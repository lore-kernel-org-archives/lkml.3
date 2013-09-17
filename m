Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab3IQKCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 06:02:54 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:53587 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab3IQKCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 06:02:20 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] kexec: Add preliminary m68k support
Date: Tue, 17 Sep 2013 12:01:35 +0200
Message-Id: <1379412095-7213-6-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379412095-7213-1-git-send-email-geert@linux-m68k.org>
References: <1379412095-7213-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 configure.ac                           |    2 +-
 kexec/Makefile                         |    1 +
 kexec/arch/m68k/Makefile               |   15 +++
 kexec/arch/m68k/bootinfo.c             |  208 ++++++++++++++++++++++++++++++++
 kexec/arch/m68k/bootinfo.h             |   29 +++++
 kexec/arch/m68k/include/arch/options.h |   45 +++++++
 kexec/arch/m68k/kexec-elf-m68k.c       |  171 ++++++++++++++++++++++++++
 kexec/arch/m68k/kexec-elf-rel-m68k.c   |   41 +++++++
 kexec/arch/m68k/kexec-m68k.c           |  113 +++++++++++++++++
 kexec/arch/m68k/kexec-m68k.h           |    9 ++
 kexec/kexec-syscall.h                  |    7 ++
 11 files changed, 640 insertions(+), 1 deletion(-)
 create mode 100644 kexec/arch/m68k/Makefile
 create mode 100644 kexec/arch/m68k/bootinfo.c
 create mode 100644 kexec/arch/m68k/bootinfo.h
 create mode 100644 kexec/arch/m68k/include/arch/options.h
 create mode 100644 kexec/arch/m68k/kexec-elf-m68k.c
 create mode 100644 kexec/arch/m68k/kexec-elf-rel-m68k.c
 create mode 100644 kexec/arch/m68k/kexec-m68k.c
 create mode 100644 kexec/arch/m68k/kexec-m68k.h

diff --git a/configure.ac b/configure.ac
index 7b61dbf..704d4f9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -45,7 +45,7 @@ case $target_cpu in
 	cris|crisv32 )
 		ARCH="cris"
 		;;
-	ia64|x86_64|alpha )
+	ia64|x86_64|alpha|m68k )
 		ARCH="$target_cpu"
 		;;
 	* )
diff --git a/kexec/Makefile b/kexec/Makefile
index 8a6138d..ceb33af 100644
--- a/kexec/Makefile
+++ b/kexec/Makefile
@@ -72,6 +72,7 @@ include $(srcdir)/kexec/arch/alpha/Makefile
 include $(srcdir)/kexec/arch/arm/Makefile
 include $(srcdir)/kexec/arch/i386/Makefile
 include $(srcdir)/kexec/arch/ia64/Makefile
+include $(srcdir)/kexec/arch/m68k/Makefile
 include $(srcdir)/kexec/arch/mips/Makefile
 include $(srcdir)/kexec/arch/cris/Makefile
 include $(srcdir)/kexec/arch/ppc/Makefile
