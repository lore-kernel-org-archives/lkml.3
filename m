Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbaI2P2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 11:28:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:38540 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbaI2P2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:28:35 -0400
Date: Mon, 29 Sep 2014 17:28:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] perf: Add sampling of the raw monotonic clock
Message-ID: <20140929152832.GL4140@worktop.programming.kicks-ass.net>
References: <1411050873-9310-1-git-send-email-pawel.moll@arm.com>
 <1411050873-9310-2-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411050873-9310-2-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 03:34:32PM +0100, Pawel Moll wrote:
> @@ -4456,6 +4459,13 @@ static void __perf_event_header__init_id(struct perf_event_header *header,
>  		data->cpu_entry.cpu	 = raw_smp_processor_id();
>  		data->cpu_entry.reserved = 0;
>  	}
> +
> +	if (sample_type & PERF_SAMPLE_CLOCK_RAW_MONOTONIC) {
> +		struct timespec now;
> +
> +		getrawmonotonic(&now);
> +		data->clock_raw_monotonic = timespec_to_ns(&now);
> +	}
>  }
>  

This cannot work, getrawmonotonic() isn't NMI-safe and there's
nothing stopping this being used from NMI context.

Also getrawmonotonic() + timespec_to_ns() will make tglx sad, he's just
done a tree-wide eradication of silly conversions and now you're adding
a ns -> timespec -> ns dance right back.

I _think_ you want ktime_get_mono_fast_ns(), but this does bring us
right back to the question/discussion on which timebase you'd want to
sync again. MONO does make sense for most cases, but I think we've had
fairly sane stories for people wanting to sync against other clocks.

A well.. 
