Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3FDWwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:52:50 -0400
Received: from 1wt.eu ([62.212.114.60]:35825 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890Ab3FDWn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:58 -0400
Message-Id: <20130604172137.312595309@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:24:19 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 169/184] netfilter: nf_ct_ipv4: packets with wrong ihl are
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 invalid

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

commit 07153c6ec074257ade76a461429b567cff2b3a1e upstream.

It was reported that the Linux kernel sometimes logs:

klogd: [2629147.402413] kernel BUG at net / netfilter /
nf_conntrack_proto_tcp.c: 447!
klogd: [1072212.887368] kernel BUG at net / netfilter /
nf_conntrack_proto_tcp.c: 392

ipv4_get_l4proto() in nf_conntrack_l3proto_ipv4.c and tcp_error() in
nf_conntrack_proto_tcp.c should catch malformed packets, so the errors
at the indicated lines - TCP options parsing - should not happen.
However, tcp_error() relies on the "dataoff" offset to the TCP header,
calculated by ipv4_get_l4proto().  But ipv4_get_l4proto() does not check
bogus ihl values in IPv4 packets, which then can slip through tcp_error()
and get caught at the TCP options parsing routines.

The patch fixes ipv4_get_l4proto() by invalidating packets with bogus
ihl value.

The patch closes netfilter bugzilla id 771.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: David Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 1032a15..c6437d5 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -83,6 +83,14 @@ static int ipv4_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 	*dataoff = nhoff + (iph->ihl << 2);
 	*protonum = iph->protocol;
 
+	/* Check bogus IP headers */
+	if (*dataoff > skb->len) {
+		pr_debug("nf_conntrack_ipv4: bogus IPv4 packet: "
+			 "nhoff %u, ihl %u, skblen %u\n",
+			 nhoff, iph->ihl << 2, skb->len);
+		return -NF_ACCEPT;
+	}
+
 	return NF_ACCEPT;
 }
 
-- 
1.7.12.2.21.g234cd45.dirty



