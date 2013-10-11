Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab3JKH0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 03:26:32 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:60480 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab3JKH0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 03:26:31 -0400
Date: Fri, 11 Oct 2013 09:26:27 +0200
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
Message-ID: <20131011072627.GA9514@gmail.com>
References: <20131008204056.GR5790@linux.vnet.ibm.com>
 <20131009032843.GA12970@linux.vnet.ibm.com>
 <20131009033502.GA14017@linux.vnet.ibm.com>
 <20131009060806.GC7664@gmail.com>
 <20131009142123.GT5790@linux.vnet.ibm.com>
 <20131010025904.GA4891@linux.vnet.ibm.com>
 <20131010080501.GA18481@gmail.com>
 <20131010171135.GL5790@linux.vnet.ibm.com>
 <20131010173937.GD26430@gmail.com>
 <20131010185819.GP5790@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010185819.GP5790@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> > So, I think this code lives within kernel/params.c. Might be fixable?
> 
> But of course!  I was just trying to be lazy. ;-)
> 
> I could imagine adding a filename field to struct kernel_param that was 
> initialized with __FILE__, then making something like parameq() that did 
> the appropriate comparison allowing any match starting after a "/" and 
> ignoring the trailing ".h" or ".c", and then calling that from 
> parse_one() along with current parameq().  There doesn't seem to be any 
> point for doing the same to do_early_param().
> 
> There would be a few surprises with this approach, for example, 
> rcu_idle_gp_delay and rcu_idle_lazy_gp_delay, which are defined in 
> kernel/rcu/tree_plugin.h, would be:
> 
> 	tree_plugin.rcu_idle_gp_delay=4
> 	tree_plugin.rcu_idle_lazy_gp_delay=6000
> 
> or:
> 
> 	rcu/tree_plugin.rcu_idle_gp_delay=4
> 	rcu/tree_plugin.rcu_idle_lazy_gp_delay=6000
> 
> or:
> 
> 	kernel/rcu/tree_plugin.rcu_idle_gp_delay=4
> 	kernel/rcu/tree_plugin.rcu_idle_lazy_gp_delay=6000
> 
> or I suppose even:
> 
> 	linux-rcu/kernel/rcu/tree_plugin.rcu_idle_gp_delay=4
> 	linux-rcu/kernel/rcu/tree_plugin.rcu_idle_lazy_gp_delay=6000
> 
> instead of (say):
> 
> 	kernel/rcu/tree.rcu_idle_gp_delay=4
> 	kernel/rcu/tree.rcu_idle_lazy_gp_delay=6000
> 
> This could of course also be fixed by comparing the filename up to the 
> last "/" followed by the current parameter name.  Or, as Peter Zijlstra 
> suggested, by manually expanding kernel/rcu/tree_plugin.h into 
> kernel/rcu/tree.c.
> 
> Or I could use the non-standard __BASE_FILE__ instead of __FILE__, which 
> expands to .../kernel/rcu/tree.c.  LLVM seems to define this as well, so 
> should be OK to use.
> 
> So it doesn't look too horrible.  (Famous last words...)

Hm, I'm not so sure about the long names, for the following reasons: 
strings like 'kernel/rcu/tree_plugin.' might mean a lot to us kernel 
developers - less to sysadmins and users who would want to utilize them.

There's also a typo danger with overly long parameters and the parameter 
parser is not very intelligent about seeing the intent of the user.

So I think while rcu/tree.val would be useful syntax, going above that, 
especially with auto-generated file names (and file names can change) 
would be overdoing it a bit :-/

Thanks,

	Ingo
