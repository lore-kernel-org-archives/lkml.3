Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbaILQbC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:31:02 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60350 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbaILQbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:31:00 -0400
Date: Fri, 12 Sep 2014 09:30:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andreea-Cristina Bernat <bernat.ada@gmail.com>, paulus@samba.org,
        mingo@redhat.com, acme@kernel.org, linux-kernel@vger.kernel.org,
        stephen@networkplumber.org, eric.dumazet@gmail.com
Subject: Re: [PATCH] kernel: events: core: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Message-ID: <20140912163055.GC4775@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140822132605.GA20130@ada>
 <20140909094235.GD19379@twins.programming.kicks-ass.net>
 <20140909161648.GE4704@linux.vnet.ibm.com>
 <20140910131251.GZ4783@worktop.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910131251.GZ4783@worktop.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091216-3532-0000-0000-000004946663
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 03:12:51PM +0200, Peter Zijlstra wrote:
> On Tue, Sep 09, 2014 at 09:16:48AM -0700, Paul E. McKenney wrote:
> > On Tue, Sep 09, 2014 at 11:42:35AM +0200, Peter Zijlstra wrote:
> 
> > > Paul, why not do something like the below and do away with all this
> > > nonsense?
> > 
> > We used to do that, but the compilers became uncooperative, despite
> > Stephen Hemminger's best efforts.
> 
> Happen to have a link handy to that thread so I can educate myself?

After a bit of software archeology, here you go...

Commit d322f45ceed52 (rcu: Make rcu_assign_pointer() unconditionally
insert a memory barrier) made this change.  According to the commit
log:

    Recent changes to gcc give warning messages on rcu_assign_pointers()'s
    checks that allow it to determine when it is OK to omit the memory
    barrier.  Stephen Hemminger tried a number of gcc tricks to silence
    this warning, but #pragmas and CPP macros do not work together in the
    way that would be required to make this work.

This was applied in 2011, and searching LKML during that time gives
the following:  https://lkml.org/lkml/2011/7/29/305

And in this LKML post, Stephen Hemminger wrote:

	Gcc now generates warnings from rcu_assign_pointer when passed the
	address of something for example:
		rcu_assign_pointer(dev_queue->qdisc, &noop_qdisc);
	This warning is harmless and should be surpressed but there maybe
	other cases where we want that Gcc warning.

	I tried various combinations of in rcu_assign_pointer macro
	  #pragma GCC diagnostic push
	  #pragma GCC diagnostic ignored "-Wlogical-op"
	  ...
	  #pragma GCC diagnostic pop
	but macro's and pragma's don't nest with the correct scope for
	this.

	Maybe some one with more Gcc foo and time to waste could take
	a crack at it.

Adding Stephen on CC in case he remembers more.

							Thanx, Paul

