Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760951Ab3EALPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 07:15:33 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:35800 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760530Ab3EALP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 07:15:26 -0400
Date: Wed, 1 May 2013 13:15:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Andrew Lutomirski <luto@mit.edu>
Subject: Re: [PATCH v5] x86: Enable fast strings on Intel if BIOS hasn't
 already
Message-ID: <20130501111522.GA19159@gmail.com>
References: <3cdeaedaa41e258e8aa9ca83d79a936e0b9462bc.1367385613.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cdeaedaa41e258e8aa9ca83d79a936e0b9462bc.1367385613.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@amacapital.net> wrote:

> From: Andrew Lutomirski <luto@mit.edu>
> 
> Intel SDM volume 3A, 8.4.2 says:
> 
>   Software can disable fast-string operation by clearing the
>   fast-string-enable bit (bit 0) of IA32_MISC_ENABLE MSR.
>   However, Intel recomments that system software always enable
>   fast-string operation.
> 
> The Intel DQ67SW board (with latest BIOS) disables fast string
> operations if TXT is enabled.  A Lenovo X220 disables it regardless
> of TXT setting.  I doubt I'm the only person with a dumb BIOS like
> this.

Hm, I think we could try this.

Do we know whether Windows enables it? Most laptop vendors will 
test/certify on Windows, so that's the 'expected' environment.

> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
> 
> v4 was a almost two years ago, but I just noticed that this is still a problem.
> This is tested on v3.9.
> 
> https://patchwork.kernel.org/patch/1073972/
> 
> This is identical to v4 of this patch except that it uses wrmsrl_safe instead
> of wrmsr_safe.
> 
>  arch/x86/kernel/cpu/intel.c | 27 ++++++++++++++++++++++-----
>  1 file changed, 22 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index 1905ce9..a4a3ef2 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -29,6 +29,7 @@
>  static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
>  {
>  	u64 misc_enable;
> +	bool allow_fast_string = true;
>  
>  	/* Unmask CPUID levels if masked: */
>  	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
> @@ -119,10 +120,11 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
>  	 * (model 2) with the same problem.
>  	 */
>  	if (c->x86 == 15) {
> -		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
> +		allow_fast_string = false;
>  
> +		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
>  		if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING) {
> -			printk(KERN_INFO "kmemcheck: Disabling fast string operations\n");
> +			printk_once(KERN_INFO "kmemcheck: Disabling fast string operations\n");
>  
>  			misc_enable &= ~MSR_IA32_MISC_ENABLE_FAST_STRING;
>  			wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
> @@ -131,13 +133,28 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
>  #endif
>  
>  	/*
> -	 * If fast string is not enabled in IA32_MISC_ENABLE for any reason,
> -	 * clear the fast string and enhanced fast string CPU capabilities.
> +	 * If BIOS didn't enable fast string operation, try to enable
> +	 * it ourselves.  If that fails, then clear the fast string
> +	 * and enhanced fast string CPU capabilities.
>  	 */
>  	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
>  		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
> +
> +		if (allow_fast_string &&
> +		    !(misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING)) {
> +			misc_enable |= MSR_IA32_MISC_ENABLE_FAST_STRING;
> +			wrmsrl_safe(MSR_IA32_MISC_ENABLE, misc_enable);
> +
> +			/* Re-read to make sure it stuck. */
> +			rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
> +
> +			if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING)
> +				printk_once(KERN_INFO FW_WARN "IA32_MISC_ENABLE.FAST_STRING_ENABLE was not set\n");
> +		}
> +
>  		if (!(misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING)) {
> -			printk(KERN_INFO "Disabled fast string operations\n");
> +			if (allow_fast_string)
> +				printk_once(KERN_INFO "Failed to enable fast string operations\n");
>  			setup_clear_cpu_cap(X86_FEATURE_REP_GOOD);
>  			setup_clear_cpu_cap(X86_FEATURE_ERMS);

I think we should also printk if we enabled it against the BIOS setting - 
so that if the user sees any problems it can possibly be tracked back to 
this change ...

I.e. stay silent if the BIOS has it enabled already - but otherwise 
document our action.

Thanks,

	Ingo
