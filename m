Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbbAIM7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:59:52 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:54392 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbbAIM7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:59:52 -0500
Date: Fri, 9 Jan 2015 13:59:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v4 10/11] perf/x86/intel: Perform rotation on Intel CQM
 RMIDs
Message-ID: <20150109125930.GG29390@twins.programming.kicks-ass.net>
References: <1415999712-5850-1-git-send-email-matt@console-pimps.org>
 <1415999712-5850-11-git-send-email-matt@console-pimps.org>
 <20150106173641.GI3337@twins.programming.kicks-ass.net>
 <20150109122239.GC495@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150109122239.GC495@console-pimps.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 12:22:39PM +0000, Matt Fleming wrote:
> On Tue, 06 Jan, at 06:36:41PM, Peter Zijlstra wrote:
> > On Fri, Nov 14, 2014 at 09:15:11PM +0000, Matt Fleming wrote:
> > > @@ -417,17 +857,38 @@ static u64 intel_cqm_event_count(struct perf_event *event)
> > >  	if (!cqm_group_leader(event))
> > >  		return 0;
> > >  
> > > -	on_each_cpu_mask(&cqm_cpumask, __intel_cqm_event_count, &rr, 1);
> > > +	/*
> > > +	 * Notice that we don't perform the reading of an RMID
> > > +	 * atomically, because we can't hold a spin lock across the
> > > +	 * IPIs.
> > > +	 *
> > > +	 * Speculatively perform the read, since @event might be
> > > +	 * assigned a different (possibly invalid) RMID while we're
> > > +	 * busying performing the IPI calls. It's therefore necessary to
> > > +	 * check @event's RMID afterwards, and if it has changed,
> > > +	 * discard the result of the read.
> > > +	 */
> > > +	raw_spin_lock_irqsave(&cache_lock, flags);
> > > +	rr.rmid = event->hw.cqm_rmid;
> > > +	raw_spin_unlock_irqrestore(&cache_lock, flags);
> > 
> > You don't actually have to hold the lock here, only ACCESS_ONCE() or
> > whatever newfangled thing replaced that.
>  
> Remind me again, are accesses to 'int' guaranteed to be atomic? There's
> no way to read a partial value?

Yah, assuming natural alignment, loads from ints (and any other native
machine word size) are atomic.
