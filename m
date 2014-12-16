Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaLPXJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 18:09:58 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:61671 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaLPXJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 18:09:54 -0500
From: Dmitry Torokhov <dtor@chromium.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Nishanth Menon <nm@ti.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] PM / OPP: fix warning in of_free_opp_table
Date: Tue, 16 Dec 2014 15:09:37 -0800
Message-Id: <1418771379-24369-3-git-send-email-dtor@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1418771379-24369-1-git-send-email-dtor@chromium.org>
References: <1418771379-24369-1-git-send-email-dtor@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not having OPP defined for a device is not a crime, we should not splat
warning in this case. Also, it seems that we are ready to accept invalid
dev (find_device_opp will return ERR_PTR(-EINVAL) then) so let's not
crash in dev_name() in such case.

Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
---
 drivers/base/power/opp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index b78c14d..413c7fe 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -799,9 +799,15 @@ void of_free_opp_table(struct device *dev)
 
 	/* Check for existing list for 'dev' */
 	dev_opp = find_device_opp(dev);
-	if (WARN(IS_ERR(dev_opp), "%s: dev_opp: %ld\n", dev_name(dev),
-		 PTR_ERR(dev_opp)))
+	if (IS_ERR(dev_opp)) {
+		int error = PTR_ERR(dev_opp);
+		if (error != -ENODEV)
+			WARN(1, "%s: dev_opp: %ld\n",
+			     IS_ERR_OR_NULL(dev) ?
+					"Invalid device" : dev_name(dev),
+			     error);
 		return;
+	}
 
 	/* Hold our list modification lock here */
 	mutex_lock(&dev_opp_list_lock);
-- 
2.2.0.rc0.207.ga3a616c

