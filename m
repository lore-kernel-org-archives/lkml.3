Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423007Ab3BANPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:15:15 -0500
Received: from mail.kernel.org ([198.145.19.201]:45791 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422817Ab3BANPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:15:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Haibo Xi <haibbo@gmail.com>, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 73/89] netfilter: nf_ct_reasm: fix conntrack reassembly expire code
Date: Fri,  1 Feb 2013 14:08:28 +0100
Message-Id: <20130201130212.740166465@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Xi <haibbo@gmail.com>

commit 97cf00e93cc24898493e7a058105e3215257ee04 upstream.

Commit b836c99fd6c9 (ipv6: unify conntrack reassembly expire
code with standard one) use the standard IPv6 reassembly
code(ip6_expire_frag_queue) to handle conntrack reassembly expire.

In ip6_expire_frag_queue, it invoke dev_get_by_index_rcu to get
which device received this expired packet.so we must save ifindex
when NF_conntrack get this packet.

With this patch applied, I can see ICMP Time Exceeded sent
from the receiver when the sender sent out 1/2 fragmented
IPv6 packet.

Signed-off-by: Haibo Xi <haibbo@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv6/netfilter/nf_conntrack_reasm.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -311,7 +311,10 @@ found:
 	else
 		fq->q.fragments = skb;
 
-	skb->dev = NULL;
+	if (skb->dev) {
+		fq->iif = skb->dev->ifindex;
+		skb->dev = NULL;
+	}
 	fq->q.stamp = skb->tstamp;
 	fq->q.meat += skb->len;
 	if (payload_len > fq->q.max_size)


