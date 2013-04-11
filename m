Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965053Ab3DKUkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:40:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27887 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab3DKUZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:25:57 -0400
X-Authority-Analysis: v=2.0 cv=Pu4Rnnw3 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=d-sl9G_xEVQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=P28-H_hmc1UA:10 a=tmtSDGaQAAAA:8 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=i5l3BeYsPBN1KbzBBJEA:9 a=jkObVMfX7fAA:10 a=UTB_XpHje0EA:10 a=0kPLrQdw3YYA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202548.578110712@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Pavel Emelyanov <xemul@parallels.com>, Eric Dumazet <edumazet@google.com>,
        Mel Gorman <mgorman@suse.de>, "David S. Miller" <davem@davemloft.net>
Subject: [ 014/171 ] skb: Propagate pfmemalloc on skb from head page only
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0014-skb-Propagate-pfmemalloc-on-skb-from-head-page-only.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Pavel Emelyanov <xemul@parallels.com>

[ Upstream commit cca7af3889bfa343d33d5e657a38d876abd10e58 ]

Hi.

I'm trying to send big chunks of memory from application address space via
TCP socket using vmsplice + splice like this

   mem = mmap(128Mb);
   vmsplice(pipe[1], mem); /* splice memory into pipe */
   splice(pipe[0], tcp_socket); /* send it into network */

When I'm lucky and a huge page splices into the pipe and then into the socket
_and_ client and server ends of the TCP connection are on the same host,
communicating via lo, the whole connection gets stuck! The sending queue
becomes full and app stops writing/splicing more into it, but the receiving
queue remains empty, and that's why.

The __skb_fill_page_desc observes a tail page of a huge page and erroneously
propagates its page->pfmemalloc value onto socket (the pfmemalloc on tail pages
contain garbage). Then this skb->pfmemalloc leaks through lo and due to the

    tcp_v4_rcv
    sk_filter
        if (skb->pfmemalloc && !sock_flag(sk, SOCK_MEMALLOC)) /* true */
            return -ENOMEM
        goto release_and_discard;

no packets reach the socket. Even TCP re-transmits are dropped by this, as skb
cloning clones the pfmemalloc flag as well.

That said, here's the proper page->pfmemalloc propagation onto socket: we
must check the huge-page's head page only, other pages' pfmemalloc and mapping
values do not contain what is expected in this place. However, I'm not sure
whether this fix is _complete_, since pfmemalloc propagation via lo also
oesn't look great.

Both, bit propagation from page to skb and this check in sk_filter, were
introduced by c48a11c7 (netvm: propagate page->pfmemalloc to skb), in v3.5 so
Mel and stable@ are in Cc.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/skbuff.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9a21379..adab092 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1253,11 +1253,13 @@ static inline void __skb_fill_page_desc(struct sk_buff *skb, int i,
 	 * do not lose pfmemalloc information as the pages would not be
 	 * allocated using __GFP_MEMALLOC.
 	 */
-	if (page->pfmemalloc && !page->mapping)
-		skb->pfmemalloc	= true;
 	frag->page.p		  = page;
 	frag->page_offset	  = off;
 	skb_frag_size_set(frag, size);
+
+	page = compound_head(page);
+	if (page->pfmemalloc && !page->mapping)
+		skb->pfmemalloc	= true;
 }
 
 /**
-- 
1.7.10.4


