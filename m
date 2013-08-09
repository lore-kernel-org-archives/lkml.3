Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030997Ab3HITv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 15:51:56 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:62763 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030908Ab3HITvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 15:51:52 -0400
Message-ID: <201308091951.r79JppCI030998@farm-0021.internal.tilera.com>
From: Tony Lu <zlu@tilera.com>
Date: Fri, 9 Aug 2013 15:45:24 -0400
Subject: [PATCH] tile: support ASLR fully
To: <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this change, tile Linux now supports address-space layout
randomization for shared objects, stack, heap and vdso.

Signed-off-by: Tony Lu <zlu@tilera.com>
Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/elf.h |  4 ++++
 arch/tile/mm/mmap.c         | 20 ++++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/tile/include/asm/elf.h b/arch/tile/include/asm/elf.h
index 31d854f..e1da88e 100644
--- a/arch/tile/include/asm/elf.h
+++ b/arch/tile/include/asm/elf.h
@@ -137,6 +137,10 @@ do { \
 	NEW_AUX_ENT(AT_SYSINFO_EHDR, VDSO_BASE); \
 } while (0)
 
+struct mm_struct;
+extern unsigned long arch_randomize_brk(struct mm_struct *mm);
+#define arch_randomize_brk arch_randomize_brk
+
 #ifdef CONFIG_COMPAT
 
 #define COMPAT_ELF_PLATFORM "tilegx-m32"
diff --git a/arch/tile/mm/mmap.c b/arch/tile/mm/mmap.c
index d67d91e..b3686ce 100644
--- a/arch/tile/mm/mmap.c
+++ b/arch/tile/mm/mmap.c
@@ -58,16 +58,32 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
 #else
 	int is_32bit = 0;
 #endif
+	unsigned long random_factor = 0UL;
+
+	if (current->flags & PF_RANDOMIZE) {
+		random_factor = get_random_int();
+		random_factor = random_factor << PAGE_SHIFT;
+		if (is_32bit)
+			random_factor &= 0xfffffful;
+		else
+			random_factor &= 0xffffffful;
+	}
 
 	/*
 	 * Use standard layout if the expected stack growth is unlimited
 	 * or we are running native 64 bits.
 	 */
-	if (!is_32bit || rlimit(RLIMIT_STACK) == RLIM_INFINITY) {
-		mm->mmap_base = TASK_UNMAPPED_BASE;
+	if (rlimit(RLIMIT_STACK) == RLIM_INFINITY) {
+		mm->mmap_base = TASK_UNMAPPED_BASE + random_factor;
 		mm->get_unmapped_area = arch_get_unmapped_area;
 	} else {
 		mm->mmap_base = mmap_base(mm);
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
 	}
 }
+
+unsigned long arch_randomize_brk(struct mm_struct *mm)
+{
+	unsigned long range_end = mm->brk + 0x02000000;
+	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
+}
-- 
1.8.3.1

