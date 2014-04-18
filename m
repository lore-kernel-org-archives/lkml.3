Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbaDRJnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:43:20 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45921 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752140AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Borkmann <dborkman@redhat.com>,
        Vlad Yasevich <yasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 25/72] net: sctp: fix skb leakage in COOKIE ECHO path of chunk->auth_chunk
Date: Fri, 18 Apr 2014 11:21:58 +0200
Message-Id: <607e4255f134e7f461d9799d30053499b0392a3a.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit c485658bae87faccd7aed540fd2ca3ab37992310 ]

While working on ec0223ec48a9 ("net: sctp: fix sctp_sf_do_5_1D_ce to
verify if we/peer is AUTH capable"), we noticed that there's a skb
memory leakage in the error path.

Running the same reproducer as in ec0223ec48a9 and by unconditionally
jumping to the error label (to simulate an error condition) in
sctp_sf_do_5_1D_ce() receive path lets kmemleak detector bark about
the unfreed chunk->auth_chunk skb clone:

Unreferenced object 0xffff8800b8f3a000 (size 256):
  comm "softirq", pid 0, jiffies 4294769856 (age 110.757s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    89 ab 75 5e d4 01 58 13 00 00 00 00 00 00 00 00  ..u^..X.........
  backtrace:
    [<ffffffff816660be>] kmemleak_alloc+0x4e/0xb0
    [<ffffffff8119f328>] kmem_cache_alloc+0xc8/0x210
    [<ffffffff81566929>] skb_clone+0x49/0xb0
    [<ffffffffa0467459>] sctp_endpoint_bh_rcv+0x1d9/0x230 [sctp]
    [<ffffffffa046fdbc>] sctp_inq_push+0x4c/0x70 [sctp]
    [<ffffffffa047e8de>] sctp_rcv+0x82e/0x9a0 [sctp]
    [<ffffffff815abd38>] ip_local_deliver_finish+0xa8/0x210
    [<ffffffff815a64af>] nf_reinject+0xbf/0x180
    [<ffffffffa04b4762>] nfqnl_recv_verdict+0x1d2/0x2b0 [nfnetlink_queue]
    [<ffffffffa04aa40b>] nfnetlink_rcv_msg+0x14b/0x250 [nfnetlink]
    [<ffffffff815a3269>] netlink_rcv_skb+0xa9/0xc0
    [<ffffffffa04aa7cf>] nfnetlink_rcv+0x23f/0x408 [nfnetlink]
    [<ffffffff815a2bd8>] netlink_unicast+0x168/0x250
    [<ffffffff815a2fa1>] netlink_sendmsg+0x2e1/0x3f0
    [<ffffffff8155cc6b>] sock_sendmsg+0x8b/0xc0
    [<ffffffff8155d449>] ___sys_sendmsg+0x369/0x380

What happens is that commit bbd0d59809f9 clones the skb containing
the AUTH chunk in sctp_endpoint_bh_rcv() when having the edge case
that an endpoint requires COOKIE-ECHO chunks to be authenticated:

  ---------- INIT[RANDOM; CHUNKS; HMAC-ALGO] ---------->
  <------- INIT-ACK[RANDOM; CHUNKS; HMAC-ALGO] ---------
  ------------------ AUTH; COOKIE-ECHO ---------------->
  <-------------------- COOKIE-ACK ---------------------

When we enter sctp_sf_do_5_1D_ce() and before we actually get to
the point where we process (and subsequently free) a non-NULL
chunk->auth_chunk, we could hit the "goto nomem_init" path from
an error condition and thus leave the cloned skb around w/o
freeing it.

The fix is to centrally free such clones in sctp_chunk_destroy()
handler that is invoked from sctp_chunk_free() after all refs have
dropped; and also move both kfree_skb(chunk->auth_chunk) there,
so that chunk->auth_chunk is either NULL (since sctp_chunkify()
allocs new chunks through kmem_cache_zalloc()) or non-NULL with
a valid skb pointer. chunk->skb and chunk->auth_chunk are the
only skbs in the sctp_chunk structure that need to be handeled.

While at it, we should use consume_skb() for both. It is the same
as dev_kfree_skb() but more appropriately named as we are not
a device but a protocol. Also, this effectively replaces the
kfree_skb() from both invocations into consume_skb(). Functions
are the same only that kfree_skb() assumes that the frame was
being dropped after a failure (e.g. for tools like drop monitor),
usage of consume_skb() seems more appropriate in function
sctp_chunk_destroy() though.

Fixes: bbd0d59809f9 ("[SCTP]: Implement the receive and verification of AUTH chunk")
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Vlad Yasevich <yasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/sctp/sm_make_chunk.c | 4 ++--
 net/sctp/sm_statefuns.c  | 5 -----
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index d244a23ab8d3..26be077b8267 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1433,8 +1433,8 @@ static void sctp_chunk_destroy(struct sctp_chunk *chunk)
 	BUG_ON(!list_empty(&chunk->list));
 	list_del_init(&chunk->transmitted_list);
 
-	/* Free the chunk skb data and the SCTP_chunk stub itself. */
-	dev_kfree_skb(chunk->skb);
+	consume_skb(chunk->skb);
+	consume_skb(chunk->auth_chunk);
 
 	SCTP_DBG_OBJCNT_DEC(chunk);
 	kmem_cache_free(sctp_chunk_cachep, chunk);
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 56ebe71cfe13..0a5f0508c43a 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -761,7 +761,6 @@ sctp_disposition_t sctp_sf_do_5_1D_ce(struct net *net,
 
 		/* Make sure that we and the peer are AUTH capable */
 		if (!net->sctp.auth_enable || !new_asoc->peer.auth_capable) {
-			kfree_skb(chunk->auth_chunk);
 			sctp_association_free(new_asoc);
 			return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 		}
@@ -776,10 +775,6 @@ sctp_disposition_t sctp_sf_do_5_1D_ce(struct net *net,
 		auth.transport = chunk->transport;
 
 		ret = sctp_sf_authenticate(net, ep, new_asoc, type, &auth);
-
-		/* We can now safely free the auth_chunk clone */
-		kfree_skb(chunk->auth_chunk);
-
 		if (ret != SCTP_IERROR_NO_ERROR) {
 			sctp_association_free(new_asoc);
 			return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
-- 
1.9.2

