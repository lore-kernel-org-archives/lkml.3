Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab3EUHCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 03:02:40 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:38592 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab3EUHCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 03:02:39 -0400
Message-ID: <519B1B4D.3090307@linux.vnet.ibm.com>
Date: Tue, 21 May 2013 12:29:25 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Don Zickus <dzickus@redhat.com>
Subject: Re: [RFC PATCH 6/8] kthread: Enable parking requests from setup()
 and unpark() callbacks
References: <1369065716-22801-1-git-send-email-fweisbec@gmail.com> <1369065716-22801-7-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1369065716-22801-7-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052106-2000-0000-0000-00000C311EB7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2013 09:31 PM, Frederic Weisbecker wrote:
> When the watchdog code is boot-disabled by the user, for example
> through the 'nmi_watchdog=0' boot option, the setup() callback of
> the watchdog kthread requests to park the task, and that until the
> user later re-enables the watchdog through sysctl or procfs.
> 
> However the parking request is not well handled when done from
> the setup() callback. After ->setup() is called, the generic smpboot
> kthread loop directly tries to call the thread function or wait
> for some event if ->thread_should_run() is false.
> 
> In the case of the watchdog kthread, ->thread_should_run() returns
> false and the kthread goes to sleep and wait for the watchdog timer
> to wake it up. But the timer is not enabled since the user requested
> to disable the watchdog. We want the kthread to park instead of waiting
> for events that can't happen.
> 
> As a result, later unpark requests after sysctl write through
> 'sysctl -w kernel.watchdog=1' won't wake up/unpark the task as
> expected, since it's not parked anyway, leaving the value modified
> without triggering any action.
> 
> We could workaround some solution in the watchdog code like forcing
> one pass to the thread function and immediately return to park.
> 
> But supporting parking requests from ->setup() or ->unpark()

unpark() can already do a proper park, because immediately after
coming out of the parked state, the 'continue' statement helps
re-evaluate the stop/park condition.

So this fix is only for the ->setup() case.

> callbacks look like proper way to implement cancellation in
> general. So let's fix it that way.
>

Sounds good to me.

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

But I wonder what nmi_watchdog=0 should actually mean, semantically..
The current code works as if the user asked us not to run the watchdog
threads, but it could as well be interpreted as if the user does not
want to run *any* watchdog-related *code*. In that case, ideally we
should *unregister* the watchdog threads, instead of just parking them.
And when the user enables them again via sysctl/procfs, we should
register the watchdog threads with the smpboot infrastructure.

I'm not saying that the current semantics is wrong, but if we really
implement it the other way I proposed above, then we won't have to deal
with weird issues like ->setup() code wanting to park, and watchdog
threads unparking and parking themselves on every CPU hotplug operation,
despite the fact that the user specified nmi_watchdog=0 on the kernel
command line.

Regards,
Srivatsa S. Bhat
 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Li Zhong <zhong@linux.vnet.ibm.com>
> Cc: Don Zickus <dzickus@redhat.com>
> ---
>  kernel/smpboot.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/smpboot.c b/kernel/smpboot.c
> index 02fc5c9..3394ed0 100644
> --- a/kernel/smpboot.c
> +++ b/kernel/smpboot.c
> @@ -151,6 +151,12 @@ static int smpboot_thread_fn(void *data)
>  			break;
>  		}
> 
> +		/* Check if setup or unpark actually want us to park */
> +		if (kthread_should_stop() || kthread_should_park()) {
> +			preempt_enable();
> +			continue;
> +		}
> +
>  		if (!ht->thread_should_run(td->cpu)) {
>  			preempt_enable();
>  			schedule();
> 

