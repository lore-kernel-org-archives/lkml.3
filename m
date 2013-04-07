Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934786Ab3DGXaK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:30:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46729 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934780Ab3DGXaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:30:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Paul Moore" <pmoore@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jan Stancek" <jan.stancek@gmail.com>
Date: Sun, 07 Apr 2013 23:45:43 +0100
Message-ID: <lsq.1365374743.352112114@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [59/74] unix: fix a race condition in unix_release()
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/unix/af_unix.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 317bfe3..18978b6 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -371,7 +371,7 @@ static void unix_sock_destructor(struct sock *sk)
 #endif
 }
 
-static int unix_release_sock(struct sock *sk, int embrion)
+static void unix_release_sock(struct sock *sk, int embrion)
 {
 	struct unix_sock *u = unix_sk(sk);
 	struct dentry *dentry;
@@ -444,8 +444,6 @@ static int unix_release_sock(struct sock *sk, int embrion)
 
 	if (unix_tot_inflight)
 		unix_gc();		/* Garbage collect fds */
-
-	return 0;
 }
 
 static void init_peercred(struct sock *sk)
@@ -682,9 +680,10 @@ static int unix_release(struct socket *sock)
 	if (!sk)
 		return 0;
 
+	unix_release_sock(sk, 0);
 	sock->sk = NULL;
 
-	return unix_release_sock(sk, 0);
+	return 0;
 }
 
 static int unix_autobind(struct socket *sock)

