Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab3JRMRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:17:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599Ab3JRMRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:17:44 -0400
Date: Fri, 18 Oct 2013 14:10:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: paulmck@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] rcusync: Introduce struct rcu_sync_ops
Message-ID: <20131018121015.GA24753@redhat.com>
References: <20131008102505.404025673@infradead.org> <20131008103830.291708447@infradead.org> <525F4653.809@cn.fujitsu.com> <20131017154228.GL4553@linux.vnet.ibm.com> <52608D88.6010807@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52608D88.6010807@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18, Lai Jiangshan wrote:
>
> On 10/17/2013 11:42 PM, Paul E. McKenney wrote:
> > On Thu, Oct 17, 2013 at 10:07:15AM +0800, Lai Jiangshan wrote:
> >> On 10/08/2013 06:25 PM, Peter Zijlstra wrote:
> >>> From: Oleg Nesterov <oleg@redhat.com>
> >>>
> >>> Add the new struct rcu_sync_ops which holds sync/call methods, and
> >>> turn the function pointers in rcu_sync_struct into an array of struct
> >>> rcu_sync_ops.
> >>
> >> Hi, Paul
> >>
> >> I think this work should be done in rcupdate.[ch] side by introducing
> >> struct rcu_flavor.
> >
> > I -do- have on my list to add an rcutorture test for rcu_sync, but
> > what do you have in mind by adding struct rcu_flavor?  I am guessing
> > that you do not mean to try to create an rcu_state and a set of
>
> No.
> The thing what I need is just as same as Oleg Nesterov implemented.
> It is just a structure with several function pointers for different RCU variants.
> But it would be better if we implement in rcupdate.[ch],
> and name it to struct rcu_flavor like the URCU.
>
> After we have struct rcu_flavor, we can replace the following code
> to a pointer to struct rcu_flavor.
>
> struct rcu_state:
> 	void (*call)(struct rcu_head *head,	/* call_rcu() flavor. */
> 		     void (*func)(struct rcu_head *head));
>
> struct rcu_torture_ops {
> 	int (*readlock)(void);
> 	void (*readunlock)(int idx);
> 	void (*sync)(void);
> 	void (*exp_sync)(void);
> 	void (*call)(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
> 	void (*cb_barrier)(void);
> };

Yes, probably. But it is not clear how/when this rcu_sync will be merged.
(I hope it will be merged anyway, if nothing else I'll resend these patches
 for percpu_rw_semaphore with other updates in percpu-rwsem.c).

Until then, perhaps you can add rcu_flavor/whatever in rcupdate.* ? Then
rcu_sync can be triviallly updated to use the ops we have in rcupdate.
And rcutorture.c of course.

IOW, I think that this should be a separate change, before or after
rcu_sync.

Oleg.

