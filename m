Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab3EBKhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 06:37:16 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40593
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756042Ab3EBKhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 06:37:14 -0400
Date: Thu, 2 May 2013 12:35:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: Re: [PATCH v4 0/6] sched: use runnable load based balance
Message-ID: <20130502103508.GA13196@dyad.programming.kicks-ass.net>
References: <1367040344-14485-1-git-send-email-alex.shi@intel.com>
 <20130501121421.GA19602@dyad.programming.kicks-ass.net>
 <5181B579.9000808@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5181B579.9000808@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 08:38:17AM +0800, Alex Shi wrote:

> On 3.8 kernel, the first problem commit is 5a505085f043 ("mm/rmap:
> Convert the struct anon_vma::mutex to an rwsem"), It cause much
> imbalance among cpus on aim7 benchmark. The reason is here,
> https://lkml.org/lkml/2013/1/29/84.

Hehe. yeah that one was going to be obvious.. rwsems were known to be totally
bad performers. Not only were they lacking lock stealing but also the spinning.
 
> But, after we use rwsem lock stealing in 3.9 kernel, commit
> ce6711f3d196f09ca0e, aim7 wakeup won't has clear imbalance issue. And
> then aim7 won't need this extra burst wakeup detection.

OK, that seems like a nice fix for rwsems.. one nit:

+               raw_spin_lock_irq(&sem->wait_lock);
+               /* Try to get the writer sem, may steal from the head writer: */
+               if (flags == RWSEM_WAITING_FOR_WRITE)
+                       if (try_get_writer_sem(sem, &waiter)) {
+                               raw_spin_unlock_irq(&sem->wait_lock);
+                               return sem;
+                       }
+               raw_spin_unlock_irq(&sem->wait_lock);
                schedule();

That should probably look like:

	preempt_disable();
	raw_spin_unlock_irq();
	preempt_enable_no_resched();
	schedule();

Otherwise you might find a performance regression on PREEMPT=y kernels.

> With PJT's patch, we know in first few seconds from wakeup, task's
> runnable load maybe nearly zero. The nearly zero runnable load increases
> the imbalance among cpus. So there are about extra 5% performance drop
> when use runnable load to do balance on aim7(in testing, aim7 will fork
> 2000 threads, and then wait for a trigger, then run as fast as possible).

OK, so what I was asking after is if you changed the scheduler after PJTs
patches landed to deal with this bulk wakeup. Also while aim7 might no longer
trigger the bad pattern what is to say nothing ever will? In particular
anything using pthread_cond_broadcast() is known to be suspect of bulk wakeups.

Anyway, I'll go try and make sense of some of the actual patches.. :-)
