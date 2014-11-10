Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaKJVbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 16:31:46 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:37752 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaKJVbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 16:31:45 -0500
Date: Mon, 10 Nov 2014 21:31:40 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v3 10/11] perf/x86/intel: Perform rotation on Intel CQM
 RMIDs
Message-ID: <20141110213140.GG1292@console-pimps.org>
References: <1415276602-10337-1-git-send-email-matt@console-pimps.org>
 <1415276602-10337-11-git-send-email-matt@console-pimps.org>
 <20141107123431.GE3337@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107123431.GE3337@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov, at 01:34:31PM, Peter Zijlstra wrote:
> On Thu, Nov 06, 2014 at 12:23:21PM +0000, Matt Fleming wrote:
> > +		min_queue_time = entry->queue_time +
> > +			msecs_to_jiffies(__rotation_period);
> > +
> > +		if (time_after(min_queue_time, now))
> > +			continue;
> 
> Why continue; this LRU is time ordered, later entries cannot be earlier,
> right?
 
Good point. We can just exit here.

> > +		set_bit(entry->rmid, cqm_limbo_bitmap);
> > +		set_bit(entry->rmid, cqm_free_bitmap);
> > +	}
> > +
> > +	/*
> > +	 * Fast return if none of the RMIDs on the limbo list have been
> > +	 * sitting on the queue for the minimum queue time.
> > +	 */
> > +	*available = !bitmap_empty(cqm_limbo_bitmap, nr_bits);
> > +	if (!*available)
> > +		return false;
> > +
> > +	/*
> > +	 * Test whether an RMID is free for each package.
> > +	 */
> > +	preempt_disable();
> > +	smp_call_function_many(&cqm_cpumask, intel_cqm_stable, NULL, true);
> > +	preempt_enable();
> 
> I don't get the whole list -> bitmap -> list juggle.
> 
> enum rmid_cycle_state {
> 	RMID_AVAILABLE = 0,
> 	RMID_LIMBO,
> 	RMID_YOUNG,
> };
> 
> struct cqm_rmid_entry {
> 	...
> 	enum rmid_cycle_state state;
> };
> 
> static void __intel_sqm_stable(void *arg)
> {
> 	list_for_each_entry(entry, &cqm_rmid_limbo_lru, list) {
> 		if (entry->state == RMID_YOUNG)
> 			break;
> 
> 		if (__rmid_read(entry->rmid) > __threshold)
> 			entry->state = RMID_LIMBO;
> 	}
> }
> 
> static bool intel_cqm_rmid_stabilize()
> {
> 	unsigned long queue_time = jiffies + msecs_to_jiffies(__rotation_period);
> 	unsigned int nr_limbo = 0;
> 	...
> 
> 	list_for_each_entry(entry, &cqm_rmid_limbo_lru, list) {
> 		if (time_after(entry->queue_time, queue_time))
> 			break;
> 
> 		entry->state = RMID_AVAILABLE;
> 		nr_limbo++;
> 	}
> 
> 	if (!nr_limbo)
> 		return;
> 
> 	on_each_cpu_mask(&cqm_cpumask, __intel_cqm_stable, NULL, true);
> 
> 	list_for_each_entry_safe(entry, tmp, &cqm_rmid_limbo_lru, list) {
> 		if (entry->state == RMID_YOUNG)
> 			break;
> 
> 		if (entry->state == RMID_AVAILABLE)
> 			list_move(&cqm_rmid_free_list, &entry->list);
> 	}
> }
> 
> 
> Would not something like that work?

Actually, yeah, that does look like it'd work. Are you OK with me adding
an enum to the cqm_rmid_entry? You had concerns in the past about
growing the size of the struct.

-- 
Matt Fleming, Intel Open Source Technology Center
