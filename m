Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab3A1SS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:18:57 -0500
Received: from smtp.citrix.com ([66.165.176.89]:59862 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757658Ab3A1SSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:18:53 -0500
X-IronPort-AV: E=Sophos;i="4.84,553,1355097600"; 
   d="scan'208";a="5353616"
Date: Mon, 28 Jan 2013 18:18:50 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Rik van Riel <riel@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aquini@redhat.com" <aquini@redhat.com>,
        "walken@google.com" <walken@google.com>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "knoel@redhat.com" <knoel@redhat.com>,
        "chegu_vinod@hp.com" <chegu_vinod@hp.com>,
        "raghavendra.kt@linux.vnet.ibm.com" 
	<raghavendra.kt@linux.vnet.ibm.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <xen-devel@lists.xensource.com>, Jan Beulich <JBeulich@novell.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH -v4 5/5] x86,smp: limit spinlock delay on virtual
 machines
In-Reply-To: <20130125141917.6d5960a8@annuminas.surriel.com>
Message-ID: <alpine.DEB.2.02.1301281749460.10432@kaball.uk.xensource.com>
References: <20130125140553.060b8ced@annuminas.surriel.com> <20130125141917.6d5960a8@annuminas.surriel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2013, Rik van Riel wrote:
> Modern Intel and AMD CPUs will trap to the host when the guest
> is spinning on a spinlock, allowing the host to schedule in
> something else.
> 
> This effectively means the host is taking care of spinlock
> backoff for virtual machines. It also means that doing the
> spinlock backoff in the guest anyway can lead to totally
> unpredictable results, extremely large backoffs, and
> performance regressions.
> 
> To prevent those problems, we limit the spinlock backoff
> delay, when running in a virtual machine, to a small value.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
>  arch/x86/include/asm/processor.h |    2 ++
>  arch/x86/kernel/setup.c          |    2 ++
>  arch/x86/kernel/smp.c            |   30 ++++++++++++++++++++++++------
>  3 files changed, 28 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index 888184b..a365f97 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -997,6 +997,8 @@ extern bool cpu_has_amd_erratum(const int *);
>  extern unsigned long arch_align_stack(unsigned long sp);
>  extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
>  
> +extern void init_spinlock_delay(void);
> +
>  void default_idle(void);
>  bool set_pm_idle_to_default(void);
>  
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 23ddd55..b834eae 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -1048,6 +1048,8 @@ void __init setup_arch(char **cmdline_p)
>  
>  	arch_init_ideal_nops();
>  
> +	init_spinlock_delay();
> +
>  	register_refined_jiffies(CLOCK_TICK_RATE);
>  
>  #ifdef CONFIG_EFI
> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> index 1877890..b1a65f0 100644
> --- a/arch/x86/kernel/smp.c
> +++ b/arch/x86/kernel/smp.c
> @@ -31,6 +31,7 @@
>  #include <asm/proto.h>
>  #include <asm/apic.h>
>  #include <asm/nmi.h>
> +#include <asm/hypervisor.h>
>  /*
>   *	Some notes on x86 processor bugs affecting SMP operation:
>   *
> @@ -114,6 +115,27 @@ static atomic_t stopping_cpu = ATOMIC_INIT(-1);
>  static bool smp_no_nmi_ipi = false;
>  
>  /*
> + * Modern Intel and AMD CPUs tell the hypervisor when a guest is
> + * spinning excessively on a spinlock.

I take that you are talking about PAUSE-loop exiting?


> The hypervisor will then
> + * schedule something else, effectively taking care of the backoff
> + * for us. Doing our own backoff on top of the hypervisor's pause
> + * loop exit handling can lead to excessively long delays, and
> + * performance degradations. Limit the spinlock delay in virtual
> + * machines to a smaller value.
> + */
> +#define DELAY_SHIFT 8
> +#define DELAY_FIXED_1 (1<<DELAY_SHIFT)
> +#define MIN_SPINLOCK_DELAY (1 * DELAY_FIXED_1)
> +#define MAX_SPINLOCK_DELAY_NATIVE (16000 * DELAY_FIXED_1)
> +#define MAX_SPINLOCK_DELAY_GUEST (16 * DELAY_FIXED_1)
> +static int __read_mostly max_spinlock_delay = MAX_SPINLOCK_DELAY_NATIVE;
> +void __init init_spinlock_delay(void)
> +{
> +	if (x86_hyper)
> +		max_spinlock_delay = MAX_SPINLOCK_DELAY_GUEST;
> +}

Before reducing max_spinlock_delay, shouldn't we check that PAUSE-loop
exiting is available? What if we are running on an older x86 machine
that doesn't support it?

It is probably worth mentioning in the comment that Xen PV guests cannot
take advantage of PAUSE-loop exiting (they don't run inside a VMX
environment), but that's OK because Xen PV guests don't set x86_hyper.

On the other hand Xen PV on HVM guests can take advantage of it (they
run in a VMX environment), and in fact they set x86_hyper to
x86_hyper_xen_hvm.
