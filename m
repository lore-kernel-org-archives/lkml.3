Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbaFCNI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:08:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932434AbaFCNIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:08:54 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        bp@alien8.de, jkosina@suse.cz, dyoung@redhat.com, chaowang@redhat.com,
        bhe@redhat.com, akpm@linux-foundation.org,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 10/13] kexec: Load and Relocate purgatory at kernel load time
Date: Tue,  3 Jun 2014 09:06:59 -0400
Message-Id: <1401800822-27425-11-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Load purgatory code in RAM and relocate it based on the location. Relocation
code has been inspired by module relocation code and purgatory relocation
code in kexec-tools.

Also compute the checksums of loaded kexec segments and store them in
purgatory.

Arch independent code provides this functionality so that arch dependent
bootloaders can make use of it.

Helper functions are provided to get/set symbol values in purgatory which
are used by bootloaders later to set things like stack and entry point
of second kernel etc.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/Kconfig                   |   2 +
 arch/x86/kernel/machine_kexec_64.c |  82 +++++++
 include/linux/kexec.h              |  31 +++
 kernel/kexec.c                     | 484 +++++++++++++++++++++++++++++++++++++
 4 files changed, 599 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 213308a..0f24b61 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1556,6 +1556,8 @@ source kernel/Kconfig.hz
 config KEXEC
 	bool "kexec system call"
 	select BUILD_BIN2C
+	select CRYPTO
+	select CRYPTO_SHA256
 	---help---
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index d9c5cf0..711c1fb 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -337,3 +337,85 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image)
 		return kexec_file_type[idx].cleanup(image);
 	return 0;
 }
+
+/* Apply purgatory relocations */
+int arch_kexec_apply_relocations_add(Elf64_Shdr *sechdrs,
+				unsigned int nr_sections, unsigned int relsec)
+{
+	unsigned int i;
+	Elf64_Rela *rel = (void *)sechdrs[relsec].sh_offset;
+	Elf64_Sym *sym;
+	void *location;
+	Elf64_Shdr *section, *symtab;
+	unsigned long address, sec_base, value;
+
+	/* Section to which relocations apply */
+	section = &sechdrs[sechdrs[relsec].sh_info];
+
+	/* Associated symbol table */
+	symtab = &sechdrs[sechdrs[relsec].sh_link];
+
+	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
+
+		/*
+		 * This is location (->sh_offset) to update. This is temporary
+		 * buffer where section is currently loaded. This will finally
+		 * be loaded to a different address later (pointed to
+		 * by ->sh_addr. kexec takes care of moving it
+		 * (kexec_load_segment()).
+		 */
+		location = (void *)(section->sh_offset + rel[i].r_offset);
+
+		/* Final address of the location */
+		address = section->sh_addr + rel[i].r_offset;
+
+		sym = (Elf64_Sym *)symtab->sh_offset +
+				ELF64_R_SYM(rel[i].r_info);
+
+		if (sym->st_shndx == SHN_UNDEF || sym->st_shndx == SHN_COMMON)
+			return -ENOEXEC;
+
+		if (sym->st_shndx == SHN_ABS)
+			sec_base = 0;
+		else if (sym->st_shndx >= nr_sections)
+			return -ENOEXEC;
+		else
+			sec_base = sechdrs[sym->st_shndx].sh_addr;
+
+		value = sym->st_value;
+		value += sec_base;
+		value += rel[i].r_addend;
+
+		switch (ELF64_R_TYPE(rel[i].r_info)) {
+		case R_X86_64_NONE:
+			break;
+		case R_X86_64_64:
+			*(u64 *)location = value;
+			break;
+		case R_X86_64_32:
+			*(u32 *)location = value;
+			if (value != *(u32 *)location)
+				goto overflow;
+			break;
+		case R_X86_64_32S:
+			*(s32 *)location = value;
+			if ((s64)value != *(s32 *)location)
+				goto overflow;
+			break;
+		case R_X86_64_PC32:
+			value -= (u64)address;
+			*(u32 *)location = value;
+			break;
+		default:
+			pr_err("kexec: Unknown rela relocation: %llu\n",
+					ELF64_R_TYPE(rel[i].r_info));
+			return -ENOEXEC;
+		}
+	}
+	return 0;
+
+overflow:
+	pr_err("kexec: overflow in relocation type %d value 0x%lx\n",
+		(int)ELF64_R_TYPE(rel[i].r_info), value);
+	return -ENOEXEC;
+}
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 3790519..7228873 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -10,6 +10,7 @@
 #include <linux/ioport.h>
 #include <linux/elfcore.h>
 #include <linux/elf.h>
