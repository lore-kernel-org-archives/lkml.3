Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030280AbaGAWCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 18:02:30 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:30244 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584AbaGAVrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:47:41 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ejZCzW8NRdwTYefHi0JchBpEUIQvhemkXwbmc=
X-RZG-CLASS-ID: mo00
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 29/50] mars: add new file include/linux/xio/xio_aio.h
Date: Tue,  1 Jul 2014 23:47:09 +0200
Message-Id: <1404251250-22992-30-git-send-email-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
---
 include/linux/xio/xio_aio.h | 96 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 96 insertions(+)
 create mode 100644 include/linux/xio/xio_aio.h

diff --git a/include/linux/xio/xio_aio.h b/include/linux/xio/xio_aio.h
new file mode 100644
index 0000000..776a28c
--- /dev/null
+++ b/include/linux/xio/xio_aio.h
@@ -0,0 +1,96 @@
+/*  (c) 2010 Thomas Schoebel-Theuer / 1&1 Internet AG */
+#ifndef XIO_AIO_H
+#define XIO_AIO_H
+
+#include <linux/aio.h>
+#include <linux/syscalls.h>
+
+#include <linux/lib_mapfree.h>
+
+#define AIO_SUBMIT_MAX_LATENCY		1000 /*    1 ms */
+#define AIO_IO_R_MAX_LATENCY		50000 /*   50 ms */
+#define AIO_IO_W_MAX_LATENCY		150000 /*  150 ms */
+#define AIO_SYNC_MAX_LATENCY		150000 /*  150 ms */
+
+extern struct threshold aio_submit_threshold;
+extern struct threshold aio_io_threshold[2];
+extern struct threshold aio_sync_threshold;
+
+/* aio_sync_mode:
+ *  0 = filemap_write_and_wait_range()
+ *  1 = fdatasync()
+ *  2 = fsync()
+ */
+extern int aio_sync_mode;
+
+struct aio_aio_aspect {
+	GENERIC_ASPECT(aio);
+	struct list_head io_head;
+	struct dirty_info di;
+	unsigned long long enqueue_stamp;
+	long long start_jiffies;
+	int resubmit;
+	int alloc_len;
+	bool do_dealloc;
+};
+
+struct aio_brick {
+	XIO_BRICK(aio);
+	/*  parameters */
+	bool o_creat;
+	bool o_direct;
+	bool o_fdsync;
+	bool is_static_device;
+};
+
+struct aio_input {
+	XIO_INPUT(aio);
+};
+
+struct aio_threadinfo {
+	struct list_head aio_list[XIO_PRIO_NR];
+	struct aio_output *output;
+	struct task_struct *thread;
+
+	wait_queue_head_t event;
+	wait_queue_head_t terminate_event;
+	spinlock_t lock;
+	int queued[XIO_PRIO_NR];
+	atomic_t queued_sum;
+	atomic_t total_enqueue_count;
+	bool terminated;
+};
+
+struct aio_output {
+	XIO_OUTPUT(aio);
+	/*  private */
+	struct mapfree_info *mf;
+
+	int fd; /*  FIXME: remove this! */
+	struct aio_threadinfo tinfo[3];
+
+	aio_context_t ctxp;
+	wait_queue_head_t fdsync_event;
+	bool fdsync_active;
+
+	/*  statistics */
+	int index;
+	atomic_t total_read_count;
+	atomic_t total_write_count;
+	atomic_t total_alloc_count;
+	atomic_t total_submit_count;
+	atomic_t total_again_count;
+	atomic_t total_delay_count;
+	atomic_t total_msleep_count;
+	atomic_t total_fdsync_count;
+	atomic_t total_fdsync_wait_count;
+	atomic_t total_mapfree_count;
+	atomic_t read_count;
+	atomic_t write_count;
+	atomic_t alloc_count;
+	atomic_t submit_count;
+};
+
+XIO_TYPES(aio);
+
+#endif
-- 
2.0.0

