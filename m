Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab3IQMqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 08:46:35 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:41213 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab3IQMoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 08:44:03 -0400
From: Russ Dill <Russ.Dill@ti.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        mans@mansr.com, Shawn Guo <shawn.guo@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [RFC PATCH 05/11] PIE: Support embedding position independent executables
Date: Tue, 17 Sep 2013 05:43:31 -0700
Message-Id: <1379421817-15759-6-git-send-email-Russ.Dill@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com>
References: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds support for embedding PIEs into the kernel, loading them
into genalloc sections, performing necessary relocations, and running code
from them. This allows platforms that need to run code from SRAM, such
an during suspend/resume, to develop that code in C instead of assembly.

Functions and data for each PIE should be grouped into sections with the
__pie(<group>) and __pie_data(<group>) macros respectively. Any symbols or
functions that are to be accessed from outside the PIE should be marked with
EXPORT_PIE_SYMBOL(<sym>). For example:

static struct ddr_timings xyz_timings __pie_data(platformxyz) = {
	[...]
};

void __pie(platformxyz) xyz_ddr_on(void *addr)
{
	[...]
}
EXPORT_PIE_SYMBOL(xyz_ddr_on);

While the kernel can access exported symbols from the PIE, the PIE cannot
access symbols from the kernel, but can access data from the kernel and
call functions in the kernel so long as addresses are passed into the PIE.

PIEs are loaded from the kernel into a genalloc pool with pie_load_sections.
pie_load_sections allocates space within the pool, copies the neccesary
code/data, and performs any necessary relocations. A chunk identifier is
returned for removing the PIE from the pool, and for translating symbols.

Because the PIEs are dynamically relocated, special accessors must be used
to access PIE symbols from kernel code:

- kern_to_pie(chunk, ptr):   Translate a PIE symbol to the virtual address
                             it is loaded into within the pool.

- fn_to_pie(chunk, ptr):     Same as above, but for function pointers.

- sram_to_phys(chunk, addr): Translate a virtual address within a loaded PIE
                             to a physical address.

Loading a PIE involves three main steps. First a set of common functions to
cover built-ins emitted by gcc (memcpy, memmove, etc) is copied into the pool.
Then the actual PIE code and data is copied into the pool. Because the PIE
code is contained within an overlay with other PIEs, offsets to the common
functions are maintained. Finally, relocations are performed as necessary.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
---
 Documentation/pie.txt             | 167 ++++++++++++++++++++++++++++++++
 Makefile                          |  17 +++-
 include/asm-generic/pie.lds.h     |  82 ++++++++++++++++
 include/asm-generic/vmlinux.lds.h |   1 +
 include/linux/pie.h               | 196 ++++++++++++++++++++++++++++++++++++++
 lib/Kconfig                       |  14 +++
 lib/Makefile                      |   2 +
 lib/pie.c                         | 138 +++++++++++++++++++++++++++
 pie/.gitignore                    |   3 +
 pie/Makefile                      |  85 +++++++++++++++++
 scripts/link-vmlinux.sh           |  11 ++-
 11 files changed, 711 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/pie.txt
 create mode 100644 include/asm-generic/pie.lds.h
 create mode 100644 include/linux/pie.h
 create mode 100644 lib/pie.c
 create mode 100644 pie/.gitignore
 create mode 100644 pie/Makefile

