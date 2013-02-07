Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824Ab3BGLL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 06:11:56 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:46701 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab3BGLLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 06:11:52 -0500
Date: Thu, 7 Feb 2013 12:11:47 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, knoel@redhat.com, chegu_vinod@hp.com,
        raghavendra.kt@linux.vnet.ibm.com, mingo@redhat.com
Subject: Re: [PATCH -v5 5/5] x86,smp: limit spinlock delay on virtual machines
Message-ID: <20130207111147.GE8945@gmail.com>
References: <20130206150311.19cd1e52@cuia.bos.redhat.com>
 <20130206150748.486d7bf8@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130206150748.486d7bf8@cuia.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rik van Riel <riel@redhat.com> wrote:

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

The kernel build will be sad on !SMP configs.

Thanks,

	Ingo
