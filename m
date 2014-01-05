Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaAEX3L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 18:29:11 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52218 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751884AbaAEX3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 18:29:09 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tony Camuso <tcamuso@redhat.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/1] acpi_pad: call schedule() when need_resched is true
Date: Mon, 06 Jan 2014 00:42:53 +0100
Message-ID: <6267303.NrPfzMWnJU@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1386863415-12790-1-git-send-email-tcamuso@redhat.com>
References: <1386863415-12790-1-git-send-email-tcamuso@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 12, 2013 10:50:15 AM Tony Camuso wrote:
> (Slightly rephrased from a bug report submitted by Stuart Hayes)
> 
> The purpose of the acpi_pad driver is to implement the "processor power
> aggregator" device as described in the ACPI 4.0 spec section 8.5. It
> takes requests from the BIOS (via ACPI) to put a specified number of
> CPUs into idle, in order to save power, until further notice.
> 
> It does this by creating high-priority threads that try to keep the CPUs
> in a high C-state (using the monitor/mwait CPU instructions). The
> mwait() call is in a loop that checks periodically if the thread should
> end and a few other things.
> 
> It was discovered through testing that the power_saving threads were
> causing the system to consume more power than the system was consuming
> before the threads were created. A counter in the main loop of
> power_saving_thread() revealed that it was spinning. The mwait()
> instruction was not keeping the CPU in a high C state very much if at
> all.
> 
> Here is a simplification of the loop in function power_saving_thread() in
> drivers/acpi/acpi_pad.c
> 
>     while (!kthread_should_stop()) {
>          :
>         try_to_freeze()
>          :
>         while (!need_resched()) {
>              :
>             if (!need_resched())
>                 __mwait(power_saving_mwait_eax, 1);
>              :
>             if (jiffies > expire_time) {
>                 do_sleep = 1;
>                 break;
>             }
>         }
>     }
> 
> If need_resched() returns true, then mwait() is not called. It was
> returning true because of things like timer interrupts, as in the
> following sequence.
> 
> hrtimer_interrupt->__run_hrtimer->tick_sched_timer-> update_process_times->
> rcu_check_callbacks->rcu_pending->__rcu_pending->set_need_resched
> 
> Kernels 3.5.0-rc2+ do not exhibit this problem, because a patch to
> try_to_freeze() in include/linux/freezer.h introduces a call to
> might_sleep(), which ultimately calls schedule() to clear the reschedule
> flag and allows the the loop to execute the call to mwait().
> 
> However, the changes to try_to_freeze are unrelated to acpi_pad, and it
> does not seem like a good idea to rely on an unrelated patch in a
> function that could later be changed and reintroduce this bug.
> 
> Therefore, it seems better to make an explicit call to schedule() in the
> outer loop when the need_resched flag is set.
> 
> Reported-by: Stuart Hayes <stuart_hayes@dell.com>
> Tested-by: Stuart Hayes <stuart_hayes@dell.com>
> Signed-off-by: Tony Camuso <tcamuso@redhat.com>

Peter Zijlstra has an acpi_pad patch that I think will conflict with this, so
please resubmit after the 3.14 merge window if still necessary.

Thanks! 

> ---
>  drivers/acpi/acpi_pad.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
> index fc6008f..2c67e59 100644
> --- a/drivers/acpi/acpi_pad.c
> +++ b/drivers/acpi/acpi_pad.c
> @@ -219,8 +219,15 @@ static int power_saving_thread(void *data)
>  		 * borrow CPU time from this CPU and cause RT task use > 95%
>  		 * CPU time. To make 'avoid starvation' work, takes a nap here.
>  		 */
> -		if (do_sleep)
> +		if (unlikely(do_sleep))
>  			schedule_timeout_killable(HZ * idle_pct / 100);
> +
> +		/* If an external event has set the need_resched flag, then
> +		 * we need to deal with it, or this loop will continue to
> +		 * spin without calling __mwait().
> +		 */
> +		if (unlikely(need_resched()))
> +			schedule();
>  	}
>  
>  	exit_round_robin(tsk_index);
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
