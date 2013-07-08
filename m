Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab3GHSI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 14:08:29 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:55595 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab3GHSI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 14:08:27 -0400
MIME-Version: 1.0
In-Reply-To: <51DACE08.5030109@intel.com>
References: <20130704223010.GA30625@quad>
	<51DACE08.5030109@intel.com>
Date: Mon, 8 Jul 2013 20:08:25 +0200
Message-ID: <CABPqkBT3QcKPGUoo2Wuvn0TdK3TKcMWtbuq4jGqbouBvqaKgDg@mail.gmail.com>
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

On Mon, Jul 8, 2013 at 4:34 PM, Dave Hansen <dave.hansen@intel.com> wrote:
> On 07/04/2013 03:30 PM, Stephane Eranian wrote:
>> There was an misunderstanding on the API of the do_div()
>> macro. It returns the remainder of the division and this
>> was not what the function expected leading to disabling the
>> interrupt latency watchdog.
>
> "Misunderstanding" is a very kind term for what I did there.  Stephane,
> were you actually running in to the new cpu limit, or were you just
> trying to update kernel.perf_event_max_sample_rate?
>
I am chasing a problem on HSW desktop where your code triggers the throttling.
It happens systematically on my system first time I run perf record usually the
first time.

I admit I have some issues with your patch and what it is trying to avoid.
There is already interrupt throttling. Your code seems to address latency
issues on the handler rather than rate issues. Yet to mitigate the latency
it is modify the throttling.

For some unknown reasons, my HSW interrupt handler goes crazy for
a while running a very simple:
   $ perf record -e cycles branchy_loop

And I do see in the log:
perf samples too long (2546 > 2500), lowering
kernel.perf_event_max_sample_rate to 50000

Which is an enormous latency. I instrumented the code, and under
normal conditions the latency
of the handler for this perf run, is about 500ns and it is consistent
with what I see on SNB.
However, on HSW, it is sometimes 5x longer. I have no explanation for
this. Andi's patch
to delay the NMI ack is enabled but it does not alleviate this
problem. There is something
else going on possibly with the HW, and I don't know what it is. This
is not a one off. It lasts for
several calls because it fires your watchdog which averages out over
multiple calls.
So one cannot blame this on the case where the samping buffer gets
full, for instance.

My model is:
processor : 6
vendor_id : GenuineIntel
cpu family : 6
model : 60
model name : Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
stepping : 3
microcode : 0x7

So something is not right and I would like to know what it is.
I will keep investigating.

> BTW, I also did the same thing in 2ab00456:
>
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=2ab00456ea8a0d79acb1390659b98416111880b2
>
> I'll have a patch out shortly for that one, but its damage would be
> limited to a bogus printk.