diff --git a/Documentation/pie.txt b/Documentation/pie.txt
new file mode 100644
index 0000000..54a1646
--- /dev/null
+++ b/Documentation/pie.txt
@@ -0,0 +1,167 @@
+Position Independent Executables (PIEs)
+=======================================
+
+About
+=====
+
+The PIE framework is designed to allow normal C code from the kernel to be
+embedded into the kernel, loaded at arbirary addresses, and executed.
+
+A PIE is a position independent executable is a piece of self contained code
+that can be relocated to any address. Before the code is run, a simple list
+of offset based relocations has to be performed.
+
+Copyright 2013 Texas Instruments, Inc
+	Russ Dill <russ.dill@ti.com>
+
+Motivation
+==========
+
+Without the PIE framework, the only way to support platforms that require
+code loaded to and run from arbitrary addresses was to write the code in
+assembly. For example, a platform may have suspend/resume steps that
+disable/enable SDRAM and must be run from on chip SRAM.
+
+In addition to the SRAM virtual address not being known at compile time
+for device tree platforms, the code must often run with the MMU enabled or
+disabled (physical vs virtual address).
+
+Design
+======
+
+The PIE code is separated into two main pieces. libpie satifies various
+function calls emitted by gcc. The kernel contains only one copy of libpie
+but whenever a PIE is loaded, a copy of libpie is copied along with the PIE
+code. The second piece is the PIE code and data marked with special PIE
+sections. At build time, libpie and the PIE sections are collected together
+into a single PIE executable:
+
+	+---------------------------------------+
+	| __pie_common_start			|
+	|	<libpie>			|
+	| __pie_common_end			|
+	+---------------------------------------+
+	| __pie_overlay_start			|
+	| +-----------------------------+	|
+	| | __pie_groupxyz_start	|	|
+	| |   <groupxyz functions/data>	|	|
+	| | __pie_groupxyz_end		|	|
+	| +-----------------------------+	|
+	| | __pie_groupabc_start	|	|
+	| |   <groupabc functions/data>	|	|
+	| | __pie_groupabc_end		|	|
+	| +-----------------------------+	|
+	| | __pie_groupijk_start	|	|
+	| |   <groupijk functions/data>	|	|
+	| | __pie_groupijk_end		|	|
+	| +-----------------------------+	|
+	| __pie_overlay_end			|
+	+---------------------------------------+
+	| <Architecture specific relocations>	|
+	+---------------------------------------+
+
+The PIE executable is then embedded into the kernel. Symbols are exported
+from the PIE executable and passed back into the kernel at link time. When
+the PIE is loaded, the memory layout then looks like the following:
+
+	+---------------------------------------+
+	| <libpie>				|
+	+---------------------------------------+
+	| <groupabc_functions/data>		|
+	+---------------------------------------+
+	| Tail (Arch specific data/relocations	|
+	+---------------------------------------+
+
+The architecture specific code is responsible for reading the relocations
+and performing the necessary fixups.
+
+Marking code/data
+=================
+
+Marking code and data for inclusing into a PIE group is done with the PIE
+section markers, __pie(<group>) and __pie_data(<group>). Any symbols that
+will be used outside of the PIE must be exported with EXPORT_PIE_SYMBOL:
+
+    static struct ddr_timings xyz_timings __pie_data(platformxyz) = {
+    	[...]
+    };
+    
+    void __pie(platformxyz) xyz_ddr_on(void *addr)
+    {
+    	[...]
+    }
+    EXPORT_PIE_SYMBOL(xyz_ddr_on);
+
+Loading PIEs
+============
+
+PIEs can be loaded into a genalloc pool (such as one backed by SRAM). The
+following functions are provided:
+
+ - pie_load_sections(pool, <group>)
+ - pie_load_sections_phys(pool, <group>)
+ - pie_free(chunk)
+
+pie_load_sections/pie_load_sections_phys load a PIE section group into the
+given pool. Any necessary fixups are peformed and a chunk identifier is
+returned. The first variant performs fixups such that the code can be run
+with the current address layout. The second (phys) variant performs fixups
+such that the code can be executed with the MMU disabled.
+
+The pie_free function unloads a PIE from a pool.
+
+Utilizing PIEs
+==============
+
+In order to translate between symbols and addresses within a loaded PIE, the
+following macros/functions are provided:
+
+ - kern_to_pie(chunk, sym)
+ - fn_to_pie(chunk, fn)
+ - pie_to_phys(chunk, addr)
+
+All three take as the first argument the chunk returned by pie_load_sections.
+Data symbols can be translated with kern_to_pie. The macro is made so that
+the type returned is the type passed:
+
+   kern_to_pie(chunk, xyz_struct_ptr)->foo = 15;
+   *kern_to_pie(chunk, &xyz_flags) = XYZ_DO_THE_THING;
+
+Because certain architectures require special handling of function pointers,
+a special varaint is provided:
+
+   ret = fn_to_pie(chunk, &xyz_ddr_on)(addr);
+   fnptr = fn_to_pie(chunk, &abc_fn);
+
+In the case that a PIE has been configured to run with the MMU disabled,
+physical addresses can be translated with pie_to_phys. For instance, if
+the resume ROM jumps to a given physical address:
+
+   trampoline = fn_to_pie(chunk, resume_trampoline);
+   writel(pie_to_phys(chunk, trampoline), XYZ_RESUME_ADDR_REG);
+
+On the Fly Fixup
+================
+
+The tail portion of the PIE can be used to store data necessary to perform
+on the fly fixups. This is necessary for code that needs to run from
+different address spaces at different times. Any on the fly fixup support
+is architecture specific.
+
+Architecture Requirements
+=========================
+
+Individual architectures must implement two functions:
+
+pie_arch_fill_tail - This function examines the architecture specific
+relocation entries and copies the ones necessary for the given PIE.
+
+pie_arch_fixup - This function performs fixups of the PIE code based
+on the tail data generated above.
+
+pie.lds - A linker script for the PIE executable must be provided.
+include/asm-generic/pie.lds.S provides a template.
+
+libpie.o - The architecture must also provide a library of functions that
+gcc may expect as a built-in, such as memcpy, memmove, etc. The list of
+functions is architecture specific.
diff --git a/Makefile b/Makefile
index fe8204b..4791a0f 100644
--- a/Makefile
+++ b/Makefile
@@ -396,7 +396,7 @@ export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE CFLAGS_GCOV
 export KBUILD_AFLAGS AFLAGS_KERNEL AFLAGS_MODULE
 export KBUILD_AFLAGS_MODULE KBUILD_CFLAGS_MODULE KBUILD_LDFLAGS_MODULE
 export KBUILD_AFLAGS_KERNEL KBUILD_CFLAGS_KERNEL
-export KBUILD_ARFLAGS
+export KBUILD_ARFLAGS OBJCOPY_OUTPUT_FORMAT
 
 # When compiling out-of-tree modules, put MODVERDIR in the module
 # tree rather than in the kernel tree. The kernel tree might
@@ -682,6 +682,10 @@ ifeq ($(CONFIG_STRIP_ASM_SYMS),y)
 LDFLAGS_vmlinux	+= $(call ld-option, -X,)
 endif
 
+ifeq ($(CONFIG_PIE),y)
+LDFLAGS_vmlinux += --just-symbols=pie/pie.syms
+endif
+
 # Default kernel image to build when no specific target is given.
 # KBUILD_IMAGE may be overruled on the command line or
 # set in the environment
@@ -737,13 +741,15 @@ core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
-		     $(net-y) $(net-m) $(libs-y) $(libs-m)))
+		     $(net-y) $(net-m) $(libs-y) $(libs-m) $(libpie-y)))
 
 vmlinux-alldirs	:= $(sort $(vmlinux-dirs) $(patsubst %/,%,$(filter %/, \
 		     $(init-n) $(init-) \
 		     $(core-n) $(core-) $(drivers-n) $(drivers-) \
 		     $(net-n)  $(net-)  $(libs-n)    $(libs-))))
 
