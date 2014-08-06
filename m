Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbaHFST5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:19:57 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:37492 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647AbaHFSRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:17:04 -0400
X-IronPort-AV: E=Sophos;i="5.01,813,1400025600"; 
   d="scan'208";a="160023728"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: Wei Liu <wei.liu2@citrix.com>, Ian Campbell <Ian.Campbell@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: [PATCH] xen-netback: Change disable flag from bool to a bit
Date: Wed, 6 Aug 2014 19:16:13 +0100
Message-ID: <1407348973-2433-5-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407348973-2433-1-git-send-email-zoltan.kiss@citrix.com>
References: <1407348973-2433-1-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xenproject.org 

diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 5cb139a..f126920 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -106,7 +106,11 @@ enum vif_state_bit_shift {
 	/* This bit signals to the RX thread that queuing was stopped
 	 * (in start_xmit), and either the timer fired or an RX interrupt came
 	 */
-	VIF_STATUS_RX_PURGE_EVENT
+	VIF_STATUS_RX_PURGE_EVENT,
+	/* Is this interface disabled? True when backend discovers
+	 * frontend is rogue.
+	 */
+	VIF_STATUS_DISABLED
 };
 
 struct xenvif {
@@ -114,10 +118,6 @@ struct xenvif {
 	domid_t          domid;
 	unsigned int     handle;
 
-	/* Is this interface disabled? True when backend discovers
-	 * frontend is rogue.
-	 */
-	bool disabled;
 	unsigned long status;
 
 	/* Use NAPI for guest TX */
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index e396d86..92e397c 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -70,7 +70,7 @@ static int xenvif_poll(struct napi_struct *napi, int budget)
 	 * We also turn off NAPI if the receive queue is stalled and the carrier
 	 * is turned off.
 	 */
-	if (unlikely(vif->disabled ||
+	if (unlikely(test_bit(VIF_STATUS_DISABLED, &vif->status) ||
 		     !netif_carrier_ok(vif->dev))) {
 		napi_complete(napi);
 		return 0;
@@ -352,8 +352,6 @@ struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
 	vif->ip_csum = 1;
 	vif->dev = dev;
 
-	vif->disabled = false;
-
 	vif->credit_bytes = vif->remaining_credit = ~0UL;
 	vif->credit_usec  = 0UL;
 	init_timer(&vif->credit_timeout);
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 0737597..8b75b41 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -787,7 +787,7 @@ static void xenvif_tx_err(struct xenvif *vif,
 static void xenvif_fatal_tx_err(struct xenvif *vif)
 {
 	netdev_err(vif->dev, "fatal error; disabling device\n");
-	vif->disabled = true;
+	set_bit(VIF_STATUS_DISABLED, &vif->status);
 	xenvif_kick_thread(vif);
 }
 
@@ -1936,7 +1936,7 @@ int xenvif_kthread_guest_rx(void *data)
 	while (!kthread_should_stop()) {
 		wait_event_interruptible(vif->wq,
 					 rx_work_todo(vif) ||
-					 vif->disabled ||
+					 test_bit(VIF_STATUS_DISABLED, &vif->status) ||
 					 test_bit(VIF_STATUS_RX_PURGE_EVENT, &vif->status) ||
 					 kthread_should_stop());
 
@@ -1946,7 +1946,7 @@ int xenvif_kthread_guest_rx(void *data)
 		 * but we cannot disable the interface in softirq
 		 * context so we defer it here.
 		 */
-		if (unlikely(vif->disabled))
+		if (unlikely(test_and_clear_bit(VIF_STATUS_DISABLED, &vif->status)))
 			xenvif_carrier_off(vif);
 		else if (unlikely(test_and_clear_bit(VIF_STATUS_RX_PURGE_EVENT,
 						     &vif->status))) {
