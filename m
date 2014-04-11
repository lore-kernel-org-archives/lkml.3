Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423110AbaDKQR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:17:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56754 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759708AbaDKQJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:09:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwin@etorok.net>,
        Wei Liu <wei.liu2@citrix.com>, Ian Campbell <ian.campbell@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 11/23] xen-netback: disable rogue vif in kthread context
Date: Fri, 11 Apr 2014 09:12:00 -0700
Message-Id: <20140411161201.785355821@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411161200.236939691@linuxfoundation.org>
References: <20140411161200.236939691@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu2@citrix.com>

[ Upstream commit e9d8b2c2968499c1f96563e6522c56958d5a1d0d ]

When netback discovers frontend is sending malformed packet it will
disables the interface which serves that frontend.

However disabling a network interface involving taking a mutex which
cannot be done in softirq context, so we need to defer this process to
kthread context.

This patch does the following:
1. introduce a flag to indicate the interface is disabled.
2. check that flag in TX path, don't do any work if it's true.
3. check that flag in RX path, turn off that interface if it's true.

The reason to disable it in RX path is because RX uses kthread. After
this change the behavior of netback is still consistent -- it won't do
any TX work for a rogue frontend, and the interface will be eventually
turned off.

Also change a "continue" to "break" after xenvif_fatal_tx_err, as it
doesn't make sense to continue processing packets if frontend is rogue.

This is a fix for XSA-90.

Reported-by: Török Edwin <edwin@etorok.net>
Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Cc: Ian Campbell <ian.campbell@citrix.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/common.h    |    5 +++++
 drivers/net/xen-netback/interface.c |   11 +++++++++++
 drivers/net/xen-netback/netback.c   |   16 ++++++++++++++--
 3 files changed, 30 insertions(+), 2 deletions(-)

--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -113,6 +113,11 @@ struct xenvif {
 	domid_t          domid;
 	unsigned int     handle;
 
+	/* Is this interface disabled? True when backend discovers
+	 * frontend is rogue.
+	 */
+	bool disabled;
+
 	/* Use NAPI for guest TX */
 	struct napi_struct napi;
 	/* When feature-split-event-channels = 0, tx_irq = rx_irq. */
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -62,6 +62,15 @@ static int xenvif_poll(struct napi_struc
 	struct xenvif *vif = container_of(napi, struct xenvif, napi);
 	int work_done;
 
+	/* This vif is rogue, we pretend we've there is nothing to do
+	 * for this vif to deschedule it from NAPI. But this interface
+	 * will be turned off in thread context later.
+	 */
+	if (unlikely(vif->disabled)) {
+		napi_complete(napi);
+		return 0;
+	}
+
 	work_done = xenvif_tx_action(vif, budget);
 
 	if (work_done < budget) {
@@ -321,6 +330,8 @@ struct xenvif *xenvif_alloc(struct devic
 	vif->ip_csum = 1;
 	vif->dev = dev;
 
+	vif->disabled = false;
+
 	vif->credit_bytes = vif->remaining_credit = ~0UL;
 	vif->credit_usec  = 0UL;
 	init_timer(&vif->credit_timeout);
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -680,7 +680,8 @@ static void xenvif_tx_err(struct xenvif
 static void xenvif_fatal_tx_err(struct xenvif *vif)
 {
 	netdev_err(vif->dev, "fatal error; disabling device\n");
-	xenvif_carrier_off(vif);
+	vif->disabled = true;
+	xenvif_kick_thread(vif);
 }
 
 static int xenvif_count_requests(struct xenvif *vif,
@@ -1151,7 +1152,7 @@ static unsigned xenvif_tx_build_gops(str
 				   vif->tx.sring->req_prod, vif->tx.req_cons,
 				   XEN_NETIF_TX_RING_SIZE);
 			xenvif_fatal_tx_err(vif);
-			continue;
+			break;
 		}
 
 		work_to_do = RING_HAS_UNCONSUMED_REQUESTS(&vif->tx);
@@ -1573,7 +1574,18 @@ int xenvif_kthread(void *data)
 	while (!kthread_should_stop()) {
 		wait_event_interruptible(vif->wq,
 					 rx_work_todo(vif) ||
+					 vif->disabled ||
 					 kthread_should_stop());
+
+		/* This frontend is found to be rogue, disable it in
+		 * kthread context. Currently this is only set when
+		 * netback finds out frontend sends malformed packet,
+		 * but we cannot disable the interface in softirq
+		 * context so we defer it here.
+		 */
+		if (unlikely(vif->disabled && netif_carrier_ok(vif->dev)))
+			xenvif_carrier_off(vif);
+
 		if (kthread_should_stop())
 			break;
 


