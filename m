Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbaGaRbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:31:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802AbaGaRai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:30:38 -0400
Date: Thu, 31 Jul 2014 19:27:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v2 tip/core/rcu 01/10] rcu: Add call_rcu_tasks()
Message-ID: <20140731172752.GA17632@redhat.com>
References: <20140731003914.GA3872@linux.vnet.ibm.com> <1406767182-4356-1-git-send-email-paulmck@linux.vnet.ibm.com> <53D9F084.7000706@cn.fujitsu.com> <20140731160924.GR11241@linux.vnet.ibm.com> <20140731163138.GA15228@redhat.com> <20140731170232.GW11241@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731170232.GW11241@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Paul E. McKenney wrote:
>
> On Thu, Jul 31, 2014 at 06:31:38PM +0200, Oleg Nesterov wrote:
>
> > But can't we avoid get_task_struct()? This can pin a lot of task_struct's.
> > Can't we just add list_del_rcu(holdout_list) into __unhash_process() ?
>
> If I add the list_del_rcu() there, then I am back to a concurrent list,
> which I would like to avoid.  Don't get me wrong, it was fun playing with
> the list-locked stuff, but best to avoid it if we can.

OK,

> The nice thing about using get_task_struct to lock
> them down is that -only- the task_struct itself is locked down -- the
> task can be reaped and so on.

I understand. but otoh it would be nice to not pin this memory if the
task was already (auto)reaped.

And afaics the number of pinned task_struct's is not bounded. In theory
it is not even limited by, say, PID_MAX_LIMIT. A thread can exit and reap
itself right after get_task_struct() but create another running thread
which can be noticed by rcu_tasks_kthread() too.

> > We only need to ensure that list_add() above can't race with that list_del(),
> > perhaps we can tolerate lock_task_sighand() ?
>
> I am worried about a task that does a voluntary context switch, then exits.
> This could results in rcu_tasks_kthread() and __unhash_process() both
> wanting to dequeue at the same time, right?

Oh yes, I was very wrong. And we do not want to abuse tasklist_lock...

OK, let me try to read the patch first.

Oleg.

