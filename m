Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbbAPTAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:00:23 -0500
Received: from mail.skyhub.de ([78.46.96.112]:32953 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbbAPTAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:00:22 -0500
Date: Fri, 16 Jan 2015 20:00:18 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 11/23] x86/x2apic: Split enable and setup function
Message-ID: <20150116190018.GK18880@pd.tnic>
References: <20150115210458.625399149@linutronix.de>
 <20150115211703.129287153@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150115211703.129287153@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 09:22:26PM -0000, Thomas Gleixner wrote:
> enable_x2apic() is a convoluted unreadable mess because it is used for
> both enablement in early boot and for setup in cpu_init().
> 
> Split the code into x2apic_enable() for enablement and x2apic_setup()
> for setup of (secondary cpus). Make use of the new state tracking to
> simplify the logic.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---

...

> @@ -1517,6 +1528,21 @@ static int __init setup_nox2apic(char *s
>  }
>  early_param("nox2apic", setup_nox2apic);
>  
> +/* Called from cpu_init() to enable x2apic on (secondary) cpus */
> +void x2apic_setup(void)
> +{
> +	/*
> +	 * If x2apic is not in ON state, disable it if already enabled
> +	 * from BIOS.
> +	 */
> +	if (x2apic_state != X2APIC_ON) {
> +		if (cpu_has_apic)

Let's move this test into disable_x2apic() so that callers don't have to
pay attention.

> +			disable_x2apic();
> +		return;
> +	}
> +	enable_x2apic();
> +}
> +
>  static __init void x2apic_disable(void)
>  {
>  	u64 msr;

...

> Index: tip/arch/x86/kernel/cpu/common.c
> ===================================================================
> --- tip.orig/arch/x86/kernel/cpu/common.c
> +++ tip/arch/x86/kernel/cpu/common.c
> @@ -1332,7 +1332,7 @@ void cpu_init(void)
>  	barrier();
>  
>  	x86_configure_nx();
> -	enable_x2apic();
> +	x2apic_setup();

64-bit only?

I'd guess so since the original call enable_x2apic() is 64-bit only too
but why?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
