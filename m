Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964974Ab3GCSo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:44:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15217 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933307Ab3GCSlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:41:11 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=0AGUK1kApKMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=N-MqokAVo1UA:10 a=tHz9FfFoAAAA:8 a=J1Y8HTJGAAAA:8 a=4j3QpNj4R4kVnKEf9boA:9 a=6O0IECtVFhoA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=NIB_dgPIuevQmd4U:21 a=cuDhcSZXU2aKHP74:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184055.414123709@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [065/141] xen-netback: better names for thresholds
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0065-xen-netback-better-names-for-thresholds.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu2@citrix.com>

[ Upstream commit 376414945d15aa636e65f7e773c1e398b7a21cb9 ]

This patch only changes some names to avoid confusion.

In this patch we have:

  MAX_SKB_SLOTS_DEFAULT -> FATAL_SKB_SLOTS_DEFAULT
  max_skb_slots -> fatal_skb_slots
  #define XEN_NETBK_LEGACY_SLOTS_MAX XEN_NETIF_NR_SLOTS_MIN

The fatal_skb_slots is the threshold to determine whether a packet is
malicious.

XEN_NETBK_LEGACY_SLOTS_MAX is the maximum slots a valid packet can have at
this point. It is defined to be XEN_NETIF_NR_SLOTS_MIN because that's
guaranteed to be supported by all backends.

Suggested-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/xen-netback/netback.c |   49 ++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 4925188..9084f8e 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -50,9 +50,17 @@
  * This is the maximum slots a skb can have. If a guest sends a skb
  * which exceeds this limit it is considered malicious.
  */
-#define MAX_SKB_SLOTS_DEFAULT 20
-static unsigned int max_skb_slots = MAX_SKB_SLOTS_DEFAULT;
-module_param(max_skb_slots, uint, 0444);
+#define FATAL_SKB_SLOTS_DEFAULT 20
+static unsigned int fatal_skb_slots = FATAL_SKB_SLOTS_DEFAULT;
+module_param(fatal_skb_slots, uint, 0444);
+
+/*
+ * To avoid confusion, we define XEN_NETBK_LEGACY_SLOTS_MAX indicating
+ * the maximum slots a valid packet can use. Now this value is defined
+ * to be XEN_NETIF_NR_SLOTS_MIN, which is supposed to be supported by
+ * all backend.
+ */
+#define XEN_NETBK_LEGACY_SLOTS_MAX XEN_NETIF_NR_SLOTS_MIN
 
 typedef unsigned int pending_ring_idx_t;
 #define INVALID_PENDING_RING_IDX (~0U)
