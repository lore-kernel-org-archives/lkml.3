Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbaKGJkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:40:10 -0500
Received: from www.linutronix.de ([62.245.132.108]:46958 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaKGJkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:40:03 -0500
Date: Fri, 7 Nov 2014 10:39:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Subbaraman Narayanamurthy <subbaram@codeaurora.org>, daniel@numascale.com,
        yuyang.du@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: hotplug thread issues
In-Reply-To: <20141106150150.GT10501@worktop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.11.1411071037440.3789@nanos>
References: <20141106150150.GT10501@worktop.programming.kicks-ass.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2014, Peter Zijlstra wrote:

> Hi Thomas,
> 
> So there have been some reports on hitting:
> 
>   BUG_ON(td->cpu != smp_processor_id());
> 
> in smpboot_thread_fn.
> 
> Now I've been staring at this for a wee bit today and I've found two
> issues, but I'm not sure either are enough to explain the observed.
> 
> 1) smpboot_register_percpu_thread() seems to lack serialization against
>    hotplug. It has a for_each_online() loop, but no get_online_cpus() --
>    unlike smpboot_unregister_percpu_thread, which does.
> 
>    Typical usage like spawn_ksoftirqd() should be fine, they're early
>    init calls and those run before we bring up the other CPUs. Therefore
>    this does not explain the observation that its ksoftirqd/n triggering
>    the BUG.
> 
>    However, the usage in proc_dowatchdog() is susceptible to this race
>    and its entirely possible to go wrong there.

Hmm. Need to have a look.
 
> 
> 2) the usage of __set_current_state(TASK_PARKED) in __kthread_parkme()
>    is wrong AFAICT, one should always use set_current_state() for
>    setting !TASK_RUNNING state. The comment with set_current_state()
>    explains why.
> 
>    This would've allowed the test_bit(KTHREAD_SHOULD_PARK) load to have
>    been satisfied before the store of TASK_PARKED.

My bad. Can you send a proper patch addressing that issue please? That
should be tagged stable as well I guess.

Thanks,

	tglx


