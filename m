Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaFMSVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 14:21:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51319 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaFMSVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 14:21:02 -0400
Date: Fri, 13 Jun 2014 11:20:10 -0700
Message-Id: <201406131820.s5DIKAts006407@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/vdso fixes for v3.16-rc1
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, Stefani Seibold <stefani@seibold.net>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Fixes for x86/vdso.  One is a simple build fix for bigendian hosts,
one is to make "make vdso_install" work again, and the rest is about
working around a bug in Google's Go language -- two are documentation
patches that improves the sample code that the Go coders took,
modified, and broke; the other two implements a workaround that keeps
existing Go binaries from segfaulting at least.

The following changes since commit 5b174fd6472b1d6b6402b30210a212f3fd770d96:

  Merge branch 'for-3.16' of git://linux-nfs.org/~bfields/linux (2014-06-10 11:50:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-vdso-for-linus

The head of this tree is a934fb5bc9cd1260be89272cfb7a6c9dc71974d7:

  x86/vdso: Fix vdso_install (2014-06-13 10:31:48 -0700)

----------------------------------------------------------------
Andy Lutomirski (5):
      x86/vdso/doc: Rename vdso_test.c to vdso_standalone_test_x86.c
      x86/vdso/doc: Make vDSO examples more portable
      x86/vdso: Add PUT_LE to store little-endian values
      x86/vdso: Hack to keep 64-bit Go programs working
      x86/vdso: Fix vdso_install

H. Peter Anvin (1):
      x86, vdso: Remove one final use of htole16()

 Documentation/vDSO/parse_vdso.c                    |  67 +++++++------
 .../{vdso_test.c => vdso_standalone_test_x86.c}    |  47 ++++++---
 Documentation/vDSO/vdso_test.c                     | 107 +++++----------------
 arch/x86/vdso/Makefile                             |  40 ++++----
 arch/x86/vdso/vdso-fakesections.c                  |  32 ++++++
 arch/x86/vdso/vdso2c.c                             |  19 +++-
 arch/x86/vdso/vdso2c.h                             |  23 ++++-
 7 files changed, 183 insertions(+), 152 deletions(-)

diff --git a/Documentation/vDSO/parse_vdso.c b/Documentation/vDSO/parse_vdso.c
index 85870208edcf..1dbb4b87268f 100644
--- a/Documentation/vDSO/parse_vdso.c
+++ b/Documentation/vDSO/parse_vdso.c
@@ -1,6 +1,6 @@
 /*
  * parse_vdso.c: Linux reference vDSO parser
- * Written by Andrew Lutomirski, 2011.
+ * Written by Andrew Lutomirski, 2011-2014.
  *
  * This code is meant to be linked in to various programs that run on Linux.
  * As such, it is available with as few restrictions as possible.  This file
@@ -11,13 +11,14 @@
  * it starts a program.  It works equally well in statically and dynamically
  * linked binaries.
  *
- * This code is tested on x86_64.  In principle it should work on any 64-bit
+ * This code is tested on x86.  In principle it should work on any
  * architecture that has a vDSO.
  */
 
 #include <stdbool.h>
 #include <stdint.h>
 #include <string.h>
+#include <limits.h>
 #include <elf.h>
 
 /*
@@ -45,11 +46,18 @@ extern void *vdso_sym(const char *version, const char *name);
 
 
 /* And here's the code. */
-
-#ifndef __x86_64__
-# error Not yet ported to non-x86_64 architectures
+#ifndef ELF_BITS
+# if ULONG_MAX > 0xffffffffUL
+#  define ELF_BITS 64
+# else
+#  define ELF_BITS 32
+# endif
 #endif
 
+#define ELF_BITS_XFORM2(bits, x) Elf##bits##_##x
+#define ELF_BITS_XFORM(bits, x) ELF_BITS_XFORM2(bits, x)
+#define ELF(x) ELF_BITS_XFORM(ELF_BITS, x)
+
 static struct vdso_info
 {
 	bool valid;
@@ -59,14 +67,14 @@ static struct vdso_info
 	uintptr_t load_offset;  /* load_addr - recorded vaddr */
 
 	/* Symbol table */
-	Elf64_Sym *symtab;
+	ELF(Sym) *symtab;
 	const char *symstrings;
-	Elf64_Word *bucket, *chain;
-	Elf64_Word nbucket, nchain;
+	ELF(Word) *bucket, *chain;
+	ELF(Word) nbucket, nchain;
 
 	/* Version table */
-	Elf64_Versym *versym;
-	Elf64_Verdef *verdef;
+	ELF(Versym) *versym;
+	ELF(Verdef) *verdef;
 } vdso_info;
 
 /* Straight from the ELF specification. */
