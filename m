Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935362AbaGYRjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:39:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934323AbaGYRiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:38:13 -0400
From: Abhi Das <adas@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com
Cc: Abhi Das <adas@redhat.com>
Subject: [RFC PATCH 3/5] gfs2: Add a dynamic buffer backed by a vector of pages
Date: Fri, 25 Jul 2014 12:38:06 -0500
Message-Id: <1406309888-10749-4-git-send-email-adas@redhat.com>
In-Reply-To: <1406309888-10749-1-git-send-email-adas@redhat.com>
References: <1406309888-10749-1-git-send-email-adas@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new buffer called 'vbuf' that is backed by a
vector of pages. It is dynamic and can be expanded as needed with
low overhead.

Signed-off-by: Abhi Das <adas@redhat.com>
---
 fs/gfs2/util.c | 299 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/gfs2/util.h |  43 +++++++++
 2 files changed, 342 insertions(+)

diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 86d2035..7345489 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -263,3 +263,302 @@ int gfs2_io_error_bh_i(struct gfs2_sbd *sdp, struct buffer_head *bh,
 	return rv;
 }
 
+/*
+ * Fast vector-of-pages backed buffer
+ */
+
+static int vp_alloc_pages(struct vp_ctx *vpx, int start, int end)
+{
+	int i;
+
+	for (i = start; i < end; i++) {
+		vpx->vp_pages[i] = alloc_page(GFP_KERNEL | GFP_NOFS);
+		if (vpx->vp_pages[i] == NULL)
+			goto free;
+	}
+	return 0;
+free:
+	for (i = start; i < end; i++)
+		if (vpx->vp_pages[i]) {
+			__free_page(vpx->vp_pages[i]);
+			vpx->vp_pages[i] = NULL;
+		}
+	return -ENOMEM;
+}
+
+static void vp_free_pages(struct vp_ctx *vpx)
+{
+	int i;
+
+	for (i = 0; i < vpx->vp_size; i++)
+		if (vpx->vp_pages[i]) {
+			__free_page(vpx->vp_pages[i]);
+			vpx->vp_pages[i] = NULL;
+		}
+}
+
+static int vp_extend(struct vp_ctx *vpx, int size)
+{
+	struct gfs2_sbd *sdp = vpx->vp_sdp;
+
+	/* first make room for more pointers */
+	if (size <= 0)
+		return -EINVAL;
+
+	vpx->vp_pages = krealloc(vpx->vp_pages,
+				 sizeof(struct page *) * (vpx->vp_size + size),
+				 GFP_KERNEL);
+	if (vpx->vp_pages == NULL)
+		goto out;
+
+	/* Zero out the new pointers and allocate pages*/
+	memset(&vpx->vp_pages[vpx->vp_size], 0, sizeof(struct page *) * size);
+	if (vp_alloc_pages(vpx, vpx->vp_size, vpx->vp_size + size))
+		goto out;
+
+	vpx->vp_size += size;
+	return 0;
+out:
+	return -ENOMEM;
+}
+
+int vp_init(struct gfs2_sbd *sdp, struct vbuf *vb, int init_cap)
+{
+	int cap, err = -ENOMEM;
+	struct vp_ctx *vpx;
+
+	cap = DIV_ROUND_UP(init_cap, PAGE_SIZE);
+
+	vpx = kmalloc(sizeof(struct vp_ctx), GFP_KERNEL);
+	if (vpx == NULL)
+		goto out;
+
+	vpx->vp_magic = VP_MAGIC;
+	vpx->vp_size = cap;
+	vpx->vp_pages = kzalloc(sizeof(struct page *) * cap, GFP_KERNEL);
+	if (vpx->vp_pages == NULL)
+		goto free;
+
+	if (vp_alloc_pages(vpx, 0, cap))
+		goto free_all;
+
+	vpx->vp_baseptr = vpx->vp_top = page_address(vpx->vp_pages[0]);
+	vpx->vp_sdp = sdp;
+	vb->v_ptr = vpx->vp_baseptr;
+	vb->v_opaque = vpx;
+
+	err = 0;
+	goto out;
+
+free_all:
+	vp_free_pages(vpx);
+	kfree(vpx->vp_pages);
+free:
+	kfree(vpx);
+	vpx = NULL;
+out:
+	return err;
+}
+
+void vp_uninit(struct vbuf *vb)
+{
+	struct vp_ctx *vpx;
+
+	if (!vb || !vb->v_opaque)
+		return;
+
+	vpx = vb->v_opaque;
+	if (vpx->vp_magic != VP_MAGIC)
+		return;
+
+	vp_free_pages(vpx);
+	kfree(vpx->vp_pages);
+	kfree(vpx);
+	vb->v_ptr = vb->v_opaque = NULL;
+}
+
+static int vp_rw_pages(struct vp_ctx *vpx, void *to, const void *from,
+		       size_t count, int what)
+{
+	int pg_ind, pg_off, bytes, rw = 0;
+
+	while (count > 0) {
+		pg_ind = what == VP_READ ? VP_PAGE_INDEX(vpx, from)
+			: VP_PAGE_INDEX(vpx, to);
+		pg_off = what == VP_READ ? VP_PAGE_OFFSET(vpx, from)
+			: VP_PAGE_OFFSET(vpx, to);
+		bytes = what == VP_READ ? VP_PAGE_BYTES_LEFT(vpx, from)
+			: VP_PAGE_BYTES_LEFT(vpx, to);
+		bytes = min(count, (size_t) bytes);
+
+		if (what == VP_READ)
+			memcpy(to, VP_PAGE_PTR(vpx, pg_ind, pg_off), bytes);
+		else {
+			if (what == VP_WRITE)
+				memcpy(VP_PAGE_PTR(vpx, pg_ind, pg_off),
+				       from, bytes);
+			else if (what == VP_MEMSET)
+				memset(VP_PAGE_PTR(vpx, pg_ind, pg_off),
+				       (*(const int*)from), bytes);
+			if ((to + count) > vpx->vp_top)
+				vpx->vp_top = to + count;
+		}
+		to += bytes;
+		if (what != VP_MEMSET)
+			from += bytes;
+		rw += bytes;
+		count -= bytes;
+	}
+	return rw;
+}
+
+struct vp_ctx* vp_get_vpx(struct vbuf *vb)
+{
+	struct vp_ctx *vpx = NULL;
+
+	if (!vb || !vb->v_opaque)
+		goto out;
+
+	vpx = vb->v_opaque;
+	if (vpx->vp_magic != VP_MAGIC) {
+		vpx = NULL;
+		goto out;
+	}
+out:
+	return vpx;
+}
+
+int vp_read(struct vbuf *vb, void *to, const void *from, size_t count)
+{
+	struct vp_ctx *vpx;
+	void *buf_end = NULL;
+	int err = -EINVAL;
+
+	vpx = vp_get_vpx(vb);
+	if (!vpx)
+		return err;
+
+	buf_end = vpx->vp_baseptr + PAGE_SIZE * vpx->vp_size;
+	if (count <= 0 || (from + count > buf_end))
+		return err;
+
+	return vp_rw_pages(vpx, to, from, count, VP_READ);
+}
+
+int vp_write_i(struct vp_ctx *vpx, void *to, const void *from,
+	       size_t count, int what)
+{
+	int err = -EINVAL;
+	void *buf_end = NULL;
+
+	/* Check to see if the write will fall within limits */
+	buf_end = vpx->vp_baseptr + PAGE_SIZE * vpx->vp_size;
+	if (to < vpx->vp_baseptr ||
+	    (to + count) > (buf_end + PAGE_SIZE * VP_MAX_ALLOC_STEP))
+		return err;
+
+	if ((to + count) > buf_end) {
+		err = vp_extend(vpx, DIV_ROUND_UP(to + count - buf_end,
+						  PAGE_SIZE));
+		if (err)
+			return err;
+	}
+	return vp_rw_pages(vpx, to, from, count, what);
+}
+
+int vp_write(struct vbuf *vb, void *to, const void *from, size_t count)
+{
+	struct vp_ctx *vpx;
+	int err = -EINVAL;
+
+	if (count <= 0 || count > VP_MAX_WRITE)
+		return err;
+
+	vpx = vp_get_vpx(vb);
+	if (!vpx)
+		return err;
+
+	return vp_write_i(vpx, to, from, count, VP_WRITE);
+}
+
+int vp_append(struct vbuf *vb, const void *from, size_t count)
+{
+	struct vp_ctx *vpx;
+	int err = -EINVAL;
+
+	if (count <= 0 || count > VP_MAX_WRITE)
+		return err;
+
+	vpx = vp_get_vpx(vb);
+	if (!vpx)
+		return err;
+	
+	return vp_write_i(vpx, vpx->vp_top, from, count, VP_WRITE);
+}
+
+int vp_memset(struct vbuf *vb, void *to, int c, size_t count)
+{
+	struct vp_ctx *vpx;
+	int err = -EINVAL;
+
+	if (count <= 0 || count > VP_MAX_WRITE)
+		return err;
+
+	vpx = vp_get_vpx(vb);
+	if (!vpx)
+		return err;
+
+	err = vp_write_i(vpx, to, &c, count, VP_MEMSET);
+
+	return err;
+}
+
+/*
+ * Returns the linear ptr to the top of this buffer
+ */
+void* vp_get_top(struct vbuf *vb)
+{
+	struct vp_ctx *vpx;
+	vpx = vp_get_vpx(vb);
+	if (!vpx)
+		return NULL;
+	else
+		return vpx->vp_top;
+}
+
+/*
+ * vp_get_page_count: Returns # of pages allocated to this buffer
+ */
+size_t vp_get_page_count(struct vbuf *vb)
+{
+	struct vp_ctx *vpx;
+	vpx = vp_get_vpx(vb);
+	if (!vpx)
+		return -EINVAL;
+	return vpx->vp_size;
+}
+
+/*
+ * vp_get_size: Returns number of bytes used in this buffer
+ */
+size_t vp_get_size(struct vbuf *vb)
+{
+	struct vp_ctx *vpx;
+	vpx = vp_get_vpx(vb);
+	if (!vpx)
+		return -EINVAL;
+	return vpx->vp_top - vpx->vp_baseptr;
+}
+
+/*
+ * vp_reset: Doesn't deallocate, simply moves
+ * vp_top to vp_baseptr, making the entire buffer
+ * available for writing.
+ */
+void vp_reset(struct vbuf *vb)
+{
+	struct vp_ctx *vpx;
+	vpx = vp_get_vpx(vb);
+	if (vpx)
+		vpx->vp_top = vpx->vp_baseptr;
+}
diff --git a/fs/gfs2/util.h b/fs/gfs2/util.h
index cbdcbdf..40fb692 100644
--- a/fs/gfs2/util.h
+++ b/fs/gfs2/util.h
@@ -16,6 +16,7 @@
 #endif
 
 #include <linux/mempool.h>
