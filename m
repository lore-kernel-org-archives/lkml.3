Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054AbaDJSrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:47:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54599 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaDJSrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:47:21 -0400
Date: Thu, 10 Apr 2014 19:36:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/5] sched: Convert thread_group_cputime() to use
 for_each_thread()
Message-ID: <20140410173610.GG26782@laptop.programming.kicks-ass.net>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com>
 <1397059882-23063-2-git-send-email-fweisbec@gmail.com>
 <20140409171607.GA13498@dyad.arnhem.chello.nl>
 <20140409173233.GA28615@redhat.com>
 <20140409183017.GF10526@twins.programming.kicks-ass.net>
 <20140409194603.GB5854@redhat.com>
 <20140409194957.GD26782@laptop.programming.kicks-ass.net>
 <20140410161955.GG13658@twins.programming.kicks-ass.net>
 <20140410172938.GA32332@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410172938.GA32332@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 07:29:38PM +0200, Oleg Nesterov wrote:
> >  #define do_each_thread(g, t) \
> >  	for (g = t = &init_task ; (g = t = next_task(g)) != &init_task ; ) do
> > @@ -2384,11 +2387,8 @@ extern bool current_is_single_threaded(void);
> >  #define while_each_thread(g, t) \
> >  	while ((t = next_thread(t)) != g)
> >  
> > -#define __for_each_thread(signal, t)	\
> > -	list_for_each_entry_rcu(t, &(signal)->thread_head, thread_node)
> > -
> >  #define for_each_thread(p, t)		\
> > -	__for_each_thread((p)->signal, t)
> > +	list_for_each_entry_rcu(t, &(p)->signal->thread_head, thread_node)
> 
> Why? __for_each_thread(signal) can generate a better code, if we do care.

Well, there were no users and it wasn't mentioned anywhere.

> In fact, ignoring the bad "signal" name, __for_each_thread(signal, t)
> even looks better. "signal" represents the whole thread group.
> 
> But I won't argue. Besides, this reminds me about CONST_CAST() and making
> task_struct->signal "const". This can improve the code generation too.

Yeah, I always disliked how we mixed up the signal handling and the
thread group stuff. We should probably rename the lot.

> > +static inline __deprecated
> > +struct task_struct *next_thread(const struct task_struct *p)
> >  {
> 
> Not sure... But probably fine too.
> 
> I already killed some users of next_thread(). This reminds me about
> next_tid(), probably it should be converted too.
> 
> As for, say, __exit_signal() it really needs next_thread(). We can fix
> it instead of deprecating, or we can add another one with another name.

Well, your Changelog said that next_thread() was faulty too; if
__exit_signal() is the only site where it is correct we can open-code it
there. If there's more we should probably create a new function and
audit all current sites.
