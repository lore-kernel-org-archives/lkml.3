Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728Ab3JQTWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 15:22:15 -0400
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:56546 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757861Ab3JQTWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 15:22:14 -0400
Date: Thu, 17 Oct 2013 19:22:12 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] percpu: Add preemption checks to __this_cpu ops
In-Reply-To: <20131016183818.GD3364@laptop.programming.kicks-ass.net>
Message-ID: <00000141c7de3c3e-51b4dd7b-901e-466e-829a-b1f7c4b9ec90-000000@email.amazonses.com>
References: <20131015174722.615394057@linux.com> <20131015174747.813545438@linux.com> <20131016084920.GT10651@twins.programming.kicks-ass.net> <00000141c1d04300-e935e477-6669-4388-8109-c77064ee27e7-000000@email.amazonses.com> <20131016153603.GZ10651@twins.programming.kicks-ass.net>
 <00000141c1fae3ba-6b52fea1-74f9-42f7-b1db-70dda847e7f9-000000@email.amazonses.com> <20131016162537.GB10651@twins.programming.kicks-ass.net> <20131016183818.GD3364@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.10.17-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013, Peter Zijlstra wrote:

> On Wed, Oct 16, 2013 at 06:25:37PM +0200, Peter Zijlstra wrote:
> > To rename __this_cpu to raw_cpu; it would then need a little manual
> > fixup and generic __this_cpu -> raW_cpu map, which can add the
> > preemption check.
>
> Something like so perhaps... only lightly compile tested
> (x86_64-defconfig).

First portion looks good to me on first glance.

> diff --git a/arch/x86/include/asm/preempt.h b/arch/x86/include/asm/preempt.h
> index 8729723..95e3532 100644
> --- a/arch/x86/include/asm/preempt.h
> +++ b/arch/x86/include/asm/preempt.h
> @@ -13,12 +13,12 @@ DECLARE_PER_CPU(int, __preempt_count);
>   */
>  static __always_inline int preempt_count(void)
>  {
> -	return __this_cpu_read_4(__preempt_count) & ~PREEMPT_NEED_RESCHED;
> +	return raw_cpu_read_4(__preempt_count) & ~PREEMPT_NEED_RESCHED;
>  }
>
>  static __always_inline void preempt_count_set(int pc)
>  {
> -	__this_cpu_write_4(__preempt_count, pc);
> +	raw_cpu_write_4(__preempt_count, pc);
>  }

Huh? What happened here? Why do we use the __this_cpu_read_4 here?
This should be just raw_cpu_write()

And more following

> diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
> index d17784e..b5aca54 100644
> --- a/include/asm-generic/percpu.h
> +++ b/include/asm-generic/percpu.h
> @@ -56,17 +56,18 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
>  #define per_cpu(var, cpu) \
>  	(*SHIFT_PERCPU_PTR(&(var), per_cpu_offset(cpu)))
>
> -#ifndef __this_cpu_ptr
> -#define __this_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, __my_cpu_offset)
> +#ifndef raw_cpu_ptr
> +#define raw_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, __my_cpu_offset)
>  #endif


Got another patch here that gets rid of __this_cpu_ptr and uses
raw_cpu_ptr everywhere instead. Would be good to make this all symmetric.


