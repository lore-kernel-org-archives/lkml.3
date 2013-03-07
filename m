Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112Ab3CGO6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:58:40 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:17913 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269Ab3CGO6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:58:38 -0500
Subject: [RFC PATCH 1/5] crash dump bitmap: add a kernel config and help
 document
To: mingo@redhat.com, kumagai-atsushi@mxc.nes.nec.co.jp, ebiederm@xmission.com,
        hpa@zytor.com, yinghai@kernel.org, vgoyal@redhat.com
From: Jingbai Ma <jingbai.ma@hp.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 07 Mar 2013 22:58:30 +0800
Message-ID: <20130307145829.29098.76897.stgit@k.asiapacific.hpqcorp.net>
In-Reply-To: <20130307145808.29098.41592.stgit@k.asiapacific.hpqcorp.net>
References: <20130307145808.29098.41592.stgit@k.asiapacific.hpqcorp.net>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a kernel config and help document for CRASH_DUMP_BITMAP.

Signed-off-by: Jingbai Ma <jingbai.ma@hp.com>
---
 Documentation/kdump/crash_dump_bitmap.txt |  378 +++++++++++++++++++++++++++++
 arch/x86/Kconfig                          |   16 +
 2 files changed, 394 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/kdump/crash_dump_bitmap.txt

