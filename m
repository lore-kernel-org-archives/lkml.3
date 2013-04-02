Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab3DBWk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:40:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33208 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933430Ab3DBWNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:13:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Stancek <jan.stancek@gmail.com>, Paul Moore <pmoore@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 104/124] unix: fix a race condition in unix_release()
Date: Tue,  2 Apr 2013 15:11:26 -0700
Message-Id: <20130402221116.173782078@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Paul Moore <pmoore@redhat.com>

[ Upstream commit ded34e0fe8fe8c2d595bfa30626654e4b87621e0 ]

As reported by Jan, and others over the past few years, there is a
race condition caused by unix_release setting the sock->sk pointer
to NULL before properly marking the socket as dead/orphaned.  This
can cause a problem with the LSM hook security_unix_may_send() if
there is another socket attempting to write to this partially
released socket in between when sock->sk is set to NULL and it is
marked as dead/orphaned.  This patch fixes this by only setting
sock->sk to NULL after the socket has been marked as dead; I also
take the opportunity to make unix_release_sock() a void function
as it only ever returned 0/success.

Dave, I think this one should go on the -stable pile.

Special thanks to Jan for coming up with a reproducer for this
problem.

Reported-by: Jan Stancek <jan.stancek@gmail.com>
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/unix/af_unix.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -384,7 +384,7 @@ static void unix_sock_destructor(struct
 #endif
 }
 
-static int unix_release_sock(struct sock *sk, int embrion)
+static void unix_release_sock(struct sock *sk, int embrion)
 {
 	struct unix_sock *u = unix_sk(sk);
 	struct path path;
@@ -453,8 +453,6 @@ static int unix_release_sock(struct sock
 
 	if (unix_tot_inflight)
 		unix_gc();		/* Garbage collect fds */
-
-	return 0;
 }
 
 static void init_peercred(struct sock *sk)
@@ -701,9 +699,10 @@ static int unix_release(struct socket *s
 	if (!sk)
 		return 0;
 
+	unix_release_sock(sk, 0);
 	sock->sk = NULL;
 
-	return unix_release_sock(sk, 0);
+	return 0;
 }
 
 static int unix_autobind(struct socket *sock)


