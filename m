Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761703Ab3IDDQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 23:16:15 -0400
Received: from li226-30.members.linode.com ([173.255.216.30]:44728 "EHLO
	mail.cooperteam.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab3IDDQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 23:16:13 -0400
From: Christopher James Halse Rogers 
	<christopher.halse.rogers@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux-arch@vger.kernel.org,
        robclark@gmail.com, maarten.lankhorst@canonical.com,
        sumit.semwal@linaro.org,
        Christopher James Halse Rogers 
	<christopher.halse.rogers@canonical.com>
Subject: [PATCH] dma-buf: Expose buffer size to userspace (v2)
Date: Wed,  4 Sep 2013 13:15:49 +1000
Message-Id: <1378264549-9185-1-git-send-email-christopher.halse.rogers@canonical.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each dma-buf has an associated size and it's reasonable for userspace
to want to know what it is.

Since userspace already has an fd, expose the size using the
size = lseek(fd, SEEK_END, 0); lseek(fd, SEEK_CUR, 0);
idiom.

v2: Added Daniel's sugeested documentation, with minor fixups

Signed-off-by: Christopher James Halse Rogers <christopher.halse.rogers@canonical.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Tested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 Documentation/dma-buf-sharing.txt | 12 ++++++++++++
 drivers/base/dma-buf.c            | 28 ++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
index 0b23261..849e982 100644
--- a/Documentation/dma-buf-sharing.txt
+++ b/Documentation/dma-buf-sharing.txt
@@ -407,6 +407,18 @@ Being able to mmap an export dma-buf buffer object has 2 main use-cases:
    interesting ways depending upong the exporter (if userspace starts depending
    upon this implicit synchronization).
 
+Other Interfaces Exposed to Userspace on the dma-buf FD
+------------------------------------------------------
+
+- Since kernel 3.12 the dma-buf FD supports the llseek system call, but only
+  with offset=0 and whence=SEEK_END|SEEK_SET. SEEK_SET is supported to allow
+  the usual size discover pattern size = SEEK_END(0); SEEK_SET(0). Every other
+  llseek operation will report -EINVAL.
+
+  If llseek on dma-buf FDs isn't support the kernel will report -ESPIPE for all
+  cases. Userspace can use this to detect support for discovering the dma-buf
+  size using llseek.
+
 Miscellaneous notes
 -------------------
 
diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 6687ba7..c33a857 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -77,9 +77,36 @@ static int dma_buf_mmap_internal(struct file *file, struct vm_area_struct *vma)
 	return dmabuf->ops->mmap(dmabuf, vma);
 }
 
+static loff_t dma_buf_llseek(struct file *file, loff_t offset, int whence)
+{
+	struct dma_buf *dmabuf;
+	loff_t base;
+
+	if (!is_dma_buf_file(file))
+		return -EBADF;
+
+	dmabuf = file->private_data;
+
+	/* only support discovering the end of the buffer,
+	   but also allow SEEK_SET to maintain the idiomatic
+	   SEEK_END(0), SEEK_CUR(0) pattern */
+	if (whence == SEEK_END)
+		base = dmabuf->size;
+	else if (whence == SEEK_SET)
+		base = 0;
+	else
+		return -EINVAL;
+
+	if (offset != 0)
+		return -EINVAL;
+
+	return base + offset;
+}
+
 static const struct file_operations dma_buf_fops = {
 	.release	= dma_buf_release,
 	.mmap		= dma_buf_mmap_internal,
+	.llseek		= dma_buf_llseek,
 };
 
 /*
@@ -133,6 +160,7 @@ struct dma_buf *dma_buf_export_named(void *priv, const struct dma_buf_ops *ops,
 	dmabuf->exp_name = exp_name;
 
 	file = anon_inode_getfile("dmabuf", &dma_buf_fops, dmabuf, flags);
+	file->f_mode |= FMODE_LSEEK;
 
 	dmabuf->file = file;
 
-- 
1.8.3.2

