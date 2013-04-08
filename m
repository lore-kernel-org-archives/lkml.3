Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935812Ab3DHJwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:52:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42900 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935754Ab3DHJwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Moore <pmoore@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 065/102] unix: fix a race condition in unix_release()
Date: Mon,  8 Apr 2013 10:50:20 +0100
Message-Id: <1365414657-29191-66-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Moore <pmoore@redhat.com>

commit ded34e0fe8fe8c2d595bfa30626654e4b87621e0 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/unix/af_unix.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 9aa708c..023db69 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -375,7 +375,7 @@ static void unix_sock_destructor(struct sock *sk)
 #endif
 }
 
-static int unix_release_sock(struct sock *sk, int embrion)
+static void unix_release_sock(struct sock *sk, int embrion)
 {
 	struct unix_sock *u = unix_sk(sk);
 	struct path path;
@@ -444,8 +444,6 @@ static int unix_release_sock(struct sock *sk, int embrion)
 
 	if (unix_tot_inflight)
 		unix_gc();		/* Garbage collect fds */
-
-	return 0;
 }
 
 static void init_peercred(struct sock *sk)
@@ -695,9 +693,10 @@ static int unix_release(struct socket *sock)
 	if (!sk)
 		return 0;
 
+	unix_release_sock(sk, 0);
 	sock->sk = NULL;
 
-	return unix_release_sock(sk, 0);
+	return 0;
 }
 
 static int unix_autobind(struct socket *sock)
-- 
1.8.1.2

