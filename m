Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbaI0R6e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 13:58:34 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:38881 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbaI0R6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 13:58:33 -0400
From: Daniel Micay <danielmicay@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, jasone@canonware.com,
        Daniel Micay <danielmicay@gmail.com>
Subject: [PATCH] mm: add mremap flag for preserving the old mapping
Date: Sat, 27 Sep 2014 13:58:06 -0400
Message-Id: <1411840686-7965-1-git-send-email-danielmicay@gmail.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces the MREMAP_RETAIN flag for preserving the source mapping
when MREMAP_MAYMOVE moves the pages to a new destination. Accesses to
the source location will fault and cause fresh pages to be mapped in.

For consistency, the old_len >= new_len case could decommit the pages
instead of unmapping. However, userspace can accomplish the same thing
via madvise and a coherent definition of the flag is possible without
the extra complexity.

Motivation:

TCMalloc and jemalloc avoid releasing virtual memory in order to reduce
virtual memory fragmentation. A call to munmap or mremap would leave a
hole in the address space. Instead, unused pages are lazily returned to
the operating system via MADV_DONTNEED.

Since mremap cannot be used to elide copies, TCMalloc and jemalloc end
up being significantly slower for patterns like repeated vector / hash
table reallocations. Consider the typical vector building pattern:

    #include <string.h>
    #include <stdlib.h>

    int main(void) {
        void *ptr = NULL;
        size_t old_size = 0;
        for (size_t size = 4; size < (1 << 30); size *= 2) {
            ptr = realloc(ptr, size);
            if (!ptr) return 1;
            memset(ptr, 0xff, size - old_size);
            old_size = size;
        }
    }

glibc: 0.115s
jemalloc: 0.199s
TCMalloc: 0.202s

In practice, in-place growth never occurs because the heap grows in the
downwards direction for all 3 allocators. TCMalloc and jemalloc pay for
enormous copies while glibc is only spending time writing new elements
to the vector. Even if it was grown in the other direction, real-world
applications would end up blocking in-place growth with new allocations.

The allocators could attempt to map the source location again after an
mremap call, but there is no guarantee of success in a multi-threaded
program and fragmentating memory over time is considered unacceptable.

Signed-off-by: Daniel Micay <danielmicay@gmail.com>
---
 include/uapi/linux/mman.h |  1 +
 mm/mremap.c               | 18 +++++++++++-------
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/mman.h b/include/uapi/linux/mman.h
index ade4acd..4e9a546 100644
--- a/include/uapi/linux/mman.h
+++ b/include/uapi/linux/mman.h
@@ -5,6 +5,7 @@
 
 #define MREMAP_MAYMOVE	1
 #define MREMAP_FIXED	2
+#define MREMAP_RETAIN	4
 
 #define OVERCOMMIT_GUESS		0
 #define OVERCOMMIT_ALWAYS		1
diff --git a/mm/mremap.c b/mm/mremap.c
index 05f1180..c01bab6 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -235,7 +235,8 @@ unsigned long move_page_tables(struct vm_area_struct *vma,
 
 static unsigned long move_vma(struct vm_area_struct *vma,
 		unsigned long old_addr, unsigned long old_len,
-		unsigned long new_len, unsigned long new_addr, bool *locked)
+		unsigned long new_len, unsigned long new_addr, bool retain,
+		bool *locked)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *new_vma;
@@ -287,6 +288,7 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 		old_len = new_len;
 		old_addr = new_addr;
 		new_addr = -ENOMEM;
+		retain = false;
 	}
 
 	/* Conceal VM_ACCOUNT so old reservation is not undone */
@@ -310,7 +312,7 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 	hiwater_vm = mm->hiwater_vm;
 	vm_stat_account(mm, vma->vm_flags, vma->vm_file, new_len>>PAGE_SHIFT);
 
-	if (do_munmap(mm, old_addr, old_len) < 0) {
+	if (retain || do_munmap(mm, old_addr, old_len) < 0) {
 		/* OOM: unable to split vma, just get accounts right */
 		vm_unacct_memory(excess >> PAGE_SHIFT);
 		excess = 0;
@@ -392,7 +394,8 @@ Eagain:
 }
 
 static unsigned long mremap_to(unsigned long addr, unsigned long old_len,
-		unsigned long new_addr, unsigned long new_len, bool *locked)
+		unsigned long new_addr, unsigned long new_len, bool retain,
+		bool *locked)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
@@ -442,7 +445,7 @@ static unsigned long mremap_to(unsigned long addr, unsigned long old_len,
 	if (ret & ~PAGE_MASK)
 		goto out1;
 
-	ret = move_vma(vma, addr, old_len, new_len, new_addr, locked);
+	ret = move_vma(vma, addr, old_len, new_len, new_addr, retain, locked);
 	if (!(ret & ~PAGE_MASK))
 		goto out;
 out1:
@@ -482,7 +485,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
 	unsigned long charged = 0;
 	bool locked = false;
 
-	if (flags & ~(MREMAP_FIXED | MREMAP_MAYMOVE))
+	if (flags & ~(MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_RETAIN))
 		return ret;
 
 	if (flags & MREMAP_FIXED && !(flags & MREMAP_MAYMOVE))
@@ -506,7 +509,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
 
 	if (flags & MREMAP_FIXED) {
 		ret = mremap_to(addr, old_len, new_addr, new_len,
-				&locked);
+				flags & MREMAP_RETAIN, &locked);
 		goto out;
 	}
 
@@ -575,7 +578,8 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
 			goto out;
 		}
 
-		ret = move_vma(vma, addr, old_len, new_len, new_addr, &locked);
+		ret = move_vma(vma, addr, old_len, new_len, new_addr,
+			       flags & MREMAP_RETAIN, &locked);
 	}
 out:
 	if (ret & ~PAGE_MASK)
-- 
2.1.1

