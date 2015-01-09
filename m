Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbbAIO1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 09:27:07 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:33936 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbbAIO1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 09:27:04 -0500
Date: Fri, 9 Jan 2015 14:27:00 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 11/11] perf/x86/intel: Enable conflicting event
 scheduling for CQM
Message-ID: <20150109142700.GF495@console-pimps.org>
References: <1415999712-5850-1-git-send-email-matt@console-pimps.org>
 <1415999712-5850-12-git-send-email-matt@console-pimps.org>
 <20150108115117.GK3337@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150108115117.GK3337@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Jan, at 12:51:17PM, Peter Zijlstra wrote:
> On Fri, Nov 14, 2014 at 09:15:12PM +0000, Matt Fleming wrote:
> > +/*
> > + * Deallocate the RMIDs from any events that conflict with @event, and
> > + * place them on the back of the group list.
> > + */
> > +static void intel_cqm_sched_out_events(struct perf_event *event)
> > +{
> > +	struct perf_event *group, *g;
> > +	unsigned int rmid;
> >  
> > +	lockdep_assert_held(&cache_mutex);
> > +
> > +	list_for_each_entry_safe(group, g, &cache_groups, hw.cqm_groups_entry) {
> > +		if (group == event)
> > +			continue;
> > +
> > +		rmid = group->hw.cqm_rmid;
> > +
> > +		/*
> > +		 * Skip events that don't have a valid RMID.
> > +		 */
> > +		if (!__rmid_valid(rmid))
> > +			continue;
> > +
> > +		/*
> > +		 * No conflict? No problem! Leave the event alone.
> > +		 */
> > +		if (!__conflict_event(group, event))
> > +			continue;
> > +
> > +		intel_cqm_xchg_rmid(group, INVALID_RMID);
> > +		__put_rmid(rmid);
> > +
> > +		list_move_tail(&group->hw.cqm_groups_entry, &cache_groups);
> > +	}
> >  }
> 
> I'm not sure about that list_move_tail() there, is wrecks the rotation
> order and would cause conflicting events to get less than their 'fair'
> share I suspect.

Good point, this is just plain wrong. 

-- 
Matt Fleming, Intel Open Source Technology Center
