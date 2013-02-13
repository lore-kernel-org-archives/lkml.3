Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692Ab3BMJsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:48:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34007 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758502Ab3BMJsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:48:12 -0500
From: Michal Kubecek <mkubecek@suse.cz>
Date: Wed, 13 Feb 2013 10:46:09 +0100
Subject: [PATCH nf-next] netfilter: nf_ct_reasm: fix per-netns sysctl
 initialization
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Amerigo Wang <amwang@redhat.com>
Message-Id: <20130213094810.64691C3A4E@unicorn.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjusting of data pointers in net/netfilter/nf_conntrack_frag6_*
sysctl table for other namespaces points to wrong netns_frags
structure and has reversed order of entries.

Problem introduced by commit c038a767cd69 in 3.7-rc1

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index c674f15..6f5c986 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -97,9 +97,9 @@ static int nf_ct_frag6_sysctl_register(struct net *net)
 		if (table == NULL)
 			goto err_alloc;
 
-		table[0].data = &net->ipv6.frags.high_thresh;
-		table[1].data = &net->ipv6.frags.low_thresh;
-		table[2].data = &net->ipv6.frags.timeout;
+		table[0].data = &net->nf_frag.frags.timeout;
+		table[1].data = &net->nf_frag.frags.low_thresh;
+		table[2].data = &net->nf_frag.frags.high_thresh;
 	}
 
 	hdr = register_net_sysctl(net, "net/netfilter", table);
-- 
1.7.10.4

