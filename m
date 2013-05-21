Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab3EUFed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 01:34:33 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:52631 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab3EUFec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 01:34:32 -0400
MIME-Version: 1.0
In-Reply-To: <1369065716-22801-7-git-send-email-fweisbec@gmail.com>
References: <1369065716-22801-1-git-send-email-fweisbec@gmail.com>
	<1369065716-22801-7-git-send-email-fweisbec@gmail.com>
Date: Tue, 21 May 2013 11:04:31 +0530
Message-ID: <CAK7N6voNjWrDJNzAaVAndt8cGWR+AAERs_C-oCWe0rRO=XuutQ@mail.gmail.com>
Subject: Re: [RFC PATCH 6/8] kthread: Enable parking requests from setup() and
 unpark() callbacks
From: anish singh <anish198519851985@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Don Zickus <dzickus@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 9:31 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
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
Out of curiosity, this can happen only for short period of time right?After
some time this will work right as the thread get back in action
after the schedule call.Then sysctl and procfs will work I think.
>
> We could workaround some solution in the watchdog code like forcing
> one pass to the thread function and immediately return to park.
>
> But supporting parking requests from ->setup() or ->unpark()
> callbacks look like proper way to implement cancellation in
> general. So let's fix it that way.
>
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
>                         break;
>                 }
>
> +               /* Check if setup or unpark actually want us to park */
> +               if (kthread_should_stop() || kthread_should_park()) {
> +                       preempt_enable();
> +                       continue;
> +               }
> +
>                 if (!ht->thread_should_run(td->cpu)) {
>                         preempt_enable();
>                         schedule();
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
