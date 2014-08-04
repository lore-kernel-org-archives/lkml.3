Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaHDMfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 08:35:53 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52691 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaHDMfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 08:35:51 -0400
Date: Mon, 4 Aug 2014 14:35:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/vdso changes for v3.17
Message-ID: <20140804123546.GA27811@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-vdso-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-vdso-for-linus

   # HEAD: 53b884ac3745353de220d92ef792515c3ae692f0 x86_64/vsyscall: Fix warn_bad_vsyscall log output

Further simplifications and improvements to the VDSO code, by Andy 
Lutomirski.

 Thanks,

	Ingo

------------------>
Andy Lutomirski (4):
      x86, vdso: Move the vvar area before the vdso text
      x86, vdso: Get rid of the fake section mechanism
      x86/vdso: Set VM_MAYREAD for the vvar vma
      x86_64/vsyscall: Fix warn_bad_vsyscall log output


 arch/x86/include/asm/vdso.h       |  18 +--
 arch/x86/kernel/vsyscall_64.c     |   8 +-
 arch/x86/vdso/Makefile            |  16 ++-
 arch/x86/vdso/vdso-fakesections.c |  21 ----
 arch/x86/vdso/vdso-layout.lds.S   |  44 ++++----
 arch/x86/vdso/vdso2c.c            | 128 ++++++++++++++++-----
 arch/x86/vdso/vdso2c.h            | 227 +++++++-------------------------------
 arch/x86/vdso/vma.c               |  22 ++--
 8 files changed, 193 insertions(+), 291 deletions(-)
 delete mode 100644 arch/x86/vdso/vdso-fakesections.c

diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index 30be253..8021bd2 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -18,15 +18,15 @@ struct vdso_image {
 
 	unsigned long alt, alt_len;
 
-	unsigned long sym_end_mapping;  /* Total size of the mapping */
-
-	unsigned long sym_vvar_page;
-	unsigned long sym_hpet_page;
-	unsigned long sym_VDSO32_NOTE_MASK;
-	unsigned long sym___kernel_sigreturn;
-	unsigned long sym___kernel_rt_sigreturn;
-	unsigned long sym___kernel_vsyscall;
-	unsigned long sym_VDSO32_SYSENTER_RETURN;
+	long sym_vvar_start;  /* Negative offset to the vvar area */
+
+	long sym_vvar_page;
+	long sym_hpet_page;
+	long sym_VDSO32_NOTE_MASK;
+	long sym___kernel_sigreturn;
+	long sym___kernel_rt_sigreturn;
+	long sym___kernel_vsyscall;
+	long sym_VDSO32_SYSENTER_RETURN;
 };
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index ea5b570..e1e1e80 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -81,10 +81,10 @@ static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
 	if (!show_unhandled_signals)
 		return;
 
-	pr_notice_ratelimited("%s%s[%d] %s ip:%lx cs:%lx sp:%lx ax:%lx si:%lx di:%lx\n",
-			      level, current->comm, task_pid_nr(current),
-			      message, regs->ip, regs->cs,
-			      regs->sp, regs->ax, regs->si, regs->di);
+	printk_ratelimited("%s%s[%d] %s ip:%lx cs:%lx sp:%lx ax:%lx si:%lx di:%lx\n",
+			   level, current->comm, task_pid_nr(current),
+			   message, regs->ip, regs->cs,
+			   regs->sp, regs->ax, regs->si, regs->di);
 }
 
 static int addr_to_vsyscall_nr(unsigned long addr)
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 61b04fe..5a4affe 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -10,7 +10,7 @@ VDSO32-$(CONFIG_X86_32)		:= y
 VDSO32-$(CONFIG_COMPAT)		:= y
 
 # files to link into the vdso
-vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o vdso-fakesections.o
+vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o
 
 # files to link into kernel
 obj-y				+= vma.o
@@ -37,7 +37,8 @@ vdso_img_sodbg := $(vdso_img-y:%=vdso%.so.dbg)
 obj-y += $(vdso_img_objs)
 targets += $(vdso_img_cfiles)
 targets += $(vdso_img_sodbg)
-.SECONDARY: $(vdso_img-y:%=$(obj)/vdso-image-%.c)
+.SECONDARY: $(vdso_img-y:%=$(obj)/vdso-image-%.c) \
+	$(vdso_img-y:%=$(obj)/vdso%.so)
 
 export CPPFLAGS_vdso.lds += -P -C
 
@@ -54,10 +55,10 @@ hostprogs-y			+= vdso2c
 
 quiet_cmd_vdso2c = VDSO2C  $@
 define cmd_vdso2c
-	$(obj)/vdso2c $< $@
+	$(obj)/vdso2c $< $(<:%.dbg=%) $@
 endef
 