@@ -92,9 +100,14 @@ void vdso_init_from_sysinfo_ehdr(uintptr_t base)
 
 	vdso_info.load_addr = base;
 
-	Elf64_Ehdr *hdr = (Elf64_Ehdr*)base;
-	Elf64_Phdr *pt = (Elf64_Phdr*)(vdso_info.load_addr + hdr->e_phoff);
-	Elf64_Dyn *dyn = 0;
+	ELF(Ehdr) *hdr = (ELF(Ehdr)*)base;
+	if (hdr->e_ident[EI_CLASS] !=
+	    (ELF_BITS == 32 ? ELFCLASS32 : ELFCLASS64)) {
+		return;  /* Wrong ELF class -- check ELF_BITS */
+	}
+
+	ELF(Phdr) *pt = (ELF(Phdr)*)(vdso_info.load_addr + hdr->e_phoff);
+	ELF(Dyn) *dyn = 0;
 
 	/*
 	 * We need two things from the segment table: the load offset
@@ -108,7 +121,7 @@ void vdso_init_from_sysinfo_ehdr(uintptr_t base)
 				+ (uintptr_t)pt[i].p_offset
 				- (uintptr_t)pt[i].p_vaddr;
 		} else if (pt[i].p_type == PT_DYNAMIC) {
-			dyn = (Elf64_Dyn*)(base + pt[i].p_offset);
+			dyn = (ELF(Dyn)*)(base + pt[i].p_offset);
 		}
 	}
 
@@ -118,7 +131,7 @@ void vdso_init_from_sysinfo_ehdr(uintptr_t base)
 	/*
 	 * Fish out the useful bits of the dynamic table.
 	 */
-	Elf64_Word *hash = 0;
+	ELF(Word) *hash = 0;
 	vdso_info.symstrings = 0;
 	vdso_info.symtab = 0;
 	vdso_info.versym = 0;
@@ -131,22 +144,22 @@ void vdso_init_from_sysinfo_ehdr(uintptr_t base)
 				 + vdso_info.load_offset);
 			break;
 		case DT_SYMTAB:
-			vdso_info.symtab = (Elf64_Sym *)
+			vdso_info.symtab = (ELF(Sym) *)
 				((uintptr_t)dyn[i].d_un.d_ptr
 				 + vdso_info.load_offset);
 			break;
 		case DT_HASH:
-			hash = (Elf64_Word *)
+			hash = (ELF(Word) *)
 				((uintptr_t)dyn[i].d_un.d_ptr
 				 + vdso_info.load_offset);
 			break;
 		case DT_VERSYM:
-			vdso_info.versym = (Elf64_Versym *)
+			vdso_info.versym = (ELF(Versym) *)
 				((uintptr_t)dyn[i].d_un.d_ptr
 				 + vdso_info.load_offset);
 			break;
 		case DT_VERDEF:
-			vdso_info.verdef = (Elf64_Verdef *)
+			vdso_info.verdef = (ELF(Verdef) *)
 				((uintptr_t)dyn[i].d_un.d_ptr
 				 + vdso_info.load_offset);
 			break;
@@ -168,8 +181,8 @@ void vdso_init_from_sysinfo_ehdr(uintptr_t base)
 	vdso_info.valid = true;
 }
 
