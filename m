Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbbAUKab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:30:31 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:42992 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbbAUKaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:30:17 -0500
X-IronPort-AV: E=Sophos;i="5.09,440,1418083200"; 
   d="scan'208";a="220140379"
Message-ID: <54BF7F95.70507@citrix.com>
Date: Wed, 21 Jan 2015 10:29:41 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Waiman Long <Waiman.Long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: <linux-arch@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        <kvm@vger.kernel.org>, Scott J Norton <scott.norton@hp.com>,
        <x86@kernel.org>, Paolo Bonzini <paolo.bonzini@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Douglas Hatch <doug.hatch@hp.com>
Subject: Re: [Xen-devel] [PATCH v14 11/11] pvqspinlock, x86: Enable PV qspinlock
 for XEN
References: <1421784755-21945-1-git-send-email-Waiman.Long@hp.com> <1421784755-21945-12-git-send-email-Waiman.Long@hp.com>
In-Reply-To: <1421784755-21945-12-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/01/15 20:12, Waiman Long wrote:
> This patch adds the necessary XEN specific code to allow XEN to
> support the CPU halting and kicking operations needed by the queue
> spinlock PV code.

Xen is a word, please don't capitalize it.

> +void xen_lock_stats(int stat_types)
> +{
> +	if (stat_types & PV_LOCKSTAT_WAKE_KICKED)
> +		add_smp(&wake_kick_stats, 1);
> +	if (stat_types & PV_LOCKSTAT_WAKE_SPURIOUS)
> +		add_smp(&wake_spur_stats, 1);
> +	if (stat_types & PV_LOCKSTAT_KICK_NOHALT)
> +		add_smp(&kick_nohlt_stats, 1);
> +	if (stat_types & PV_LOCKSTAT_HALT_QHEAD)
> +		add_smp(&halt_qhead_stats, 1);
> +	if (stat_types & PV_LOCKSTAT_HALT_QNODE)
> +		add_smp(&halt_qnode_stats, 1);
> +	if (stat_types & PV_LOCKSTAT_HALT_ABORT)
> +		add_smp(&halt_abort_stats, 1);
> +}
> +PV_CALLEE_SAVE_REGS_THUNK(xen_lock_stats);

This is not inlined and the 6 test-and-branch cannot be optimized away.

> +/*
> + * Halt the current CPU & release it back to the host
> + * Return 0 if halted, -1 otherwise.
> + */
> +int xen_halt_cpu(u8 *byte, u8 val)
> +{
> +	int irq = __this_cpu_read(lock_kicker_irq);
> +	unsigned long flags;
> +	u64 start;
> +
> +	/* If kicker interrupts not initialized yet, just spin */
> +	if (irq == -1)
> +		return -1;
> +
> +	/*
> +	 * Make sure an interrupt handler can't upset things in a
> +	 * partially setup state.
> +	 */
> +	local_irq_save(flags);
> +	start = spin_time_start();
> +
> +	/* clear pending */
> +	xen_clear_irq_pending(irq);
> +
> +	/* Allow interrupts while blocked */
> +	local_irq_restore(flags);

It's not clear what "partially setup state" is being protected here.
xen_clear_irq_pending() is an atomic bit clear.

I think you can drop the irq save/restore here.

> +	/*
> +	 * Don't halt if the content of the given byte address differs from
> +	 * the expected value. A read memory barrier is added to make sure that
> +	 * the latest value of the byte address is fetched.
> +	 */
> +	smp_rmb();

The atomic bit clear in xen_clear_irq_pending() acts as a full memory
barrier.  I don't think you need an additional memory barrier here, only
a compiler one.  I suggest using READ_ONCE().

> +	if (*byte != val) {
> +		xen_lock_stats(PV_LOCKSTAT_HALT_ABORT);
> +		return -1;
> +	}
> +	/*
> +	 * If an interrupt happens here, it will leave the wakeup irq
> +	 * pending, which will cause xen_poll_irq() to return
> +	 * immediately.
> +	 */
> +
> +	/* Block until irq becomes pending (or perhaps a spurious wakeup) */
> +	xen_poll_irq(irq);
> +	spin_time_accum_blocked(start);
> +	return 0;
> +}
> +PV_CALLEE_SAVE_REGS_THUNK(xen_halt_cpu);
> +
> +#endif /* CONFIG_QUEUE_SPINLOCK */
> +
>  static irqreturn_t dummy_handler(int irq, void *dev_id)
>  {
>  	BUG();

David

