Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbaAOW06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:26:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41007 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbaAOV5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:57:34 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sasha Levin <sasha.levin@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 149/166] net: unix: allow set_peek_off to fail
Date: Wed, 15 Jan 2014 13:52:43 -0800
Message-Id: <1389822780-4729-150-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

[ Upstream commit 12663bfc97c8b3fdb292428105dd92d563164050 ]

unix_dgram_recvmsg() will hold the readlock of the socket until recv
is complete.

In the same time, we may try to setsockopt(SO_PEEK_OFF) which will hang until
unix_dgram_recvmsg() will complete (which can take a while) without allowing
us to break out of it, triggering a hung task spew.

Instead, allow set_peek_off to fail, this way userspace will not hang.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/net.h | 2 +-
 net/core/sock.c     | 2 +-
 net/unix/af_unix.c  | 8 ++++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index 5ea38d9..f6dc1f5 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -180,7 +180,7 @@ struct proto_ops {
 				      int offset, size_t size, int flags);
 	ssize_t 	(*splice_read)(struct socket *sock,  loff_t *ppos,
 				       struct pipe_inode_info *pipe, size_t len, unsigned int flags);
-	void		(*set_peek_off)(struct sock *sk, int val);
+	int		(*set_peek_off)(struct sock *sk, int val);
 };
 
 #define DECLARE_SOCKADDR(type, dst, src)	\
diff --git a/net/core/sock.c b/net/core/sock.c
index fc0d751..7367c05 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -886,7 +886,7 @@ set_rcvbuf:
 
 	case SO_PEEK_OFF:
 		if (sock->ops->set_peek_off)
-			sock->ops->set_peek_off(sk, val);
+			ret = sock->ops->set_peek_off(sk, val);
 		else
 			ret = -EOPNOTSUPP;
 		break;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 6cc5803..499efb7 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -531,13 +531,17 @@ static int unix_seqpacket_sendmsg(struct kiocb *, struct socket *,
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

