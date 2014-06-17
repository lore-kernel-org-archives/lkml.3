Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965459AbaFQQcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:32:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51027 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965289AbaFQQ0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:26:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 069/121] netfilter: ipv4: defrag: set local_df flag on defragmented skb
Date: Tue, 17 Jun 2014 09:17:27 -0700
Message-Id: <1403021899-16708-42-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit 895162b1101b3ea5db08ca6822ae9672717efec0 upstream.

else we may fail to forward skb even if original fragments do fit
outgoing link mtu:

1. remote sends 2k packets in two 1000 byte frags, DF set
2. we want to forward but only see '2k > mtu and DF set'
3. we then send icmp error saying that outgoing link is 1500

But original sender never sent a packet that would not fit
the outgoing link.

Setting local_df makes outgoing path test size vs.
IPCB(skb)->frag_max_size, so we will still send the correct
error in case the largest original size did not fit
outgoing link mtu.

Reported-by: Maxime Bizon <mbizon@freebox.fr>
Suggested-by: Maxime Bizon <mbizon@freebox.fr>
Fixes: 5f2d04f1f9 (ipv4: fix path MTU discovery with connection tracking)
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/netfilter/nf_defrag_ipv4.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index 7428155..4cfb3bd 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -22,7 +22,6 @@
 #endif
 #include <net/netfilter/nf_conntrack_zones.h>
 
-/* Returns new sk_buff, or NULL */
 static int nf_ct_ipv4_gather_frags(struct sk_buff *skb, u_int32_t user)
 {
 	int err;
@@ -33,8 +32,10 @@ static int nf_ct_ipv4_gather_frags(struct sk_buff *skb, u_int32_t user)
 	err = ip_defrag(skb, user);
 	local_bh_enable();
 
-	if (!err)
+	if (!err) {
 		ip_send_check(ip_hdr(skb));
+		skb->local_df = 1;
+	}
 
 	return err;
 }
-- 
1.9.1

