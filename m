Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965212Ab3FTKrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:47:04 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62149 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab3FTKrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:47:01 -0400
Date: Thu, 20 Jun 2013 12:46:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        peterz@infradead.org, fweisbec@gmail.com, jolsa@redhat.com,
        namhyung@kernel.org, eranian@google.com
Subject: Re: [RFC PATCH 4/4] perf: add timehist command
Message-ID: <20130620104656.GA11256@gmail.com>
References: <1370643734-9579-1-git-send-email-dsahern@gmail.com>
 <1370643734-9579-5-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370643734-9579-5-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> perf timehist provides an analysis of scheduling event data. Right now
> it uses the context-switch softwar event; it needs to be updated to use
> the scheduling tracepoints along with analysis enhancements those
> tracepoints provide. For now, the context switch event provides a
> well-tested start point.
> 
> This command has been extremely helpful debugging systems with heavy
> CPU contention.
> 
> Use case:
> 1. collect context switch data for the system (or cpu) along with
>    the stack trace:
>        perf record -e cs -c 1 -ag -- <workload>
> 
> 2. run the timehist command to show the time between schedule-in
>    times (ie., how long did the task go between access to the CPU)
>    as well as run times (ie., how long did the task run once scheduled)
>    and the stack trace of the task when scheduled out:
> 
>        perf timehist
> 
> time          cpu  task [tid/pid]    b/n time  run time
> ------------- ---- ----------------- --------- ---------
> 227959.352628 [02] make[17133]       0.004877  0.000285  do_wait         sys_wait4 ...
> 227959.352762 [03] sh[17136]         0.000000  0.000135  __cond_resched  _cond_resched  ...
> 227959.352777 [03] migration/3[23]   0.003163  0.000014  smpboot_thread_fn kthread      ...
> 227959.352801 [02] <idle>            0.000285  0.000173  cpu_idle        start_secondary
> 227959.353552 [02] sh[17136]         0.000038  0.000750  do_exit         do_group_exit   ...
> 227959.353564 [04] <idle>            0.000014  0.001113  cpu_idle        start_secondary
> 227959.353722 [04] make[17133]       0.000936  0.000157  do_exit         do_group_exit   ...
> 227959.353761 [06] <idle>            0.001210  0.021919  cpu_idle        start_secondary
> 227959.353900 [06] make[17127]       0.001310  0.000139  wait_for_completion_killable do_fork ...
> 227959.353921 [03] <idle>            0.000150  0.001143  cpu_idle        start_secondary
> 227959.353945 [03] make[17137]       0.000000  0.000023  __cond_resched  _cond_resched   ...
> 227959.353962 [03] migration/3[23]   0.001167  0.000017  smpboot_thread_fn kthread         ret_from_fork
> 227959.353990 [02] <idle>            0.000750  0.000438  cpu_idle        start_secondary
> 227959.354034 [03] <idle>            0.000041  0.000071  cpu_idle        start_secondary
> 227959.354044 [03] rcu_sched[10]     0.002931  0.000010  rcu_gp_kthread  kthread         ret_from_fork
> 227959.354089 [06] <idle>            0.000139  0.000189  cpu_idle        start_secondary
> 227959.354096 [06] rcu_sched[10]     0.000044  0.000006  rcu_gp_kthread  kthread         ret_from_fork
> 227959.354110 [06] make[17127]       0.000195  0.000014  pipe_wait       pipe_read       ...
> 227959.354382 [00] <idle>            0.000013  0.003307  cpu_idle        rest_init       ...
> 227959.354452 [00] qemu-kvm[25781/25777]  0.000000  0.000069  kvm_vcpu_block  kvm_arch_vcpu_ioctl_run ...
> 227959.354498 [04] <idle>                 0.000157  0.000776  cpu_idle        start_secondary
> 
> Additional options:
>   i. --cpu-visual - useful for multi-core. Adds a field to highlight
>                     visually which cpu had an event
> 
>  ii. --summary - show a run time summary of how long each task ran over
>                  the time interval analyzed
> 
> Runtime summary (times are in seconds)
>                      comm  parent  number  run-time    min-run    max-run   avg-run  stddev(%)
> ...
>           qemu-kvm[25777]     -1       8   0.000398   0.000037   0.000076   0.000049   8.99
>     qemu-kvm[25781/25777]     -1      22   0.001532   0.000040   0.000193   0.000069  10.39
>     qemu-kvm[25782/25777]     -1      21   0.001536   0.000038   0.000255   0.000073  14.13
>               sshd[28339]     -1      12   0.001337   0.000073   0.000129   0.000111   4.69
> ...
> 
> Terminated tasks:
>                 sh[17126]  17125       2   0.000778
>               make[17125]  17124       3   0.002007
>                 sh[17129]  17128       2   0.000945
>                 sh[17130]  17128       2   0.001600
>               make[17128]  17127       4   0.002272
> ...
> 
> iii. --tree - show parent-child summary with runtimes:
> 
> Parent-child relationships
> --------------------------
> ...
> perf[17124]  0.002964
>     make[17125]  0.002007
>         sh[17126]  0.000778
>     make[17127]  0.101272
>         make[17128]  0.002272
>             sh[17129]  0.000945
>             sh[17130]  0.001600
>         make[17131]  0.001888
>         make[17132]  0.000715
>         make[17133]  0.002273
>             sh[17134]  0.002230
>                 gcc[17135]  0.002527
>             sh[17136]  0.000886
>         make[17137]  0.002408
>             sh[17138]  0.002420
>                 gcc[17139]  0.010634
>                 gcc[17140]  0.006208
> 
> This command has been a work in progress for years and many more options
> and features will be added in time.

Looks very useful!

This is the kind of analysis I thought 'perf sched' might one day end up 
doing.

Do you plan to submit it non-RFC, to be merged?

Your tool could take over the somewhat stale 'perf sched' command as well 
btw., while possibly carrying over some of the perf sched features like 
'replay'.

'perf sched record' enough events to support the ones you need:

>        perf record -e cs -c 1 -ag -- <workload>

plus:

 'perf sched sum[mary]'       # show the summary
 'perf sched tree'            # could show the tree.
 'perf sched hist[ogram]'     # would show the histogram

i.e. feel free to take over 'perf sched' to suit your 'timehist' workflow 
and logic. As the main (and somewhat overworked) author of 'perf sched' I 
have no problem with you taking it over, at all.

You could also add a 'perf timehist' alias to the new 'perf sched' 
command, to keep your original (and well established?) naming.

Thanks,

	Ingo
