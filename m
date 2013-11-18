Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab3KRSh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:37:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab3KRSh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:37:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Beulich <jbeulich@suse.com>, Wei Liu <wei.liu2@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Jason Luan <jianhai.luan@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 05/19] xen-netback: use jiffies_64 value to calculate credit timeout
Date: Mon, 18 Nov 2013 10:37:18 -0800
Message-Id: <20131118183645.605840953@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118183644.030738675@linuxfoundation.org>
References: <20131118183644.030738675@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu2@citrix.com>

[ Upstream commit 059dfa6a93b779516321e5112db9d7621b1367ba ]

time_after_eq() only works if the delta is < MAX_ULONG/2.

For a 32bit Dom0, if netfront sends packets at a very low rate, the time
between subsequent calls to tx_credit_exceeded() may exceed MAX_ULONG/2
and the test for timer_after_eq() will be incorrect. Credit will not be
replenished and the guest may become unable to send packets (e.g., if
prior to the long gap, all credit was exhausted).

Use jiffies_64 variant to mitigate this problem for 32bit Dom0.

Suggested-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: Jason Luan <jianhai.luan@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/common.h    |    1 +
 drivers/net/xen-netback/interface.c |    3 +--
 drivers/net/xen-netback/netback.c   |   10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -163,6 +163,7 @@ struct xenvif {
 	unsigned long   credit_usec;
 	unsigned long   remaining_credit;
 	struct timer_list credit_timeout;
+	u64 credit_window_start;
 
 	/* Statistics */
 	unsigned long rx_gso_checksum_fixup;
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -312,8 +312,7 @@ struct xenvif *xenvif_alloc(struct devic
 	vif->credit_bytes = vif->remaining_credit = ~0UL;
 	vif->credit_usec  = 0UL;
 	init_timer(&vif->credit_timeout);
-	/* Initialize 'expires' now: it's used to track the credit window. */
-	vif->credit_timeout.expires = jiffies;
+	vif->credit_window_start = get_jiffies_64();
 
 	dev->netdev_ops	= &xenvif_netdev_ops;
 	dev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO;
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1185,9 +1185,8 @@ out:
 
 static bool tx_credit_exceeded(struct xenvif *vif, unsigned size)
 {
-	unsigned long now = jiffies;
-	unsigned long next_credit =
-		vif->credit_timeout.expires +
+	u64 now = get_jiffies_64();
+	u64 next_credit = vif->credit_window_start +
 		msecs_to_jiffies(vif->credit_usec / 1000);
 
 	/* Timer could already be pending in rare cases. */
@@ -1195,8 +1194,8 @@ static bool tx_credit_exceeded(struct xe
 		return true;
 
 	/* Passed the point where we can replenish credit? */
-	if (time_after_eq(now, next_credit)) {
-		vif->credit_timeout.expires = now;
+	if (time_after_eq64(now, next_credit)) {
+		vif->credit_window_start = now;
 		tx_add_credit(vif);
 	}
 
@@ -1208,6 +1207,7 @@ static bool tx_credit_exceeded(struct xe
 			tx_credit_callback;
 		mod_timer(&vif->credit_timeout,
 			  next_credit);
+		vif->credit_window_start = next_credit;
 
 		return true;
 	}


