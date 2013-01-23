Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab3AWBhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 20:37:18 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:54320 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab3AWBhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 20:37:15 -0500
Date: Tue, 22 Jan 2013 18:37:10 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Feng Tang <feng.tang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Add support for S3 non-stop TSC support.
Message-ID: <20130123013710.GA1046@obsidianresearch.com>
References: <1358750325-21217-1-git-send-email-feng.tang@intel.com>
 <50FD8D07.5030908@linaro.org>
 <20130122195701.GH30647@obsidianresearch.com>
 <50FEF505.60504@linaro.org>
 <20130123002610.GA814@obsidianresearch.com>
 <50FF31D6.3090304@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FF31D6.3090304@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 04:41:58PM -0800, John Stultz wrote:

> Right but to calculate an suspend interval (since they are likely
> many orders of magnitude larger then the intervals between timer
> interrupts), you need different mult/shift selection.  Its splitting
> out the mult/shift management into a per-subsystem level that is the

You are talking about overflow in cyclecounter_cyc2ns and the like
right? The 64 bit cycle_t and the underlying hw counter (eg 64 bit
rdtsc) are not going to overflow..

An alternate version of cyclecounter_cyc2ns for use by the suspend
code that handles overflow during the mult/shift operation solves that
problem:

// Drops some small precision along the way but is simple..
static inline u64 cyclecounter_cyc2ns_128(const struct cyclecounter *cc,
                                          cycle_t cycles)
{
    u64 max = U64_MAX/cc->mult;
    u64 num = cycles/max;
    u64 result = num * ((max * cc->mult) >> cc->shift);
    return result + cyclecounter_cyc2ns(cc, cycles - num*cc->mult);
}

Or am I missing the issue?

> complicated part. Additionally, there may be cases where the
> timekeeping clocksource is one clocksource and the suspend
> clocksource is another. So I think to properly integrate this sort

Does the difference matter? The clocksource to use is detected at
runtime, if the timekeeping clocksource is no good for suspend time
keeping then it just won't be used. With a distinct
read_persistent_clock API then they are already seperate??

Jason
