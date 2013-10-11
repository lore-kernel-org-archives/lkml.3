Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab3JKAsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 20:48:38 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57167 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab3JKAsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 20:48:36 -0400
X-AuditID: 9c930179-b7c78ae000003065-7e-52574ae2f91a
From: Minchan Kim <minchan@kernel.org>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org, ch0.han@lge.com, gunho.lee@lge.com,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH] squashfs: enhance parallel I/O
Date: Fri, 11 Oct 2013 09:48:31 +0900
Message-Id: <1381452511-6193-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now squashfs have used for only one stream buffer for decompression
so it hurts concurrent read performance so this patch supprts
multiple decompressor to enhance performance concurrent I/O.

Four 1G file dd read on KVM machine which has 2 CPU and 4G memory.

dd if=test/test1.dat of=/dev/null &
dd if=test/test2.dat of=/dev/null &
dd if=test/test3.dat of=/dev/null &
dd if=test/test4.dat of=/dev/null &

old : 1m39s -> new : 9s

This patch is based on [1].

[1] Squashfs: Refactor decompressor interface and code

Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 fs/squashfs/Kconfig              |   12 +++
 fs/squashfs/Makefile             |    9 +-
 fs/squashfs/decompressor_multi.c |  194 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 214 insertions(+), 1 deletion(-)
 create mode 100644 fs/squashfs/decompressor_multi.c

diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
index c70111e..7a580d0 100644
--- a/fs/squashfs/Kconfig
+++ b/fs/squashfs/Kconfig
@@ -63,6 +63,18 @@ config SQUASHFS_LZO
 
 	  If unsure, say N.
 
+config SQUASHFS_MULTI_DECOMPRESSOR
+	bool "Use multiple decompressor for handling concurrent I/O"
+	depends on SQUASHFS
+	help
+	  By default Squashfs uses a compressor for data but it gives
+	  poor performance on parallel I/O workload of multiple CPU
+	  mahchine due to waitting a compressor available.
+
+	  If workload has parallel I/O and your system has enough memory,
+	  this option may improve overall I/O performance.
+	  If unsure, say N.
+
 config SQUASHFS_XZ
 	bool "Include support for XZ compressed file systems"
 	depends on SQUASHFS
diff --git a/fs/squashfs/Makefile b/fs/squashfs/Makefile
index c223c84..dfebc3b 100644
--- a/fs/squashfs/Makefile
+++ b/fs/squashfs/Makefile
@@ -4,8 +4,15 @@
 
 obj-$(CONFIG_SQUASHFS) += squashfs.o
 squashfs-y += block.o cache.o dir.o export.o file.o fragment.o id.o inode.o
-squashfs-y += namei.o super.o symlink.o decompressor.o decompressor_single.o
+squashfs-y += namei.o super.o symlink.o decompressor.o
+
 squashfs-$(CONFIG_SQUASHFS_XATTR) += xattr.o xattr_id.o
 squashfs-$(CONFIG_SQUASHFS_LZO) += lzo_wrapper.o
 squashfs-$(CONFIG_SQUASHFS_XZ) += xz_wrapper.o
 squashfs-$(CONFIG_SQUASHFS_ZLIB) += zlib_wrapper.o
