Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab3JJS6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:58:30 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:41099 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934Ab3JJS61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:58:27 -0400
Date: Thu, 10 Oct 2013 11:58:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo.kernel.org@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] sched/wait: Collapse __wait_event macros -v5
Message-ID: <20131010185819.GP5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131008194718.GD7315@gmail.com>
 <20131008204056.GR5790@linux.vnet.ibm.com>
 <20131009032843.GA12970@linux.vnet.ibm.com>
 <20131009033502.GA14017@linux.vnet.ibm.com>
 <20131009060806.GC7664@gmail.com>
 <20131009142123.GT5790@linux.vnet.ibm.com>
 <20131010025904.GA4891@linux.vnet.ibm.com>
 <20131010080501.GA18481@gmail.com>
 <20131010171135.GL5790@linux.vnet.ibm.com>
 <20131010173937.GD26430@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010173937.GD26430@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101018-9332-0000-0000-000001B884DD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 07:39:37PM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Thu, Oct 10, 2013 at 10:05:01AM +0200, Ingo Molnar wrote:
> > > 
> > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > > 
> > > > And it now builds, boots, and passes short rcutorture tests, updated 
> > > > patch below.
> > > > 
> > > > One side-effect is the boot parameters, namely that what used to be 
> > > > rcutree.blimit=10 is now simply tree.blimit=10.  Not a problem for me, I 
> > > > just made my test scripts probe the source tree and generate the 
> > > > corresponding format.  But is there some straightforward way to get the 
> > > > name of the "rcu" directory involved?  The obvious approach of 
> > > > "rcu.tree.blimit=10" does not work -- the kernel happily ignores any 
> > > > such parameter.
> > > 
> > > Hm, that boot option parser attitude is a bit sad - more structure to boot 
> > > parameters is IMHO a Good Thing.
> > 
> > No argument here!
> > 
> > > Does it accept :
> > > 
> > > 	rcu/tree/blimit=10
> > > 
> > > 	rcu/tree.blimit=10
> > > 
> > > type of structure perhaps?
> > 
> > Unfortunately, no.  :-(
> 
> So, I think this code lives within kernel/params.c. Might be fixable?

But of course!  I was just trying to be lazy. ;-)

I could imagine adding a filename field to struct kernel_param that
was initialized with __FILE__, then making something like parameq()
that did the appropriate comparison allowing any match starting after a
"/" and ignoring the trailing ".h" or ".c", and then calling that from
parse_one() along with current parameq().  There doesn't seem to be any
point for doing the same to do_early_param().

There would be a few surprises with this approach, for example,
rcu_idle_gp_delay and rcu_idle_lazy_gp_delay, which are defined
in kernel/rcu/tree_plugin.h, would be:

	tree_plugin.rcu_idle_gp_delay=4
	tree_plugin.rcu_idle_lazy_gp_delay=6000

or:

	rcu/tree_plugin.rcu_idle_gp_delay=4
	rcu/tree_plugin.rcu_idle_lazy_gp_delay=6000

or:

	kernel/rcu/tree_plugin.rcu_idle_gp_delay=4
	kernel/rcu/tree_plugin.rcu_idle_lazy_gp_delay=6000

or I suppose even:

	linux-rcu/kernel/rcu/tree_plugin.rcu_idle_gp_delay=4
	linux-rcu/kernel/rcu/tree_plugin.rcu_idle_lazy_gp_delay=6000

instead of (say):

	kernel/rcu/tree.rcu_idle_gp_delay=4
	kernel/rcu/tree.rcu_idle_lazy_gp_delay=6000

This could of course also be fixed by comparing the filename up to
the last "/" followed by the current parameter name.  Or, as Peter
Zijlstra suggested, by manually expanding kernel/rcu/tree_plugin.h into
kernel/rcu/tree.c.

Or I could use the non-standard __BASE_FILE__ instead of __FILE__, which
expands to .../kernel/rcu/tree.c.  LLVM seems to define this as well,
so should be OK to use.

So it doesn't look too horrible.  (Famous last words...)

Thoughts?

> > > > It looks like I should be able to do something like the following in 
> > > > kernel/rcu/tree.c to get back the old parameter names:
> > > > 
> > > > MODULE_ALIAS("rcutree");
> > > > #ifdef MODULE_PARAM_PREFIX
> > > > #undef MODULE_PARAM_PREFIX
> > > > #endif
> > > > #define MODULE_PARAM_PREFIX "rcutree."
> > > 
> > > Yeah.
> > > 
> > > ( To keep it simple, the undef should be unnecessary, it's not like anyone 
> > >   can slip in a MODULE_PARAM_PREFIX without you noticing, right? )
> > 
> > Works with the #undef, trying it without it...  And it works, but I do 
> > get the following complaint from the compiler:
> > 
> > /home/paulmck/public_git/linux-rcu/kernel/rcu/tree.c:66:0: warning: "MODULE_PARAM_PREFIX" redefined [enabled by default]
> > /home/paulmck/public_git/linux-rcu/include/linux/moduleparam.h:13:0: note: this is the location of the previous definition
> > 
> > The problem is that moduleparam.h contains the following:
> > 
> > #define MODULE_PARAM_PREFIX KBUILD_MODNAME "."
> > 
> > So the #undef is ugly, but better than the compiler warning.  :-(
> 
> agreed.
> 
> Thanks,
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

