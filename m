Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbaEDQIv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:08:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbaEDPm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Weng Meiling <wengmeiling.weng@huawei.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.10 43/86] nfsd: check passed sockets net matches NFSd superblocks one
Date: Sun,  4 May 2014 11:41:18 -0400
Message-Id: <20140504154146.247332711@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154140.444932005@linuxfoundation.org>
References: <20140504154140.444932005@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kinsbursky <skinsbursky@parallels.com>

commit 3064639423c48d6e0eb9ecc27c512a58e38c6c57 upstream.

There could be a case, when NFSd file system is mounted in network, different
to socket's one, like below:

"ip netns exec" creates new network and mount namespace, which duplicates NFSd
mount point, created in init_net context. And thus NFS server stop in nested
network context leads to RPCBIND client destruction in init_net.
Then, on NFSd start in nested network context, rpc.nfsd process creates socket
in nested net and passes it into "write_ports", which leads to RPCBIND sockets
creation in init_net context because of the same reason (NFSd monut point was
created in init_net context). An attempt to register passed socket in nested
net leads to panic, because no RPCBIND client present in nexted network
namespace.

This patch add check that passed socket's net matches NFSd superblock's one.
And returns -EINVAL error to user psace otherwise.

v2: Put socket on exit.

Reported-by: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfsctl.c               |    5 +++++
 include/linux/sunrpc/svcsock.h |    1 +
 net/sunrpc/svcsock.c           |   16 ++++++++++++++++
 3 files changed, 22 insertions(+)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -699,6 +699,11 @@ static ssize_t __write_ports_addfd(char
 	if (err != 0 || fd < 0)
 		return -EINVAL;
 
+	if (svc_alien_sock(net, fd)) {
+		printk(KERN_ERR "%s: socket net is different to NFSd's one\n", __func__);
+		return -EINVAL;
+	}
+
 	err = nfsd_create_serv(net);
 	if (err != 0)
 		return err;
--- a/include/linux/sunrpc/svcsock.h
+++ b/include/linux/sunrpc/svcsock.h
@@ -56,6 +56,7 @@ int		svc_recv(struct svc_rqst *, long);
 int		svc_send(struct svc_rqst *);
 void		svc_drop(struct svc_rqst *);
 void		svc_sock_update_bufs(struct svc_serv *serv);
+bool		svc_alien_sock(struct net *net, int fd);
 int		svc_addsock(struct svc_serv *serv, const int fd,
 					char *name_return, const size_t len);
 void		svc_init_xprt_sock(void);
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1393,6 +1393,22 @@ static struct svc_sock *svc_setup_socket
 	return svsk;
 }
 
+bool svc_alien_sock(struct net *net, int fd)
+{
+	int err;
+	struct socket *sock = sockfd_lookup(fd, &err);
+	bool ret = false;
+
+	if (!sock)
+		goto out;
+	if (sock_net(sock->sk) != net)
+		ret = true;
+	sockfd_put(sock);
+out:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(svc_alien_sock);
+
 /**
  * svc_addsock - add a listener socket to an RPC service
  * @serv: pointer to RPC service to which to add a new listener


