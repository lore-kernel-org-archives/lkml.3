Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbbAFRRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:17:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:55556 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbbAFRR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:17:29 -0500
Date: Tue, 6 Jan 2015 18:17:12 +0100
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
Message-ID: <20150106171712.GH3337@twins.programming.kicks-ass.net>
References: <1415999712-5850-1-git-send-email-matt@console-pimps.org>
 <1415999712-5850-11-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415999712-5850-11-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 09:15:11PM +0000, Matt Fleming wrote:
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

slightly excessive quoting, bear with me, see below:

> +/*
> + * Attempt to rotate the groups and assign new RMIDs.
> + *
> + * Rotating RMIDs is complicated because the hardware doesn't give us
> + * any clues.
> + *
> + * There's problems with the hardware interface; when you change the
> + * task:RMID map cachelines retain their 'old' tags, giving a skewed
> + * picture. In order to work around this, we must always keep one free
> + * RMID - intel_cqm_rotation_rmid.
> + *
> + * Rotation works by taking away an RMID from a group (the old RMID),
> + * and assigning the free RMID to another group (the new RMID). We must
> + * then wait for the old RMID to not be used (no cachelines tagged).
> + * This ensure that all cachelines are tagged with 'active' RMIDs. At
> + * this point we can start reading values for the new RMID and treat the
> + * old RMID as the free RMID for the next rotation.
> + *
> + * Return %true or %false depending on whether we did any rotating.
> + */
> +static bool __intel_cqm_rmid_rotate(void)
> +{
> +	struct perf_event *group, *rotor, *start = NULL;
> +	unsigned int nr_needed = 0;
> +	unsigned int rmid;
> +	bool rotated = false;
> +	bool available;
> +
> +	mutex_lock(&cache_mutex);
> +
> +again:
> +	/*
> +	 * Fast path through this function if there are no groups and no
> +	 * RMIDs that need cleaning.
> +	 */
> +	if (list_empty(&cache_groups) && list_empty(&cqm_rmid_limbo_lru))
> +		goto out;
> +
> +	list_for_each_entry(group, &cache_groups, hw.cqm_groups_entry) {
> +		if (!__rmid_valid(group->hw.cqm_rmid)) {
> +			if (!start)
> +				start = group;
> +			nr_needed++;
> +		}
> +	}
> +
> +	/*
> +	 * We have some event groups, but they all have RMIDs assigned
> +	 * and no RMIDs need cleaning.
> +	 */
> +	if (!nr_needed && list_empty(&cqm_rmid_limbo_lru))
> +		goto out;
> +
> +	if (!nr_needed)
> +		goto stabilize;
> +
> +	/*
> +	 * We have more event groups without RMIDs than available RMIDs.
> +	 *
> +	 * We force deallocate the rmid of the group at the head of
> +	 * cache_groups. The first event group without an RMID then gets
> +	 * assigned intel_cqm_rotation_rmid. This ensures we always make
> +	 * forward progress.
> +	 *
> +	 * Rotate the cache_groups list so the previous head is now the
> +	 * tail.
> +	 */
> +	rotor = __intel_cqm_pick_and_rotate();
> +	rmid = intel_cqm_xchg_rmid(rotor, INVALID_RMID);
> +
> +	/*
> +	 * The group at the front of the list should always have a valid
> +	 * RMID. If it doesn't then no groups have RMIDs assigned.
> +	 */
> +	if (!__rmid_valid(rmid))
> +		goto stabilize;
> +
> +	/*
> +	 * If the rotation is going to succeed, reduce the threshold so
> +	 * that we don't needlessly reuse dirty RMIDs.
> +	 */
> +	if (__rmid_valid(intel_cqm_rotation_rmid)) {
> +		intel_cqm_xchg_rmid(start, intel_cqm_rotation_rmid);
> +		intel_cqm_rotation_rmid = INVALID_RMID;
> +
> +		if (__intel_cqm_threshold)
> +			__intel_cqm_threshold--;
> +	}
> +
> +	__put_rmid(rmid);
> +
> +	rotated = true;
> +
> +stabilize:
> +	/*
> +	 * We now need to stablize the RMID we freed above (if any) to
> +	 * ensure that the next time we rotate we have an RMID with zero
> +	 * occupancy value.
> +	 *
> +	 * Alternatively, if we didn't need to perform any rotation,
> +	 * we'll have a bunch of RMIDs in limbo that need stabilizing.
> +	 */
> +	if (!intel_cqm_rmid_stabilize(&available)) {
> +		unsigned int limit;
> +
> +		limit = __intel_cqm_max_threshold / cqm_l3_scale;
> +		if (available && __intel_cqm_threshold < limit) {
> +			__intel_cqm_threshold++;
> +			goto again;

afaict the again label will try and steal yet another rmid, if rmids
don't decay fast enough, we could end up with all rmids on the limbo
list and none active. Or am I missing something here?

> +		}
> +	}
> +
> +out:
> +	mutex_unlock(&cache_mutex);
> +	return rotated;
> +}