+pie-$(CONFIG_PIE) := pie/
+
 init-y		:= $(patsubst %/, %/built-in.o, $(init-y))
 core-y		:= $(patsubst %/, %/built-in.o, $(core-y))
 drivers-y	:= $(patsubst %/, %/built-in.o, $(drivers-y))
@@ -751,16 +757,21 @@ net-y		:= $(patsubst %/, %/built-in.o, $(net-y))
 libs-y1		:= $(patsubst %/, %/lib.a, $(libs-y))
 libs-y2		:= $(patsubst %/, %/built-in.o, $(libs-y))
 libs-y		:= $(libs-y1) $(libs-y2)
+pie-y		:= $(patsubst %/, %/built-in.o, $(pie-y))
+libpie-y	:= $(patsubst %/, %/built-in.o, $(libpie-y))
 
 # Externally visible symbols (used by link-vmlinux.sh)
 export KBUILD_VMLINUX_INIT := $(head-y) $(init-y)
 export KBUILD_VMLINUX_MAIN := $(core-y) $(libs-y) $(drivers-y) $(net-y)
+export KBUILD_VMLINUX_PIE  := $(pie-y)
+export KBUILD_LIBPIE       := $(libpie-y)
+export KBUILD_PIE_LDS      := $(PIE_LDS)
 export KBUILD_LDS          := arch/$(SRCARCH)/kernel/vmlinux.lds
 export LDFLAGS_vmlinux
 # used by scripts/pacmage/Makefile
 export KBUILD_ALLDIRS := $(sort $(filter-out arch/%,$(vmlinux-alldirs)) arch Documentation include samples scripts tools virt)
 
