Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846AbaGAVzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:55:35 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.162]:21881 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444AbaGAVyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:54:00 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ejZCzW8NRdwTYefHi0JchBpEUIQvhemkXwbmc=
X-RZG-CLASS-ID: mo00
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 31/50] mars: add new file include/linux/xio/xio_client.h
Date: Tue,  1 Jul 2014 23:47:11 +0200
Message-Id: <1404251250-22992-32-git-send-email-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
---
 include/linux/xio/xio_client.h | 70 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)
 create mode 100644 include/linux/xio/xio_client.h

diff --git a/include/linux/xio/xio_client.h b/include/linux/xio/xio_client.h
new file mode 100644
index 0000000..86f3eac
--- /dev/null
+++ b/include/linux/xio/xio_client.h
@@ -0,0 +1,70 @@
+/*  (c) 2010 Thomas Schoebel-Theuer / 1&1 Internet AG */
+#ifndef XIO_CLIENT_H
+#define XIO_CLIENT_H
+
+#include <linux/xio_net.h>
+#include <linux/brick/lib_limiter.h>
+
+extern struct xio_limiter client_limiter;
+extern int global_net_io_timeout;
+extern int xio_client_abort;
+
+struct client_aio_aspect {
+	GENERIC_ASPECT(aio);
+	struct list_head io_head;
+	struct list_head hash_head;
+	struct list_head tmp_head;
+	unsigned long submit_jiffies;
+	int alloc_len;
+	bool do_dealloc;
+};
+
+struct client_brick {
+	XIO_BRICK(client);
+	/*  tunables */
+	int max_flying; /*  limit on parallelism */
+	int io_timeout;    /*  > 0: report IO errors after timeout (in seconds) */
+	bool limit_mode;
+
+	/*  readonly from outside */
+	int connection_state; /*  0 = switched off, 1 = not connected, 2 = connected */
+};
+
+struct client_input {
+	XIO_INPUT(client);
+};
+
+struct client_threadinfo {
+	struct task_struct *thread;
+
+	wait_queue_head_t run_event;
+	int restart_count;
+};
+
+struct client_output {
+	XIO_OUTPUT(client);
+	atomic_t fly_count;
+	atomic_t timeout_count;
+	spinlock_t lock;
+	struct list_head aio_list;
+	struct list_head wait_list;
+
+	wait_queue_head_t event;
+	int  last_id;
+	int recv_error;
+	struct xio_socket socket;
+	char *host;
+	char *path;
+	struct client_threadinfo sender;
+	struct client_threadinfo receiver;
+	struct xio_info info;
+
+	wait_queue_head_t info_event;
+	bool get_info;
+	bool got_info;
+	struct list_head *hash_table;
+};
+
+XIO_TYPES(client);
+
+#endif
-- 
2.0.0

