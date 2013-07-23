Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986Ab3GWNcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 09:32:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53326 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932548Ab3GWNcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 09:32:48 -0400
Date: Tue, 23 Jul 2013 15:32:43 +0200
From: Borislav Petkov <bp@alien8.de>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]Fix boot hang in 3.11-rc1/2 because of bug in AMD errata
 check
Message-ID: <20130723133243.GE8497@pd.tnic>
References: <20130723134829.25251b01@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130723134829.25251b01@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Basically this patch looks ok, just a couple of nitpicks/comments.

Please change the subject to something more meaningful like

"x86, AMD: Make cpu_has_amd_erratum use currect cpuinfo descriptor" or
so.

On Tue, Jul 23, 2013 at 01:48:29PM +0200, Torsten Kaiser wrote:
> cpu_has_amd_erratum() is buggy, because it uses the per-cpu cpu_info
> before it is filled by smp_store_boot_cpu_info() / smp_store_cpu_info().
> 
> If early microcode loading is enabled its collect_cpu_info_amd_early() will
> fill ->x86 and so the fallback to boot_cpu_data is not used.
> But ->x86_vendor was not filled and is still 0 == X86_VENDOR_INTEL resulting in 
> no errata fixes getting applied and my system hangs on boot.
> 
> Using cpu_info in cpu_has_amd_erratum() is wrong anyway: Its only caller
> init_amd() will have a struct cpuinfo_x86 as parameter and the set_cpu_bug()
> that is controlled by cpu_has_amd_erratum() also only uses that struct.
> 
> So pass the struct cpuinfo_x86 from init_amd() to cpu_has_amd_erratum() and
> the broken fallback can be dropped.
> 
> I also turned the vendor check into an BUG_ON() because init_amd() can only
> be used by AMD CPUs and if the current failure hadn't been silent this bug
> would have been much more obvious.

BUG_ON is kinda heavy-handed here, a WARN_ON should be fine.

Other than that, I like the commit message: it explains the whole deal
in a very detailed manner and I'd wish more commit messages on lkml
would be like that. Good job!

> Signed-off-by: Torsten Kaiser <just.for.lkml@googlemail.com>
> 
> --- a/arch/x86/kernel/cpu/amd.c	2013-07-22 06:33:10.027931005 +0200
> +++ b/arch/x86/kernel/cpu/amd.c	2013-07-22 06:35:15.757931265 +0200
> @@ -512,7 +512,7 @@ static void early_init_amd(struct cpuinf
>  
>  static const int amd_erratum_383[];
>  static const int amd_erratum_400[];
> -static bool cpu_has_amd_erratum(const int *erratum);
> +static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum);
>  
>  static void init_amd(struct cpuinfo_x86 *c)
>  {
> @@ -729,11 +729,11 @@ static void init_amd(struct cpuinfo_x86
>  		value &= ~(1ULL << 24);
>  		wrmsrl_safe(MSR_AMD64_BU_CFG2, value);
>  
> -		if (cpu_has_amd_erratum(amd_erratum_383))
> +		if (cpu_has_amd_erratum(c, amd_erratum_383))
>  			set_cpu_bug(c, X86_BUG_AMD_TLB_MMATCH);
>  	}
>  
> -	if (cpu_has_amd_erratum(amd_erratum_400))
> +	if (cpu_has_amd_erratum(c, amd_erratum_400))
>  		set_cpu_bug(c, X86_BUG_AMD_APIC_C1E);
>  
>  	rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
> @@ -878,22 +878,15 @@ static const int amd_erratum_400[] =
>  static const int amd_erratum_383[] =
>  	AMD_OSVW_ERRATUM(3, AMD_MODEL_RANGE(0x10, 0, 0, 0xff, 0xf));
>  
> -static bool cpu_has_amd_erratum(const int *erratum)
> +
> +static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum)
>  {
> -	struct cpuinfo_x86 *cpu = __this_cpu_ptr(&cpu_info);
>  	int osvw_id = *erratum++;
>  	u32 range;
>  	u32 ms;
>  
> -	/*
> -	 * If called early enough that current_cpu_data hasn't been initialized
> -	 * yet, fall back to boot_cpu_data.
> -	 */
> -	if (cpu->x86 == 0)
> -		cpu = &boot_cpu_data;
> -
> -	if (cpu->x86_vendor != X86_VENDOR_AMD)
> -		return false;
> +	/* Should never be called on non-AMD-CPUs */
> +	BUG_ON(cpu->x86_vendor != X86_VENDOR_AMD);
>  
>  	if (osvw_id >= 0 && osvw_id < 65536 &&
>  	    cpu_has(cpu, X86_FEATURE_OSVW)) {
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
