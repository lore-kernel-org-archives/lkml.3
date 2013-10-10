Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab3JJRjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 13:39:42 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:53364 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab3JJRjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 13:39:41 -0400
Date: Thu, 10 Oct 2013 19:39:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo.kernel.org@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] sched/wait: Collapse __wait_event macros -v5
Message-ID: <20131010173937.GD26430@gmail.com>
References: <20131008141657.GW5790@linux.vnet.ibm.com>
 <20131008194718.GD7315@gmail.com>
 <20131008204056.GR5790@linux.vnet.ibm.com>
 <20131009032843.GA12970@linux.vnet.ibm.com>
 <20131009033502.GA14017@linux.vnet.ibm.com>
 <20131009060806.GC7664@gmail.com>
 <20131009142123.GT5790@linux.vnet.ibm.com>
 <20131010025904.GA4891@linux.vnet.ibm.com>
 <20131010080501.GA18481@gmail.com>
 <20131010171135.GL5790@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010171135.GL5790@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Thu, Oct 10, 2013 at 10:05:01AM +0200, Ingo Molnar wrote:
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > And it now builds, boots, and passes short rcutorture tests, updated 
> > > patch below.
> > > 
> > > One side-effect is the boot parameters, namely that what used to be 
> > > rcutree.blimit=10 is now simply tree.blimit=10.  Not a problem for me, I 
> > > just made my test scripts probe the source tree and generate the 
> > > corresponding format.  But is there some straightforward way to get the 
> > > name of the "rcu" directory involved?  The obvious approach of 
> > > "rcu.tree.blimit=10" does not work -- the kernel happily ignores any 
> > > such parameter.
> > 
> > Hm, that boot option parser attitude is a bit sad - more structure to boot 
> > parameters is IMHO a Good Thing.
> 
> No argument here!
> 
> > Does it accept :
> > 
> > 	rcu/tree/blimit=10
> > 
> > 	rcu/tree.blimit=10
> > 
> > type of structure perhaps?
> 
> Unfortunately, no.  :-(

So, I think this code lives within kernel/params.c. Might be fixable?

> 
> > > It looks like I should be able to do something like the following in 
> > > kernel/rcu/tree.c to get back the old parameter names:
> > > 
> > > MODULE_ALIAS("rcutree");
> > > #ifdef MODULE_PARAM_PREFIX
> > > #undef MODULE_PARAM_PREFIX
> > > #endif
> > > #define MODULE_PARAM_PREFIX "rcutree."
> > 
> > Yeah.
> > 
> > ( To keep it simple, the undef should be unnecessary, it's not like anyone 
> >   can slip in a MODULE_PARAM_PREFIX without you noticing, right? )
> 
> Works with the #undef, trying it without it...  And it works, but I do 
> get the following complaint from the compiler:
> 
> /home/paulmck/public_git/linux-rcu/kernel/rcu/tree.c:66:0: warning: "MODULE_PARAM_PREFIX" redefined [enabled by default]
> /home/paulmck/public_git/linux-rcu/include/linux/moduleparam.h:13:0: note: this is the location of the previous definition
> 
> The problem is that moduleparam.h contains the following:
> 
> #define MODULE_PARAM_PREFIX KBUILD_MODNAME "."
> 
> So the #undef is ugly, but better than the compiler warning.  :-(

agreed.

Thanks,

	Ingo
