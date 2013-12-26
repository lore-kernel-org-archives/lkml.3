Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab3LZQsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 11:48:16 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49143 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526Ab3LZQrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 11:47:37 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>
Subject: [PATCH 2/4] phy: phy-core: increment refcounting variables only on 'success'
Date: Thu, 26 Dec 2013 22:17:18 +0530
Message-ID: <1388076440-7620-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1388076440-7620-1-git-send-email-kishon@ti.com>
References: <1388076440-7620-1-git-send-email-kishon@ti.com>
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
 drivers/phy/phy-core.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 8797bb7..33fcbcc 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -167,13 +167,14 @@ int phy_init(struct phy *phy)
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
@@ -191,13 +192,14 @@ int phy_exit(struct phy *phy)
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
@@ -215,16 +217,20 @@ int phy_power_on(struct phy *phy)
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
@@ -235,19 +241,19 @@ int phy_power_off(struct phy *phy)
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