+
+ifdef CONFIG_SQUASHFS_MULTI_DECOMPRESSOR
+	squashfs-y		+= decompressor_multi.o
+else
+	squashfs-y		+= decompressor_single.o
+endif
diff --git a/fs/squashfs/decompressor_multi.c b/fs/squashfs/decompressor_multi.c
new file mode 100644
index 0000000..23f1e94
--- /dev/null
+++ b/fs/squashfs/decompressor_multi.c
@@ -0,0 +1,194 @@
+/*
+ *  Copyright (c) 2013
+ *  Minchan Kim <minchan@kernel.org>
+ *
+ *  This work is licensed under the terms of the GNU GPL, version 2. See
+ *  the COPYING file in the top-level directory.
+ */
+#include <linux/types.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/buffer_head.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+#include <linux/cpumask.h>
+
+#include "squashfs_fs.h"
+#include "squashfs_fs_sb.h"
+#include "decompressor.h"
+#include "squashfs.h"
+
+/*
+ * This file implements multi-threaded decompression in the
+ * decompressor framework
+ */
+
+
+/*
+ * The reason that multiply two is that a CPU can request new I/O
+ * while it is waitting previous request.
+ */
+#define MAX_DECOMPRESSOR	(num_online_cpus() * 2)
+
+
+int squashfs_max_decompressors(void)
+{
+	return MAX_DECOMPRESSOR;
+}
+
+
+struct squashfs_stream {
+	void			*comp_opts;
+	struct list_head	strm_list;
+	struct mutex		mutex;
+	int			avail_comp;
+	wait_queue_head_t	wait;
+};
+
+
+struct comp_stream {
+	void *stream;
+	struct list_head list;
+};
+
+
+static void put_comp_stream(struct comp_stream *comp_strm,
+				struct squashfs_stream *stream)
+{
+	mutex_lock(&stream->mutex);
+	list_add(&comp_strm->list, &stream->strm_list);
+	mutex_unlock(&stream->mutex);
+	wake_up(&stream->wait);
+}
+
+void *squashfs_decompressor_create(struct squashfs_sb_info *msblk,
+				void *comp_opts)
+{
+	struct squashfs_stream *stream;
+	struct comp_stream *comp_strm = NULL;
+	int err = -ENOMEM;
+
+	stream = kzalloc(sizeof(*stream), GFP_KERNEL);
+	if (!stream)
+		goto out;
+
+	stream->comp_opts = comp_opts;
+	mutex_init(&stream->mutex);
+	INIT_LIST_HEAD(&stream->strm_list);
+	init_waitqueue_head(&stream->wait);
+
+	comp_strm = kmalloc(sizeof(*comp_strm), GFP_KERNEL);
+	if (!comp_strm)
+		goto out;
+
+	comp_strm->stream = msblk->decompressor->init(msblk,
+						stream->comp_opts);
+	if (IS_ERR(comp_strm->stream)) {
+		err = PTR_ERR(comp_strm->stream);
+		goto out;
+	}
+
+	list_add(&comp_strm->list, &stream->strm_list);
+	stream->avail_comp = 1;
+	return stream;
+
+out:
+	kfree(comp_strm);
+	kfree(stream);
+	return ERR_PTR(err);
+}
+
+
+void squashfs_decompressor_destroy(struct squashfs_sb_info *msblk)
+{
+	struct squashfs_stream *stream = msblk->stream;
+	if (stream) {
+		struct comp_stream *comp_strm;
+
+		while (!list_empty(&stream->strm_list)) {
+			comp_strm = list_entry(stream->strm_list.prev,
+						struct comp_stream, list);
+			list_del(&comp_strm->list);
+			msblk->decompressor->free(comp_strm->stream);
+			kfree(comp_strm);
+			stream->avail_comp--;
+		}
+	}
+
+	WARN_ON(stream->avail_comp);
+	kfree(stream->comp_opts);
+	kfree(stream);
+}
+
+
+static struct comp_stream *get_comp_stream(struct squashfs_sb_info *msblk,
+					struct squashfs_stream *stream)
+{
+	struct comp_stream *comp_strm;
+
+	while (1) {
+		mutex_lock(&stream->mutex);
+
+		/* There is available comp_stream */
+		if (!list_empty(&stream->strm_list)) {
+			comp_strm = list_entry(stream->strm_list.prev,
+				struct comp_stream, list);
+			list_del(&comp_strm->list);
+			mutex_unlock(&stream->mutex);
+			break;
+		}
+
+		/*
+		 * If there is no available comp and already full,
+		 * let's wait for releasing comp from other users.
+		 */
+		if (stream->avail_comp >= MAX_DECOMPRESSOR)
+			goto wait;
+
+		/* Let's allocate new comp */
+		comp_strm = kmalloc(sizeof(*comp_strm), GFP_KERNEL);
+		if (!comp_strm)
+			goto wait;
+
+		comp_strm->stream = msblk->decompressor->init(msblk,
+						stream->comp_opts);
+		if (IS_ERR(comp_strm->stream)) {
+			kfree(comp_strm);
+			goto wait;
+		}
+
+		stream->avail_comp++;
+		WARN_ON(stream->avail_comp > MAX_DECOMPRESSOR);
+
+		mutex_unlock(&stream->mutex);
+		break;
+wait:
+		/*
+		 * If system memory is tough, let's for other's
+		 * releasing instead of hurting VM because it could
+		 * make page cache thrashing.
+		 */
+		mutex_unlock(&stream->mutex);
+		wait_event(stream->wait,
+			!list_empty(&stream->strm_list));
+	}
+
+	return comp_strm;
+}
+
+
+int squashfs_decompress(struct squashfs_sb_info *msblk,
+	void **buffer, struct buffer_head **bh, int b, int offset, int length,
+	int srclength, int pages)
+{
+	int res;
+	struct squashfs_stream *stream = msblk->stream;
+	struct comp_stream *comp_stream = get_comp_stream(msblk, stream);
+	res = msblk->decompressor->decompress(msblk, comp_stream->stream,
+		buffer, bh, b, offset, length, srclength, pages);
+	put_comp_stream(comp_stream, stream);
+	if (res < 0)
+		ERROR("%s decompression failed, data probably corrupt\n",
+			msblk->decompressor->name);
+	return res;
+}
-- 
1.7.9.5

