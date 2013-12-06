Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162047Ab3LFWcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:32:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759150Ab3LFVwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 49/83] sch_tbf: handle too small burst
Date: Fri,  6 Dec 2013 13:51:39 -0800
Message-Id: <20131206214644.624538953@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4d0820cf6a55d72350cb2d24a4504f62fbde95d9 ]

If a too small burst is inadvertently set on TBF, we might trigger
a bug in tbf_segment(), as 'skb' instead of 'segs' was used in a
qdisc_reshape_fail() call.

tc qdisc add dev eth0 root handle 1: tbf latency 50ms burst 1KB rate
50mbit

Fix the bug, and add a warning, as such configuration is not
going to work anyway for non GSO packets.

(For some reason, one has to use a burst >= 1520 to get a working
configuration, even with old kernels. This is a probable iproute2/tc
bug)

Based on a report and initial patch from Yang Yingliang

Fixes: e43ac79a4bc6 ("sch_tbf: segment too big GSO packets")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_tbf.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -21,6 +21,7 @@
 #include <net/netlink.h>
 #include <net/sch_generic.h>
 #include <net/pkt_sched.h>
+#include <net/tcp.h>
 
 
 /*	Simple Token Bucket Filter.
@@ -117,6 +118,22 @@ struct tbf_sched_data {
 };
 
 
+/*
+ * Return length of individual segments of a gso packet,
+ * including all headers (MAC, IP, TCP/UDP)
+ */
+static unsigned int skb_gso_seglen(const struct sk_buff *skb)
+{
+	unsigned int hdr_len = skb_transport_header(skb) - skb_mac_header(skb);
+	const struct skb_shared_info *shinfo = skb_shinfo(skb);
+
+	if (likely(shinfo->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6)))
+		hdr_len += tcp_hdrlen(skb);
+	else
+		hdr_len += sizeof(struct udphdr);
+	return hdr_len + shinfo->gso_size;
+}
+
 /* GSO packet is too big, segment it so that tbf can transmit
  * each segment in time
  */
@@ -136,12 +153,8 @@ static int tbf_segment(struct sk_buff *s
 	while (segs) {
 		nskb = segs->next;
 		segs->next = NULL;
-		if (likely(segs->len <= q->max_size)) {
-			qdisc_skb_cb(segs)->pkt_len = segs->len;
-			ret = qdisc_enqueue(segs, q->qdisc);
-		} else {
-			ret = qdisc_reshape_fail(skb, sch);
-		}
+		qdisc_skb_cb(segs)->pkt_len = segs->len;
+		ret = qdisc_enqueue(segs, q->qdisc);
 		if (ret != NET_XMIT_SUCCESS) {
 			if (net_xmit_drop_count(ret))
 				sch->qstats.drops++;
@@ -163,7 +176,7 @@ static int tbf_enqueue(struct sk_buff *s
 	int ret;
 
 	if (qdisc_pkt_len(skb) > q->max_size) {
-		if (skb_is_gso(skb))
+		if (skb_is_gso(skb) && skb_gso_seglen(skb) <= q->max_size)
 			return tbf_segment(skb, sch);
 		return qdisc_reshape_fail(skb, sch);
 	}
@@ -316,6 +329,11 @@ static int tbf_change(struct Qdisc *sch,
 	if (max_size < 0)
 		goto done;
 
+	if (max_size < psched_mtu(qdisc_dev(sch)))
+		pr_warn_ratelimited("sch_tbf: burst %u is lower than device %s mtu (%u) !\n",
+				    max_size, qdisc_dev(sch)->name,
+				    psched_mtu(qdisc_dev(sch)));
+
 	if (q->qdisc != &noop_qdisc) {
 		err = fifo_set_limit(q->qdisc, qopt->limit);
 		if (err)


