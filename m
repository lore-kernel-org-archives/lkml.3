Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab3E1VYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:24:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59595 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112Ab3E1VXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:23:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Amitkumar Karwar <akarwar@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 25/78] mwifiex: fix memory leak issue when driver unload
Date: Tue, 28 May 2013 14:19:34 -0700
Message-Id: <1369776027-17859-26-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amitkumar Karwar <akarwar@marvell.com>

commit f16fdc9d2dc1e5b270e9a08377587e831e0d36ac upstream.

After unregister_netdevice() call the request is queued and
reg_state is changed to NETREG_UNREGISTERING.
As we check for NETREG_UNREGISTERED state, free_netdev() never
gets executed causing memory leak.

Initialize "dev->destructor" to free_netdev() to free device
data after unregistration.

Reported-by: Daniel Drake <dsd@laptop.org>
Tested-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 3 ---
 drivers/net/wireless/mwifiex/main.c     | 1 +
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 3eca710..10cb3f1 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2155,9 +2155,6 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 	if (wdev->netdev->reg_state == NETREG_REGISTERED)
 		unregister_netdevice(wdev->netdev);
 
-	if (wdev->netdev->reg_state == NETREG_UNREGISTERED)
-		free_netdev(wdev->netdev);
-
 	/* Clear the priv in adapter */
 	priv->netdev = NULL;
 
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 9c802ed..6d9bc63 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -646,6 +646,7 @@ void mwifiex_init_priv_params(struct mwifiex_private *priv,
 						struct net_device *dev)
 {
 	dev->netdev_ops = &mwifiex_netdev_ops;
+	dev->destructor = free_netdev;
 	/* Initialize private structure */
 	priv->current_key_index = 0;
 	priv->media_connected = false;
-- 
1.8.1.2

