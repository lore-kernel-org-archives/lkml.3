Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbaJWT7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 15:59:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028AbaJWT7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 15:59:49 -0400
Date: Thu, 23 Oct 2014 21:56:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] document ->sighand protection,
	rcu_read_unlock() deadlocks
Message-ID: <20141023195604.GA7899@redhat.com>
References: <20140922164404.GA28910@redhat.com> <20140928214357.GA17874@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140928214357.GA17874@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping ;)

Paul, should I resend or you do not think this can go via your rcu
tree?

On 09/28, Oleg Nesterov wrote:
>
> Paul, could you take these 2 doc patches? Assuming that you agree
> with the comments, of course.
>
> On 09/24, Paul E. McKenney wrote:
> >
> > On Tue, Sep 23, 2014 at 09:03:48PM +0200, Oleg Nesterov wrote:
> > >
> > > Paul, will you agree if we turn it into
> > > ...
> > >      /*
> > >       * On the succesfull return we hold ->siglock. According to comment
> > >       * above rcu_read_unlock() this is against the rules, but scheduler
> > >       * locks are fine under this lock, signal_wake_up() takes them too.
> > >       */
> > >      rcu_read_unlock();
> >
> > If you guys continue the guarantee of no deadlock, I am OK with this change.
>
> Heh. Contrary to what I said (and you all were agree ;), this deadlock
> is actually possible, so we can not remove the deadlock-avoidance from
> __lock_task_sighand(). And I do not see how we can cleanup this code
> because preempt_disable() + spin_lock() is not -rt friendly.
>
> I think this deserves a bit of documentation, see 2/2. Perhaps this is
> just me, but imo the current comment is a bit misleading.
>
> "if the caller of rcu_read_unlock() already holds one of these locks ..."
> is not a problem in fact. I mean, pi_lock or rq->lock are special enough,
> nobody should ever call the outermost rcu_read_unlock() with these locks
> held. rt_mutex->wait_lock should be fine too, also because ->boost_mtx
> is private to rcu_boost() and rcu_read_unlock_special().
>
> But. They can race with each other, and that is why rcu_read_unlock()
> under (say) ->siglock can actually lead to deadlock. And only because
> rt_mutex->wait_lock doesn't disable irqs. Or I am totally confused.
>
> Perhaps we can change rtmutex.c to use raw_spin_lock_irqsave(), or do
> something else...
>
> Oleg.
>
>  include/linux/rcupdate.h |    4 +++-
>  kernel/fork.c            |    5 ++++-
>  kernel/signal.c          |   12 +++++++++++-
>  3 files changed, 18 insertions(+), 3 deletions(-)

