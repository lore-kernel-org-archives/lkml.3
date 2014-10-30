Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbaJ3Am3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 20:42:29 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:51307 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630AbaJ3Am0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 20:42:26 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: akpm@linux-foundation.org, linux-mm@kvack.org, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [RFC 1/6] mm: Add a mechanism to track the current address of a special mapping
Date: Wed, 29 Oct 2014 17:42:11 -0700
Message-Id: <efbf2fd94e8fcfa5e38656bb6f17739a1ebe4e6a.1414629045.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1414629045.git.luto@amacapital.net>
References: <cover.1414629045.git.luto@amacapital.net>
In-Reply-To: <cover.1414629045.git.luto@amacapital.net>
References: <cover.1414629045.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds code to record the start address of a special mapping in
mm->context.  Something like this is needed to enable arch code to
find the vdso or another special mapping if that mapping has been
mremapped.

CRIU remaps special mappings, so this isn't just hypothetical.

Most vdso-using architectures record the vdso address in mm->context
already.  Some of those are only doing it for arch_vma_name, which
is no longer necessary.  Others need it for real:

 - x86_32 (native and compat) need it for the sigreturn,
   rt_sigreturn, and sysenter return thunks.

 - ARM could, in principle, use this for to make its kuser helpers
   relocatable.  (I don't think it will, but it *could*.)

 - x86 may, in the near future, want to change vvar context, per-mm,
   in response to a prctl or other request.  This could, for
   example, be used to turn off RDTSC (using CR4.TSD) without
   crashing the target process.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 include/linux/mm.h       |  3 +++
 include/linux/mm_types.h |  8 ++++++++
 mm/mmap.c                | 24 +++++++++++++++++++++---
 mm/mremap.c              |  2 ++
 4 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8981cc882ed2..66bc9a37ae17 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1796,6 +1796,9 @@ extern int install_special_mapping(struct mm_struct *mm,
 				   unsigned long addr, unsigned long len,
 				   unsigned long flags, struct page **pages);
 
+/* Internal helper to update mm context after the vma is moved. */
+extern void update_special_mapping_addr(struct vm_area_struct *vma);
+
 extern unsigned long get_unmapped_area(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
 
 extern unsigned long mmap_region(struct file *file, unsigned long addr,
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 6e0b286649f1..ad6652fe3671 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -515,6 +515,14 @@ struct vm_special_mapping
 {
 	const char *name;
 	struct page **pages;
+
+	/*
+	 * If non-NULL, this is called when installed and when mremap
+	 * moves the first page of the mapping.
+	 */
+	void (*start_addr_set)(struct vm_special_mapping *sm,
+			       struct mm_struct *mm,
+			       unsigned long start_addr);
 };
 
 enum tlb_flush_reason {
diff --git a/mm/mmap.c b/mm/mmap.c
index c0a3637cdb64..8c398b9ee225 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2923,8 +2923,21 @@ static const struct vm_operations_struct legacy_special_mapping_vmops = {
 	.fault = special_mapping_fault,
 };
 
+void update_special_mapping_addr(struct vm_area_struct *vma)
+{
+	struct vm_special_mapping *sm;
+
+	if (vma->vm_ops != &special_mapping_vmops)
+		return;
+
+	sm = vma->vm_private_data;
+	if (sm->start_addr_set &&
+	    vma->vm_start == (vma->vm_pgoff << PAGE_SHIFT))
+		sm->start_addr_set(sm, vma->vm_mm, vma->vm_start);
+}
+
 static int special_mapping_fault(struct vm_area_struct *vma,
-				struct vm_fault *vmf)
+				 struct vm_fault *vmf)
 {
 	pgoff_t pgoff;
 	struct page **pages;
@@ -3009,8 +3022,13 @@ struct vm_area_struct *_install_special_mapping(
 	unsigned long addr, unsigned long len,
 	unsigned long vm_flags, const struct vm_special_mapping *spec)
 {
-	return __install_special_mapping(mm, addr, len, vm_flags,
-					 &special_mapping_vmops, (void *)spec);
+	struct vm_area_struct *vma;
+
+	vma = __install_special_mapping(mm, addr, len, vm_flags,
+					&special_mapping_vmops, (void *)spec);
+	if (!IS_ERR(vma))
+		update_special_mapping_addr(vma);
+	return vma;
 }
 
 int install_special_mapping(struct mm_struct *mm,
diff --git a/mm/mremap.c b/mm/mremap.c
index 05f1180e9f21..7a0b79fdf60f 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -287,6 +287,8 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 		old_len = new_len;
 		old_addr = new_addr;
 		new_addr = -ENOMEM;
+	} else {
+		update_special_mapping_addr(new_vma);
 	}
 
 	/* Conceal VM_ACCOUNT so old reservation is not undone */
-- 
1.9.3

