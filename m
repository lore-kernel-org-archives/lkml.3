Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318AbaD3IvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:51:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:34759 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbaD3Iu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:50:57 -0400
Date: Wed, 30 Apr 2014 10:50:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Wang, Xiaoming" <xiaoming.wang@intel.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Subject: Re: [PATCH] lib/spinlock_debug: Tweak the loop time to fit different
 _delay()
Message-ID: <20140430085054.GD30445@twins.programming.kicks-ass.net>
References: <1398897638.21870.8.camel@wxm-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398897638.21870.8.camel@wxm-ubuntu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 06:40:38PM -0400, Wang, Xiaoming wrote:
> loops_per_jiffy*Hz  is not always 1 second exactly
> it depends on the realization of _delay() .
> delay_tsc is used as _delay() in arch/x86/lib/delay.c
> It makes loop loops_per_jiffy larger than exception
> and causes one thread can not obtain the spin lock for
> a long time which may trigger HARD LOCKUP in this case.
> So we use cpu_clock() which is more accurate.
> 
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>
> ---
>  kernel/locking/spinlock_debug.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/locking/spinlock_debug.c b/kernel/locking/spinlock_debug.c
> index 0374a59..471d26c 100644
> --- a/kernel/locking/spinlock_debug.c
> +++ b/kernel/locking/spinlock_debug.c
> @@ -105,10 +105,13 @@ static inline void debug_spin_unlock(raw_spinlock_t *lock)
>  
>  static void __spin_lock_debug(raw_spinlock_t *lock)
>  {
> -	u64 i;
> -	u64 loops = loops_per_jiffy * HZ;
> +	u64 t;
> +	u64 one_second = 1000000000;
> +	u32 this_cpu = raw_smp_processor_id();
> +
> +	t = cpu_clock(this_cpu);
>  
> -	for (i = 0; i < loops; i++) {
> +	while (cpu_clock(this_cpu) - t < one_second) {
>  		if (arch_spin_trylock(&lock->raw_lock))
>  			return;
>  		__delay(1);

Yep, and now you've broken support for archs that fall back to jiffies
for cpu_clock :-), jiffies need not progress if you've got IRQs
disabled.
