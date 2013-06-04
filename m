Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab3FDVCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 17:02:48 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:61975 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab3FDVCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 17:02:44 -0400
MIME-Version: 1.0
In-Reply-To: <tip-6b3389ac21b5e557b957f1497d0ff22bf733e8c3@git.kernel.org>
References: <20130531150241.GA12006@jshin-Toonie>
	<tip-6b3389ac21b5e557b957f1497d0ff22bf733e8c3@git.kernel.org>
Date: Tue, 4 Jun 2013 14:02:43 -0700
X-Google-Sender-Auth: oUngQumd_ZBiG7iXRuLk4y7OKy4
Message-ID: <CAE9FiQUJOfcoU8c_Xwhosb1=9=dyaH6mXkERX-zxCUmEXjeNUg@mail.gmail.com>
Subject: Re: [tip:x86/microcode] x86, microcode, amd: Fix warnings and errors
 on with CONFIG_MICROCODE=m
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Jacob Shin <jacob.shin@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 2:59 PM, tip-bot for Jacob Shin
<tipbot@zytor.com> wrote:
> Commit-ID:  6b3389ac21b5e557b957f1497d0ff22bf733e8c3
> Gitweb:     http://git.kernel.org/tip/6b3389ac21b5e557b957f1497d0ff22bf733e8c3
> Author:     Jacob Shin <jacob.shin@amd.com>
> AuthorDate: Fri, 31 May 2013 01:53:24 -0500
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Fri, 31 May 2013 13:56:58 -0700
>
> x86, microcode, amd: Fix warnings and errors on with CONFIG_MICROCODE=m
>
> Fix section mismatch warnings on microcode_amd_early.
> Compile error occurs when CONFIG_MICROCODE=m, change so that early
> loading depends on microcode_core.
>
> Reported-by: Yinghai Lu <yinghai@kernel.org>
> Reported-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> Link: http://lkml.kernel.org/r/20130531150241.GA12006@jshin-Toonie
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  arch/x86/Kconfig                      | 2 +-
>  arch/x86/include/asm/microcode_amd.h  | 2 +-
>  arch/x86/kernel/microcode_amd_early.c | 8 ++++----
>  3 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 28dba52..2705532 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1065,7 +1065,7 @@ config MICROCODE_AMD_EARLY
>
>  config MICROCODE_EARLY
>         bool "Early load microcode"
> -       depends on (MICROCODE_INTEL || MICROCODE_AMD) && BLK_DEV_INITRD
> +       depends on MICROCODE=y && BLK_DEV_INITRD
>         select MICROCODE_INTEL_EARLY if MICROCODE_INTEL
>         select MICROCODE_AMD_EARLY if MICROCODE_AMD
>         default y
> diff --git a/arch/x86/include/asm/microcode_amd.h b/arch/x86/include/asm/microcode_amd.h
> index 24254aa..c6b043f 100644
> --- a/arch/x86/include/asm/microcode_amd.h
> +++ b/arch/x86/include/asm/microcode_amd.h
> @@ -64,7 +64,7 @@ extern enum ucode_state load_microcode_amd(int cpu, const u8 *data, size_t size)
>  #ifdef CONFIG_MICROCODE_AMD_EARLY
>  #ifdef CONFIG_X86_32
>  #define MPB_MAX_SIZE PAGE_SIZE
> -extern u8 __cpuinitdata amd_bsp_mpb[MPB_MAX_SIZE];
> +extern u8 amd_bsp_mpb[MPB_MAX_SIZE];
>  #endif
>  extern void __init load_ucode_amd_bsp(void);
>  extern void __cpuinit load_ucode_amd_ap(void);
> diff --git a/arch/x86/kernel/microcode_amd_early.c b/arch/x86/kernel/microcode_amd_early.c
> index 7e54d97..9618805 100644
> --- a/arch/x86/kernel/microcode_amd_early.c
> +++ b/arch/x86/kernel/microcode_amd_early.c
> @@ -21,9 +21,9 @@ static u32 ucode_new_rev;
>   * Microcode patch container file is prepended to the initrd in cpio format.
>   * See Documentation/x86/early-microcode.txt
>   */
> -static __initdata char ucode_path[] = "kernel/x86/microcode/AuthenticAMD.bin";
> +static __cpuinitdata char ucode_path[] = "kernel/x86/microcode/AuthenticAMD.bin";
>
> -static struct cpio_data __init find_ucode_in_initrd(void)
> +static struct cpio_data __cpuinit find_ucode_in_initrd(void)
>  {
>         long offset = 0;
>         struct cpio_data cd;

does not like right fix.

find_ucode_in_initrd should be __init.

> @@ -62,7 +62,7 @@ static struct cpio_data __init find_ucode_in_initrd(void)
>   * load_microcode_amd() to save equivalent cpu table and microcode patches in
>   * kernel heap memory.
>   */
> -static void __init apply_ucode_in_initrd(void)
> +static void __cpuinit apply_ucode_in_initrd(void)
>  {
>         struct cpio_data cd;
>         struct equiv_cpu_entry *eq;

it should not call find_ucode_in_initrd or
it should be __init.

> @@ -133,7 +133,7 @@ void __init load_ucode_amd_bsp(void)
>  }
>
>  #ifdef CONFIG_X86_32
> -u8 __cpuinitdata amd_bsp_mpb[MPB_MAX_SIZE];
> +u8 amd_bsp_mpb[MPB_MAX_SIZE];
>
>  /*
>   * On 32-bit, since AP's early load occurs before paging is turned on, we
