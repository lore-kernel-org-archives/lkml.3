Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab3FCWTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:19:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8852 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758600Ab3FCWMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:14 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=PNvNYNo7Q9gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Ek2uqcT4szwA:10 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8 a=Op-mwl0xAAAA:8 a=vmLDa1wCAAAA:8 a=KmqCZUEVAza2QQZapJAA:9 a=9RRF0ttvEvMA:10 a=d4CUUju0HPYA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221156.134954404@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Daniel Drake <dsd@laptop.org>, Amitkumar Karwar <akarwar@marvell.com>,
        Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [23/65] mwifiex: fix memory leak issue when driver unload
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0023-mwifiex-fix-memory-leak-issue-when-driver-unload.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Amitkumar Karwar <akarwar@marvell.com>

[ Upstream commit f16fdc9d2dc1e5b270e9a08377587e831e0d36ac ]

After unregister_netdevice() call the request is queued and
reg_state is changed to NETREG_UNREGISTERING.
As we check for NETREG_UNREGISTERED state, free_netdev() never
gets executed causing memory leak.

Initialize "dev->destructor" to free_netdev() to free device
data after unregistration.

Cc: <stable@vger.kernel.org>
Reported-by: Daniel Drake <dsd@laptop.org>
Tested-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    3 ---
 drivers/net/wireless/mwifiex/main.c     |    1 +
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index b4719ea..23a6d94 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1741,9 +1741,6 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 	if (wdev->netdev->reg_state == NETREG_REGISTERED)
 		unregister_netdevice(wdev->netdev);
 
-	if (wdev->netdev->reg_state == NETREG_UNREGISTERED)
-		free_netdev(wdev->netdev);
-
 	/* Clear the priv in adapter */
 	priv->netdev = NULL;
 
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 4680362..ec830ac 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -637,6 +637,7 @@ void mwifiex_init_priv_params(struct mwifiex_private *priv,
 						struct net_device *dev)
 {
 	dev->netdev_ops = &mwifiex_netdev_ops;
+	dev->destructor = free_netdev;
 	/* Initialize private structure */
 	priv->current_key_index = 0;
 	priv->media_connected = false;
-- 
1.7.10.4


