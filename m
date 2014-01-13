Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbaAMOiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:38:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51572 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaAMO06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:26:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sasha Levin <sasha.levin@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 82/96] net: unix: allow set_peek_off to fail
Date: Mon, 13 Jan 2014 14:24:45 +0000
Message-Id: <1389623099-18783-83-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

commit 12663bfc97c8b3fdb292428105dd92d563164050 upstream.

unix_dgram_recvmsg() will hold the readlock of the socket until recv
is complete.

In the same time, we may try to setsockopt(SO_PEEK_OFF) which will hang until
unix_dgram_recvmsg() will complete (which can take a while) without allowing
us to break out of it, triggering a hung task spew.

Instead, allow set_peek_off to fail, this way userspace will not hang.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/net.h | 2 +-
 net/core/sock.c     | 2 +-
 net/unix/af_unix.c  | 8 ++++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index f150cdf..2ece444 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -215,7 +215,7 @@ struct proto_ops {
 				      int offset, size_t size, int flags);
 	ssize_t 	(*splice_read)(struct socket *sock,  loff_t *ppos,
 				       struct pipe_inode_info *pipe, size_t len, unsigned int flags);
-	void		(*set_peek_off)(struct sock *sk, int val);
+	int		(*set_peek_off)(struct sock *sk, int val);
 };
 
 #define DECLARE_SOCKADDR(type, dst, src)	\
diff --git a/net/core/sock.c b/net/core/sock.c
index 457ae99..5057305 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -787,7 +787,7 @@ set_rcvbuf:
 
 	case SO_PEEK_OFF:
 		if (sock->ops->set_peek_off)
-			sock->ops->set_peek_off(sk, val);
+			ret = sock->ops->set_peek_off(sk, val);
 		else
 			ret = -EOPNOTSUPP;
 		break;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index a0df32b..692d780 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -525,13 +525,17 @@ static int unix_seqpacket_sendmsg(struct kiocb *, struct socket *,
 static int unix_seqpacket_recvmsg(struct kiocb *, struct socket *,
 				  struct msghdr *, size_t, int);
 
-static void unix_set_peek_off(struct sock *sk, int val)
+static int unix_set_peek_off(struct sock *sk, int val)
 {
 	struct unix_sock *u = unix_sk(sk);
 
-	mutex_lock(&u->readlock);
+	if (mutex_lock_interruptible(&u->readlock))
+		return -EINTR;
+
 	sk->sk_peek_off = val;
 	mutex_unlock(&u->readlock);
+
+	return 0;
 }
 
 
-- 
1.8.3.2