+#include <linux/slab.h>
 
 #include "incore.h"
 
@@ -168,4 +169,46 @@ gfs2_tune_get_i(&(sdp)->sd_tune, &(sdp)->sd_tune.field)
 __printf(2, 3)
 int gfs2_lm_withdraw(struct gfs2_sbd *sdp, const char *fmt, ...);
 
+/*
+ * Fast buffer backed by vector of pages.
+ * Always allocate one page at a time
+ */
+struct vbuf {
+	void    *v_ptr;
+	void    *v_opaque;
+};
+
+struct vp_ctx {
+	struct gfs2_sbd *vp_sdp;
+	unsigned int     vp_magic;
+	void            *vp_baseptr;
+	void            *vp_top;
+	unsigned long    vp_size; /* size in pages (for bytes, * PAGE_SIZE) */
+	struct page    **vp_pages;
+};
+
+#define VP_MAGIC           0xfabd1cc5
+#define VP_MAX_WRITE       (PAGE_SIZE * 1024)
+#define VP_MAX_ALLOC_STEP  128 /* Can only alloc these many pages at a time */
+
+#define VP_READ    1
+#define VP_WRITE   2
+#define VP_MEMSET  3
+
+#define VP_PAGE_INDEX(vpx, a)      (((char*)a - (char*)vpx->vp_baseptr) / PAGE_SIZE)
+#define VP_PAGE_OFFSET(vpx, a)     (((char*)a - (char*)vpx->vp_baseptr) % PAGE_SIZE)
+#define VP_PAGE_BYTES_LEFT(vpx, a) (PAGE_SIZE - VP_PAGE_OFFSET(vpx, a))
+#define VP_PAGE_PTR(vpx, ind, off) (page_address(vpx->vp_pages[ind]) + off)
+
+int vp_init(struct gfs2_sbd *sdp, struct vbuf *vb, int init_cap);
+void vp_uninit(struct vbuf *vb);
+void* vp_get_top(struct vbuf *vb);
+size_t vp_get_size(struct vbuf *vb);
+size_t vp_get_page_count(struct vbuf *vb);
+void vp_reset(struct vbuf *vb);
+int vp_read(struct vbuf *vb, void *to, const void *from, size_t count);
+int vp_write(struct vbuf *vb, void *to, const void *from, size_t count);
+int vp_append(struct vbuf *vb, const void *from, size_t count);
+int vp_memset(struct vbuf *vb, void *to, int c, size_t count);
+ 
 #endif /* __UTIL_DOT_H__ */
-- 
1.8.1.4

