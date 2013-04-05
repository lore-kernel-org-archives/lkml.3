Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163060Ab3DEWa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 18:30:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40327 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162778Ab3DEWaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 18:30:25 -0400
Date: Fri, 5 Apr 2013 15:29:53 -0700
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-918708245e92941df16a634dc201b407d12bcd91@git.kernel.org>
Cc: mjg@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, jbeulich@suse.com, matt.fleming@intel.com,
        JBeulich@suse.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mjg@redhat.com, jbeulich@suse.com, matt.fleming@intel.com,
        JBeulich@suse.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <515C5D2502000078000CA6AD@nat28.tlf.novell.com>
References: <515C5D2502000078000CA6AD@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix rebuild with EFI_STUB enabled
Git-Commit-ID: 918708245e92941df16a634dc201b407d12bcd91
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 05 Apr 2013 15:29:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  918708245e92941df16a634dc201b407d12bcd91
Gitweb:     http://git.kernel.org/tip/918708245e92941df16a634dc201b407d12bcd91
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Wed, 3 Apr 2013 15:47:33 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 5 Apr 2013 13:59:23 -0700

x86: Fix rebuild with EFI_STUB enabled

eboot.o and efi_stub_$(BITS).o didn't get added to "targets", and hence
their .cmd files don't get included by the build machinery, leading to
the files always getting rebuilt.

Rather than adding the two files individually, take the opportunity and
add $(VMLINUX_OBJS) to "targets" instead, thus allowing the assignment
at the top of the file to be shrunk quite a bit.

At the same time, remove a pointless flags override line - the variable
assigned to was misspelled anyway, and the options added are
meaningless for assembly sources.

[ hpa: the patch is not minimal, but I am taking it for -urgent anyway
  since the excess impact of the patch seems to be small enough. ]

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/515C5D2502000078000CA6AD@nat28.tlf.novell.com
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/compressed/Makefile | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

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
