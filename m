Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963AbaBUNAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:00:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47213 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541AbaBUMv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:26 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 096/121] xen: install xen/gntdev.h and xen/gntalloc.h
Date: Fri, 21 Feb 2014 12:48:40 +0000
Message-Id: <1392986945-9693-97-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit 564eb714f5f09ac733c26860d5f0831f213fbdf1 upstream.

xen/gntdev.h and xen/gntalloc.h both provide userspace ABIs so they
should be installed.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/uapi/xen/Kbuild     |   2 +
 include/uapi/xen/gntalloc.h |  82 ++++++++++++++++++++++++
 include/uapi/xen/gntdev.h   | 150 ++++++++++++++++++++++++++++++++++++++++++++
 include/xen/gntalloc.h      |  82 ------------------------
 include/xen/gntdev.h        | 150 --------------------------------------------
 5 files changed, 234 insertions(+), 232 deletions(-)
 create mode 100644 include/uapi/xen/gntalloc.h
 create mode 100644 include/uapi/xen/gntdev.h
 delete mode 100644 include/xen/gntalloc.h
 delete mode 100644 include/xen/gntdev.h

diff --git a/include/uapi/xen/Kbuild b/include/uapi/xen/Kbuild
index 61257cb..5c45962 100644
--- a/include/uapi/xen/Kbuild
+++ b/include/uapi/xen/Kbuild
@@ -1,3 +1,5 @@
 # UAPI Header export list
 header-y += evtchn.h
+header-y += gntalloc.h
+header-y += gntdev.h
 header-y += privcmd.h
