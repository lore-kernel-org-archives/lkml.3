Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbaCFXTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 18:19:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbaCFXTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 18:19:05 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 1/3] af_rxrpc: Remove incorrect checksum calculation from
 rxrpc_recvmsg() [ver #3]
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: dhowells@redhat.com, tim@electronghost.co.uk,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 06 Mar 2014 23:18:43 +0000
Message-ID: <20140306231843.11431.66661.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140306231835.11431.50147.stgit@warthog.procyon.org.uk>
References: <20140306231835.11431.50147.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Smith <tim@electronghost.co.uk>

The UDP checksum was already verified in rxrpc_data_ready() - which calls
skb_checksum_complete() - as the RxRPC packet header contains no checksum of
its own.  Subsequent calls to skb_copy_and_csum_datagram_iovec() are thus
redundant and are, in any case, being passed only a subset of the UDP payload -
so the checksum will always fail if that path is taken.

So there is no need to check skb->ip_summed in rxrpc_recvmsg(), and no need for
the csum_copy_error: exit path.

Signed-off-by: Tim Smith <tim@electronghost.co.uk>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-recvmsg.c |   25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/net/rxrpc/ar-recvmsg.c b/net/rxrpc/ar-recvmsg.c
index 34b5490dde65..e9aaa65c0778 100644
--- a/net/rxrpc/ar-recvmsg.c
+++ b/net/rxrpc/ar-recvmsg.c
@@ -180,16 +180,7 @@ int rxrpc_recvmsg(struct kiocb *iocb, struct socket *sock,
 		if (copy > len - copied)
 			copy = len - copied;
 
-		if (skb->ip_summed == CHECKSUM_UNNECESSARY ||
-		    skb->ip_summed == CHECKSUM_PARTIAL) {
-			ret = skb_copy_datagram_iovec(skb, offset,
-						      msg->msg_iov, copy);
-		} else {
-			ret = skb_copy_and_csum_datagram_iovec(skb, offset,
-							       msg->msg_iov);
-			if (ret == -EINVAL)
-				goto csum_copy_error;
-		}
+		ret = skb_copy_datagram_iovec(skb, offset, msg->msg_iov, copy);
 
 		if (ret < 0)
 			goto copy_error;
@@ -348,20 +339,6 @@ copy_error:
 	_leave(" = %d", ret);
 	return ret;
 
-csum_copy_error:
-	_debug("csum error");
-	release_sock(&rx->sk);
-	if (continue_call)
-		rxrpc_put_call(continue_call);
-	rxrpc_kill_skb(skb);
-	if (!(flags & MSG_PEEK)) {
-		if (skb_dequeue(&rx->sk.sk_receive_queue) != skb)
-			BUG();
-	}
-	skb_kill_datagram(&rx->sk, skb, flags);
-	rxrpc_put_call(call);
-	return -EAGAIN;
-
 wait_interrupted:
 	ret = sock_intr_errno(timeo);
 wait_error:

