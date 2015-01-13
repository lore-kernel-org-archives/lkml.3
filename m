Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbbAMNqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:46:36 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38878 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbbAMNpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:45:04 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Paul Clements <Paul.Clements@steeleye.com>
Cc: nbd-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Markus Pargmann <mpa@pengutronix.de>
Subject: [RFC 4/4] nbd: Add support for nbd as root device
Date: Tue, 13 Jan 2015 14:44:25 +0100
Message-Id: <1421156665-27318-5-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421156665-27318-1-git-send-email-mpa@pengutronix.de>
References: <1421156665-27318-1-git-send-email-mpa@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to nbd to use it as a root device. This code essentially
provides a minimal nbd-client implementation within the kernel. It opens
a socket and makes the negotiation with the server. Afterwards it passes
the socket to the normal nbd-code to handle the connection.

The arguments for the server are passed via module parameter. The
module parameter has the format
'[<SERVER_IP>:]<SERVER_PORT>/<EXPORT_NAME>'.
SERVER_IP is optional. If it is not available it will use the
root_server_addr transmitted through DHCP.

Based on those arguments, the connection to the server is established
and is connected to the nbd0 device. The rootdevice therefore is
root=/dev/nbd0.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---
 drivers/block/nbd.c | 306 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 306 insertions(+)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 11f7644be111..ac881ae3c15a 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -32,12 +32,17 @@
 #include <net/sock.h>
 #include <linux/net.h>
 #include <linux/kthread.h>
+#include <net/ipconfig.h>
+#include <linux/in.h>
+#include <linux/tcp.h>
 
 #include <asm/uaccess.h>
 #include <asm/types.h>
 
 #include <linux/nbd.h>
 
+#define ADDR_NONE cpu_to_be32(INADDR_NONE)
+
 #define NBD_MAGIC 0x68797548
 
 #ifdef NDEBUG
@@ -71,6 +76,20 @@ static int max_part;
  */
 static DEFINE_SPINLOCK(nbd_lock);
 
+static const char nbd_magic[] = "NBDMAGIC";
+static const u64 nbd_opts_magic = 0x49484156454F5054LL;
+
+/* Options used for the kernel driver */
+#define NBD_OPT_EXPORT_NAME 1
+
+#define NBD_DEFAULT_BLOCKSIZE 1024
+
+extern __be32 root_nfs_parse_addr(char *name);
+
+static __be32 nbd_server_addr = ADDR_NONE;
+static __be32 nbd_server_port;
+static char nbd_server_export[128] = "";
+
 #ifndef NDEBUG
 static const char *ioctl_cmd_to_ascii(int cmd)
 {
@@ -105,6 +124,52 @@ static const char *nbdcmd_to_ascii(int cmd)
 }
 #endif /* NDEBUG */
 
+/*
+ * Parse format "[<SERVER_IP>:]<SERVER_PORT>/<EXPORT_NAME>"
+ */
+static int nbd_server_addr_set(const char *val, const struct kernel_param *kp)
+{
+	char *export;
+	u16 port;
+	int ret;
+	char buf[128];
+
+	strncpy(buf, val, 128);
+
+	nbd_server_addr = root_nfs_parse_addr(buf);
+
+	if (*buf == '\0') {
+		ret = -EINVAL;
+		goto free_buf;
+	}
+	export = strchr(buf, '/');
+	if (!export || *(export + 1) == '\0') {
+		ret = -EINVAL;
+		goto free_buf;
+	}
+	*export = '\0';
+	++export;
+
+	ret = kstrtou16(buf, 10, &port);
+	if (ret)
+		goto free_buf;
+
+	memmove(buf, export, strlen(export) + 1);
+
+	nbd_server_port = htons(port);
+	strcpy(nbd_server_export, export);
+
+	return 0;
+
+free_buf:
+	kfree(buf);
+	return ret;
+}
+
+static const struct kernel_param_ops nbd_server_addr_ops = {
+	.set = nbd_server_addr_set,
+};
+
 static void nbd_end_request(struct request *req)
 {
 	int error = req->errors ? -EIO : 0;
@@ -856,6 +921,245 @@ static const struct block_device_operations nbd_fops =
 	.ioctl =	nbd_ioctl,
 };
 
