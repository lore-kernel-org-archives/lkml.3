Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab3BGLZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 06:25:58 -0500
Received: from smtp.citrix.com ([66.165.176.89]:53542 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab3BGLZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 06:25:57 -0500
X-IronPort-AV: E=Sophos;i="4.84,621,1355097600"; 
   d="scan'208";a="6622245"
Date: Thu, 7 Feb 2013 11:25:51 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Rik van Riel <riel@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aquini@redhat.com" <aquini@redhat.com>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "knoel@redhat.com" <knoel@redhat.com>,
        "chegu_vinod@hp.com" <chegu_vinod@hp.com>,
        "raghavendra.kt@linux.vnet.ibm.com" 
	<raghavendra.kt@linux.vnet.ibm.com>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: [PATCH -v5 5/5] x86,smp: limit spinlock delay on virtual
 machines
In-Reply-To: <20130206150748.486d7bf8@cuia.bos.redhat.com>
Message-ID: <alpine.DEB.2.02.1302071122440.4275@kaball.uk.xensource.com>
References: <20130206150311.19cd1e52@cuia.bos.redhat.com> <20130206150748.486d7bf8@cuia.bos.redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2013, Rik van Riel wrote:
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
>  arch/x86/kernel/cpu/hypervisor.c |    2 ++
>  arch/x86/kernel/smp.c            |   21 +++++++++++++++++++--
>  3 files changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index 888184b..4118fd8 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -997,6 +997,8 @@ extern bool cpu_has_amd_erratum(const int *);
>  extern unsigned long arch_align_stack(unsigned long sp);
>  extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
>  
> +extern void init_guest_spinlock_delay(void);
> +
>  void default_idle(void);
>  bool set_pm_idle_to_default(void);
>  
> diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
> index a8f8fa9..4a53724 100644
> --- a/arch/x86/kernel/cpu/hypervisor.c
> +++ b/arch/x86/kernel/cpu/hypervisor.c
> @@ -76,6 +76,8 @@ void __init init_hypervisor_platform(void)
>  
>  	init_hypervisor(&boot_cpu_data);
>  
> +	init_guest_spinlock_delay();
> +
>  	if (x86_hyper->init_platform)
>  		x86_hyper->init_platform();
>  }
> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> index 64e33ef..fbc5ff3 100644
> --- a/arch/x86/kernel/smp.c
> +++ b/arch/x86/kernel/smp.c
> @@ -116,8 +116,25 @@ static bool smp_no_nmi_ipi = false;
>  #define DELAY_SHIFT			8
>  #define DELAY_FIXED_1			(1<<DELAY_SHIFT)
>  #define MIN_SPINLOCK_DELAY		(1 * DELAY_FIXED_1)
> -#define MAX_SPINLOCK_DELAY		(16000 * DELAY_FIXED_1)
> +#define MAX_SPINLOCK_DELAY_NATIVE	(16000 * DELAY_FIXED_1)
> +#define MAX_SPINLOCK_DELAY_GUEST	(16 * DELAY_FIXED_1)
>  #define DELAY_HASH_SHIFT		6
> +
> +/*
> + * Modern Intel and AMD CPUs tell the hypervisor when a guest is
> + * spinning excessively on a spinlock. The hypervisor will then
> + * schedule something else, effectively taking care of the backoff
> + * for us. Doing our own backoff on top of the hypervisor's pause
> + * loop exit handling can lead to excessively long delays, and
> + * performance degradations. Limit the spinlock delay in virtual
> + * machines to a smaller value. Called from init_hypervisor_platform 
> + */
> +static int __read_mostly max_spinlock_delay = MAX_SPINLOCK_DELAY_NATIVE;
> +void __init init_guest_spinlock_delay(void)
> +{
> +	max_spinlock_delay = MAX_SPINLOCK_DELAY_GUEST;
> +}
> +

Same comment as last time:

"""
Before reducing max_spinlock_delay, shouldn't we check that PAUSE-loop
exiting is available? What if we are running on an older x86 machine
that doesn't support it?
"""
