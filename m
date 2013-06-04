Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab3FDOSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:18:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46842 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073Ab3FDOIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:08:21 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Amitkumar Karwar <akarwar@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 40/70] mwifiex: fix memory leak issue when driver unload
Date: Tue,  4 Jun 2013 15:06:56 +0100
Message-Id: <1370354846-14213-41-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backport to 3.5:
  - adjust context: use dev instead of wdev->netdev ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 3 ---
 drivers/net/wireless/mwifiex/main.c     | 1 +
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 4506cda..3a5b73f 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1622,9 +1622,6 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct net_device *dev)
 	if (dev->reg_state == NETREG_REGISTERED)
 		unregister_netdevice(dev);
 
-	if (dev->reg_state == NETREG_UNREGISTERED)
-		free_netdev(dev);
-
 	/* Clear the priv in adapter */
 	priv->netdev = NULL;
 
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 3192855..4be4d43 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -636,6 +636,7 @@ void mwifiex_init_priv_params(struct mwifiex_private *priv,
 						struct net_device *dev)
 {
 	dev->netdev_ops = &mwifiex_netdev_ops;
+	dev->destructor = free_netdev;
 	/* Initialize private structure */
 	priv->current_key_index = 0;
 	priv->media_connected = false;
-- 
1.8.1.2

