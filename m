Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab3KYNWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:22:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57133 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab3KYNIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:08:01 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Liu <wei.liu2@citrix.com>, Ian Campbell <ian.campbell@citrix.com>,
        Jason Luan <jianhai.luan@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 35/78] xen-netback: use jiffies_64 value to calculate credit timeout
Date: Mon, 25 Nov 2013 13:06:22 +0000
Message-Id: <1385384825-21681-36-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu2@citrix.com>

commit 059dfa6a93b779516321e5112db9d7621b1367ba upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/xen-netback/common.h    |  1 +
 drivers/net/xen-netback/interface.c |  3 +--
 drivers/net/xen-netback/netback.c   | 10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 9d7f172..093bf0a 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -88,6 +88,7 @@ struct xenvif {
 	unsigned long   credit_usec;
 	unsigned long   remaining_credit;
 	struct timer_list credit_timeout;
+	u64 credit_window_start;
 
 	/* Statistics */
 	unsigned long rx_gso_checksum_fixup;
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index 221f426..cfaaf68 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -273,8 +273,7 @@ struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
 	vif->credit_bytes = vif->remaining_credit = ~0UL;
 	vif->credit_usec  = 0UL;
 	init_timer(&vif->credit_timeout);
-	/* Initialize 'expires' now: it's used to track the credit window. */
-	vif->credit_timeout.expires = jiffies;
+	vif->credit_window_start = get_jiffies_64();
 
 	dev->netdev_ops	= &xenvif_netdev_ops;
 	dev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO;
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 228607b..3d0f22a 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1364,9 +1364,8 @@ out:
 
 static bool tx_credit_exceeded(struct xenvif *vif, unsigned size)
 {
-	unsigned long now = jiffies;
-	unsigned long next_credit =
-		vif->credit_timeout.expires +
+	u64 now = get_jiffies_64();
+	u64 next_credit = vif->credit_window_start +
 		msecs_to_jiffies(vif->credit_usec / 1000);
 
 	/* Timer could already be pending in rare cases. */
@@ -1374,8 +1373,8 @@ static bool tx_credit_exceeded(struct xenvif *vif, unsigned size)
 		return true;
 
 	/* Passed the point where we can replenish credit? */
-	if (time_after_eq(now, next_credit)) {
-		vif->credit_timeout.expires = now;
+	if (time_after_eq64(now, next_credit)) {
+		vif->credit_window_start = now;
 		tx_add_credit(vif);
 	}
 
@@ -1387,6 +1386,7 @@ static bool tx_credit_exceeded(struct xenvif *vif, unsigned size)
 			tx_credit_callback;
 		mod_timer(&vif->credit_timeout,
 			  next_credit);
+		vif->credit_window_start = next_credit;
 
 		return true;
 	}
-- 
1.8.3.2

