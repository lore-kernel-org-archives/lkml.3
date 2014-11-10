Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaKJMN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:13:57 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:56882 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbaKJMN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:13:56 -0500
Date: Mon, 10 Nov 2014 13:13:49 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        akpm@linux-foundation.org, mingo@redhat.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] irqflags: fix (at least latent) code generation issue
Message-ID: <20141110121349.GA21120@gmail.com>
References: <54589AFA0200007800044A77@mail.emea.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54589AFA0200007800044A77@mail.emea.novell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@suse.com> wrote:

> The conditional in local_irq_restore() otherwise can cause code bloat
> (the if and else blocks may get translated into separate code paths
> despite the generated code being identical, dependent on compiler
> internal heuristics). Note that this adjustment gets the code in sync
> with the comment preceding it (which was slightly wrong from at least
> from 2.6.37 onwards).
> 
> The code bloat was observed in reality with an experimental x86 patch
> I'm about to post as RFC.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> ---
>  include/linux/irqflags.h |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- 3.18-rc3/include/linux/irqflags.h
> +++ 3.18-rc3-irqflags/include/linux/irqflags.h
> @@ -85,7 +85,7 @@
>   * The local_irq_*() APIs are equal to the raw_local_irq*()
>   * if !TRACE_IRQFLAGS.
>   */
> -#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
> +#ifdef CONFIG_TRACE_IRQFLAGS
>  #define local_irq_enable() \
>  	do { trace_hardirqs_on(); raw_local_irq_enable(); } while (0)
>  #define local_irq_disable() \
> @@ -131,7 +131,7 @@
>  	} while (0)
>  
>  
> -#else /* !CONFIG_TRACE_IRQFLAGS_SUPPORT */
> +#else /* !CONFIG_TRACE_IRQFLAGS */
>  
>  #define local_irq_enable()	do { raw_local_irq_enable(); } while (0)
>  #define local_irq_disable()	do { raw_local_irq_disable(); } while (0)
> @@ -145,6 +145,6 @@
>  #define irqs_disabled_flags(flags) (raw_irqs_disabled_flags(flags))
>  #define safe_halt()		do { raw_safe_halt(); } while (0)
>  
> -#endif /* CONFIG_TRACE_IRQFLAGS_SUPPORT */
> +#endif /* CONFIG_TRACE_IRQFLAGS */

So this breaks a couple of non-x86 architectures, such as MIPS:

/home/mingo/tip/include/acpi/platform/aclinuxex.h: In function 'acpi_os_allocate':
/home/mingo/tip/include/acpi/platform/aclinuxex.h:86: error: implicit declaration of function 'arch_irqs_disabled'

Thanks,

	Ingo
