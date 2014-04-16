Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbaDPKxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:53:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51668 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658AbaDPKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:29 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        Rainer Weikusat <rweikusat@mobileactivedefense.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 14/46] net: unix: non blocking recvmsg() should not return -EINTR
Date: Wed, 16 Apr 2014 11:31:30 +0100
Message-Id: <1397644322-13905-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit de1443916791d75fdd26becb116898277bb0273f upstream.

Some applications didn't expect recvmsg() on a non blocking socket
could return -EINTR. This possibility was added as a side effect
of commit b3ca9b02b00704 ("net: fix multithreaded signal handling in
unix recv routines").

To hit this bug, you need to be a bit unlucky, as the u->readlock
mutex is usually held for very small periods.

Fixes: b3ca9b02b00704 ("net: fix multithreaded signal handling in unix recv routines")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Rainer Weikusat <rweikusat@mobileactivedefense.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/unix/af_unix.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 2ea3310..c80c107 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1793,8 +1793,11 @@ static int unix_dgram_recvmsg(struct kiocb *iocb, struct socket *sock,
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
 
@@ -1914,6 +1917,7 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
 	struct unix_sock *u = unix_sk(sk);
 	struct sockaddr_un *sunaddr = msg->msg_name;
 	int copied = 0;
+	int noblock = flags & MSG_DONTWAIT;
 	int check_creds = 0;
 	int target;
 	int err = 0;
@@ -1929,7 +1933,7 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
 		goto out;
 
 	target = sock_rcvlowat(sk, flags&MSG_WAITALL, size);
-	timeo = sock_rcvtimeo(sk, flags&MSG_DONTWAIT);
+	timeo = sock_rcvtimeo(sk, noblock);
 
 	/* Lock the socket to prevent queue disordering
 	 * while sleeps in memcpy_tomsg
@@ -1941,8 +1945,11 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
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

