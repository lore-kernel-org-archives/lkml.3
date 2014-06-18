Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbaFRRVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 13:21:18 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57712 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaFRRVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 13:21:16 -0400
Date: Wed, 18 Jun 2014 19:21:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Qiaowei Ren <qiaowei.ren@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 03/10] x86, mpx: add macro cpu_has_mpx
Message-ID: <20140618172111.GJ24024@pd.tnic>
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com>
 <1403084656-27284-4-git-send-email-qiaowei.ren@intel.com>
 <20140618095739.GA24419@pd.tnic>
 <53A1A3A5.9010109@intel.com>
 <53A1A942.1090001@zytor.com>
 <53A1BD95.10701@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53A1BD95.10701@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 09:25:57AM -0700, Dave Hansen wrote:
> On 06/18/2014 07:59 AM, H. Peter Anvin wrote:
> > On 06/18/2014 07:35 AM, Dave Hansen wrote:
> >> It looks like static_cpu_has() is the right thing to use instead of
> >> boot_cpu_has().  But, this doesn't just obfuscate things.
> >>
> >> We actually _want_ the compiler to cull code out when the config option
> >> is off.  Things like do_bounds() will see code savings with _some_ kind
> >> of #ifdef rather than using static_cpu_has().
> >>
> >> So, we can either use the well worn, consistent with other features in
> >> x86, cpu_has_$foo approach.  Or, we can roll our own macros.
> > 
> > We could do something like:
> > 
> > #define MPX_ENABLED (IS_ENABLED(CONFIG_X86_MPX) &&
> > static_cpu_has(X86_FEATURE_MPX))
> 
> How about something like the attached patch?
> 
> This lets us use static_cpu_has() for the checks, and allows us to
> easily add new checks for other features that might be compile-time
> disabled.

> 
> 
> ---
> 
>  b/arch/x86/include/asm/cpufeature.h |   26 ++++++++++++++++++++------
>  b/arch/x86/kernel/mpx.c             |    4 ++--
>  b/arch/x86/kernel/traps.c           |    2 +-
>  3 files changed, 23 insertions(+), 9 deletions(-)
> 
> diff -puN arch/x86/include/asm/cpufeature.h~x86-disabled_mask arch/x86/include/asm/cpufeature.h
> --- a/arch/x86/include/asm/cpufeature.h~x86-disabled_mask	2014-06-18 08:48:41.329750895 -0700
> +++ b/arch/x86/include/asm/cpufeature.h	2014-06-18 09:19:19.143546973 -0700
> @@ -339,12 +339,6 @@ extern const char * const x86_power_flag
>  #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
>  #define cpu_has_topoext		boot_cpu_has(X86_FEATURE_TOPOEXT)
>  
> -#ifdef CONFIG_X86_INTEL_MPX
> -#define cpu_has_mpx boot_cpu_has(X86_FEATURE_MPX)
> -#else
> -#define cpu_has_mpx 0
> -#endif /* CONFIG_X86_INTEL_MPX */
> -
>  #ifdef CONFIG_X86_64
>  
>  #undef  cpu_has_vme
> @@ -367,6 +361,22 @@ extern const char * const x86_power_flag
>  
>  #endif /* CONFIG_X86_64 */
>  
> +/*
> + * Add features and their corresponding config options here
> + * if you want to have the compiler optimize out code that
> + * uses them.
> + *
> + * You should not use this function directly.  Use
> + * static_cpu_has() so that you also benefit from alternatives
> + * when the features are enabled.
> + */
> +static __always_inline int __cpu_feature_compile_enabled(u16 bit)
> +{
> +	if (bit == X86_FEATURE_MPX)
> +		return IS_ENABLED(CONFIG_X86_MPX);

Right, this should be CONFIG_X86_INTEL_MPX but that's details.

I guess this might grow into a big if-else noodle case but when that
happens, we probably could add some sort of mapping between X86_FEATURE
bits to CONFIG_ items or so.

Then, you could probably add this call to the enclosing macros
static_cpu_has{,_safe} so that it gets evaluated first. The advantage is
that the IS_ENABLED test would work very early - always, actually - even
before alternatives have run and thus catch the cases where the feature
is config-disabled.

Otherwise, asm looks ok.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
