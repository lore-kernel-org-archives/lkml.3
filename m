Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbaANA0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:26:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbaANA0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:26:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 09/27] net: unix: allow set_peek_off to fail
Date: Mon, 13 Jan 2014 16:26:23 -0800
Message-Id: <20140114002623.624125675@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002623.356220317@linuxfoundation.org>
References: <20140114002623.356220317@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/net.h |    2 +-
 net/core/sock.c     |    2 +-
 net/unix/af_unix.c  |    8 ++++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

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
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -795,7 +795,7 @@ set_rcvbuf:
 
 	case SO_PEEK_OFF:
 		if (sock->ops->set_peek_off)
-			sock->ops->set_peek_off(sk, val);
+			ret = sock->ops->set_peek_off(sk, val);
 		else
 			ret = -EOPNOTSUPP;
 		break;
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -524,13 +524,17 @@ static int unix_seqpacket_sendmsg(struct
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
 
 


