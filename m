Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaAOQ0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 11:26:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbaAOQ0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 11:26:02 -0500
Date: Wed, 15 Jan 2014 17:25:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/timers 1/3] timers: Reduce __run_timers()
	latency for empty list
Message-ID: <20140115162531.GA11499@redhat.com>
References: <20140114041449.GA13934@linux.vnet.ibm.com> <1389672919-14621-1-git-send-email-paulmck@linux.vnet.ibm.com> <20140114184828.GA29331@redhat.com> <20140114235015.GZ10038@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114235015.GZ10038@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14, Paul E. McKenney wrote:
>
> On Tue, Jan 14, 2014 at 07:48:28PM +0100, Oleg Nesterov wrote:
> > >  __internal_add_timer(struct tvec_base *base, struct timer_list *timer)
> > >  {
> > > @@ -1146,6 +1157,10 @@ static inline void __run_timers(struct tvec_base *base)
> > >  	struct timer_list *timer;
> > >
> > >  	spin_lock_irq(&base->lock);
> >
> > Do we really need to take base->lock before catchup_timer_jiffies() ?
> > ->timer_jiffies can only be changed by us, and it seems that we do
> > not care if we race with base->active_timers++.
>
> Given that this lock should be almost always acquired by the current
> CPU, the penalty for acquiring it should be low.  After all, we were
> acquiring it prior to this patch as many times as we are after this patch,
> right?

Yes. But

	if (catchup_timer_jiffies())
		return;

looks a bit simpler and can save a couple of insn. I won't argue of course,
this is minor. And you already sent v2, I'll try add some comments...

Oleg.

