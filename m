Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaBLIOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:14:20 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50346 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752257AbaBLION (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:13 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Akira Takeuchi" <takeuchi.akr@jp.panasonic.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Naoya Horiguchi" <n-horiguchi@ah.jp.nec.com>,
        "Kiyoshi Owada" <owada.kiyoshi@jp.panasonic.com>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.203829909@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 27/79] mm: ensure get_unmapped_area() returns higher
 address than mmap_min_addr
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>

commit 2afc745f3e3079ab16c826be4860da2529054dd2 upstream.

This patch fixes the problem that get_unmapped_area() can return illegal
address and result in failing mmap(2) etc.

In case that the address higher than PAGE_SIZE is set to
/proc/sys/vm/mmap_min_addr, the address lower than mmap_min_addr can be
returned by get_unmapped_area(), even if you do not pass any virtual
address hint (i.e.  the second argument).

This is because the current get_unmapped_area() code does not take into
account mmap_min_addr.

This leads to two actual problems as follows:

1. mmap(2) can fail with EPERM on the process without CAP_SYS_RAWIO,
   although any illegal parameter is not passed.

2. The bottom-up search path after the top-down search might not work in
   arch_get_unmapped_area_topdown().

Note: The first and third chunk of my patch, which changes "len" check,
are for more precise check using mmap_min_addr, and not for solving the
above problem.

[How to reproduce]

	--- test.c -------------------------------------------------
	#include <stdio.h>
	#include <unistd.h>
	#include <sys/mman.h>
	#include <sys/errno.h>

	int main(int argc, char *argv[])
	{
		void *ret = NULL, *last_map;
		size_t pagesize = sysconf(_SC_PAGESIZE);

		do {
			last_map = ret;
			ret = mmap(0, pagesize, PROT_NONE,
				MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
	//		printf("ret=%p\n", ret);
		} while (ret != MAP_FAILED);

		if (errno != ENOMEM) {
			printf("ERR: unexpected errno: %d (last map=%p)\n",
			errno, last_map);
		}

		return 0;
	}
	---------------------------------------------------------------

	$ gcc -m32 -o test test.c
	$ sudo sysctl -w vm.mmap_min_addr=65536
	vm.mmap_min_addr = 65536
	$ ./test  (run as non-priviledge user)
	ERR: unexpected errno: 1 (last map=0x10000)

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2:
 As we do not have vm_unmapped_area(), make arch_get_unmapped_area_topdown()
 calculate the lower limit for the new area's end address and then compare
 addresses with this instead of with len.  In the process, fix an off-by-one
 error which could result in returning 0 if mm->mmap_base == len.]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1368,7 +1368,7 @@ arch_get_unmapped_area(struct file *filp
 	struct vm_area_struct *vma;
 	unsigned long start_addr;
 
-	if (len > TASK_SIZE)
+	if (len > TASK_SIZE - mmap_min_addr)
 		return -ENOMEM;
 
 	if (flags & MAP_FIXED)
@@ -1377,7 +1377,7 @@ arch_get_unmapped_area(struct file *filp
 	if (addr) {
 		addr = PAGE_ALIGN(addr);
 		vma = find_vma(mm, addr);
-		if (TASK_SIZE - len >= addr &&
+		if (TASK_SIZE - len >= addr && addr >= mmap_min_addr &&
 		    (!vma || addr + len <= vma->vm_start))
 			return addr;
 	}
@@ -1442,9 +1442,10 @@ arch_get_unmapped_area_topdown(struct fi
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
 	unsigned long addr = addr0;
+	unsigned long low_limit = max(PAGE_SIZE, mmap_min_addr);
 
 	/* requested length too big for entire address space */
-	if (len > TASK_SIZE)
+	if (len > TASK_SIZE - mmap_min_addr)
 		return -ENOMEM;
 
 	if (flags & MAP_FIXED)
@@ -1454,7 +1455,7 @@ arch_get_unmapped_area_topdown(struct fi
 	if (addr) {
 		addr = PAGE_ALIGN(addr);
 		vma = find_vma(mm, addr);
-		if (TASK_SIZE - len >= addr &&
+		if (TASK_SIZE - len >= addr && addr >= mmap_min_addr &&
 				(!vma || addr + len <= vma->vm_start))
 			return addr;
 	}
@@ -1469,14 +1470,14 @@ arch_get_unmapped_area_topdown(struct fi
 	addr = mm->free_area_cache;
 
 	/* make sure it can fit in the remaining address space */
-	if (addr > len) {
+	if (addr >= low_limit + len) {
 		vma = find_vma(mm, addr-len);
 		if (!vma || addr <= vma->vm_start)
 			/* remember the address as a hint for next time */
 			return (mm->free_area_cache = addr-len);
 	}
 
-	if (mm->mmap_base < len)
+	if (mm->mmap_base < low_limit + len)
 		goto bottomup;
 
 	addr = mm->mmap_base-len;
@@ -1498,7 +1499,7 @@ arch_get_unmapped_area_topdown(struct fi
 
 		/* try just below the current vma->vm_start */
 		addr = vma->vm_start-len;
-	} while (len < vma->vm_start);
+	} while (vma->vm_start >= low_limit + len);
 
 bottomup:
 	/*

