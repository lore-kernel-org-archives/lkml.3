Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbaA0S7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 13:59:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929AbaA0S67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 13:58:59 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        jkosina@suse.cz, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 08/11] kexec-bzImage: Support for loading bzImage using 64bit entry
Date: Mon, 27 Jan 2014 13:57:48 -0500
Message-Id: <1390849071-21989-9-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is loader specific code which can load bzImage and set it up for
64bit entry. This does not take care of 32bit entry or real mode entry
yet.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/include/asm/kexec-bzimage.h |  11 ++
 arch/x86/include/asm/kexec.h         |  30 +++++
 arch/x86/kernel/Makefile             |   2 +
 arch/x86/kernel/kexec-bzimage.c      | 234 +++++++++++++++++++++++++++++++++++
 arch/x86/kernel/machine_kexec.c      | 136 ++++++++++++++++++++
 arch/x86/kernel/machine_kexec_64.c   |   3 +-
 6 files changed, 415 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/kexec-bzimage.h
 create mode 100644 arch/x86/kernel/kexec-bzimage.c
 create mode 100644 arch/x86/kernel/machine_kexec.c

diff --git a/arch/x86/include/asm/kexec-bzimage.h b/arch/x86/include/asm/kexec-bzimage.h
new file mode 100644
index 0000000..9e83961
--- /dev/null
+++ b/arch/x86/include/asm/kexec-bzimage.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_BZIMAGE_H
+#define _ASM_BZIMAGE_H
+
+extern int bzImage64_probe(const char *buf, unsigned long len);
+extern void *bzImage64_load(struct kimage *image, char *kernel,
+		unsigned long kernel_len, char *initrd,
+		unsigned long initrd_len, char *cmdline,
+		unsigned long cmdline_len);
+extern int bzImage64_cleanup(struct kimage *image);
+
+#endif  /* _ASM_BZIMAGE_H */
diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
index 17483a4..9bd6fec 100644
--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -23,6 +23,7 @@
 
 #include <asm/page.h>
 #include <asm/ptrace.h>
