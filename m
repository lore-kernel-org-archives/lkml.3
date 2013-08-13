Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab3HMP3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:29:15 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:15315 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab3HMP3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:29:13 -0400
Message-ID: <201308131529.r7DFTCkL028814@farm-0021.internal.tilera.com>
In-Reply-To: <alpine.LNX.2.00.1308101849350.32627@pobox.suse.cz>
References: <alpine.LNX.2.00.1308101849350.32627@pobox.suse.cz>
From: Tony Lu <zlu@tilera.com>
Date: Tue, 13 Aug 2013 10:45:24 -0400
Subject: [PATCH v2] tile: support ASLR fully
To: <linux-kernel@vger.kernel.org>, <cmetcalf@tilera.com>,
        Jiri Kosina <jkosina@suse.cz>
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
v2: implement Jiri Kosina's suggestion to copy the math in
mmap_rnd() for x86.

 arch/tile/include/asm/elf.h |  4 ++++
 arch/tile/mm/mmap.c         | 24 ++++++++++++++++++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)

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
index d67d91e..4b99344 100644
--- a/arch/tile/mm/mmap.c
+++ b/arch/tile/mm/mmap.c
@@ -58,16 +58,36 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
 #else
 	int is_32bit = 0;
 #endif
+	unsigned long random_factor = 0UL;
+
+	/*
+	 *  8 bits of randomness in 32bit mmaps, 24 address space bits
+	 * 12 bits of randomness in 64bit mmaps, 28 address space bits
+	 */
+	if (current->flags & PF_RANDOMIZE) {
+		if (is_32bit)
+			random_factor = get_random_int() % (1<<8);
+		else
+			random_factor = get_random_int() % (1<<12);
+		
+		random_factor <<= PAGE_SHIFT;
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

