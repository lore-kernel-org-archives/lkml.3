Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbbAPTBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:01:32 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49524 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755423AbbAPTBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:01:30 -0500
Date: Fri, 16 Jan 2015 20:01:26 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 10/23] x86/x2apic: Disable x2apic from nox2apic setup
Message-ID: <20150116190126.GL18880@pd.tnic>
References: <20150115210458.625399149@linutronix.de>
 <20150115211703.051214090@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150115211703.051214090@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 09:22:24PM -0000, Thomas Gleixner wrote:
> There is no point in postponing the hardware disablement of x2apic. It
> can be disabled right away in the nox2apic setup function.
> 
> Disable it right away and set the state to DISABLED . This allows to
> remove all the nox2apic conditionals all over the place.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---

...

> @@ -1488,6 +1484,19 @@ enum {
>  };
>  static int x2apic_state;
>  
> +static inline void disable_x2apic(void)
> +{
> +	u64 msr;
> +
> +	rdmsrl(MSR_IA32_APICBASE, msr);
> +	if (!(msr & X2APIC_ENABLE))
> +		return;
> +	/* Disable xapic and x2apic first and then reenable xapic mode */
> +	wrmsrl(MSR_IA32_APICBASE, msr & ~(X2APIC_ENABLE | XAPIC_ENABLE));
> +	wrmsrl(MSR_IA32_APICBASE, msr & ~X2APIC_ENABLE);
> +	printk_once(KERN_INFO "x2apic disabled\n");
> +}
> +
>  static int __init setup_nox2apic(char *str)
>  {
>  	if (x2apic_enabled()) {
> @@ -1498,28 +1507,17 @@ static int __init setup_nox2apic(char *s
>  				   apicid);
>  			return 0;
>  		}
> -
> -		pr_warning("x2apic already enabled. will disable it\n");
> -	} else
> -		setup_clear_cpu_cap(X86_FEATURE_X2APIC);
> -
> -	nox2apic = true;
> +		pr_warning("x2apic already enabled.\n");
> +		disable_x2apic();
> +	}
> +	setup_clear_cpu_cap(X86_FEATURE_X2APIC);
>  	x2apic_state = X2APIC_DISABLED;
> +	x2apic_mode = 0;
>  	return 0;
>  }
>  early_param("nox2apic", setup_nox2apic);
>  
> -/*
> - * Need to disable xapic and x2apic at the same time and then enable xapic mode
> - */
> -static inline void __disable_x2apic(u64 msr)
> -{
> -	wrmsrl(MSR_IA32_APICBASE,
> -	       msr & ~(X2APIC_ENABLE | XAPIC_ENABLE));
> -	wrmsrl(MSR_IA32_APICBASE, msr & ~X2APIC_ENABLE);
> -}
> -
> -static __init void disable_x2apic(void)
> +static __init void x2apic_disable(void)

This is still misleading: we have x2apic_disable() and disable_x2apic().
What is what? Can we clarify them more and maybe prepend one of them
with "__" to show which is the lower level helper...

Or is the logic that all functions beginning with the "x2apic_" prefix
are called from outside and the "enable_/disable_x2apic" ones are the
internal helpers?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
