Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab3CDCpl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 21:45:41 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:47100 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab3CDCpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 21:45:40 -0500
Message-ID: <51340ACD.70904@gmail.com>
Date: Sun, 03 Mar 2013 20:45:33 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ian Campbell <ian.campbell@citrix.com>
CC: xen-devel@lists.xen.org, "Keir (Xen.org)" <keir@xen.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tim Deegan <tim@xen.org>, linux-kernel@vger.kernel.org,
        Jan Beulich <JBeulich@suse.com>, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nico@fluxnic.net>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH LINUX v5] xen: event channel arrays are xen_ulong_t and
 not unsigned long
References: <1361285327.1051.115.camel@zakaz.uk.xensource.com> <1361360886-2956-1-git-send-email-ian.campbell@citrix.com>
In-Reply-To: <1361360886-2956-1-git-send-email-ian.campbell@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 05:48 AM, Ian Campbell wrote:
> On ARM we want these to be the same size on 32- and 64-bit.
> 
> This is an ABI change on ARM. X86 does not change.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Jan Beulich <JBeulich@suse.com>
> Cc: Keir (Xen.org) <keir@xen.org>
> Cc: Tim Deegan <tim@xen.org>
> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: xen-devel@lists.xen.org
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
> Changes since V4
>   Rebase onto v3.8
>   Fix wording of comment
>   Fix bitmask length passed to find_first_bit, need sizeof*8 for bits not just
>   sizeof. Use BITS_PER_EVTCHN_WORD and provide a convenience wrapper.
> Changes since V3
>   s/read_evtchn_pending_sel/xchg_xen_ulong/ in a comment.
> Changes since V2
>   Add comments about the correct bitops to use, and on the ordering/barrier
>   requirements on xchg_xen_ulong.
> Changes since V1
>   use find_first_set not __ffs
>   fix some more unsigned long -> xen_ulong_t
>   use more generic xchg_xen_ulong instead of ...read_evtchn...
> ---
>  arch/arm/include/asm/xen/events.h |   22 +++++++
>  arch/x86/include/asm/xen/events.h |    3 +
>  drivers/xen/events.c              |  115 +++++++++++++++++++++---------------
>  include/xen/interface/xen.h       |    8 +-
>  4 files changed, 96 insertions(+), 52 deletions(-)
> 

I'm seeing some some build failures on randconfig builds with this change:

/tmp/ccJaIZOW.s: Assembler messages:
/tmp/ccJaIZOW.s:831: Error: even register required -- `ldrexd r5,r6,[r4]'

This is with ubuntu 12.04 cross compiler (gcc version 4.6.3
(Ubuntu/Linaro 4.6.3-1ubuntu5)).

This register restriction is on ARM, but not Thumb builds. Comparing
this to atomic64_cmpxchg, I don't see how to fix this. Perhaps Will or
Nico have thoughts.

> diff --git a/arch/arm/include/asm/xen/events.h b/arch/arm/include/asm/xen/events.h
> index 94b4e90..5c27696 100644
> --- a/arch/arm/include/asm/xen/events.h
> +++ b/arch/arm/include/asm/xen/events.h
> @@ -15,4 +15,26 @@ static inline int xen_irqs_disabled(struct pt_regs *regs)
>  	return raw_irqs_disabled_flags(regs->ARM_cpsr);
>  }
>  
> +/*
> + * We cannot use xchg because it does not support 8-byte
> + * values. However it is safe to use {ldr,dtd}exd directly because all
> + * platforms which Xen can run on support those instructions.

Why does atomic64_cmpxchg not work here?

> + */
> +static inline xen_ulong_t xchg_xen_ulong(xen_ulong_t *ptr, xen_ulong_t val)
> +{
> +	xen_ulong_t oldval;
> +	unsigned int tmp;
> +
> +	wmb();

Based on atomic64_cmpxchg implementation, you could use smp_mb here
which avoids an outer cache flush.

> +	asm volatile("@ xchg_xen_ulong\n"
> +		"1:     ldrexd  %0, %H0, [%3]\n"
> +		"       strexd  %1, %2, %H2, [%3]\n"
> +		"       teq     %1, #0\n"
> +		"       bne     1b"
> +		: "=&r" (oldval), "=&r" (tmp)
> +		: "r" (val), "r" (ptr)
> +		: "memory", "cc");

And a smp_mb is needed here.

Rob

> +	return oldval;
> +}