+#include <linux/module.h>
 #include <asm/kexec.h>
 
 /* Verify architecture specific macros are defined */
@@ -95,6 +96,27 @@ struct compat_kexec_segment {
 };
 #endif
 
+struct kexec_sha_region {
+	unsigned long start;
+	unsigned long len;
+};
+
+struct purgatory_info {
+	/* Pointer to elf header of read only purgatory */
+	Elf_Ehdr *ehdr;
+
+	/* Pointer to purgatory sechdrs which are modifiable */
+	Elf_Shdr *sechdrs;
+	/*
+	 * Temporary buffer location where purgatory is loaded and relocated
+	 * This memory can be freed post image load
+	 */
+	void *purgatory_buf;
+
+	/* Address where purgatory is finally loaded and is executed from */
+	unsigned long purgatory_load_addr;
+};
+
 struct kimage {
 	kimage_entry_t head;
 	kimage_entry_t *entry;
@@ -143,6 +165,9 @@ struct kimage {
 
 	/* Image loader handling the kernel can store a pointer here */
 	void *image_loader_data;
+
+	/* Information for loading purgatory */
+	struct purgatory_info purgatory_info;
 };
 
 /*
@@ -190,6 +215,12 @@ extern int kexec_add_buffer(struct kimage *image, char *buffer,
 			unsigned long *load_addr);
 extern struct page *kimage_alloc_control_pages(struct kimage *image,
 						unsigned int order);
+extern int kexec_load_purgatory(struct kimage *image, unsigned long min,
+		unsigned long max, int top_down, unsigned long *load_addr);
+extern int kexec_purgatory_get_set_symbol(struct kimage *image,
+		const char *name, void *buf, unsigned int size, bool get_value);
+extern void *kexec_purgatory_get_symbol_addr(struct kimage *image,
+					const char *name);
 extern void crash_kexec(struct pt_regs *);
 int kexec_should_crash(struct task_struct *);
 void crash_save_cpu(struct pt_regs *regs, int cpu);
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 1ad4d60..7f2e393 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -39,6 +39,9 @@
 #include <asm/io.h>
 #include <asm/sections.h>
 
+#include <crypto/hash.h>
+#include <crypto/sha.h>
+
 /* Per cpu memory for storing cpu states in case of system crash. */
 note_buf_t __percpu *crash_notes;
 
@@ -51,6 +54,15 @@ size_t vmcoreinfo_max_size = sizeof(vmcoreinfo_data);
 /* Flag to indicate we are going to kexec a new kernel */
 bool kexec_in_progress = false;
 
+/*
+ * Declare these symbols weak so that if architecture provides a purgatory,
+ * these will be overridden.
+ */
+char __weak kexec_purgatory[0];
+size_t __weak kexec_purgatory_size = 0;
+
+static int kexec_calculate_store_digests(struct kimage *image);
+
 /* Location of the reserved area for the crash kernel */
 struct resource crashk_res = {
 	.name  = "Crash kernel",
@@ -336,6 +348,15 @@ arch_kimage_file_post_load_cleanup(struct kimage *image)
 	return;
 }
 
+/* Apply relocations for rela section */
+int __attribute__ ((weak))
+arch_kexec_apply_relocations_add(Elf_Shdr *sechdrs, unsigned int nr_sections,
+					unsigned int relsec)
+{
+	pr_err(KERN_ERR "kexec: REL relocation unsupported\n");
+	return -ENOEXEC;
+}
+
 /*
  * Free up tempory buffers allocated which are not needed after image has
  * been loaded.
@@ -355,6 +376,12 @@ static void kimage_file_post_load_cleanup(struct kimage *image)
 	vfree(image->cmdline_buf);
 	image->cmdline_buf = NULL;
 
+	vfree(image->purgatory_info.purgatory_buf);
+	image->purgatory_info.purgatory_buf = NULL;
+
+	vfree(image->purgatory_info.sechdrs);
+	image->purgatory_info.sechdrs = NULL;
+
 	/* See if architcture has anything to cleanup post load */
 	arch_kimage_file_post_load_cleanup(image);
 }
