Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaLNWjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 17:39:44 -0500
Received: from kanga.kvack.org ([205.233.56.17]:57378 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbaLNWjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 17:39:37 -0500
Date: Sun, 14 Dec 2014 17:39:36 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-aio@kvack.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [GIT PULL] aio: changes for 3.19
Message-ID: <20141214223936.GJ2672@kvack.org>
References: <20141214202224.GH2672@kvack.org> <CA+55aFxV2h1NrE87Zt7U8bsrXgeO=Tf-DyQO8wBYZ=M7WEjxKg@mail.gmail.com> <20141214215221.GI2672@kvack.org> <20141214141336.a0267e95.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141214141336.a0267e95.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 02:13:36PM -0800, Andrew Morton wrote:
> The patch appears to be a bugfix which coincidentally helps CRIU?

Yes.

> If it weren't for the bugfix part, I'd be asking "why not pass the
> desired virtual address into io_setup()?".

It's entirely possible someone might have a need to mremap the event ring, 
but nobody seems to have tried until now.

> The patch overall is a no-op from an MM perspective and seems OK to me.

How about the documentation/comment updates below?

I'll try to be more aggressive about getting signoffs on these wider changes 
in the future.

		-ben
-- 
"Thought is the essence of where you are now."

aio/mm: update documentation for mremap hook in commit e4a0d3e720e7e508749c1439b5ba3aff56c92976

Add a few more comments and documentation to explain the mremap hook introduced
in commit e4a0d3e720e7e508749c1439b5ba3aff56c92976.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>

 Documentation/filesystems/vfs.txt |    4 ++++
 fs/aio.c                          |    8 ++++++++
 2 files changed, 12 insertions(+)

diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 43ce050..a9f3df5 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -820,6 +820,7 @@ struct file_operations {
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
+	void (*mremap) (struct file *, struct vm_area_struct *);
 	int (*open) (struct inode *, struct file *);
 	int (*flush) (struct file *);
 	int (*release) (struct inode *, struct file *);
@@ -868,6 +869,9 @@ otherwise noted.
 
   mmap: called by the mmap(2) system call
 
+  mremap: called by the mremap(2) system call.  Called holding mmap_sem for
+	write.
+
   open: called by the VFS when an inode should be opened. When the VFS
 	opens a file, it creates a new "struct file". It then calls the
 	open method for the newly allocated file structure. You might
diff --git a/fs/aio.c b/fs/aio.c
index 1b7893e..aba5385 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -286,11 +286,19 @@ static void aio_free_ring(struct kioctx *ctx)
 
 static int aio_ring_mmap(struct file *file, struct vm_area_struct *vma)
 {
+	/* Resizing the event ring is not supported; mark it so. */
 	vma->vm_flags |= VM_DONTEXPAND;
 	vma->vm_ops = &generic_file_vm_ops;
 	return 0;
 }
 
+/* aio_ring_remap()
+ *	Called when th aio event ring is being relocated within the process'
+ *	address space.  The primary purpose is to update the saved address of
+ *	the aio event ring so that when the ioctx is detroyed, it gets removed
+ *	from the correct userspace address.  This is typically used when
+ *	reloading a process back into memory by checkpoint-restore.
+ */
 static void aio_ring_remap(struct file *file, struct vm_area_struct *vma)
 {
 	struct mm_struct *mm = vma->vm_mm;
