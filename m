Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaFVQcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 12:32:19 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:36243 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaFVQcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 12:32:16 -0400
Message-ID: <53A70602.8020000@linux.vnet.ibm.com>
Date: Sun, 22 Jun 2014 22:06:18 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Waiman.Long@hp.com, tglx@linutronix.de, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, paulmck@linux.vnet.ibm.com,
        riel@redhat.com, torvalds@linux-foundation.org,
        david.vrabel@citrix.com, oleg@redhat.com, gleb@redhat.com,
        scott.norton@hp.com, chegu_vinod@hp.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 11/11] qspinlock, kvm: Add paravirt support
References: <20140615124657.264658593@chello.nl> <20140615130154.400698797@chello.nl>
In-Reply-To: <20140615130154.400698797@chello.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062216-6102-0000-0000-000005D40E1D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2014 06:17 PM, Peter Zijlstra wrote:
> Signed-off-by: Peter Zijlstra<peterz@infradead.org>
> ---
[...]
> +
> +void kvm_wait(int *ptr, int val)
> +{
> +	unsigned long flags;
> +
> +	if (in_nmi())
> +		return;
> +
> +	/*
> +	 * Make sure an interrupt handler can't upset things in a
> +	 * partially setup state.
> +	 */

I am seeing hang with even 2 cpu guest (with patches on top of 3.15-rc6 ).
looking further with gdb I see one cpu is stuck with native_halt with
slowpath flag(_Q_LOCKED_SLOW) set when it was called.

(gdb) bt
#0  native_halt () at /test/master/arch/x86/include/asm/irqflags.h:55
#1  0xffffffff81033118 in halt (ptr=0xffffffff81eb0e58, val=524291) at 
/test/master/arch/x86/include/asm/paravirt.h:116
#2  kvm_wait (ptr=0xffffffff81eb0e58, val=524291) at 
arch/x86/kernel/kvm.c:835
#3  kvm_wait (ptr=0xffffffff81eb0e58, val=524291) at 
arch/x86/kernel/kvm.c:809
#4  0xffffffff810a2d8e in pv_wait (lock=0xffffffff81eb0e58) at 
/test/master/arch/x86/include/asm/paravirt.h:744
#5  __pv_wait_head (lock=0xffffffff81eb0e58) at 
kernel/locking/qspinlock.c:352

Value of lock seem to be 524288 (means already unlocked?)
So apart from races Waiman mentioned, are we also in need of smp_mb()
here and/or native_queue_unlock()?.

Interestingly I see other cpu stuck at multi_cpu_stop().

(gdb) thr 1
[Switching to thread 1 (Thread 1)]#0  multi_cpu_stop 
(data=0xffff8802140d1da0) at kernel/stop_machine.c:192
192			if (msdata->state != curstate) {

Or is it I am missing something.

please let me know if .config need to be shared.

> +	local_irq_save(flags);
> +
> +	/*
> +	 * check again make sure it didn't become free while
> +	 * we weren't looking.
> +	 */
> +	if (ACCESS_ONCE(*ptr) != val)
> +		goto out;
> +
> +	/*
> +	 * halt until it's our turn and kicked. Note that we do safe halt
> +	 * for irq enabled case to avoid hang when lock info is overwritten
> +	 * in irq spinlock slowpath and no spurious interrupt occur to save us.
> +	 */
> +	if (arch_irqs_disabled_flags(flags))
> +		halt();
> +	else
> +		safe_halt();
> +
> +out:
> +	local_irq_restore(flags);
> +}
> +#endif /* QUEUE_SPINLOCK */

