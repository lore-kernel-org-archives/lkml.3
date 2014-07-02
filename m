Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbaGBT1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:27:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50560 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452AbaGBT1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:27:18 -0400
Date: Wed, 2 Jul 2014 21:27:09 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave@sr71.net>
Cc: x86@kernel.org, hpa@zytor.com, qiaowei.ren@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: introduce disabled-features
Message-ID: <20140702192709.GK1318@pd.tnic>
References: <20140702162925.B07A3AB9@viggo.jf.intel.com>
 <20140702162928.B3BBEB26@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140702162928.B3BBEB26@viggo.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 09:29:28AM -0700, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> I believe the REQUIRED_MASK aproach was taken so that it was
> easier to consult in assembly (arch/x86/kernel/verify_cpu.S).
> DISABLED_MASK does not have the same restriction, but I
> implemented it the same way for consistency.
> 
> We have a REQUIRED_MASK... which does two things:
> 1. Keeps a list of cpuid bits to check in very early boot and
>    refuse to boot if those are not present.
> 2. Consulted during cpu_has() checks, which allows us to
>    optimize out things at compile-time.  In other words, if we
>    *KNOW* we will not boot with the feature off, then we can
>    safely assume that it will be present forever.
> 
> But, we don't have a similar mechanism for CPU features which
> may be present but that we know we will not use.  We simply
> use our existing mechanisms to repeatedly check the status of
> the bit at runtime (well, the alternatives patching helps here
> but it does not provide compile-time optimization).
> 
> Adding a feature to disabled-features.h allows the bit to be
> checked via a new macro: cpu_feature_enabled().  Note that
> for features in DISABLED_MASK, checks with this macro have
> all of the benefits of an #ifdef.  Before, we would have done
> this in a header:
> 
> #ifdef CONFIG_X86_INTEL_MPX
> #define cpu_has_mpx cpu_has(X86_FEATURE_MPX)
> #else
> #define cpu_has_mpx 0
> #endif
> 
> and this in the code:
> 
> 	if (cpu_has_mpx)
> 		do_some_mpx_thing();
> 
> Now, just add your feature to DISABLED_MASK and you can do this
> everywhere, and get the same benefits you would have from
> #ifdefs:
> 
> 	if (cpu_feature_enabled(X86_FEATURE_MPX))
> 		do_some_mpx_thing();
> 
> We need a new function and *not* a modification to cpu_has()
> because there are cases where we actually need to check the CPU
> itself, despite what features the kernel supports.  The best
> example of this is a hypervisor which has no control over what
> features its guests are using and where the guest does not depend
> on the host for support.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Acked-by: Borislav Petkov <bp@suse.de>

...

> +/*
> + * Make sure to add features to the correct mask

Hehe, good. :-)

> + */
> +#define DISABLED_MASK0	0
> +#define DISABLED_MASK1	0
> +#define DISABLED_MASK2	0
> +#define DISABLED_MASK3	0
> +#define DISABLED_MASK4	0
> +#define DISABLED_MASK5	0
> +#define DISABLED_MASK6	0
> +#define DISABLED_MASK7	0
> +#define DISABLED_MASK8	0
> +#define DISABLED_MASK9	0
> +
> +#endif /* _ASM_X86_DISABLED_FEATURES_H */
> _
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
