Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbaAaAAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 19:00:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37602 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbaAaAAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 19:00:14 -0500
Date: Thu, 30 Jan 2014 15:59:48 -0800
Message-Id: <201401302359.s0UNxmu8017092@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/build additional for v3.14
Cc: David Woodhouse <David.Woodhouse@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 30 Jan 2014 15:59:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Various build-related minor bits.

Most of this is work by David Woodhouse to be able to compile the
early boot code with clang/llvm; we have also managed to push an
actual -m16 option into gcc 4.9 so this makes us use that option if
available instead of hacking it.

The balance is a patch from Michael Davidson to the relocs program to
help manual debugging.

None of these should change the actual compiled binary with currently
released compilers.

The following changes since commit f4bcd8ccddb02833340652e9f46f5127828eb79d:

  Merge branch 'x86-kaslr-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2014-01-20 14:45:50 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-build-for-linus

for you to fetch changes up to de3accdaec88851874c573031de007283e90b199:

  x86, build: Build 16-bit code with -m16 where possible (2014-01-30 08:05:36 -0800)

----------------------------------------------------------------
David Woodhouse (4):
      x86: Remove duplication of 16-bit CFLAGS
      x86, boot: Use __attribute__((used)) to ensure videocard structs are emitted
      x86, boot: Fix word-size assumptions in has_eflag() inline asm
      x86, build: Build 16-bit code with -m16 where possible

H. Peter Anvin (1):
      Merge commit 'f4bcd8ccddb02833340652e9f46f5127828eb79d' into x86/build

Michael Davidson (1):
      x86, relocs: Add manual debug mode

 arch/x86/Makefile              | 22 ++++++++++++++++++++++
 arch/x86/boot/Makefile         | 15 +--------------
 arch/x86/boot/cpuflags.c       | 25 ++++++++++++++++++++-----
 arch/x86/boot/video.h          |  2 +-
 arch/x86/realmode/rm/Makefile  | 17 ++---------------
 arch/x86/tools/relocs.c        | 30 +++++++++++++++++++++++++++++-
 arch/x86/tools/relocs.h        |  7 ++++---
 arch/x86/tools/relocs_common.c | 16 ++++++++++++----
 8 files changed, 91 insertions(+), 43 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 13b22e0f681d..eeda43abed6e 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -11,6 +11,28 @@ else
         KBUILD_DEFCONFIG := $(ARCH)_defconfig
 endif
 
+# How to compile the 16-bit code.  Note we always compile for -march=i386;
+# that way we can complain to the user if the CPU is insufficient.
+#
+# The -m16 option is supported by GCC >= 4.9 and clang >= 3.5. For
+# older versions of GCC, we need to play evil and unreliable tricks to
+# attempt to ensure that our asm(".code16gcc") is first in the asm
+# output.
+CODE16GCC_CFLAGS := -m32 -include $(srctree)/arch/x86/boot/code16gcc.h \
+		    $(call cc-option, -fno-toplevel-reorder,\
+		      $(call cc-option, -fno-unit-at-a-time))
+M16_CFLAGS	 := $(call cc-option, -m16, $(CODE16GCC_CFLAGS))
+
+REALMODE_CFLAGS	:= $(M16_CFLAGS) -g -Os -D__KERNEL__ \
+		   -DDISABLE_BRANCH_PROFILING \
+		   -Wall -Wstrict-prototypes -march=i386 -mregparm=3 \
+		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
+		   -mno-mmx -mno-sse \
+		   $(call cc-option, -ffreestanding) \
+		   $(call cc-option, -fno-stack-protector) \
+		   $(call cc-option, -mpreferred-stack-boundary=2)
+export REALMODE_CFLAGS
+
 # BITS is used as extension for files which are available in a 32 bit
 # and a 64 bit version to simplify shared Makefiles.
 # e.g.: obj-y += foo_$(BITS).o
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index de7066918005..878df7e88cd4 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -51,20 +51,7 @@ $(obj)/cpustr.h: $(obj)/mkcpustr FORCE
 
 # ---------------------------------------------------------------------------
 
