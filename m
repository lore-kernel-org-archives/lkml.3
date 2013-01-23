Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab3AWBy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 20:54:26 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45943 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab3AWByY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 20:54:24 -0500
Message-ID: <50FF42CD.6010203@linaro.org>
Date: Tue, 22 Jan 2013 17:54:21 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Feng Tang <feng.tang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Add support for S3 non-stop TSC support.
References: <1358750325-21217-1-git-send-email-feng.tang@intel.com> <50FD8D07.5030908@linaro.org> <20130122195701.GH30647@obsidianresearch.com> <50FEF505.60504@linaro.org> <20130123002610.GA814@obsidianresearch.com> <50FF31D6.3090304@linaro.org> <20130123013710.GA1046@obsidianresearch.com>
In-Reply-To: <20130123013710.GA1046@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 05:37 PM, Jason Gunthorpe wrote:
> On Tue, Jan 22, 2013 at 04:41:58PM -0800, John Stultz wrote:
>
>> Right but to calculate an suspend interval (since they are likely
>> many orders of magnitude larger then the intervals between timer
>> interrupts), you need different mult/shift selection.  Its splitting
>> out the mult/shift management into a per-subsystem level that is the
> You are talking about overflow in cyclecounter_cyc2ns and the like
> right? The 64 bit cycle_t and the underlying hw counter (eg 64 bit
> rdtsc) are not going to overflow..
>
> An alternate version of cyclecounter_cyc2ns for use by the suspend
> code that handles overflow during the mult/shift operation solves that
> problem:
>
> // Drops some small precision along the way but is simple..
> static inline u64 cyclecounter_cyc2ns_128(const struct cyclecounter *cc,
>                                            cycle_t cycles)
> {
>      u64 max = U64_MAX/cc->mult;
>      u64 num = cycles/max;
>      u64 result = num * ((max * cc->mult) >> cc->shift);
>      return result + cyclecounter_cyc2ns(cc, cycles - num*cc->mult);
> }
>
> Or am I missing the issue?

Well, cyclecounters and clocksources are currently different things. 
There was some hope that cyclecounters would be a simpler base structure 
that would supersede clocksources, but the complexity of all the 
variants of clocksources have limited the ability to make such a 
conversion. At least so far. I hope to eventually clean that up as the 
potential overlap is obvious - although as the 
cyclecounters/timecounters code never grew as I expected. But I'm not 
sure how soon "eventually" will end up being.

But regardless of historical tangents :), you're right, an alternate and 
slower cyc2ns function could be used to avoid overflow issues.


>
>> complicated part. Additionally, there may be cases where the
>> timekeeping clocksource is one clocksource and the suspend
>> clocksource is another. So I think to properly integrate this sort
> Does the difference matter? The clocksource to use is detected at
> runtime, if the timekeeping clocksource is no good for suspend time
> keeping then it just won't be used. With a distinct
> read_persistent_clock API then they are already seperate??

Not sure I'm following you here.  I still think the selection of which 
clocksource to use for suspend timing is problematic (especially if its 
not the active timekeeping clocksource).  So I think instead of 
complicating the generic timekeeping code with the logic, I'd rather 
push it off to new read_presistent_clock api.

thanks
-john


