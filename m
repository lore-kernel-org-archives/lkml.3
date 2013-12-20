Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325Ab3LTFHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 00:07:09 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:52637 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab3LTFHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 00:07:08 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <kishon@ti.com>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <s.nawrocki@samsung.com>, <jg1.han@samsung.com>, <mporter@linaro.org>,
        <andrew@lunn.ch>, <k.debski@samsung.com>, <gautamvivek1987@gmail.com>,
        <heikki.krogerus@linux.intel.com>, <yuvaraj.cd@gmail.com>,
        <george.cherian@ti.com>
Subject: [PATCH v2 1/2] phy: phy-core: increment refcounting variables only on 'success'
Date: Fri, 20 Dec 2013 10:36:49 +0530
Message-ID: <1387516009-12804-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387463504-4415-1-git-send-email-kishon@ti.com>
References: <1387463504-4415-1-git-send-email-kishon@ti.com>
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

Reported-by: George Cherian <george.cherian@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
Changes from v1:
Fixed power_off to call phy_pm_runtime_put only when there is no error in
power_off callback

 drivers/phy/phy-core.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 03cf8fb..27b8f3f 100644
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
@@ -223,19 +229,19 @@ int phy_power_off(struct phy *phy)
 	int ret = -ENOTSUPP;
 
 	mutex_lock(&phy->mutex);
-	if (--phy->power_count == 0 && phy->ops->power_off) {
+	if (phy->power_count == 1 && phy->ops->power_off) {
 		ret =  phy->ops->power_off(phy);
 		if (ret < 0) {
 			dev_err(&phy->dev, "phy poweroff failed --> %d\n", ret);
-			goto out;
+			mutex_unlock(&phy->mutex);
+			return ret;
 		}
 	}
-
-out:
+	--phy->power_count;
 	mutex_unlock(&phy->mutex);
 	phy_pm_runtime_put(phy);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(phy_power_off);
 
-- 
1.7.10.4

