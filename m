Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab3H1Ijm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 04:39:42 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:47006 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab3H1Iji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 04:39:38 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] videobuf2: Fix vb2_write prototype
Date: Wed, 28 Aug 2013 10:39:29 +0200
Message-Id: <1377679169-9374-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct v4_file_operations defines the data param as
const char __user *data but on vb2 is defined as
char __user *data.

This patch fixes the warnings produced by this. ie:

drivers/qtec/qtec_xform.c:817:2: warning: initialization from
incompatible pointer type [enabled by default]
drivers/qtec/qtec_xform.c:817:2: warning: (near initialization for
		‘qtec_xform_v4l_fops.write’) [enabled by default]

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |    7 ++++---
 include/media/videobuf2-core.h           |    4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 9fc4bab..b3f86c1 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2438,10 +2438,11 @@ size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
 }
 EXPORT_SYMBOL_GPL(vb2_read);
 
-size_t vb2_write(struct vb2_queue *q, char __user *data, size_t count,
+size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
 		loff_t *ppos, int nonblocking)
 {
-	return __vb2_perform_fileio(q, data, count, ppos, nonblocking, 0);
+	return __vb2_perform_fileio(q, (char __user *) data, count,
+							ppos, nonblocking, 0);
 }
 EXPORT_SYMBOL_GPL(vb2_write);
 
@@ -2595,7 +2596,7 @@ int vb2_fop_release(struct file *file)
 }
 EXPORT_SYMBOL_GPL(vb2_fop_release);
 
-ssize_t vb2_fop_write(struct file *file, char __user *buf,
+ssize_t vb2_fop_write(struct file *file, const char __user *buf,
 		size_t count, loff_t *ppos)
 {
 	struct video_device *vdev = video_devdata(file);
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index d88a098..06ec850 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -388,7 +388,7 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait);
 size_t vb2_read(struct vb2_queue *q, char __user *data, size_t count,
 		loff_t *ppos, int nonblock);
-size_t vb2_write(struct vb2_queue *q, char __user *data, size_t count,
+size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t count,
 		loff_t *ppos, int nonblock);
 
 /**
@@ -488,7 +488,7 @@ int vb2_ioctl_expbuf(struct file *file, void *priv,
 
 int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma);
 int vb2_fop_release(struct file *file);
-ssize_t vb2_fop_write(struct file *file, char __user *buf,
+ssize_t vb2_fop_write(struct file *file, const char __user *buf,
 		size_t count, loff_t *ppos);
 ssize_t vb2_fop_read(struct file *file, char __user *buf,
 		size_t count, loff_t *ppos);
-- 
1.7.10.4