-# How to compile the 16-bit code.  Note we always compile for -march=i386,
-# that way we can complain to the user if the CPU is insufficient.
-KBUILD_CFLAGS	:= $(USERINCLUDE) -m32 -g -Os -D_SETUP -D__KERNEL__ \
-		   -DDISABLE_BRANCH_PROFILING \
-		   -Wall -Wstrict-prototypes \
-		   -march=i386 -mregparm=3 \
-		   -include $(srctree)/$(src)/code16gcc.h \
-		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
-		   -mno-mmx -mno-sse \
-		   $(call cc-option, -ffreestanding) \
-		   $(call cc-option, -fno-toplevel-reorder,\
-		   $(call cc-option, -fno-unit-at-a-time)) \
-		   $(call cc-option, -fno-stack-protector) \
-		   $(call cc-option, -mpreferred-stack-boundary=2)
+KBUILD_CFLAGS	:= $(USERINCLUDE) $(REALMODE_CFLAGS) -D_SETUP
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
 GCOV_PROFILE := n
 
diff --git a/arch/x86/boot/cpuflags.c b/arch/x86/boot/cpuflags.c
index a9fcb7cfb241..431fa5f84537 100644
--- a/arch/x86/boot/cpuflags.c
+++ b/arch/x86/boot/cpuflags.c
@@ -28,20 +28,35 @@ static int has_fpu(void)
 	return fsw == 0 && (fcw & 0x103f) == 0x003f;
 }
 
+/*
+ * For building the 16-bit code we want to explicitly specify 32-bit
+ * push/pop operations, rather than just saying 'pushf' or 'popf' and
+ * letting the compiler choose. But this is also included from the
+ * compressed/ directory where it may be 64-bit code, and thus needs
+ * to be 'pushfq' or 'popfq' in that case.
+ */
+#ifdef __x86_64__
+#define PUSHF "pushfq"
+#define POPF "popfq"
+#else
+#define PUSHF "pushfl"
+#define POPF "popfl"
+#endif
+
 int has_eflag(unsigned long mask)
 {
 	unsigned long f0, f1;
 
-	asm volatile("pushf	\n\t"
-		     "pushf	\n\t"
+	asm volatile(PUSHF "	\n\t"
+		     PUSHF "	\n\t"
 		     "pop %0	\n\t"
 		     "mov %0,%1	\n\t"
 		     "xor %2,%1	\n\t"
 		     "push %1	\n\t"
-		     "popf	\n\t"
-		     "pushf	\n\t"
+		     POPF "	\n\t"
+		     PUSHF "	\n\t"
 		     "pop %1	\n\t"
-		     "popf"
+		     POPF
 		     : "=&r" (f0), "=&r" (f1)
 		     : "ri" (mask));
 
diff --git a/arch/x86/boot/video.h b/arch/x86/boot/video.h
index ff339c5db311..0bb25491262d 100644
--- a/arch/x86/boot/video.h
+++ b/arch/x86/boot/video.h
@@ -80,7 +80,7 @@ struct card_info {
 	u16 xmode_n;		/* Size of unprobed mode range */
 };
 
-#define __videocard struct card_info __attribute__((section(".videocards")))
+#define __videocard struct card_info __attribute__((used,section(".videocards")))
 extern struct card_info video_cards[], video_cards_end[];
 
 int mode_defined(u16 mode);	/* video.c */
diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index 9cac82588cbc..3497f14e4dea 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -64,20 +64,7 @@ $(obj)/realmode.relocs: $(obj)/realmode.elf FORCE
 
 # ---------------------------------------------------------------------------
 
-# How to compile the 16-bit code.  Note we always compile for -march=i386,
-# that way we can complain to the user if the CPU is insufficient.
-KBUILD_CFLAGS	:= $(LINUXINCLUDE) -m32 -g -Os -D_SETUP -D__KERNEL__ -D_WAKEUP \
-		   -I$(srctree)/arch/x86/boot \
-		   -DDISABLE_BRANCH_PROFILING \
-		   -Wall -Wstrict-prototypes \
-		   -march=i386 -mregparm=3 \
-		   -include $(srctree)/$(src)/../../boot/code16gcc.h \
-		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
-		   -mno-mmx -mno-sse \
-		   $(call cc-option, -ffreestanding) \
-		   $(call cc-option, -fno-toplevel-reorder,\
-		   $(call cc-option, -fno-unit-at-a-time)) \
-		   $(call cc-option, -fno-stack-protector) \
-		   $(call cc-option, -mpreferred-stack-boundary=2)
+KBUILD_CFLAGS	:= $(LINUXINCLUDE) $(REALMODE_CFLAGS) -D_SETUP -D_WAKEUP \
+		   -I$(srctree)/arch/x86/boot
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
 GCOV_PROFILE := n
diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index 11f9285a2ff6..cfbdbdb4e173 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -1025,6 +1025,29 @@ static void emit_relocs(int as_text, int use_real_mode)
 	}
 }
 
