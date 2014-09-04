Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbaIDKs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:48:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36024 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaIDKs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:48:28 -0400
Message-ID: <54084376.8090002@canonical.com>
Date: Thu, 04 Sep 2014 12:48:22 +0200
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
References: <5405E186.2080406@canonical.com>	<20140902192941.GB3001@console-pimps.org>	<CAKv+Gu_eSe+FeNkGm+w3sSsRn2_hr70xLVBieZgyhawAv6PQvw@mail.gmail.com>	<5406D0DB.90401@canonical.com>	<CAKv+Gu8OD3p+GSwB+SPRf3pKwZB2R1t6x1zK7czGCXj1QhB7_g@mail.gmail.com>	<54073409.6030004@canonical.com>	<CAKv+Gu9q1qTh6DZXsCG2tGVBn-uwuQKQa_6FEMmchDVFi5vJtw@mail.gmail.com>	<20140903175948.GH3001@console-pimps.org> <CAKv+Gu9tejixb3Kb3YM_7sLcpKNuRHN+Dn+twFyCAXx99wYRCw@mail.gmail.com>
In-Reply-To: <CAKv+Gu9tejixb3Kb3YM_7sLcpKNuRHN+Dn+twFyCAXx99wYRCw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 03-09-14 om 21:57 schreef Ard Biesheuvel:
> On 3 September 2014 19:59, Matt Fleming <matt@console-pimps.org> wrote:
>> On Wed, 03 Sep, at 05:37:26PM, Ard Biesheuvel wrote:
>>> Will do, thanks.
>>>
>>> @Matt: so there is two ways to fix this, the patch above addressing
>>> this single instance, and alternatively, adding a #pragma GCC
>>> visiblilty push(hidden) to all .c files under libstub/, *before* the
>>> #includes. The latter would catch future problems regarding newly
>>> introduced global variables, but it may be a bit overkill in this
>>> case, as libstub is not expected to be in flux in the foreseeable
>>> future.
>>>
>>> Any preferences?
>> Any reason we can't reuse the existing GOT fixup code in the early x86
>> boot code? We're not executing it before the EFI boot stub atm, which is
>> the reason Maarten is hitting these difficulties.
>>
> I guess that is likely to work, I just wasn't aware it existed :-)
> I think adding another visibility(hidden) attribute or 2 would
> complete eliminate the need for GOT fixups, but I guess that is more
> sensitive to compiler versions being recent enough etc.
> The attached (build tested only) patch eliminates all GOT relocations
> under boot/compressed for a 64-bit EFI stub build.
>
>> Maarten, does the following help?
>>
>> If not, Ard please go ahead with option #2 above. Overkill yes, but I've
>> done the single __attribute__() hacks in other projects and someone
>> (usually me) always eventually forgets to tag some instance.
>>
> It appears we just got lucky on arm64, since we don't have any global
> variables, but the issue does exist there as well.
>
FWIW, visibility pushing doesn't seem to work for functions declared with extern.
Following seems to get rid of all GOTPCREL:
---
diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index bd49ec61255c..221da1e53d87 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -298,8 +298,8 @@ int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr);
 int validate_cpu(void);
 
 /* early_serial_console.c */
-extern int early_serial_base;
-void console_init(void);
+extern __attribute__((__visibility__("hidden"))) int early_serial_base;
+__attribute__((__visibility__("hidden"))) void console_init(void);
 
 /* edd.c */
 void query_edd(void);
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 24e3e569a13c..23ac047fd23e 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -30,9 +30,10 @@
 #endif
 
 /* misc.c */
-extern memptr free_mem_ptr;
-extern memptr free_mem_end_ptr;
-extern struct boot_params *real_mode;		/* Pointer to real-mode data */
+extern __attribute__((__visibility__("hidden"))) memptr free_mem_ptr;
+extern __attribute__((__visibility__("hidden"))) memptr free_mem_end_ptr;
+extern __attribute__((__visibility__("hidden"))) struct boot_params *real_mode;		/* Pointer to real-mode data */
+
 void __putstr(const char *s);
 #define error_putstr(__x)  __putstr(__x)
 
@@ -75,7 +76,7 @@ unsigned char *choose_kernel_location(unsigned char *input,
 
 #ifdef CONFIG_EARLY_PRINTK
 /* early_serial_console.c */
-extern int early_serial_base;
+__attribute__((__visibility__("hidden"))) int early_serial_base;
 void console_init(void);
 #else
 static const int early_serial_base;
diff --git a/arch/x86/boot/cpuflags.h b/arch/x86/boot/cpuflags.h
index ea97697e51e4..d01fcf94ece6 100644
--- a/arch/x86/boot/cpuflags.h
+++ b/arch/x86/boot/cpuflags.h
@@ -10,8 +10,8 @@ struct cpu_features {
 	u32 flags[NCAPINTS];
 };
 
-extern struct cpu_features cpu;
-extern u32 cpu_vendor[3];
+__attribute__((visibility("hidden"))) extern struct cpu_features cpu;
+__attribute__((visibility("hidden"))) extern u32 cpu_vendor[3];
 
 int has_eflag(unsigned long mask);
 void get_cpuflags(void);
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 044a2fd3c5fe..8725d85f1903 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -178,7 +178,7 @@ struct efi_config {
 	bool is64;
 } __packed;
 
-extern struct efi_config *efi_early;
+extern __attribute__((visibility("hidden"))) struct efi_config *efi_early;
 
 #define efi_call_early(f, ...)						\
 	efi_early->call(efi_early->f, __VA_ARGS__);

