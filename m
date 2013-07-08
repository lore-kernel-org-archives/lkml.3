Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab3GHUUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 16:20:24 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:53224 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab3GHUUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 16:20:21 -0400
MIME-Version: 1.0
In-Reply-To: <51DB1B75.8060303@intel.com>
References: <20130704223010.GA30625@quad>
	<51DACE08.5030109@intel.com>
	<CABPqkBT3QcKPGUoo2Wuvn0TdK3TKcMWtbuq4jGqbouBvqaKgDg@mail.gmail.com>
	<51DB1B75.8060303@intel.com>
Date: Mon, 8 Jul 2013 22:20:21 +0200
Message-ID: <CABPqkBRdK5WwokEWE3tQZiAyO3pWbS9aUn7HUkQT+XsMYfJUiA@mail.gmail.com>
Subject: Re: [PATCH] perf: fix interrupt handler timing harness
From: Stephane Eranian <eranian@google.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, dave.hansen@linux.intel.com,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 8, 2013 at 10:05 PM, Dave Hansen <dave.hansen@intel.com> wrote:
> On 07/08/2013 11:08 AM, Stephane Eranian wrote:
>> I admit I have some issues with your patch and what it is trying to avoid.
>> There is already interrupt throttling. Your code seems to address latency
>> issues on the handler rather than rate issues. Yet to mitigate the latency
>> it is modify the throttling.
>
> If we have too many interrupts, we need to drop the rate (existing
> throttling).
>
> If the interrupts _consistently_ take too long individually they can
> starve out all the other CPU users.  I saw no way to make them finish
> faster, so the only recourse is to also drop the rate.
>
I think we need to investigate why some interrupts take so much time.
Could be HW, could be SW. Not talking about old hardware here.
Once we understand this, then we know maybe adjust the timing on
our patch.

>> For some unknown reasons, my HSW interrupt handler goes crazy for
>> a while running a very simple:
>>    $ perf record -e cycles branchy_loop
>>
>> And I do see in the log:
>> perf samples too long (2546 > 2500), lowering
>> kernel.perf_event_max_sample_rate to 50000
>>
>> Which is an enormous latency. I instrumented the code, and under
>> normal conditions the latency
>> of the handler for this perf run, is about 500ns and it is consistent
>> with what I see on SNB.
>
> I was seeing latencies near 1 second from time to time, but
> _consistently_ in the hundreds of milliseconds.

On my systems, I see 500ns with one session running. But on HSW,
something else is going on with bursts at 2500ns. That's not normal.
I want an explanation for this.