-$(obj)/vdso-image-%.c: $(obj)/vdso%.so.dbg $(obj)/vdso2c FORCE
+$(obj)/vdso-image-%.c: $(obj)/vdso%.so.dbg $(obj)/vdso%.so $(obj)/vdso2c FORCE
 	$(call if_changed,vdso2c)
 
 #
@@ -113,6 +114,10 @@ $(obj)/%-x32.o: $(obj)/%.o FORCE
 
 targets += vdsox32.lds $(vobjx32s-y)
 
+$(obj)/%.so: OBJCOPYFLAGS := -S
+$(obj)/%.so: $(obj)/%.so.dbg
+	$(call if_changed,objcopy)
+
 $(obj)/vdsox32.so.dbg: $(src)/vdsox32.lds $(vobjx32s) FORCE
 	$(call if_changed,vdso)
 
@@ -134,7 +139,7 @@ override obj-dirs = $(dir $(obj)) $(obj)/vdso32/
 
 targets += vdso32/vdso32.lds
 targets += vdso32/note.o vdso32/vclock_gettime.o $(vdso32.so-y:%=vdso32/%.o)
-targets += vdso32/vclock_gettime.o vdso32/vdso-fakesections.o
+targets += vdso32/vclock_gettime.o
 
 $(obj)/vdso32.o: $(vdso32-images:%=$(obj)/%)
 
@@ -156,7 +161,6 @@ $(vdso32-images:%=$(obj)/%.dbg): KBUILD_CFLAGS = $(KBUILD_CFLAGS_32)
 $(vdso32-images:%=$(obj)/%.dbg): $(obj)/vdso32-%.so.dbg: FORCE \
 				 $(obj)/vdso32/vdso32.lds \
 				 $(obj)/vdso32/vclock_gettime.o \
-				 $(obj)/vdso32/vdso-fakesections.o \
 				 $(obj)/vdso32/note.o \
 				 $(obj)/vdso32/%.o
 	$(call if_changed,vdso)
