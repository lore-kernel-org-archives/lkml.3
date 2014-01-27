Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbaA0TB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 14:01:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093AbaA0S6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 13:58:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        jkosina@suse.cz, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 10/11] kexec: Support for loading ELF x86_64 images
Date: Mon, 27 Jan 2014 13:57:50 -0500
Message-Id: <1390849071-21989-11-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides support for kexec for loading ELF x86_64 images. I have
tested it with loading vmlinux and it worked.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/include/asm/kexec-elf.h   |  11 ++
 arch/x86/kernel/Makefile           |   1 +
 arch/x86/kernel/kexec-elf.c        | 231 +++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/machine_kexec_64.c |   2 +
 4 files changed, 245 insertions(+)
 create mode 100644 arch/x86/include/asm/kexec-elf.h
 create mode 100644 arch/x86/kernel/kexec-elf.c

diff --git a/arch/x86/include/asm/kexec-elf.h b/arch/x86/include/asm/kexec-elf.h
new file mode 100644
index 0000000..afef382
--- /dev/null
+++ b/arch/x86/include/asm/kexec-elf.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_KEXEC_ELF_H
+#define _ASM_KEXEC_ELF_H
+
+extern int elf_x86_64_probe(const char *buf, unsigned long len);
+extern void *elf_x86_64_load(struct kimage *image, char *kernel,
+		unsigned long kernel_len, char *initrd,
+		unsigned long initrd_len, char *cmdline,
+		unsigned long cmdline_len);
+extern int elf_x86_64_cleanup(struct kimage *image);
+
+#endif  /* _ASM_KEXEC_ELF_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index fa9981d..2d77de7 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -71,6 +71,7 @@ obj-$(CONFIG_KEXEC)		+= machine_kexec.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_KEXEC)		+= kexec-bzimage.o
+obj-$(CONFIG_KEXEC)		+= kexec-elf.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
 obj-y				+= kprobes/
 obj-$(CONFIG_MODULES)		+= module.o
