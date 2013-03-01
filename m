Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab3CAUSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:18:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51458 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab3CATpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Archit Taneja <archit@ti.com>, Prabhakar Lad <prabhakar.lad@ti.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 46/77] media: omap_vout: find_vma() needs ->mmap_sem held
Date: Fri,  1 Mar 2013 11:44:31 -0800
Message-Id: <20130301194356.840788893@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit 55ee64b30a38d688232e5eb2860467dddc493573 upstream.

Walking rbtree while it's modified is a Bad Idea(tm); besides,
the result of find_vma() can be freed just as it's getting returned
to caller.  Fortunately, it's easy to fix - just take ->mmap_sem a bit
earlier (and don't bother with find_vma() at all if virtp >= PAGE_OFFSET -
in that case we don't even look at its result).

While we are at it, what prevents VIDIOC_PREPARE_BUF calling
v4l_prepare_buf() -> (e.g) vb2_ioctl_prepare_buf() -> vb2_prepare_buf() ->
__buf_prepare() -> __qbuf_userptr() -> vb2_vmalloc_get_userptr() -> find_vma(),
AFAICS without having taken ->mmap_sem anywhere in process?  The code flow
is bloody convoluted and depends on a bunch of things done by initialization,
so I certainly might've missed something...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Archit Taneja <archit@ti.com>
Cc: Prabhakar Lad <prabhakar.lad@ti.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/omap/omap_vout.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -205,19 +205,21 @@ static u32 omap_vout_uservirt_to_phys(u3
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
 
-	vma = find_vma(mm, virtp);
 	/* For kernel direct-mapped memory, take the easy way */
-	if (virtp >= PAGE_OFFSET) {
-		physp = virt_to_phys((void *) virtp);
-	} else if (vma && (vma->vm_flags & VM_IO) && vma->vm_pgoff) {
+	if (virtp >= PAGE_OFFSET)
+		return virt_to_phys((void *) virtp);
+
+	down_read(&current->mm->mmap_sem);
+	vma = find_vma(mm, virtp);
+	if (vma && (vma->vm_flags & VM_IO) && vma->vm_pgoff) {
 		/* this will catch, kernel-allocated, mmaped-to-usermode
 		   addresses */
 		physp = (vma->vm_pgoff << PAGE_SHIFT) + (virtp - vma->vm_start);
+		up_read(&current->mm->mmap_sem);
 	} else {
 		/* otherwise, use get_user_pages() for general userland pages */
 		int res, nr_pages = 1;
 		struct page *pages;
-		down_read(&current->mm->mmap_sem);
 
 		res = get_user_pages(current, current->mm, virtp, nr_pages, 1,
 				0, &pages, NULL);