diff --git a/arch/x86/vdso/vdso-fakesections.c b/arch/x86/vdso/vdso-fakesections.c
deleted file mode 100644
index aa5fbfa..0000000
--- a/arch/x86/vdso/vdso-fakesections.c
+++ /dev/null
@@ -1,21 +0,0 @@
-/*
- * Copyright 2014 Andy Lutomirski
- * Subject to the GNU Public License, v.2
- *
- * String table for loadable section headers.  See vdso2c.h for why
- * this exists.
- */
-
-const char fake_shstrtab[] __attribute__((section(".fake_shstrtab"))) =
-	".hash\0"
-	".dynsym\0"
-	".dynstr\0"
-	".gnu.version\0"
-	".gnu.version_d\0"
-	".dynamic\0"
-	".rodata\0"
-	".fake_shstrtab\0"  /* Yay, self-referential code. */
-	".note\0"
-	".eh_frame_hdr\0"
-	".eh_frame\0"
-	".text";
diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index 9197544..de2c921 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -18,6 +18,25 @@
 
 SECTIONS
 {
+	/*
+	 * User/kernel shared data is before the vDSO.  This may be a little
+	 * uglier than putting it after the vDSO, but it avoids issues with
+	 * non-allocatable things that dangle past the end of the PT_LOAD
+	 * segment.
+	 */
+
+	vvar_start = . - 2 * PAGE_SIZE;
+	vvar_page = vvar_start;
+
+	/* Place all vvars at the offsets in asm/vvar.h. */
+#define EMIT_VVAR(name, offset) vvar_ ## name = vvar_page + offset;
+#define __VVAR_KERNEL_LDS
+#include <asm/vvar.h>
+#undef __VVAR_KERNEL_LDS
+#undef EMIT_VVAR
+
+	hpet_page = vvar_start + PAGE_SIZE;
+
 	. = SIZEOF_HEADERS;
 
 	.hash		: { *(.hash) }			:text
@@ -74,31 +93,6 @@ SECTIONS
 	.altinstructions	: { *(.altinstructions) }	:text
 	.altinstr_replacement	: { *(.altinstr_replacement) }	:text
 
-	/*
-	 * The remainder of the vDSO consists of special pages that are
-	 * shared between the kernel and userspace.  It needs to be at the
-	 * end so that it doesn't overlap the mapping of the actual
-	 * vDSO image.
-	 */
-
-	. = ALIGN(PAGE_SIZE);
-	vvar_page = .;
-
-	/* Place all vvars at the offsets in asm/vvar.h. */
-#define EMIT_VVAR(name, offset) vvar_ ## name = vvar_page + offset;
-#define __VVAR_KERNEL_LDS
-#include <asm/vvar.h>
-#undef __VVAR_KERNEL_LDS
-#undef EMIT_VVAR
-
-	. = vvar_page + PAGE_SIZE;
-
-	hpet_page = .;
-	. = . + PAGE_SIZE;
-
-	. = ALIGN(PAGE_SIZE);
-	end_mapping = .;
-
 	/DISCARD/ : {
 		*(.discard)
 		*(.discard.*)
diff --git a/arch/x86/vdso/vdso2c.c b/arch/x86/vdso/vdso2c.c
index 238dbe82..8627db2 100644
--- a/arch/x86/vdso/vdso2c.c
+++ b/arch/x86/vdso/vdso2c.c
@@ -1,3 +1,53 @@
+/*
+ * vdso2c - A vdso image preparation tool
+ * Copyright (c) 2014 Andy Lutomirski and others
+ * Licensed under the GPL v2
+ *
+ * vdso2c requires stripped and unstripped input.  It would be trivial
+ * to fully strip the input in here, but, for reasons described below,
+ * we need to write a section table.  Doing this is more or less
+ * equivalent to dropping all non-allocatable sections, but it's
+ * easier to let objcopy handle that instead of doing it ourselves.
+ * If we ever need to do something fancier than what objcopy provides,
+ * it would be straightforward to add here.
+ *
+ * We're keep a section table for a few reasons:
+ *
+ * The Go runtime had a couple of bugs: it would read the section
+ * table to try to figure out how many dynamic symbols there were (it
+ * shouldn't have looked at the section table at all) and, if there
+ * were no SHT_SYNDYM section table entry, it would use an
+ * uninitialized value for the number of symbols.  An empty DYNSYM
+ * table would work, but I see no reason not to write a valid one (and
+ * keep full performance for old Go programs).  This hack is only
+ * needed on x86_64.
+ *
+ * The bug was introduced on 2012-08-31 by:
+ * https://code.google.com/p/go/source/detail?r=56ea40aac72b
+ * and was fixed on 2014-06-13 by:
+ * https://code.google.com/p/go/source/detail?r=fc1cd5e12595
+ *
+ * Binutils has issues debugging the vDSO: it reads the section table to
+ * find SHT_NOTE; it won't look at PT_NOTE for the in-memory vDSO, which
+ * would break build-id if we removed the section table.  Binutils
+ * also requires that shstrndx != 0.  See:
+ * https://sourceware.org/bugzilla/show_bug.cgi?id=17064
+ *
+ * elfutils might not look for PT_NOTE if there is a section table at
+ * all.  I don't know whether this matters for any practical purpose.
+ *
+ * For simplicity, rather than hacking up a partial section table, we
+ * just write a mostly complete one.  We omit non-dynamic symbols,
+ * though, since they're rather large.
+ *
+ * Once binutils gets fixed, we might be able to drop this for all but
+ * the 64-bit vdso, since build-id only works in kernel RPMs, and
+ * systems that update to new enough kernel RPMs will likely update
+ * binutils in sync.  build-id has never worked for home-built kernel
+ * RPMs without manual symlinking, and I suspect that no one ever does
+ * that.
+ */
+
 #include <inttypes.h>
 #include <stdint.h>
 #include <unistd.h>
@@ -20,9 +70,9 @@ const char *outfilename;
 
 /* Symbols that we need in vdso2c. */
 enum {
+	sym_vvar_start,
 	sym_vvar_page,
 	sym_hpet_page,
-	sym_end_mapping,
 	sym_VDSO_FAKE_SECTION_TABLE_START,
 	sym_VDSO_FAKE_SECTION_TABLE_END,
 };
@@ -38,9 +88,9 @@ struct vdso_sym {
 };
 
 struct vdso_sym required_syms[] = {
+	[sym_vvar_start] = {"vvar_start", true},
 	[sym_vvar_page] = {"vvar_page", true},
 	[sym_hpet_page] = {"hpet_page", true},
-	[sym_end_mapping] = {"end_mapping", true},
 	[sym_VDSO_FAKE_SECTION_TABLE_START] = {
 		"VDSO_FAKE_SECTION_TABLE_START", false
 	},
@@ -61,7 +111,8 @@ static void fail(const char *format, ...)
 	va_start(ap, format);
 	fprintf(stderr, "Error: ");
 	vfprintf(stderr, format, ap);
-	unlink(outfilename);
+	if (outfilename)
+		unlink(outfilename);
 	exit(1);
 	va_end(ap);
 }
@@ -96,9 +147,11 @@ extern void bad_put_le(void);
 
 #define NSYMS (sizeof(required_syms) / sizeof(required_syms[0]))
 
-#define BITSFUNC3(name, bits) name##bits
-#define BITSFUNC2(name, bits) BITSFUNC3(name, bits)
-#define BITSFUNC(name) BITSFUNC2(name, ELF_BITS)
+#define BITSFUNC3(name, bits, suffix) name##bits##suffix
+#define BITSFUNC2(name, bits, suffix) BITSFUNC3(name, bits, suffix)
+#define BITSFUNC(name) BITSFUNC2(name, ELF_BITS, )
+
+#define INT_BITS BITSFUNC2(int, ELF_BITS, _t)
 
 #define ELF_BITS_XFORM2(bits, x) Elf##bits##_##x
 #define ELF_BITS_XFORM(bits, x) ELF_BITS_XFORM2(bits, x)
@@ -112,30 +165,53 @@ extern void bad_put_le(void);
 #include "vdso2c.h"
 #undef ELF_BITS
 
-static void go(void *addr, size_t len, FILE *outfile, const char *name)
+static void go(void *raw_addr, size_t raw_len,
+	       void *stripped_addr, size_t stripped_len,
+	       FILE *outfile, const char *name)
 {
-	Elf64_Ehdr *hdr = (Elf64_Ehdr *)addr;
+	Elf64_Ehdr *hdr = (Elf64_Ehdr *)raw_addr;
 
 	if (hdr->e_ident[EI_CLASS] == ELFCLASS64) {
-		go64(addr, len, outfile, name);
+		go64(raw_addr, raw_len, stripped_addr, stripped_len,
+		     outfile, name);
 	} else if (hdr->e_ident[EI_CLASS] == ELFCLASS32) {
-		go32(addr, len, outfile, name);
+		go32(raw_addr, raw_len, stripped_addr, stripped_len,
+		     outfile, name);
 	} else {
 		fail("unknown ELF class\n");
 	}
 }
 
+static void map_input(const char *name, void **addr, size_t *len, int prot)
+{
+	off_t tmp_len;
+
+	int fd = open(name, O_RDONLY);
+	if (fd == -1)
+		err(1, "%s", name);
+
+	tmp_len = lseek(fd, 0, SEEK_END);
+	if (tmp_len == (off_t)-1)
+		err(1, "lseek");
+	*len = (size_t)tmp_len;
+
+	*addr = mmap(NULL, tmp_len, prot, MAP_PRIVATE, fd, 0);
+	if (*addr == MAP_FAILED)
+		err(1, "mmap");
+
+	close(fd);
+}
+
 int main(int argc, char **argv)
 {
-	int fd;
-	off_t len;
-	void *addr;
+	size_t raw_len, stripped_len;
+	void *raw_addr, *stripped_addr;
 	FILE *outfile;
 	char *name, *tmp;
 	int namelen;
 
-	if (argc != 3) {
-		printf("Usage: vdso2c INPUT OUTPUT\n");
+	if (argc != 4) {
+		printf("Usage: vdso2c RAW_INPUT STRIPPED_INPUT OUTPUT\n");
 		return 1;
 	}
 
@@ -143,7 +219,7 @@ int main(int argc, char **argv)
 	 * Figure out the struct name.  If we're writing to a .so file,
 	 * generate raw output insted.
 	 */
-	name = strdup(argv[2]);
+	name = strdup(argv[3]);
 	namelen = strlen(name);
 	if (namelen >= 3 && !strcmp(name + namelen - 3, ".so")) {
 		name = NULL;
@@ -159,26 +235,18 @@ int main(int argc, char **argv)
 				*tmp = '_';
 	}
 
-	fd = open(argv[1], O_RDONLY);
-	if (fd == -1)
-		err(1, "%s", argv[1]);
-
-	len = lseek(fd, 0, SEEK_END);
-	if (len == (off_t)-1)
-		err(1, "lseek");
-
-	addr = mmap(NULL, len, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
-	if (addr == MAP_FAILED)
-		err(1, "mmap");
+	map_input(argv[1], &raw_addr, &raw_len, PROT_READ);
+	map_input(argv[2], &stripped_addr, &stripped_len, PROT_READ);
 
-	outfilename = argv[2];
+	outfilename = argv[3];
 	outfile = fopen(outfilename, "w");
 	if (!outfile)
 		err(1, "%s", argv[2]);
 
-	go(addr, (size_t)len, outfile, name);
+	go(raw_addr, raw_len, stripped_addr, stripped_len, outfile, name);
 
-	munmap(addr, len);
+	munmap(raw_addr, raw_len);
+	munmap(stripped_addr, stripped_len);
 	fclose(outfile);
 
 	return 0;
diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index 11b65d4..fd57829 100644
--- a/arch/x86/vdso/vdso2c.h
+++ b/arch/x86/vdso/vdso2c.h
@@ -4,139 +4,23 @@
  * are built for 32-bit userspace.
  */
 
-/*
- * We're writing a section table for a few reasons:
- *
- * The Go runtime had a couple of bugs: it would read the section
- * table to try to figure out how many dynamic symbols there were (it
- * shouldn't have looked at the section table at all) and, if there
- * were no SHT_SYNDYM section table entry, it would use an
- * uninitialized value for the number of symbols.  An empty DYNSYM
- * table would work, but I see no reason not to write a valid one (and
- * keep full performance for old Go programs).  This hack is only
- * needed on x86_64.
- *
- * The bug was introduced on 2012-08-31 by:
- * https://code.google.com/p/go/source/detail?r=56ea40aac72b
- * and was fixed on 2014-06-13 by:
- * https://code.google.com/p/go/source/detail?r=fc1cd5e12595
- *
- * Binutils has issues debugging the vDSO: it reads the section table to
- * find SHT_NOTE; it won't look at PT_NOTE for the in-memory vDSO, which
- * would break build-id if we removed the section table.  Binutils
- * also requires that shstrndx != 0.  See:
- * https://sourceware.org/bugzilla/show_bug.cgi?id=17064
- *
- * elfutils might not look for PT_NOTE if there is a section table at
- * all.  I don't know whether this matters for any practical purpose.
- *
- * For simplicity, rather than hacking up a partial section table, we
- * just write a mostly complete one.  We omit non-dynamic symbols,
- * though, since they're rather large.
- *
- * Once binutils gets fixed, we might be able to drop this for all but
- * the 64-bit vdso, since build-id only works in kernel RPMs, and
- * systems that update to new enough kernel RPMs will likely update
- * binutils in sync.  build-id has never worked for home-built kernel
- * RPMs without manual symlinking, and I suspect that no one ever does
- * that.
- */
-struct BITSFUNC(fake_sections)
-{
-	ELF(Shdr) *table;
-	unsigned long table_offset;
-	int count, max_count;
-
-	int in_shstrndx;
-	unsigned long shstr_offset;
-	const char *shstrtab;
-	size_t shstrtab_len;
-
-	int out_shstrndx;
-};
-
-static unsigned int BITSFUNC(find_shname)(struct BITSFUNC(fake_sections) *out,
-					  const char *name)
-{
-	const char *outname = out->shstrtab;
-	while (outname - out->shstrtab < out->shstrtab_len) {
-		if (!strcmp(name, outname))
-			return (outname - out->shstrtab) + out->shstr_offset;
-		outname += strlen(outname) + 1;
-	}
-
-	if (*name)
-		printf("Warning: could not find output name \"%s\"\n", name);
-	return out->shstr_offset + out->shstrtab_len - 1;  /* Use a null. */
-}
-
-static void BITSFUNC(init_sections)(struct BITSFUNC(fake_sections) *out)
-{
-	if (!out->in_shstrndx)
-		fail("didn't find the fake shstrndx\n");
-
-	memset(out->table, 0, out->max_count * sizeof(ELF(Shdr)));
-
-	if (out->max_count < 1)
-		fail("we need at least two fake output sections\n");
-
-	PUT_LE(&out->table[0].sh_type, SHT_NULL);
-	PUT_LE(&out->table[0].sh_name, BITSFUNC(find_shname)(out, ""));
-
-	out->count = 1;
-}
-
-static void BITSFUNC(copy_section)(struct BITSFUNC(fake_sections) *out,
-				   int in_idx, const ELF(Shdr) *in,
-				   const char *name)
-{
-	uint64_t flags = GET_LE(&in->sh_flags);
-
-	bool copy = flags & SHF_ALLOC &&
-		(GET_LE(&in->sh_size) ||
-		 (GET_LE(&in->sh_type) != SHT_RELA &&
-		  GET_LE(&in->sh_type) != SHT_REL)) &&
-		strcmp(name, ".altinstructions") &&
-		strcmp(name, ".altinstr_replacement");
-
-	if (!copy)
-		return;
-
-	if (out->count >= out->max_count)
-		fail("too many copied sections (max = %d)\n", out->max_count);
-
-	if (in_idx == out->in_shstrndx)
-		out->out_shstrndx = out->count;
-
-	out->table[out->count] = *in;
-	PUT_LE(&out->table[out->count].sh_name,
-	       BITSFUNC(find_shname)(out, name));
-
-	/* elfutils requires that a strtab have the correct type. */
-	if (!strcmp(name, ".fake_shstrtab"))
-		PUT_LE(&out->table[out->count].sh_type, SHT_STRTAB);
-
-	out->count++;
-}
-
-static void BITSFUNC(go)(void *addr, size_t len,
+static void BITSFUNC(go)(void *raw_addr, size_t raw_len,
+			 void *stripped_addr, size_t stripped_len,
 			 FILE *outfile, const char *name)
 {
 	int found_load = 0;
 	unsigned long load_size = -1;  /* Work around bogus warning */
-	unsigned long data_size;
-	ELF(Ehdr) *hdr = (ELF(Ehdr) *)addr;
+	unsigned long mapping_size;
+	ELF(Ehdr) *hdr = (ELF(Ehdr) *)raw_addr;
 	int i;
 	unsigned long j;
 	ELF(Shdr) *symtab_hdr = NULL, *strtab_hdr, *secstrings_hdr,
 		*alt_sec = NULL;
 	ELF(Dyn) *dyn = 0, *dyn_end = 0;
 	const char *secstrings;
-	uint64_t syms[NSYMS] = {};
-
-	struct BITSFUNC(fake_sections) fake_sections = {};
+	INT_BITS syms[NSYMS] = {};
 
-	ELF(Phdr) *pt = (ELF(Phdr) *)(addr + GET_LE(&hdr->e_phoff));
+	ELF(Phdr) *pt = (ELF(Phdr) *)(raw_addr + GET_LE(&hdr->e_phoff));
 
 	/* Walk the segment table. */
 	for (i = 0; i < GET_LE(&hdr->e_phnum); i++) {
@@ -154,14 +38,16 @@ static void BITSFUNC(go)(void *addr, size_t len,
 			load_size = GET_LE(&pt[i].p_memsz);
 			found_load = 1;
 		} else if (GET_LE(&pt[i].p_type) == PT_DYNAMIC) {
-			dyn = addr + GET_LE(&pt[i].p_offset);
-			dyn_end = addr + GET_LE(&pt[i].p_offset) +
+			dyn = raw_addr + GET_LE(&pt[i].p_offset);
+			dyn_end = raw_addr + GET_LE(&pt[i].p_offset) +
 				GET_LE(&pt[i].p_memsz);
 		}
 	}
 	if (!found_load)
 		fail("no PT_LOAD seg\n");
-	data_size = (load_size + 4095) / 4096 * 4096;
+
+	if (stripped_len < load_size)
+		fail("stripped input is too short\n");
 
 	/* Walk the dynamic table */
 	for (i = 0; dyn + i < dyn_end &&
@@ -173,11 +59,11 @@ static void BITSFUNC(go)(void *addr, size_t len,
 	}
 
 	/* Walk the section table */
-	secstrings_hdr = addr + GET_LE(&hdr->e_shoff) +
+	secstrings_hdr = raw_addr + GET_LE(&hdr->e_shoff) +
 		GET_LE(&hdr->e_shentsize)*GET_LE(&hdr->e_shstrndx);
-	secstrings = addr + GET_LE(&secstrings_hdr->sh_offset);
+	secstrings = raw_addr + GET_LE(&secstrings_hdr->sh_offset);
 	for (i = 0; i < GET_LE(&hdr->e_shnum); i++) {
-		ELF(Shdr) *sh = addr + GET_LE(&hdr->e_shoff) +
+		ELF(Shdr) *sh = raw_addr + GET_LE(&hdr->e_shoff) +
 			GET_LE(&hdr->e_shentsize) * i;
 		if (GET_LE(&sh->sh_type) == SHT_SYMTAB)
 			symtab_hdr = sh;
@@ -190,7 +76,7 @@ static void BITSFUNC(go)(void *addr, size_t len,
 	if (!symtab_hdr)
 		fail("no symbol table\n");
 
-	strtab_hdr = addr + GET_LE(&hdr->e_shoff) +
+	strtab_hdr = raw_addr + GET_LE(&hdr->e_shoff) +
 		GET_LE(&hdr->e_shentsize) * GET_LE(&symtab_hdr->sh_link);
 
 	/* Walk the symbol table */
@@ -198,9 +84,9 @@ static void BITSFUNC(go)(void *addr, size_t len,
 	     i < GET_LE(&symtab_hdr->sh_size) / GET_LE(&symtab_hdr->sh_entsize);
 	     i++) {
 		int k;
-		ELF(Sym) *sym = addr + GET_LE(&symtab_hdr->sh_offset) +
+		ELF(Sym) *sym = raw_addr + GET_LE(&symtab_hdr->sh_offset) +
 			GET_LE(&symtab_hdr->sh_entsize) * i;
-		const char *name = addr + GET_LE(&strtab_hdr->sh_offset) +
+		const char *name = raw_addr + GET_LE(&strtab_hdr->sh_offset) +
 			GET_LE(&sym->st_name);
 
 		for (k = 0; k < NSYMS; k++) {
@@ -209,51 +95,17 @@ static void BITSFUNC(go)(void *addr, size_t len,
 					fail("duplicate symbol %s\n",
 					     required_syms[k].name);
 				}
+
+				/*
+				 * Careful: we use negative addresses, but
+				 * st_value is unsigned, so we rely
+				 * on syms[k] being a signed type of the
+				 * correct width.
+				 */
 				syms[k] = GET_LE(&sym->st_value);
 			}
 		}
-
-		if (!strcmp(name, "fake_shstrtab")) {
-			ELF(Shdr) *sh;
-
-			fake_sections.in_shstrndx = GET_LE(&sym->st_shndx);
-			fake_sections.shstrtab = addr + GET_LE(&sym->st_value);
-			fake_sections.shstrtab_len = GET_LE(&sym->st_size);
-			sh = addr + GET_LE(&hdr->e_shoff) +
-				GET_LE(&hdr->e_shentsize) *
-				fake_sections.in_shstrndx;
-			fake_sections.shstr_offset = GET_LE(&sym->st_value) -
-				GET_LE(&sh->sh_addr);
-		}
-	}
-
-	/* Build the output section table. */
-	if (!syms[sym_VDSO_FAKE_SECTION_TABLE_START] ||
-	    !syms[sym_VDSO_FAKE_SECTION_TABLE_END])
-		fail("couldn't find fake section table\n");
-	if ((syms[sym_VDSO_FAKE_SECTION_TABLE_END] -
-	     syms[sym_VDSO_FAKE_SECTION_TABLE_START]) % sizeof(ELF(Shdr)))
-		fail("fake section table size isn't a multiple of sizeof(Shdr)\n");
-	fake_sections.table = addr + syms[sym_VDSO_FAKE_SECTION_TABLE_START];
-	fake_sections.table_offset = syms[sym_VDSO_FAKE_SECTION_TABLE_START];
-	fake_sections.max_count = (syms[sym_VDSO_FAKE_SECTION_TABLE_END] -
-				   syms[sym_VDSO_FAKE_SECTION_TABLE_START]) /
-		sizeof(ELF(Shdr));
-
-	BITSFUNC(init_sections)(&fake_sections);
-	for (i = 0; i < GET_LE(&hdr->e_shnum); i++) {
-		ELF(Shdr) *sh = addr + GET_LE(&hdr->e_shoff) +
-			GET_LE(&hdr->e_shentsize) * i;
-		BITSFUNC(copy_section)(&fake_sections, i, sh,
-				       secstrings + GET_LE(&sh->sh_name));
 	}
-	if (!fake_sections.out_shstrndx)
-		fail("didn't generate shstrndx?!?\n");
-
-	PUT_LE(&hdr->e_shoff, fake_sections.table_offset);
-	PUT_LE(&hdr->e_shentsize, sizeof(ELF(Shdr)));
-	PUT_LE(&hdr->e_shnum, fake_sections.count);
-	PUT_LE(&hdr->e_shstrndx, fake_sections.out_shstrndx);
 
 	/* Validate mapping addresses. */
 	for (i = 0; i < sizeof(special_pages) / sizeof(special_pages[0]); i++) {
@@ -263,21 +115,23 @@ static void BITSFUNC(go)(void *addr, size_t len,
 		if (syms[i] % 4096)
 			fail("%s must be a multiple of 4096\n",
 			     required_syms[i].name);
-		if (syms[i] < data_size)
-			fail("%s must be after the text mapping\n",
+		if (syms[sym_vvar_start] > syms[i] + 4096)
+			fail("%s underruns begin_vvar\n",
 			     required_syms[i].name);
-		if (syms[sym_end_mapping] < syms[i] + 4096)
-			fail("%s overruns end_mapping\n",
+		if (syms[i] + 4096 > 0)
+			fail("%s is on the wrong side of the vdso text\n",
 			     required_syms[i].name);
 	}
-	if (syms[sym_end_mapping] % 4096)
-		fail("end_mapping must be a multiple of 4096\n");
+	if (syms[sym_vvar_start] % 4096)
+		fail("vvar_begin must be a multiple of 4096\n");
 
 	if (!name) {
-		fwrite(addr, load_size, 1, outfile);
+		fwrite(stripped_addr, stripped_len, 1, outfile);
 		return;
 	}
 
+	mapping_size = (stripped_len + 4095) / 4096 * 4096;
+
 	fprintf(outfile, "/* AUTOMATICALLY GENERATED -- DO NOT EDIT */\n\n");
 	fprintf(outfile, "#include <linux/linkage.h>\n");
 	fprintf(outfile, "#include <asm/page_types.h>\n");
@@ -285,20 +139,21 @@ static void BITSFUNC(go)(void *addr, size_t len,
 	fprintf(outfile, "\n");
 	fprintf(outfile,
 		"static unsigned char raw_data[%lu] __page_aligned_data = {",
-		data_size);
-	for (j = 0; j < load_size; j++) {
+		mapping_size);
+	for (j = 0; j < stripped_len; j++) {
 		if (j % 10 == 0)
 			fprintf(outfile, "\n\t");
-		fprintf(outfile, "0x%02X, ", (int)((unsigned char *)addr)[j]);
+		fprintf(outfile, "0x%02X, ",
+			(int)((unsigned char *)stripped_addr)[j]);
 	}
 	fprintf(outfile, "\n};\n\n");
 
 	fprintf(outfile, "static struct page *pages[%lu];\n\n",
-		data_size / 4096);
+		mapping_size / 4096);
 
 	fprintf(outfile, "const struct vdso_image %s = {\n", name);
 	fprintf(outfile, "\t.data = raw_data,\n");
-	fprintf(outfile, "\t.size = %lu,\n", data_size);
+	fprintf(outfile, "\t.size = %lu,\n", mapping_size);
 	fprintf(outfile, "\t.text_mapping = {\n");
 	fprintf(outfile, "\t\t.name = \"[vdso]\",\n");
 	fprintf(outfile, "\t\t.pages = pages,\n");
@@ -311,8 +166,8 @@ static void BITSFUNC(go)(void *addr, size_t len,
 	}
 	for (i = 0; i < NSYMS; i++) {
 		if (required_syms[i].export && syms[i])
-			fprintf(outfile, "\t.sym_%s = 0x%" PRIx64 ",\n",
-				required_syms[i].name, syms[i]);
+			fprintf(outfile, "\t.sym_%s = %" PRIi64 ",\n",
+				required_syms[i].name, (int64_t)syms[i]);
 	}
 	fprintf(outfile, "};\n");
 }
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 5a5176d..970463b 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -93,7 +93,7 @@ static int map_vdso(const struct vdso_image *image, bool calculate_addr)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	unsigned long addr;
+	unsigned long addr, text_start;
 	int ret = 0;
 	static struct page *no_pages[] = {NULL};
 	static struct vm_special_mapping vvar_mapping = {
@@ -103,26 +103,28 @@ static int map_vdso(const struct vdso_image *image, bool calculate_addr)
 
 	if (calculate_addr) {
 		addr = vdso_addr(current->mm->start_stack,
-				 image->sym_end_mapping);
+				 image->size - image->sym_vvar_start);
 	} else {
 		addr = 0;
 	}
 
 	down_write(&mm->mmap_sem);
 
-	addr = get_unmapped_area(NULL, addr, image->sym_end_mapping, 0, 0);
+	addr = get_unmapped_area(NULL, addr,
+				 image->size - image->sym_vvar_start, 0, 0);
 	if (IS_ERR_VALUE(addr)) {
 		ret = addr;
 		goto up_fail;
 	}
 
-	current->mm->context.vdso = (void __user *)addr;
+	text_start = addr - image->sym_vvar_start;
+	current->mm->context.vdso = (void __user *)text_start;
 
 	/*
 	 * MAYWRITE to allow gdb to COW and set breakpoints
 	 */
 	vma = _install_special_mapping(mm,
-				       addr,
+				       text_start,
 				       image->size,
 				       VM_READ|VM_EXEC|
 				       VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
@@ -134,9 +136,9 @@ static int map_vdso(const struct vdso_image *image, bool calculate_addr)
 	}
 
 	vma = _install_special_mapping(mm,
-				       addr + image->size,
-				       image->sym_end_mapping - image->size,
-				       VM_READ,
+				       addr,
+				       -image->sym_vvar_start,
+				       VM_READ|VM_MAYREAD,
 				       &vvar_mapping);
 
 	if (IS_ERR(vma)) {
@@ -146,7 +148,7 @@ static int map_vdso(const struct vdso_image *image, bool calculate_addr)
 
 	if (image->sym_vvar_page)
 		ret = remap_pfn_range(vma,
-				      addr + image->sym_vvar_page,
+				      text_start + image->sym_vvar_page,
 				      __pa_symbol(&__vvar_page) >> PAGE_SHIFT,
 				      PAGE_SIZE,
 				      PAGE_READONLY);
@@ -157,7 +159,7 @@ static int map_vdso(const struct vdso_image *image, bool calculate_addr)
 #ifdef CONFIG_HPET_TIMER
 	if (hpet_address && image->sym_hpet_page) {
 		ret = io_remap_pfn_range(vma,
-			addr + image->sym_hpet_page,
+			text_start + image->sym_hpet_page,
 			hpet_address >> PAGE_SHIFT,
 			PAGE_SIZE,
 			pgprot_noncached(PAGE_READONLY));
