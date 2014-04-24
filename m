Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367AbaDXWOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:14:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbaDXVxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:53:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Rainer Weikusat <rweikusat@mobileactivedefense.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 03/27] net: unix: non blocking recvmsg() should not return -EINTR
Date: Thu, 24 Apr 2014 14:55:37 -0700
Message-Id: <20140424215552.041408348@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140424215551.942390050@linuxfoundation.org>
References: <20140424215551.942390050@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Rainer Weikusat <rweikusat@mobileactivedefense.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/unix/af_unix.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1787,8 +1787,11 @@ static int unix_dgram_recvmsg(struct kio
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
 
@@ -1910,6 +1913,7 @@ static int unix_stream_recvmsg(struct ki
 	struct unix_sock *u = unix_sk(sk);
 	struct sockaddr_un *sunaddr = msg->msg_name;
 	int copied = 0;
+	int noblock = flags & MSG_DONTWAIT;
 	int check_creds = 0;
 	int target;
 	int err = 0;
@@ -1925,7 +1929,7 @@ static int unix_stream_recvmsg(struct ki
 		goto out;
 
 	target = sock_rcvlowat(sk, flags&MSG_WAITALL, size);
-	timeo = sock_rcvtimeo(sk, flags&MSG_DONTWAIT);
+	timeo = sock_rcvtimeo(sk, noblock);
 
 	/* Lock the socket to prevent queue disordering
 	 * while sleeps in memcpy_tomsg
@@ -1937,8 +1941,11 @@ static int unix_stream_recvmsg(struct ki
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
 


