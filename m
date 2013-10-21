Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab3JUIxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:53:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39846 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754516Ab3JUIxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:53:14 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Greg Ungerer" <gerg@uclinux.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.30450496@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 126/149] m68knommu: clean up linker script
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Ungerer <gerg@uclinux.org>

commit f84f52a5c15db7d14a534815f27253b001735183 upstream.

There is a lot of years of collected cruft in the m68knommu linker script.
Clean it all up and use the well defined linker script support macros.

Support is maintained for building both ROM/FLASH based and RAM based setups.
No major changes to section layouts, though the rodata section is now lumped
in with the read/write data section.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/m68k/kernel/vmlinux-nommu.lds | 200 +++++++++----------------------------
 1 file changed, 49 insertions(+), 151 deletions(-)

diff --git a/arch/m68k/kernel/vmlinux-nommu.lds b/arch/m68k/kernel/vmlinux-nommu.lds
index 8e66ccb..40e02d9 100644
--- a/arch/m68k/kernel/vmlinux-nommu.lds
+++ b/arch/m68k/kernel/vmlinux-nommu.lds
@@ -1,195 +1,93 @@
 /*
  *	vmlinux.lds.S -- master linker script for m68knommu arch
  *
- *	(C) Copyright 2002-2006, Greg Ungerer <gerg@snapgear.com>
+ *	(C) Copyright 2002-2012, Greg Ungerer <gerg@snapgear.com>
  *
  *	This linker script is equipped to build either ROM loaded or RAM
  *	run kernels.
  */
 
-#include <asm-generic/vmlinux.lds.h>
-#include <asm/page.h>
-#include <asm/thread_info.h>
-
 #if defined(CONFIG_RAMKERNEL)
-#define	RAM_START	CONFIG_KERNELBASE
-#define	RAM_LENGTH	(CONFIG_RAMBASE + CONFIG_RAMSIZE - CONFIG_KERNELBASE)
-#define	TEXT		ram
-#define	DATA		ram
-#define	INIT		ram
-#define	BSSS		ram
-#endif
-#if defined(CONFIG_ROMKERNEL) || defined(CONFIG_HIMEMKERNEL)
-#define	RAM_START	CONFIG_RAMBASE
-#define	RAM_LENGTH	CONFIG_RAMSIZE
-#define	ROMVEC_START	CONFIG_ROMVEC
-#define	ROMVEC_LENGTH	CONFIG_ROMVECSIZE
-#define	ROM_START	CONFIG_ROMSTART
-#define	ROM_LENGTH	CONFIG_ROMSIZE
-#define	TEXT		rom
-#define	DATA		ram
-#define	INIT		ram
-#define	BSSS		ram
+#define	KTEXT_ADDR	CONFIG_KERNELBASE
 #endif
-
-#ifndef DATA_ADDR
-#define	DATA_ADDR
+#if defined(CONFIG_ROMKERNEL)
+#define	KTEXT_ADDR	CONFIG_ROMSTART
+#define	KDATA_ADDR	CONFIG_KERNELBASE
+#define	LOAD_OFFSET	KDATA_ADDR + (ADDR(.text) + SIZEOF(.text))
 #endif
 
+#include <asm/page.h>
+#include <asm/thread_info.h>
+#include <asm-generic/vmlinux.lds.h>
 
 OUTPUT_ARCH(m68k)
 ENTRY(_start)
 
-MEMORY {
-	ram	: ORIGIN = RAM_START, LENGTH = RAM_LENGTH
-#ifdef ROM_START
-	romvec	: ORIGIN = ROMVEC_START, LENGTH = ROMVEC_LENGTH
-	rom	: ORIGIN = ROM_START, LENGTH = ROM_LENGTH
-#endif
-}
-
 jiffies = jiffies_64 + 4;
 
 SECTIONS {
 
-#ifdef ROMVEC_START
-	. = ROMVEC_START ;
+#ifdef CONFIG_ROMVEC
+	. = CONFIG_ROMVEC;
 	.romvec : {
-		__rom_start = . ;
+		__rom_start = .;
 		_romvec = .;
+		*(.romvec)
 		*(.data..initvect)
-	} > romvec
+	}
 #endif
 
+	. = KTEXT_ADDR;
+
+	_text = .;
+	_stext = .;
 	.text : {
-		_text = .;
-		_stext = . ;
 		HEAD_TEXT
 		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
-		*(.text..lock)
 		*(.fixup)
+		. = ALIGN(16);
+	}
+	_etext = .;
+
+#ifdef KDATA_ADDR
+	. = KDATA_ADDR;
+#endif
+
+	_sdata = .;
+	RO_DATA_SECTION(PAGE_SIZE)
+	RW_DATA_SECTION(16, PAGE_SIZE, THREAD_SIZE)
+	_edata = .;
 
