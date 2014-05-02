Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbaEBUQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 16:16:08 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:61909 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbaEBUP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 16:15:59 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 3/6] x86: Reimplement vdso.so preparation in build-time C
Date: Fri,  2 May 2014 13:15:45 -0700
Message-Id: <1b548d2de5c311a006231e5111d8e53f039e67b9.1399061075.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1399061075.git.luto@amacapital.net>
References: <cover.1399061075.git.luto@amacapital.net>
In-Reply-To: <cover.1399061075.git.luto@amacapital.net>
References: <cover.1399061075.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, vdso.so files are prepared and analyzed by a combination
of objcopy, nm, some linker script tricks, and some simple ELF
parsers in the kernel.  Replace all of that with plain C code that
runs at build time.

All five vdso images now generate .c files that are compiled and
linked in to the kernel image.

This should cause only one userspace-visible change: the loaded vDSO
images are stripped more heavily than they used to be.  Everything
outside the loadable segment is dropped.  In particular, this causes
the section table and section name strings to be missing.  This
should be fine: real dynamic loaders don't load or inspect these
tables anyway.  The result is roughly equivalent to eu-strip's
--strip-sections option.

The purpose of this change is to enable the vvar and hpet mappings
to be moved to the page following the vDSO load segment.  Currently,
it is possible for the section table to extend into the page after
the load segment, so, if we map it, it risks overlapping the vvar or
hpet page.  This happens whenever the load segment is just under a
multiple of PAGE_SIZE.

The only real subtlety here is that the old code had a C file with
inline assembler that did 'call VDSO32_vsyscall' and a linker script
that defined 'VDSO32_vsyscall = __kernel_vsyscall'.  This most
likely worked by accident: the linker script entry defines a symbol
associated with an address as opposed to an alias for the real
dynamic symbol __kernel_vsyscall.  That caused ld to relocate the
reference at link time instead of leaving an interposable dynamic
relocation.  Since the VDSO32_vsyscall hack is no longer needed, I
now use 'call __kernel_vsyscall', and I added -Bsymbolic to make it
work.  vdso2c will generate an error and abort the build if the
resulting image contains any dynamic relocations, so we won't
silently generate bad vdso images.

(Dynamic relocations are a problem because nothing will even attempt
to relocate the vdso.)

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/ia32/ia32_signal.c       |   8 +--
 arch/x86/include/asm/elf.h        |   7 +-
 arch/x86/include/asm/mmu.h        |   2 +-
 arch/x86/include/asm/vdso.h       |  70 +++++++------------
 arch/x86/kernel/signal.c          |   6 +-
 arch/x86/mm/init_64.c             |   3 +-
 arch/x86/vdso/.gitignore          |   5 +-
 arch/x86/vdso/Makefile            |  90 +++++++++---------------
 arch/x86/vdso/vclock_gettime.c    |   4 +-
 arch/x86/vdso/vdso.S              |   3 -
 arch/x86/vdso/vdso2c.c            | 142 ++++++++++++++++++++++++++++++++++++++
 arch/x86/vdso/vdso2c.h            | 137 ++++++++++++++++++++++++++++++++++++
 arch/x86/vdso/vdso32-setup.c      |  50 ++++++--------
 arch/x86/vdso/vdso32.S            |   9 ---
 arch/x86/vdso/vdso32/vdso32.lds.S |  10 ---
 arch/x86/vdso/vdsox32.S           |   3 -
 arch/x86/vdso/vma.c               | 100 +++++----------------------
 arch/x86/xen/setup.c              |  11 ++-
 18 files changed, 400 insertions(+), 260 deletions(-)
 delete mode 100644 arch/x86/vdso/vdso.S
 create mode 100644 arch/x86/vdso/vdso2c.c
 create mode 100644 arch/x86/vdso/vdso2c.h
 delete mode 100644 arch/x86/vdso/vdso32.S
 delete mode 100644 arch/x86/vdso/vdsox32.S

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 2206757..f9e181a 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -383,8 +383,8 @@ int ia32_setup_frame(int sig, struct ksignal *ksig,
 	} else {
 		/* Return stub is in 32bit vsyscall page */
 		if (current->mm->context.vdso)
-			restorer = VDSO32_SYMBOL(current->mm->context.vdso,
-						 sigreturn);
+			restorer = current->mm->context.vdso +
+				selected_vdso32->sym___kernel_sigreturn;
 		else
 			restorer = &frame->retcode;
 	}
