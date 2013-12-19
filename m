Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab3LSOcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:32:12 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:45507 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab3LSOcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:32:11 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <kishon@ti.com>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <s.nawrocki@samsung.com>, <jg1.han@samsung.com>, <mporter@linaro.org>,
        <andrew@lunn.ch>, <k.debski@samsung.com>, <gautamvivek1987@gmail.com>,
        <heikki.krogerus@linux.intel.com>, <yuvaraj.cd@gmail.com>
Subject: [PATCH 1/2] phy: phy-core: increment refcounting variables only on 'success'
Date: Thu, 19 Dec 2013 20:01:43 +0530
Message-ID: <1387463504-4415-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increment 'init_count' only if the 'init' callback succeeded and decrement
'init_count' only if the 'exit' callback succeded. Increment 'power_count'
only if 'power_on' callback succeded and if it failed disable the clocks using
phy_pm_runtime_put_sync(). Also decrement 'power_count' only if 'power_off'
callback succeded and if it failed do not disable the clocks.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-core.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 03cf8fb..e198259 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -155,13 +155,14 @@ int phy_init(struct phy *phy)
 		return ret;
 
 	mutex_lock(&phy->mutex);
-	if (phy->init_count++ == 0 && phy->ops->init) {
+	if (phy->init_count == 0 && phy->ops->init) {
 		ret = phy->ops->init(phy);
 		if (ret < 0) {
 			dev_err(&phy->dev, "phy init failed --> %d\n", ret);
 			goto out;
 		}
 	}
+	++phy->init_count;
 
 out:
 	mutex_unlock(&phy->mutex);
@@ -179,13 +180,14 @@ int phy_exit(struct phy *phy)
 		return ret;
 
 	mutex_lock(&phy->mutex);
-	if (--phy->init_count == 0 && phy->ops->exit) {
+	if (phy->init_count == 1 && phy->ops->exit) {
 		ret = phy->ops->exit(phy);
 		if (ret < 0) {
 			dev_err(&phy->dev, "phy exit failed --> %d\n", ret);
 			goto out;
 		}
 	}
+	--phy->init_count;
 
 out:
 	mutex_unlock(&phy->mutex);
@@ -203,16 +205,20 @@ int phy_power_on(struct phy *phy)
 		return ret;
 
 	mutex_lock(&phy->mutex);
-	if (phy->power_count++ == 0 && phy->ops->power_on) {
+	if (phy->power_count == 0 && phy->ops->power_on) {
 		ret = phy->ops->power_on(phy);
 		if (ret < 0) {
 			dev_err(&phy->dev, "phy poweron failed --> %d\n", ret);
 			goto out;
 		}
 	}
+	++phy->power_count;
+	mutex_unlock(&phy->mutex);
+	return 0;
 
 out:
 	mutex_unlock(&phy->mutex);
+	phy_pm_runtime_put_sync(phy);
 
 	return ret;
 }
@@ -223,13 +229,16 @@ int phy_power_off(struct phy *phy)
 	int ret = -ENOTSUPP;
 
 	mutex_lock(&phy->mutex);
-	if (--phy->power_count == 0 && phy->ops->power_off) {
+	if (phy->power_count == 1 && phy->ops->power_off) {
 		ret =  phy->ops->power_off(phy);
 		if (ret < 0) {
 			dev_err(&phy->dev, "phy poweroff failed --> %d\n", ret);
 			goto out;
 		}
 	}
+	--phy->power_count;
+	mutex_unlock(&phy->mutex);
+	return 0;
 
 out:
 	mutex_unlock(&phy->mutex);
-- 
1.7.10.4

