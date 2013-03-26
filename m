Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab3CZXq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:46:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52412 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab3CZWnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:43:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Eric Dumazet <edumazet@google.com>, Mel Gorman <mgorman@suse.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 14/98] skb: Propagate pfmemalloc on skb from head page only
Date: Tue, 26 Mar 2013 15:42:03 -0700
Message-Id: <20130326224243.949089288@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1269,11 +1269,13 @@ static inline void __skb_fill_page_desc(
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