@@ -462,8 +462,8 @@ int ia32_setup_rt_frame(int sig, struct ksignal *ksig,
 		if (ksig->ka.sa.sa_flags & SA_RESTORER)
 			restorer = ksig->ka.sa.sa_restorer;
 		else
-			restorer = VDSO32_SYMBOL(current->mm->context.vdso,
-						 rt_sigreturn);
+			restorer = current->mm->context.vdso +
+				selected_vdso32->sym___kernel_rt_sigreturn;
 		put_user_ex(ptr_to_compat(restorer), &frame->pretcode);
 
 		/*
diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index e96df2c..65b21bc 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -299,7 +299,7 @@ do {									\
 do {									\
 	if (vdso64_enabled)						\
 		NEW_AUX_ENT(AT_SYSINFO_EHDR,				\
-			    (unsigned long)current->mm->context.vdso);	\
+			    (unsigned long __force)current->mm->context.vdso); \
 } while (0)
 
 /* As a historical oddity, the x32 and x86_64 vDSOs are controlled together. */
@@ -307,7 +307,7 @@ do {									\
 do {									\
 	if (vdso64_enabled)						\
 		NEW_AUX_ENT(AT_SYSINFO_EHDR,				\
-			    (unsigned long)current->mm->context.vdso);	\
+			    (unsigned long __force)current->mm->context.vdso); \
 } while (0)
 
 #define AT_SYSINFO		32
@@ -325,7 +325,8 @@ else									\
 #define VDSO_CURRENT_BASE	((unsigned long)current->mm->context.vdso)
 
 #define VDSO_ENTRY							\
-	((unsigned long)VDSO32_SYMBOL(VDSO_CURRENT_BASE, vsyscall))
+	((unsigned long)current->mm->context.vdso +			\
+	 selected_vdso32->sym___kernel_vsyscall)
 
 struct linux_binprm;
 
diff --git a/arch/x86/include/asm/mmu.h b/arch/x86/include/asm/mmu.h
index 5f55e69..876e74e 100644
--- a/arch/x86/include/asm/mmu.h
+++ b/arch/x86/include/asm/mmu.h
@@ -18,7 +18,7 @@ typedef struct {
 #endif
 
 	struct mutex lock;
-	void *vdso;
+	void __user *vdso;
 } mm_context_t;
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index d1dc554..389fe2c 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -3,63 +3,43 @@
 
 #include <asm/page_types.h>
 #include <linux/linkage.h>
+#include <linux/init.h>
 
-#ifdef __ASSEMBLER__
+#ifndef __ASSEMBLER__
 
-#define DEFINE_VDSO_IMAGE(symname, filename)				\
-__PAGE_ALIGNED_DATA ;							\
-	.globl symname##_start, symname##_end ;				\
-	.align PAGE_SIZE ;						\
-	symname##_start: ;						\
-	.incbin filename ;						\
-	symname##_end: ;						\
-	.align PAGE_SIZE /* extra data here leaks to userspace. */ ;	\
-									\
-.previous ;								\
-									\
-	.globl symname##_pages ;					\
-	.bss ;								\
-	.align 8 ;							\
-	.type symname##_pages, @object ;				\
-	symname##_pages: ;						\
-	.zero (symname##_end - symname##_start + PAGE_SIZE - 1) / PAGE_SIZE * (BITS_PER_LONG / 8) ; \
-	.size symname##_pages, .-symname##_pages
+struct vdso_image {
+	void *data;
+	unsigned long size;   /* Always a multiple of PAGE_SIZE */
+	struct page **pages;  /* Big enough for data/size page pointers */
 
-#else
+	unsigned long alt, alt_len;
 
-#define DECLARE_VDSO_IMAGE(symname)				\
-	extern char symname##_start[], symname##_end[];		\
-	extern struct page *symname##_pages[]
+	unsigned long sym_VDSO32_NOTE_MASK;
+	unsigned long sym___kernel_sigreturn;
+	unsigned long sym___kernel_rt_sigreturn;
+	unsigned long sym___kernel_vsyscall;
+	unsigned long sym_VDSO32_SYSENTER_RETURN;
+};
 
-#if defined CONFIG_X86_32 || defined CONFIG_COMPAT
+#ifdef CONFIG_X86_64
+extern const struct vdso_image vdso_image_64;
+#endif
 
-#include <asm/vdso32.h>
+#ifdef CONFIG_X86_X32
+extern const struct vdso_image vdso_image_x32;
+#endif
 
-DECLARE_VDSO_IMAGE(vdso32_int80);
+#if defined CONFIG_X86_32 || defined CONFIG_COMPAT
+extern const struct vdso_image vdso_image_32_int80;
 #ifdef CONFIG_COMPAT
-DECLARE_VDSO_IMAGE(vdso32_syscall);
+extern const struct vdso_image vdso_image_32_syscall;
 #endif
-DECLARE_VDSO_IMAGE(vdso32_sysenter);
+extern const struct vdso_image vdso_image_32_sysenter;
 
-/*
- * Given a pointer to the vDSO image, find the pointer to VDSO32_name
- * as that symbol is defined in the vDSO sources or linker script.
- */
-#define VDSO32_SYMBOL(base, name)					\
-({									\
-	extern const char VDSO32_##name[];				\
-	(void __user *)(VDSO32_##name + (unsigned long)(base));		\
-})
+extern const struct vdso_image *selected_vdso32;
 #endif
 
-/*
- * These symbols are defined with the addresses in the vsyscall page.
- * See vsyscall-sigreturn.S.
- */
-extern void __user __kernel_sigreturn;
-extern void __user __kernel_rt_sigreturn;
-
-void __init patch_vdso32(void *vdso, size_t len);
+extern void __init init_vdso_image(const struct vdso_image *image);
 
 #endif /* __ASSEMBLER__ */
 
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 9e5de68..a0da58d 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -298,7 +298,8 @@ __setup_frame(int sig, struct ksignal *ksig, sigset_t *set,
 	}
 
 	if (current->mm->context.vdso)
-		restorer = VDSO32_SYMBOL(current->mm->context.vdso, sigreturn);
+		restorer = current->mm->context.vdso +
+			selected_vdso32->sym___kernel_sigreturn;
 	else
 		restorer = &frame->retcode;
 	if (ksig->ka.sa.sa_flags & SA_RESTORER)
@@ -361,7 +362,8 @@ static int __setup_rt_frame(int sig, struct ksignal *ksig,
 		save_altstack_ex(&frame->uc.uc_stack, regs->sp);
 
 		/* Set up to return from userspace.  */
-		restorer = VDSO32_SYMBOL(current->mm->context.vdso, rt_sigreturn);
+		restorer = current->mm->context.vdso +
+			selected_vdso32->sym___kernel_sigreturn;
 		if (ksig->ka.sa.sa_flags & SA_RESTORER)
 			restorer = ksig->ka.sa.sa_restorer;
 		put_user_ex(restorer, &frame->pretcode);
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index f35c66c..5638496 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1223,7 +1223,8 @@ int in_gate_area_no_mm(unsigned long addr)
 
 const char *arch_vma_name(struct vm_area_struct *vma)
 {
-	if (vma->vm_mm && vma->vm_start == (long)vma->vm_mm->context.vdso)
+	if (vma->vm_mm && vma->vm_start ==
+	    (long __force)vma->vm_mm->context.vdso)
 		return "[vdso]";
 	if (vma == &gate_vma)
 		return "[vsyscall]";
diff --git a/arch/x86/vdso/.gitignore b/arch/x86/vdso/.gitignore
index 3282874..aae8ffd 100644
--- a/arch/x86/vdso/.gitignore
+++ b/arch/x86/vdso/.gitignore
@@ -1,8 +1,7 @@
 vdso.lds
-vdso-syms.lds
 vdsox32.lds
-vdsox32-syms.lds
-vdso32-syms.lds
 vdso32-syscall-syms.lds
 vdso32-sysenter-syms.lds
 vdso32-int80-syms.lds
+vdso-image-*.c
+vdso2c
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index c580d12..895d4b1 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -24,15 +24,30 @@ vobj64s := $(filter-out $(vobjx32s-compat),$(vobjs-y))
 
 # files to link into kernel
 obj-y				+= vma.o
-obj-$(VDSO64-y)			+= vdso.o
-obj-$(VDSOX32-y)		+= vdsox32.o
-obj-$(VDSO32-y)			+= vdso32.o vdso32-setup.o
+
+# vDSO images to build
+vdso_img-$(VDSO64-y)		+= 64
+vdso_img-$(VDSOX32-y)		+= x32
+vdso_img-$(VDSO32-y)		+= 32-int80
+vdso_img-$(CONFIG_COMPAT)	+= 32-syscall
+vdso_img-$(VDSO32-y)		+= 32-sysenter
+
+obj-$(VDSO32-y)			+= vdso32-setup.o
 
 vobjs := $(foreach F,$(vobj64s),$(obj)/$F)
 
 $(obj)/vdso.o: $(obj)/vdso.so
 
-targets += vdso.so vdso.so.dbg vdso.lds $(vobjs-y)
+targets += vdso.lds $(vobjs-y)
+
+# Build the vDSO image C files and link them in.
+vdso_img_objs := $(vdso_img-y:%=vdso-image-%.o)
+vdso_img_cfiles := $(vdso_img-y:%=vdso-image-%.c)
+vdso_img_sodbg := $(vdso_img-y:%=vdso%.so.dbg)
+obj-y += $(vdso_img_objs)
+targets += $(vdso_img_cfiles)
+targets += $(vdso_img_sodbg)
+.SECONDARY: $(vdso_img-y:%=$(obj)/vdso-image-%.c)
 
 export CPPFLAGS_vdso.lds += -P -C
 
@@ -41,14 +56,18 @@ VDSO_LDFLAGS_vdso.lds = -m64 -Wl,-soname=linux-vdso.so.1 \
 			-Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096 \
 			$(DISABLE_LTO)
 
-$(obj)/vdso.o: $(src)/vdso.S $(obj)/vdso.so
-
-$(obj)/vdso.so.dbg: $(src)/vdso.lds $(vobjs) FORCE
+$(obj)/vdso64.so.dbg: $(src)/vdso.lds $(vobjs) FORCE
 	$(call if_changed,vdso)
 
-$(obj)/%.so: OBJCOPYFLAGS := -S
-$(obj)/%.so: $(obj)/%.so.dbg FORCE
-	$(call if_changed,objcopy)
+hostprogs-y			+= vdso2c
+
+quiet_cmd_vdso2c = VDSO2C  $@
+define cmd_vdso2c
+	$(obj)/vdso2c $< $@
+endef
+
+$(obj)/vdso-image-%.c: $(obj)/vdso%.so.dbg $(obj)/vdso2c FORCE
+	$(call if_changed,vdso2c)
 
 #
 # Don't omit frame pointers for ease of userspace debugging, but do
@@ -68,22 +87,6 @@ CFLAGS_REMOVE_vclock_gettime.o = -pg
 CFLAGS_REMOVE_vgetcpu.o = -pg
 CFLAGS_REMOVE_vvar.o = -pg
 
-targets += vdso-syms.lds
-obj-$(VDSO64-y)			+= vdso-syms.lds
-
-#
-# Match symbols in the DSO that look like VDSO*; produce a file of constants.
-#
-sed-vdsosym := -e 's/^00*/0/' \
-	-e 's/^\([0-9a-fA-F]*\) . \(VDSO[a-zA-Z0-9_]*\)$$/\2 = 0x\1;/p'
-quiet_cmd_vdsosym = VDSOSYM $@
-define cmd_vdsosym
-	$(NM) $< | LC_ALL=C sed -n $(sed-vdsosym) | LC_ALL=C sort > $@
-endef
-
-$(obj)/%-syms.lds: $(obj)/%.so.dbg FORCE
-	$(call if_changed,vdsosym)
-
 #
 # X32 processes use x32 vDSO to access 64bit kernel data.
 #
@@ -94,9 +97,6 @@ $(obj)/%-syms.lds: $(obj)/%.so.dbg FORCE
 # so that it can reach 64bit address space with 64bit pointers.
 #
 
-targets += vdsox32-syms.lds
-obj-$(VDSOX32-y)		+= vdsox32-syms.lds
-
 CPPFLAGS_vdsox32.lds = $(CPPFLAGS_vdso.lds)
 VDSO_LDFLAGS_vdsox32.lds = -Wl,-m,elf32_x86_64 \
 			   -Wl,-soname=linux-vdso.so.1 \
@@ -113,9 +113,7 @@ quiet_cmd_x32 = X32     $@
 $(obj)/%-x32.o: $(obj)/%.o FORCE
 	$(call if_changed,x32)
 
-targets += vdsox32.so vdsox32.so.dbg vdsox32.lds $(vobjx32s-y)
-
-$(obj)/vdsox32.o: $(src)/vdsox32.S $(obj)/vdsox32.so
+targets += vdsox32.lds $(vobjx32s-y)
 
 $(obj)/vdsox32.so.dbg: $(src)/vdsox32.lds $(vobjx32s) FORCE
 	$(call if_changed,vdso)
@@ -123,7 +121,6 @@ $(obj)/vdsox32.so.dbg: $(src)/vdsox32.lds $(vobjx32s) FORCE
 #
 # Build multiple 32-bit vDSO images to choose from at boot time.
 #
-obj-$(VDSO32-y)			+= vdso32-syms.lds
 vdso32.so-$(VDSO32-y)		+= int80
 vdso32.so-$(CONFIG_COMPAT)	+= syscall
 vdso32.so-$(VDSO32-y)		+= sysenter
@@ -138,10 +135,8 @@ VDSO_LDFLAGS_vdso32.lds = -m32 -Wl,-m,elf_i386 -Wl,-soname=linux-gate.so.1
 override obj-dirs = $(dir $(obj)) $(obj)/vdso32/
 
 targets += vdso32/vdso32.lds
-targets += $(vdso32-images) $(vdso32-images:=.dbg)
 targets += vdso32/note.o vdso32/vclock_gettime.o $(vdso32.so-y:%=vdso32/%.o)
-
-extra-y	+= $(vdso32-images)
+targets += vdso32/vclock_gettime.o
 
 $(obj)/vdso32.o: $(vdso32-images:%=$(obj)/%)
 
@@ -166,27 +161,6 @@ $(vdso32-images:%=$(obj)/%.dbg): $(obj)/vdso32-%.so.dbg: FORCE \
 				 $(obj)/vdso32/%.o
 	$(call if_changed,vdso)
 
-# Make vdso32-*-syms.lds from each image, and then make sure they match.
-# The only difference should be that some do not define VDSO32_SYSENTER_RETURN.
-
-targets += vdso32-syms.lds $(vdso32.so-y:%=vdso32-%-syms.lds)
-
-quiet_cmd_vdso32sym = VDSOSYM $@
-define cmd_vdso32sym
-	if LC_ALL=C sort -u $(filter-out FORCE,$^) > $(@D)/.tmp_$(@F) && \
-	   $(foreach H,$(filter-out FORCE,$^),\
-		     if grep -q VDSO32_SYSENTER_RETURN $H; \
-		     then diff -u $(@D)/.tmp_$(@F) $H; \
-		     else sed /VDSO32_SYSENTER_RETURN/d $(@D)/.tmp_$(@F) | \
-			  diff -u - $H; fi &&) : ;\
-	then mv -f $(@D)/.tmp_$(@F) $@; \
-	else rm -f $(@D)/.tmp_$(@F); exit 1; \
-	fi
-endef
-
-$(obj)/vdso32-syms.lds: $(vdso32.so-y:%=$(obj)/vdso32-%-syms.lds) FORCE
-	$(call if_changed,vdso32sym)
-
 #
 # The DSO images are built using a special linker script.
 #
@@ -197,7 +171,7 @@ quiet_cmd_vdso = VDSO    $@
 		 sh $(srctree)/$(src)/checkundef.sh '$(NM)' '$@'
 
 VDSO_LDFLAGS = -fPIC -shared $(call cc-ldoption, -Wl$(comma)--hash-style=sysv) \
-		$(LTO_CFLAGS)
+	-Wl,-Bsymbolic $(LTO_CFLAGS)
 GCOV_PROFILE := n
 
 #
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 16d6861..091554c 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -154,7 +154,7 @@ notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
 	asm(
 		"mov %%ebx, %%edx \n"
 		"mov %2, %%ebx \n"
-		"call VDSO32_vsyscall \n"
+		"call __kernel_vsyscall \n"
 		"mov %%edx, %%ebx \n"
 		: "=a" (ret)
 		: "0" (__NR_clock_gettime), "g" (clock), "c" (ts)
@@ -169,7 +169,7 @@ notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
 	asm(
 		"mov %%ebx, %%edx \n"
 		"mov %2, %%ebx \n"
-		"call VDSO32_vsyscall \n"
+		"call __kernel_vsyscall \n"
 		"mov %%edx, %%ebx \n"
 		: "=a" (ret)
 		: "0" (__NR_gettimeofday), "g" (tv), "c" (tz)
diff --git a/arch/x86/vdso/vdso.S b/arch/x86/vdso/vdso.S
deleted file mode 100644
index be3f23b..0000000
--- a/arch/x86/vdso/vdso.S
+++ /dev/null
@@ -1,3 +0,0 @@
-#include <asm/vdso.h>
-
-DEFINE_VDSO_IMAGE(vdso, "arch/x86/vdso/vdso.so")
diff --git a/arch/x86/vdso/vdso2c.c b/arch/x86/vdso/vdso2c.c
new file mode 100644
index 0000000..976e8e4
--- /dev/null
+++ b/arch/x86/vdso/vdso2c.c
@@ -0,0 +1,142 @@
+#include <inttypes.h>
+#include <stdint.h>
+#include <unistd.h>
+#include <stdarg.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <err.h>
+
+#include <sys/mman.h>
+#include <sys/types.h>
+
+#include <linux/elf.h>
+#include <linux/types.h>
+
+/* Symbols that we need in vdso2c. */
+char const * const required_syms[] = {
+	"VDSO32_NOTE_MASK",
+	"VDSO32_SYSENTER_RETURN",
+	"__kernel_vsyscall",
+	"__kernel_sigreturn",
+	"__kernel_rt_sigreturn",
+};
+
+__attribute__((format(printf, 1, 2))) __attribute__((noreturn))
+static void fail(const char *format, ...)
+{
+	va_list ap;
+	va_start(ap, format);
+	fprintf(stderr, "Error: ");
+	vfprintf(stderr, format, ap);
+	exit(1);
+	va_end(ap);
+}
+
+#define NSYMS (sizeof(required_syms) / sizeof(required_syms[0]))
+
+#define BITS 64
+#define GOFUNC go64
+#define Elf_Ehdr Elf64_Ehdr
+#define Elf_Shdr Elf64_Shdr
+#define Elf_Phdr Elf64_Phdr
+#define Elf_Sym Elf64_Sym
+#define Elf_Dyn Elf64_Dyn
+#include "vdso2c.h"
+#undef BITS
+#undef GOFUNC
+#undef Elf_Ehdr
+#undef Elf_Shdr
+#undef Elf_Phdr
+#undef Elf_Sym
+#undef Elf_Dyn
+
+#define BITS 32
+#define GOFUNC go32
+#define Elf_Ehdr Elf32_Ehdr
+#define Elf_Shdr Elf32_Shdr
+#define Elf_Phdr Elf32_Phdr
+#define Elf_Sym Elf32_Sym
+#define Elf_Dyn Elf32_Dyn
+#include "vdso2c.h"
+#undef BITS
+#undef GOFUNC
+#undef Elf_Ehdr
+#undef Elf_Shdr
+#undef Elf_Phdr
+#undef Elf_Sym
+#undef Elf_Dyn
+
+static int go(void *addr, size_t len, FILE *outfile, const char *name)
+{
+	Elf64_Ehdr *hdr = (Elf64_Ehdr *)addr;
+
+	if (hdr->e_ident[EI_CLASS] == ELFCLASS64) {
+		return go64(addr, len, outfile, name);
+	} else if (hdr->e_ident[EI_CLASS] == ELFCLASS32) {
+		return go32(addr, len, outfile, name);
+	} else {
+		fprintf(stderr, "Error: unknown ELF class\n");
+		return 1;
+	}
+}
+
+int main(int argc, char **argv)
+{
+	int fd;
+	off_t len;
+	void *addr;
+	FILE *outfile;
+	int ret;
+	char *name, *tmp;
+	int namelen;
+
+	if (argc != 3) {
+		printf("Usage: vdso2c INPUT OUTPUT\n");
+		return 1;
+	}
+
+	/*
+	 * Figure out the struct name.  If we're writing to a .so file,
+	 * generate raw output insted.
+	 */
+	name = strdup(argv[2]);
+	namelen = strlen(name);
+	if (namelen >= 3 && !strcmp(name + namelen - 3, ".so")) {
+		name = NULL;
+	} else {
+		tmp = strrchr(name, '/');
+		if (tmp)
+			name = tmp + 1;
+		tmp = strchr(name, '.');
+		if (tmp)
+			*tmp = '\0';
+		for (tmp = name; *tmp; tmp++)
+			if (*tmp == '-')
+				*tmp = '_';
+	}
+
+	fd = open(argv[1], O_RDONLY);
+	if (fd == -1)
+		err(1, "%s", argv[1]);
+
+	len = lseek(fd, 0, SEEK_END);
+	if (len == (off_t)-1)
+		err(1, "lseek");
+
+	addr = mmap(NULL, len, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
+	if (addr == MAP_FAILED)
+		err(1, "mmap");
+
+	outfile = fopen(argv[2], "w");
+	if (!outfile)
+		err(1, "%s", argv[2]);
+
+	ret = go(addr, (size_t)len, outfile, name);
+
+	munmap(addr, len);
+	fclose(outfile);
+
+	return ret;
+}
diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
new file mode 100644
index 0000000..9276e52
--- /dev/null
+++ b/arch/x86/vdso/vdso2c.h
@@ -0,0 +1,137 @@
+/*
+ * This file is included twice from vdso2c.c.  It generates code for 32-bit
+ * and 64-bit vDSOs.  We need both for 64-bit builds, since 32-bit vDSOs
+ * are built for 32-bit userspace.
+ */
+
+static int GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
+{
+	int found_load = 0;
+	unsigned long load_size = -1;  /* Work around bogus warning */
+	unsigned long data_size;
+	Elf_Ehdr *hdr = (Elf_Ehdr *)addr;
+	int i;
+	unsigned long j;
+	Elf_Shdr *symtab_hdr = NULL, *strtab_hdr, *secstrings_hdr,
+		*alt_sec = NULL;
+	Elf_Dyn *dyn = 0, *dyn_end = 0;
+	const char *secstrings;
+	uint64_t syms[NSYMS] = {};
+
+	Elf_Phdr *pt = (Elf_Phdr *)(addr + hdr->e_phoff);
+
+	/* Walk the segment table. */
+	for (i = 0; i < hdr->e_phnum; i++) {
+		if (pt[i].p_type == PT_LOAD) {
+			if (found_load)
+				fail("multiple PT_LOAD segs\n");
+
+			if (pt[i].p_offset != 0 || pt[i].p_vaddr != 0)
+				fail("PT_LOAD in wrong place\n");
+
+			if (pt[i].p_memsz != pt[i].p_filesz)
+				fail("cannot handle memsz != filesz\n");
+
+			load_size = pt[i].p_memsz;
+			found_load = 1;
+		} else if (pt[i].p_type == PT_DYNAMIC) {
+			dyn = addr + pt[i].p_offset;
+			dyn_end = addr + pt[i].p_offset + pt[i].p_memsz;
+		}
+	}
+	if (!found_load)
+		fail("no PT_LOAD seg\n");
+	data_size = (load_size + 4095) / 4096 * 4096;
+
+	/* Walk the dynamic table */
+	for (i = 0; dyn + i < dyn_end && dyn[i].d_tag != DT_NULL; i++) {
+		if (dyn[i].d_tag == DT_REL || dyn[i].d_tag == DT_RELSZ ||
+		    dyn[i].d_tag == DT_RELENT || dyn[i].d_tag == DT_TEXTREL)
+			fail("vdso image contains dynamic relocations\n");
+	}
+
+	/* Walk the section table */
+	secstrings_hdr = addr + hdr->e_shoff + hdr->e_shentsize*hdr->e_shstrndx;
+	secstrings = addr + secstrings_hdr->sh_offset;
+	for (i = 0; i < hdr->e_shnum; i++) {
+		Elf_Shdr *sh = addr + hdr->e_shoff + hdr->e_shentsize * i;
+		if (sh->sh_type == SHT_SYMTAB)
+			symtab_hdr = sh;
+
+		if (!strcmp(secstrings + sh->sh_name, ".altinstructions"))
+			alt_sec = sh;
+	}
+
+	if (!symtab_hdr) {
+		fail("no symbol table\n");
+		return 1;
+	}
+
+	strtab_hdr = addr + hdr->e_shoff +
+		hdr->e_shentsize * symtab_hdr->sh_link;
+
+	/* Walk the symbol table */
+	for (i = 0; i < symtab_hdr->sh_size / symtab_hdr->sh_entsize; i++) {
+		int k;
+		Elf_Sym *sym = addr + symtab_hdr->sh_offset +
+			symtab_hdr->sh_entsize * i;
+		const char *name = addr + strtab_hdr->sh_offset + sym->st_name;
+		for (k = 0; k < NSYMS; k++) {
+			if (!strcmp(name, required_syms[k])) {
+				if (syms[k]) {
+					fail("duplicate symbol %s\n",
+					     required_syms[k]);
+				}
+				syms[k] = sym->st_value;
+			}
+		}
+	}
+
+	/* Remove sections. */
+	hdr->e_shoff = 0;
+	hdr->e_shentsize = 0;
+	hdr->e_shnum = 0;
+	hdr->e_shstrndx = SHN_UNDEF;
+
+	if (!name) {
+		fwrite(addr, load_size, 1, outfile);
+		return 0;
+	}
+
+	fprintf(outfile, "/* AUTOMATICALLY GENERATED -- DO NOT EDIT */\n\n");
+	fprintf(outfile, "#include <linux/linkage.h>\n");
+	fprintf(outfile, "#include <asm/page_types.h>\n");
+	fprintf(outfile, "#include <asm/vdso.h>\n");
+	fprintf(outfile, "\n");
+	fprintf(outfile,
+		"static unsigned char raw_data[%lu] __page_aligned_data = {",
+		data_size);
+	for (j = 0; j < load_size; j++) {
+		if (j % 10 == 0)
+			fprintf(outfile, "\n\t");
+		fprintf(outfile, "0x%02X, ", (int)((unsigned char *)addr)[j]);
+	}
+	fprintf(outfile, "\n};\n\n");
+
+	fprintf(outfile, "static struct page *pages[%lu];\n\n",
+		data_size / 4096);
+
+	fprintf(outfile, "const struct vdso_image %s = {\n", name);
+	fprintf(outfile, "\t.data = raw_data,\n");
+	fprintf(outfile, "\t.size = %lu,\n", data_size);
+	fprintf(outfile, "\t.pages = pages,\n");
+	if (alt_sec) {
+		fprintf(outfile, "\t.alt = %lu,\n",
+			(unsigned long)alt_sec->sh_offset);
+		fprintf(outfile, "\t.alt_len = %lu,\n",
+			(unsigned long)alt_sec->sh_size);
+	}
+	for (i = 0; i < NSYMS; i++) {
+		if (syms[i])
+			fprintf(outfile, "\t.sym_%s = 0x%" PRIx64 ",\n",
+				required_syms[i], syms[i]);
+	}
+	fprintf(outfile, "};\n");
+
+	return 0;
+}
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 9c78d5b..d414601 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -29,6 +29,7 @@
 #include <asm/fixmap.h>
 #include <asm/hpet.h>
 #include <asm/vvar.h>
+#include <asm/vdso32.h>
 
 #ifdef CONFIG_COMPAT_VDSO
 #define VDSO_DEFAULT	0
@@ -67,9 +68,6 @@ __setup("vdso32=", vdso32_setup);
 __setup_param("vdso=", vdso_setup, vdso32_setup, 0);
 #endif
 
-static struct page **vdso32_pages;
-static unsigned vdso32_size;
-
 #ifdef CONFIG_X86_64
 
 #define	vdso32_sysenter()	(boot_cpu_has(X86_FEATURE_SYSENTER32))
@@ -82,34 +80,23 @@ static unsigned vdso32_size;
 
 #endif	/* CONFIG_X86_64 */
 
+#if defined(CONFIG_X86_32) || defined(CONFIG_COMPAT)
+const struct vdso_image *selected_vdso32;
+#endif
+
 int __init sysenter_setup(void)
 {
-	char *vdso32_start, *vdso32_end;
-	int npages, i;
-
 #ifdef CONFIG_COMPAT
-	if (vdso32_syscall()) {
-		vdso32_start = vdso32_syscall_start;
-		vdso32_end = vdso32_syscall_end;
-		vdso32_pages = vdso32_syscall_pages;
-	} else
+	if (vdso32_syscall())
+		selected_vdso32 = &vdso_image_32_syscall;
+	else
 #endif
-	if (vdso32_sysenter()) {
-		vdso32_start = vdso32_sysenter_start;
-		vdso32_end = vdso32_sysenter_end;
-		vdso32_pages = vdso32_sysenter_pages;
-	} else {
-		vdso32_start = vdso32_int80_start;
-		vdso32_end = vdso32_int80_end;
-		vdso32_pages = vdso32_int80_pages;
-	}
-
-	npages = ((vdso32_end - vdso32_start) + PAGE_SIZE - 1) / PAGE_SIZE;
-	vdso32_size = npages << PAGE_SHIFT;
-	for (i = 0; i < npages; i++)
-		vdso32_pages[i] = virt_to_page(vdso32_start + i*PAGE_SIZE);
+	if (vdso32_sysenter())
+		selected_vdso32 = &vdso_image_32_sysenter;
+	else
+		selected_vdso32 = &vdso_image_32_int80;
 
-	patch_vdso32(vdso32_start, vdso32_size);
+	init_vdso_image(selected_vdso32);
 
 	return 0;
 }
@@ -121,6 +108,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	unsigned long addr;
 	int ret = 0;
 	struct vm_area_struct *vma;
+	unsigned long vdso32_size = selected_vdso32->size;
 
 #ifdef CONFIG_X86_X32_ABI
 	if (test_thread_flag(TIF_X32))
@@ -140,7 +128,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 
 	addr += VDSO_OFFSET(VDSO_PREV_PAGES);
 
-	current->mm->context.vdso = (void *)addr;
+	current->mm->context.vdso = (void __user *)addr;
 
 	/*
 	 * MAYWRITE to allow gdb to COW and set breakpoints
@@ -150,7 +138,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 			vdso32_size,
 			VM_READ|VM_EXEC|
 			VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
-			vdso32_pages);
+			selected_vdso32->pages);
 
 	if (ret)
 		goto up_fail;
@@ -188,8 +176,10 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	}
 #endif
 
-	current_thread_info()->sysenter_return =
-		VDSO32_SYMBOL(addr, SYSENTER_RETURN);
+	if (selected_vdso32->sym_VDSO32_SYSENTER_RETURN)
+		current_thread_info()->sysenter_return =
+			current->mm->context.vdso +
+			selected_vdso32->sym_VDSO32_SYSENTER_RETURN;
 
   up_fail:
 	if (ret)
diff --git a/arch/x86/vdso/vdso32.S b/arch/x86/vdso/vdso32.S
deleted file mode 100644
index 018bcd9..0000000
--- a/arch/x86/vdso/vdso32.S
+++ /dev/null
@@ -1,9 +0,0 @@
-#include <asm/vdso.h>
-
-DEFINE_VDSO_IMAGE(vdso32_int80, "arch/x86/vdso/vdso32-int80.so")
-
-#ifdef CONFIG_COMPAT
-DEFINE_VDSO_IMAGE(vdso32_syscall, "arch/x86/vdso/vdso32-syscall.so")
-#endif
-
-DEFINE_VDSO_IMAGE(vdso32_sysenter, "arch/x86/vdso/vdso32-sysenter.so")
diff --git a/arch/x86/vdso/vdso32/vdso32.lds.S b/arch/x86/vdso/vdso32/vdso32.lds.S
index aadb8b9..f072095 100644
--- a/arch/x86/vdso/vdso32/vdso32.lds.S
+++ b/arch/x86/vdso/vdso32/vdso32.lds.S
@@ -38,13 +38,3 @@ VERSION
 	local: *;
 	};
 }
-
-/*
- * Symbols we define here called VDSO* get their values into vdso32-syms.h.
- */
-VDSO32_vsyscall		= __kernel_vsyscall;
-VDSO32_sigreturn	= __kernel_sigreturn;
-VDSO32_rt_sigreturn	= __kernel_rt_sigreturn;
-VDSO32_clock_gettime	= clock_gettime;
-VDSO32_gettimeofday	= gettimeofday;
-VDSO32_time		= time;
diff --git a/arch/x86/vdso/vdsox32.S b/arch/x86/vdso/vdsox32.S
deleted file mode 100644
index f4aa34e..0000000
--- a/arch/x86/vdso/vdsox32.S
+++ /dev/null
@@ -1,3 +0,0 @@
-#include <asm/vdso.h>
-
-DEFINE_VDSO_IMAGE(vdsox32, "arch/x86/vdso/vdsox32.so")
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 8b79039..cf21762 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -19,99 +19,31 @@
 #if defined(CONFIG_X86_64)
 unsigned int __read_mostly vdso64_enabled = 1;
 
-DECLARE_VDSO_IMAGE(vdso);
 extern unsigned short vdso_sync_cpuid;
-static unsigned vdso_size;
-
-#ifdef CONFIG_X86_X32_ABI
-DECLARE_VDSO_IMAGE(vdsox32);
-static unsigned vdsox32_size;
-#endif
 #endif
 
-#if defined(CONFIG_X86_32) || defined(CONFIG_X86_X32_ABI) || \
-	defined(CONFIG_COMPAT)
-void __init patch_vdso32(void *vdso, size_t len)
+void __init init_vdso_image(const struct vdso_image *image)
 {
-	Elf32_Ehdr *hdr = vdso;
-	Elf32_Shdr *sechdrs, *alt_sec = 0;
-	char *secstrings;
-	void *alt_data;
 	int i;
+	int npages = (image->size) / PAGE_SIZE;
 
-	BUG_ON(len < sizeof(Elf32_Ehdr));
-	BUG_ON(memcmp(hdr->e_ident, ELFMAG, SELFMAG) != 0);
-
-	sechdrs = (void *)hdr + hdr->e_shoff;
-	secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
-
-	for (i = 1; i < hdr->e_shnum; i++) {
-		Elf32_Shdr *shdr = &sechdrs[i];
-		if (!strcmp(secstrings + shdr->sh_name, ".altinstructions")) {
-			alt_sec = shdr;
-			goto found;
-		}
-	}
-
-	/* If we get here, it's probably a bug. */
-	pr_warning("patch_vdso32: .altinstructions not found\n");
-	return;  /* nothing to patch */
+	BUG_ON(image->size % PAGE_SIZE != 0);
+	for (i = 0; i < npages; i++)
+		image->pages[i] = virt_to_page(image->data + i*PAGE_SIZE);
 
-found:
-	alt_data = (void *)hdr + alt_sec->sh_offset;
-	apply_alternatives(alt_data, alt_data + alt_sec->sh_size);
+	apply_alternatives((struct alt_instr *)(image->data + image->alt),
+			   (struct alt_instr *)(image->data + image->alt +
+						image->alt_len));
 }
-#endif
-
-#if defined(CONFIG_X86_64)
-static void __init patch_vdso64(void *vdso, size_t len)
-{
-	Elf64_Ehdr *hdr = vdso;
-	Elf64_Shdr *sechdrs, *alt_sec = 0;
-	char *secstrings;
-	void *alt_data;
-	int i;
 
-	BUG_ON(len < sizeof(Elf64_Ehdr));
-	BUG_ON(memcmp(hdr->e_ident, ELFMAG, SELFMAG) != 0);
-
-	sechdrs = (void *)hdr + hdr->e_shoff;
-	secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
-
-	for (i = 1; i < hdr->e_shnum; i++) {
-		Elf64_Shdr *shdr = &sechdrs[i];
-		if (!strcmp(secstrings + shdr->sh_name, ".altinstructions")) {
-			alt_sec = shdr;
-			goto found;
-		}
-	}
-
-	/* If we get here, it's probably a bug. */
-	pr_warning("patch_vdso64: .altinstructions not found\n");
-	return;  /* nothing to patch */
-
-found:
-	alt_data = (void *)hdr + alt_sec->sh_offset;
-	apply_alternatives(alt_data, alt_data + alt_sec->sh_size);
-}
 
+#if defined(CONFIG_X86_64)
 static int __init init_vdso(void)
 {
-	int npages = (vdso_end - vdso_start + PAGE_SIZE - 1) / PAGE_SIZE;
-	int i;
-
-	patch_vdso64(vdso_start, vdso_end - vdso_start);
-
-	vdso_size = npages << PAGE_SHIFT;
-	for (i = 0; i < npages; i++)
-		vdso_pages[i] = virt_to_page(vdso_start + i*PAGE_SIZE);
+	init_vdso_image(&vdso_image_64);
 
 #ifdef CONFIG_X86_X32_ABI
-	patch_vdso32(vdsox32_start, vdsox32_end - vdsox32_start);
-	npages = (vdsox32_end - vdsox32_start + PAGE_SIZE - 1) / PAGE_SIZE;
-	vdsox32_size = npages << PAGE_SHIFT;
-	for (i = 0; i < npages; i++)
-		vdsox32_pages[i] = virt_to_page(vdsox32_start + i*PAGE_SIZE);
+	init_vdso_image(&vdso_image_x32);
 #endif
 
 	return 0;
@@ -171,7 +103,7 @@ static int setup_additional_pages(struct linux_binprm *bprm,
 		goto up_fail;
 	}
 
-	current->mm->context.vdso = (void *)addr;
+	current->mm->context.vdso = (void __user *)addr;
 
 	ret = install_special_mapping(mm, addr, size,
 				      VM_READ|VM_EXEC|
@@ -189,15 +121,15 @@ up_fail:
 
 int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 {
-	return setup_additional_pages(bprm, uses_interp, vdso_pages,
-				      vdso_size);
+	return setup_additional_pages(bprm, uses_interp, vdso_image_64.pages,
+				      vdso_image_64.size);
 }
 
 #ifdef CONFIG_X86_X32_ABI
 int x32_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 {
-	return setup_additional_pages(bprm, uses_interp, vdsox32_pages,
-				      vdsox32_size);
+	return setup_additional_pages(bprm, uses_interp, vdso_image_x32.pages,
+				      vdso_image_x32.size);
 }
 #endif
 
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 0982233..7225a95 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -516,10 +516,17 @@ char * __init xen_memory_setup(void)
 static void __init fiddle_vdso(void)
 {
 #ifdef CONFIG_X86_32
+	/*
+	 * This could be called before selected_vdso32 is initialized, so
+	 * just fiddle with both possible images.  vdso_image_32_syscall
+	 * can't be selected, since it only exists on 64-bit systems.
+	 */
 	u32 *mask;
-	mask = VDSO32_SYMBOL(&vdso32_int80_start, NOTE_MASK);
+	mask = vdso_image_32_int80.data +
+		vdso_image_32_int80.sym_VDSO32_NOTE_MASK;
 	*mask |= 1 << VDSO_NOTE_NONEGSEG_BIT;
-	mask = VDSO32_SYMBOL(&vdso32_sysenter_start, NOTE_MASK);
+	mask = vdso_image_32_sysenter.data +
+		vdso_image_32_sysenter.sym_VDSO32_NOTE_MASK;
 	*mask |= 1 << VDSO_NOTE_NONEGSEG_BIT;
 #endif
 }
-- 
1.9.0