@@ -1370,6 +1397,10 @@ SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
 	if (ret)
 		goto out;
 
+	ret = kexec_calculate_store_digests(image);
+	if (ret)
+		goto out;
+
 	for (i = 0; i < image->nr_segments; i++) {
 		struct kexec_segment *ksegment;
 
@@ -2131,6 +2162,459 @@ int kexec_add_buffer(struct kimage *image, char *buffer,
 	return 0;
 }
 
+/* Calculate and store the digest of segments */
+static int kexec_calculate_store_digests(struct kimage *image)
+{
+	struct crypto_shash *tfm;
+	struct shash_desc *desc;
+	int ret = 0, i, j, zero_buf_sz = 256, sha_region_sz;
+	size_t desc_size, nullsz;
+	char *digest = NULL;
+	void *zero_buf;
+	struct kexec_sha_region *sha_regions;
+
+	tfm = crypto_alloc_shash("sha256", 0, 0);
+	if (IS_ERR(tfm)) {
+		ret = PTR_ERR(tfm);
+		goto out;
+	}
+
+	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
+	desc = kzalloc(desc_size, GFP_KERNEL);
+	if (!desc) {
+		ret = -ENOMEM;
+		goto out_free_tfm;
+	}
+
+	zero_buf = kzalloc(zero_buf_sz, GFP_KERNEL);
+	if (!zero_buf) {
+		ret = -ENOMEM;
+		goto out_free_desc;
+	}
+
+	sha_region_sz = KEXEC_SEGMENT_MAX * sizeof(struct kexec_sha_region);
+	sha_regions = vzalloc(sha_region_sz);
+	if (!sha_regions)
+		goto out_free_zero_buf;
+
+	desc->tfm   = tfm;
+	desc->flags = 0;
+
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto out_free_sha_regions;
+
+	digest = kzalloc(SHA256_DIGEST_SIZE, GFP_KERNEL);
+	if (!digest) {
+		ret = -ENOMEM;
+		goto out_free_sha_regions;
+	}
+
+	/* Traverse through all segments */
+	for (j = i = 0; i < image->nr_segments; i++) {
+		struct kexec_segment *ksegment;
+		ksegment = &image->segment[i];
+
+		/*
+		 * Skip purgatory as it will be modified once we put digest
+		 * info in purgatory
+		 */
+		if (ksegment->kbuf == image->purgatory_info.purgatory_buf)
+			continue;
+
+		ret = crypto_shash_update(desc, ksegment->kbuf,
+						ksegment->bufsz);
+		if (ret)
+			break;
+
+		nullsz = ksegment->memsz - ksegment->bufsz;
+		while (nullsz) {
+			unsigned long bytes = nullsz;
+			if (bytes > zero_buf_sz)
+				bytes = zero_buf_sz;
+			ret = crypto_shash_update(desc, zero_buf, bytes);
+			if (ret)
+				break;
+			nullsz -= bytes;
+		}
+
+		if (ret)
+			break;
+
+		sha_regions[j].start = ksegment->mem;
+		sha_regions[j].len = ksegment->memsz;
+		j++;
+	}
+
+	if (!ret) {
+		ret = crypto_shash_final(desc, digest);
+		if (ret)
+			goto out_free_sha_regions;
+		ret = kexec_purgatory_get_set_symbol(image, "sha_regions",
+				sha_regions, sha_region_sz, 0);
+		if (ret)
+			goto out_free_sha_regions;
+
+		ret = kexec_purgatory_get_set_symbol(image, "sha256_digest",
+				digest, SHA256_DIGEST_SIZE, 0);
+		if (ret)
+			goto out_free_sha_regions;
+	}
+
+out_free_sha_regions:
+	vfree(sha_regions);
+out_free_zero_buf:
+	kfree(zero_buf);
+out_free_desc:
+	kfree(desc);
+out_free_tfm:
+	kfree(tfm);
+out:
+	kfree(digest);
+	return ret;
+}
+
+/* Actually load and relcoate purgatory. Lot of code taken from kexec-tools */
+static int elf_rel_load_relocate(struct kimage *image, unsigned long min,
+				unsigned long max, int top_down)
+{
+	struct purgatory_info *pi = &image->purgatory_info;
+	unsigned long align, buf_align, bss_align, buf_sz, bss_sz, bss_pad;
+	unsigned long memsz, entry, load_addr, data_addr, bss_addr, off;
+	unsigned char *buf_addr, *src;
+	int i, ret = 0, entry_sidx = -1;
+	Elf_Shdr *sechdrs = NULL, *sechdrs_c;
+	void *purgatory_buf = NULL;
+
+	/*
+	 * sechdrs_c points to section headers in purgatory and are read
+	 * only. No modifications allowed.
+	 */
+	sechdrs_c = (void *)pi->ehdr + pi->ehdr->e_shoff;
+
+	/*
+	 * We can not modify sechdrs_c[] and its fields. It is read only.
+	 * Copy it over to a local copy where one can store some temporary
+	 * data and free it at the end. We need to modify ->sh_addr and
+	 * ->sh_offset fields to keep track permanent and temporary locations
+	 * of sections.
+	 */
+	sechdrs = vzalloc(pi->ehdr->e_shnum * sizeof(Elf_Shdr));
+	if (!sechdrs)
+		return -ENOMEM;
+
+	memcpy(sechdrs, sechdrs_c, pi->ehdr->e_shnum * sizeof(Elf_Shdr));
+
+	/*
+	 * We seem to have multiple copies of sections. First copy is which
+	 * is embedded in kernel in read only section. Some of these sections
+	 * will be copied to a temporary buffer and relocated. And these
+	 * sections will finally be copied to their final detination at
+	 * segment load time.
+	 *
+	 * Use ->sh_offset to reflect section address in memory. It will
+	 * point to original read only copy if section is not allocatable.
+	 * Otherwise it will point to temporary copy which will be relocated.
+	 *
+	 * Use ->sh_addr to contain final address of the section where it
+	 * will go during execution time.
+	 */
+	for (i = 0; i < pi->ehdr->e_shnum; i++) {
+		if (sechdrs[i].sh_type == SHT_NOBITS)
+			continue;
+
+		sechdrs[i].sh_offset = (unsigned long)pi->ehdr +
+						sechdrs[i].sh_offset;
+	}
+
+	entry = pi->ehdr->e_entry;
+	for (i = 0; i < pi->ehdr->e_shnum; i++) {
+		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
+			continue;
+
+		if (!(sechdrs[i].sh_flags & SHF_EXECINSTR))
+			continue;
+
+		/* Make entry section relative */
+		if (sechdrs[i].sh_addr <= pi->ehdr->e_entry &&
+		    ((sechdrs[i].sh_addr + sechdrs[i].sh_size) >
+		     pi->ehdr->e_entry)) {
+			entry_sidx = i;
+			entry -= sechdrs[i].sh_addr;
+			break;
+		}
+	}
+
+	/* Find the RAM size requirements of relocatable object */
+	buf_align = 1;
+	bss_align = 1;
+	buf_sz = 0;
+	bss_sz = 0;
+
+	for (i = 0; i < pi->ehdr->e_shnum; i++) {
+		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
+			continue;
+
+		align = sechdrs[i].sh_addralign;
+		if (sechdrs[i].sh_type != SHT_NOBITS) {
+			if (buf_align < align)
+				buf_align = align;
+			buf_sz = ALIGN(buf_sz, align);
+			buf_sz += sechdrs[i].sh_size;
+		} else {
+			if (bss_align < align)
+				bss_align = align;
+			bss_sz = ALIGN(bss_sz, align);
+			bss_sz += sechdrs[i].sh_size;
+		}
+	}
+
+	if (buf_align < bss_align)
+		buf_align = bss_align;
+	bss_pad = 0;
+	if (buf_sz & (bss_align - 1))
+		bss_pad = bss_align - (buf_sz & (bss_align - 1));
+
+	memsz = buf_sz + bss_pad + bss_sz;
+
+	/* Allocate buffer for purgatory */
+	purgatory_buf = vzalloc(buf_sz);
+	if (!purgatory_buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* Add buffer to segment list */
+	ret = kexec_add_buffer(image, purgatory_buf, buf_sz, memsz,
+				buf_align, min, max, top_down,
+				&pi->purgatory_load_addr);
+	if (ret)
+		goto out;
+
+	/* Load SHF_ALLOC sections */
+	buf_addr = purgatory_buf;
+	load_addr = pi->purgatory_load_addr;
+	data_addr = load_addr;
+	bss_addr = load_addr + buf_sz + bss_pad;
+
+	for (i = 0; i < pi->ehdr->e_shnum; i++) {
+		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
+			continue;
+
+		align = sechdrs[i].sh_addralign;
+		if (sechdrs[i].sh_type != SHT_NOBITS) {
+			data_addr = ALIGN(data_addr, align);
+			off = data_addr - load_addr;
+			/* We have already modifed ->sh_offset to keep addr */
+			src = (char *) sechdrs[i].sh_offset;
+			memcpy(buf_addr + off, src, sechdrs[i].sh_size);
+
+			/* Store load address and source address of section */
+			sechdrs[i].sh_addr = data_addr;
+
+			/*
+			 * This section got copied to temporary buffer. Update
+			 * ->sh_offset accordingly.
+			 */
+			sechdrs[i].sh_offset = (unsigned long)(buf_addr + off);
+
+			/* Advance to the next address */
+			data_addr += sechdrs[i].sh_size;
+		} else {
+			bss_addr = ALIGN(bss_addr, align);
+			sechdrs[i].sh_addr = bss_addr;
+			bss_addr += sechdrs[i].sh_size;
+		}
+	}
+
+	/* update entry based on entry section position */
+	if (entry_sidx >= 0)
+		entry += sechdrs[entry_sidx].sh_addr;
+
+	/* Set the entry point of purgatory */
+	image->start = entry;
+
+	/* Apply relocations */
+	for (i = 0; i < pi->ehdr->e_shnum; i++) {
+		Elf_Shdr *section, *symtab;
+
+		if (sechdrs[i].sh_type != SHT_RELA &&
+		    sechdrs[i].sh_type != SHT_REL)
+			continue;
+
+		if (sechdrs[i].sh_info > pi->ehdr->e_shnum ||
+		    sechdrs[i].sh_link > pi->ehdr->e_shnum) {
+			ret = -ENOEXEC;
+			goto out;
+		}
+
+		section = &sechdrs[sechdrs[i].sh_info];
+		symtab = &sechdrs[sechdrs[i].sh_link];
+
+		if (!(section->sh_flags & SHF_ALLOC))
+			continue;
+
+		if (symtab->sh_link > pi->ehdr->e_shnum)
+			/* Invalid section number? */
+			continue;
+
+		ret = -EOPNOTSUPP;
+		if (sechdrs[i].sh_type == SHT_RELA)
+			ret = arch_kexec_apply_relocations_add(sechdrs,
+							pi->ehdr->e_shnum, i);
+		if (ret)
+			goto out;
+	}
+
+	pi->sechdrs = sechdrs;
+	pi->purgatory_buf = purgatory_buf;
+	return ret;
+out:
+	vfree(sechdrs);
+	vfree(purgatory_buf);
+	return ret;
+}
+
+/* Load relocatable purgatory object and relocate it appropriately */
+int kexec_load_purgatory(struct kimage *image, unsigned long min,
+		unsigned long max, int top_down, unsigned long *load_addr)
+{
+	struct purgatory_info *pi = &image->purgatory_info;
+	int ret;
+
+	if (kexec_purgatory_size <= 0)
+		return -EINVAL;
+
+	if (kexec_purgatory_size < sizeof(Elf_Ehdr))
+		return -ENOEXEC;
+
+	pi->ehdr = (Elf_Ehdr *)kexec_purgatory;
+
+	if (memcmp(pi->ehdr->e_ident, ELFMAG, SELFMAG) != 0
+	    || pi->ehdr->e_type != ET_REL
+	    || !elf_check_arch(pi->ehdr)
+	    || pi->ehdr->e_shentsize != sizeof(Elf_Shdr))
+		return -ENOEXEC;
+
+	if (pi->ehdr->e_shoff >= kexec_purgatory_size
+	    || (pi->ehdr->e_shnum * sizeof(Elf_Shdr) >
+	    kexec_purgatory_size - pi->ehdr->e_shoff))
+		return -ENOEXEC;
+
+	ret = elf_rel_load_relocate(image, min, max, top_down);
+	if (ret)
+		return ret;
+
+	*load_addr = image->purgatory_info.purgatory_load_addr;
+	return 0;
+}
+
+static Elf_Sym *kexec_purgatory_find_symbol(struct purgatory_info *pi,
+						const char *name)
+{
+	Elf_Sym *syms;
+	Elf_Shdr *sechdrs;
+	Elf_Ehdr *ehdr;
+	int i, k;
+	const char *strtab;
+
+	if (!pi->sechdrs || !pi->ehdr)
+		return NULL;
+
+	sechdrs = pi->sechdrs;
+	ehdr = pi->ehdr;
+
+	for (i = 0; i < ehdr->e_shnum; i++) {
+		if (sechdrs[i].sh_type != SHT_SYMTAB)
+			continue;
+
+		if (sechdrs[i].sh_link > ehdr->e_shnum)
+			/* Invalid stratab section number */
+			continue;
+		strtab = (char *)sechdrs[sechdrs[i].sh_link].sh_offset;
+		syms = (Elf_Sym *)sechdrs[i].sh_offset;
+
+		/* Go through symbols for a match */
+		for (k = 0; k < sechdrs[i].sh_size/sizeof(Elf_Sym); k++) {
+			if (ELF_ST_BIND(syms[k].st_info) != STB_GLOBAL)
+				continue;
+
+			if (strcmp(strtab + syms[k].st_name, name) != 0)
+				continue;
+
+			if (syms[k].st_shndx == SHN_UNDEF ||
+			    syms[k].st_shndx > ehdr->e_shnum) {
+				pr_debug("Symbol: %s has bad section index %d.\n",
+						name, syms[k].st_shndx);
+				return NULL;
+			}
+
+			/* Found the symbol we are looking for */
+			return &syms[k];
+		}
+	}
+
+	return NULL;
+}
+
+void *kexec_purgatory_get_symbol_addr(struct kimage *image, const char *name)
+{
+	struct purgatory_info *pi = &image->purgatory_info;
+	Elf_Sym *sym;
+	Elf_Shdr *sechdr;
+
+	sym = kexec_purgatory_find_symbol(pi, name);
+	if (!sym)
+		return ERR_PTR(-EINVAL);
+
+	sechdr = &pi->sechdrs[sym->st_shndx];
+
+	/*
+	 * Returns the address where symbol will finally be loaded after
+	 * kexec_load_segment()
+	 */
+	return (void *)(sechdr->sh_addr + sym->st_value);
+}
+
+/*
+ * Get or set value of a symbol. If "get_value" is true, symbol value is
+ * returned in buf otherwise symbol value is set based on value in buf.
+ */
+int kexec_purgatory_get_set_symbol(struct kimage *image, const char *name,
+				void *buf, unsigned int size, bool get_value)
+{
+	Elf_Sym *sym;
+	Elf_Shdr *sechdrs;
+	struct purgatory_info *pi = &image->purgatory_info;
+	char *sym_buf;
+
+	sym = kexec_purgatory_find_symbol(pi, name);
+	if (!sym)
+		return -EINVAL;
+
+	if (sym->st_size != size) {
+		pr_debug("Symbol: %s size is not right\n", name);
+		return -EINVAL;
+	}
+
+	sechdrs = pi->sechdrs;
+
+	if (sechdrs[sym->st_shndx].sh_type == SHT_NOBITS) {
+		pr_debug("Symbol: %s is in a bss section. Cannot get/set\n",
+					name);
+		return -EINVAL;
+	}
+
+	sym_buf = (unsigned char *)sechdrs[sym->st_shndx].sh_offset +
+					sym->st_value;
+
+	if (get_value)
+		memcpy((void *)buf, sym_buf, size);
+	else
+		memcpy((void *)sym_buf, buf, size);
+
+	return 0;
+}
 
 /*
  * Move into place and start executing a preloaded standalone
-- 
1.9.0

