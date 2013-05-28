Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138Ab3E1Dz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:55:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52471 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758774Ab3E1DyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:16 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Bing Zhao" <bzhao@marvell.com>,
        "Daniel Drake" <dsd@laptop.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Amitkumar Karwar" <akarwar@marvell.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.304891203@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [19/94] mwifiex: fix memory leak issue when driver unload
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: s/wdev->netdev/dev/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    3 ---
 drivers/net/wireless/mwifiex/main.c     |    1 +
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1281,9 +1281,6 @@ int mwifiex_del_virtual_intf(struct wiph
 	if (dev->reg_state == NETREG_REGISTERED)
 		unregister_netdevice(dev);
 
-	if (dev->reg_state == NETREG_UNREGISTERED)
-		free_netdev(dev);
-
 	/* Clear the priv in adapter */
 	priv->netdev = NULL;
 
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -581,6 +581,7 @@ void mwifiex_init_priv_params(struct mwi
 						struct net_device *dev)
 {
 	dev->netdev_ops = &mwifiex_netdev_ops;
+	dev->destructor = free_netdev;
 	/* Initialize private structure */
 	priv->current_key_index = 0;
 	priv->media_connected = false;

