Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaBSHAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 02:00:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51090 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaBSHAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 02:00:37 -0500
Message-ID: <1392793215.5423.51.camel@marge.simpson.net>
Subject: Re: [RFC PATCH] rcu: move SRCU grace period work to power efficient
 workqueue
From: Mike Galbraith <bitbucket@online.de>
To: paulmck@linux.vnet.ibm.com
Cc: Kevin Hilman <khilman@linaro.org>, Tejun Heo <tj@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Zoran Markovic <zoran.markovic@linaro.org>,
        linux-kernel@vger.kernel.org,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Date: Wed, 19 Feb 2014 08:00:15 +0100
In-Reply-To: <1392612613.5565.78.camel@marge.simpson.net>
References: <1391197986-12774-1-git-send-email-zoran.markovic@linaro.org>
	 <52F8A51F.4090909@cn.fujitsu.com>
	 <20140210184729.GL4250@linux.vnet.ibm.com>
	 <20140212182336.GD5496@localhost.localdomain>
	 <20140212190241.GD4250@linux.vnet.ibm.com>
	 <20140212192354.GC26809@htj.dyndns.org> <7hk3cx46rw.fsf@paris.lan>
	 <1392449804.5517.45.camel@marge.simpson.net>
	 <20140216164106.GD4250@linux.vnet.ibm.com>
	 <1392612613.5565.78.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:e8PmIMdFgSGfTgFAf2LOnLNU1Cj7oRVAI0AhJAy/TSg
 85El4u1E/enBhyOhaaRmoaRuMQ4/BUKAEdZ5+xyiTFw0/chEtY
 2K5yTyBDUaIeWrL+63aNkbqmDvgzyRKurXQ1RAwYSepeWOyoyt
 GWvLv7aERmIIOjkBkP0g0FiORn6FZGvH1EUUngOq0NgmdYQVzb
 /+rU4pIlm3WXm+E0pCjj3mdNjbu6OeB4cmrjkorCzz1Kqdm7kh
 79+MXGuUdjBrChsfZpmrmIx6DW10b3srKPJV7U9dvnpU5yKQW5
 tCB1mvefFDtOpj5iCOowV1WIenmsOgykyAaO9WzqY/yay4F5op
 H/WSS5QApwke3tzCenG0THNdBSs2R7GNXn4wgJOxFcIKXV4+m0
 CyhM/hJ/JXzpg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-17 at 05:50 +0100, Mike Galbraith wrote: 
> On Sun, 2014-02-16 at 08:41 -0800, Paul E. McKenney wrote:

> > So maybe start with Kevin's patch, but augment with something else for
> > the !NO_HZ_FULL case?
> 
> Sure (hm, does it work without workqueue.disable_numa ?).

I took patch out for a spin on a 40 core box +SMT, with CPUs 4-79
isolated via exclusive cpuset with load balancing off.  Worker bees
ignored patch either way.

-Mike

Perturbation measurement hog pinned to CPU4.

With patch:

