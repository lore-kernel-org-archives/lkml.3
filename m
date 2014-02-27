Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbaB0Tdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:33:35 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:54686 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaB0Tde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:33:34 -0500
Message-ID: <530F9307.40400@linux.vnet.ibm.com>
Date: Thu, 27 Feb 2014 11:33:27 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Michael Ellerman <mpe@ellerman.id.au>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 02/11] perf core: export swevent hrtimer helpers
References: <1392415338-16288-3-git-send-email-cody@linux.vnet.ibm.com> <20140225033326.7BB942C0228@ozlabs.org> <20140225102008.GI9987@twins.programming.kicks-ass.net> <530D0D57.4030704@linux.vnet.ibm.com> <20140226082943.GC18404@twins.programming.kicks-ass.net>
In-Reply-To: <20140226082943.GC18404@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022719-8236-0000-0000-0000004314E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 12:29 AM, Peter Zijlstra wrote:
> On Tue, Feb 25, 2014 at 01:38:31PM -0800, Cody P Schafer wrote:
>> On 02/25/2014 02:20 AM, Peter Zijlstra wrote:
>>> On Tue, Feb 25, 2014 at 02:33:26PM +1100, Michael Ellerman wrote:
>>>> On Fri, 2014-14-02 at 22:02:06 UTC, Cody P Schafer wrote:
>>>>> Export the swevent hrtimer helpers currently only used in events/core.c
>>>>> to allow the addition of architecture specific sw-like pmus.
>>>>
>>>> Peter, Ingo, can we get your ACK on this please?
>>>
>>> How are they used? I saw some usage in patch 9 or so; but its not
>>> explained anywhere. All patches have non-existent Changelogs and the few
>>> comments that are there are pretty hardware specific.
>>>
>>> So please do tell; what do you need this for?
>>
>>  From this patch's change log:
>>
>>> Export the swevent hrtimer helpers currently only used in events/core.c to allow the addition of architecture specific sw-like pmus.
>>
>> The key part here is "architecture specific sw-like pmus", where the
>> announcement explains why these pmus are sw-like:
>
> I don't read announcements for crucial patch details; announcements are
> lost and therefore unimportant.

And I'll be sure to elaborate further in the changelog next time (if I 
don't drop this change entirely).
This is the first comment I've got on this particular patch.

>>> The counters supplied by these interfaces are continually counting and never
>>> need to be (and cannot be) disabled or enabled. They additionally do not
>>> generate any interrupts. This makes them in some regards similar to software
>>> counters, and as a result their implimentation shares some common code (which
>>> an initial patch exposes) with the sw counters.
>>
>> Essentially, these pmus just provide access to a big array of counters which
>> don't generate interrupts, and are all 64bit (and assumed to never
>> overflow). Rather than duplicate the code that we already have for managing
>> timing when reading from counters that don't have interrupts (the functions
>> that are exposed by this patch), I've reused it.
>
> So note that all the software counters generate interrupts in their own
> measuring domain. The hrtimer ones measure time and generate time based
> interrupts, the event based ones generate 'interrupts' on their events.
>
> What you have here is a hw pmu without interrupt capability. That's
> fine, they don't get to generate interrupt. We have plenty of those
> already.
>
> But what you propose to do is add interrupt in another domain entirely.
> That's not fine. Don't do that.

Ok, so it looks like I misunderstood the need for an interrupt. The 
intention in using the swevent_hrtimer code was to enable setting up the 
events as frequency sampled. After taking another look at the gpci and 
24x7 pmus, I'm forbidding sampling events anyhow in event init, so the 
timer code isn't even taken advantage of. I'll drop this patch in the 
next set.

>
> You also try and conceal this information; so you suck.
>