@@ -924,25 +932,26 @@ static int netbk_count_requests(struct xenvif *vif,
 		/* This guest is really using too many slots and
 		 * considered malicious.
 		 */
-		if (unlikely(slots >= max_skb_slots)) {
+		if (unlikely(slots >= fatal_skb_slots)) {
 			netdev_err(vif->dev,
 				   "Malicious frontend using %d slots, threshold %u\n",
-				   slots, max_skb_slots);
+				   slots, fatal_skb_slots);
 			netbk_fatal_tx_err(vif);
 			return -E2BIG;
 		}
 
 		/* Xen network protocol had implicit dependency on
-		 * MAX_SKB_FRAGS. XEN_NETIF_NR_SLOTS_MIN is set to the
-		 * historical MAX_SKB_FRAGS value 18 to honor the same
-		 * behavior as before. Any packet using more than 18
-		 * slots but less than max_skb_slots slots is dropped
+		 * MAX_SKB_FRAGS. XEN_NETBK_LEGACY_SLOTS_MAX is set to
+		 * the historical MAX_SKB_FRAGS value 18 to honor the
+		 * same behavior as before. Any packet using more than
+		 * 18 slots but less than fatal_skb_slots slots is
+		 * dropped
 		 */
-		if (!drop_err && slots >= XEN_NETIF_NR_SLOTS_MIN) {
+		if (!drop_err && slots >= XEN_NETBK_LEGACY_SLOTS_MAX) {
 			if (net_ratelimit())
 				netdev_dbg(vif->dev,
 					   "Too many slots (%d) exceeding limit (%d), dropping packet\n",
-					   slots, XEN_NETIF_NR_SLOTS_MIN);
+					   slots, XEN_NETBK_LEGACY_SLOTS_MAX);
 			drop_err = -E2BIG;
 		}
 
@@ -1024,7 +1033,7 @@ static struct gnttab_copy *xen_netbk_get_requests(struct xen_netbk *netbk,
 	struct pending_tx_info *first = NULL;
 
 	/* At this point shinfo->nr_frags is in fact the number of
-	 * slots, which can be as large as XEN_NETIF_NR_SLOTS_MIN.
+	 * slots, which can be as large as XEN_NETBK_LEGACY_SLOTS_MAX.
 	 */
 	nr_slots = shinfo->nr_frags;
 
@@ -1391,12 +1400,12 @@ static unsigned xen_netbk_tx_build_gops(struct xen_netbk *netbk)
 	struct sk_buff *skb;
 	int ret;
 
-	while ((nr_pending_reqs(netbk) + XEN_NETIF_NR_SLOTS_MIN
+	while ((nr_pending_reqs(netbk) + XEN_NETBK_LEGACY_SLOTS_MAX
 		< MAX_PENDING_REQS) &&
 		!list_empty(&netbk->net_schedule_list)) {
 		struct xenvif *vif;
 		struct xen_netif_tx_request txreq;
-		struct xen_netif_tx_request txfrags[XEN_NETIF_NR_SLOTS_MIN];
+		struct xen_netif_tx_request txfrags[XEN_NETBK_LEGACY_SLOTS_MAX];
 		struct page *page;
 		struct xen_netif_extra_info extras[XEN_NETIF_EXTRA_TYPE_MAX-1];
 		u16 pending_idx;
@@ -1484,7 +1493,7 @@ static unsigned xen_netbk_tx_build_gops(struct xen_netbk *netbk)
 		pending_idx = netbk->pending_ring[index];
 
 		data_len = (txreq.size > PKT_PROT_LEN &&
-			    ret < XEN_NETIF_NR_SLOTS_MIN) ?
+			    ret < XEN_NETBK_LEGACY_SLOTS_MAX) ?
 			PKT_PROT_LEN : txreq.size;
 
 		skb = alloc_skb(data_len + NET_SKB_PAD + NET_IP_ALIGN,
@@ -1763,7 +1772,7 @@ static inline int rx_work_todo(struct xen_netbk *netbk)
 static inline int tx_work_todo(struct xen_netbk *netbk)
 {
 
-	if ((nr_pending_reqs(netbk) + XEN_NETIF_NR_SLOTS_MIN
+	if ((nr_pending_reqs(netbk) + XEN_NETBK_LEGACY_SLOTS_MAX
 	     < MAX_PENDING_REQS) &&
 	     !list_empty(&netbk->net_schedule_list))
 		return 1;
@@ -1848,11 +1857,11 @@ static int __init netback_init(void)
 	if (!xen_domain())
 		return -ENODEV;
 
-	if (max_skb_slots < XEN_NETIF_NR_SLOTS_MIN) {
+	if (fatal_skb_slots < XEN_NETBK_LEGACY_SLOTS_MAX) {
 		printk(KERN_INFO
-		       "xen-netback: max_skb_slots too small (%d), bump it to XEN_NETIF_NR_SLOTS_MIN (%d)\n",
-		       max_skb_slots, XEN_NETIF_NR_SLOTS_MIN);
-		max_skb_slots = XEN_NETIF_NR_SLOTS_MIN;
+		       "xen-netback: fatal_skb_slots too small (%d), bump it to XEN_NETBK_LEGACY_SLOTS_MAX (%d)\n",
+		       fatal_skb_slots, XEN_NETBK_LEGACY_SLOTS_MAX);
+		fatal_skb_slots = XEN_NETBK_LEGACY_SLOTS_MAX;
 	}
 
 	xen_netbk_group_nr = num_online_cpus();
-- 
1.7.10.4


