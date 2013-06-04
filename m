Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039Ab3FDHRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 03:17:13 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:47316 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759884Ab3FDHRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 03:17:03 -0400
Message-ID: <51AD9563.5020404@linux.vnet.ibm.com>
Date: Tue, 04 Jun 2013 12:51:07 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: stefan.bader@canonical.com, gleb@redhat.com, mingo@redhat.com,
        jeremy@goop.org, x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        linux-doc@vger.kernel.org, habanero@linux.vnet.ibm.com,
        xen-devel@lists.xensource.com, peterz@infradead.org,
        mtosatti@redhat.com, stefano.stabellini@eu.citrix.com,
        andi@firstfloor.org, attilio.rao@citrix.com, ouyang@cs.pitt.edu,
        gregkh@suse.de, agraf@suse.de, chegu_vinod@hp.com,
        torvalds@linux-foundation.org, avi.kivity@gmail.com,
        tglx@linutronix.de, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stephan.diestelhorst@amd.com, riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V9 5/19]  xen/pvticketlock: Xen implementation for
 PV ticket locks
References: <20130601192125.5966.35563.sendpatchset@codeblue> <20130601192314.5966.71330.sendpatchset@codeblue> <20130603160316.GG4224@phenom.dumpdata.com>
In-Reply-To: <20130603160316.GG4224@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060407-7014-0000-0000-0000031D4C54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 09:33 PM, Konrad Rzeszutek Wilk wrote:
> On Sat, Jun 01, 2013 at 12:23:14PM -0700, Raghavendra K T wrote:
>> xen/pvticketlock: Xen implementation for PV ticket locks
>>
>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> Replace the old Xen implementation of PV spinlocks with and implementation
>> of xen_lock_spinning and xen_unlock_kick.
>>
>> xen_lock_spinning simply registers the cpu in its entry in lock_waiting,
>> adds itself to the waiting_cpus set, and blocks on an event channel
>> until the channel becomes pending.
>>
>> xen_unlock_kick searches the cpus in waiting_cpus looking for the one
>> which next wants this lock with the next ticket, if any.  If found,
>> it kicks it by making its event channel pending, which wakes it up.
>>
>> We need to make sure interrupts are disabled while we're relying on the
>> contents of the per-cpu lock_waiting values, otherwise an interrupt
>> handler could come in, try to take some other lock, block, and overwrite
>> our values.
>>
>> Raghu: use function + enum instead of macro, cmpxchg for zero status reset
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
>> ---
>>   arch/x86/xen/spinlock.c |  347 +++++++++++------------------------------------
>>   1 file changed, 78 insertions(+), 269 deletions(-)
>>
>> diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
>> index d6481a9..860e190 100644
>> --- a/arch/x86/xen/spinlock.c
>> +++ b/arch/x86/xen/spinlock.c
>> @@ -16,45 +16,44 @@
>>   #include "xen-ops.h"
>>   #include "debugfs.h"
>>
>> -#ifdef CONFIG_XEN_DEBUG_FS
>> -static struct xen_spinlock_stats
>> -{
>> -	u64 taken;
>> -	u32 taken_slow;
>> -	u32 taken_slow_nested;
>> -	u32 taken_slow_pickup;
>> -	u32 taken_slow_spurious;
>> -	u32 taken_slow_irqenable;
>> +enum xen_contention_stat {
>> +	TAKEN_SLOW,
>> +	TAKEN_SLOW_PICKUP,
>> +	TAKEN_SLOW_SPURIOUS,
>> +	RELEASED_SLOW,
>> +	RELEASED_SLOW_KICKED,
>> +	NR_CONTENTION_STATS
>> +};
>>
>> -	u64 released;
>> -	u32 released_slow;
>> -	u32 released_slow_kicked;
>>
>> +#ifdef CONFIG_XEN_DEBUG_FS
>>   #define HISTO_BUCKETS	30
>> -	u32 histo_spin_total[HISTO_BUCKETS+1];
>> -	u32 histo_spin_spinning[HISTO_BUCKETS+1];
>> +static struct xen_spinlock_stats
>> +{
>> +	u32 contention_stats[NR_CONTENTION_STATS];
>>   	u32 histo_spin_blocked[HISTO_BUCKETS+1];
>> -
>> -	u64 time_total;
>> -	u64 time_spinning;
>>   	u64 time_blocked;
>>   } spinlock_stats;
>>
>>   static u8 zero_stats;
>>
>> -static unsigned lock_timeout = 1 << 10;
>> -#define TIMEOUT lock_timeout
>> -
>>   static inline void check_zero(void)
>>   {
>> -	if (unlikely(zero_stats)) {
>> -		memset(&spinlock_stats, 0, sizeof(spinlock_stats));
>> -		zero_stats = 0;
>> +	u8 ret;
>> +	u8 old = ACCESS_ONCE(zero_stats);
>> +	if (unlikely(old)) {
>> +		ret = cmpxchg(&zero_stats, old, 0);
>> +		/* This ensures only one fellow resets the stat */
>> +		if (ret == old)
>> +			memset(&spinlock_stats, 0, sizeof(spinlock_stats));
>>   	}
>>   }
>>
>> -#define ADD_STATS(elem, val)			\
>> -	do { check_zero(); spinlock_stats.elem += (val); } while(0)
>> +static inline void add_stats(enum xen_contention_stat var, u32 val)
>> +{
>> +	check_zero();
>> +	spinlock_stats.contention_stats[var] += val;
>> +}
>>
>>   static inline u64 spin_time_start(void)
>>   {
>> @@ -73,22 +72,6 @@ static void __spin_time_accum(u64 delta, u32 *array)
>>   		array[HISTO_BUCKETS]++;
>>   }
>>
>> -static inline void spin_time_accum_spinning(u64 start)
>> -{
>> -	u32 delta = xen_clocksource_read() - start;
>> -
>> -	__spin_time_accum(delta, spinlock_stats.histo_spin_spinning);
>> -	spinlock_stats.time_spinning += delta;
>> -}
>> -
>> -static inline void spin_time_accum_total(u64 start)
>> -{
>> -	u32 delta = xen_clocksource_read() - start;
>> -
>> -	__spin_time_accum(delta, spinlock_stats.histo_spin_total);
>> -	spinlock_stats.time_total += delta;
>> -}
>> -
>>   static inline void spin_time_accum_blocked(u64 start)
>>   {
>>   	u32 delta = xen_clocksource_read() - start;
>> @@ -98,19 +81,15 @@ static inline void spin_time_accum_blocked(u64 start)
>>   }
>>   #else  /* !CONFIG_XEN_DEBUG_FS */
>>   #define TIMEOUT			(1 << 10)
>> -#define ADD_STATS(elem, val)	do { (void)(val); } while(0)
>> +static inline void add_stats(enum xen_contention_stat var, u32 val)
>> +{
>> +}
>>
>>   static inline u64 spin_time_start(void)
>>   {
>>   	return 0;
>>   }
>>
>> -static inline void spin_time_accum_total(u64 start)
>> -{
>> -}
>> -static inline void spin_time_accum_spinning(u64 start)
>> -{
>> -}
>>   static inline void spin_time_accum_blocked(u64 start)
>>   {
>>   }
>> @@ -133,229 +112,82 @@ typedef u16 xen_spinners_t;
>>   	asm(LOCK_PREFIX " decw %0" : "+m" ((xl)->spinners) : : "memory");
>>   #endif
>>
>> -struct xen_spinlock {
>> -	unsigned char lock;		/* 0 -> free; 1 -> locked */
>> -	xen_spinners_t spinners;	/* count of waiting cpus */
>> +struct xen_lock_waiting {
>> +	struct arch_spinlock *lock;
>> +	__ticket_t want;
>>   };
>>
>>   static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
>> +static DEFINE_PER_CPU(struct xen_lock_waiting, lock_waiting);
>> +static cpumask_t waiting_cpus;
>>
>> -#if 0
>> -static int xen_spin_is_locked(struct arch_spinlock *lock)
>> -{
>> -	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
>> -
>> -	return xl->lock != 0;
>> -}
>> -
>> -static int xen_spin_is_contended(struct arch_spinlock *lock)
>> +static void xen_lock_spinning(struct arch_spinlock *lock, __ticket_t want)
>>   {
>> -	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
>> -
>> -	/* Not strictly true; this is only the count of contended
>> -	   lock-takers entering the slow path. */
>> -	return xl->spinners != 0;
>> -}
>> -
>> -static int xen_spin_trylock(struct arch_spinlock *lock)
>> -{
>> -	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
>> -	u8 old = 1;
>> -
>> -	asm("xchgb %b0,%1"
>> -	    : "+q" (old), "+m" (xl->lock) : : "memory");
>> -
>> -	return old == 0;
>> -}
>> -
>> -static DEFINE_PER_CPU(struct xen_spinlock *, lock_spinners);
>> -
>> -/*
>> - * Mark a cpu as interested in a lock.  Returns the CPU's previous
>> - * lock of interest, in case we got preempted by an interrupt.
>> - */
>> -static inline struct xen_spinlock *spinning_lock(struct xen_spinlock *xl)
>> -{
>> -	struct xen_spinlock *prev;
>> -
>> -	prev = __this_cpu_read(lock_spinners);
>> -	__this_cpu_write(lock_spinners, xl);
>> -
>> -	wmb();			/* set lock of interest before count */
>> -
>> -	inc_spinners(xl);
>> -
>> -	return prev;
>> -}
>> -
>> -/*
>> - * Mark a cpu as no longer interested in a lock.  Restores previous
>> - * lock of interest (NULL for none).
>> - */
>> -static inline void unspinning_lock(struct xen_spinlock *xl, struct xen_spinlock *prev)
>> -{
>> -	dec_spinners(xl);
>> -	wmb();			/* decrement count before restoring lock */
>> -	__this_cpu_write(lock_spinners, prev);
>> -}
>> -
>> -static noinline int xen_spin_lock_slow(struct arch_spinlock *lock, bool irq_enable)
>> -{
>> -	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
>> -	struct xen_spinlock *prev;
>>   	int irq = __this_cpu_read(lock_kicker_irq);
>> -	int ret;
>> +	struct xen_lock_waiting *w = &__get_cpu_var(lock_waiting);
>> +	int cpu = smp_processor_id();
>>   	u64 start;
>> +	unsigned long flags;
>>
>>   	/* If kicker interrupts not initialized yet, just spin */
>>   	if (irq == -1)
>> -		return 0;
>> +		return;
>>
>>   	start = spin_time_start();
>>
>> -	/* announce we're spinning */
>> -	prev = spinning_lock(xl);
>> -
>> -	ADD_STATS(taken_slow, 1);
>> -	ADD_STATS(taken_slow_nested, prev != NULL);
>> -
>> -	do {
>> -		unsigned long flags;
>> -
>> -		/* clear pending */
>> -		xen_clear_irq_pending(irq);
>> -
>> -		/* check again make sure it didn't become free while
>> -		   we weren't looking  */
>> -		ret = xen_spin_trylock(lock);
>> -		if (ret) {
>> -			ADD_STATS(taken_slow_pickup, 1);
>> -
>> -			/*
>> -			 * If we interrupted another spinlock while it
>> -			 * was blocking, make sure it doesn't block
>> -			 * without rechecking the lock.
>> -			 */
>> -			if (prev != NULL)
>> -				xen_set_irq_pending(irq);
>> -			goto out;
>> -		}
>> +	/*
>> +	 * Make sure an interrupt handler can't upset things in a
>> +	 * partially setup state.
>> +	 */
>> +	local_irq_save(flags);
>>
>> -		flags = arch_local_save_flags();
>> -		if (irq_enable) {
>> -			ADD_STATS(taken_slow_irqenable, 1);
>> -			raw_local_irq_enable();
>> -		}
>> +	w->want = want;
>> +	smp_wmb();
>> +	w->lock = lock;
>>
>> -		/*
>> -		 * Block until irq becomes pending.  If we're
>> -		 * interrupted at this point (after the trylock but
>> -		 * before entering the block), then the nested lock
>> -		 * handler guarantees that the irq will be left
>> -		 * pending if there's any chance the lock became free;
>> -		 * xen_poll_irq() returns immediately if the irq is
>> -		 * pending.
>> -		 */
>> -		xen_poll_irq(irq);
>> +	/* This uses set_bit, which atomic and therefore a barrier */
>> +	cpumask_set_cpu(cpu, &waiting_cpus);
>> +	add_stats(TAKEN_SLOW, 1);
>>
>> -		raw_local_irq_restore(flags);
>> +	/* clear pending */
>> +	xen_clear_irq_pending(irq);
>>
>> -		ADD_STATS(taken_slow_spurious, !xen_test_irq_pending(irq));
>> -	} while (!xen_test_irq_pending(irq)); /* check for spurious wakeups */
>> +	/* Only check lock once pending cleared */
>> +	barrier();
>>
>> +	/* check again make sure it didn't become free while
>> +	   we weren't looking  */
>> +	if (ACCESS_ONCE(lock->tickets.head) == want) {
>> +		add_stats(TAKEN_SLOW_PICKUP, 1);
>> +		goto out;
>> +	}
>> +	/* Block until irq becomes pending (or perhaps a spurious wakeup) */
>> +	xen_poll_irq(irq);
>> +	add_stats(TAKEN_SLOW_SPURIOUS, !xen_test_irq_pending(irq));
>>   	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
>> -
>>   out:
>> -	unspinning_lock(xl, prev);
>> +	cpumask_clear_cpu(cpu, &waiting_cpus);
>> +	w->lock = NULL;
>> +	local_irq_restore(flags);
>>   	spin_time_accum_blocked(start);
>> -
>> -	return ret;
>>   }
>>
>> -static inline void __xen_spin_lock(struct arch_spinlock *lock, bool irq_enable)
>> -{
>> -	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
>> -	unsigned timeout;
>> -	u8 oldval;
>> -	u64 start_spin;
>> -
>> -	ADD_STATS(taken, 1);
>> -
>> -	start_spin = spin_time_start();
>> -
>> -	do {
>> -		u64 start_spin_fast = spin_time_start();
>> -
>> -		timeout = TIMEOUT;
>> -
>> -		asm("1: xchgb %1,%0\n"
>> -		    "   testb %1,%1\n"
>> -		    "   jz 3f\n"
>> -		    "2: rep;nop\n"
>> -		    "   cmpb $0,%0\n"
>> -		    "   je 1b\n"
>> -		    "   dec %2\n"
>> -		    "   jnz 2b\n"
>> -		    "3:\n"
>> -		    : "+m" (xl->lock), "=q" (oldval), "+r" (timeout)
>> -		    : "1" (1)
>> -		    : "memory");
>> -
>> -		spin_time_accum_spinning(start_spin_fast);
>> -
>> -	} while (unlikely(oldval != 0 &&
>> -			  (TIMEOUT == ~0 || !xen_spin_lock_slow(lock, irq_enable))));
>> -
>> -	spin_time_accum_total(start_spin);
>> -}
>> -
>> -static void xen_spin_lock(struct arch_spinlock *lock)
>> -{
>> -	__xen_spin_lock(lock, false);
>> -}
>> -
>> -static void xen_spin_lock_flags(struct arch_spinlock *lock, unsigned long flags)
>> -{
>> -	__xen_spin_lock(lock, !raw_irqs_disabled_flags(flags));
>> -}
>> -
>> -static noinline void xen_spin_unlock_slow(struct xen_spinlock *xl)
>> +static void xen_unlock_kick(struct arch_spinlock *lock, __ticket_t next)
>>   {
>>   	int cpu;
>>
>> -	ADD_STATS(released_slow, 1);
>> +	add_stats(RELEASED_SLOW, 1);
>> +
>> +	for_each_cpu(cpu, &waiting_cpus) {
>> +		const struct xen_lock_waiting *w = &per_cpu(lock_waiting, cpu);
>>
>> -	for_each_online_cpu(cpu) {
>> -		/* XXX should mix up next cpu selection */
>> -		if (per_cpu(lock_spinners, cpu) == xl) {
>> -			ADD_STATS(released_slow_kicked, 1);
>> +		if (w->lock == lock && w->want == next) {
>> +			add_stats(RELEASED_SLOW_KICKED, 1);
>>   			xen_send_IPI_one(cpu, XEN_SPIN_UNLOCK_VECTOR);
>
> When this was initially implemented there was a "break" here. But
> 76eaca031f0af2bb303e405986f637811956a422 (xen: Send spinlock IPI to all waiters)
> fixed an issue and changed this to send an IPI to all of the CPUs. That
> means the 'break' was removed..
>
> With this implementation of spinlock, you know exactly which vCPU is holding it,
> so this code should introduce the 'break' back.
>

Thank you for spotting. agreed.



