Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab3DGFtg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 01:49:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50608 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665Ab3DGFte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 01:49:34 -0400
Date: Sat, 6 Apr 2013 22:49:06 -0700
Message-Id: <201304070549.r375n6wj013205@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for v3.9-rc6
Cc: <stable@vger.kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Jan Beulich <jbeulich@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Will Drewry <wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Two quite small fixes: one a build problem, and the other fixes
seccomp filters on x32.

The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eefa9:

  Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

for you to fetch changes up to 918708245e92941df16a634dc201b407d12bcd91:

  x86: Fix rebuild with EFI_STUB enabled (2013-04-05 13:59:23 -0700)

----------------------------------------------------------------
Jan Beulich (1):
      x86: Fix rebuild with EFI_STUB enabled

Paul Moore (1):
      x86: remove the x32 syscall bitmask from syscall_get_nr()

 arch/x86/boot/compressed/Makefile | 5 ++---
 arch/x86/include/asm/syscall.h    | 4 ++--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 8a84501..5ef205c 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -4,7 +4,7 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
-targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.xz vmlinux.bin.lzo head_$(BITS).o misc.o string.o cmdline.o early_serial_console.o piggy.o
+targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.xz vmlinux.bin.lzo
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
@@ -29,7 +29,6 @@ VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
 	$(obj)/piggy.o
 
 $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
-$(obj)/efi_stub_$(BITS).o: KBUILD_CLFAGS += -fshort-wchar -mno-red-zone
 
 ifeq ($(CONFIG_EFI_STUB), y)
 	VMLINUX_OBJS += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o
@@ -43,7 +42,7 @@ OBJCOPYFLAGS_vmlinux.bin :=  -R .comment -S
 $(obj)/vmlinux.bin: vmlinux FORCE
 	$(call if_changed,objcopy)
 
-targets += vmlinux.bin.all vmlinux.relocs
+targets += $(patsubst $(obj)/%,%,$(VMLINUX_OBJS)) vmlinux.bin.all vmlinux.relocs
 
 CMD_RELOCS = arch/x86/tools/relocs
 quiet_cmd_relocs = RELOCS  $@
diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index 1ace47b..2e188d6 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -29,13 +29,13 @@ extern const unsigned long sys_call_table[];
  */
 static inline int syscall_get_nr(struct task_struct *task, struct pt_regs *regs)
 {
-	return regs->orig_ax & __SYSCALL_MASK;
+	return regs->orig_ax;
 }
 
 static inline void syscall_rollback(struct task_struct *task,
 				    struct pt_regs *regs)
 {
-	regs->ax = regs->orig_ax & __SYSCALL_MASK;
+	regs->ax = regs->orig_ax;
 }
 
 static inline long syscall_get_error(struct task_struct *task,