-static bool vdso_match_version(Elf64_Versym ver,
-			       const char *name, Elf64_Word hash)
+static bool vdso_match_version(ELF(Versym) ver,
+			       const char *name, ELF(Word) hash)
 {
 	/*
 	 * This is a helper function to check if the version indexed by
@@ -188,7 +201,7 @@ static bool vdso_match_version(Elf64_Versym ver,
 
 	/* First step: find the version definition */
 	ver &= 0x7fff;  /* Apparently bit 15 means "hidden" */
-	Elf64_Verdef *def = vdso_info.verdef;
+	ELF(Verdef) *def = vdso_info.verdef;
 	while(true) {
 		if ((def->vd_flags & VER_FLG_BASE) == 0
 		    && (def->vd_ndx & 0x7fff) == ver)
@@ -197,11 +210,11 @@ static bool vdso_match_version(Elf64_Versym ver,
 		if (def->vd_next == 0)
 			return false;  /* No definition. */
 
-		def = (Elf64_Verdef *)((char *)def + def->vd_next);
+		def = (ELF(Verdef) *)((char *)def + def->vd_next);
 	}
 
 	/* Now figure out whether it matches. */
-	Elf64_Verdaux *aux = (Elf64_Verdaux*)((char *)def + def->vd_aux);
+	ELF(Verdaux) *aux = (ELF(Verdaux)*)((char *)def + def->vd_aux);
 	return def->vd_hash == hash
 		&& !strcmp(name, vdso_info.symstrings + aux->vda_name);
 }
@@ -213,10 +226,10 @@ void *vdso_sym(const char *version, const char *name)
 		return 0;
 
 	ver_hash = elf_hash(version);
-	Elf64_Word chain = vdso_info.bucket[elf_hash(name) % vdso_info.nbucket];
+	ELF(Word) chain = vdso_info.bucket[elf_hash(name) % vdso_info.nbucket];
 
 	for (; chain != STN_UNDEF; chain = vdso_info.chain[chain]) {
-		Elf64_Sym *sym = &vdso_info.symtab[chain];
+		ELF(Sym) *sym = &vdso_info.symtab[chain];
 
 		/* Check for a defined global or weak function w/ right name. */
 		if (ELF64_ST_TYPE(sym->st_info) != STT_FUNC)
@@ -243,7 +256,7 @@ void *vdso_sym(const char *version, const char *name)
 
 void vdso_init_from_auxv(void *auxv)
 {
-	Elf64_auxv_t *elf_auxv = auxv;
+	ELF(auxv_t) *elf_auxv = auxv;
 	for (int i = 0; elf_auxv[i].a_type != AT_NULL; i++)
 	{
 		if (elf_auxv[i].a_type == AT_SYSINFO_EHDR) {
diff --git a/Documentation/vDSO/vdso_standalone_test_x86.c b/Documentation/vDSO/vdso_standalone_test_x86.c
new file mode 100644
index 000000000000..d46240265c50
--- /dev/null
+++ b/Documentation/vDSO/vdso_standalone_test_x86.c
@@ -0,0 +1,128 @@
+/*
+ * vdso_test.c: Sample code to test parse_vdso.c on x86
+ * Copyright (c) 2011-2014 Andy Lutomirski
+ * Subject to the GNU General Public License, version 2
+ *
+ * You can amuse yourself by compiling with:
+ * gcc -std=gnu99 -nostdlib
+ *     -Os -fno-asynchronous-unwind-tables -flto -lgcc_s
+ *      vdso_standalone_test_x86.c parse_vdso.c
+ * to generate a small binary.  On x86_64, you can omit -lgcc_s
+ * if you want the binary to be completely standalone.
+ */
+
+#include <sys/syscall.h>
+#include <sys/time.h>
+#include <unistd.h>
+#include <stdint.h>
+
+extern void *vdso_sym(const char *version, const char *name);
+extern void vdso_init_from_sysinfo_ehdr(uintptr_t base);
+extern void vdso_init_from_auxv(void *auxv);
+
+/* We need a libc functions... */
+int strcmp(const char *a, const char *b)
+{
+	/* This implementation is buggy: it never returns -1. */
+	while (*a || *b) {
+		if (*a != *b)
+			return 1;
+		if (*a == 0 || *b == 0)
+			return 1;
+		a++;
+		b++;
+	}
+
+	return 0;
+}
+
+/* ...and two syscalls.  This is x86-specific. */
+static inline long x86_syscall3(long nr, long a0, long a1, long a2)
+{
+	long ret;
+#ifdef __x86_64__
+	asm volatile ("syscall" : "=a" (ret) : "a" (nr),
+		      "D" (a0), "S" (a1), "d" (a2) :
+		      "cc", "memory", "rcx",
+		      "r8", "r9", "r10", "r11" );
+#else
+	asm volatile ("int $0x80" : "=a" (ret) : "a" (nr),
+		      "b" (a0), "c" (a1), "d" (a2) :
+		      "cc", "memory" );
+#endif
+	return ret;
+}
+
+static inline long linux_write(int fd, const void *data, size_t len)
+{
+	return x86_syscall3(__NR_write, fd, (long)data, (long)len);
+}
+
+static inline void linux_exit(int code)
+{
+	x86_syscall3(__NR_exit, code, 0, 0);
+}
+
+void to_base10(char *lastdig, uint64_t n)
+{
+	while (n) {
+		*lastdig = (n % 10) + '0';
+		n /= 10;
+		lastdig--;
+	}
+}
+
+__attribute__((externally_visible)) void c_main(void **stack)
+{
+	/* Parse the stack */
+	long argc = (long)*stack;
+	stack += argc + 2;
+
+	/* Now we're pointing at the environment.  Skip it. */
+	while(*stack)
+		stack++;
+	stack++;
+
+	/* Now we're pointing at auxv.  Initialize the vDSO parser. */
+	vdso_init_from_auxv((void *)stack);
+
+	/* Find gettimeofday. */
+	typedef long (*gtod_t)(struct timeval *tv, struct timezone *tz);
+	gtod_t gtod = (gtod_t)vdso_sym("LINUX_2.6", "__vdso_gettimeofday");
+
+	if (!gtod)
+		linux_exit(1);
+
+	struct timeval tv;
+	long ret = gtod(&tv, 0);
+
+	if (ret == 0) {
+		char buf[] = "The time is                     .000000\n";
+		to_base10(buf + 31, tv.tv_sec);
+		to_base10(buf + 38, tv.tv_usec);
+		linux_write(1, buf, sizeof(buf) - 1);
+	} else {
+		linux_exit(ret);
+	}
+
+	linux_exit(0);
+}
+
+/*
+ * This is the real entry point.  It passes the initial stack into
+ * the C entry point.
+ */
+asm (
+	".text\n"
+	".global _start\n"
+	".type _start,@function\n"
+	"_start:\n\t"
+#ifdef __x86_64__
+	"mov %rsp,%rdi\n\t"
+	"jmp c_main"
+#else
+	"push %esp\n\t"
+	"call c_main\n\t"
+	"int $3"
+#endif
+	);
diff --git a/Documentation/vDSO/vdso_test.c b/Documentation/vDSO/vdso_test.c
index fff633432dff..8daeb7d7032c 100644
--- a/Documentation/vDSO/vdso_test.c
+++ b/Documentation/vDSO/vdso_test.c
@@ -1,111 +1,52 @@
 /*
- * vdso_test.c: Sample code to test parse_vdso.c on x86_64
- * Copyright (c) 2011 Andy Lutomirski
+ * vdso_test.c: Sample code to test parse_vdso.c
+ * Copyright (c) 2014 Andy Lutomirski
  * Subject to the GNU General Public License, version 2
  *
- * You can amuse yourself by compiling with:
- * gcc -std=gnu99 -nostdlib
- *     -Os -fno-asynchronous-unwind-tables -flto
- *      vdso_test.c parse_vdso.c -o vdso_test
- * to generate a small binary with no dependencies at all.
+ * Compile with:
+ * gcc -std=gnu99 vdso_test.c parse_vdso.c
+ *
+ * Tested on x86, 32-bit and 64-bit.  It may work on other architectures, too.
  */
 
-#include <sys/syscall.h>
-#include <sys/time.h>
-#include <unistd.h>
 #include <stdint.h>
+#include <elf.h>
+#include <stdio.h>
+#include <sys/auxv.h>
+#include <sys/time.h>
 
 extern void *vdso_sym(const char *version, const char *name);
 extern void vdso_init_from_sysinfo_ehdr(uintptr_t base);
 extern void vdso_init_from_auxv(void *auxv);
 
-/* We need a libc functions... */
-int strcmp(const char *a, const char *b)
+int main(int argc, char **argv)
 {
-	/* This implementation is buggy: it never returns -1. */
-	while (*a || *b) {
-		if (*a != *b)
-			return 1;
-		if (*a == 0 || *b == 0)
-			return 1;
-		a++;
-		b++;
+	unsigned long sysinfo_ehdr = getauxval(AT_SYSINFO_EHDR);
+	if (!sysinfo_ehdr) {
+		printf("AT_SYSINFO_EHDR is not present!\n");
+		return 0;
 	}
 
-	return 0;
-}
-
-/* ...and two syscalls.  This is x86_64-specific. */
-static inline long linux_write(int fd, const void *data, size_t len)
-{
-
-	long ret;
-	asm volatile ("syscall" : "=a" (ret) : "a" (__NR_write),
-		      "D" (fd), "S" (data), "d" (len) :
-		      "cc", "memory", "rcx",
-		      "r8", "r9", "r10", "r11" );
-	return ret;
-}
-
-static inline void linux_exit(int code)
-{
-	asm volatile ("syscall" : : "a" (__NR_exit), "D" (code));
-}
-
-void to_base10(char *lastdig, uint64_t n)
-{
-	while (n) {
-		*lastdig = (n % 10) + '0';
-		n /= 10;
-		lastdig--;
-	}
-}
-
-__attribute__((externally_visible)) void c_main(void **stack)
-{
-	/* Parse the stack */
-	long argc = (long)*stack;
-	stack += argc + 2;
-
-	/* Now we're pointing at the environment.  Skip it. */
-	while(*stack)
-		stack++;
-	stack++;
-
-	/* Now we're pointing at auxv.  Initialize the vDSO parser. */
-	vdso_init_from_auxv((void *)stack);
+	vdso_init_from_sysinfo_ehdr(getauxval(AT_SYSINFO_EHDR));
 
 	/* Find gettimeofday. */
 	typedef long (*gtod_t)(struct timeval *tv, struct timezone *tz);
 	gtod_t gtod = (gtod_t)vdso_sym("LINUX_2.6", "__vdso_gettimeofday");
 
-	if (!gtod)
-		linux_exit(1);
+	if (!gtod) {
+		printf("Could not find __vdso_gettimeofday\n");
+		return 1;
+	}
 
 	struct timeval tv;
 	long ret = gtod(&tv, 0);
 
 	if (ret == 0) {
-		char buf[] = "The time is                     .000000\n";
-		to_base10(buf + 31, tv.tv_sec);
-		to_base10(buf + 38, tv.tv_usec);
-		linux_write(1, buf, sizeof(buf) - 1);
+		printf("The time is %lld.%06lld\n",
+		       (long long)tv.tv_sec, (long long)tv.tv_usec);
 	} else {
-		linux_exit(ret);
+		printf("__vdso_gettimeofday failed\n");
 	}
 
-	linux_exit(0);
+	return 0;
 }
-
-/*
- * This is the real entry point.  It passes the initial stack into
- * the C entry point.
- */
-asm (
-	".text\n"
-	".global _start\n"
-        ".type _start,@function\n"
-        "_start:\n\t"
-        "mov %rsp,%rdi\n\t"
-        "jmp c_main"
-	);
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 9769df094035..3c0809a0631f 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -9,18 +9,9 @@ VDSOX32-$(CONFIG_X86_X32_ABI)	:= y
 VDSO32-$(CONFIG_X86_32)		:= y
 VDSO32-$(CONFIG_COMPAT)		:= y
 
-vdso-install-$(VDSO64-y)	+= vdso.so
-vdso-install-$(VDSOX32-y)	+= vdsox32.so
-vdso-install-$(VDSO32-y)	+= $(vdso32-images)
-
-
 # files to link into the vdso
-vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o
-
-vobjs-$(VDSOX32-y) += $(vobjx32s-compat)
-
-# Filter out x32 objects.
-vobj64s := $(filter-out $(vobjx32s-compat),$(vobjs-y))
+vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o vdso-fakesections.o
+vobjs-nox32 := vdso-fakesections.o
 
 # files to link into kernel
 obj-y				+= vma.o
@@ -34,7 +25,7 @@ vdso_img-$(VDSO32-y)		+= 32-sysenter
 
 obj-$(VDSO32-y)			+= vdso32-setup.o
 
-vobjs := $(foreach F,$(vobj64s),$(obj)/$F)
+vobjs := $(foreach F,$(vobjs-y),$(obj)/$F)
 
 $(obj)/vdso.o: $(obj)/vdso.so
 
@@ -104,7 +95,13 @@ VDSO_LDFLAGS_vdsox32.lds = -Wl,-m,elf32_x86_64 \
 			   -Wl,-z,max-page-size=4096 \
 			   -Wl,-z,common-page-size=4096
 
-vobjx32s-y := $(vobj64s:.o=-x32.o)
+# 64-bit objects to re-brand as x32
+vobjs64-for-x32 := $(filter-out $(vobjs-nox32),$(vobjs-y))
+
+# x32-rebranded versions
+vobjx32s-y := $(vobjs64-for-x32:.o=-x32.o)
+
+# same thing, but in the output directory
 vobjx32s := $(foreach F,$(vobjx32s-y),$(obj)/$F)
 
 # Convert 64bit object file to x32 for x32 vDSO.
@@ -176,15 +173,20 @@ VDSO_LDFLAGS = -fPIC -shared $(call cc-ldoption, -Wl$(comma)--hash-style=sysv) \
 GCOV_PROFILE := n
 
 #
-# Install the unstripped copy of vdso*.so listed in $(vdso-install-y).
+# Install the unstripped copies of vdso*.so.
 #
-quiet_cmd_vdso_install = INSTALL $@
-      cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
-$(vdso-install-y): %.so: $(obj)/%.so.dbg FORCE
+quiet_cmd_vdso_install = INSTALL $(@:install_%=%)
+      cmd_vdso_install = cp $< $(MODLIB)/vdso/$(@:install_%=%)
+
+vdso_img_insttargets := $(vdso_img_sodbg:%.dbg=install_%)
+
+$(MODLIB)/vdso: FORCE
 	@mkdir -p $(MODLIB)/vdso
+
+$(vdso_img_insttargets): install_%: $(obj)/%.dbg $(MODLIB)/vdso FORCE
 	$(call cmd,vdso_install)
 
-PHONY += vdso_install $(vdso-install-y)
-vdso_install: $(vdso-install-y)
+PHONY += vdso_install $(vdso_img_insttargets)
+vdso_install: $(vdso_img_insttargets) FORCE
 
 clean-files := vdso32-syscall* vdso32-sysenter* vdso32-int80*
diff --git a/arch/x86/vdso/vdso-fakesections.c b/arch/x86/vdso/vdso-fakesections.c
new file mode 100644
index 000000000000..cb8a8d72c24b
--- /dev/null
+++ b/arch/x86/vdso/vdso-fakesections.c
@@ -0,0 +1,32 @@
+/*
+ * Copyright 2014 Andy Lutomirski
+ * Subject to the GNU Public License, v.2
+ *
+ * Hack to keep broken Go programs working.
+ *
+ * The Go runtime had a couple of bugs: it would read the section table to try
+ * to figure out how many dynamic symbols there were (it shouldn't have looked
+ * at the section table at all) and, if there were no SHT_SYNDYM section table
+ * entry, it would use an uninitialized value for the number of symbols.  As a
+ * workaround, we supply a minimal section table.  vdso2c will adjust the
+ * in-memory image so that "vdso_fake_sections" becomes the section table.
+ *
+ * The bug was introduced by:
+ * https://code.google.com/p/go/source/detail?r=56ea40aac72b (2012-08-31)
+ * and is being addressed in the Go runtime in this issue:
+ * https://code.google.com/p/go/issues/detail?id=8197
+ */
+
+#ifndef __x86_64__
+#error This hack is specific to the 64-bit vDSO
+#endif
+
+#include <linux/elf.h>
+
+extern const __visible struct elf64_shdr vdso_fake_sections[];
+const __visible struct elf64_shdr vdso_fake_sections[] = {
+	{
+		.sh_type = SHT_DYNSYM,
+		.sh_entsize = sizeof(Elf64_Sym),
+	}
+};
diff --git a/arch/x86/vdso/vdso2c.c b/arch/x86/vdso/vdso2c.c
index 450ac6eaf613..7a6bf50f9165 100644
--- a/arch/x86/vdso/vdso2c.c
+++ b/arch/x86/vdso/vdso2c.c
@@ -54,7 +54,7 @@ static void fail(const char *format, ...)
 }
 
 /*
- * Evil macros to do a little-endian read.
+ * Evil macros for little-endian reads and writes
  */
 #define GLE(x, bits, ifnot)						\
 	__builtin_choose_expr(						\
@@ -62,11 +62,24 @@ static void fail(const char *format, ...)
 		(__typeof__(*(x)))get_unaligned_le##bits(x), ifnot)
 
 extern void bad_get_le(void);
-#define LAST_LE(x)							\
+#define LAST_GLE(x)							\
 	__builtin_choose_expr(sizeof(*(x)) == 1, *(x), bad_get_le())
 
 #define GET_LE(x)							\
-	GLE(x, 64, GLE(x, 32, GLE(x, 16, LAST_LE(x))))
+	GLE(x, 64, GLE(x, 32, GLE(x, 16, LAST_GLE(x))))
+
+#define PLE(x, val, bits, ifnot)					\
+	__builtin_choose_expr(						\
+		(sizeof(*(x)) == bits/8),				\
+		put_unaligned_le##bits((val), (x)), ifnot)
+
+extern void bad_put_le(void);
+#define LAST_PLE(x, val)						\
+	__builtin_choose_expr(sizeof(*(x)) == 1, *(x) = (val), bad_put_le())
+
+#define PUT_LE(x, val)					\
+	PLE(x, val, 64, PLE(x, val, 32, PLE(x, val, 16, LAST_PLE(x, val))))
+
 
 #define NSYMS (sizeof(required_syms) / sizeof(required_syms[0]))
 
diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index 8a074637a576..c6eefaf389b9 100644
--- a/arch/x86/vdso/vdso2c.h
+++ b/arch/x86/vdso/vdso2c.h
@@ -18,6 +18,8 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 	const char *secstrings;
 	uint64_t syms[NSYMS] = {};
 
+	uint64_t fake_sections_value = 0, fake_sections_size = 0;
+
 	Elf_Phdr *pt = (Elf_Phdr *)(addr + GET_LE(&hdr->e_phoff));
 
 	/* Walk the segment table. */
@@ -84,6 +86,7 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 			GET_LE(&symtab_hdr->sh_entsize) * i;
 		const char *name = addr + GET_LE(&strtab_hdr->sh_offset) +
 			GET_LE(&sym->st_name);
+
 		for (k = 0; k < NSYMS; k++) {
 			if (!strcmp(name, required_syms[k])) {
 				if (syms[k]) {
@@ -93,6 +96,13 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 				syms[k] = GET_LE(&sym->st_value);
 			}
 		}
+
+		if (!strcmp(name, "vdso_fake_sections")) {
+			if (fake_sections_value)
+				fail("duplicate vdso_fake_sections\n");
+			fake_sections_value = GET_LE(&sym->st_value);
+			fake_sections_size = GET_LE(&sym->st_size);
+		}
 	}
 
 	/* Validate mapping addresses. */
@@ -112,11 +122,14 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 	if (syms[sym_end_mapping] % 4096)
 		fail("end_mapping must be a multiple of 4096\n");
 
-	/* Remove sections. */
-	hdr->e_shoff = 0;
-	hdr->e_shentsize = 0;
-	hdr->e_shnum = 0;
-	hdr->e_shstrndx = htole16(SHN_UNDEF);
+	/* Remove sections or use fakes */
+	if (fake_sections_size % sizeof(Elf_Shdr))
+		fail("vdso_fake_sections size is not a multiple of %ld\n",
+		     (long)sizeof(Elf_Shdr));
+	PUT_LE(&hdr->e_shoff, fake_sections_value);
+	PUT_LE(&hdr->e_shentsize, fake_sections_value ? sizeof(Elf_Shdr) : 0);
+	PUT_LE(&hdr->e_shnum, fake_sections_size / sizeof(Elf_Shdr));
+	PUT_LE(&hdr->e_shstrndx, SHN_UNDEF);
 
 	if (!name) {
 		fwrite(addr, load_size, 1, outfile);
