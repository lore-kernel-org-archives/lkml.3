Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbaGAVsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:48:08 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:43273 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369AbaGAVrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:47:40 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ejZCzW8NRdwTYefHi0JchBpEUIQvhemkXwbmc=
X-RZG-CLASS-ID: mo00
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 27/50] mars: add new file include/linux/xio/xio_bio.h
Date: Tue,  1 Jul 2014 23:47:07 +0200
Message-Id: <1404251250-22992-28-git-send-email-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
---
 include/linux/xio/xio_bio.h | 69 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)
 create mode 100644 include/linux/xio/xio_bio.h

diff --git a/include/linux/xio/xio_bio.h b/include/linux/xio/xio_bio.h
new file mode 100644
index 0000000..73fad4e
--- /dev/null
+++ b/include/linux/xio/xio_bio.h
@@ -0,0 +1,69 @@
+/*  (c) 2010 Thomas Schoebel-Theuer / 1&1 Internet AG */
+#ifndef XIO_BIO_H
+#define XIO_BIO_H
+
+#define BIO_SUBMIT_MAX_LATENCY		250 /*	250 us */
+#define BIO_IO_R_MAX_LATENCY		40000 /*   40 ms */
+#define BIO_IO_W_MAX_LATENCY		100000 /*  100 ms */
+
+extern struct threshold bio_submit_threshold;
+extern struct threshold bio_io_threshold[2];
+
+#include <linux/blkdev.h>
+
+struct bio_aio_aspect {
+	GENERIC_ASPECT(aio);
+	struct list_head io_head;
+	struct bio *bio;
+	struct bio_output *output;
+	unsigned long long start_stamp;
+	int status_code;
+	int hash_pos;
+	int alloc_len;
+	bool do_dealloc;
+};
+
+struct bio_brick {
+	XIO_BRICK(bio);
+	/*  tunables */
+	int ra_pages;
+	int bg_threshold;
+	int bg_maxfly;
+	bool do_noidle;
+	bool do_sync;
+	bool do_unplug;
+
+	/*  readonly */
+	loff_t total_size;
+	atomic_t fly_count[XIO_PRIO_NR];
+	atomic_t queue_count[XIO_PRIO_NR];
+	atomic_t completed_count;
+	atomic_t total_completed_count[XIO_PRIO_NR];
+
+	/*  private */
+	spinlock_t lock;
+	struct list_head queue_list[XIO_PRIO_NR];
+	struct list_head submitted_list[2];
+	struct list_head completed_list;
+
+	wait_queue_head_t submit_event;
+	wait_queue_head_t response_event;
+	struct mapfree_info *mf;
+	struct block_device *bdev;
+	struct task_struct *submit_thread;
+	struct task_struct *response_thread;
+	int bvec_max;
+	bool submitted;
+};
+
+struct bio_input {
+	XIO_INPUT(bio);
+};
+
+struct bio_output {
+	XIO_OUTPUT(bio);
+};
+
+XIO_TYPES(bio);
+
+#endif
-- 
2.0.0

