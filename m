Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbaDRJmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:42:20 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45945 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752222AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Rainer Weikusat <rweikusat@mobileactivedefense.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 33/72] net: unix: non blocking recvmsg() should not return -EINTR
Date: Fri, 18 Apr 2014 11:22:06 +0200
Message-Id: <e3749adbcbf79583fb092fa1866a160f664912eb.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit de1443916791d75fdd26becb116898277bb0273f ]

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/unix/af_unix.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index d7c1ac621a90..c3975bcf725f 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1785,8 +1785,11 @@ static int unix_dgram_recvmsg(struct kiocb *iocb, struct socket *sock,
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
 
@@ -1911,6 +1914,7 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
 	struct unix_sock *u = unix_sk(sk);
 	struct sockaddr_un *sunaddr = msg->msg_name;
 	int copied = 0;
+	int noblock = flags & MSG_DONTWAIT;
 	int check_creds = 0;
 	int target;
 	int err = 0;
@@ -1926,7 +1930,7 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
 		goto out;
 
 	target = sock_rcvlowat(sk, flags&MSG_WAITALL, size);
-	timeo = sock_rcvtimeo(sk, flags&MSG_DONTWAIT);
+	timeo = sock_rcvtimeo(sk, noblock);
 
 	/* Lock the socket to prevent queue disordering
 	 * while sleeps in memcpy_tomsg
@@ -1938,8 +1942,11 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
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
1.9.2