diff --git a/Documentation/kdump/crash_dump_bitmap.txt b/Documentation/kdump/crash_dump_bitmap.txt
new file mode 100644
index 0000000..468cdf2
--- /dev/null
+++ b/Documentation/kdump/crash_dump_bitmap.txt
@@ -0,0 +1,378 @@
+================================================================
+Documentation for Crash Dump Bitmap
+================================================================
+
+This document includes overview, setup and installation, and analysis
+information.
+
+Overview
+========
+
+Traditionally, to reduce the size of dump file, dumper scans all memory
+pages to exclude the unnecessary memory pages after capture kernel
+booted, and scan it in userspace code (makedumpfile).
+
+It introduces several problems:
+
+1. Requires more memory to store memory bitmap on systems with large
+amount of memory installed. And in capture kernel there is only a few
+free memory available, it will cause an out of memory error and fail.
+(Non-cyclic mode)
+
+2. Scans all memory pages in makedumpfile is a very slow process. On
+system with 1TB or more memory installed, the scanning process is very
+long. Typically on 1TB idle system, it takes about 19 minutes. On system
+with 4TB or more memory installed, it even doesn't work. To address the
+out of memory issue on system with big memory (4TB or more memory
+installed),  makedumpfile v1.5.1 introduces a new cyclic mode. It only
+scans a piece of memory pages each time, and do it cyclically to scan
+all memory pages. But it runs more slowly, on 1TB system, takes about 33
+minutes.
+
+3. Scans memory pages code in makedumpfile is very complicated, without
+kernel memory management related data structure, makedumpfile has to
+build up its on data structure, and will not able to use some macros
+that only be available in kernel (e.g. page_to_pfn), and has to use some
+slow lookup algorithm instead.
+
+This patch introduces a new way to scan memory pages. It reserves a piece of
+memory (1 bit for each page, 32MB per TB memory on x86 systems) in the first
+kernel. During the kernel panic process, it scans all memory pages, clear the
+bit for all excluded memory pages in the reserved memory.
+
+We have several benefits by this new approach:
+
+1. It's extremely fast, on 1TB system only takes about 17.5 seconds to
+scan all memory pages!
+
+2. Reduces the memory requirement of makedumpfile by putting the
+reserved memory in the first kernel memory space.
+
+3. Simplifies the complexity of existing memory pages scanning code in
+userspace.
+
+
+Usage
+=====
+
+1) Enable "kernel crash dump bitmap" in "Processor type and features", under
+"kernel crash dumps".
+
+CONFIG_CRASH_DUMP_BITMAP=y
+
+it depends on "kexec system call" and "kernel crash dumps", so there features
+must be enabled also.
+
+CONFIG_KEXEC=y
+CONFIG_CRASH_DUMP=y
+
+2) Enable "sysfs file system support" in "Filesystem" -> "Pseudo filesystems.".
+
+   CONFIG_SYSFS=y
+
+3) Compile and install the new kernel.
+
+4) Check the new kernel.
+Once new kernel has booted, there will be a new foler
+/proc/crash_dump_bitmap.
+Check current dump level:
+cat /proc/crash_dump_bitmap/dump_level
+
+Set dump level:
+echo "dump level" > /proc/crash_dump_bitmap/dump_level
+
+The dump level is as same as the parameter of makedumpfile -d dump_level.
+
+Run page scan and check page status:
+cat /proc/crash_dump_bitmap/page_status
+
+5) Download makedumpfile v1.5.3 or later from sourceforge:
+http://sourceforge.net/projects/makedumpfile/
+
+6) Patch it with the patch at the end of this file.
+
+7) Compile it and copy the patched makedumpfile into the right folder
+(/sbin or /usr/sbin)
+
+8) Change the /etc/kdump.conf, and a "-q" in the makedumpfile parameter
+line. It will tell makedumpfile to use the crash dump bitmap in kernel.
+core_collector makedumpfile --non-cyclic -q -c -d 31 --message-level 23
+
+9) Regenerate initramfs to make sure the patched makedumpfile and config
+has been included in it.
+
+
+To Do
+=====
+
+It only supports x86-64 architecture currently, need to add supports for
+other architectures.
+
+
+Contact
+=======
+
+Jingbai Ma (jingbai.ma@hp.com)
+
+
+Patch (for makedumpfile v1.5.3)
+
+Please forgive me, for some format issues of makedumpfile source, I have
+to wrap this patch with '#'.  Please use this sed command to get the
+patch for makedumpfile:
+
+sed -n -e "s/^#\(.*\)#$/\1/p" crash_dump_bitmap.txt > makedumpfile.patch
+
+=====
+#diff --git a/makedumpfile.c b/makedumpfile.c#
+#index acb1b21..f29b6a5 100644#
+#--- a/makedumpfile.c#
+#+++ b/makedumpfile.c#
+#@@ -34,6 +34,10 @@ struct srcfile_table	srcfile_table;#
+# struct vm_table		vt = { 0 };#
+# struct DumpInfo		*info = NULL;#
+# #
+#+struct crash_dump_bitmap_info	crash_dump_bitmap_info;#
+#+#
+#+const unsigned int CURRENT_BITMAP_INFO_VERSION = 1;#
+#+#
+# char filename_stdout[] = FILENAME_STDOUT;#
+# #
+# /*#
+#@@ -892,6 +896,7 @@ get_symbol_info(void)#
+# 	SYMBOL_INIT(node_remap_start_vaddr, "node_remap_start_vaddr");#
+# 	SYMBOL_INIT(node_remap_end_vaddr, "node_remap_end_vaddr");#
+# 	SYMBOL_INIT(node_remap_start_pfn, "node_remap_start_pfn");#
+#+	SYMBOL_INIT(crash_dump_bitmap_info, "crash_dump_bitmap_info");#
+# #
+# 	if (SYMBOL(node_data) != NOT_FOUND_SYMBOL)#
+# 		SYMBOL_ARRAY_TYPE_INIT(node_data, "node_data");#
+#@@ -1704,6 +1709,8 @@ read_vmcoreinfo(void)#
+# 	READ_SYMBOL("node_remap_end_vaddr", node_remap_end_vaddr);#
+# 	READ_SYMBOL("node_remap_start_pfn", node_remap_start_pfn);#
+# #
+#+	READ_SYMBOL("crash_dump_bitmap_info", crash_dump_bitmap_info);#
+#+#
+# 	READ_STRUCTURE_SIZE("page", page);#
+# 	READ_STRUCTURE_SIZE("mem_section", mem_section);#
+# 	READ_STRUCTURE_SIZE("pglist_data", pglist_data);#
+#@@ -4423,6 +4430,74 @@ copy_bitmap(void)#
+# int#
+# create_2nd_bitmap(void)#
+# {#
+#+	off_t offset_page;#
+#+	char buf1[info->page_size], buf2[info->page_size];#
+#+	int i;#
+#+#
+#+	if (info->flag_crash_dump_bitmap) {#
+#+		offset_page = 0;#
+#+		while (offset_page < (info->len_bitmap / 2)) {#
+#+			if (lseek(info->bitmap1->fd, info->bitmap1->offset#
+#+				+ offset_page, SEEK_SET) < 0) {#
+#+				ERRMSG("Can't seek the bitmap(%s). %s\n",#
+#+				    info->bitmap1->file_name, strerror(errno));#
+#+				return FALSE;#
+#+			}#
+#+#
+#+			if (read(info->bitmap1->fd, buf1, info->page_size)#
+#+				!= info->page_size) {#
+#+					ERRMSG("Can't read bitmap(%s). %s\n",#
+#+					info->bitmap1->file_name,#
+#+					strerror(errno));#
+#+				return FALSE;#
+#+			}#
+#+#
+#+			if (readmem(PADDR, crash_dump_bitmap_info.bitmap#
+#+				+ offset_page, buf2, info->page_size)#
+#+				!= info->page_size) {#
+#+				ERRMSG("Can't read bitmap1! addr=%llx\n",#
+#+					crash_dump_bitmap_info.bitmap#
+#+					+ offset_page);#
+#+				return FALSE;#
+#+			}#
+#+#
+#+			if (crash_dump_bitmap_info.version#
+#+				!= CURRENT_BITMAP_INFO_VERSION) {#
+#+				ERRMSG("bitmap version! expected=%d, got=%d\n",#
+#+					CURRENT_BITMAP_INFO_VERSION,#
+#+					crash_dump_bitmap_info.version);#
+#+				return FALSE;#
+#+			}#
+#+#
+#+			for (i = 0; i < info->page_size; i++)#
+#+				buf2[i] = buf1[i] & buf2[i];#
+#+#
+#+			if (lseek(info->bitmap2->fd, info->bitmap2->offset#
+#+				+ offset_page, SEEK_SET) < 0) {#
+#+				ERRMSG("Can't seek the bitmap(%s). %s\n",#
+#+				    info->bitmap2->file_name, strerror(errno));#
+#+				return FALSE;#
+#+			}#
+#+#
+#+			if (write(info->bitmap2->fd, buf2, info->page_size)#
+#+				!= info->page_size) {#
+#+				ERRMSG("Can't write the bitmap(%s). %s\n",#
+#+				    info->bitmap2->file_name, strerror(errno));#
+#+				return FALSE;#
+#+			}#
+#+#
+#+			offset_page += info->page_size;#
+#+		}#
+#+#
+#+		pfn_cache = crash_dump_bitmap_info.cache_pages;#
+#+		pfn_cache_private = crash_dump_bitmap_info.cache_private_pages;#
+#+		pfn_user = crash_dump_bitmap_info.user_pages;#
+#+		pfn_free = crash_dump_bitmap_info.free_pages;#
+#+		pfn_hwpoison = crash_dump_bitmap_info.hwpoison_pages;#
+#+#
+#+		return TRUE;#
+#+	}#
+#+#
+# 	/*#
+# 	 * Copy 1st-bitmap to 2nd-bitmap.#
+# 	 */#
+#@@ -4587,6 +4662,46 @@ create_dump_bitmap(void)#
+# 		if (!prepare_bitmap_buffer())#
+# 			goto out;#
+# #
+#+		if (info->flag_crash_dump_bitmap#
+#+			&& (SYMBOL(crash_dump_bitmap_info)#
+#+			!= NOT_FOUND_SYMBOL)) {#
+#+			/* Read crash_dump_bitmap_info from old kernel */#
+#+			readmem(VADDR, SYMBOL(crash_dump_bitmap_info),#
+#+				&crash_dump_bitmap_info,#
+#+				sizeof(struct crash_dump_bitmap_info));#
+#+#
+#+			if (!crash_dump_bitmap_info.bitmap_size#
+#+				|| !crash_dump_bitmap_info.bitmap) {#
+#+				ERRMSG("Can't get crash_dump bitmap info! ");#
+#+				ERRMSG("Failback to legacy mode.\n");#
+#+				ERRMSG("crash_dump_bitmap_info=0x%llx, ",#
+#+					SYMBOL(crash_dump_bitmap_info));#
+#+				ERRMSG("bitmap=0x%llx, ",#
+#+					crash_dump_bitmap_info.bitmap);#
+#+				ERRMSG("bitmap_size=%lld\n",#
+#+					crash_dump_bitmap_info.bitmap_size);#
+#+#
+#+				info->flag_crash_dump_bitmap = FALSE;#
+#+			} else {#
+#+				MSG("crash_dump_bitmap: ");#
+#+				MSG("crash_dump_bitmap_info=0x%llx, ",#
+#+					SYMBOL(crash_dump_bitmap_info));#
+#+				MSG("bitmap=0x%llx, ",#
+#+					crash_dump_bitmap_info.bitmap);#
+#+				MSG("bitmap_size=%lld, ",#
+#+					crash_dump_bitmap_info.bitmap_size);#
+#+				MSG("cache_pages=0x%lx, ",#
+#+					crash_dump_bitmap_info.cache_pages);#
+#+				MSG("cache_private_pages=0x%lx, ",#
+#+					crash_dump_bitmap_info#
+#+					.cache_private_pages);#
+#+				MSG("user_pages=0x%lx, ",#
+#+					crash_dump_bitmap_info.user_pages);#
+#+				MSG("free_pages=0x%lx\n",#
+#+					crash_dump_bitmap_info.free_pages);#
+#+			}#
+#+		}#
+#+#
+# 		if (!create_1st_bitmap())#
+# 			goto out;#
+# #
+#@@ -8454,7 +8569,8 @@ main(int argc, char *argv[])#
+# 	#
+# 	info->block_order = DEFAULT_ORDER;#
+# 	message_level = DEFAULT_MSG_LEVEL;#
+#-	while ((opt = getopt_long(argc, argv, "b:cDd:EFfg:hi:lMpRrsvXx:", longopts,#
+#+	while ((opt = getopt_long(argc, argv, "b:cDd:EFfg:hi:lMpqRrsvXx:",#
+#+		longopts,#
+# 	    NULL)) != -1) {#
+# 		switch (opt) {#
+# 		case 'b':#
+#@@ -8518,6 +8634,10 @@ main(int argc, char *argv[])#
+# 		case 'P':#
+# 			info->xen_phys_start = strtoul(optarg, NULL, 0);#
+# 			break;#
+#+		case 'q':#
+#+			info->flag_crash_dump_bitmap = TRUE;#
+#+			info->flag_cyclic = FALSE;#
+#+			break;#
+# 		case 'R':#
+# 			info->flag_rearrange = 1;#
+# 			break;#
+#diff --git a/makedumpfile.h b/makedumpfile.h#
+#index 272273e..6404b16 100644#
+#--- a/makedumpfile.h#
+#+++ b/makedumpfile.h#
+#@@ -41,6 +41,8 @@#
+# #include "dwarf_info.h"#
+# #include "diskdump_mod.h"#
+# #include "sadump_mod.h"#
+#+#include "print_info.h"#
+#+#
+# #
+# /*#
+#  * Result of command#
+#@@ -889,6 +891,7 @@ struct DumpInfo {#
+# 	int		flag_refiltering;    /* refilter from kdump-compressed file */#
+# 	int		flag_force;	     /* overwrite existing stuff */#
+# 	int		flag_exclude_xen_dom;/* exclude Domain-U from xen-kdump */#
+#+	int		flag_crash_dump_bitmap;/* crash dump bitmap */#
+# 	int             flag_dmesg;          /* dump the dmesg log out of the vmcore file */#
+# 	int		flag_nospace;	     /* the flag of "No space on device" error */#
+# 	unsigned long	vaddr_for_vtop;      /* virtual address for debugging */#
+#@@ -1153,6 +1156,11 @@ struct symbol_table {#
+# 	unsigned long long	__per_cpu_load;#
+# 	unsigned long long	cpu_online_mask;#
+# 	unsigned long long	kexec_crash_image;#
+#+#
+#+	/*#
+#+	 * for crash_dump_bitmap#
+#+ 	 */#
+#+	unsigned long long	crash_dump_bitmap_info;#
+# };#
+# #
+# struct size_table {#
+#@@ -1381,6 +1389,20 @@ struct srcfile_table {#
+# 	char	pud_t[LEN_SRCFILE];#
+# };#
+# #
+#+/*#
+#+ * for crash_dump_bitmap#
+#+ */#
+#+struct crash_dump_bitmap_info {#
+#+	unsigned int version;#
+#+	unsigned long long bitmap;#
+#+	unsigned long long bitmap_size;#
+#+	unsigned long cache_pages;#
+#+	unsigned long cache_private_pages;#
+#+	unsigned long user_pages;#
+#+	unsigned long free_pages;#
+#+	unsigned long hwpoison_pages;#
+#+};#
+#+#
+# extern struct symbol_table	symbol_table;#
+# extern struct size_table	size_table;#
+# extern struct offset_table	offset_table;#
+#@@ -1541,8 +1563,20 @@ is_dumpable(struct dump_bitmap *bitmap, unsigned long long pfn)#
+# 	off_t offset;#
+# 	if (pfn == 0 || bitmap->no_block != pfn/PFN_BUFBITMAP) {#
+# 		offset = bitmap->offset + BUFSIZE_BITMAP*(pfn/PFN_BUFBITMAP);#
+#-		lseek(bitmap->fd, offset, SEEK_SET);#
+#-		read(bitmap->fd, bitmap->buf, BUFSIZE_BITMAP);#
+#+		if (lseek(bitmap->fd, offset, SEEK_SET) < 0) {#
+#+			ERRMSG("Can't seek bitmap file %s:(%d), ",#
+#+				bitmap->file_name, bitmap->fd);#
+#+			ERRMSG("offset=%ld, error: %s\n",#
+#+				offset, strerror(errno));#
+#+		}#
+#+#
+#+		if (read(bitmap->fd, bitmap->buf, BUFSIZE_BITMAP) < 0) {#
+#+			ERRMSG("Can't read bitmap file %s:(%d), ",#
+#+				bitmap->file_name, bitmap->fd);#
+#+			ERRMSG("offset=%ld, error: %s\n",#
+#+				offset, strerror(errno));#
+#+		}#
+#+#
+# 		if (pfn == 0)#
+# 			bitmap->no_block = 0;#
+# 		else#
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a4f24f5..7b6232e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1633,6 +1633,22 @@ config CRASH_DUMP
 	  (CONFIG_RELOCATABLE=y).
 	  For more details see Documentation/kdump/kdump.txt
 
+config CRASH_DUMP_BITMAP
+	bool "kernel crash dump bitmap"
+	def_bool y
+	depends on CRASH_DUMP && X86_64
+	---help---
+	  This option will enable the kernel crash dump bitmap support.
+	  It will reserve a block of memory to store crash dump bitmap.
+	  (1 bit for each page, 32MB per TB memory on x86 systems)
+	  It will scan all memory pages during crash processing and mark the
+	  excluded memory page bit in the reserved memory. It will be very
+	  fast compare to scan it later in the capture kernel.
+	  User can control which type of page to be excluded through procfs:
+	  /proc/crash_dump_bitmap/dump_level
+	  The default dump level is 31 (exclude all unnecessary pages).
+	  For more details see Documentation/kdump/crash_dump_bitmap.txt
+
 config KEXEC_JUMP
 	bool "kexec jump"
 	depends on KEXEC && HIBERNATION

