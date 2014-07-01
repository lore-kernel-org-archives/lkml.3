Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbaGAVr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:47:58 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:28262 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399AbaGAVrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:47:39 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ejZCzW8NRdwTYefHi0JchBpEUIQvhemkXwbmc=
X-RZG-CLASS-ID: mo00
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 21/50] mars: add new file include/linux/xio_net.h
Date: Tue,  1 Jul 2014 23:47:01 +0200
Message-Id: <1404251250-22992-22-git-send-email-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
---
 include/linux/xio_net.h | 126 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 126 insertions(+)
 create mode 100644 include/linux/xio_net.h

diff --git a/include/linux/xio_net.h b/include/linux/xio_net.h
new file mode 100644
index 0000000..c9f48f1
--- /dev/null
+++ b/include/linux/xio_net.h
@@ -0,0 +1,126 @@
+/*  (c) 2011 Thomas Schoebel-Theuer / 1&1 Internet AG */
+#ifndef XIO_NET_H
+#define XIO_NET_H
+
+#include <net/sock.h>
+#include <net/ipconfig.h>
+#include <net/tcp.h>
+
+#include <linux/brick/brick.h>
+
+extern int xio_net_default_port;
+extern bool xio_net_is_alive;
+
+#define MAX_DESC_CACHE			16
+
+/* The original struct socket has no refcount. This leads to problems
+ * during long-lasting system calls when racing with socket shutdown.
+ *
+ * The original idea of struct xio_socket was just a small wrapper
+ * adding a refcount and some debugging aid.
+ * Later, some buffering was added in order to take advantage of
+ * kernel_sendpage().
+ * Caching of meta description has also been added.
+ */
+struct xio_socket {
+	struct socket *s_socket;
+	void *s_buffer;
+	atomic_t s_count;
+	int s_pos;
+	int s_debug_nr;
+	int s_send_abort;
+	int s_recv_abort;
+	int s_send_cnt;
+	int s_recv_cnt;
+	bool s_shutdown_on_err;
+	bool s_alive;
+
+	u8   s_send_proto;
+	u8   s_recv_proto;
+	struct xio_desc_cache *s_desc_send[MAX_DESC_CACHE];
+	struct xio_desc_cache *s_desc_recv[MAX_DESC_CACHE];
+};
+
+struct xio_tcp_params {
+	int ip_tos;
+	int tcp_window_size;
+	int tcp_nodelay;
+	int tcp_timeout;
+	int tcp_keepcnt;
+	int tcp_keepintvl;
+	int tcp_keepidle;
+};
+
+extern struct xio_tcp_params default_tcp_params;
+
+enum {
+	CMD_NOP,
+	CMD_NOTIFY,
+	CMD_CONNECT,
+	CMD_GETINFO,
+	CMD_GETENTS,
+	CMD_AIO,
+	CMD_CB,
+};
+
+#define CMD_FLAG_MASK			255
+#define CMD_FLAG_HAS_DATA		256
+
+struct xio_cmd {
+	struct timespec cmd_stamp; /*  for automatic lamport clock */
+	int cmd_code;
+	int cmd_int1;
+
+	/* int cmd_int2; */
+	/* int cmd_int3; */
+	char *cmd_str1;
+
+	/* char *cmd_str2; */
+	/* char *cmd_str3; */
+};
+
+extern const struct meta xio_cmd_meta[];
+
+extern char *(*xio_translate_hostname)(const char *name);
+
+/* Low-level network traffic
+ */
+extern int xio_create_sockaddr(struct sockaddr_storage *addr, const char *spec);
+
+extern int xio_create_socket(struct xio_socket *msock, struct sockaddr_storage *addr, bool is_server);
+extern int xio_accept_socket(struct xio_socket *new_msock, struct xio_socket *old_msock);
+extern bool xio_get_socket(struct xio_socket *msock);
+extern void xio_put_socket(struct xio_socket *msock);
+extern void xio_shutdown_socket(struct xio_socket *msock);
+extern bool xio_socket_is_alive(struct xio_socket *msock);
+
+extern int xio_send_raw(struct xio_socket *msock, const void *buf, int len, bool cork);
+extern int xio_recv_raw(struct xio_socket *msock, void *buf, int minlen, int maxlen);
+
+/* Mid-level generic field data exchange
+ */
+extern int xio_send_struct(struct xio_socket *msock, const void *data, const struct meta *meta);
+#define xio_recv_struct(_sock_, _data_, _meta_)				\
+	({								\
+		_xio_recv_struct(_sock_, _data_, _meta_, __LINE__);	\
+	})
+extern int _xio_recv_struct(struct xio_socket *msock, void *data, const struct meta *meta, int line);
+
+/* High-level transport of xio structures
+ */
+extern int xio_send_dent_list(struct xio_socket *msock, struct list_head *anchor);
+extern int xio_recv_dent_list(struct xio_socket *msock, struct list_head *anchor);
+
+extern int xio_send_aio(struct xio_socket *msock, struct aio_object *aio);
+extern int xio_recv_aio(struct xio_socket *msock, struct aio_object *aio, struct xio_cmd *cmd);
+extern int xio_send_cb(struct xio_socket *msock, struct aio_object *aio);
+extern int xio_recv_cb(struct xio_socket *msock, struct aio_object *aio, struct xio_cmd *cmd);
+
+/***********************************************************************/
+
+/*  init */
+
+extern int init_xio_net(void);
+extern void exit_xio_net(void);
+
+#endif
-- 
2.0.0

