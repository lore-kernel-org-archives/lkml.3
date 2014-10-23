Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580AbaJWTQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 15:16:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932122AbaJWTQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 15:16:38 -0400
Date: Thu, 23 Oct 2014 21:13:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        htejun@gmail.com
Subject: Re: rcu_preempt detected stalls.
Message-ID: <20141023191319.GA5137@redhat.com>
References: <20141013173504.GA27955@redhat.com> <20141023183232.GW4977@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023183232.GW4977@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23, Paul E. McKenney wrote:
>
> On Mon, Oct 13, 2014 at 01:35:04PM -0400, Dave Jones wrote:
> > Today in "rcu stall while fuzzing" news:
> >
> > INFO: rcu_preempt detected stalls on CPUs/tasks:
> > 	Tasks blocked on level-0 rcu_node (CPUs 0-3): P766 P646
> > 	Tasks blocked on level-0 rcu_node (CPUs 0-3): P766 P646
> > 	(detected by 0, t=6502 jiffies, g=75434, c=75433, q=0)
> > trinity-c342    R  running task    13384   766  32295 0x00000000
> >  ffff880068943d58 0000000000000002 0000000000000002 ffff880193c8c680
> >  00000000001d4100 0000000000000000 ffff880068943fd8 00000000001d4100
> >  ffff88024302c680 ffff880193c8c680 ffff880068943fd8 0000000000000000
> > Call Trace:
> >  [<ffffffff888368e2>] preempt_schedule_irq+0x52/0xb0
> >  [<ffffffff8883df10>] retint_kernel+0x20/0x30
> >  [<ffffffff880d9424>] ? lock_acquire+0xd4/0x2b0
> >  [<ffffffff8808d495>] ? kill_pid_info+0x5/0x130
> >  [<ffffffff8808d4d5>] kill_pid_info+0x45/0x130
> >  [<ffffffff8808d495>] ? kill_pid_info+0x5/0x130
> >  [<ffffffff8808d6d2>] SYSC_kill+0xf2/0x2f0
> >  [<ffffffff8808d67b>] ? SYSC_kill+0x9b/0x2f0
> >  [<ffffffff8819c2b7>] ? context_tracking_user_exit+0x57/0x280
> >  [<ffffffff880136bd>] ? syscall_trace_enter+0x13d/0x310
> >  [<ffffffff8808fd9e>] SyS_kill+0xe/0x10
> >  [<ffffffff8883d3a4>] tracesys+0xdd/0xe2
>
> Well, there is a loop in kill_pid_info().  I am surprised that it
> would loop indefinitely, but if it did, you would certainly get
> RCU CPU stalls.  Please see patch below, adding Oleg for his thoughts.

Yes, this loops should not be a problem, we only restart if we race with
a multi-threaded exec from a non-leader thread.

But I already saw a couple of bug-reports which look as a task_struct
corruption (->signal/creds == NULL), looks like something was broken
recently. Perhaps an unbalanced put_task_struct...

_Perhaps_ this is another case. If ->sighand was nullified then it will
loop forever.

Oleg.

