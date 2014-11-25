Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaKYOEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:04:42 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44205 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaKYOCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:02:34 -0500
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/17] tipc_sendmsg(): pass msghdr instead of its ->msg_iov
Date: Tue, 25 Nov 2014 14:02:26 +0000
Message-Id: <1416924151-28698-12-git-send-email-viro@ZenIV.linux.org.uk>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <20141125024018.GH7996@ZenIV.linux.org.uk>
References: <20141125024018.GH7996@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/tipc/socket.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index e918091..2d4b2fa 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -700,7 +700,7 @@ static unsigned int tipc_poll(struct file *file, struct socket *sock,
  * tipc_sendmcast - send multicast message
  * @sock: socket structure
  * @seq: destination address
- * @iov: message data to send
+ * @msg: message to send
  * @dsz: total length of message data
  * @timeo: timeout to wait for wakeup
  *
@@ -708,7 +708,7 @@ static unsigned int tipc_poll(struct file *file, struct socket *sock,
  * Returns the number of bytes sent on success, or errno
  */
 static int tipc_sendmcast(struct  socket *sock, struct tipc_name_seq *seq,
-			  struct iovec *iov, size_t dsz, long timeo)
+			  struct msghdr *msg, size_t dsz, long timeo)
 {
 	struct sock *sk = sock->sk;
 	struct tipc_msg *mhdr = &tipc_sk(sk)->phdr;
@@ -727,7 +727,7 @@ static int tipc_sendmcast(struct  socket *sock, struct tipc_name_seq *seq,
 
 new_mtu:
 	mtu = tipc_bclink_get_mtu();
-	rc = tipc_msg_build(mhdr, iov, 0, dsz, mtu, &buf);
+	rc = tipc_msg_build(mhdr, msg->msg_iov, 0, dsz, mtu, &buf);
 	if (unlikely(rc < 0))
 		return rc;
 
@@ -951,7 +951,7 @@ static int tipc_sendmsg(struct kiocb *iocb, struct socket *sock,
 	timeo = sock_sndtimeo(sk, m->msg_flags & MSG_DONTWAIT);
 
 	if (dest->addrtype == TIPC_ADDR_MCAST) {
-		rc = tipc_sendmcast(sock, seq, iov, dsz, timeo);
+		rc = tipc_sendmcast(sock, seq, m, dsz, timeo);
 		goto exit;
 	} else if (dest->addrtype == TIPC_ADDR_NAME) {
 		u32 type = dest->addr.name.name.type;
-- 
1.7.10.4

