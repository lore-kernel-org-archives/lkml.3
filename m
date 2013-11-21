Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab3KUQaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 11:30:11 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52120 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab3KUQaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 11:30:09 -0500
Date: Thu, 21 Nov 2013 17:29:56 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Chris Leech <christopher.leech@intel.com>,
        David Miller <davem@davemloft.net>, rui.zhang@intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 3/7] idle, thermal, acpi: Remove home grown idle
 implementations
Message-ID: <20131121162956.GI10022@twins.programming.kicks-ass.net>
References: <20131120160450.072555619@infradead.org>
 <20131120162736.508462614@infradead.org>
 <20131120165406.14fa0f09@ultegra>
 <20131121082151.GU10022@twins.programming.kicks-ass.net>
 <20131121160716.GT4138@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121160716.GT4138@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 08:07:16AM -0800, Paul E. McKenney wrote:
> On Thu, Nov 21, 2013 at 09:21:51AM +0100, Peter Zijlstra wrote:
> > On Wed, Nov 20, 2013 at 04:54:06PM -0800, Jacob Pan wrote:
> > > On Wed, 20 Nov 2013 17:04:53 +0100
> > > Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > People are starting to grow their own idle implementations in various
> > > > disgusting ways. Collapse the lot and use the generic idle code to
> > > > provide a proper idle cycle implementation.
> > > > 
> > > +Paul
> > > 
> > > RCU and others rely on is_idle_task() might be broken with the
> > > consolidated idle code since caller of do_idle may have pid != 0.
> > > 
> > > Should we use TS_POLL or introduce a new flag to identify idle task?
> > 
> > PF_IDLE would be my preference, I checked and we seem to have a grand
> > total of 2 unused task_struct::flags left ;-)
> 
> As long as RCU has some reliable way to identify an idle task, I am
> good.  But I have to ask -- why can't idle injection coordinate with
> the existing idle tasks rather than temporarily making alternative
> idle tasks?

Because that'd completely wreck how the scheduler selects tasks for just
these 2 arguably insane drivers.

We'd have to somehow teach it to pick the actual idle task instead of
this one task, but keep scheduling the rest of the tasks like normal --
we very much should keep higher priority tasks running like normal.

And we'd need a way to make it stop doing this 'proxy' execution.

That said, once we manage to replace the entire PI implementation with a
proper proxy execution scheme, the above would be possible by having a
resource (rt_mutex) associated with every idle task, and always held by
that task.

At that point we can do something like:

  rt_mutex_lock_timeout(cpu_idle_lock(cpu), jiffies);

And get the idle thread executing in our stead.

That said, idle is _special_ and I'd not be surprised we'd find a few
'funnies' along the way of trying to get that to actually work.

For now I'd rather not go there quite yet.
