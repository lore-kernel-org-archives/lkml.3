Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab3BCOzO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:55:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34122 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753770Ab3BCOzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:06 -0500
Message-Id: <20130203144645.362991019@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:46:59 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Amitkumar Karwar <akarwar@marvell.com>,
        Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 015/128] mwifiex: handle association failure case correctly
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amitkumar Karwar <akarwar@marvell.com>

commit b7097eb75fa11c302dcdec83f1dbfa874e0af0d1 upstream.

Currently even if association is failed "iw link" shows some
information about connected BSS and "Tx timeout" error is seen in
dmesg log.

This patch fixes below issues in the code to handle assoc failure
case correctly.
1) "status" variable in mwifiex_wait_queue_complete() is not
correctly updated. Hence driver doesn't inform cfg80211 stack
about association failure.
2) During association network queues are stopped but carrier is
not cleared, which gives Tx timeout error in failure case

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 470ca75..b0fbf5d 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -54,7 +54,7 @@ int mwifiex_copy_mcast_addr(struct mwifiex_multicast_list *mlist,
 int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter)
 {
 	bool cancel_flag = false;
-	int status = adapter->cmd_wait_q.status;
+	int status;
 	struct cmd_ctrl_node *cmd_queued;
 
 	if (!adapter->cmd_queued)
@@ -79,6 +79,8 @@ int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter)
 		mwifiex_cancel_pending_ioctl(adapter);
 		dev_dbg(adapter->dev, "cmd cancel\n");
 	}
+
+	status = adapter->cmd_wait_q.status;
 	adapter->cmd_wait_q.status = 0;
 
 	return status;
@@ -240,6 +242,8 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 
 		if (!netif_queue_stopped(priv->netdev))
 			mwifiex_stop_net_dev_queue(priv->netdev, adapter);
+		if (netif_carrier_ok(priv->netdev))
+			netif_carrier_off(priv->netdev);
 
 		/* Clear any past association response stored for
 		 * application retrieval */
@@ -271,6 +275,8 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 
 		if (!netif_queue_stopped(priv->netdev))
 			mwifiex_stop_net_dev_queue(priv->netdev, adapter);
+		if (netif_carrier_ok(priv->netdev))
+			netif_carrier_off(priv->netdev);
 
 		if (!ret) {
 			dev_dbg(adapter->dev, "info: network found in scan"


