Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab3KUIWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 03:22:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40266 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab3KUIWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 03:22:10 -0500
Date: Thu, 21 Nov 2013 09:21:51 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Chris Leech <christopher.leech@intel.com>,
        David Miller <davem@davemloft.net>, rui.zhang@intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/7] idle, thermal, acpi: Remove home grown idle
 implementations
Message-ID: <20131121082151.GU10022@twins.programming.kicks-ass.net>
References: <20131120160450.072555619@infradead.org>
 <20131120162736.508462614@infradead.org>
 <20131120165406.14fa0f09@ultegra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131120165406.14fa0f09@ultegra>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 04:54:06PM -0800, Jacob Pan wrote:
> On Wed, 20 Nov 2013 17:04:53 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > People are starting to grow their own idle implementations in various
> > disgusting ways. Collapse the lot and use the generic idle code to
> > provide a proper idle cycle implementation.
> > 
> +Paul
> 
> RCU and others rely on is_idle_task() might be broken with the
> consolidated idle code since caller of do_idle may have pid != 0.
> 
> Should we use TS_POLL or introduce a new flag to identify idle task?

PF_IDLE would be my preference, I checked and we seem to have a grand
total of 2 unused task_struct::flags left ;-)

> The reason why idle injection code does not inform RCU is that we have
> known short period of idle time which does not impact RCU grace period.
> 
> On the other side, I see idle injection code is working with this
> patchset with workaround in s_idle_task() by checking TS_POLL flag.
> But the efficiency is down by ~30%. i.e.
> 
> before: inject 25% time to get 23-24% package idle
> after: inject 25% time to get 16-17% package idle
> 
> Still looking into improvement.

So the quick hack is to make acpi_idle/intel_idle use the highest
possible C-state when pid!=0 && PF_IDLE.

Ideally though I'd see some of the QoS ramifications explored. Because
forcing the CPU into the highest C-state basically invalidates the
entire QoS stack.

So either make QoS and this idle injection stuff mutually exclusive in a
very explicit way -- disable the QoS interface when you enable one of
these idle injectors AND fail to engage the idle injectors when an
incompatible QoS setting is pre-existing.

Or come up with something smarter.

You also have to explore the case of higher priority tasks messing with
the proper operation of your injectors, this one is harder to deal with.
