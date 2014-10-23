Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008AbaJWUdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 16:33:36 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35682 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932240AbaJWUdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 16:33:33 -0400
Date: Thu, 23 Oct 2014 13:29:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] document ->sighand protection,
	rcu_read_unlock() deadlocks
Message-ID: <20141023202939.GF4977@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140922164404.GA28910@redhat.com>
 <20140928214357.GA17874@redhat.com>
 <20141023195604.GA7899@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023195604.GA7899@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102320-0029-0000-0000-000000DC8CDC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 09:56:04PM +0200, Oleg Nesterov wrote:
> Ping ;)
> 
> Paul, should I resend or you do not think this can go via your rcu
> tree?

Please accept my apologies for missing these!

They are now queued for 3.19.

							Thanx, Paul

> On 09/28, Oleg Nesterov wrote:
> >
> > Paul, could you take these 2 doc patches? Assuming that you agree
> > with the comments, of course.
> >
> > On 09/24, Paul E. McKenney wrote:
> > >
> > > On Tue, Sep 23, 2014 at 09:03:48PM +0200, Oleg Nesterov wrote:
> > > >
> > > > Paul, will you agree if we turn it into
> > > > ...
> > > >      /*
> > > >       * On the succesfull return we hold ->siglock. According to comment
> > > >       * above rcu_read_unlock() this is against the rules, but scheduler
> > > >       * locks are fine under this lock, signal_wake_up() takes them too.
> > > >       */
> > > >      rcu_read_unlock();
> > >
> > > If you guys continue the guarantee of no deadlock, I am OK with this change.
> >
> > Heh. Contrary to what I said (and you all were agree ;), this deadlock
> > is actually possible, so we can not remove the deadlock-avoidance from
> > __lock_task_sighand(). And I do not see how we can cleanup this code
> > because preempt_disable() + spin_lock() is not -rt friendly.
> >
> > I think this deserves a bit of documentation, see 2/2. Perhaps this is
> > just me, but imo the current comment is a bit misleading.
> >
> > "if the caller of rcu_read_unlock() already holds one of these locks ..."
> > is not a problem in fact. I mean, pi_lock or rq->lock are special enough,
> > nobody should ever call the outermost rcu_read_unlock() with these locks
> > held. rt_mutex->wait_lock should be fine too, also because ->boost_mtx
> > is private to rcu_boost() and rcu_read_unlock_special().
> >
> > But. They can race with each other, and that is why rcu_read_unlock()
> > under (say) ->siglock can actually lead to deadlock. And only because
> > rt_mutex->wait_lock doesn't disable irqs. Or I am totally confused.
> >
> > Perhaps we can change rtmutex.c to use raw_spin_lock_irqsave(), or do
> > something else...
> >
> > Oleg.
> >
> >  include/linux/rcupdate.h |    4 +++-
> >  kernel/fork.c            |    5 ++++-
> >  kernel/signal.c          |   12 +++++++++++-
> >  3 files changed, 18 insertions(+), 3 deletions(-)
> 

