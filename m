Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3HEGaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 02:30:21 -0400
Received: from li226-30.members.linode.com ([173.255.216.30]:59978 "EHLO
	mail.cooperteam.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab3HEGaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 02:30:19 -0400
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Aug 2013 02:30:19 EDT
From: Christopher James Halse Rogers 
	<christopher.halse.rogers@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux-arch@vger.kernel.org,
        robclark@gmail.com, maarten.lankhorst@canonical.com,
        sumit.semwal@linaro.org,
        Christopher James Halse Rogers 
	<christopher.halse.rogers@canonical.com>
Subject: [PATCH] dma-buf: Expose buffer size to userspace
Date: Mon,  5 Aug 2013 16:22:00 +1000
Message-Id: <1375683720-4748-1-git-send-email-christopher.halse.rogers@canonical.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each dma-buf has an associated size and it's reasonable for userspace
to want to know what it is.

Since userspace already has an fd, expose the size using the
size = lseek(fd, SEEK_END, 0); lseek(fd, SEEK_CUR, 0);
idiom.

Signed-off-by: Christopher James Halse Rogers <christopher.halse.rogers@canonical.com>
---

I've run into a point in the radeon DRM userspace where I need the
size of a dma-buf. I could add a radeon-specific mechanism to get that,
but this seems like something that would be more generally useful.

I'm not entirely sure about supporting both SEEK_END and SEEK_CUR; this
is somewhat of an abuse of lseek, as seeking obviously doesn't make sense.
It's the obivous idiom for getting the size of what's on the other end of a
file descriptor, though.

I didn't notice anywhere to document this; Documentation/dma-buf-api didn't
seem like the right place. Is there somewhere I've overlooked?

 drivers/base/dma-buf.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

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

