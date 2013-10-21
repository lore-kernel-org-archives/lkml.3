Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab3JUIxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:53:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39832 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754393Ab3JUIxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:53:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Greg Ungerer" <gerg@uclinux.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.522696728@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 124/149] m68k: consolidate the vmlinux.lds linker scripts
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

commit 40c1b9cfeedf79b909c961e0e00a13497e80bc82 upstream.

The merge of m68knommu left the linker scripts a little disorganized.
Some consistent naming and squashing two of scripts that just include
others can simplify things a lot.

So merge the two simple including scripts, and rename the nommu script
to be consistent with the existing m68k linker scripts.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/m68k/kernel/vmlinux-nommu.lds | 187 +++++++++++++++++++++++++++++++++++++
 arch/m68k/kernel/vmlinux.lds.S     |  13 ++-
 arch/m68k/kernel/vmlinux.lds_mm.S  |  10 --
 arch/m68k/kernel/vmlinux.lds_no.S  | 187 -------------------------------------
 4 files changed, 198 insertions(+), 199 deletions(-)
 create mode 100644 arch/m68k/kernel/vmlinux-nommu.lds
 delete mode 100644 arch/m68k/kernel/vmlinux.lds_mm.S
 delete mode 100644 arch/m68k/kernel/vmlinux.lds_no.S