#           TASK-PID   CPU#  ||||||  TIMESTAMP  FUNCTION
#              | |       |   ||||||     |         |
            pert-9949  [004] ....113   405.120164: workqueue_queue_work: work struct=ffff880a5c4ecc08 function=flush_to_ldisc workqueue=ffff88046f40ba00 req_cpu=256 cpu=4
            pert-9949  [004] ....113   405.120166: workqueue_activate_work: work struct ffff880a5c4ecc08
            pert-9949  [004] d.L.313   405.120169: sched_wakeup: comm=kworker/4:2 pid=2119 prio=120 success=1 target_cpu=004
            pert-9949  [004] d.Lh213   405.120170: tick_stop: success=no msg=more than 1 task in runqueue
            pert-9949  [004] d.L.213   405.120172: tick_stop: success=no msg=more than 1 task in runqueue
            pert-9949  [004] d...3..   405.120173: sched_switch: prev_comm=pert prev_pid=9949 prev_prio=120 prev_state=R+ ==> next_comm=kworker/4:2 next_pid=2119 next_prio=120
     kworker/4:2-2119  [004] ....1..   405.120174: workqueue_execute_start: work struct ffff880a5c4ecc08: function flush_to_ldisc
     kworker/4:2-2119  [004] d...311   405.120176: sched_wakeup: comm=sshd pid=6620 prio=120 success=1 target_cpu=000
     kworker/4:2-2119  [004] ....1..   405.120176: workqueue_execute_end: work struct ffff880a5c4ecc08
     kworker/4:2-2119  [004] d...3..   405.120177: sched_switch: prev_comm=kworker/4:2 prev_pid=2119 prev_prio=120 prev_state=S ==> next_comm=pert next_pid=9949 next_prio=120
            pert-9949  [004] ....113   405.120178: workqueue_queue_work: work struct=ffff880a5c4ecc08 function=flush_to_ldisc workqueue=ffff88046f40ba00 req_cpu=256 cpu=4
            pert-9949  [004] ....113   405.120179: workqueue_activate_work: work struct ffff880a5c4ecc08
            pert-9949  [004] d.L.313   405.120179: sched_wakeup: comm=kworker/4:2 pid=2119 prio=120 success=1 target_cpu=004
            pert-9949  [004] d.L.213   405.120181: tick_stop: success=no msg=more than 1 task in runqueue
            pert-9949  [004] d...3..   405.120181: sched_switch: prev_comm=pert prev_pid=9949 prev_prio=120 prev_state=R+ ==> next_comm=kworker/4:2 next_pid=2119 next_prio=120
     kworker/4:2-2119  [004] ....1..   405.120182: workqueue_execute_start: work struct ffff880a5c4ecc08: function flush_to_ldisc
     kworker/4:2-2119  [004] ....1..   405.120183: workqueue_execute_end: work struct ffff880a5c4ecc08
     kworker/4:2-2119  [004] d...3..   405.120183: sched_switch: prev_comm=kworker/4:2 prev_pid=2119 prev_prio=120 prev_state=S ==> next_comm=pert next_pid=9949 next_prio=120
            pert-9949  [004] d...1..   405.120736: tick_stop: success=yes msg= 
            pert-9949  [004] ....113   410.121082: workqueue_queue_work: work struct=ffff880a5c4ecc08 function=flush_to_ldisc workqueue=ffff88046f40ba00 req_cpu=256 cpu=4
            pert-9949  [004] ....113   410.121082: workqueue_activate_work: work struct ffff880a5c4ecc08
            pert-9949  [004] d.L.313   410.121084: sched_wakeup: comm=kworker/4:2 pid=2119 prio=120 success=1 target_cpu=004
            pert-9949  [004] d.Lh213   410.121085: tick_stop: success=no msg=more than 1 task in runqueue
            pert-9949  [004] d.L.213   410.121087: tick_stop: success=no msg=more than 1 task in runqueue
            ...and so on until tick time


(extra cheezy) hack kinda sorta works iff workqueue.disable_numa:

