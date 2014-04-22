Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989AbaDVVkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:40:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36135 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776AbaDVUPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:15:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 003/133] net: unix: non blocking recvmsg() should not return -EINTR
Date: Tue, 22 Apr 2014 13:12:21 -0700
Message-Id: <1398197671-12786-4-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit de1443916791d75fdd26becb116898277bb0273f ]

Some applications didn't expect recvmsg() on a non blocking socket
could return -EINTR. This possibility was added as a side effect
of commit b3ca9b02b00704 ("net: fix multithreaded signal handling in
unix recv routines").

To hit this bug, you need to be a bit unlucky, as the u->readlock
mutex is usually held for very small periods.

Fixes: b3ca9b02b00704 ("net: fix multithreaded signal handling in unix recv routines")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ kamal removed Cc: Rainer Weikusat per request ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/unix/af_unix.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 72f4e97..3887f23 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1795,8 +1795,11 @@ static int unix_dgram_recvmsg(struct kiocb *iocb, struct socket *sock,
 		goto out;
 
 	err = mutex_lock_interruptible(&u->readlock);
-	if (err) {
-		err = sock_intr_errno(sock_rcvtimeo(sk, noblock));
+	if (unlikely(err)) {
+		/* recvmsg() in non blocking mode is supposed to return -EAGAIN
+		 * sk_rcvtimeo is not honored by mutex_lock_interruptible()
+		 */
+		err = noblock ? -EAGAIN : -ERESTARTSYS;
 		goto out;
 	}
 
@@ -1918,6 +1921,7 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
 	struct unix_sock *u = unix_sk(sk);
 	struct sockaddr_un *sunaddr = msg->msg_name;
 	int copied = 0;
+	int noblock = flags & MSG_DONTWAIT;
 	int check_creds = 0;
 	int target;
 	int err = 0;
@@ -1933,7 +1937,7 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
 		goto out;
 
 	target = sock_rcvlowat(sk, flags&MSG_WAITALL, size);
-	timeo = sock_rcvtimeo(sk, flags&MSG_DONTWAIT);
+	timeo = sock_rcvtimeo(sk, noblock);
 
 	/* Lock the socket to prevent queue disordering
 	 * while sleeps in memcpy_tomsg
@@ -1945,8 +1949,11 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
 	}
 
 	err = mutex_lock_interruptible(&u->readlock);
-	if (err) {
-		err = sock_intr_errno(timeo);
+	if (unlikely(err)) {
+		/* recvmsg() in non blocking mode is supposed to return -EAGAIN
+		 * sk_rcvtimeo is not honored by mutex_lock_interruptible()
+		 */
+		err = noblock ? -EAGAIN : -ERESTARTSYS;
 		goto out;
 	}
 
-- 
1.9.1

