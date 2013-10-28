Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab3J1JzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 05:55:13 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:46559 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab3J1JzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 05:55:11 -0400
MIME-Version: 1.0
In-Reply-To: <20131026175305.GE1069@krava.brq.redhat.com>
References: <1382533085-7166-1-git-send-email-eranian@google.com>
	<1382533085-7166-5-git-send-email-eranian@google.com>
	<20131025174448.GD7024@krava.brq.redhat.com>
	<CABPqkBTKec0T0NDFUoC8qDVO9stACkzc2xnUqwx6yODHXKaYTg@mail.gmail.com>
	<20131026175305.GE1069@krava.brq.redhat.com>
Date: Mon, 28 Oct 2013 10:55:10 +0100
Message-ID: <CABPqkBSZcdziXWb7w_FQftroF5AusKGHRwecP_196umceivbZg@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] perf,x86: add RAPL hrtimer support
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 7:53 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Sat, Oct 26, 2013 at 07:07:06PM +0200, Stephane Eranian wrote:
>> On Fri, Oct 25, 2013 at 7:44 PM, Jiri Olsa <jolsa@redhat.com> wrote:
>> > On Wed, Oct 23, 2013 at 02:58:05PM +0200, Stephane Eranian wrote:
>
> SNIP
>
>> >> +     list_for_each_entry(event, &pmu->active_list, active_entry) {
>> >> +             rapl_event_update(event);
>> >> +     }
>> >
>> > hi,
>> > I dont fully understand the reason for the timer,
>> > I'm probably missing something..
>> >
>> The reason is rather simple and is similar to what happens with uncore.
>> The counter are narrow, 32-bit and there is no interrupt capability. We
>> need to poll the counters and accumulate in the sw counter to avoid missing
>> an overflow.
>>
>> > - the timer calls rapl_event_update for all defined events
>>
>> No, only for the defined RAPL events which is what we want.
>
> ok, that's what I meant
>
>>
>> > - but rapl_pmu_event_read calls rapl_event_update any time the
>> >   event is read (sys_read)
>> >
>> Yes, but we want to prevent missing a counter overflow. It may happen
>> if the counter counts in a unit which increments fast.
>>
>> > The rapl_event_update only read msr and updates
>> > event->count|hw,prev_count.
>> No, it does update the count:
>>         local64_add(sdelta, &event->count);
>
> ah, there's the shift that takes care of the
> overflowed msr value.. ok
>
No, we try to poll the counter faster than it can possibly overflow.
