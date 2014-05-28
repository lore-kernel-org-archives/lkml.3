Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbaE1PYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:24:32 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:62530 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbaE1PYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:24:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140528145831.GH29957@tassilo.jf.intel.com>
References: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
	<1401257890-30535-7-git-send-email-zheng.z.yan@intel.com>
	<20140528081053.GP11096@twins.programming.kicks-ass.net>
	<20140528145831.GH29957@tassilo.jf.intel.com>
Date: Wed, 28 May 2014 17:24:30 +0200
Message-ID: <CABPqkBQZWC33egtrpGLUHKizzrFRAz68-AsP-GWxB=Q--bjf8g@mail.gmail.com>
Subject: Re: [RFC PATCH 6/7] perf, x86: large PEBS interrupt threshold
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 4:58 PM, Andi Kleen <ak@linux.intel.com> wrote:
>> In particular, the 0x90 offset (IA32_PERF_GLOBAL_STATUS). Intel once
>> confirmed to me that that is a direct copy of the similarly named MSR at
>> the time of the PEBS assist.
>
> That is correct.
>
>>
>> This is a problem, since if multiple counters overflow multiple bits
>> will be set and its (afaict) ambiguous which event is for which counter.
>
> When a PEBS counter overflows it clears its respective GLOBAL_STATUS bit
> automatically. You may see multiple STATUS bits in the PEBS record
> if two PEBS counters overflow at exactly the same time, but that is no different
> from the threshold==1 case (and relatively rare)
>
> So the threshold > 1 and the threshold == 1 case work identically.
>
That's what I was trying to get to in my msg.
And I think today, you will generate up to 4 SAMPLE records if all
PEBS event overflowed at the same time and this is fine based on
what I see in intel_pmu_drain_pebs_nhm().

The only part I don't quite follow here is this:
                      if (__test_and_set_bit(bit, (unsigned long *)&status))
                                continue;

Which seems to indicate the code is making sure each counter is
processed only once. But it can only be processed once, if you have
only one record. And if you have multiple, you want to be able to
handle the same counter multiple times, at least once perf PEBS
record. So I am a bit confused about this test.

>> So until you can give an official Intel answer on how all this demuxing
>> is supposed to work and be correct this patch set isn't moving anywhere.
>
> FWIW a patch signed off by intel.com is an official Intel statement.
>
>>
>> > To supply a TID it
>> > requires flushing on context switch. It can however supply the IP
>>
>> On SNB+, previous to SNB it would need to have precise==1. I've seen no
>> such logic in. Instead you seem to artificially limit it to SNB+, for no
>> apparent reason to me.
>
> Only tested on Sandy Bridge+
>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only