-vmlinux-deps := $(KBUILD_LDS) $(KBUILD_VMLINUX_INIT) $(KBUILD_VMLINUX_MAIN)
+vmlinux-deps := $(KBUILD_LDS) $(KBUILD_PIE_LDS) $(KBUILD_VMLINUX_INIT) $(KBUILD_VMLINUX_MAIN) $(KBUILD_VMLINUX_PIE)
 
 # Final link of vmlinux
       cmd_link-vmlinux = $(CONFIG_SHELL) $< $(LD) $(LDFLAGS) $(LDFLAGS_vmlinux)
diff --git a/include/asm-generic/pie.lds.h b/include/asm-generic/pie.lds.h
new file mode 100644
index 0000000..2f8d20e
--- /dev/null
+++ b/include/asm-generic/pie.lds.h
@@ -0,0 +1,82 @@
+/*
+ * Helper macros to support writing architecture specific
+ * pie linker scripts.
+ *
+ * A minimal linker scripts has following content:
+ * [This is a sample, architectures may have special requiriements]
+ *
+ * OUTPUT_FORMAT(...)
+ * OUTPUT_ARCH(...)
+ * SECTIONS
+ * {
+ *	. = 0x0;
+ *
+ *	PIE_COMMON_START
+ *	.text {
+ *		PIE_TEXT_TEXT
+ *	}
+ *	PIE_COMMON_END
+ *
+ *	PIE_OVERLAY_START
+ *	OVERLAY : NOCROSSREFS {
+ *		PIE_OVERLAY_SECTION(am33xx)
+ *		PIE_OVERLAY_SECTION(am347x)
+ *		[...]
+ *	}
+ *	PIE_OVERLAY_END
+ *
+ *	PIE_DISCARDS		// must be the last
+ * }
+ */
+
+#include <asm-generic/vmlinux.lds.h>
+
+#define PIE_COMMON_START						\
+	__pie_common_start : {						\
+		VMLINUX_SYMBOL(__pie_common_start) = .;			\
+	}
+
+#define PIE_COMMON_END							\
+	__pie_common_end : {						\
+		VMLINUX_SYMBOL(__pie_common_end) = .;			\
+	}
+
+#define PIE_OVERLAY_START						\
+	__pie_overlay_start : {						\
+		VMLINUX_SYMBOL(__pie_overlay_start) = .;		\
+	}
+
+#define PIE_OVERLAY_END							\
+	__pie_overlay_end : {						\
+		VMLINUX_SYMBOL(__pie_overlay_end) = .;			\
+	}
+
+#define PIE_TEXT_TEXT							\
+	KEEP(*(.pie.text))
+
+#define PIE_OVERLAY_SECTION(name)					\
+	.pie.##name {							\
+		KEEP(*(.pie.##name##.*))				\
+		VMLINUX_SYMBOL(__pie_##name##_start) =			\
+				LOADADDR(.pie.##name##);		\
+		VMLINUX_SYMBOL(__pie_##name##_end) =			\
+				LOADADDR(.pie.##name##) +		\
+				SIZEOF(.pie.##name##);			\
+	}
+
+#define PIE_DISCARDS							\
+	/DISCARD/ : {							\
+	*(.dynsym)							\
+	*(.dynstr*)							\
+	*(.dynamic*)							\
+	*(.plt*)							\
+	*(.interp*)							\
+	*(.gnu*) 							\
+	*(.hash)							\
+	*(.comment)							\
+	*(.bss*)							\
+	*(.data)							\
+	*(.discard)							\
+	*(.discard.*)							\
+	}
+
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 69732d2..5a21cfe 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -666,6 +666,7 @@
 	EXIT_CALL							\
 	*(.discard)							\
 	*(.discard.*)							\
+	*(.pie.*)							\
 	}
 
 /**
diff --git a/include/linux/pie.h b/include/linux/pie.h
new file mode 100644
index 0000000..66450c1
--- /dev/null
+++ b/include/linux/pie.h
@@ -0,0 +1,196 @@
+/*
+ * Copyright 2013 Texas Instruments, Inc.
+ *      Russ Dill <russ.dill@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ */
+
+#ifndef _LINUX_PIE_H
+#define _LINUX_PIE_H
+
+#include <linux/kernel.h>
+#include <linux/err.h>
+
+#include <asm/fncpy.h>
+#include <asm/bug.h>
+
+struct gen_pool;
+struct pie_chunk;
+
+/**
+ * pie_arch_fixup - arch specific fixups of copied PIE code
+ * @chunk:	identifier to be used with kern_to_pie/pie_to_phys
+ * @base:	virtual address of start of copied PIE section
+ * @tail:	virtual address of tail data in copied PIE
+ * @offset:	offset to apply to relocation entries.
+ *
+ * When this code is done executing, it should be possible to jump to code
+ * so long as it is located at the given offset.
+ */
+extern int pie_arch_fixup(struct pie_chunk *chunk, void *base, void *tail,
+							unsigned long offset);
+
+/**
+ * pie_arch_fill_tail - arch specific tail information for copied PIE
+ * @tail:		virtual address of tail data in copied PIE to be filled
+ * @common_start:	virtual address of common code within kernel data
+ * @common_end:		virtual end address of common code within kernel data
+ * @overlay_start:	virtual address of first overlay within kernel data
+ * @code_start:		virtual address of this overlay within kernel data
+ * @code_end:		virtual end address of this overlay within kernel data
+ *
+ * Fill tail data with data necessary to for pie_arch_fixup to perform
+ * relocations. If tail is NULL, do not update data, but still calculate
+ * the number of bytes required.
+ *
+ * Returns number of bytes required/used for tail on success, -EERROR otherwise.
+ */
+extern int pie_arch_fill_tail(void *tail, void *common_start, void *common_end,
+			void *overlay_start, void *code_start, void *code_end);
+
+#ifdef CONFIG_PIE
+
+/**
+ * __pie_load_data - load and fixup PIE code from kernel data
+ * @pool:	pool to allocate memory from and copy code into
+ * @start:	virtual start address in kernel of chunk specific code
+ * @end:	virtual end address in kernel of chunk specific code
+ * @phys:	%true to fixup to physical address of destination, %false to
+ *		fixup to virtual address of destination
+ *
+ * Returns 0 on success, -EERROR otherwise
+ */
+extern struct pie_chunk *__pie_load_data(struct gen_pool *pool,
+				void *start, void *end, bool phys);
+
+/**
+ * pie_to_phys - translate a virtual PIE address into a physical one
+ * @chunk:	identifier returned by pie_load_sections
+ * @addr:	virtual address within pie chunk
+ *
+ * Returns physical address on success, -1 otherwise
+ */
+extern phys_addr_t pie_to_phys(struct pie_chunk *chunk, unsigned long addr);
+
+extern void __iomem *__kern_to_pie(struct pie_chunk *chunk, void *ptr);
+
+/**
+ * pie_free - free the pool space used by an pie chunk
+ * @chunk:	identifier returned by pie_load_sections
+ */
+extern void pie_free(struct pie_chunk *chunk);
+
+#define __pie_load_sections(pool, name, phys) ({			\
+	extern char __pie_##name##_start[];				\
+	extern char __pie_##name##_end[];				\
+									\
+	__pie_load_data(pool, __pie_##name##_start,			\
+					__pie_##name##_end, phys);	\
+})
+
+/*
+ * Required for any symbol within an PIE section that is referenced by the
+ * kernel
+ */
+#define EXPORT_PIE_SYMBOL(sym)		extern typeof(sym) sym __weak
+
+/* For marking data and functions that should be part of a PIE */
+#define __pie(name)	__attribute__ ((__section__(".pie." #name ".text")))
+#define __pie_data(name) __attribute__ ((__section__(".pie." #name ".data")))
+
+#else
+
+static inline struct pie_chunk *__pie_load_data(struct gen_pool *pool,
+					void *start, void *end, bool phys)
+{
+	return ERR_PTR(-EINVAL);
+}
+
+static inline phys_addr_t pie_to_phys(struct pie_chunk *chunk,
+						unsigned long addr)
+{
+	return -1;
+}
+
+static inline void __iomem *__kern_to_pie(struct pie_chunk *chunk, void *ptr)
+{
+	return NULL;
+}
+
+static inline void pie_free(struct pie_chunk *chunk)
+{
+}
+
+#define __pie_load_sections(pool, name, phys) ({ ERR_PTR(-EINVAL); })
+
+#define EXPORT_PIE_SYMBOL(sym)
+
+#define __pie(name)
+#define __pie_data(name)
+
+#endif
+
+/**
+ * pie_load_sections - load and fixup sections associated with the given name
+ * @pool:	pool to allocate memory from and copy code into
+ *		fixup to virtual address of destination
+ * @name:	the name given to __pie() and __pie_data() when marking
+ *		data and code
+ *
+ * Returns 0 on success, -EERROR otherwise
+ */
+#define pie_load_sections(pool, name) ({				\
+	__pie_load_sections(pool, name, false);				\
+})
+
+/**
+ * pie_load_sections_phys - load and fixup sections associated with the given
+ * name for execution with the MMU off
+ *
+ * @pool:	pool to allocate memory from and copy code into
+ *		fixup to virtual address of destination
+ * @name:	the name given to __pie() and __pie_data() when marking
+ *		data and code
+ *
+ * Returns 0 on success, -EERROR otherwise
+ */
+#define pie_load_sections_phys(pool, name) ({				\
+	__pie_load_sections(pool, name, true);				\
+})
+
+/**
+ * kern_to_pie - convert a kernel symbol to the virtual address of where
+ * that symbol is loaded into the given PIE chunk.
+ *
+ * @chunk:	identifier returned by pie_load_sections
+ * @p:		symbol to convert
+ *
+ * Return type is the same as type passed
+ */
+#define kern_to_pie(chunk, p) ({					\
+	void *__ptr = (void *) (p);					\
+	typeof(p) __result = (typeof(p)) __kern_to_pie(chunk, __ptr);	\
+	__result;							\
+})
+
+/**
+ * kern_to_fn - convert a kernel function symbol to the virtual address of where
+ * that symbol is loaded into the given PIE chunk
+ *
+ * @chunk:	identifier returned by pie_load_sections
+ * @p:		function to convert
+ *
+ * Return type is the same as type passed
+ */
+#define fn_to_pie(chunk, funcp) ({					\
+	uintptr_t __kern_addr, __pie_addr;				\
+									\
+	__kern_addr = fnptr_to_addr(funcp);				\
+	__pie_addr = kern_to_pie(chunk, __kern_addr);			\
+									\
+	fnptr_translate(funcp, __pie_addr);				\
+})
+
+#endif
diff --git a/lib/Kconfig b/lib/Kconfig
index 71d9f81..d47df14 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -353,6 +353,20 @@ config DQL
 config NLATTR
 	bool
 
