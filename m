Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab3CRSpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 14:45:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab3CRSpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 14:45:20 -0400
Date: Mon, 18 Mar 2013 19:43:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] uprobes: Use file_inode()
Message-ID: <20130318184317.GA8423@redhat.com>
References: <20130317180036.GA16843@redhat.com> <20130317182550.GD21522@ZenIV.linux.org.uk> <20130317184255.GA23280@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130317184255.GA23280@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup. Now that we have f_inode/file_inode() we can use it instead
of ->f_mapping->host.

This should not make any difference for uprobes, but in theory this
change is more correct. We use this inode as a key, to compare it
with uprobe->inode set by uprobe_register(inode), and the caller uses
d_inode.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 2bcd08e..5c273b3 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -758,7 +758,7 @@ register_for_each_vma(struct uprobe *uprobe, struct uprobe_consumer *new)
 		down_write(&mm->mmap_sem);
 		vma = find_vma(mm, info->vaddr);
 		if (!vma || !valid_vma(vma, is_register) ||
-		    vma->vm_file->f_mapping->host != uprobe->inode)
+		    file_inode(vma->vm_file) != uprobe->inode)
 			goto unlock;
 
 		if (vma->vm_start > info->vaddr ||
@@ -917,7 +917,7 @@ static int unapply_uprobe(struct uprobe *uprobe, struct mm_struct *mm)
 		loff_t offset;
 
 		if (!valid_vma(vma, false) ||
-		    vma->vm_file->f_mapping->host != uprobe->inode)
+		    file_inode(vma->vm_file) != uprobe->inode)
 			continue;
 
 		offset = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
@@ -1010,7 +1010,7 @@ int uprobe_mmap(struct vm_area_struct *vma)
 	if (no_uprobe_events() || !valid_vma(vma, true))
 		return 0;
 
-	inode = vma->vm_file->f_mapping->host;
+	inode = file_inode(vma->vm_file);
 	if (!inode)
 		return 0;
 
@@ -1041,7 +1041,7 @@ vma_has_uprobes(struct vm_area_struct *vma, unsigned long start, unsigned long e
 	struct inode *inode;
 	struct rb_node *n;
 
-	inode = vma->vm_file->f_mapping->host;
+	inode = file_inode(vma->vm_file);
 
 	min = vaddr_to_offset(vma, start);
 	max = min + (end - start) - 1;
@@ -1465,7 +1465,7 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
 	vma = find_vma(mm, bp_vaddr);
 	if (vma && vma->vm_start <= bp_vaddr) {
 		if (valid_vma(vma, false)) {
-			struct inode *inode = vma->vm_file->f_mapping->host;
+			struct inode *inode = file_inode(vma->vm_file);
 			loff_t offset = vaddr_to_offset(vma, bp_vaddr);
 
 			uprobe = find_uprobe(inode, offset);
-- 
1.5.5.1


