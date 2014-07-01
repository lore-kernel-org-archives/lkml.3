Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814AbaGAVxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:53:40 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.220]:15873 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbaGAVxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:53:37 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ejZCzW8NRdwTYefHi0JchBpEUIQvhemkXwbmc=
X-RZG-CLASS-ID: mo00
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 35/50] mars: add new file include/linux/xio/xio_copy.h
Date: Tue,  1 Jul 2014 23:47:15 +0200
Message-Id: <1404251250-22992-36-git-send-email-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
---
 include/linux/xio/xio_copy.h | 99 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)
 create mode 100644 include/linux/xio/xio_copy.h

diff --git a/include/linux/xio/xio_copy.h b/include/linux/xio/xio_copy.h
new file mode 100644
index 0000000..d487d52
--- /dev/null
+++ b/include/linux/xio/xio_copy.h
@@ -0,0 +1,99 @@
+/*  (c) 2010 Thomas Schoebel-Theuer / 1&1 Internet AG */
+#ifndef XIO_COPY_H
+#define XIO_COPY_H
+
+#include <linux/wait.h>
+#include <linux/semaphore.h>
+
+#define INPUT_A_IO			0
+#define INPUT_A_COPY			1
+#define INPUT_B_IO			2
+#define INPUT_B_COPY			3
+
+extern int xio_copy_overlap;
+extern int xio_copy_read_prio;
+extern int xio_copy_write_prio;
+extern int xio_copy_read_max_fly;
+extern int xio_copy_write_max_fly;
+
+enum {
+	COPY_STATE_RESET    = -1,
+	COPY_STATE_START = 0, /*  don't change this, it _must_ be zero */
+	COPY_STATE_START2,
+	COPY_STATE_READ1,
+	COPY_STATE_READ2,
+	COPY_STATE_READ3,
+	COPY_STATE_WRITE,
+	COPY_STATE_WRITTEN,
+	COPY_STATE_CLEANUP,
+	COPY_STATE_FINISHED,
+};
+
+struct copy_state {
+	struct aio_object *table[2];
+	bool active[2];
+	char state;
+	bool writeout;
+
+	short prev;
+	short len;
+	short error;
+};
+
+struct copy_aio_aspect {
+	GENERIC_ASPECT(aio);
+	struct copy_brick *brick;
+	int queue;
+};
+
+struct copy_brick {
+	XIO_BRICK(copy);
+	/*  parameters */
+	struct xio_limiter *copy_limiter;
+	loff_t copy_start;
+
+	loff_t copy_end; /*  stop working if == 0 */
+	int io_prio;
+
+	int append_mode; /*  1 = passively, 2 = actively */
+	bool verify_mode; /*  0 = copy, 1 = checksum+compare */
+	bool repair_mode; /*  whether to repair in case of verify errors */
+	bool recheck_mode; /*  whether to re-check after repairs (costs performance) */
+	bool utilize_mode; /*  utilize already copied data */
+	bool abort_mode;  /*  abort on IO error (default is retry forever) */
+	/*  readonly from outside */
+	loff_t copy_last; /*  current working position */
+	struct timespec copy_last_stamp;
+	int copy_error;
+	int copy_error_count;
+	int verify_ok_count;
+	int verify_error_count;
+	bool low_dirty;
+	bool is_aborting;
+
+	/*  internal */
+	bool trigger;
+	unsigned long clash;
+	atomic_t total_clash_count;
+	atomic_t io_flight;
+	atomic_t copy_read_flight;
+	atomic_t copy_write_flight;
+	unsigned long last_jiffies;
+
+	wait_queue_head_t event;
+	struct semaphore mutex;
+	struct task_struct *thread;
+	struct copy_state **st;
+};
+
+struct copy_input {
+	XIO_INPUT(copy);
+};
+
+struct copy_output {
+	XIO_OUTPUT(copy);
+};
+
+XIO_TYPES(copy);
+
+#endif
-- 
2.0.0

