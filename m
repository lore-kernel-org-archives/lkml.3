Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802Ab3EGEGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:06:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9670 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760156Ab3EGD6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:52 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=KD9RH4bWTR8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=A_W-nbdQbVoA:10 a=iox4zFpeAAAA:8 a=VwQbUJbxAAAA:8 a=1nSz6Ew-AAAA:8 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=ppDWQa8pdrQpKnv6qjEA:9 a=n9GBPR9yFnkA:10 a=jEp0ucaQiEUA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035846.028726759@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Beulich <jbeulich@suse.com>, Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [031/126] x86: Fix rebuild with EFI_STUB enabled
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0031-x86-Fix-rebuild-with-EFI_STUB-enabled.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jan Beulich <JBeulich@suse.com>

[ Upstream commit 918708245e92941df16a634dc201b407d12bcd91 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/boot/compressed/Makefile |    5 ++---
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
-- 
1.7.10.4


