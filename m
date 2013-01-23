Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab3AWDHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 22:07:11 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33928 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab3AWDHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 22:07:08 -0500
Message-ID: <50FF53D8.2070503@linaro.org>
Date: Tue, 22 Jan 2013 19:07:04 -0800
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
References: <1358750325-21217-1-git-send-email-feng.tang@intel.com> <50FD8D07.5030908@linaro.org> <20130122195701.GH30647@obsidianresearch.com> <50FEF505.60504@linaro.org> <20130123002610.GA814@obsidianresearch.com> <50FF31D6.3090304@linaro.org> <20130123013710.GA1046@obsidianresearch.com> <50FF42CD.6010203@linaro.org> <20130123023523.GC1590@obsidianresearch.com>
In-Reply-To: <20130123023523.GC1590@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 06:35 PM, Jason Gunthorpe wrote:
> On Tue, Jan 22, 2013 at 05:54:21PM -0800, John Stultz wrote:
>
>>>> complicated part. Additionally, there may be cases where the
>>>> timekeeping clocksource is one clocksource and the suspend
>>>> clocksource is another. So I think to properly integrate this sort
>>> Does the difference matter? The clocksource to use is detected at
>>> runtime, if the timekeeping clocksource is no good for suspend time
>>> keeping then it just won't be used. With a distinct
>>> read_persistent_clock API then they are already seperate??
>> Not sure I'm following you here.  I still think the selection of
>> which clocksource to use for suspend timing is problematic
>> (especially if its not the active timekeeping clocksource).  So I
>> think instead of complicating the generic timekeeping code with the
>> logic, I'd rather push it off to new read_presistent_clock api.
> Well, where do you see the complication?
>
> My thought was to save the cycle_t from *all* the clock sources during
> suspend, and then on resume look for the highest priority one where
> the driver reports it continued to tick the whole time. The active
> timekeeping clock source doesn't seem to come into the equation??
>
> Add
>        int (*active_during_suspend)(struct clocksource *cs);
>        cycle_t value_before_suspend;
> To struct clocksource.
>
> Before suspend:
>    foreach(cs,all clocksources) {
>        if (cs->active_during_suspend)
>              cs->value_before_suspend = cs->read(cs);
>    }
>
> After resume:
>    cycle_t best_delta = 0;
>    struct clocksource *best_cs = NULL;
>    foreach(cs,all clocksources) {
>        if (cs->active_during_suspend &&
>            (best_cs == NULL || cs->rating > best_cs->rating) &&
>            cs->active_during_suspend(cs)) {
>              best_delta = cs->read(cs) - cs->value_before_suspend;
>              best_cs = cs;
>        }
>    }
>
> Update the TSC driver to set the function pointer
> active_during_suspend when the CPU supports non-stop TSC. Have it
> return true if S3 was the deepest sleep entered during the last
> suspend/resume cycle, false otherwise. Ditto for that ARM case.
>
> This seems reasonably simple, compared to adding a new API, new
> drivers, new function pointer multiplexors to arches...

So yea, your suggestion is attractive in some ways.

But personally, I'm less fond of adding additional state to the 
clocksources, as I'm (admittedly, very) slowly trying to go the other 
way, and make the clocksources mostly state free. This is in part to 
allow for faster timekeeping updates (see: 
https://lkml.org/lkml/2012/3/2/66) - but again, I've not made much 
progress there recently, so this probably isn't a strong enough argument 
against it.

Another downside is that accessing a clocksource can be costly, so doing 
so for every clocksource could unnecessarily slow suspend/resume down. 
Reading all the clocksources avoids the complexity of creating the 
secondary selection and management of a suspend-time measuring 
clocksource, but it also feels a little hackish to me. And iterating 
over the clocksource list requires exposing currently private 
clocksource data to the timekeeping core.

The reason I like the idea of a new persistent_clock api, is that it 
formalizes existing usage, and doesn't require changes to the 
timekeeping logic, or to architectures that don't have running 
suspend-time counters (whatever the new read_persistent_clock interface 
ends up being can call the existing read_persistent_clock function). 
Only on arm and x86 might there be a more complicated function.

But don't let my naysaying stop you from submitting a patch. It would be 
interesting to see your idea fully fleshed out.

I appreciate your persistence here, and apologies for my thick-headed-ness.

thanks
-john


