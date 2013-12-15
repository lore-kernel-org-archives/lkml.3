Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab3LOECu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 23:02:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58532 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab3LOECs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 23:02:48 -0500
Date: Sat, 14 Dec 2013 20:02:08 -0800
Message-Id: <201312150402.rBF428wR022814@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for 3.13-rc4
Cc: <stable@vger.kernel.org>, Cliff Wickman <cpw@sgi.com>,
        "H. J. Lu" <hjl.tools@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>,
        "Kevin B. Smith" <kevin.b.smith@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Sunil K. Pandey" <sunil.k.pandey@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 14 Dec 2013 20:02:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 374b105797c3d4f29c685f3be535c35f5689b30e:

  Linux 3.13-rc3 (2013-12-06 09:34:04 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/urgent

for you to fetch changes up to 04bf9ba720fcc4fa313fa122b799ae0989b6cd50:

  x86, efi: Don't use (U)EFI time services on 32 bit (2013-12-10 15:02:34 -0800)


This is a pretty small batch:

The biggest single change is to stop using EFI time services on 32-bit
platforms.  This matches our current behavior on 64-bit platforms as
we already had ruled them out there as being too unreliable.  Turns
out that affects 32-bit platforms, too.

One NULL pointer fix for SGI UV.

Two minor build fixes, one of which only affects icc and the other
which affects icc and future versions or nonstandard default settings
of gcc.


----------------------------------------------------------------
H. Peter Anvin (2):
      x86, build: Pass in additional -mno-mmx, -mno-sse options
      x86, build, icc: Remove uninitialized_var() from compiler-intel.h

Matthew Garrett (1):
      x86, efi: Don't use (U)EFI time services on 32 bit

cpw (1):
      x86/UV: Fix NULL pointer dereference in uv_flush_tlb_others() if the 'nobau' boot option is used

 arch/x86/Makefile                 | 8 ++++----
 arch/x86/boot/Makefile            | 6 +++---
 arch/x86/boot/compressed/Makefile | 1 +
 arch/x86/platform/efi/efi.c       | 7 -------
 arch/x86/platform/uv/tlb_uv.c     | 5 +++--
 arch/x86/realmode/rm/Makefile     | 3 ++-
 include/linux/compiler-intel.h    | 2 --
 7 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index eda00f9be0cf..57d021507120 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -31,8 +31,8 @@ ifeq ($(CONFIG_X86_32),y)
 
         KBUILD_CFLAGS += -msoft-float -mregparm=3 -freg-struct-return
 
-        # Don't autogenerate SSE instructions
-	KBUILD_CFLAGS += -mno-sse
+        # Don't autogenerate MMX or SSE instructions
+        KBUILD_CFLAGS += -mno-mmx -mno-sse
 
         # Never want PIC in a 32-bit kernel, prevent breakage with GCC built
         # with nonstandard options
@@ -60,8 +60,8 @@ else
         KBUILD_AFLAGS += -m64
         KBUILD_CFLAGS += -m64
 
-        # Don't autogenerate SSE instructions
-	KBUILD_CFLAGS += -mno-sse
+        # Don't autogenerate MMX or SSE instructions
+        KBUILD_CFLAGS += -mno-mmx -mno-sse
 
 	# Use -mpreferred-stack-boundary=3 if supported.
 	KBUILD_CFLAGS += $(call cc-option,-mpreferred-stack-boundary=3)
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index dce69a256896..d9c11956fce0 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -53,18 +53,18 @@ $(obj)/cpustr.h: $(obj)/mkcpustr FORCE
 
 # How to compile the 16-bit code.  Note we always compile for -march=i386,
 # that way we can complain to the user if the CPU is insufficient.
-KBUILD_CFLAGS	:= $(USERINCLUDE) -g -Os -D_SETUP -D__KERNEL__ \
+KBUILD_CFLAGS	:= $(USERINCLUDE) -m32 -g -Os -D_SETUP -D__KERNEL__ \
 		   -DDISABLE_BRANCH_PROFILING \
 		   -Wall -Wstrict-prototypes \
 		   -march=i386 -mregparm=3 \
 		   -include $(srctree)/$(src)/code16gcc.h \
 		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
+		   -mno-mmx -mno-sse \
 		   $(call cc-option, -ffreestanding) \
 		   $(call cc-option, -fno-toplevel-reorder,\
-			$(call cc-option, -fno-unit-at-a-time)) \
+		   $(call cc-option, -fno-unit-at-a-time)) \
 		   $(call cc-option, -fno-stack-protector) \
 		   $(call cc-option, -mpreferred-stack-boundary=2)
-KBUILD_CFLAGS	+= $(call cc-option, -m32)
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
 GCOV_PROFILE := n
 
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index dcd90df10ab4..c8a6792e7842 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -13,6 +13,7 @@ KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
 cflags-$(CONFIG_X86_32) := -march=i386
 cflags-$(CONFIG_X86_64) := -mcmodel=small
 KBUILD_CFLAGS += $(cflags-y)
+KBUILD_CFLAGS += -mno-mmx -mno-sse
 KBUILD_CFLAGS += $(call cc-option,-ffreestanding)
 KBUILD_CFLAGS += $(call cc-option,-fno-stack-protector)
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 92c02344a060..cceb813044ef 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -690,13 +690,6 @@ void __init efi_init(void)
 
 	set_bit(EFI_MEMMAP, &x86_efi_facility);
 
-#ifdef CONFIG_X86_32
-	if (efi_is_native()) {
-		x86_platform.get_wallclock = efi_get_time;
-		x86_platform.set_wallclock = efi_set_rtc_mmss;
-	}
-#endif
-
 #if EFI_DEBUG
 	print_efi_memmap();
 #endif
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 0f92173a12b6..efe4d7220397 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1070,12 +1070,13 @@ const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 	unsigned long status;
 
 	bcp = &per_cpu(bau_control, cpu);
-	stat = bcp->statp;
-	stat->s_enters++;
 
 	if (bcp->nobau)
 		return cpumask;
 
+	stat = bcp->statp;
+	stat->s_enters++;
+
 	if (bcp->busy) {
 		descriptor_status =
 			read_lmmr(UVH_LB_BAU_SB_ACTIVATION_STATUS_0);
diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index 88692871823f..9cac82588cbc 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -73,9 +73,10 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -m32 -g -Os -D_SETUP -D__KERNEL__ -D_WAKEUP \
 		   -march=i386 -mregparm=3 \
 		   -include $(srctree)/$(src)/../../boot/code16gcc.h \
 		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
+		   -mno-mmx -mno-sse \
 		   $(call cc-option, -ffreestanding) \
 		   $(call cc-option, -fno-toplevel-reorder,\
-			$(call cc-option, -fno-unit-at-a-time)) \
+		   $(call cc-option, -fno-unit-at-a-time)) \
 		   $(call cc-option, -fno-stack-protector) \
 		   $(call cc-option, -mpreferred-stack-boundary=2)
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
diff --git a/include/linux/compiler-intel.h b/include/linux/compiler-intel.h
index 973ce10c40b6..dc1bd3dcf11f 100644
--- a/include/linux/compiler-intel.h
+++ b/include/linux/compiler-intel.h
@@ -28,8 +28,6 @@
 
 #endif
 
-#define uninitialized_var(x) x
-
 #ifndef __HAVE_BUILTIN_BSWAP16__
 /* icc has this, but it's called _bswap16 */
 #define __HAVE_BUILTIN_BSWAP16__
