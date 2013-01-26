Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab3AZMAv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 07:00:51 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:59979 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab3AZMAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 07:00:47 -0500
Date: Sat, 26 Jan 2013 13:00:43 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        eric.dumazet@gmail.com, lwoodman@redhat.com, knoel@redhat.com,
        chegu_vinod@hp.com, raghavendra.kt@linux.vnet.ibm.com,
        mingo@redhat.com
Subject: Re: [PATCH -v4 5/5] x86,smp: limit spinlock delay on virtual machines
Message-ID: <20130126120043.GB13445@gmail.com>
References: <20130125140553.060b8ced@annuminas.surriel.com>
 <20130125141917.6d5960a8@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125141917.6d5960a8@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rik van Riel <riel@redhat.com> wrote:

>  static bool smp_no_nmi_ipi = false;
>  
>  /*
> + * Modern Intel and AMD CPUs tell the hypervisor when a guest is
> + * spinning excessively on a spinlock. The hypervisor will then
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

I realize that you took existing code and extended it, but that 
chunk of code looks pretty disgusting visually now - at minimum 
it should be vertically aligned as most other kernel code does.

The comment should also tell that the unit of these values is 
'spinlock-op loops' or so.

Thanks,

	Ingo