---
 kernel/workqueue.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1328,8 +1328,11 @@ static void __queue_work(int cpu, struct
 
 	rcu_read_lock();
 retry:
-	if (req_cpu == WORK_CPU_UNBOUND)
+	if (req_cpu == WORK_CPU_UNBOUND) {
 		cpu = raw_smp_processor_id();
+		if (runqueue_is_isolated(cpu))
+			cpu = 0;
+	}
 
 	/* pwq which will be used unless @work is executing elsewhere */
 	if (!(wq->flags & WQ_UNBOUND))


#           TASK-PID   CPU#  ||||||  TIMESTAMP  FUNCTION
#              | |       |   ||||||     |         |
           <...>-33824 [004] ....113  5555.889694: workqueue_queue_work: work struct=ffff880a596eb008 function=flush_to_ldisc workqueue=ffff88046f40ba00 req_cpu=256 cpu=0
           <...>-33824 [004] ....113  5555.889695: workqueue_activate_work: work struct ffff880a596eb008
           <...>-33824 [004] d...313  5555.889697: sched_wakeup: comm=kworker/0:2 pid=2105 prio=120 success=1 target_cpu=000
           <...>-33824 [004] ....113  5560.890594: workqueue_queue_work: work struct=ffff880a596eb008 function=flush_to_ldisc workqueue=ffff88046f40ba00 req_cpu=256 cpu=0
           <...>-33824 [004] ....113  5560.890595: workqueue_activate_work: work struct ffff880a596eb008
           <...>-33824 [004] d...313  5560.890596: sched_wakeup: comm=kworker/0:2 pid=2105 prio=120 success=1 target_cpu=000
           <...>-33824 [004] ....113  5565.891493: workqueue_queue_work: work struct=ffff880a596eb008 function=flush_to_ldisc workqueue=ffff88046f40ba00 req_cpu=256 cpu=0
           <...>-33824 [004] ....113  5565.891493: workqueue_activate_work: work struct ffff880a596eb008
           <...>-33824 [004] d...313  5565.891494: sched_wakeup: comm=kworker/0:2 pid=2105 prio=120 success=1 target_cpu=000
           <...>-33824 [004] ....113  5570.892401: workqueue_queue_work: work struct=ffff880a596eb008 function=flush_to_ldisc workqueue=ffff88046f40ba00 req_cpu=256 cpu=0
           <...>-33824 [004] ....113  5570.892401: workqueue_activate_work: work struct ffff880a596eb008
           <...>-33824 [004] d...313  5570.892403: sched_wakeup: comm=kworker/0:2 pid=2105 prio=120 success=1 target_cpu=000
           <...>-33824 [004] ....113  5575.893300: workqueue_queue_work: work struct=ffff880a596eb008 function=flush_to_ldisc workqueue=ffff88046f40ba00 req_cpu=256 cpu=0
           <...>-33824 [004] ....113  5575.893301: workqueue_activate_work: work struct ffff880a596eb008
           <...>-33824 [004] d...313  5575.893302: sched_wakeup: comm=kworker/0:2 pid=2105 prio=120 success=1 target_cpu=000
           <...>-33824 [004] d..h1..  5578.854979: softirq_raise: vec=1 [action=TIMER]
           <...>-33824 [004] dN..3..  5578.854981: sched_wakeup: comm=sirq-timer/4 pid=319 prio=69 success=1 target_cpu=004
           <...>-33824 [004] dN..1..  5578.854982: tick_stop: success=no msg=more than 1 task in runqueue
           <...>-33824 [004] dN.h1..  5578.854983: tick_stop: success=no msg=more than 1 task in runqueue
           <...>-33824 [004] dN..1..  5578.854985: tick_stop: success=no msg=more than 1 task in runqueue
           <...>-33824 [004] d...3..  5578.854986: sched_switch: prev_comm=pert prev_pid=33824 prev_prio=120 prev_state=R+ ==> next_comm=sirq-timer/4 next_pid=319 next_prio=69
    sirq-timer/4-319   [004] d..h3..  5578.854987: softirq_raise: vec=1 [action=TIMER]
    sirq-timer/4-319   [004] d...3..  5578.854989: tick_stop: success=no msg=more than 1 task in runqueue
    sirq-timer/4-319   [004] ....111  5578.854990: softirq_entry: vec=1 [action=TIMER]
    sirq-timer/4-319   [004] ....111  5578.855194: softirq_exit: vec=1 [action=TIMER]     <== 204us tick, not good... to_stare_at++
    sirq-timer/4-319   [004] d...3..  5578.855196: sched_switch: prev_comm=sirq-timer/4 prev_pid=319 prev_prio=69 prev_state=S ==> next_comm=pert next_pid=33824 next_prio=120
           <...>-33824 [004] d...1..  5578.855987: tick_stop: success=yes msg= 
           ...etc