-		. = ALIGN(16);          /* Exception table              */
-		__start___ex_table = .;
-		*(__ex_table)
-		__stop___ex_table = .;
-
-		*(.rodata) *(.rodata.*)
-		*(__vermagic)		/* Kernel version magic */
-		*(.rodata1)
-		*(.rodata.str1.1)
-
-		/* Kernel symbol table: Normal symbols */
-		. = ALIGN(4);
-		__start___ksymtab = .;
-		*(SORT(___ksymtab+*))
-		__stop___ksymtab = .;
-
-		/* Kernel symbol table: GPL-only symbols */
-		__start___ksymtab_gpl = .;
-		*(SORT(___ksymtab_gpl+*))
-		__stop___ksymtab_gpl = .;
-
-		/* Kernel symbol table: Normal unused symbols */
-		__start___ksymtab_unused = .;
-		*(SORT(___ksymtab_unused+*))
-		__stop___ksymtab_unused = .;
-
-		/* Kernel symbol table: GPL-only unused symbols */
-		__start___ksymtab_unused_gpl = .;
-		*(SORT(___ksymtab_unused_gpl+*))
-		__stop___ksymtab_unused_gpl = .;
-
-		/* Kernel symbol table: GPL-future symbols */
-		__start___ksymtab_gpl_future = .;
-		*(SORT(___ksymtab_gpl_future+*))
-		__stop___ksymtab_gpl_future = .;
-
-		/* Kernel symbol table: Normal symbols */
-		__start___kcrctab = .;
-		*(SORT(___kcrctab+*))
-		__stop___kcrctab = .;
-
-		/* Kernel symbol table: GPL-only symbols */
-		__start___kcrctab_gpl = .;
-		*(SORT(___kcrctab_gpl+*))
-		__stop___kcrctab_gpl = .;
-
-		/* Kernel symbol table: Normal unused symbols */
-		__start___kcrctab_unused = .;
-		*(SORT(___kcrctab_unused+*))
-		__stop___kcrctab_unused = .;
-
-		/* Kernel symbol table: GPL-only unused symbols */
-		__start___kcrctab_unused_gpl = .;
-		*(SORT(___kcrctab_unused_gpl+*))
-		__stop___kcrctab_unused_gpl = .;
-
-		/* Kernel symbol table: GPL-future symbols */
-		__start___kcrctab_gpl_future = .;
-		*(SORT(___kcrctab_gpl_future+*))
-		__stop___kcrctab_gpl_future = .;
-
-		/* Kernel symbol table: strings */
-		*(__ksymtab_strings)
-
-		/* Built-in module parameters */
-		. = ALIGN(4) ;
-		__start___param = .;
-		*(__param)
-		__stop___param = .;
-
-		/* Built-in module versions */
-		. = ALIGN(4) ;
-		__start___modver = .;
-		*(__modver)
-		__stop___modver = .;
-
-		. = ALIGN(4) ;
-		_etext = . ;
-	} > TEXT
-
-	.data DATA_ADDR : {
-		. = ALIGN(4);
-		_sdata = . ;
-		DATA_DATA
-		CACHELINE_ALIGNED_DATA(32)
-		PAGE_ALIGNED_DATA(PAGE_SIZE)
-		*(.data..shared_aligned)
-		INIT_TASK_DATA(THREAD_SIZE)
-		_edata = . ;
-	} > DATA
+	EXCEPTION_TABLE(16)
+	NOTES
 
+	. = ALIGN(PAGE_SIZE);
+	__init_begin = .;
+	INIT_TEXT_SECTION(PAGE_SIZE)
+	INIT_DATA_SECTION(16)
+	PERCPU_SECTION(16)
 	.m68k_fixup : {
 		__start_fixup = .;
 		*(.m68k_fixup)
 		__stop_fixup = .;
-	} > DATA
-	NOTES > DATA
-
-	.init.text : {
-		. = ALIGN(PAGE_SIZE);
-		__init_begin = .;
-	} > INIT
-	INIT_TEXT_SECTION(PAGE_SIZE) > INIT
-	INIT_DATA_SECTION(16) > INIT
+	}
 	.init.data : {
 		. = ALIGN(PAGE_SIZE);
 		__init_end = .;
-	} > INIT
-
-	.bss : {
-		. = ALIGN(4);
-		_sbss = . ;
-		*(.bss)
-		*(COMMON)
-		. = ALIGN(4) ;
-		_ebss = . ;
-	 	_end = . ;
-	} > BSSS
+	}
+
+	_sbss = .;
+	BSS_SECTION(0, 0, 0)
+	_ebss = .;
+
+	_end = .;
+
+	STABS_DEBUG
+	.comment 0 : { *(.comment) }
 
+	/* Sections to be discarded */
 	DISCARDS
 }
 

