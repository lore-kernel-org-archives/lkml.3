Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaKGMer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:34:47 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:54658 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaKGMeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:34:44 -0500
Date: Fri, 7 Nov 2014 13:34:31 +0100
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
Message-ID: <20141107123431.GE3337@twins.programming.kicks-ass.net>
References: <1415276602-10337-1-git-send-email-matt@console-pimps.org>
 <1415276602-10337-11-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415276602-10337-11-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 12:23:21PM +0000, Matt Fleming wrote:
> +/*
> + * Test whether an RMID has a zero occupancy value on this cpu.
> + */
> +static void intel_cqm_stable(void *arg)
> +{
> +	unsigned int nr_bits;
> +	int i = -1;
> +
> +	nr_bits = cqm_max_rmid + 1;
> +
> +	for (; i = find_next_bit(cqm_limbo_bitmap, nr_bits, i+1),
> +		i < nr_bits;) {
> +		if (__rmid_read(i) > __intel_cqm_threshold)
> +			clear_bit(i, cqm_free_bitmap);
> +	}
> +}
> +
> +static unsigned int __rotation_period = 250; /* ms */
> +
> +/*
> + * intel_cqm_rmid_stabilize - move RMIDs from limbo to free list
> + * @available: are there freeable RMIDs on the limbo list?
> + *
> + * Quiescent state; wait for all 'freed' RMIDs to become unused, i.e. no
> + * cachelines are tagged with those RMIDs. After this we can reuse them
> + * and know that the current set of active RMIDs is stable.
> + *
> + * Return %true or %false depending on whether we were able to stabilize
> + * an RMID for intel_cqm_rotation_rmid.
> + *
> + * If we return %false then @available is updated to indicate the reason
> + * we couldn't stabilize any RMIDs. @available is %false if no suitable
> + * RMIDs were found on the limbo list to recycle, i.e. no RMIDs had been
> + * on the list for the minimum queue time. If @available is %true then,
> + * we found suitable RMIDs to recycle but none had an associated
> + * occupancy value below __intel_cqm_threshold and the threshold should
> + * be increased and stabilization reattempted.
> + */
> +static bool intel_cqm_rmid_stabilize(bool *available)
> +{
> +	struct cqm_rmid_entry *entry;
> +	unsigned int nr_bits;
> +	struct perf_event *event;
> +
> +	lockdep_assert_held(&cache_mutex);
> +
> +	nr_bits = cqm_max_rmid + 1;
> +
> +	bitmap_zero(cqm_limbo_bitmap, nr_bits);
> +	bitmap_zero(cqm_free_bitmap, nr_bits);
> +
> +	list_for_each_entry(entry, &cqm_rmid_limbo_lru, list) {
> +		unsigned long min_queue_time;
> +		unsigned long now = jiffies;
> +
> +		/*
> +		 * We hold RMIDs placed into limbo for a minimum queue
> +		 * time. Before the minimum queue time has elapsed we do
> +		 * not recycle RMIDs.
> +		 *
> +		 * The reasoning is that until a sufficient time has
> +		 * passed since we stopped using an RMID, any RMID
> +		 * placed onto the limbo list will likely still have
> +		 * data tagged in the cache, which means we'll probably
> +		 * fail to recycle it anyway.
> +		 *
> +		 * We can save ourselves an expensive IPI by skipping
> +		 * any RMIDs that have not been queued for the minimum
> +		 * time.
> +		 */
> +		min_queue_time = entry->queue_time +
> +			msecs_to_jiffies(__rotation_period);
> +
> +		if (time_after(min_queue_time, now))
> +			continue;

Why continue; this LRU is time ordered, later entries cannot be earlier,
right?

> +		set_bit(entry->rmid, cqm_limbo_bitmap);
> +		set_bit(entry->rmid, cqm_free_bitmap);
> +	}
> +
> +	/*
> +	 * Fast return if none of the RMIDs on the limbo list have been
> +	 * sitting on the queue for the minimum queue time.
> +	 */
> +	*available = !bitmap_empty(cqm_limbo_bitmap, nr_bits);
> +	if (!*available)
> +		return false;
> +
> +	/*
> +	 * Test whether an RMID is free for each package.
> +	 */
> +	preempt_disable();
> +	smp_call_function_many(&cqm_cpumask, intel_cqm_stable, NULL, true);
> +	preempt_enable();

I don't get the whole list -> bitmap -> list juggle.

enum rmid_cycle_state {
	RMID_AVAILABLE = 0,
	RMID_LIMBO,
	RMID_YOUNG,
};

struct cqm_rmid_entry {
	...
	enum rmid_cycle_state state;
};

static void __intel_sqm_stable(void *arg)
{
	list_for_each_entry(entry, &cqm_rmid_limbo_lru, list) {
		if (entry->state == RMID_YOUNG)
			break;

		if (__rmid_read(entry->rmid) > __threshold)
			entry->state = RMID_LIMBO;
	}
}

static bool intel_cqm_rmid_stabilize()
{
	unsigned long queue_time = jiffies + msecs_to_jiffies(__rotation_period);
	unsigned int nr_limbo = 0;
	...

	list_for_each_entry(entry, &cqm_rmid_limbo_lru, list) {
		if (time_after(entry->queue_time, queue_time))
			break;

		entry->state = RMID_AVAILABLE;
		nr_limbo++;
	}

	if (!nr_limbo)
		return;

	on_each_cpu_mask(&cqm_cpumask, __intel_cqm_stable, NULL, true);

	list_for_each_entry_safe(entry, tmp, &cqm_rmid_limbo_lru, list) {
		if (entry->state == RMID_YOUNG)
			break;

		if (entry->state == RMID_AVAILABLE)
			list_move(&cqm_rmid_free_list, &entry->list);
	}
}


Would not something like that work?
