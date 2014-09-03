Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbaICI1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 04:27:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57137 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736AbaICI1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 04:27:13 -0400
Message-ID: <5406D0DB.90401@canonical.com>
Date: Wed, 03 Sep 2014 10:27:07 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matt Fleming <matt@console-pimps.org>
CC: Ulf Winkelvos <ulf@winkelvos.de>, Matt Fleming <matt.fleming@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [REGRESSION] "efi: efistub: Convert into static library" and
 preparation patches
References: <5405E186.2080406@canonical.com>	<20140902192941.GB3001@console-pimps.org> <CAKv+Gu_eSe+FeNkGm+w3sSsRn2_hr70xLVBieZgyhawAv6PQvw@mail.gmail.com>
In-Reply-To: <CAKv+Gu_eSe+FeNkGm+w3sSsRn2_hr70xLVBieZgyhawAv6PQvw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 03-09-14 om 08:06 schreef Ard Biesheuvel:
> On 2 September 2014 21:29, Matt Fleming <matt@console-pimps.org> wrote:
>> On Tue, 02 Sep, at 05:25:58PM, Maarten Lankhorst wrote:
>>> Hey,
>>>
>>> My macbook pro 8.2 fails to do a efi stub boot with these patches.
>>>
>>> Commit f23cf8bd5c1f49 "efi/x86: efistub: Move shared dependencies to <asm/efi.h>"
>>> causes the first break, but this can be averted by changing
>>>
>>> struct efi_config *efi_early;
>>>
>>> to
>>>
>>> struct efi_config *efi_early __attribute__((visibility("hidden")));
>> Weird. That sounds like a bug in the Apple EFI PE loader. Does any other
>> visibility result in a working kernel?
>>
>>> I also need to revert commit f4f75ad5741fe "efi: efistub: Convert into static library"
>>> to get boot working.
>> I'll take a look at the symbol changes between these commits and try and
>> guess what's going on.
>>
>>> I'm not an early boot expert, so I have no idea what's going on here.
>>> Only console output I see when the boot fails is "setup_efi_pci() failed!" after
>>> the commit that adds this message.
>> Yeah, that should be unrelated.
>>
>> Thanks for the report.
>>
> If x86 is anything like ARM in this respect, this is likely caused by
> the way PIC references to globals are emitted.
> When using default visibility, a reference to a global is emitted by a
> reference to the GOT, and an offset into the GOT, and the two are
> added and dereferenced at runtime. For this to work, the GOT needs to
> contain the correct absolute address for the global in question. This,
> in turn, relies on absolute relocations to be resolved at load time,
> which we don't do with the EFI stub. Could it be that the link address
> and load address are usually the same on x86 EFI but not on the Mac?
>
> With hidden visibility, the PIC reference is emitted using a relative
> relocation, to which the value of the program counter is added at
> runtime, and no GOT is involved, and all relocations can be resolved
> at build time.
>
> I think it makes sense to add a #pragma GCC visibility push(hidden) to
> efistub.h (if pragmas are in fashion these days), making sure that no
> global references (not even externs) will generate GOT entries.
>
Something like that probably.

Following patch FAILS:

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index f277184e2ac1..f9738d92c9ce 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -15,6 +15,8 @@
 
 #undef memcpy			/* Use memcpy from misc.c */
 
+#pragma GCC visibility push(hidden)
+
 #include "eboot.h"
 
 static efi_system_table_t *sys_table;
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 32d5cca30f49..7ef10f36cc1b 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -13,6 +13,8 @@
 #include <linux/efi.h>
 #include <asm/efi.h>
 
+#pragma GCC visibility push(hidden)
+
 #include "efistub.h"
 
 #define EFI_READ_CHUNK_SIZE	(1024 * 1024)

-----
But this works:

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 7a801a310e37..eebd13ee301b 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -30,11 +30,10 @@ VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
 	$(obj)/string.o $(obj)/cmdline.o $(obj)/early_serial_console.o \
 	$(obj)/piggy.o $(obj)/cpuflags.o $(obj)/aslr.o
 
-$(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
+$(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone -fvisibility=hidden
 
 ifeq ($(CONFIG_EFI_STUB), y)
-	VMLINUX_OBJS += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o \
-				$(objtree)/drivers/firmware/efi/libstub/lib.a
+	VMLINUX_OBJS += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o
 endif
 
 $(obj)/vmlinux: $(VMLINUX_OBJS) FORCE
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index f277184e2ac1..e18a265460dd 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -17,6 +17,8 @@
 
 #include "eboot.h"
 
+#include "../../../drivers/firmware/efi/libstub/efi-stub-helper.c"
+
 static efi_system_table_t *sys_table;
 
 struct efi_config *efi_early;


In case it was caused by lacking -fshort-wchar or order of building, I tried the following, also fails:
---
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 7a801a310e37..8f62c273badd 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -30,11 +30,10 @@ VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
 	$(obj)/string.o $(obj)/cmdline.o $(obj)/early_serial_console.o \
 	$(obj)/piggy.o $(obj)/cpuflags.o $(obj)/aslr.o
 
-$(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
+$(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone -fvisibility=hidden
 
 ifeq ($(CONFIG_EFI_STUB), y)
-	VMLINUX_OBJS += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o \
-				$(objtree)/drivers/firmware/efi/libstub/lib.a
+	VMLINUX_OBJS += $(objtree)/drivers/firmware/efi/libstub/efi-stub-helper.o $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o
 endif
 
 $(obj)/vmlinux: $(VMLINUX_OBJS) FORCE
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index b14bc2b9fb4d..66c5536cff4d 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -8,7 +8,8 @@ cflags-$(CONFIG_X86_32)		:= -march=i386
 cflags-$(CONFIG_X86_64)		:= -mcmodel=small
 cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2 \
 				   -fPIC -fno-strict-aliasing -mno-red-zone \
-				   -mno-mmx -mno-sse -DDISABLE_BRANCH_PROFILING
+				   -mno-mmx -mno-sse -DDISABLE_BRANCH_PROFILING \
+				   -fvisibility=hidden -fshort-wchar
 
 cflags-$(CONFIG_ARM64)		:= $(subst -pg,,$(KBUILD_CFLAGS))
 cflags-$(CONFIG_ARM)		:= $(subst -pg,,$(KBUILD_CFLAGS)) \



---
I have no idea why only directly referencing the file in eboot.c works.

~Maarten