+/*
+ * As an aid to debugging problems with different linkers
+ * print summary information about the relocs.
+ * Since different linkers tend to emit the sections in
+ * different orders we use the section names in the output.
+ */
+static int do_reloc_info(struct section *sec, Elf_Rel *rel, ElfW(Sym) *sym,
+				const char *symname)
+{
+	printf("%s\t%s\t%s\t%s\n",
+		sec_name(sec->shdr.sh_info),
+		rel_type(ELF_R_TYPE(rel->r_info)),
+		symname,
+		sec_name(sym->st_shndx));
+	return 0;
+}
+
+static void print_reloc_info(void)
+{
+	printf("reloc section\treloc type\tsymbol\tsymbol section\n");
+	walk_relocs(do_reloc_info);
+}
+
 #if ELF_BITS == 64
 # define process process_64
 #else
@@ -1032,7 +1055,8 @@ static void emit_relocs(int as_text, int use_real_mode)
 #endif
 
 void process(FILE *fp, int use_real_mode, int as_text,
-	     int show_absolute_syms, int show_absolute_relocs)
+	     int show_absolute_syms, int show_absolute_relocs,
+	     int show_reloc_info)
 {
 	regex_init(use_real_mode);
 	read_ehdr(fp);
@@ -1050,5 +1074,9 @@ void process(FILE *fp, int use_real_mode, int as_text,
 		print_absolute_relocs();
 		return;
 	}
+	if (show_reloc_info) {
+		print_reloc_info();
+		return;
+	}
 	emit_relocs(as_text, use_real_mode);
 }
diff --git a/arch/x86/tools/relocs.h b/arch/x86/tools/relocs.h
index 07cdb1eca4fa..f59590645b68 100644
--- a/arch/x86/tools/relocs.h
+++ b/arch/x86/tools/relocs.h
@@ -29,8 +29,9 @@ enum symtype {
 };
 
 void process_32(FILE *fp, int use_real_mode, int as_text,
-		int show_absolute_syms, int show_absolute_relocs);
+		int show_absolute_syms, int show_absolute_relocs,
+		int show_reloc_info);
 void process_64(FILE *fp, int use_real_mode, int as_text,
-		int show_absolute_syms, int show_absolute_relocs);
-
+		int show_absolute_syms, int show_absolute_relocs,
+		int show_reloc_info);
 #endif /* RELOCS_H */
diff --git a/arch/x86/tools/relocs_common.c b/arch/x86/tools/relocs_common.c
index 44d396823a53..acab636bcb34 100644
--- a/arch/x86/tools/relocs_common.c
+++ b/arch/x86/tools/relocs_common.c
@@ -11,12 +11,13 @@ void die(char *fmt, ...)
 
 static void usage(void)
 {
-	die("relocs [--abs-syms|--abs-relocs|--text|--realmode] vmlinux\n");
+	die("relocs [--abs-syms|--abs-relocs|--reloc-info|--text|--realmode]" \
+	    " vmlinux\n");
 }
 
 int main(int argc, char **argv)
 {
-	int show_absolute_syms, show_absolute_relocs;
+	int show_absolute_syms, show_absolute_relocs, show_reloc_info;
 	int as_text, use_real_mode;
 	const char *fname;
 	FILE *fp;
@@ -25,6 +26,7 @@ int main(int argc, char **argv)
 
 	show_absolute_syms = 0;
 	show_absolute_relocs = 0;
+	show_reloc_info = 0;
 	as_text = 0;
 	use_real_mode = 0;
 	fname = NULL;
@@ -39,6 +41,10 @@ int main(int argc, char **argv)
 				show_absolute_relocs = 1;
 				continue;
 			}
+			if (strcmp(arg, "--reloc-info") == 0) {
+				show_reloc_info = 1;
+				continue;
+			}
 			if (strcmp(arg, "--text") == 0) {
 				as_text = 1;
 				continue;
@@ -67,10 +73,12 @@ int main(int argc, char **argv)
 	rewind(fp);
 	if (e_ident[EI_CLASS] == ELFCLASS64)
 		process_64(fp, use_real_mode, as_text,
-			   show_absolute_syms, show_absolute_relocs);
+			   show_absolute_syms, show_absolute_relocs,
+			   show_reloc_info);
 	else
 		process_32(fp, use_real_mode, as_text,
-			   show_absolute_syms, show_absolute_relocs);
+			   show_absolute_syms, show_absolute_relocs,
+			   show_reloc_info);
 	fclose(fp);
 	return 0;
 }
