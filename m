Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab3LSM7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:59:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44616 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab3LSL41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:56:27 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 047/208] sch_tbf: handle too small burst
Date: Thu, 19 Dec 2013 11:52:25 +0000
Message-Id: <1387454106-19326-48-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 4d0820cf6a55d72350cb2d24a4504f62fbde95d9 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/sched/sch_tbf.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 1aaf1b6..6ddda28 100644
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
@@ -136,12 +153,8 @@ static int tbf_segment(struct sk_buff *skb, struct Qdisc *sch)
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
@@ -163,7 +176,7 @@ static int tbf_enqueue(struct sk_buff *skb, struct Qdisc *sch)
 	int ret;
 
 	if (qdisc_pkt_len(skb) > q->max_size) {
-		if (skb_is_gso(skb))
+		if (skb_is_gso(skb) && skb_gso_seglen(skb) <= q->max_size)
 			return tbf_segment(skb, sch);
 		return qdisc_reshape_fail(skb, sch);
 	}
@@ -316,6 +329,11 @@ static int tbf_change(struct Qdisc *sch, struct nlattr *opt)
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
-- 
1.8.3.2

