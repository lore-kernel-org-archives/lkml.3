Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaE0WtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 18:49:23 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:51459 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaE0WtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 18:49:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140522031950.280830190@linutronix.de>
References: <20140522031841.797415507@linutronix.de>
	<20140522031950.280830190@linutronix.de>
Date: Tue, 27 May 2014 15:49:21 -0700
X-Google-Sender-Auth: 3D_YIl8yl3FLcCghq8SKXqjRmbA
Message-ID: <CAGQ1y=6DOs0hcdV+NvOdA9hxf6kwu-R0M-c6R2iUK4ufr=pwEg@mail.gmail.com>
Subject: Re: [patch 6/6] rtmutex: Avoid pointless requeueing in the deadlock
 detection chain walk
From: Jason Low <jason.low2@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 8:25 PM, Thomas Gleixner <tglx@linutronix.de> wrote:

> @@ -440,32 +452,41 @@ static int rt_mutex_adjust_prio_chain(st
>         get_task_struct(task);
>         raw_spin_lock_irqsave(&task->pi_lock, flags);
>
> -       if (waiter == rt_mutex_top_waiter(lock)) {
> -               /*
> -                * The waiter became the top waiter on the
> -                * lock. Remove the previous top waiter from the tasks
> -                * pi waiters list and add waiter to it.
> -                */
> -               rt_mutex_dequeue_pi(task, prerequeue_top_waiter);
> -               rt_mutex_enqueue_pi(task, waiter);
> -               __rt_mutex_adjust_prio(task);
> -
> -       } else if (prerequeue_top_waiter == waiter) {
> -               /*
> -                * The waiter was the top waiter on the lock. Remove
> -                * waiter from the tasks pi waiters list and add the
> -                * new top waiter to it.
> -                */
> -               rt_mutex_dequeue_pi(task, waiter);
> -               waiter = rt_mutex_top_waiter(lock);
> -               rt_mutex_enqueue_pi(task, waiter);
> -               __rt_mutex_adjust_prio(task);
> -
> -       } else {
> -               /*
> -                * Nothing changed. No need to do any priority
> -                * adjustment.
> -                */
> +       /*
> +        * In case we are just following the lock chain for deadlock
> +        * detection we can avoid the whole requeue and priority
> +        * adjustment business.
> +        */
> +       if (requeue) {
> +               if (waiter == rt_mutex_top_waiter(lock)) {
> +                       /*
> +                        * The waiter became the top waiter on the
> +                        * lock. Remove the previous top waiter from
> +                        * the tasks pi waiters list and add waiter to
> +                        * it.
> +                        */
> +                       rt_mutex_dequeue_pi(task, prerequeue_top_waiter);
> +                       rt_mutex_enqueue_pi(task, waiter);
> +                       __rt_mutex_adjust_prio(task);
> +
> +               } else if (prerequeue_top_waiter == waiter) {
> +                       /*
> +                        * The waiter was the top waiter on the
> +                        * lock. Remove waiter from the tasks pi
> +                        * waiters list and add the new top waiter to
> +                        * it.
> +                        */
> +                       rt_mutex_dequeue_pi(task, waiter);
> +                       waiter = rt_mutex_top_waiter(lock);
> +                       rt_mutex_enqueue_pi(task, waiter);
> +                       __rt_mutex_adjust_prio(task);
> +
> +               } else {
> +                       /*
> +                        * Nothing changed. No need to do any priority
> +                        * adjustment.
> +                        */
> +               }
>         }
>
>         raw_spin_unlock_irqrestore(&task->pi_lock, flags);

In the above case, could we go 1 step further and avoid taking the pi
lock as well?

        if (requeue) {
                raw_spin_lock_irqsave(&task->pi_lock, flags);

                if (waiter == rt_mutex_top_waiter(lock)) {
                        /*
                         * The waiter became the top waiter on the
                         * lock. Remove the previous top waiter from
                         * the tasks pi waiters list and add waiter to
                         * it.
                         */
                        rt_mutex_dequeue_pi(task, prerequeue_top_waiter);
                        rt_mutex_enqueue_pi(task, waiter);
                        __rt_mutex_adjust_prio(task);

                } else if (prerequeue_top_waiter == waiter) {
                        /*
                         * The waiter was the top waiter on the
                         * lock. Remove waiter from the tasks pi
                         * waiters list and add the new top waiter to
                         * it.
                         */
                        rt_mutex_dequeue_pi(task, waiter);
                        waiter = rt_mutex_top_waiter(lock);
                        rt_mutex_enqueue_pi(task, waiter);
                        __rt_mutex_adjust_prio(task);

                } else {
                        /*
                         * Nothing changed. No need to do any priority
                         * adjustment.
                         */
                }

                raw_spin_unlock_irqrestore(&task->pi_lock, flags);
        }