diff --git a/arch/m68k/kernel/vmlinux-nommu.lds b/arch/m68k/kernel/vmlinux-nommu.lds
new file mode 100644
index 0000000..4e23893
--- /dev/null
+++ b/arch/m68k/kernel/vmlinux-nommu.lds
@@ -0,0 +1,187 @@
+/*
+ *	vmlinux.lds.S -- master linker script for m68knommu arch
+ *
+ *	(C) Copyright 2002-2006, Greg Ungerer <gerg@snapgear.com>
+ *
+ *	This linker script is equipped to build either ROM loaded or RAM
+ *	run kernels.
+ */
+
+#include <asm-generic/vmlinux.lds.h>
+#include <asm/page.h>
+#include <asm/thread_info.h>
+
+#if defined(CONFIG_RAMKERNEL)
+#define	RAM_START	CONFIG_KERNELBASE
+#define	RAM_LENGTH	(CONFIG_RAMBASE + CONFIG_RAMSIZE - CONFIG_KERNELBASE)
+#define	TEXT		ram
+#define	DATA		ram
+#define	INIT		ram
+#define	BSSS		ram
+#endif
+#if defined(CONFIG_ROMKERNEL) || defined(CONFIG_HIMEMKERNEL)
+#define	RAM_START	CONFIG_RAMBASE
+#define	RAM_LENGTH	CONFIG_RAMSIZE
+#define	ROMVEC_START	CONFIG_ROMVEC
+#define	ROMVEC_LENGTH	CONFIG_ROMVECSIZE
+#define	ROM_START	CONFIG_ROMSTART
+#define	ROM_LENGTH	CONFIG_ROMSIZE
+#define	TEXT		rom
+#define	DATA		ram
+#define	INIT		ram
+#define	BSSS		ram
+#endif
+
+#ifndef DATA_ADDR
+#define	DATA_ADDR
+#endif
+
+
+OUTPUT_ARCH(m68k)
+ENTRY(_start)
+
+MEMORY {
+	ram	: ORIGIN = RAM_START, LENGTH = RAM_LENGTH
+#ifdef ROM_START
+	romvec	: ORIGIN = ROMVEC_START, LENGTH = ROMVEC_LENGTH
+	rom	: ORIGIN = ROM_START, LENGTH = ROM_LENGTH
+#endif
+}
+
+jiffies = jiffies_64 + 4;
+
+SECTIONS {
+
+#ifdef ROMVEC_START
+	. = ROMVEC_START ;
+	.romvec : {
+		__rom_start = . ;
+		_romvec = .;
+		*(.data..initvect)
+	} > romvec
+#endif
+
+	.text : {
+		_text = .;
+		_stext = . ;
+		HEAD_TEXT
+		TEXT_TEXT
+		SCHED_TEXT
+		LOCK_TEXT
+		*(.text..lock)
+
+		. = ALIGN(16);          /* Exception table              */
+		__start___ex_table = .;
+		*(__ex_table)
+		__stop___ex_table = .;
+
+		*(.rodata) *(.rodata.*)
+		*(__vermagic)		/* Kernel version magic */
+		*(.rodata1)
+		*(.rodata.str1.1)
+
+		/* Kernel symbol table: Normal symbols */
+		. = ALIGN(4);
+		__start___ksymtab = .;
+		*(SORT(___ksymtab+*))
+		__stop___ksymtab = .;
+
+		/* Kernel symbol table: GPL-only symbols */
+		__start___ksymtab_gpl = .;
+		*(SORT(___ksymtab_gpl+*))
+		__stop___ksymtab_gpl = .;
+
+		/* Kernel symbol table: Normal unused symbols */
+		__start___ksymtab_unused = .;
+		*(SORT(___ksymtab_unused+*))
+		__stop___ksymtab_unused = .;
+
+		/* Kernel symbol table: GPL-only unused symbols */
+		__start___ksymtab_unused_gpl = .;
+		*(SORT(___ksymtab_unused_gpl+*))
+		__stop___ksymtab_unused_gpl = .;
+
+		/* Kernel symbol table: GPL-future symbols */
+		__start___ksymtab_gpl_future = .;
+		*(SORT(___ksymtab_gpl_future+*))
+		__stop___ksymtab_gpl_future = .;
+
+		/* Kernel symbol table: Normal symbols */
+		__start___kcrctab = .;
+		*(SORT(___kcrctab+*))
+		__stop___kcrctab = .;
+
+		/* Kernel symbol table: GPL-only symbols */
+		__start___kcrctab_gpl = .;
+		*(SORT(___kcrctab_gpl+*))
+		__stop___kcrctab_gpl = .;
+
+		/* Kernel symbol table: Normal unused symbols */
+		__start___kcrctab_unused = .;
+		*(SORT(___kcrctab_unused+*))
+		__stop___kcrctab_unused = .;
+
+		/* Kernel symbol table: GPL-only unused symbols */
+		__start___kcrctab_unused_gpl = .;
+		*(SORT(___kcrctab_unused_gpl+*))
+		__stop___kcrctab_unused_gpl = .;
+
+		/* Kernel symbol table: GPL-future symbols */
+		__start___kcrctab_gpl_future = .;
+		*(SORT(___kcrctab_gpl_future+*))
+		__stop___kcrctab_gpl_future = .;
+
+		/* Kernel symbol table: strings */
+		*(__ksymtab_strings)
+
+		/* Built-in module parameters */
+		. = ALIGN(4) ;
+		__start___param = .;
+		*(__param)
+		__stop___param = .;
+
+		/* Built-in module versions */
+		. = ALIGN(4) ;
+		__start___modver = .;
+		*(__modver)
+		__stop___modver = .;
+
+		. = ALIGN(4) ;
+		_etext = . ;
+	} > TEXT
+
+	.data DATA_ADDR : {
+		. = ALIGN(4);
+		_sdata = . ;
+		DATA_DATA
+		CACHELINE_ALIGNED_DATA(32)
+		PAGE_ALIGNED_DATA(PAGE_SIZE)
+		*(.data..shared_aligned)
+		INIT_TASK_DATA(THREAD_SIZE)
+		_edata = . ;
+	} > DATA
+
+	.init.text : {
+		. = ALIGN(PAGE_SIZE);
+		__init_begin = .;
+	} > INIT
+	INIT_TEXT_SECTION(PAGE_SIZE) > INIT
+	INIT_DATA_SECTION(16) > INIT
+	.init.data : {
+		. = ALIGN(PAGE_SIZE);
+		__init_end = .;
+	} > INIT
+
+	.bss : {
+		. = ALIGN(4);
+		_sbss = . ;
+		*(.bss)
+		*(COMMON)
+		. = ALIGN(4) ;
+		_ebss = . ;
+	 	_end = . ;
+	} > BSSS
+
+	DISCARDS
+}
+
diff --git a/arch/m68k/kernel/vmlinux.lds.S b/arch/m68k/kernel/vmlinux.lds.S
index 030dabf..3d99a04 100644
--- a/arch/m68k/kernel/vmlinux.lds.S
+++ b/arch/m68k/kernel/vmlinux.lds.S
@@ -1,5 +1,14 @@
 #ifdef CONFIG_MMU