+#include <asm/bootparam.h>
 
 /*
  * KEXEC_SOURCE_MEMORY_LIMIT maximum page get_free_page can return.
@@ -161,11 +162,40 @@ struct kimage_arch {
 	pmd_t *pmd;
 	pte_t *pte;
 };
+
+struct kexec_entry64_regs {
+	uint64_t rax;
+	uint64_t rbx;
+	uint64_t rcx;
+	uint64_t rdx;
+	uint64_t rsi;
+	uint64_t rdi;
+	uint64_t rsp;
+	uint64_t rbp;
+	uint64_t r8;
+	uint64_t r9;
+	uint64_t r10;
+	uint64_t r11;
+	uint64_t r12;
+	uint64_t r13;
+	uint64_t r14;
+	uint64_t r15;
+	uint64_t rip;
+};
 #endif
 
 typedef void crash_vmclear_fn(void);
 extern crash_vmclear_fn __rcu *crash_vmclear_loaded_vmcss;
 
+extern int kexec_setup_initrd(struct boot_params *boot_params,
+		unsigned long initrd_load_addr, unsigned long initrd_len);
+extern int kexec_setup_cmdline(struct boot_params *boot_params,
+		unsigned long bootparams_load_addr,
+		unsigned long cmdline_offset, char *cmdline,
+		unsigned long cmdline_len);
+extern int kexec_setup_boot_parameters(struct boot_params *params);
+
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_X86_KEXEC_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index cb648c8..fa9981d 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -67,8 +67,10 @@ obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
 obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
 obj-$(CONFIG_X86_TSC)		+= trace_clock.o
+obj-$(CONFIG_KEXEC)		+= machine_kexec.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
+obj-$(CONFIG_KEXEC)		+= kexec-bzimage.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
 obj-y				+= kprobes/
 obj-$(CONFIG_MODULES)		+= module.o
diff --git a/arch/x86/kernel/kexec-bzimage.c b/arch/x86/kernel/kexec-bzimage.c
new file mode 100644
index 0000000..cbfcd00
--- /dev/null
+++ b/arch/x86/kernel/kexec-bzimage.c
@@ -0,0 +1,234 @@
+#include <linux/string.h>
+#include <linux/printk.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/kexec.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+
+#include <asm/bootparam.h>
+#include <asm/setup.h>
+
+#ifdef CONFIG_X86_64
+
+struct bzimage64_data {
+	/*
+	 * Temporary buffer to hold bootparams buffer. This should be
+	 * freed once the bootparam segment has been loaded.
+	 */
+	void *bootparams_buf;
+};
+
+int bzImage64_probe(const char *buf, unsigned long len)
+{
+	int ret = -ENOEXEC;
+	struct setup_header *header;
+
+	if (len < 2 * 512) {
+		pr_debug("File is too short to be a bzImage\n");
+		return ret;
+	}
+
+	header = (struct setup_header *)(buf + 0x1F1);
+	if (memcmp((char *)&header->header, "HdrS", 4) != 0) {
+		pr_debug("Not a bzImage\n");
+		return ret;
+	}
+
+	if (header->boot_flag != 0xAA55) {
+                /* No x86 boot sector present */
+		pr_debug("No x86 boot sector present\n");
+		return ret;
+	}
+
+	if (header->version < 0x020C) {
+                /* Must be at least protocol version 2.12 */
+		pr_debug("Must be at least protocol version 2.12\n");
+		return ret;
+	}
+
+	if ((header->loadflags & 1) == 0) {
+		/* Not a bzImage */
+		pr_debug("zImage not a bzImage\n");
+		return ret;
+	}
+
+	if ((header->xloadflags & 3) != 3) {
+		/* XLF_KERNEL_64 and XLF_CAN_BE_LOADED_ABOVE_4G should be set */
+		pr_debug("Not a relocatable bzImage64\n");
+		return ret;
+	}
+
+        /* I've got a bzImage */
+	pr_debug("It's a relocatable bzImage64\n");
+	ret = 0;
+
+	return ret;
+}
+
+void *bzImage64_load(struct kimage *image, char *kernel,
+		unsigned long kernel_len,
+		char *initrd, unsigned long initrd_len,
+		char *cmdline, unsigned long cmdline_len)
+{
+
+	struct setup_header *header;
+	int setup_sects, kern16_size, ret = 0;
+	unsigned long setup_header_size, params_cmdline_sz;
+	struct boot_params *params;
+	unsigned long bootparam_load_addr, kernel_load_addr, initrd_load_addr;
+	unsigned long purgatory_load_addr;
+	unsigned long kernel_bufsz, kernel_memsz, kernel_align;
+	char *kernel_buf;
+	struct bzimage64_data *ldata;
+	struct kexec_entry64_regs regs64;
+	void *stack;
+
+	header = (struct setup_header *)(kernel + 0x1F1);
+	setup_sects = header->setup_sects;
+	if (setup_sects == 0)
+		setup_sects = 4;
+
+	kern16_size = (setup_sects + 1) * 512;
+	if (kernel_len < kern16_size) {
+		pr_debug("bzImage truncated\n");
+		return ERR_PTR(-ENOEXEC);
+	}
+
+	if (cmdline_len > header->cmdline_size) {
+		pr_debug("Kernel command line too long\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	/* Allocate loader specific data */
+	ldata = kzalloc(sizeof(struct bzimage64_data), GFP_KERNEL);
+	if (!ldata)
+		return ERR_PTR(-ENOMEM);
+
+	/*
+	 * Load purgatory. For 64bit entry point, purgatory  code can be
+	 * anywhere.
+	 */
+	ret = kexec_load_purgatory(image, 0x3000, -1, 1, &purgatory_load_addr);
+	if (ret) {
+		pr_debug("Loading purgatory failed\n");
+		goto out_free_loader_data;
+	}
+
+	pr_debug("Loaded purgatory at 0x%lx\n", purgatory_load_addr);
+
+	/* Load Bootparams and cmdline */
+	params_cmdline_sz = sizeof(struct boot_params) + cmdline_len;
+	params = kzalloc(params_cmdline_sz, GFP_KERNEL);
+	if (!params) {
+		ret = -ENOMEM;
+		goto out_free_loader_data;
+	}
+
+	/* Copy setup header onto bootparams. */
+	setup_header_size = 0x0202 + kernel[0x0201] - 0x1F1;
+
+	/* Is there a limit on setup header size? */
+	memcpy(&params->hdr, (kernel + 0x1F1), setup_header_size);
+	ret = kexec_add_buffer(image, (char *)params, params_cmdline_sz,
+			params_cmdline_sz, 16, 0x3000, -1, 1,
+			&bootparam_load_addr);
+	if (ret)
+		goto out_free_params;
+	pr_debug("Loaded boot_param and command line at 0x%lx sz=0x%lx\n",
+			bootparam_load_addr, params_cmdline_sz);
+
+	/* Load kernel */
+	kernel_buf = kernel + kern16_size;
+	kernel_bufsz =  kernel_len - kern16_size;
+	kernel_memsz = ALIGN(header->init_size, 4096);
+	kernel_align = header->kernel_alignment;
+
+	ret = kexec_add_buffer(image, kernel_buf,
+			kernel_bufsz, kernel_memsz, kernel_align, 0x100000,
+			-1, 1, &kernel_load_addr);
+	if (ret)
+		goto out_free_params;
+
+	pr_debug("Loaded 64bit kernel at 0x%lx sz = 0x%lx\n", kernel_load_addr,
+				kernel_memsz);
+
+	/* Load initrd high */
+	if (initrd) {
+		ret = kexec_add_buffer(image, initrd, initrd_len, initrd_len,
+			4096, 0x1000000, ULONG_MAX, 1, &initrd_load_addr);
+		if (ret)
+			goto out_free_params;
+
+		pr_debug("Loaded initrd at 0x%lx sz = 0x%lx\n",
+					initrd_load_addr, initrd_len);
+		ret = kexec_setup_initrd(params, initrd_load_addr, initrd_len);
+		if (ret)
+			goto out_free_params;
+	}
+
+	ret = kexec_setup_cmdline(params, bootparam_load_addr,
+			sizeof(struct boot_params), cmdline, cmdline_len);
+	if (ret)
+		goto out_free_params;
+
+	/* bootloader info. Do we need a separate ID for kexec kernel loader? */
+	params->hdr.type_of_loader = 0x0D << 4;
+	params->hdr.loadflags = 0;
+
+	/* Setup purgatory regs for entry */
+	ret = kexec_purgatory_get_set_symbol(image, "entry64_regs", &regs64,
+					sizeof(regs64), 1);
+	if (ret)
+		goto out_free_params;
+
+	regs64.rbx = 0; /* Bootstrap Processor */
+	regs64.rsi = bootparam_load_addr;
+	regs64.rip = kernel_load_addr + 0x200;
+	stack = kexec_purgatory_get_symbol_addr(image, "stack_end");
+	if (IS_ERR(stack)) {
+		pr_debug("Could not find address of symbol stack_end\n");
+		ret = -EINVAL;
+		goto out_free_params;
+	}
+
+	regs64.rsp = (unsigned long)stack;
+	ret = kexec_purgatory_get_set_symbol(image, "entry64_regs", &regs64,
+					sizeof(regs64), 0);
+	if (ret)
+		goto out_free_params;
+
+	ret = kexec_setup_boot_parameters(params);
+	if (ret)
+		goto out_free_params;
+
+	/*
+	 * Store pointer to params so that it could be freed after loading
+	 * params segment has been loaded and contents have been copied
+	 * somewhere else.
+	 */
+	ldata->bootparams_buf = params;
+	return ldata;
+
+out_free_params:
+	kfree(params);
+out_free_loader_data:
+	kfree(ldata);
+	return ERR_PTR(ret);
+}
+
+/* This cleanup function is called after various segments have been loaded */
+int bzImage64_cleanup(struct kimage *image)
+{
+	struct bzimage64_data *ldata = image->image_loader_data;
+
+	if (!ldata)
+		return 0;
+
+	kfree(ldata->bootparams_buf);
+	ldata->bootparams_buf = NULL;
+
+	return 0;
+}
+
+#endif /* CONFIG_X86_64 */
diff --git a/arch/x86/kernel/machine_kexec.c b/arch/x86/kernel/machine_kexec.c
new file mode 100644
index 0000000..ac55890
--- /dev/null
+++ b/arch/x86/kernel/machine_kexec.c
@@ -0,0 +1,136 @@
+/*
+ * handle transition of Linux booting another kernel
+ *
+ * Copyright (C) 2014 Red Hat Inc.
+ * Authors:
+ * 	Vivek Goyal <vgoyal@redhat.com>
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <asm/bootparam.h>
+#include <asm/setup.h>
+
+/*
+ * Common code for x86 and x86_64 used for kexec.
+ *
+ * For the time being it compiles only for x86_64 as there are no image
+ * loaders implemented * for x86. This #ifdef can be removed once somebody
+ * decides to write an image loader on CONFIG_X86_32.
+ */
+
+#ifdef CONFIG_X86_64
+
+int kexec_setup_initrd(struct boot_params *boot_params,
+		unsigned long initrd_load_addr, unsigned long initrd_len)
+{
+	boot_params->hdr.ramdisk_image = initrd_load_addr & 0xffffffffUL;
+	boot_params->hdr.ramdisk_size = initrd_len & 0xffffffffUL;
+
+	boot_params->ext_ramdisk_image = initrd_load_addr >> 32;
+	boot_params->ext_ramdisk_size = initrd_len >> 32;
+
+	return 0;
+}
+
+int kexec_setup_cmdline(struct boot_params *boot_params,
+		unsigned long bootparams_load_addr,
+		unsigned long cmdline_offset, char *cmdline,
+		unsigned long cmdline_len)
+{
+	char *cmdline_ptr = ((char *)boot_params) + cmdline_offset;
+	unsigned long cmdline_ptr_phys;
+	uint32_t cmdline_low_32, cmdline_ext_32;
+
+	memcpy(cmdline_ptr, cmdline, cmdline_len);
+	cmdline_ptr[cmdline_len - 1] = '\0';
+
+	cmdline_ptr_phys = bootparams_load_addr + cmdline_offset;
+	cmdline_low_32 = cmdline_ptr_phys & 0xffffffffUL;
+	cmdline_ext_32 = cmdline_ptr_phys >> 32;
+
+	boot_params->hdr.cmd_line_ptr = cmdline_low_32;
+	if (cmdline_ext_32)
+		boot_params->ext_cmd_line_ptr = cmdline_ext_32;
+
+	return 0;
+}
+
+static int setup_memory_map_entries(struct boot_params *params)
+{
+	unsigned int nr_e820_entries;
+
+	/* TODO: What about EFI */
+	nr_e820_entries = e820_saved.nr_map;
+	if (nr_e820_entries > E820MAX)
+		nr_e820_entries = E820MAX;
+
+	params->e820_entries = nr_e820_entries;
+	memcpy(&params->e820_map, &e820_saved.map,
+			nr_e820_entries * sizeof(struct e820entry));
+
+	return 0;
+}
+
+int kexec_setup_boot_parameters(struct boot_params *params)
+{
+	unsigned int nr_e820_entries;
+	unsigned long long mem_k, start, end;
+	int i;
+
+	/* Get subarch from existing bootparams */
+	params->hdr.hardware_subarch = boot_params.hdr.hardware_subarch;
+
+	/* Copying screen_info will do? */
+	memcpy(&params->screen_info, &boot_params.screen_info,
+				sizeof(struct screen_info));
+
+	/* Fill in memsize later */
+	params->screen_info.ext_mem_k = 0;
+	params->alt_mem_k = 0;
+
+	/* Default APM info */
+	memset(&params->apm_bios_info, 0, sizeof(params->apm_bios_info));
+
+	/* Default drive info */
+	memset(&params->hd0_info, 0, sizeof(params->hd0_info));
+	memset(&params->hd1_info, 0, sizeof(params->hd1_info));
+
+	/* Default sysdesc table */
+	params->sys_desc_table.length = 0;
+
+	setup_memory_map_entries(params);
+	nr_e820_entries = params->e820_entries;
+
+	for(i = 0; i < nr_e820_entries; i++) {
+		if (params->e820_map[i].type != E820_RAM)
+			continue;
+		start = params->e820_map[i].addr;
+		end = params->e820_map[i].addr + params->e820_map[i].size - 1;
+
+		if ((start <= 0x100000) && end > 0x100000) {
+			mem_k = (end >> 10) - (0x100000 >> 10);
+			params->screen_info.ext_mem_k = mem_k;
+			params->alt_mem_k = mem_k;
+			if (mem_k > 0xfc00)
+				params->screen_info.ext_mem_k = 0xfc00; /* 64M*/
+			if (mem_k > 0xffffffff)
+				params->alt_mem_k = 0xffffffff;
+		}
+	}
+
+	/* Setup EDD info */
+	memcpy(params->eddbuf, boot_params.eddbuf,
+				EDDMAXNR * sizeof(struct edd_info));
+	params->eddbuf_entries = boot_params.eddbuf_entries;
+
+	memcpy(params->edd_mbr_sig_buffer, boot_params.edd_mbr_sig_buffer,
+			EDD_MBR_SIG_MAX * sizeof(unsigned int));
+
+	return 0;
+}
+
+#endif /* CONFIG_X86_64 */
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 8866c5e..37df7d3 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -21,10 +21,11 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/debugreg.h>
+#include <asm/kexec-bzimage.h>
 
 /* arch dependent functionality related to kexec file based syscall */
 static struct kexec_file_type kexec_file_type[]={
-	{"", NULL, NULL, NULL},
+	{"bzImage64", bzImage64_probe, bzImage64_load, bzImage64_cleanup},
 };
 
 static int nr_file_types = sizeof(kexec_file_type)/sizeof(kexec_file_type[0]);
-- 
1.8.4.2

