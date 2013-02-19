Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041Ab3BSRLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:11:51 -0500
Received: from smtp.citrix.com ([66.165.176.89]:44867 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932668Ab3BSRLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:11:50 -0500
X-IronPort-AV: E=Sophos;i="4.84,696,1355097600"; 
   d="scan'208";a="8220652"
Date: Tue, 19 Feb 2013 17:11:46 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <ian.campbell@citrix.com>
CC: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, "Keir (Xen.org)" <keir@xen.org>,
        "Tim (Xen.org)" <tim@xen.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH LINUX] xen: event channel arrays are xen_ulong_t and not
 unsigned long
In-Reply-To: <1361285357-26696-1-git-send-email-ian.campbell@citrix.com>
Message-ID: <alpine.DEB.2.02.1302191642230.4654@kaball.uk.xensource.com>
References: <1361285327.1051.115.camel@zakaz.uk.xensource.com> <1361285357-26696-1-git-send-email-ian.campbell@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2013, Ian Campbell wrote:
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
> ---
> Changes since V1
>   use find_first_set not __ffs
>   fix some more unsigned long -> xen_ulong_t
>   use more generic xchg_xen_ulong instead of ...read_evtchn...
> ---
>  arch/arm/include/asm/xen/events.h |   22 ++++++++
>  arch/x86/include/asm/xen/events.h |    3 +
>  drivers/xen/events.c              |  103 ++++++++++++++++++++-----------------
>  include/xen/interface/xen.h       |    8 ++--
>  4 files changed, 84 insertions(+), 52 deletions(-)

You might have to rebase this patch: it doesn't apply on Linux 3.8.


> diff --git a/arch/arm/include/asm/xen/events.h b/arch/arm/include/asm/xen/events.h
> index 94b4e90..9bb5f50 100644
> --- a/arch/arm/include/asm/xen/events.h
> +++ b/arch/arm/include/asm/xen/events.h
> @@ -15,4 +15,26 @@ static inline int xen_irqs_disabled(struct pt_regs *regs)
>         return raw_irqs_disabled_flags(regs->ARM_cpsr);
>  }
> 
> +/*
> + * We cannot use xchg because it does not support 8-byte
> + * values. However it is safe to use {ldr,dtd}exd directly because all
> + * platforms which Xen can run on support those instructions.
> + */
> +static inline xen_ulong_t xchg_xen_ulong(xen_ulong_t *ptr, xen_ulong_t val)
> +{
> +       xen_ulong_t oldval;
> +       unsigned int tmp;
> +
> +       wmb();
> +       asm volatile("@ read_evtchn_pending_sel\n"
                           ^ do we need this?


> +               "1:     ldrexd  %0, %H0, [%3]\n"
> +               "       strexd  %1, %2, %H2, [%3]\n"
> +               "       teq     %1, #0\n"
> +               "       bne     1b"
> +               : "=&r" (oldval), "=&r" (tmp)
> +               : "r" (val), "r" (ptr)
> +               : "memory", "cc");
> +       return oldval;
> +}
> +
>  #endif /* _ASM_ARM_XEN_EVENTS_H */

[...]

> @@ -1295,18 +1306,14 @@ static void __xen_evtchn_do_upcall(void)
>         unsigned count;
> 
>         do {
> -               unsigned long pending_words;
> +               xen_ulong_t pending_words;
> 
>                 vcpu_info->evtchn_upcall_pending = 0;
> 
>                 if (__this_cpu_inc_return(xed_nesting_count) - 1)
>                         goto out;
> 
> -#ifndef CONFIG_X86 /* No need for a barrier -- XCHG is a barrier on x86. */
> -               /* Clear master flag /before/ clearing selector flag. */
> -               wmb();
> -#endif

Even though I understand that moving wmb() into xchg_xen_ulong gets rid
of an ugly ifndef, I am not sure whether it is a good thing from the
code readability point of view. I'll let Konrad decide on this one.


> -               pending_words = xchg(&vcpu_info->evtchn_pending_sel, 0);
> +               pending_words = xchg_xen_ulong(&vcpu_info->evtchn_pending_sel, 0);
> 
>                 start_word_idx = __this_cpu_read(current_word_idx);
>                 start_bit_idx = __this_cpu_read(current_bit_idx);
> @@ -1314,8 +1321,8 @@ static void __xen_evtchn_do_upcall(void)
>                 word_idx = start_word_idx;
> 
>                 for (i = 0; pending_words != 0; i++) {
> -                       unsigned long pending_bits;
> -                       unsigned long words;
> +                       xen_ulong_t pending_bits;
> +                       xen_ulong_t words;
> 
>                         words = MASK_LSBS(pending_words, word_idx);
> 
> @@ -1327,7 +1334,7 @@ static void __xen_evtchn_do_upcall(void)
>                                 bit_idx = 0;
>                                 continue;
>                         }
> -                       word_idx = __ffs(words);
> +                       word_idx = find_first_bit(BM(&words), sizeof(words));
> 
>                         pending_bits = active_evtchns(cpu, s, word_idx);
>                         bit_idx = 0; /* usually scan entire word from start */

is that because find_first_bit can actually cope with a bit number >=
32 and __ffs can't?
In that case it is worth adding a comment somewhere in this file,
reminding people to only use bit operations that can handle size >
unsigned long

