Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbaBMQGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 11:06:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbaBMQGs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 11:06:48 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-afs@lists.infradead.org, josh@joshtriplett.org
Subject: Re: [PATCH 01/21] fs: Remove unused function in afs/write.c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Thu, 13 Feb 2014 16:06:16 +0000
Message-ID: <19617.1392307576@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rashika Kheria <rashika.kheria@gmail.com> wrote:

> Remove unused function in afs/write.c.
> 
> This eliminates the following warning in afs/write.c:
> fs/afs/write.c:749:5: warning: no previous prototype for ‘afs_page_mkwrite’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

I would like to counter with the attached patch.  Yes, I know that
afs_page_mkwrite() still won't be called after this patch - yet.  I have
someone working on RxRPC and AFS stuff and I'd like to have him try and fix up
the missing stuff.

David
---
commit bf0e3d6fc98ba1567deea0a4182580d8041361aa
Author: David Howells <dhowells@redhat.com>
Date:   Thu Feb 13 13:40:57 2014 +0000

    AFS: Actually use afs_page_mkwrite()
    
    When afs_page_mkwrite() was added in commit:
    
    	9b3f26c9110dcea62716aca9b8c68ceb482227ef
    	FS-Cache: Make kAFS use FS-Cache
    
    it wasn't actually called.  It should be called, however, so that we don't see
    local changes not associated with the old data version appearing in fscache's
    cache (afs_page_mkwrite() holds up the write to a file's page through an
    mmap'd page until that page has finished being written to the cache).
    
    Signed-off-by: David Howells <dhowells@redhat.com>
    cc: Rashika Kheria <rashika.kheria@gmail.com>
    cc: Josh Triplett <josh@joshtriplett.org>

diff --git a/fs/afs/file.c b/fs/afs/file.c
index 66d50fe2ee45..014792a8d34e 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -18,6 +18,7 @@
 #include <linux/gfp.h>
 #include "internal.h"
 
+static int afs_file_mmap(struct file *file, struct vm_area_struct *vma);
 static int afs_readpage(struct file *file, struct page *page);
 static void afs_invalidatepage(struct page *page, unsigned int offset,
 			       unsigned int length);
@@ -35,7 +36,7 @@ const struct file_operations afs_file_operations = {
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
 	.aio_write	= afs_file_write,
-	.mmap		= generic_file_readonly_mmap,
+	.mmap		= afs_file_mmap,
 	.splice_read	= generic_file_splice_read,
 	.fsync		= afs_fsync,
 	.lock		= afs_lock,
@@ -378,3 +379,25 @@ static int afs_releasepage(struct page *page, gfp_t gfp_flags)
 	_leave(" = T");
 	return 1;
 }
+
+static const struct vm_operations_struct afs_vm_ops = {
+	.fault		= filemap_fault,
+	.page_mkwrite	= afs_page_mkwrite,
+	.remap_pages	= generic_file_remap_pages,
+};
+
+/*
+ * Handle setting up a memory mapping on an AFS file.
+ *
+ * At the moment we only support read-only mappings as writable mappings must
+ * set up a writeback record.
+ */
+static int afs_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	int ret;
+
+	ret = generic_file_readonly_mmap(file, vma);
+	if (ret == 0)
+		vma->vm_ops = &afs_vm_ops;
+	return ret;
+}
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 6621f8008122..a074279bdab7 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -750,6 +750,7 @@ extern ssize_t afs_file_write(struct kiocb *, const struct iovec *,
 			      unsigned long, loff_t);
 extern int afs_writeback_all(struct afs_vnode *);
 extern int afs_fsync(struct file *, loff_t, loff_t, int);
+extern int afs_page_mkwrite(struct vm_area_struct *, struct page *);
 
 
 /*****************************************************************************/
diff --git a/fs/afs/write.c b/fs/afs/write.c
index a890db4b9898..a593c2c0970e 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -759,6 +759,13 @@ int afs_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 	fscache_wait_on_page_write(vnode->cache, page);
 #endif
 
+	/* TODO: Get the key from vma->vm_file, flush any overlapping
+	 * contradictory writeback record, set up new a writeback record if
+	 * needed and remove the R/O check from afs_file_mmap().
+	 *
+	 * The code can probably be common with much of afs_write_begin().
+	 */
+
 	_leave(" = 0");
 	return 0;
 }
