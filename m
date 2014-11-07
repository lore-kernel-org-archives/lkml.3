Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaKGMit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:38:49 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:58983 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaKGMiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:38:46 -0500
Date: Fri, 7 Nov 2014 13:38:36 +0100
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
Message-ID: <20141107123836.GH10476@twins.programming.kicks-ass.net>
References: <1415276602-10337-1-git-send-email-matt@console-pimps.org>
 <1415276602-10337-11-git-send-email-matt@console-pimps.org>
 <20141107123431.GE3337@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107123431.GE3337@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 01:34:31PM +0100, Peter Zijlstra wrote:
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

For optional goodness:

		if (nr_limbo > max_scan_size)
			break;

Which will limit the number of RMIDs you'll scan from the IPI, and
thereby limit the time taken there.

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
