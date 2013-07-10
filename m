Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab3GJOxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:53:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51692 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3GJOxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:53:38 -0400
Date: Wed, 10 Jul 2013 16:52:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: mtosatti@redhat.com, mingo@redhat.com, gleb@redhat.com,
        glommer@parallels.com, tglx@linutronix.de, jeremy@goop.org,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: sched: add notifier for cross-cpu migrations
Message-ID: <20130710145238.GW25631@dyad.programming.kicks-ass.net>
References: <20130710103440.GO25631@dyad.programming.kicks-ass.net>
 <20130710143902.GA28514@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130710143902.GA28514@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 04:39:02PM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Hi,
> > 
> > I just stumbled over commit 582b336ec2 and had a massive WTF moment.
> > 
> > The Changelog -- empty!
> > The Implementation -- complete crap!
> > 
> > fail^2.
> > 
> > A git grep later I find its x86_64 paravirt only.. for this we add 
> > unconditional crap to the scheduler?
> > 
> > At the _very_ least this should have been wrapped in a static_key and 
> > the changelog should have given some clue as to the what and why of this 
> > code.
> 
> My bad for letting it slip through...
> 
> Marcelo, mind implementing the suggestions from Peter?

So ideally we'd kill the entire notifier, notifiers make it far too easy for
others to use -- and I don't want silent users of stuff like this.

Ideally I'd see a direct callback:

  pvclock_migration_callback(t, new_cpu);

That compiles to 'do { } while (0);' for kernels without CONFIG_PARAVIRT.  Then
for paravirt it would use a static_key to get a real callback only if there's a
pvclock user.

Something like:

#define pvclock_migration_callback(_t, _cpu)			\
do {								\
	if (static_key_false(&pvclock_key))			\
		__pvclock_migration_callback((_t), (_cpu));	\
} while (0)

NOTE: static_key_false() doesn't test false, it assumes the default is false
and makes the function call the out-of-line jump -- horridly confusing function
name.

Your pvclock muck would do:

 static_key_slow_inc() -- for every new user and,
 static_key_slow_dec() -- for every user gone.

Its a reference count scheme, so that when there's no users there is only a 5
byte nop.
