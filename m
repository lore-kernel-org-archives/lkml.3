Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978AbaITVXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 17:23:18 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:42928 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401AbaITVXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 17:23:13 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 1/3] x86, ptdump: Add section for EFI runtime services
Date: Sat, 20 Sep 2014 23:22:20 +0200
Message-Id: <1411248142-28951-2-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411248142-28951-1-git-send-email-minipli@googlemail.com>
References: <1411248142-28951-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 3891a04aafd6 ("x86-64, espfix: Don't leak bits 31:16 of %esp
returning..") the "ESPFix Area" was added to the page table dump special
sections. That area, though, has a limited amount of entries printed.

The EFI runtime services are, unfortunately, located in-between the
espfix area and the high kernel memory mapping. Due to the enforced
limitation for the espfix area, the EFI mappings won't be printed in the
page table dump.

To make the ESP runtime service mappings visible again, provide them a
dedicated entry.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/pgtable_64_types.h |    2 ++
 arch/x86/mm/dump_pagetables.c           |    3 +++
 arch/x86/platform/efi/efi_64.c          |    3 +--
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 7166e25ecb57..602b6028c5b6 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -63,6 +63,8 @@ typedef struct { pteval_t pte; } pte_t;
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
 #define ESPFIX_PGD_ENTRY _AC(-2, UL)
 #define ESPFIX_BASE_ADDR (ESPFIX_PGD_ENTRY << PGDIR_SHIFT)
+#define EFI_VA_START	 ( -4 * (_AC(1, UL) << 30))
+#define EFI_VA_END	 (-68 * (_AC(1, UL) << 30))
 
 #define EARLY_DYNAMIC_PAGE_TABLES	64
 
diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 95a427e57887..1a8053d1012e 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -76,6 +76,9 @@ static struct addr_marker address_markers[] = {
 # ifdef CONFIG_X86_ESPFIX64
 	{ ESPFIX_BASE_ADDR,	"ESPfix Area", 16 },
 # endif
+# ifdef CONFIG_EFI
+	{ EFI_VA_END,		"EFI Runtime Services" },
+# endif
 	{ __START_KERNEL_map,   "High Kernel Mapping" },
 	{ MODULES_VADDR,        "Modules" },
 	{ MODULES_END,          "End Modules" },
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 290d397e1dd9..899c7f17ad85 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -48,8 +48,7 @@ static unsigned long efi_flags __initdata;
  * We allocate runtime services regions bottom-up, starting from -4G, i.e.
  * 0xffff_ffff_0000_0000 and limit EFI VA mapping space to 64G.
  */
-static u64 efi_va	= -4 * (1UL << 30);
-#define EFI_VA_END	(-68 * (1UL << 30))
+static u64 efi_va = EFI_VA_START;
 
 /*
  * Scratch space used for switching the pagetable in the EFI stub
-- 
1.7.10.4

