Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab3LWKYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 05:24:08 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:55342 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3LWKYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 05:24:06 -0500
Message-ID: <1387794220.15103.79.camel@marge.simpson.net>
Subject: RFC: rt + uncontrollable kthreads/workqueues = generic evil
From: Mike Galbraith <bitbucket@online.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Mon, 23 Dec 2013 11:23:40 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:eLAZFJ2rZ60D3igCUS0qpQ5WgXeSzCkEa7KPya9vGsU
 h7FwXMalQhoIXAkxYKDtLp3Es8syrgFUCYPoQefs+2tSPIvBhG
 vc5ac9mAKOyDxWp2w4WgQjjL7fw/Si2YitTtPvoVvfJMMi9Xb6
 F/UZ3EZ+ph8PgAQVN4CwWeHgKH/Y/0emESdo+8GGNYH3YeItyC
 3MkyzGcq8pp2ZMfLxDuPhfoCxmgXi93dwK9izzDxiVnPjGKxFO
 46jnye38LOVzcY1GKFppCTnnDsvGPzAOMdfhj1JO16HhZQn0El
 XQvKUWayBZ1/jdiQy/M1pcqWp9j18NrbXq5chriUmscE9BgiEN
 rCYQy7SSJuEPkY1pEFaGje0FEHWVmBGr6LsHpVk6iq32ld/2SD
 uJn1dQ74hYbpw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1. rt tasks can kill the whole box or jam up random applications via
kthreadd and/or kworker starvation, even when the user is being careful.
2. uncontrollable kthreads create unfixable rt priority inversions in
the workqueue case, and even if workqueues could be prioritized, dynamic
worker pools can insert huge memory allocation latencies into any rt
task that depends upon a workqueue.

A couple samples:

CPU2,3 are "completely" isolated via cpusets, CPU3 is running a "super
critical" rt hog (while(1);) at FIFO:1.  Joe User fires up firefox on a
system cpuset CPU, firefox hangs, lots of things do.


marge:~ # cat /proc/5840/stack
[<ffffffff81101d0e>] sleep_on_page+0xe/0x20
[<ffffffff81101f00>] wait_on_page_bit+0x80/0x90
[<ffffffff81102004>] filemap_fdatawait_range+0xf4/0x180
[<ffffffff811035ad>] filemap_write_and_wait_range+0x4d/0x80
[<ffffffff811cab8a>] ext4_sync_file+0xca/0x290
[<ffffffff81186e38>] do_fsync+0x58/0x80
[<ffffffff81187230>] SyS_fsync+0x10/0x20
[<ffffffff81559ed2>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

rt_rq[3]:
  .rt_nr_running                 : 1
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000001

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
        kthreadd     2     32390.390741        89   120     32390.390741         1.103162    417146.885135
    kworker/u8:0     6     32390.390741        50   120     32390.390741         0.679007    303904.697089
     kworker/3:1    37     32391.042046      4971   120     32391.042046        77.975683    197424.475026
    kworker/3:1H   269     32390.390741      2542   100     32390.390741        15.520425    193210.559919
R         cpuhog  5625         0.000000        13    98         0.000000    382385.886326        89.825704

Well now, kthreadd waking to an isolated and 100% rt consumed CPU
doesn't bode well for the future of this box, that's a killer.
kworker/3:1H is what was blocking firefox and more though, bumping it to
FIFO:10 freed firefox and friends.

Try again with kthread prioritized.. evolution hangs at startup.

rt_rq[3]:
  .rt_nr_running                 : 1
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 0.000001

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
     kworker/3:1    37     32392.189438      5092   120     32392.189438        79.811331    318171.326151
R         cpuhog 15101         0.000000         4    98         0.000000     48118.123331         0.043160

marge:~ # pidof evolution
15103
marge:~ # cat /proc/15103/stack
[<ffffffff81064359>] flush_work+0x29/0x40
[<ffffffff81110113>] lru_add_drain_all+0x163/0x1a0
[<ffffffff8112df48>] SyS_mlock+0x38/0x130
[<ffffffff81559ed2>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

cpuhog 15101 [003]  5027.777502: irq:softirq_entry: vec=1 [action=TIMER]
cpuhog 15101 [003]  5027.777504: workqueue:workqueue_queue_work: work struct=0xffff88022fd8f060 function=vmstat_update workqueue=0xffff880226c5aa00 req_cpu=64 cpu=3
cpuhog 15101 [003]  5027.777505: workqueue:workqueue_activate_work: work struct 0xffff88022fd8f060
cpuhog 15101 [003]  5027.777507: sched:sched_wakeup: comm=kworker/3:1 pid=37 prio=120 success=1 target_cpu=003
cpuhog 15101 [003]  5027.777508: irq:softirq_exit: vec=1 [action=TIMER]
cpuhog 15101 [003]  5027.777508: irq:softirq_entry: vec=9 [action=RCU]
cpuhog 15101 [003]  5027.777509: irq:softirq_exit: vec=9 [action=RCU]
cpuhog 15101 [003]  5027.781500: irq:softirq_raise: vec=1 [action=TIMER]

flush_work is gonna take a while.  Bump pid 37 to FIFO:10, evolution can
finally run.

I created an ugly hack in enterprise to let the user prioritize kthreads
and/or workqueues, and that works as far as empowering the user to do
whatever he wants to do without the box just falling over, or the stuff
he thinks is super critical starving its own dependencies (or innocent
bystanders as above), and ergo itself, no matter how "clever" that
"critical stuff" may seem to me.

Most of the time, when I see these kind of issues, it's stuff that I'd
call rt abuse, but I've also recently seen some image processing stuff
that looked much more legit, and which used to be able to get away with
using a workqueue fall flat, and I had to tell the user that workqueue
should be removed from their driver, as the things are not the least bit
rt friendly.  Dynamic pool constituted a regression for that user. 

	-Mike

