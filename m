Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaKJU6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:58:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:60981 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbaKJU6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:58:52 -0500
Date: Mon, 10 Nov 2014 21:58:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v3 10/11] perf/x86/intel: Perform rotation on Intel CQM
 RMIDs
Message-ID: <20141110205846.GE10501@worktop.programming.kicks-ass.net>
References: <1415276602-10337-1-git-send-email-matt@console-pimps.org>
 <1415276602-10337-11-git-send-email-matt@console-pimps.org>
 <20141107120612.GB3337@twins.programming.kicks-ass.net>
 <20141110204353.GD1292@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110204353.GD1292@console-pimps.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 08:43:53PM +0000, Matt Fleming wrote:
> On Fri, 07 Nov, at 01:06:12PM, Peter Zijlstra wrote:
> > On Thu, Nov 06, 2014 at 12:23:21PM +0000, Matt Fleming wrote:
> > > +/*
> > > + * Exchange the RMID of a group of events.
> > > + */
> > > +static unsigned int
> > > +intel_cqm_xchg_rmid(struct perf_event *group, unsigned int rmid)
> > > +{
> > > +	struct perf_event *event;
> > > +	unsigned int old_rmid = group->hw.cqm_rmid;
> > > +	struct list_head *head = &group->hw.cqm_group_entry;
> > > +
> > > +	lockdep_assert_held(&cache_mutex);
> > > +
> > > +	/*
> > > +	 * If our RMID is being deallocated, perform a read now.
> > > +	 */
> > > +	if (__rmid_valid(old_rmid) && !__rmid_valid(rmid)) {
> > > +		struct intel_cqm_count_info info;
> > > +
> > > +		local64_set(&group->count, 0);
> > > +		info.event = group;
> > > +
> > > +		preempt_disable();
> > > +		smp_call_function_many(&cqm_cpumask, __intel_cqm_event_count,
> > > +				       &info, 1);
> > > +		preempt_enable();
> > > +	}
> > 
> > This suffers the same issue as before, why not call that one function
> > and not reimplement it?
> > 
> > Also, I don't think we'd ever swap an rmid for another valid one, right?
> > So we could do this read/update unconditionally.
> 
> No, we never swap a valid RMID for another valid one, but we do make a
> invalid -> valid transition, so doing the read wouldn't make sense
> in that situation.

Ah indeed.
