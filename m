Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188AbbAFRhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:37:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:55699 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbbAFRg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:36:57 -0500
Date: Tue, 6 Jan 2015 18:36:41 +0100
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
Message-ID: <20150106173641.GI3337@twins.programming.kicks-ass.net>
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
> @@ -417,17 +857,38 @@ static u64 intel_cqm_event_count(struct perf_event *event)
>  	if (!cqm_group_leader(event))
>  		return 0;
>  
> -	on_each_cpu_mask(&cqm_cpumask, __intel_cqm_event_count, &rr, 1);
> +	/*
> +	 * Notice that we don't perform the reading of an RMID
> +	 * atomically, because we can't hold a spin lock across the
> +	 * IPIs.
> +	 *
> +	 * Speculatively perform the read, since @event might be
> +	 * assigned a different (possibly invalid) RMID while we're
> +	 * busying performing the IPI calls. It's therefore necessary to
> +	 * check @event's RMID afterwards, and if it has changed,
> +	 * discard the result of the read.
> +	 */
> +	raw_spin_lock_irqsave(&cache_lock, flags);
> +	rr.rmid = event->hw.cqm_rmid;
> +	raw_spin_unlock_irqrestore(&cache_lock, flags);

You don't actually have to hold the lock here, only ACCESS_ONCE() or
whatever newfangled thing replaced that.

> +
> +	if (!__rmid_valid(rr.rmid))
> +		goto out;
>  
> -	local64_set(&event->count, atomic64_read(&rr.value));
> +	on_each_cpu_mask(&cqm_cpumask, __intel_cqm_event_count, &rr, 1);
>  
> +	raw_spin_lock_irqsave(&cache_lock, flags);
> +	if (event->hw.cqm_rmid == rr.rmid)
> +		local64_set(&event->count, atomic64_read(&rr.value));
> +	raw_spin_unlock_irqrestore(&cache_lock, flags);

Here you do indeed need the lock as its more than a single op :-)

> +out:
>  	return __perf_event_count(event);
>  }