+config HAVE_PIE
+        bool
+        help
+          See Documentation/pie.txt for details.
+
+config PIE
+	bool "Embedded position independant executables"
+	depends on HAVE_PIE
+	help
+	  This option adds support for embedding position indepentant (PIE)
+	  executables into the kernel. The PIEs can then be copied into
+	  genalloc regions such as SRAM and executed. Some platforms require
+	  this for suspend/resume support.
+
 #
 # Generic 64-bit atomic support is selected if needed
 #
diff --git a/lib/Makefile b/lib/Makefile
index 7baccfd..2b6123d 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -145,6 +145,8 @@ obj-$(CONFIG_GENERIC_NET_UTILS) += net_utils.o
 
 obj-$(CONFIG_STMP_DEVICE) += stmp_device.o
 
+obj-$(CONFIG_PIE) += pie.o
+
 libfdt_files = fdt.o fdt_ro.o fdt_wip.o fdt_rw.o fdt_sw.o fdt_strerror.o
 $(foreach file, $(libfdt_files), \
 	$(eval CFLAGS_$(file) = -I$(src)/../scripts/dtc/libfdt))
diff --git a/lib/pie.c b/lib/pie.c
new file mode 100644
index 0000000..c0190dd
--- /dev/null
+++ b/lib/pie.c
@@ -0,0 +1,138 @@
+/*
+ * Copyright 2013 Texas Instruments, Inc.
+ *	Russ Dill <russ.dill@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/genalloc.h>
+#include <linux/pie.h>
+#include <asm/cacheflush.h>
+
+struct pie_chunk {
+	struct gen_pool *pool;
+	unsigned long addr;
+	size_t sz;
+};
+
+extern char __pie_common_start[];
+extern char __pie_common_end[];
+extern char __pie_overlay_start[];
+
+int __weak pie_arch_fill_tail(void *tail, void *common_start, void *common_end,
+			void *overlay_start, void *code_start, void *code_end)
+{
+	return 0;
+}
+
+int __weak pie_arch_fixup(struct pie_chunk *chunk, void *base, void *tail,
+							unsigned long offset)
+{
+	return 0;
+}
+
+struct pie_chunk *__pie_load_data(struct gen_pool *pool, void *code_start,
+					void *code_end, bool phys)
+{
+	struct pie_chunk *chunk;
+	unsigned long offset;
+	int ret;
+	char *tail;
+	size_t common_sz;
+	size_t code_sz;
+	size_t tail_sz;
+
+	/* Calculate the tail size */
+	ret = pie_arch_fill_tail(NULL, __pie_common_start, __pie_common_end,
+				__pie_overlay_start, code_start, code_end);
+	if (ret < 0)
+		goto err;
+	tail_sz = ret;
+
+	chunk = kzalloc(sizeof(*chunk), GFP_KERNEL);
+	if (!chunk) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	common_sz = __pie_overlay_start - __pie_common_start;
+	code_sz = code_end - code_start;
+
+	chunk->pool = pool;
+	chunk->sz = common_sz + code_sz + tail_sz;
+
+	chunk->addr = gen_pool_alloc(pool, chunk->sz);
+	if (!chunk->addr) {
+		ret = -ENOMEM;
+		goto err_free;
+	}
+
+	/* Copy common code/data */
+	tail = (char *) chunk->addr;
+	memcpy(tail, __pie_common_start, common_sz);
+	tail += common_sz;
+
+	/* Copy chunk specific code/data */
+	memcpy(tail, code_start, code_sz);
+	tail += code_sz;
+
+	/* Fill in tail data */
+	ret = pie_arch_fill_tail(tail, __pie_common_start, __pie_common_end,
+				__pie_overlay_start, code_start, code_end);
+	if (ret < 0)
+		goto err_alloc;
+
+	/* Calculate initial offset */
+	if (phys)
+		offset = gen_pool_virt_to_phys(pool, chunk->addr);
+	else
+		offset = chunk->addr;
+
+	/* Perform arch specific code fixups */
+	ret = pie_arch_fixup(chunk, (void *) chunk->addr, tail, offset);
+	if (ret < 0)
+		goto err_alloc;
+
+	flush_icache_range(chunk->addr, chunk->addr + chunk->sz);
+
+	return chunk;
+
+err_alloc:
+	gen_pool_free(chunk->pool, chunk->addr, chunk->sz);
+
+err_free:
+	kfree(chunk);
+err:
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(__pie_load_data);
+
+phys_addr_t pie_to_phys(struct pie_chunk *chunk, unsigned long addr)
+{
+	return gen_pool_virt_to_phys(chunk->pool, addr);
+}
+EXPORT_SYMBOL_GPL(pie_to_phys);
+
+void __iomem *__kern_to_pie(struct pie_chunk *chunk, void *ptr)
+{
+	uintptr_t offset = (uintptr_t) ptr;
+	offset -= (uintptr_t) __pie_common_start;
+	if (offset >= chunk->sz)
+		return NULL;
+	else
+		return (void *) (chunk->addr + offset);
+}
+EXPORT_SYMBOL_GPL(__kern_to_pie);
+
+void pie_free(struct pie_chunk *chunk)
+{
+	gen_pool_free(chunk->pool, chunk->addr, chunk->sz);
+	kfree(chunk);
+}
+EXPORT_SYMBOL_GPL(pie_free);
diff --git a/pie/.gitignore b/pie/.gitignore
new file mode 100644
index 0000000..4f29803
--- /dev/null
+++ b/pie/.gitignore
@@ -0,0 +1,3 @@
+*.syms
+pie.lds
+pie.lds.S
diff --git a/pie/Makefile b/pie/Makefile
new file mode 100644
index 0000000..9afed70
--- /dev/null
+++ b/pie/Makefile
@@ -0,0 +1,85 @@
+#
+# linux/pie/Makefile
+#
+# Copyright 2013 Texas Instruments, Inc.
+#      Russ Dill <russ.dill@ti.com>
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms and conditions of the GNU General Public License,
+# version 2, as published by the Free Software Foundation.
+#
+
+obj-y		:= pie.bin.o
+
+# Report unresolved symbol references
+ldflags-y	+= --no-undefined
+# Delete all temporary local symbols
+ldflags-y	+= -X
+
+# Reset objcopy flags, ARM puts "-O binary" here
+OBJCOPYFLAGS	=
+
+# Reference gcc builtins for use in PIE with __pie_
+$(obj)/pie_rename.syms: $(KBUILD_LIBPIE)
+	@$(NM) $^ | awk '{if ($$3) print $$3,"__pie_"$$3}' > $@
+
+# For weakening the links to the original gcc builtins
+$(obj)/pie_weaken.syms: $(KBUILD_LIBPIE)
+	@$(NM) $^ | awk '{if ($$3) print "__pie_"$$3}' > $@
+
+# For embedding address of the symbols copied from the PIE into the kernel
+$(obj)/pie.syms: $(obj)/pie.elf
+	@$(NM) $^ | awk '{if ($$3 && $$2 == toupper($$2)) print $$3,"=","0x"$$1" + _binary_pie_pie_bin_start;"}' > $@
+
+# Collect together the libpie objects
+LDFLAGS_libpie_stage1.o += -r
+
+$(obj)/libpie_stage1.o: $(KBUILD_LIBPIE)
+	$(call if_changed,ld)
+
+# Rename the libpie gcc builtins with a __pie_ prefix
+OBJCOPYFLAGS_libpie_stage2.o += --redefine-syms=$(obj)/pie_rename.syms
+OBJCOPYFLAGS_libpie_stage2.o += --rename-section .text=.pie.text
+
+$(obj)/libpie_stage2.o: $(obj)/libpie_stage1.o
+	$(call if_changed,objcopy)
+
+# Generate a version of vmlinux.o with weakened and rename references to gcc
+# builtins.
+OBJCOPYFLAGS_pie_stage1.o += --weaken-symbols=$(obj)/pie_weaken.syms
+OBJCOPYFLAGS_pie_stage1.o += --redefine-syms=$(obj)/pie_rename.syms
+
+$(obj)/pie_stage1.o: $(obj)/../vmlinux.o $(obj)/pie_rename.syms $(obj)/pie_weaken.syms
+	$(call if_changed,objcopy)
+
+# Drop in the PIE versions instead
+LDFLAGS_pie_stage2.o += -r
+# Allow the _GLOBAL_OFFSET_TABLE to redefine
+LDFLAGS_pie_stage2.o += --defsym=_GLOBAL_OFFSET_TABLE_=_GLOBAL_OFFSET_TABLE_
+
+$(obj)/pie_stage2.o: $(obj)/pie_stage1.o $(obj)/libpie_stage2.o
+	$(call if_changed,ld)
+
+# Drop everything but the pie sections
+OBJCOPYFLAGS_pie_stage3.o += -j ".pie.*"
+
+$(obj)/pie_stage3.o: $(obj)/pie_stage2.o
+	$(call if_changed,objcopy)
+
+# Create the position independant executable
+LDFLAGS_pie.elf += -T $(KBUILD_PIE_LDS) --pie --gc-sections
+
+$(obj)/pie.elf: $(obj)/pie_stage3.o $(KBUILD_PIE_LDS)
+	$(call if_changed,ld)
+
+# Create binary data for the kernel
+OBJCOPYFLAGS_pie.bin += -O binary
+
+$(obj)/pie.bin: $(obj)/pie.elf $(obj)/pie.syms
+	$(call if_changed,objcopy)
+
+# Import the data into the kernel
+OBJCOPYFLAGS_pie.bin.o += -B $(ARCH) -I binary -O $(OBJCOPY_OUTPUT_FORMAT)
+
+$(obj)/pie.bin.o: $(obj)/pie.bin
+	$(call if_changed,objcopy)
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 0149949..8cf4971 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -55,12 +55,16 @@ vmlinux_link()
 	if [ "${SRCARCH}" != "um" ]; then
 		${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} -o ${2}                  \
 			-T ${lds} ${KBUILD_VMLINUX_INIT}                     \
-			--start-group ${KBUILD_VMLINUX_MAIN} --end-group ${1}
+			--start-group					     \
+				${KBUILD_VMLINUX_MAIN}			     \
+				${KBUILD_VMLINUX_PIE}			     \
+			--end-group ${1}
 	else
 		${CC} ${CFLAGS_vmlinux} -o ${2}                              \
 			-Wl,-T,${lds} ${KBUILD_VMLINUX_INIT}                 \
 			-Wl,--start-group                                    \
 				 ${KBUILD_VMLINUX_MAIN}                      \
+				 ${KBUILD_VMLINUX_PIE}                       \
 			-Wl,--end-group                                      \
 			-lutil ${1}
 		rm -f linux
@@ -143,10 +147,13 @@ esac
 #link vmlinux.o
 info LD vmlinux.o
 modpost_link vmlinux.o
-
 # modpost vmlinux.o to check for section mismatches
 ${MAKE} -f "${srctree}/scripts/Makefile.modpost" vmlinux.o
 
+if [ -n "${CONFIG_PIE}" ]; then
+	${MAKE} -f "${srctree}/scripts/Makefile.build" obj=pie
+fi
+
 # Update version
 info GEN .version
 if [ ! -r .version ]; then
-- 
1.8.3.2

