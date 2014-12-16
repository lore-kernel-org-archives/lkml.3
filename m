Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbaLPXJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 18:09:57 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:43464 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaLPXJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 18:09:53 -0500
From: Dmitry Torokhov <dtor@chromium.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Nishanth Menon <nm@ti.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] PM / OPP: add some lockdep annotations
Date: Tue, 16 Dec 2014 15:09:36 -0800
Message-Id: <1418771379-24369-2-git-send-email-dtor@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1418771379-24369-1-git-send-email-dtor@chromium.org>
References: <1418771379-24369-1-git-send-email-dtor@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain OPP APIs need to be called under RCU lock; let's add a few
rcu_lockdep_assert() calls to warn about potential misuse.

Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
---
 drivers/base/power/opp.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index d24dd614a..b78c14d 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -108,6 +108,14 @@ static LIST_HEAD(dev_opp_list);
 /* Lock to allow exclusive modification to the device and opp lists */
 static DEFINE_MUTEX(dev_opp_list_lock);
 
+#define opp_rcu_lockdep_assert()					\
+do {									\
+	rcu_lockdep_assert(rcu_read_lock_held() ||			\
+				lockdep_is_held(&dev_opp_list_lock),	\
+			   "Missing rcu_read_lock() or "		\
+			   "dev_opp_list_lock protection");		\
+} while (0)
+
 /**
  * find_device_opp() - find device_opp struct using device pointer
  * @dev:	device pointer used to lookup device OPPs
@@ -218,6 +226,8 @@ int dev_pm_opp_get_opp_count(struct device *dev)
 	struct dev_pm_opp *temp_opp;
 	int count = 0;
 
+	opp_rcu_lockdep_assert();
+
 	dev_opp = find_device_opp(dev);
 	if (IS_ERR(dev_opp)) {
 		int r = PTR_ERR(dev_opp);
@@ -267,6 +277,8 @@ struct dev_pm_opp *dev_pm_opp_find_freq_exact(struct device *dev,
 	struct device_opp *dev_opp;
 	struct dev_pm_opp *temp_opp, *opp = ERR_PTR(-ERANGE);
 
+	opp_rcu_lockdep_assert();
+
 	dev_opp = find_device_opp(dev);
 	if (IS_ERR(dev_opp)) {
 		int r = PTR_ERR(dev_opp);
@@ -313,6 +325,8 @@ struct dev_pm_opp *dev_pm_opp_find_freq_ceil(struct device *dev,
 	struct device_opp *dev_opp;
 	struct dev_pm_opp *temp_opp, *opp = ERR_PTR(-ERANGE);
 
+	opp_rcu_lockdep_assert();
+
 	if (!dev || !freq) {
 		dev_err(dev, "%s: Invalid argument freq=%p\n", __func__, freq);
 		return ERR_PTR(-EINVAL);
@@ -361,6 +375,8 @@ struct dev_pm_opp *dev_pm_opp_find_freq_floor(struct device *dev,
 	struct device_opp *dev_opp;
 	struct dev_pm_opp *temp_opp, *opp = ERR_PTR(-ERANGE);
 
+	opp_rcu_lockdep_assert();
+
 	if (!dev || !freq) {
 		dev_err(dev, "%s: Invalid argument freq=%p\n", __func__, freq);
 		return ERR_PTR(-EINVAL);
-- 
2.2.0.rc0.207.ga3a616c