+static int nbd_connect(struct socket **socket)
+{
+	struct socket *sock;
+	struct sockaddr_in sockaddr;
+	int err;
+	char val;
+
+	err = sock_create_kern(AF_INET, SOCK_STREAM, IPPROTO_TCP, &sock);
+	if (err < 0)
+		return err;
+
+	sockaddr.sin_family = AF_INET;
+	sockaddr.sin_addr.s_addr = root_server_addr;
+	sockaddr.sin_port = nbd_server_port;
+
+	val = 1;
+	sock->ops->setsockopt(sock, IPPROTO_TCP, TCP_NODELAY, &val,
+			      sizeof(val));
+
+	err = sock->ops->connect(sock, (struct sockaddr *)&sockaddr,
+				 sizeof(sockaddr), 0);
+	if (err < 0)
+		return err;
+
+	*socket = sock;
+
+	return 0;
+}
+
+static int nbd_connection_negotiate(struct nbd_device *nbd, char *export_name,
+				    size_t *rsize, u16 *nflags)
+{
+	char buf[256];
+	int ret;
+	u64 magic;
+	u16 flags;
+	u32 client_flags;
+	u32 opt;
+	u32 name_len;
+	u64 nbd_size;
+
+	ret = sock_xmit(nbd, 0, buf, 8, 0);
+	if (ret < 0)
+		return ret;
+
+	if (strncmp(buf, nbd_magic, 8))
+		return -EINVAL;
+
+	ret = sock_xmit(nbd, 0, &magic, sizeof(magic), 0);
+	if (ret < 0)
+		return ret;
+	magic = be64_to_cpu(magic);
+
+	if (magic != nbd_opts_magic)
+		return -EINVAL;
+
+	ret = sock_xmit(nbd, 0, &flags, sizeof(flags), 0);
+	if (ret < 0)
+		return ret;
+
+	*nflags = ntohs(flags);
+
+	client_flags = 0;
+
+	ret = sock_xmit(nbd, 1, &client_flags, sizeof(client_flags), 0);
+	if (ret < 0)
+		return ret;
+
+	magic = cpu_to_be64(nbd_opts_magic);
+	ret = sock_xmit(nbd, 1, &magic, sizeof(magic), 0);
+	if (ret < 0)
+		return ret;
+
+	opt = htonl(NBD_OPT_EXPORT_NAME);
+	ret = sock_xmit(nbd, 1, &opt, sizeof(opt), 0);
+	if (ret < 0)
+		return ret;
+
+	name_len = strlen(export_name);
+	name_len = htonl(name_len);
+	ret = sock_xmit(nbd, 1, &name_len, sizeof(name_len), 0);
+	if (ret < 0)
+		return ret;
+
+	ret = sock_xmit(nbd, 1, export_name, strlen(export_name), 0);
+	if (ret < 0)
+		return ret;
+
+	ret = sock_xmit(nbd, 0, &nbd_size, sizeof(nbd_size), 0);
+	if (ret < 0)
+		return ret;
+	nbd_size = be64_to_cpu(nbd_size);
+
+	ret = sock_xmit(nbd, 0, &flags, sizeof(flags), 0);
+	if (ret < 0)
+		return ret;
+	*nflags |= ntohs(flags);
+
+	ret = sock_xmit(nbd, 0, buf, 124, 0);
+	if (ret < 0)
+		return ret;
+
+	*rsize = nbd_size;
+
+	return 0;
+}
+
+struct nbd_bdev {
+	struct block_device *bdev;
+	struct nbd_device *nbd;
+};
+
+static int nbd_connection_handler_thread(void *data)
+{
+	struct nbd_bdev *nbd_bdev = data;
+	struct nbd_device *nbd = nbd_bdev->nbd;
+	int ret;
+
+	mutex_lock(&nbd->tx_lock);
+	ret = nbd_connection_handler(nbd_bdev->bdev, nbd_bdev->nbd);
+	mutex_unlock(&nbd->tx_lock);
+
+	return ret;
+}
+
+static int nbd_bind_connection(struct block_device *bdev,
+			       struct nbd_device *nbd, struct socket *sock,
+			       size_t rsize, u32 flags)
+{
+	struct nbd_bdev *nbd_bdev;
+	struct task_struct *thread;
+
+	nbd_bdev = kmalloc(sizeof(*nbd_bdev), GFP_KERNEL);
+	if (!nbd_bdev)
+		return -ENOMEM;
+
+	nbd_bdev->bdev = bdev;
+	nbd_bdev->nbd = nbd;
+
+	mutex_lock(&nbd->tx_lock);
+
+	nbd->flags = flags;
+
+	nbd_set_blksize(bdev, nbd, 4096);
+	nbd_set_total_size(bdev, nbd, rsize);
+	nbd_set_blksize(bdev, nbd, NBD_DEFAULT_BLOCKSIZE);
+
+	/*
+	 *mutex_unlock(&nbd->tx_lock);
+	 *nbd_ioctl(bdev, 0, NBD_CLEAR_SOCK, 0);
+	 *mutex_lock(&nbd->tx_lock);
+	 */
+
+	nbd_set_sock(bdev, nbd, sock);
+	nbd_set_timeout(nbd, 2);
+	mutex_unlock(&nbd->tx_lock);
+
+	thread = kthread_run(nbd_connection_handler_thread, nbd_bdev,
+			     "nbd_connection_handler");
+	if (IS_ERR(thread))
+		return PTR_ERR(thread);
+
+	return 0;
+}
+
+static int nbd_setup_bdev(struct nbd_device *nbd, size_t rsize, u16 flags)
+{
+	struct block_device *bdev;
+	int ret;
+
+	bdev = blkdev_get_by_dev(disk_devt(nbd->disk),
+				 FMODE_READ | FMODE_WRITE, nbd->sock);
+	if (IS_ERR(bdev))
+		return PTR_ERR(bdev);
+
+	ret = nbd_bind_connection(bdev, nbd, nbd->sock, rsize, flags);
+
+	return ret;
+}
+
+/*
+ * nbd_root - Called to initialize a root nbd device for booting from nbd0
+ */
+static int nbd_root(void)
+{
+	struct nbd_device *nbd;
+	struct socket *sock;
+	int ret;
+	size_t rsize;
+	u16 flags;
+
+	/* No kernel argument was given, or there were errors parsing it */
+	if (nbd_server_port == 0)
+		return 0;
+
+	if (!strlen(nbd_server_export)) {
+		pr_err("NBD-root: Missing export name\n");
+		return -EINVAL;
+	}
+
+	if (nbd_server_addr == ADDR_NONE) {
+		if (root_server_addr == ADDR_NONE) {
+			pr_err("NBD-root: Failed to find server address\n");
+			return -EINVAL;
+		}
+		nbd_server_addr = root_server_addr;
+	}
+
+	ret = nbd_connect(&sock);
+	if (ret) {
+		pr_err("NBD-root: nbd_connect failed %d\n", ret);
+		return ret;
+	}
+
+	nbd = &nbd_dev[0];
+	nbd->sock = sock;
+
+	ret = nbd_connection_negotiate(nbd, nbd_server_export, &rsize, &flags);
+	if (ret) {
+		pr_err("NBD-root: nbd_connection_negotiate failed %d\n", ret);
+		goto remove_sock;
+	}
+
+	ret = nbd_setup_bdev(nbd, rsize, flags);
+	if (ret) {
+		pr_err("NBD-root: nbd_setup_bdev failed %d\n", ret);
+		goto remove_sock;
+	}
+
+	return 0;
+
+remove_sock:
+	nbd->sock = NULL;
+	return ret;
+}
+
+/* We need this in late_initcall_sync to be sure that the network is setup */
+late_initcall_sync(nbd_root);
+
 /*
  * And here should be modules and kernel interface 
  *  (Just smiley confuses emacs :-)
@@ -991,6 +1295,8 @@ module_param(nbds_max, int, 0444);
 MODULE_PARM_DESC(nbds_max, "number of network block devices to initialize (default: 16)");
 module_param(max_part, int, 0444);
 MODULE_PARM_DESC(max_part, "number of partitions per device (default: 0)");
+module_param_cb(root_server, &nbd_server_addr_ops, NULL, 0);
+MODULE_PARM_DESC(root_server, "root server address for rootfs on a nbd. Format is [<SERVER_IP>:]<SERVER_PORT>/<EXPORT_NAME>.");
 #ifndef NDEBUG
 module_param(debugflags, int, 0644);
 MODULE_PARM_DESC(debugflags, "flags for controlling debug output");
-- 
2.1.4

