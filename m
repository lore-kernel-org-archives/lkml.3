Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab3DCOtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:49:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39774 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932192Ab3DCOt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:49:29 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <515C5D2502000078000CA6AD@nat28.tlf.novell.com>
References: <515C5D2502000078000CA6AD@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86: fix rebuild with EFI_STUB enabled
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 03 Apr 2013 07:48:30 -0700
To: Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de
CC: Matt Fleming <matt.fleming@intel.com>, mjg@redhat.com,
        linux-kernel@vger.kernel.org
Message-ID: <5a3182e0-580a-42f4-a17f-925836cca7d2@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks awesome for 3.10, but getting a minimal fix for 3.9/stable would be good, too.

Jan Beulich <JBeulich@suse.com> wrote:

>eboot.o and efi_stub_$(BITS).o didn't get added to "targets", and hence
>their .cmd files don't get included by the build machinery, leading to
>the files always getting rebuilt.
>
>Rather than adding the two files individually, take the opportunity and
>add $(VMLINUX_OBJS) to "targets" instead, thus allowing the assignment
>at the top of the file to be shrunk quite a bit.
>
>At the same time, remove a pointless flags override line - the variable
>assigned to was misspelled anyway, and the options added are
>meaningless for assembly sources.
>
>Signed-off-by: Jan Beulich <jbeulich@suse.com>
>Cc: Matthew Garrett <mjg@redhat.com>
>Cc: Matt Fleming <matt.fleming@intel.com>
>---
> arch/x86/boot/compressed/Makefile |    5 ++---
> 1 file changed, 2 insertions(+), 3 deletions(-)
>
>--- 3.9-rc5/arch/x86/boot/compressed/Makefile
>+++ 3.9-rc5-x86-EFI-stub-rebuild/arch/x86/boot/compressed/Makefile
>@@ -4,7 +4,7 @@
> # create a compressed vmlinux image from the original vmlinux
> #
> 
>-targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz
>vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.xz vmlinux.bin.lzo
>head_$(BITS).o misc.o string.o cmdline.o early_serial_console.o piggy.o
>+targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2
>vmlinux.bin.lzma vmlinux.bin.xz vmlinux.bin.lzo
> 
> KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
> KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
>@@ -29,7 +29,6 @@ VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)
> 	$(obj)/piggy.o
> 
> $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
>-$(obj)/efi_stub_$(BITS).o: KBUILD_CLFAGS += -fshort-wchar
>-mno-red-zone
> 
> ifeq ($(CONFIG_EFI_STUB), y)
> 	VMLINUX_OBJS += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o
>@@ -43,7 +42,7 @@ OBJCOPYFLAGS_vmlinux.bin :=  -R .comment
> $(obj)/vmlinux.bin: vmlinux FORCE
> 	$(call if_changed,objcopy)
> 
>-targets += vmlinux.bin.all vmlinux.relocs
>+targets += $(patsubst $(obj)/%,%,$(VMLINUX_OBJS)) vmlinux.bin.all
>vmlinux.relocs
> 
> CMD_RELOCS = arch/x86/tools/relocs
> quiet_cmd_relocs = RELOCS  $@

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
