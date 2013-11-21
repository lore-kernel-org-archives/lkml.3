Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab3KUQHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 11:07:47 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:53072 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab3KUQHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 11:07:45 -0500
Date: Thu, 21 Nov 2013 08:07:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <20131121160716.GT4138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131120160450.072555619@infradead.org>
 <20131120162736.508462614@infradead.org>
 <20131120165406.14fa0f09@ultegra>
 <20131121082151.GU10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121082151.GU10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112116-6688-0000-0000-000003BDD6BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 09:21:51AM +0100, Peter Zijlstra wrote:
> On Wed, Nov 20, 2013 at 04:54:06PM -0800, Jacob Pan wrote:
> > On Wed, 20 Nov 2013 17:04:53 +0100
> > Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > People are starting to grow their own idle implementations in various
> > > disgusting ways. Collapse the lot and use the generic idle code to
> > > provide a proper idle cycle implementation.
> > > 
> > +Paul
> > 
> > RCU and others rely on is_idle_task() might be broken with the
> > consolidated idle code since caller of do_idle may have pid != 0.
> > 
> > Should we use TS_POLL or introduce a new flag to identify idle task?
> 
> PF_IDLE would be my preference, I checked and we seem to have a grand
> total of 2 unused task_struct::flags left ;-)

As long as RCU has some reliable way to identify an idle task, I am
good.  But I have to ask -- why can't idle injection coordinate with
the existing idle tasks rather than temporarily making alternative
idle tasks?

							Thanx, Paul

> > The reason why idle injection code does not inform RCU is that we have
> > known short period of idle time which does not impact RCU grace period.
> > 
> > On the other side, I see idle injection code is working with this
> > patchset with workaround in s_idle_task() by checking TS_POLL flag.
> > But the efficiency is down by ~30%. i.e.
> > 
> > before: inject 25% time to get 23-24% package idle
> > after: inject 25% time to get 16-17% package idle
> > 
> > Still looking into improvement.
> 
> So the quick hack is to make acpi_idle/intel_idle use the highest
> possible C-state when pid!=0 && PF_IDLE.
> 
> Ideally though I'd see some of the QoS ramifications explored. Because
> forcing the CPU into the highest C-state basically invalidates the
> entire QoS stack.
> 
> So either make QoS and this idle injection stuff mutually exclusive in a
> very explicit way -- disable the QoS interface when you enable one of
> these idle injectors AND fail to engage the idle injectors when an
> incompatible QoS setting is pre-existing.
> 
> Or come up with something smarter.
> 
> You also have to explore the case of higher priority tasks messing with
> the proper operation of your injectors, this one is harder to deal with.
> 