-#include "vmlinux.lds_mm.S"
+PHDRS
+{
+  text PT_LOAD FILEHDR PHDRS FLAGS (7);
+  data PT_LOAD FLAGS (7);
+}
+#ifdef CONFIG_SUN3
+#include "vmlinux-sun3.lds"
 #else
-#include "vmlinux.lds_no.S"
+#include "vmlinux-std.lds"
+#endif
+#else
+#include "vmlinux-nommu.lds"
 #endif
diff --git a/arch/m68k/kernel/vmlinux.lds_mm.S b/arch/m68k/kernel/vmlinux.lds_mm.S
deleted file mode 100644
index 99ba315..0000000
--- a/arch/m68k/kernel/vmlinux.lds_mm.S
+++ /dev/null
@@ -1,10 +0,0 @@
-PHDRS
-{
-  text PT_LOAD FILEHDR PHDRS FLAGS (7);
-  data PT_LOAD FLAGS (7);
-}
-#ifdef CONFIG_SUN3
-#include "vmlinux-sun3.lds"
-#else
-#include "vmlinux-std.lds"
-#endif
diff --git a/arch/m68k/kernel/vmlinux.lds_no.S b/arch/m68k/kernel/vmlinux.lds_no.S
deleted file mode 100644
index 4e23893..0000000
--- a/arch/m68k/kernel/vmlinux.lds_no.S
+++ /dev/null
@@ -1,187 +0,0 @@
-/*
- *	vmlinux.lds.S -- master linker script for m68knommu arch
- *
- *	(C) Copyright 2002-2006, Greg Ungerer <gerg@snapgear.com>
- *
- *	This linker script is equipped to build either ROM loaded or RAM
- *	run kernels.
- */
-
-#include <asm-generic/vmlinux.lds.h>
-#include <asm/page.h>
-#include <asm/thread_info.h>
-
-#if defined(CONFIG_RAMKERNEL)
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
-#endif
-
-#ifndef DATA_ADDR
-#define	DATA_ADDR
-#endif
-
-
-OUTPUT_ARCH(m68k)
-ENTRY(_start)
-
-MEMORY {
-	ram	: ORIGIN = RAM_START, LENGTH = RAM_LENGTH
-#ifdef ROM_START
-	romvec	: ORIGIN = ROMVEC_START, LENGTH = ROMVEC_LENGTH
-	rom	: ORIGIN = ROM_START, LENGTH = ROM_LENGTH
-#endif
-}
-
-jiffies = jiffies_64 + 4;
-
-SECTIONS {
-
-#ifdef ROMVEC_START
-	. = ROMVEC_START ;
-	.romvec : {
-		__rom_start = . ;
-		_romvec = .;
-		*(.data..initvect)
-	} > romvec
-#endif
-
-	.text : {
-		_text = .;
-		_stext = . ;
-		HEAD_TEXT
-		TEXT_TEXT
-		SCHED_TEXT
-		LOCK_TEXT
-		*(.text..lock)
-
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
-
-	.init.text : {
-		. = ALIGN(PAGE_SIZE);
-		__init_begin = .;
-	} > INIT
-	INIT_TEXT_SECTION(PAGE_SIZE) > INIT
-	INIT_DATA_SECTION(16) > INIT
-	.init.data : {
-		. = ALIGN(PAGE_SIZE);
-		__init_end = .;
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
-
-	DISCARDS
-}
-

