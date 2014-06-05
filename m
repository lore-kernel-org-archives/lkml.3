Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaFEOp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:45:28 -0400
Received: from mail-yk0-f177.google.com ([209.85.160.177]:41947 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbaFEOpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:45:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140605140316.GB16811@pd.tnic>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
	<1401917658-26065-10-git-send-email-eranian@google.com>
	<CADknwL5S8QpzCAgrKHjbGTbEx7nA8L=Vu8d-UWAYCg6X25OcGw@mail.gmail.com>
	<CABPqkBSimH8Ob_q3dDtQiW_OwuS9nA4Gsx87H26ywNcmYd38Xw@mail.gmail.com>
	<CADknwL6s2ttb5E2JDr6bc_XkwpxnW5ecU-3Ns88=gvgPvLYkPg@mail.gmail.com>
	<CABPqkBQUUb+yEvC8y3oLc0DUbF3DJPzbt3sNL7Zqzufh6EYdRw@mail.gmail.com>
	<CADknwL71NC5wBG1tnqgJ6iiA4y+HYomGpufOn7V+MP2=m7+Mig@mail.gmail.com>
	<CABPqkBTEafZ5MbYM4UQxX92uWcPiphPeXMoJRKTt8jnrB+5j2w@mail.gmail.com>
	<20140605132750.GA16811@pd.tnic>
	<CABPqkBT9ExD4unz0VZ5G1d+oGpkepiwXskgBpv5GTavs=tYAKA@mail.gmail.com>
	<20140605140316.GB16811@pd.tnic>
Date: Thu, 5 Jun 2014 17:45:24 +0300
Message-ID: <CAHzUATiVCHytrG3sz8AmC8anZTQcPDRHp91-kWEoeq=RU7UNiw@mail.gmail.com>
Subject: Re: [PATCH 9/9] perf/x86: add syfs entry to disable HT bug workaround
From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Stephane Eranian <eranian@google.com>,
        Matt Fleming <matt@console-pimps.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 5:03 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Jun 05, 2014 at 03:42:14PM +0200, Stephane Eranian wrote:
>> I gave a test case earlier:
>>
>> # echo 0 >/proc/sys/kernel/nmi_watchdog
>> # run_my_uniform_workload_on_all_cpus &
>> # perf stat -a -e r81d0,r01d1,r08d0,r20d1 sleep 5
>>
>> That run gives the correct answer.
>>
>> If I just look at CPU0 CPU4 siblings:
>>
>> CPU0, counter0 leaks N counts to CPU4, counter 0
>>
>> but at the same time:
>>
>> CPU4, counter0 leaks N counts to CPU0, counter 0
>>
>> This is because we have the same event in the same
>> counter AND the workload is uniform, meaning the
>> event (here loads retired) occurs at the same rate
>> on both siblings.
>>
>> You can test this by measuring only on one HT.
>> # perf stat -a -C0 -e r81d0,r01d1,r08d0,r20d1 sleep 5
>>
>> Note that some events, leak more than they count.
>
> Ok, so AFAIU, this particular workload counts correctly just because
> counters leak the same amount. If so, what happens if you run this exact
> same workload with the workaround enabled? I read something about a bit
> more counter multiplexing... or is there a more serious issue?

The issue is that the outcoming leaked counts are not compensated
by the incoming leaked counts of the sibling thread. With the workaround,
corrupting events are always scheduled with an empty sibling counter.
This means that their leaked counts are lost. So it is expected to see
lower counts with the workaround. Note that this is not a side-effect of
the workaround; leaked counts are expected to be lost with nothing
measured on the sibling counter in general.

In a second series we intend to re-integrate the counts for counting mode
events. The workaround makes this easier because it guarantees
that the sibling counter is unused, thus its counts are purely leaked
counts and they can be safely re-integrated.


>
> Thanks.
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
