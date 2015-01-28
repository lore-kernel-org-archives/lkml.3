Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbbA2JHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:07:43 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44906 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760560AbbA2JHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:07:35 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Simon Horman <horms@verge.net.au>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 088/176] ipvs: correct usage/allocation of seqadj ext in ipvs
Date: Wed, 28 Jan 2015 15:28:38 +0100
Message-Id: <0dc051e586000710b98014be998ac2e1a7fde76b.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ upstream commit b25adce1606427fd88da08f5203714cada7f6a98 ]

The IPVS FTP helper ip_vs_ftp could trigger an OOPS in nf_ct_seqadj_set,
after commit 41d73ec053d2 (netfilter: nf_conntrack: make sequence number
adjustments usuable without NAT).

This is because, the seqadj ext is now allocated dynamically, and the
IPVS code didn't handle this situation.  Fix this in the IPVS nfct
code by invoking the alloc function nfct_seqadj_ext_add().

Cc: <stable@vger.kernel.org> # 3.12.x
Fixes: 41d73ec053d2 (netfilter: nf_conntrack: make sequence number adjustments usuable without NAT)
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/netfilter/ipvs/ip_vs_nfct.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_nfct.c b/net/netfilter/ipvs/ip_vs_nfct.c
index c8beafd401aa..5a355a46d1dc 100644
--- a/net/netfilter/ipvs/ip_vs_nfct.c
+++ b/net/netfilter/ipvs/ip_vs_nfct.c
@@ -63,6 +63,7 @@
 #include <net/ip_vs.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_expect.h>
+#include <net/netfilter/nf_conntrack_seqadj.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 
@@ -97,6 +98,11 @@ ip_vs_update_conntrack(struct sk_buff *skb, struct ip_vs_conn *cp, int outin)
 	if (CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL)
 		return;
 
+	/* Applications may adjust TCP seqs */
+	if (cp->app && nf_ct_protonum(ct) == IPPROTO_TCP &&
+	    !nfct_seqadj(ct) && !nfct_seqadj_ext_add(ct))
+		return;
+
 	/*
 	 * The connection is not yet in the hashtable, so we update it.
 	 * CIP->VIP will remain the same, so leave the tuple in
-- 
2.2.2

