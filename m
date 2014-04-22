Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbaDVMz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:55:56 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:64081 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751323AbaDVMzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:55:47 -0400
X-IronPort-AV: E=Sophos;i="4.97,903,1389715200"; 
   d="scan'208";a="29572631"
Message-ID: <535658DB.2090801@cn.fujitsu.com>
Date: Tue, 22 Apr 2014 20:56:11 +0900
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <rostedt@goodmis.org>, <fweisbec@gmail.com>, <mingo@redhat.com>,
        <acme@ghostprotocols.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/8] sched/core: Skip wakeup when task is already running.
References: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com> <51238bf1648b1f4c66d3547a49cf949d1679d068.1397562542.git.yangds.fnst@cn.fujitsu.com> <20140415135326.GV11096@twins.programming.kicks-ass.net> <534E59FC.2090001@cn.fujitsu.com>
In-Reply-To: <534E59FC.2090001@cn.fujitsu.com>
Content-Type: multipart/mixed;
	boundary="------------000505070600090503000701"
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------000505070600090503000701
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

On 04/16/2014 07:22 PM, Dongsheng Yang wrote:
> On 04/15/2014 10:53 PM, Peter Zijlstra wrote:
>> On Tue, Apr 15, 2014 at 09:32:53PM +0900, Dongsheng Yang wrote:
>>
>> How can you get there with ->state == RUNNING? try_to_wake_up*() bail
>> when !(->state & state).
> Yes, try_to_wake_up() did this check. But other callers would miss it.
>
> With the following code ,I can get the actual message of waking up
> a running task
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 9f63275..1369cae 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1418,8 +1418,10 @@ static void ttwu_activate(struct rq *rq, struct 
> task_stru
>  static void
>  ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
>  {
> -       if (p->state == TASK_RUNNING)
> +       if (p->state == TASK_RUNNING) {
> +               printk("Wakeup a running task.");
>                 return;
> +       }
>
>         check_preempt_curr(rq, p, wake_flags);
>         trace_sched_wakeup(p, true);
>
>
> # grep "Wakeup" /var/log/messages
> Apr 15 20:16:21 localhost kernel: [    5.436505] Wakeup a running task.
> Apr 15 20:16:21 localhost kernel: [    7.776042] Wakeup a running task.
> Apr 15 20:16:21 localhost kernel: [    9.324274] Wakeup a running task.

Hi Peter, after some more investigation, I think I got the problem, 
which is that
some other task set p->state to TASK_RUNNING without holding p->pi_lock.

Scenario as attached graph shown, if some other task set p->state to
TASK_RUNNING after the check  if (! (p->state & state)), then we are
wasting time to wake up a running task in try_to_wake_up().

If the analyse is right, I think there are two methods to solve this 
problem:
     * Skip in ttwu_do_wakeup() when p->state is running, as what my patch
did.
     * Add a locking when we set p->state, lots of work to do and I am 
afraid
it will hurt the performance of kernel.


The following message is the backtrace info I got when it happened:

(gdb) bt
#0  try_to_wake_up (p=0xffff88027e651930, state=1, wake_flags=0)
     at kernel/sched/core.c:1605
#1  0xffffffff81099532 in default_wake_function (curr=<value optimized 
out>,
     mode=<value optimized out>, wake_flags=<value optimized out>,
     key=<value optimized out>) at kernel/sched/core.c:2853
#2  0xffffffff810aa489 in __wake_up_common (q=0xffff88027f03f210, mode=1,
     nr_exclusive=1, wake_flags=0, key=0x4) at kernel/sched/wait.c:75
#3  0xffffffff810aa838 in __wake_up (q=0xffff88027f03f210, mode=1,
     nr_exclusive=1, key=0x4) at kernel/sched/wait.c:97
#4  0xffffffff813cd0a4 in n_tty_check_unthrottle (tty=0xffff88027f03ec00,
     file=0xffff880278ab1b00,
     buf=0x7fff0fcf9720 "\r\nyum install -y 
./a/alsa-plugins-pulseaudio-1.0.27-1.fc19.x86_64.rpml -y 
./a/alsa-lib-1.0.27.1-2.fc19.x86_64.rpm.noarch.rpm\r\nyum install -y 
./a/albatross-xfwm4-theme-1.2-5.fc19.noarch.rpm\r\nyum instal"...,
     nr=16315) at drivers/tty/n_tty.c:280
#5  n_tty_read (tty=0xffff88027f03ec00, file=0xffff880278ab1b00,
     buf=0x7fff0fcf9720 "\r\nyum install -y 
./a/alsa-plugins-pulseaudio-1.0.27-1.fc19.x86_64.rpml -y 
./a/alsa-lib-1.0.27.1-2.fc19.x86_64.rpm.noarch.rpm\r\nyum install -y 
./a/albatross-xfwm4-theme-1.2-5.fc19.noarch.rpm\r\nyum instal"...,
     nr=16315) at drivers/tty/n_tty.c:2259
#6  0xffffffff813c5667 in tty_read (file=0xffff880278ab1b00,
     buf=0x7fff0fcf9720 "\r\nyum install -y 
./a/alsa-plugins-pulseaudio-1.0.27-1.fc19.x86_64.rpml -y 
./a/alsa-lib-1.0.27.1-2.fc19.x86_64.rpm.noarch.rpm\r\nyum in---Type 
<return> to continue, or q <return> to quit---q
Quit
(gdb) p p->state   ------> Currently, p->state is TASK_RUNNING.
$1 = 0
(gdb) l
1600
1601        success = 1; /* we're going to change ->state */
1602        cpu = task_cpu(p);
1603
1604        if (p->state == TASK_RUNNING) {
1605            printk("Wake up a running task.");
1606        }
1607        if (p->on_rq && ttwu_remote(p, wake_flags))
1608            goto stat;
1609
(gdb)
>
> So, I think there are some caller of ttwu_do_wakeup() is attempt to wake
> up a running task.
>> .
>>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> .
>


--------------000505070600090503000701
Content-Type: text/plain; charset="UTF-8"; name="graph"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="graph"

			CPU1							CPU2
	raw_spin_lock_irqsave(&p->pi_lock, flags);		set_task_state(tsk, TASK_INTERRUPTIBLE);
	if (!(p->state & state)) ---> TASK_INTERRUPTIBLE			 |
                goto out;							 |
	cpu = task_cpu(p);					set_task_state(tsk, TASK_RUNNING);
			... ---> TASK_RUNNING

--------------000505070600090503000701--
