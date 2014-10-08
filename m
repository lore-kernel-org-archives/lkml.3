Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbaJHSIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 14:08:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:34772 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbaJHSIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 14:08:20 -0400
Date: Wed, 8 Oct 2014 20:08:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 11/11] perf/x86/intel: Perform rotation on Intel CQM RMIDs
Message-ID: <20141008180814.GH4750@worktop.programming.kicks-ass.net>
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
 <1411567455-31264-12-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411567455-31264-12-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 03:04:15PM +0100, Matt Fleming wrote:
> +	preempt_disable();
> +	list_for_each_entry(entry, &cqm_rmid_limbo_lru, list) {
> +		for_each_cpu(cpu, &cqm_cpumask) {
> +			unsigned long *map;
> +
> +			map = &limbo_bitmap[cpu * BITS_TO_LONGS(nr_bits)];
> +			set_bit(entry->rmid, map);
> +		}
> +	}
> +
> +	/*
> +	 * Test whether an RMID is free for each package.
> +	 */
> +	smp_call_function_many(&cqm_cpumask, intel_cqm_stable, &info, true);
> +
> +	/*
> +	 * Convert all cpu bitmaps into a single bitmap by ANDing all of
> +	 * them together. If we've still got any bits set that indicates
> +	 * an RMID is now unused on all cpus.
> +	 */
> +	bitmap_fill(free_bitmap, nr_bits);
> +	for_each_cpu(cpu, &cqm_cpumask) {
> +		unsigned long *map;
> +
> +		map = &limbo_bitmap[cpu * BITS_TO_LONGS(nr_bits)];
> +		bitmap_and(free_bitmap, free_bitmap, map, nr_bits);
> +	}
> +
> +	if (!bitmap_empty(free_bitmap, nr_bits)) {
> +		int i = -1;
> +
> +		for (; i = find_next_bit(free_bitmap, nr_bits, i+1),
> +			i < nr_bits;) {
> +			entry = __rmid_entry(i);
> +
> +			list_del(&entry->list);	/* remove from limbo */
> +
> +			/*
> +			 * The rotation RMID gets priority if it's
> +			 * currently invalid. In which case, skip adding
> +			 * the RMID to the the free lru.
> +			 */
> +			if (!__rmid_valid(intel_cqm_rotation_rmid)) {
> +				intel_cqm_rotation_rmid = i;
> +				continue;
> +			}
> +
> +			/*
> +			 * If we have groups waiting for RMIDs, hand
> +			 * them one now.
> +			 */
> +			raw_spin_lock_irq(&cache_lock);
> +			list_for_each_entry(event, &cache_groups,
> +					    hw.cqm_groups_entry) {
> +				if (__rmid_valid(event->hw.cqm_rmid))
> +					continue;
> +
> +				intel_cqm_xchg_rmid(event, i);
> +				entry = NULL;
> +				break;
> +			}
> +			raw_spin_unlock_irq(&cache_lock);
> +
> +			if (!entry)
> +				continue;
> +
> +			/*
> +			 * Otherwise place it onto the free list.
> +			 */
> +			list_add_tail(&entry->list, &cqm_rmid_free_lru);
> +		}
> +	}
> +
> +	preempt_enable();

Why is all that under preempt_disable()?
