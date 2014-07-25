Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964822AbaGYRiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:38:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935313AbaGYRiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:38:14 -0400
From: Abhi Das <adas@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com
Cc: Abhi Das <adas@redhat.com>
Subject: [RFC PATCH 4/5] gfs2: Add sort functionality with extra parameter
Date: Fri, 25 Jul 2014 12:38:07 -0500
Message-Id: <1406309888-10749-5-git-send-email-adas@redhat.com>
In-Reply-To: <1406309888-10749-1-git-send-email-adas@redhat.com>
References: <1406309888-10749-1-git-send-email-adas@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is essentially a copy of the sort function and its helpers
from lib/sort.c with the exception of an additional 'void *opaque'
parameter added here.
custom cmp_func and swap_func functions can make use of the opaque
field for relevant context

Signed-off-by: Abhi Das <adas@redhat.com>
---
 fs/gfs2/util.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/gfs2/util.h |  4 ++++
 2 files changed, 59 insertions(+)

diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 7345489..2c1aee3 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -562,3 +562,58 @@ void vp_reset(struct vbuf *vb)
 	if (vpx)
 		vpx->vp_top = vpx->vp_baseptr;
 }
+
+/* heap sort that takes an opaque context - directly copied from lib/sort.c */
+static void u32_swap(void *opaque, void *a, void *b, int size)
+{
+	u32 t = *(u32 *)a;
+	*(u32 *)a = *(u32 *)b;
+	*(u32 *)b = t;
+}
+
+static void generic_swap(void *opaque, void *a, void *b, int size)
+{
+	char t;
+	do {
+		t = *(char *)a;
+		*(char *)a++ = *(char *)b;
+		*(char *)b++ = t;
+	} while (--size > 0);
+}
+
+void ctx_sort(void *opaque, void *base, size_t num, size_t size,
+	      int (*cmp_func)(void *, const void *, const void *),
+	      void (*swap_func)(void *, void *, void *, int size))
+{
+	int i = (num/2 - 1) * size, n = num * size, c, r;
+
+	if (!swap_func)
+		swap_func = (size == 4 ? u32_swap : generic_swap);
+
+	/* heapify */
+	for ( ; i >= 0; i -= size) {
+		for (r = i; r * 2 + size < n; r  = c) {
+			c = r * 2 + size;
+			if (c < n - size &&
+			    cmp_func(opaque, base + c, base + c + size) < 0)
+				c += size;
+			if (cmp_func(opaque, base + r, base + c) >= 0)
+				break;
+			swap_func(opaque, base + r, base + c, size);
+		}
+	}
+
+	/* sort */
+	for (i = n - size; i > 0; i -= size) {
+		swap_func(opaque, base, base + i, size);
+		for (r = 0; r * 2 + size < i; r = c) {
+			c = r * 2 + size;
+			if (c < i - size &&
+			    cmp_func(opaque, base + c, base + c + size) < 0)
+				c += size;
+			if (cmp_func(opaque, base + r, base + c) >= 0)
+				break;
+			swap_func(opaque, base + r, base + c, size);
+		}
+	}
+}
diff --git a/fs/gfs2/util.h b/fs/gfs2/util.h
index 40fb692..3e10d72 100644
--- a/fs/gfs2/util.h
+++ b/fs/gfs2/util.h
@@ -210,5 +210,9 @@ int vp_read(struct vbuf *vb, void *to, const void *from, size_t count);
 int vp_write(struct vbuf *vb, void *to, const void *from, size_t count);
 int vp_append(struct vbuf *vb, const void *from, size_t count);
 int vp_memset(struct vbuf *vb, void *to, int c, size_t count);
+
+void ctx_sort(void *opaque, void *base, size_t num, size_t size,
+	      int (*cmp_func)(void *, const void *, const void *),
+	      void (*swap_func)(void *, void *, void *, int size));
  
 #endif /* __UTIL_DOT_H__ */
-- 
1.8.1.4

