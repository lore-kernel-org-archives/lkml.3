Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162655Ab3LFNsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:48:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44134 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121Ab3LFNCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 119/272] mm: ensure get_unmapped_area() returns higher address than mmap_min_addr
Date: Fri,  6 Dec 2013 12:56:48 +0000
Message-Id: <1386334761-25517-120-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/mmap.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index f9c97d1..ab6650d 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1855,7 +1855,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	struct vm_area_struct *vma;
 	struct vm_unmapped_area_info info;
 
-	if (len > TASK_SIZE)
+	if (len > TASK_SIZE - mmap_min_addr)
 		return -ENOMEM;
 
 	if (flags & MAP_FIXED)
@@ -1864,7 +1864,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	if (addr) {
 		addr = PAGE_ALIGN(addr);
 		vma = find_vma(mm, addr);
-		if (TASK_SIZE - len >= addr &&
+		if (TASK_SIZE - len >= addr && addr >= mmap_min_addr &&
 		    (!vma || addr + len <= vma->vm_start))
 			return addr;
 	}
@@ -1894,7 +1894,7 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 	struct vm_unmapped_area_info info;
 
 	/* requested length too big for entire address space */
-	if (len > TASK_SIZE)
+	if (len > TASK_SIZE - mmap_min_addr)
 		return -ENOMEM;
 
 	if (flags & MAP_FIXED)
@@ -1904,14 +1904,14 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 	if (addr) {
 		addr = PAGE_ALIGN(addr);
 		vma = find_vma(mm, addr);
-		if (TASK_SIZE - len >= addr &&
+		if (TASK_SIZE - len >= addr && addr >= mmap_min_addr &&
 				(!vma || addr + len <= vma->vm_start))
 			return addr;
 	}
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = PAGE_SIZE;
+	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
 	info.high_limit = mm->mmap_base;
 	info.align_mask = 0;
 	addr = vm_unmapped_area(&info);
-- 
1.8.3.2

