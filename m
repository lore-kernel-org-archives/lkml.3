Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab3IIQ4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:56:37 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:58542 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab3IIQ4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:56:35 -0400
Date: Mon, 9 Sep 2013 09:56:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909165628.GA3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130909083926.3eceebef@gandalf.local.home>
 <20130909124547.GB16280@somewhere>
 <20130909085504.2ddd7e69@gandalf.local.home>
 <20130909130851.GC16280@somewhere>
 <20130909092142.05780991@gandalf.local.home>
 <20130909092917.0c99b71a@gandalf.local.home>
 <20130909144037.GH16280@somewhere>
 <20130909112057.35403440@gandalf.local.home>
 <20130909160920.GW3966@linux.vnet.ibm.com>
 <20130909123026.4560fa19@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909123026.4560fa19@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090916-1344-0000-0000-000001874728
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 12:30:26PM -0400, Steven Rostedt wrote:
> On Mon, 9 Sep 2013 09:09:20 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Oddly enough, the earliest implementations of RCU that I worked with
> > back in the early 1990s had implementation but no concept.  The concepts
> > came later.  Something about how dragging people through 1500 lines
> > of highly optimized parallel C code not being a very effective way of
> > teaching RCU.  Surprisingly enough, there actually were some people who
> > managed to learn it that way...
> 
> This is actually my point of my arguments :-)
> 
> Things that are shown outside of the rcu files should be an interface
> that reflects the concept, not the implementation (if possible). Just
> like there's nothing in "preempt_count()" that says the preempt count
> is stored on a per task field.
> 
> We can't expect the rest of the community to understand the RCU
> implementation, when there's still many that don't understand the
> concept ;-)
> 
> You can implement RCU anyway you seem fit. My concern is where very
> smart people like Peter Zijlstra stumble over code used by others that
> show:
> 
> 	preempt_disable();
> 	ret = yada_yada();
> 	preempt_enable();
> 
> 	return ret;
> 
> Where the function name states that we want CPU state, but if that's
> really true, then who ever wants CPU state must not preempt here.
> 
> The point being, here the concept actually makes more sense than the
> implementation, because I think one thing we all can agree on, is that
> the interface throughout the kernel should be something people can
> understand quickly without too much effort. The better we all can
> understand, the better the kernel will be.
> 
> I think we are starting to bike shed a bit too much. The real issue is,
> what can "rcu_is_cpu_idle()" be called that makes sense with those that
> need to look at this code?
> 
> 
> "rcu_is_not_active()" or "rcu_is_ignored()" where a user can see that,
> "Oh, RCU is ignored here, I shouldn't be using rcu_read_lock()" or if
> their code is called within something that does "rcu_is_ignored()" and
> they see that they used "rcu_read_lock()" they would understand what
> the issue is.
> 
> If they see "rcu_is_cpu_idle()" they would get confused: "Hmm, the cpu
> isn't idle here?"
> 
> Perhaps "rcu_watching_this_cpu()" may make sense, but again, if I see a
> the above preempt_enable() in that code, I would think it's a bug,
> because then the return value is not guaranteed to be on this cpu.

Indeed, the preempt_disable()/preempt_enable() pair will need a big
fat comment whatever the name turns out to be.  Without such a comment,
regardless of the name smart people would likely have objections to the
"yada_yada()" containing references to a per-CPU variable whose result
is passed out of the preempt_disable() region.

							Thanx, Paul