diff --git a/include/uapi/xen/gntalloc.h b/include/uapi/xen/gntalloc.h
new file mode 100644
index 0000000..76bd580
--- /dev/null
+++ b/include/uapi/xen/gntalloc.h
@@ -0,0 +1,82 @@
+/******************************************************************************
+ * gntalloc.h
+ *
+ * Interface to /dev/xen/gntalloc.
+ *
+ * Author: Daniel De Graaf <dgdegra@tycho.nsa.gov>
+ *
+ * This file is in the public domain.
+ */
+
+#ifndef __LINUX_PUBLIC_GNTALLOC_H__
+#define __LINUX_PUBLIC_GNTALLOC_H__
+
+/*
+ * Allocates a new page and creates a new grant reference.
+ */
+#define IOCTL_GNTALLOC_ALLOC_GREF \
+_IOC(_IOC_NONE, 'G', 5, sizeof(struct ioctl_gntalloc_alloc_gref))
+struct ioctl_gntalloc_alloc_gref {
+	/* IN parameters */
+	/* The ID of the domain to be given access to the grants. */
+	uint16_t domid;
+	/* Flags for this mapping */
+	uint16_t flags;
+	/* Number of pages to map */
+	uint32_t count;
+	/* OUT parameters */
+	/* The offset to be used on a subsequent call to mmap(). */
+	uint64_t index;
+	/* The grant references of the newly created grant, one per page */
+	/* Variable size, depending on count */
+	uint32_t gref_ids[1];
+};
+
+#define GNTALLOC_FLAG_WRITABLE 1
+
+/*
+ * Deallocates the grant reference, allowing the associated page to be freed if
+ * no other domains are using it.
+ */
+#define IOCTL_GNTALLOC_DEALLOC_GREF \
+_IOC(_IOC_NONE, 'G', 6, sizeof(struct ioctl_gntalloc_dealloc_gref))
+struct ioctl_gntalloc_dealloc_gref {
+	/* IN parameters */
+	/* The offset returned in the map operation */
+	uint64_t index;
+	/* Number of references to unmap */
+	uint32_t count;
+};
+
+/*
+ * Sets up an unmap notification within the page, so that the other side can do
+ * cleanup if this side crashes. Required to implement cross-domain robust
+ * mutexes or close notification on communication channels.
+ *
+ * Each mapped page only supports one notification; multiple calls referring to
+ * the same page overwrite the previous notification. You must clear the
+ * notification prior to the IOCTL_GNTALLOC_DEALLOC_GREF if you do not want it
+ * to occur.
+ */
+#define IOCTL_GNTALLOC_SET_UNMAP_NOTIFY \
+_IOC(_IOC_NONE, 'G', 7, sizeof(struct ioctl_gntalloc_unmap_notify))
+struct ioctl_gntalloc_unmap_notify {
+	/* IN parameters */
+	/* Offset in the file descriptor for a byte within the page (same as
+	 * used in mmap). If using UNMAP_NOTIFY_CLEAR_BYTE, this is the byte to
+	 * be cleared. Otherwise, it can be any byte in the page whose
+	 * notification we are adjusting.
+	 */
+	uint64_t index;
+	/* Action(s) to take on unmap */
+	uint32_t action;
+	/* Event channel to notify */
+	uint32_t event_channel_port;
+};
+
+/* Clear (set to zero) the byte specified by index */
+#define UNMAP_NOTIFY_CLEAR_BYTE 0x1
+/* Send an interrupt on the indicated event channel */
+#define UNMAP_NOTIFY_SEND_EVENT 0x2
+
+#endif /* __LINUX_PUBLIC_GNTALLOC_H__ */
diff --git a/include/uapi/xen/gntdev.h b/include/uapi/xen/gntdev.h
new file mode 100644
index 0000000..5304bd3
--- /dev/null
+++ b/include/uapi/xen/gntdev.h
@@ -0,0 +1,150 @@
+/******************************************************************************
+ * gntdev.h
+ * 
+ * Interface to /dev/xen/gntdev.
+ * 
+ * Copyright (c) 2007, D G Murray
+ * 
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ * 
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ * 
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ * 
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+#ifndef __LINUX_PUBLIC_GNTDEV_H__
+#define __LINUX_PUBLIC_GNTDEV_H__
+
+struct ioctl_gntdev_grant_ref {
+	/* The domain ID of the grant to be mapped. */
+	uint32_t domid;
+	/* The grant reference of the grant to be mapped. */
+	uint32_t ref;
+};
+
+/*
+ * Inserts the grant references into the mapping table of an instance
+ * of gntdev. N.B. This does not perform the mapping, which is deferred
+ * until mmap() is called with @index as the offset.
+ */
+#define IOCTL_GNTDEV_MAP_GRANT_REF \
+_IOC(_IOC_NONE, 'G', 0, sizeof(struct ioctl_gntdev_map_grant_ref))
+struct ioctl_gntdev_map_grant_ref {
+	/* IN parameters */
+	/* The number of grants to be mapped. */
+	uint32_t count;
+	uint32_t pad;
+	/* OUT parameters */
+	/* The offset to be used on a subsequent call to mmap(). */
+	uint64_t index;
+	/* Variable IN parameter. */
+	/* Array of grant references, of size @count. */
+	struct ioctl_gntdev_grant_ref refs[1];
+};
+
+/*
+ * Removes the grant references from the mapping table of an instance of
+ * of gntdev. N.B. munmap() must be called on the relevant virtual address(es)
+ * before this ioctl is called, or an error will result.
+ */
+#define IOCTL_GNTDEV_UNMAP_GRANT_REF \
+_IOC(_IOC_NONE, 'G', 1, sizeof(struct ioctl_gntdev_unmap_grant_ref))
+struct ioctl_gntdev_unmap_grant_ref {
+	/* IN parameters */
+	/* The offset was returned by the corresponding map operation. */
+	uint64_t index;
+	/* The number of pages to be unmapped. */
+	uint32_t count;
+	uint32_t pad;
+};
+
+/*
+ * Returns the offset in the driver's address space that corresponds
+ * to @vaddr. This can be used to perform a munmap(), followed by an
+ * UNMAP_GRANT_REF ioctl, where no state about the offset is retained by
+ * the caller. The number of pages that were allocated at the same time as
+ * @vaddr is returned in @count.
+ *
+ * N.B. Where more than one page has been mapped into a contiguous range, the
+ *      supplied @vaddr must correspond to the start of the range; otherwise
+ *      an error will result. It is only possible to munmap() the entire
+ *      contiguously-allocated range at once, and not any subrange thereof.
+ */
+#define IOCTL_GNTDEV_GET_OFFSET_FOR_VADDR \
+_IOC(_IOC_NONE, 'G', 2, sizeof(struct ioctl_gntdev_get_offset_for_vaddr))
+struct ioctl_gntdev_get_offset_for_vaddr {
+	/* IN parameters */
+	/* The virtual address of the first mapped page in a range. */
+	uint64_t vaddr;
+	/* OUT parameters */
+	/* The offset that was used in the initial mmap() operation. */
+	uint64_t offset;
+	/* The number of pages mapped in the VM area that begins at @vaddr. */
+	uint32_t count;
+	uint32_t pad;
+};
+
+/*
+ * Sets the maximum number of grants that may mapped at once by this gntdev
+ * instance.
+ *
+ * N.B. This must be called before any other ioctl is performed on the device.
+ */
+#define IOCTL_GNTDEV_SET_MAX_GRANTS \
+_IOC(_IOC_NONE, 'G', 3, sizeof(struct ioctl_gntdev_set_max_grants))
+struct ioctl_gntdev_set_max_grants {
+	/* IN parameter */
+	/* The maximum number of grants that may be mapped at once. */
+	uint32_t count;
+};
+
+/*
+ * Sets up an unmap notification within the page, so that the other side can do
+ * cleanup if this side crashes. Required to implement cross-domain robust
+ * mutexes or close notification on communication channels.
+ *
+ * Each mapped page only supports one notification; multiple calls referring to
+ * the same page overwrite the previous notification. You must clear the
+ * notification prior to the IOCTL_GNTALLOC_DEALLOC_GREF if you do not want it
+ * to occur.
+ */
+#define IOCTL_GNTDEV_SET_UNMAP_NOTIFY \
+_IOC(_IOC_NONE, 'G', 7, sizeof(struct ioctl_gntdev_unmap_notify))
+struct ioctl_gntdev_unmap_notify {
+	/* IN parameters */
+	/* Offset in the file descriptor for a byte within the page (same as
+	 * used in mmap). If using UNMAP_NOTIFY_CLEAR_BYTE, this is the byte to
+	 * be cleared. Otherwise, it can be any byte in the page whose
+	 * notification we are adjusting.
+	 */
+	uint64_t index;
+	/* Action(s) to take on unmap */
+	uint32_t action;
+	/* Event channel to notify */
+	uint32_t event_channel_port;
+};
+
+/* Clear (set to zero) the byte specified by index */
+#define UNMAP_NOTIFY_CLEAR_BYTE 0x1
+/* Send an interrupt on the indicated event channel */
+#define UNMAP_NOTIFY_SEND_EVENT 0x2
+
+#endif /* __LINUX_PUBLIC_GNTDEV_H__ */
diff --git a/include/xen/gntalloc.h b/include/xen/gntalloc.h
deleted file mode 100644
index 76bd580..0000000
--- a/include/xen/gntalloc.h
+++ /dev/null
@@ -1,82 +0,0 @@
-/******************************************************************************
- * gntalloc.h
- *
- * Interface to /dev/xen/gntalloc.
- *
- * Author: Daniel De Graaf <dgdegra@tycho.nsa.gov>
- *
- * This file is in the public domain.
- */
-
-#ifndef __LINUX_PUBLIC_GNTALLOC_H__
-#define __LINUX_PUBLIC_GNTALLOC_H__
-
-/*
- * Allocates a new page and creates a new grant reference.
- */
-#define IOCTL_GNTALLOC_ALLOC_GREF \
-_IOC(_IOC_NONE, 'G', 5, sizeof(struct ioctl_gntalloc_alloc_gref))
-struct ioctl_gntalloc_alloc_gref {
-	/* IN parameters */
-	/* The ID of the domain to be given access to the grants. */
-	uint16_t domid;
-	/* Flags for this mapping */
-	uint16_t flags;
-	/* Number of pages to map */
-	uint32_t count;
-	/* OUT parameters */
-	/* The offset to be used on a subsequent call to mmap(). */
-	uint64_t index;
-	/* The grant references of the newly created grant, one per page */
-	/* Variable size, depending on count */
-	uint32_t gref_ids[1];
-};
-
-#define GNTALLOC_FLAG_WRITABLE 1
-
-/*
- * Deallocates the grant reference, allowing the associated page to be freed if
- * no other domains are using it.
- */
-#define IOCTL_GNTALLOC_DEALLOC_GREF \
-_IOC(_IOC_NONE, 'G', 6, sizeof(struct ioctl_gntalloc_dealloc_gref))
-struct ioctl_gntalloc_dealloc_gref {
-	/* IN parameters */
-	/* The offset returned in the map operation */
-	uint64_t index;
-	/* Number of references to unmap */
-	uint32_t count;
-};
-
-/*
- * Sets up an unmap notification within the page, so that the other side can do
- * cleanup if this side crashes. Required to implement cross-domain robust
- * mutexes or close notification on communication channels.
- *
- * Each mapped page only supports one notification; multiple calls referring to
- * the same page overwrite the previous notification. You must clear the
- * notification prior to the IOCTL_GNTALLOC_DEALLOC_GREF if you do not want it
- * to occur.
- */
-#define IOCTL_GNTALLOC_SET_UNMAP_NOTIFY \
-_IOC(_IOC_NONE, 'G', 7, sizeof(struct ioctl_gntalloc_unmap_notify))
-struct ioctl_gntalloc_unmap_notify {
-	/* IN parameters */
-	/* Offset in the file descriptor for a byte within the page (same as
-	 * used in mmap). If using UNMAP_NOTIFY_CLEAR_BYTE, this is the byte to
-	 * be cleared. Otherwise, it can be any byte in the page whose
-	 * notification we are adjusting.
-	 */
-	uint64_t index;
-	/* Action(s) to take on unmap */
-	uint32_t action;
-	/* Event channel to notify */
-	uint32_t event_channel_port;
-};
-
-/* Clear (set to zero) the byte specified by index */
-#define UNMAP_NOTIFY_CLEAR_BYTE 0x1
-/* Send an interrupt on the indicated event channel */
-#define UNMAP_NOTIFY_SEND_EVENT 0x2
-
-#endif /* __LINUX_PUBLIC_GNTALLOC_H__ */
diff --git a/include/xen/gntdev.h b/include/xen/gntdev.h
deleted file mode 100644
index 5304bd3..0000000
--- a/include/xen/gntdev.h
+++ /dev/null
@@ -1,150 +0,0 @@
-/******************************************************************************
- * gntdev.h
- * 
- * Interface to /dev/xen/gntdev.
- * 
- * Copyright (c) 2007, D G Murray
- * 
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License version 2
- * as published by the Free Software Foundation; or, when distributed
- * separately from the Linux kernel or incorporated into other
- * software packages, subject to the following license:
- * 
- * Permission is hereby granted, free of charge, to any person obtaining a copy
- * of this source file (the "Software"), to deal in the Software without
- * restriction, including without limitation the rights to use, copy, modify,
- * merge, publish, distribute, sublicense, and/or sell copies of the Software,
- * and to permit persons to whom the Software is furnished to do so, subject to
- * the following conditions:
- * 
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- * 
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
- * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
- * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
- * IN THE SOFTWARE.
- */
-
-#ifndef __LINUX_PUBLIC_GNTDEV_H__
-#define __LINUX_PUBLIC_GNTDEV_H__
-
-struct ioctl_gntdev_grant_ref {
-	/* The domain ID of the grant to be mapped. */
-	uint32_t domid;
-	/* The grant reference of the grant to be mapped. */
-	uint32_t ref;
-};
-
-/*
- * Inserts the grant references into the mapping table of an instance
- * of gntdev. N.B. This does not perform the mapping, which is deferred
- * until mmap() is called with @index as the offset.
- */
-#define IOCTL_GNTDEV_MAP_GRANT_REF \
-_IOC(_IOC_NONE, 'G', 0, sizeof(struct ioctl_gntdev_map_grant_ref))
-struct ioctl_gntdev_map_grant_ref {
-	/* IN parameters */
-	/* The number of grants to be mapped. */
-	uint32_t count;
-	uint32_t pad;
-	/* OUT parameters */
-	/* The offset to be used on a subsequent call to mmap(). */
-	uint64_t index;
-	/* Variable IN parameter. */
-	/* Array of grant references, of size @count. */
-	struct ioctl_gntdev_grant_ref refs[1];
-};
-
-/*
- * Removes the grant references from the mapping table of an instance of
- * of gntdev. N.B. munmap() must be called on the relevant virtual address(es)
- * before this ioctl is called, or an error will result.
- */
-#define IOCTL_GNTDEV_UNMAP_GRANT_REF \
-_IOC(_IOC_NONE, 'G', 1, sizeof(struct ioctl_gntdev_unmap_grant_ref))
-struct ioctl_gntdev_unmap_grant_ref {
-	/* IN parameters */
-	/* The offset was returned by the corresponding map operation. */
-	uint64_t index;
-	/* The number of pages to be unmapped. */
-	uint32_t count;
-	uint32_t pad;
-};
-
-/*
- * Returns the offset in the driver's address space that corresponds
- * to @vaddr. This can be used to perform a munmap(), followed by an
- * UNMAP_GRANT_REF ioctl, where no state about the offset is retained by
- * the caller. The number of pages that were allocated at the same time as
- * @vaddr is returned in @count.
- *
- * N.B. Where more than one page has been mapped into a contiguous range, the
- *      supplied @vaddr must correspond to the start of the range; otherwise
- *      an error will result. It is only possible to munmap() the entire
- *      contiguously-allocated range at once, and not any subrange thereof.
- */
-#define IOCTL_GNTDEV_GET_OFFSET_FOR_VADDR \
-_IOC(_IOC_NONE, 'G', 2, sizeof(struct ioctl_gntdev_get_offset_for_vaddr))
-struct ioctl_gntdev_get_offset_for_vaddr {
-	/* IN parameters */
-	/* The virtual address of the first mapped page in a range. */
-	uint64_t vaddr;
-	/* OUT parameters */
-	/* The offset that was used in the initial mmap() operation. */
-	uint64_t offset;
-	/* The number of pages mapped in the VM area that begins at @vaddr. */
-	uint32_t count;
-	uint32_t pad;
-};
-
-/*
- * Sets the maximum number of grants that may mapped at once by this gntdev
- * instance.
- *
- * N.B. This must be called before any other ioctl is performed on the device.
- */
-#define IOCTL_GNTDEV_SET_MAX_GRANTS \
-_IOC(_IOC_NONE, 'G', 3, sizeof(struct ioctl_gntdev_set_max_grants))
-struct ioctl_gntdev_set_max_grants {
-	/* IN parameter */
-	/* The maximum number of grants that may be mapped at once. */
-	uint32_t count;
-};
-
-/*
- * Sets up an unmap notification within the page, so that the other side can do
- * cleanup if this side crashes. Required to implement cross-domain robust
- * mutexes or close notification on communication channels.
- *
- * Each mapped page only supports one notification; multiple calls referring to
- * the same page overwrite the previous notification. You must clear the
- * notification prior to the IOCTL_GNTALLOC_DEALLOC_GREF if you do not want it
- * to occur.
- */
-#define IOCTL_GNTDEV_SET_UNMAP_NOTIFY \
-_IOC(_IOC_NONE, 'G', 7, sizeof(struct ioctl_gntdev_unmap_notify))
-struct ioctl_gntdev_unmap_notify {
-	/* IN parameters */
-	/* Offset in the file descriptor for a byte within the page (same as
-	 * used in mmap). If using UNMAP_NOTIFY_CLEAR_BYTE, this is the byte to
-	 * be cleared. Otherwise, it can be any byte in the page whose
-	 * notification we are adjusting.
-	 */
-	uint64_t index;
-	/* Action(s) to take on unmap */
-	uint32_t action;
-	/* Event channel to notify */
-	uint32_t event_channel_port;
-};
-
-/* Clear (set to zero) the byte specified by index */
-#define UNMAP_NOTIFY_CLEAR_BYTE 0x1
-/* Send an interrupt on the indicated event channel */
-#define UNMAP_NOTIFY_SEND_EVENT 0x2
-
-#endif /* __LINUX_PUBLIC_GNTDEV_H__ */
-- 
1.9.0

