Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaB1UyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 15:54:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42364 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaB1UyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 15:54:16 -0500
Date: Fri, 28 Feb 2014 21:54:09 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: paulmck@linux.vnet.ibm.com, Vince Weaver <vincent.weaver@maine.edu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
Message-ID: <20140228205409.GB14089@laptop.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1402251032230.23234@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402261003390.18730@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402271621000.2571@vincent-weaver-1.um.maine.edu>
 <20140227173150.4e5ed747@gandalf.local.home>
 <530FC1C6.5040209@zytor.com>
 <20140227183008.6be081b7@gandalf.local.home>
 <530FCE6C.4080808@zytor.com>
 <alpine.DEB.2.10.1402271957380.6210@vincent-weaver-1.um.maine.edu>
 <20140228203405.GH11910@linux.vnet.ibm.com>
 <20140228154716.0198d7cb@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140228154716.0198d7cb@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 03:47:16PM -0500, Steven Rostedt wrote:
> > > I'll try your patch momentarily, first I had some other changes I started 
> > > running before I left work (for some reason it recompiled the whole 
> > > kernel).
> > > 
> > > 8: function:             perf_output_begin
> > > 8: bprint:               perf_output_begin: VMW: event type 2 config 2a st: 2c3e
> > > 8: bputs:                perf_output_begin: VMW: before rcu_dereference
> > > 9: function:             __do_page_fault
> > > 9: function:                down_read_trylock
> > > 9: function:                _cond_resched
> > > 9: function:                find_vma
> > > 
> > > so it looks like the fault happens 
> > > 
> > > rcu_read_lock();
> > > 
> > > 116         /*
> > > 117          * For inherited events we send all the output towards the parent.
> > > 118          */
> > > 119         if (event->parent)
> > > 120                 event = event->parent;
> > > 121 
> > > 
> > > somewhere between here
> > > 
> > > 122         rb = rcu_dereference(event->rb);
> > > 123         if (unlikely(!rb))
> > > 124                 goto out;
> > > 
> > > and here
> > > 
> > > 125 
> > > 126         if (unlikely(!rb->nr_pages))
> > > 127                 goto out;
> > > 
> > > although if rcu locks do anything to turn off tracing then this could be 
> > > suspect.
> > 
> > The most likely suspect is of course event->rb in the rcu_dereference.
> > I have to defer to Steven on how rcu_read_lock() and rcu_read_unlock()
> > currently interact with tracing.  ;-)
> 
> These are all perf related. You'll need to defer to Peter Zijlstra ;-)

I'm lost.. :/

pretty much all perf objects are RCU freed. 
