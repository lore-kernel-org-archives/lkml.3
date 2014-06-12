Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbaFLXTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:19:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbaFLXTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:19:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maxime Bizon <mbizon@freebox.fr>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.4 2/8] netfilter: ipv4: defrag: set local_df flag on defragmented skb
Date: Thu, 12 Jun 2014 16:22:49 -0700
Message-Id: <20140612232238.585729937@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140612232238.396722659@linuxfoundation.org>
References: <20140612232238.396722659@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/netfilter/nf_defrag_ipv4.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -22,7 +22,6 @@
 #endif
 #include <net/netfilter/nf_conntrack_zones.h>
 
-/* Returns new sk_buff, or NULL */
 static int nf_ct_ipv4_gather_frags(struct sk_buff *skb, u_int32_t user)
 {
 	int err;
@@ -33,8 +32,10 @@ static int nf_ct_ipv4_gather_frags(struc
 	err = ip_defrag(skb, user);
 	local_bh_enable();
 
-	if (!err)
+	if (!err) {
 		ip_send_check(ip_hdr(skb));
+		skb->local_df = 1;
+	}
 
 	return err;
 }


