Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbaBEVJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:09:38 -0500
Received: from mail.windriver.com ([147.11.1.11]:54320 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbaBEUED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:04:03 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Paul Moore <pmoore@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 038/213] unix: fix a race condition in unix_release()
Date: Wed, 5 Feb 2014 14:59:53 -0500
Message-ID: <1391630568-49251-39-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Moore <pmoore@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/unix/af_unix.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 0b7148bed6b3..072835bc61fa 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -370,7 +370,7 @@ static void unix_sock_destructor(struct sock *sk)
 #endif
 }
 
-static int unix_release_sock(struct sock *sk, int embrion)
+static void unix_release_sock(struct sock *sk, int embrion)
 {
 	struct unix_sock *u = unix_sk(sk);
 	struct dentry *dentry;
@@ -445,8 +445,6 @@ static int unix_release_sock(struct sock *sk, int embrion)
 
 	if (unix_tot_inflight)
 		unix_gc();		/* Garbage collect fds */
-
-	return 0;
 }
 
 static int unix_listen(struct socket *sock, int backlog)
@@ -661,9 +659,10 @@ static int unix_release(struct socket *sock)
 	if (!sk)
 		return 0;
 
+	unix_release_sock(sk, 0);
 	sock->sk = NULL;
 
-	return unix_release_sock(sk, 0);
+	return 0;
 }
 
 static int unix_autobind(struct socket *sock)
-- 
1.8.5.2