diff --git a/arch/x86/kernel/kexec-elf.c b/arch/x86/kernel/kexec-elf.c
new file mode 100644
index 0000000..ff1017c
--- /dev/null
+++ b/arch/x86/kernel/kexec-elf.c
@@ -0,0 +1,231 @@
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
+struct elf_x86_64_data {
+	/*
+	 * Temporary buffer to hold bootparams buffer. This should be
+	 * freed once the bootparam segment has been loaded.
+	 */
+	void *bootparams_buf;
+};
+
+int elf_x86_64_probe(const char *buf, unsigned long len)
+{
+	int ret = -ENOEXEC;
+	Elf_Ehdr *ehdr;
+
+	if (len < sizeof(Elf_Ehdr)) {
+		pr_debug("File is too short to be an ELF executable.\n");
+		return ret;
+	}
+
+	ehdr = (Elf_Ehdr *)buf;
+
+	if (memcmp(ehdr->e_ident, ELFMAG, SELFMAG) != 0
+	    || ehdr->e_type != ET_EXEC || !elf_check_arch(ehdr)
+	    || ehdr->e_phentsize != sizeof(Elf_Phdr))
+		return -ENOEXEC;
+
+	if (ehdr->e_phoff >= len
+	    || (ehdr->e_phnum * sizeof(Elf_Phdr) > len - ehdr->e_phoff))
+		return -ENOEXEC;
+
+        /* I've got a bzImage */
+	pr_debug("It's an elf_x86_64 image.\n");
+	ret = 0;
+
+	return ret;
+}
+
+static int elf_exec_load(struct kimage *image, char *kernel)
+{
+	Elf_Ehdr *ehdr;
+	Elf_Phdr *phdrs;
+	int i, ret;
+	size_t filesz;
+	char *buffer;
+
+	ehdr = (Elf_Ehdr *)kernel;
+	phdrs = (void *)ehdr + ehdr->e_phoff;
+
+	for (i = 0; i < ehdr->e_phnum; i++) {
+		if (phdrs[i].p_type != PT_LOAD)
+			continue;
+		filesz = phdrs[i].p_filesz;
+		if (filesz > phdrs[i].p_memsz)
+			filesz = phdrs[i].p_memsz;
+
+		buffer = (char *)ehdr + phdrs[i].p_offset;
+		ret = kexec_add_segment(image, buffer, filesz, phdrs[i].p_memsz,
+						phdrs[i].p_paddr);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+/* Fill in fields which are usually present in bzImage */
+static int init_linux_parameters(struct boot_params *params)
+{
+	/*
+	 * FIXME: It is odd that the information which comes from kernel
+	 * has to be faked by loading kernel. I guess it is limitation of
+	 * ELF format. Right now keeping it same as kexec-tools
+	 * implementation. But this most likely needs fixing.
+	 */
+	memcpy(&params->hdr.header, "HdrS", 4);
+	params->hdr.version = 0x0206;
+	params->hdr.initrd_addr_max = 0x37FFFFFF;
+	params->hdr.cmdline_size = 2048;
+	return 0;
+}
+
+void *elf_x86_64_load(struct kimage *image, char *kernel,
+		unsigned long kernel_len,
+		char *initrd, unsigned long initrd_len,
+		char *cmdline, unsigned long cmdline_len)
+{
+
+	int ret = 0;
+	unsigned long params_cmdline_sz;
+	struct boot_params *params;
+	unsigned long bootparam_load_addr, initrd_load_addr;
+	unsigned long purgatory_load_addr;
+	struct elf_x86_64_data *ldata;
+	struct kexec_entry64_regs regs64;
+	void *stack;
+	Elf_Ehdr *ehdr;
+
+	ehdr = (Elf_Ehdr *)kernel;
+
+	/* Allocate loader specific data */
+	ldata = kzalloc(sizeof(struct elf_x86_64_data), GFP_KERNEL);
+	if (!ldata)
+		return ERR_PTR(-ENOMEM);
+
+	/* Load the ELF executable */
+	ret = elf_exec_load(image, kernel);
+	if (ret) {
+		pr_debug("Loading ELF executable failed\n");
+		goto out_free_loader_data;
+	}
+
+	/*
+	 * Load purgatory. For 64bit entry point, purgatory  code can be
+	 * anywhere.
+	 */
+	ret = kexec_load_purgatory(image, 0, ULONG_MAX, 0,
+				&purgatory_load_addr);
+	if (ret) {
+		pr_debug("Loading purgatory failed\n");
+		goto out_free_loader_data;
+	}
+
+	pr_debug("Loaded purgatory at 0x%lx\n", purgatory_load_addr);
+
+	/* Argument/parameter segment */
+	params_cmdline_sz = sizeof(struct boot_params) + cmdline_len;
+	params = kzalloc(params_cmdline_sz, GFP_KERNEL);
+	if (!params) {
+		ret = -ENOMEM;
+		goto out_free_loader_data;
+	}
+
+	init_linux_parameters(params);
+	ret = kexec_add_buffer(image, (char *)params, params_cmdline_sz,
+			params_cmdline_sz, 16, 0, -1, 0, &bootparam_load_addr);
+	if (ret)
+		goto out_free_params;
+	pr_debug("Loaded boot_param and command line at 0x%lx sz=0x%lx\n",
+			bootparam_load_addr, params_cmdline_sz);
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
+	regs64.rip = ehdr->e_entry;
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
+int elf_x86_64_cleanup(struct kimage *image)
+{
+	struct elf_x86_64_data *ldata = image->image_loader_data;
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
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 37df7d3..e35bcaf 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -22,10 +22,12 @@
 #include <asm/mmu_context.h>
 #include <asm/debugreg.h>
 #include <asm/kexec-bzimage.h>
+#include <asm/kexec-elf.h>
 
 /* arch dependent functionality related to kexec file based syscall */
 static struct kexec_file_type kexec_file_type[]={
 	{"bzImage64", bzImage64_probe, bzImage64_load, bzImage64_cleanup},
+	{"elf-x86_64", elf_x86_64_probe, elf_x86_64_load, elf_x86_64_cleanup},
 };
 
 static int nr_file_types = sizeof(kexec_file_type)/sizeof(kexec_file_type[0]);
-- 
1.8.4.2