diff --git a/kexec/arch/m68k/Makefile b/kexec/arch/m68k/Makefile
new file mode 100644
index 0000000..4645894
--- /dev/null
+++ b/kexec/arch/m68k/Makefile
@@ -0,0 +1,15 @@
+#
+# kexec m68k (linux booting linux)
+#
+m68k_KEXEC_SRCS =  kexec/arch/m68k/kexec-m68k.c
+m68k_KEXEC_SRCS += kexec/arch/m68k/kexec-elf-m68k.c
+m68k_KEXEC_SRCS += kexec/arch/m68k/kexec-elf-rel-m68k.c
+m68k_KEXEC_SRCS += kexec/arch/m68k/bootinfo.c
+
+m68k_ADD_BUFFER =
+m68k_ADD_SEGMENT =
+m68k_VIRT_TO_PHYS =
+
+dist += kexec/arch/m68k/Makefile $(m68k_KEXEC_SRCS)			\
+	kexec/arch/m68k/kexec-m68k.h					\
+	kexec/arch/m68k/include/arch/options.h
diff --git a/kexec/arch/m68k/bootinfo.c b/kexec/arch/m68k/bootinfo.c
new file mode 100644
index 0000000..328a838
--- /dev/null
+++ b/kexec/arch/m68k/bootinfo.c
@@ -0,0 +1,208 @@
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "../../kexec.h"
+
+#include "bootinfo.h"
+
+const char *bootinfo_file = DEFAULT_BOOTINFO_FILE;
+static struct bi_records *bootinfo;
+static off_t bootinfo_size;
+
+static unsigned int num_memchunks;
+
+static struct bi_records *bi_next(struct bi_records *bi, uint16_t size)
+{
+	return (void *)((unsigned long)bi + size);
+}
+
+static void bi_remove(uint16_t tag)
+{
+	struct bi_records *bi;
+	off_t rem;
+	uint16_t size;
+
+	bi = bootinfo;
+	rem = bootinfo_size;
+	while (1) {
+		if (bi->tag == BI_LAST)
+			break;
+
+		size = bi->size;
+		if (bi->tag == tag) {
+			memmove(bi, bi_next(bi, size), rem - size);
+			bootinfo_size -= size;
+			rem -= size;
+			continue;
+		}
+
+		bi = bi_next(bi, size);
+		rem -= size;
+	}
+}
+
+static struct bi_records *bi_add(uint16_t tag, uint16_t size)
+{
+	struct bi_records *bi;
+
+	/* Add 4-byte header and round up to multiple of 4 bytes */
+	size = _ALIGN_UP(4 + size, 4);
+
+	bootinfo = xrealloc(bootinfo, bootinfo_size + size);
+
+	/* Replace old sentinel by new record */
+	bi = bi_next(bootinfo, bootinfo_size - 2);
+	bootinfo_size += size;
+	memset(bi, 0, size);
+	bi->tag = tag;
+	bi->size = size;
+
+	/* Re-add sentinel */
+	bi_next(bi, size)->tag = BI_LAST;
+
+	return bi;
+}
+
+void bootinfo_load(void)
+{
+	struct bi_records *bi;
+	off_t rem;
+	uint16_t tag, size;
+
+	printf("Loading bootinfo from %s\n", bootinfo_file);
+	bootinfo = (void *)slurp_file_len(bootinfo_file, MAX_BOOTINFO_SIZE,
+					  &bootinfo_size);
+	if (!bootinfo)
+		die("No bootinfo");
+
+	bi = bootinfo;
+	rem = bootinfo_size;
+	while (1) {
+		if (rem < 2)
+			die("Unexpected end of bootinfo");
+
+		tag = bi->tag;
+		if (tag == BI_LAST) {
+			rem -= 2;
+			break;
+		}
+
+		if (rem < 4)
+			die("Unexpected end of bootinfo");
+
+		size = bi->size;
+		if (size < 4 || size % 4)
+			die("Invalid tag size");
+		if (rem < size)
+			die("Unexpected end of bootinfo");
+
+		if (tag == BI_MEMCHUNK)
+			num_memchunks++;
+
+		bi = bi_next(bi, size);
+		rem -= size;
+	}
+
+	if (rem)
+		die("Trailing data at end of bootinfo");
+}
+
+void bootinfo_print(void)
+{
+	struct bi_records *bi = bootinfo;
+	uint16_t tag, size;
+
+	while (1) {
+		tag = bi->tag;
+		if (tag == BI_LAST) {
+			puts("BI_LAST");
+			break;
+		}
+
+		size = bi->size;
+		switch (tag) {
+		case BI_MEMCHUNK:
+			printf("BI_MEMCHUNK: 0x%08lx bytes at 0x%08lx\n",
+			       bi->mem_info.size, bi->mem_info.addr);
+			break;
+
+		case BI_RAMDISK:
+			printf("BI_RAMDISK: 0x%08lx bytes at 0x%08lx\n",
+			       bi->mem_info.size, bi->mem_info.addr);
+			break;
+
+		case BI_COMMAND_LINE:
+			printf("BI_COMMAND_LINE: %s\n", bi->string);
+			break;
+
+		default:
+			printf("BI tag 0x%04x size %u\n", tag, size);
+			break;
+		}
+		bi = bi_next(bi, size);
+	}
+}
+
+int bootinfo_get_memory_ranges(struct memory_range **range)
+{
+	struct memory_range *ranges;
+	struct bi_records *bi;
+	int i;
+
+	ranges = xmalloc(num_memchunks * sizeof(struct memory_range));
+	for (bi = bootinfo, i = 0; i < num_memchunks;
+	     bi = bi_next(bi, bi->size)) {
+		if (bi->tag != BI_MEMCHUNK)
+			continue;
+
+		ranges[i].start = bi->mem_info.addr;
+		ranges[i].end = bi->mem_info.addr + bi->mem_info.size - 1;
+		ranges[i].type = RANGE_RAM;
+		i++;
+	}
+
+	*range = ranges;
+	return num_memchunks;
+}
+
+void bootinfo_set_cmdline(const char *cmdline)
+{
+	struct bi_records *bi;
+	uint16_t size;
+
+	/* Remove existing command line records */
+	bi_remove(BI_COMMAND_LINE);
+
+	if (!cmdline)
+		return;
+
+	/* Add new command line record */
+	size = strlen(cmdline) + 1;
+	bi = bi_add(BI_COMMAND_LINE, size);
+	memcpy(bi->string, cmdline, size);
+}
+
+void bootinfo_set_ramdisk(unsigned long ramdisk_addr,
+			  unsigned long ramdisk_size)
+{
+	struct bi_records *bi;
+
+	/* Remove existing ramdisk records */
+	bi_remove(BI_RAMDISK);
+
+	if (!ramdisk_size)
+		return;
+
+	/* Add new ramdisk record */
+	bi = bi_add(BI_RAMDISK, sizeof(bi->mem_info));
+	bi->mem_info.addr = ramdisk_addr;
+	bi->mem_info.size = ramdisk_size;
+}
+
+void add_bootinfo(struct kexec_info *info, unsigned long addr)
+{
+	add_buffer(info, bootinfo, bootinfo_size, bootinfo_size,
+		   sizeof(void *), addr, 0x0fffffff, 1);
+}
diff --git a/kexec/arch/m68k/bootinfo.h b/kexec/arch/m68k/bootinfo.h
new file mode 100644
index 0000000..90e2576
--- /dev/null
+++ b/kexec/arch/m68k/bootinfo.h
@@ -0,0 +1,29 @@
+#define DEFAULT_BOOTINFO_FILE	"/proc/bootinfo"
+#define MAX_BOOTINFO_SIZE	1536
+
+struct bi_records {
+	unsigned short tag;
+	unsigned short size;
+	union {
+		unsigned long generic[0];
+		struct {
+			unsigned long addr;
+			unsigned long size;
+		} mem_info;
+		char string[0];
+	};
+};
+
+#define BI_LAST		0x0000	// FIXME To be obtained from <asm/bootinfo.h>
+#define BI_MEMCHUNK	0x0005	// FIXME
+#define BI_RAMDISK	0x0006	// FIXME
+#define BI_COMMAND_LINE	0x0007	// FIXME
+
+extern const char *bootinfo_file;
+extern void bootinfo_load(void);
+extern void bootinfo_print(void);
+extern int bootinfo_get_memory_ranges(struct memory_range **range);
+extern void bootinfo_set_cmdline(const char *cmdline);
+extern void bootinfo_set_ramdisk(unsigned long ramdisk_addr,
+				 unsigned long ramdisk_size);
+extern void add_bootinfo(struct kexec_info *info, unsigned long addr);
diff --git a/kexec/arch/m68k/include/arch/options.h b/kexec/arch/m68k/include/arch/options.h
new file mode 100644
index 0000000..f279d54
--- /dev/null
+++ b/kexec/arch/m68k/include/arch/options.h
@@ -0,0 +1,45 @@
+#ifndef KEXEC_ARCH_M68K_OPTIONS_H
+#define KEXEC_ARCH_M68K_OPTIONS_H
+
+#define OPT_ARCH_MAX		(OPT_MAX+0)
+
+/* All 'local' loader options: */
+#define OPT_APPEND		(OPT_ARCH_MAX+0)
+#define OPT_REUSE_CMDLINE	(OPT_ARCH_MAX+1)
+#define OPT_RAMDISK		(OPT_ARCH_MAX+2)
+#define OPT_BOOTINFO		(OPT_ARCH_MAX+3)
+
+/* Options relevant to the architecture (excluding loader-specific ones),
+ * in this case none:
+ */
+#define KEXEC_ARCH_OPTIONS \
+	KEXEC_OPTIONS \
+
+#define KEXEC_ARCH_OPT_STR KEXEC_OPT_STR ""
+
+/* The following two #defines list ALL of the options added by all of the
+ * architecture's loaders.
+ * o	main() uses this complete list to scan for its options, ignoring
+ *	arch-specific/loader-specific ones.
+ * o	Then, arch_process_options() uses this complete list to scan for its
+ *	options, ignoring general/loader-specific ones.
+ * o	Then, the file_type[n].load re-scans for options, using
+ *	KEXEC_ARCH_OPTIONS plus its loader-specific options subset.
+ *	Any unrecognised options cause an error here.
+ *
+ * This is done so that main()'s/arch_process_options()'s getopt_long() calls
+ * don't choose a kernel filename from random arguments to options they don't
+ * recognise -- as they now recognise (if not act upon) all possible options.
+ */
+#define KEXEC_ALL_OPTIONS					\
+	KEXEC_ARCH_OPTIONS					\
+	{ "command-line",	1, NULL, OPT_APPEND },		\
+	{ "append",		1, NULL, OPT_APPEND },		\
+	{ "reuse-cmdline",	0, NULL, OPT_REUSE_CMDLINE },	\
+	{ "ramdisk",		1, NULL, OPT_RAMDISK },		\
+	{ "initrd",		1, NULL, OPT_RAMDISK },		\
+	{ "bootinfo",		1, NULL, OPT_BOOTINFO },
+
+#define KEXEC_ALL_OPT_STR KEXEC_ARCH_OPT_STR
+
+#endif /* KEXEC_ARCH_M68K_OPTIONS_H */
diff --git a/kexec/arch/m68k/kexec-elf-m68k.c b/kexec/arch/m68k/kexec-elf-m68k.c
new file mode 100644
index 0000000..06d329b
--- /dev/null
+++ b/kexec/arch/m68k/kexec-elf-m68k.c
@@ -0,0 +1,171 @@
+/*
+ * kexec-elf-m68k.c - kexec Elf loader for m68k
+ *
+ * Copyright (C) 2013 Geert Uytterhoeven
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+*/
+
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <getopt.h>
+#include <elf.h>
+#include <boot/elf_boot.h>
+#include <ip_checksum.h>
+#include "../../kexec.h"
+#include "../../kexec-elf.h"
+#include "../../kexec-syscall.h"
+#include "kexec-m68k.h"
+#include "bootinfo.h"
+#include <arch/options.h>
+
+int elf_m68k_probe(const char *buf, off_t len)
+{
+	struct mem_ehdr ehdr;
+	int result;
+	result = build_elf_exec_info(buf, len, &ehdr, 0);
+	if (result < 0) {
+		goto out;
+	}
+
+	/* Verify the architecuture specific bits */
+	if (ehdr.e_machine != EM_68K) {
+		/* for a different architecture */
+		fprintf(stderr, "Not for this architecture.\n");
+		result = -1;
+		goto out;
+	}
+	result = 0;
+ out:
+	free_elf_info(&ehdr);
+	return result;
+}
+
+void elf_m68k_usage(void)
+{
+	printf(	"    --command-line=STRING Set the kernel command line to STRING\n"
+		"    --append=STRING       Set the kernel command line to STRING\n"
+		"    --reuse-cmdline       Use kernel command line from running system.\n"
+		"    --ramdisk=FILE        Use FILE as the kernel's initial ramdisk.\n"
+		"    --initrd=FILE         Use FILE as the kernel's initial ramdisk.\n"
+		"    --bootinfo=FILE       Use FILE as the kernel's bootinfo\n"
+		);
+}
+
+int elf_m68k_load(int argc, char **argv, const char *buf, off_t len,
+	struct kexec_info *info)
+{
+	struct mem_ehdr ehdr;
+	const char *cmdline = NULL, *ramdisk_file = NULL;
+	int opt;
+	int result;
+	unsigned long ramdisk_addr = 0;
+	off_t ramdisk_size = 0;
+	size_t i;
+
+	/* See options.h if adding any more options. */
+	static const struct option options[] = {
+		KEXEC_ARCH_OPTIONS
+		{ "command-line",	1, NULL, OPT_APPEND },
+		{ "append",		1, NULL, OPT_APPEND },
+		{ "reuse-cmdline",	0, NULL, OPT_REUSE_CMDLINE },
+		{ "ramdisk",		1, NULL, OPT_RAMDISK },
+		{ "initrd",		1, NULL, OPT_RAMDISK },
+		{ "bootinfo",		1, NULL, OPT_BOOTINFO },
+		{ 0,                    0, NULL, 0 },
+	};
+
+	static const char short_options[] = KEXEC_ARCH_OPT_STR "d";
+
+	while ((opt = getopt_long(argc, argv, short_options,
+				  options, 0)) != -1) {
+		switch (opt) {
+		default:
+			/* Ignore core options */
+			if (opt < OPT_ARCH_MAX) {
+				break;
+			}
+		case '?':
+			usage();
+			return -1;
+		case OPT_APPEND:
+			cmdline = optarg;
+			break;
+		case OPT_REUSE_CMDLINE:
+			cmdline = get_command_line();
+			break;
+		case OPT_RAMDISK:
+			ramdisk_file = optarg;
+			break;
+		case OPT_BOOTINFO:
+			break;
+		}
+	}
+
+	result = build_elf_exec_info(buf, len, &ehdr, 0);
+	if (result < 0)
+		die("ELF exec parse failed\n");
+
+	/* Read in the PT_LOAD segments and remove CKSEG0 mask from address*/
+	for (i = 0; i < ehdr.e_phnum; i++) {
+		struct mem_phdr *phdr;
+		phdr = &ehdr.e_phdr[i];
+		if (phdr->p_type == PT_LOAD)
+			phdr->p_paddr = virt_to_phys(phdr->p_paddr);
+	}
+
+	/* Load the Elf data */
+	result = elf_exec_load(&ehdr, info);
+	if (result < 0)
+		die("ELF exec load failed\n");
+
+	info->entry = (void *)virt_to_phys(ehdr.e_entry);
+
+	if (info->segment[0].mem == NULL) {
+		// FIXME Do not touch page zero
+		printf("Removing page zero\n");
+		info->segment[0].buf =
+		    (void *)((unsigned long)info->segment[0].buf + 4096);
+		info->segment[0].bufsz -= 4096;
+		info->segment[0].mem =
+		    (void *)((unsigned long)info->segment[0].mem + 4096);
+		info->segment[0].memsz -= 4096;
+	}
+
+	// FIXME check struct bootversion at start of kernel
+
+	bootinfo_set_cmdline(cmdline);
+
+	/* Load ramdisk */
+	if (ramdisk_file) {
+		void *ramdisk = slurp_decompress_file(ramdisk_file,
+						      &ramdisk_size);
+		/* Store ramdisk at top of first memory chunk */
+		/* FIXME Without the -4096, locate_hole() fails with
+		 * Could not find a free area of memory of 0x15e000 bytes...
+		 */
+		ramdisk_addr = _ALIGN_DOWN(info->memory_range[0].end -
+					   ramdisk_size + 1 - 4096 /* FIXME */,
+					   4096);
+		if (!buf)
+			die("Ramdisk load failed\n");
+		add_buffer(info, ramdisk, ramdisk_size, ramdisk_size, 4096,
+			   ramdisk_addr, info->memory_range[0].end, 1);
+	}
+	bootinfo_set_ramdisk(ramdisk_addr, ramdisk_size);
+
+	bootinfo_print();	// FIXME
+
+	/* Bootinfo must be stored right after the kernel */
+	add_bootinfo(info, 0);
+
+	return 0;
+}
diff --git a/kexec/arch/m68k/kexec-elf-rel-m68k.c b/kexec/arch/m68k/kexec-elf-rel-m68k.c
new file mode 100644
index 0000000..3bad106
--- /dev/null
+++ b/kexec/arch/m68k/kexec-elf-rel-m68k.c
@@ -0,0 +1,41 @@
+/*
+ * kexec-elf-rel-m68k.c - kexec Elf relocation routines
+ *
+ * Copyright (C) 2013 Geert Uytterhoeven
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+*/
+
+#include <stdio.h>
+#include <elf.h>
+#include "../../kexec.h"
+#include "../../kexec-elf.h"
+
+int machine_verify_elf_rel(struct mem_ehdr *ehdr)
+{
+	if (ehdr->ei_data != ELFDATA2MSB) {
+		return 0;
+	}
+	if (ehdr->ei_class != ELFCLASS32) {
+		return 0;
+	}
+	if (ehdr->e_machine != EM_68K) {
+		return 0;
+	}
+	return 1;
+}
+
+void machine_apply_elf_rel(struct mem_ehdr *UNUSED(ehdr), unsigned long r_type,
+			   void *UNUSED(location),
+			   unsigned long UNUSED(address),
+			   unsigned long UNUSED(value))
+{
+	switch(r_type) {
+
+	default:
+		die("Unknown rela relocation: %lu\n", r_type);
+		break;
+	}
+	return;
+}
diff --git a/kexec/arch/m68k/kexec-m68k.c b/kexec/arch/m68k/kexec-m68k.c
new file mode 100644
index 0000000..d53a839
--- /dev/null
+++ b/kexec/arch/m68k/kexec-m68k.c
@@ -0,0 +1,113 @@
+/*
+ * kexec-m68k.c - kexec for m68k
+ *
+ * Copyright (C) 2013 Geert Uytterhoeven
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+ */
+
+#include <stddef.h>
+#include <stdio.h>
+#include <errno.h>
+#include <stdint.h>
+#include <string.h>
+#include <getopt.h>
+#include "../../kexec.h"
+#include "../../kexec-syscall.h"
+#include "kexec-m68k.h"
+#include "bootinfo.h"
+#include <arch/options.h>
+
+
+/* Return a sorted list of memory ranges. */
+int get_memory_ranges(struct memory_range **range, int *ranges,
+		      unsigned long kexec_flags)
+{
+	bootinfo_load();
+	*ranges = bootinfo_get_memory_ranges(range);
+	return 0;
+}
+
+
+struct file_type file_type[] = {
+	{"elf-m68k", elf_m68k_probe, elf_m68k_load, elf_m68k_usage},
+};
+int file_types = sizeof(file_type) / sizeof(file_type[0]);
+
+void arch_usage(void)
+{
+}
+
+int arch_process_options(int argc, char **argv)
+{
+	static const struct option options[] = {
+		KEXEC_ALL_OPTIONS
+		{ "bootinfo",		1, NULL, OPT_BOOTINFO },
+		{ 0,			0, NULL, 0 },
+	};
+	static const char short_options[] = KEXEC_ALL_OPT_STR;
+	int opt;
+	unsigned long value;
+	char *end;
+
+	opterr = 0; /* Don't complain about unrecognized options here */
+	while((opt = getopt_long(argc, argv, short_options, options, 0)) != -1) {
+		switch(opt) {
+		default:
+			break;
+		case OPT_BOOTINFO:
+			bootinfo_file = optarg;
+			break;
+		}
+	}
+	/* Reset getopt for the next pass; called in other source modules */
+	opterr = 1;
+	optind = 1;
+	return 0;
+}
+
+const struct arch_map_entry arches[] = {
+	{ "m68k", KEXEC_ARCH_68K },
+	{ NULL, 0 },
+};
+
+int arch_compat_trampoline(struct kexec_info *UNUSED(info))
+{
+	return 0;
+}
+
+void arch_update_purgatory(struct kexec_info *UNUSED(info))
+{
+}
+
+int is_crashkernel_mem_reserved(void)
+{
+	return 0;
+}
+
+unsigned long virt_to_phys(unsigned long addr)
+{
+	return addr & 0x7fffffff;	// FIXME
+}
+
+/*
+ * add_segment() should convert base to a physical address on m68k,
+ * while the default is just to work with base as is */
+void add_segment(struct kexec_info *info, const void *buf, size_t bufsz,
+		 unsigned long base, size_t memsz)
+{
+	add_segment_phys_virt(info, buf, bufsz, virt_to_phys(base), memsz, 1);
+}
+
+/*
+ * add_buffer() should convert base to a physical address on m68k,
+ * while the default is just to work with base as is */
+unsigned long add_buffer(struct kexec_info *info, const void *buf,
+			 unsigned long bufsz, unsigned long memsz,
+			 unsigned long buf_align, unsigned long buf_min,
+			 unsigned long buf_max, int buf_end)
+{
+	return add_buffer_phys_virt(info, buf, bufsz, memsz, buf_align,
+				    buf_min, buf_max, buf_end, 1);
+}
diff --git a/kexec/arch/m68k/kexec-m68k.h b/kexec/arch/m68k/kexec-m68k.h
new file mode 100644
index 0000000..99482c4
--- /dev/null
+++ b/kexec/arch/m68k/kexec-m68k.h
@@ -0,0 +1,9 @@
+#ifndef KEXEC_M68K_H
+#define KEXEC_M68K_H
+
+int elf_m68k_probe(const char *buf, off_t len);
+int elf_m68k_load(int argc, char **argv, const char *buf, off_t len,
+		  struct kexec_info *info);
+void elf_m68k_usage(void);
+
+#endif /* KEXEC_M68K_H */
diff --git a/kexec/kexec-syscall.h b/kexec/kexec-syscall.h
index b56cb00..6238044 100644
--- a/kexec/kexec-syscall.h
+++ b/kexec/kexec-syscall.h
@@ -45,6 +45,9 @@
 #if defined(__mips__)
 #define __NR_kexec_load                4311
 #endif
+#ifdef __m68k__
+#define __NR_kexec_load                313
+#endif
 #ifndef __NR_kexec_load
 #error Unknown processor architecture.  Needs a kexec_load syscall number.
 #endif
@@ -67,6 +70,7 @@ static inline long kexec_load(void *entry, unsigned long nr_segments,
  */
 #define KEXEC_ARCH_DEFAULT ( 0 << 16)
 #define KEXEC_ARCH_386     ( 3 << 16)
+#define KEXEC_ARCH_68K     ( 4 << 16)
 #define KEXEC_ARCH_X86_64  (62 << 16)
 #define KEXEC_ARCH_PPC     (20 << 16)
 #define KEXEC_ARCH_PPC64   (21 << 16)
@@ -114,5 +118,8 @@ static inline long kexec_load(void *entry, unsigned long nr_segments,
 #if defined(__mips__)
 #define KEXEC_ARCH_NATIVE	KEXEC_ARCH_MIPS
 #endif
+#ifdef __m68k__
+#define KEXEC_ARCH_NATIVE	KEXEC_ARCH_68K
+#endif
 
 #endif /* KEXEC_SYSCALL_H */
-- 
1.7.9.5

