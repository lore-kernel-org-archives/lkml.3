Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbaFEN0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:26:19 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:52297 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaFEN0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:26:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140605131952.GI6758@twins.programming.kicks-ass.net>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
	<1401917658-26065-10-git-send-email-eranian@google.com>
	<CADknwL5S8QpzCAgrKHjbGTbEx7nA8L=Vu8d-UWAYCg6X25OcGw@mail.gmail.com>
	<CABPqkBSimH8Ob_q3dDtQiW_OwuS9nA4Gsx87H26ywNcmYd38Xw@mail.gmail.com>
	<20140605131952.GI6758@twins.programming.kicks-ass.net>
Date: Thu, 5 Jun 2014 15:26:17 +0200
Message-ID: <CABPqkBQX56XNm21xEb2sj5M7L4dibBoSdm7Th2Mc0n6oxM9YPw@mail.gmail.com>
Subject: Re: [PATCH 9/9] perf/x86: add syfs entry to disable HT bug workaround
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Matt Fleming <matt@console-pimps.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 3:19 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Jun 05, 2014 at 11:29:33AM +0200, Stephane Eranian wrote:
>
>> If you know what you are doing (poweruser), then there are measurements
>> which works fine with the HT erratum.  This is why we have the option.
>>
>> For instance if you only measure events 4x4 in system-wide mode
>> and you know which counters these event are going to use, you don't
>> need the workaround. For instance:
>>
>> # perf stat -a -e r81d0,r01d1,r08d0,r20d1 sleep 5
>>
>> Works well if you have a uniform workload across all CPUs.
>> All those events leak, but the leaks balance themselves and you
>> get the correct counts in the end. The advantage is that you don't
>> have to multiplex. With the workaround enable, this would multiplex
>> a lot.
>>
>> But as I said, this is for experts only.
>
> Still seems tricky, you really want those pinned to make that guarantee,
> and even then its a stretch. I don't think perf tool exposes the pinned
> attribute though, or I'm just not looking right.
>
I think it does. But regardless, if you are on single user machine,
NMI disabled,
and you know where events can run, workload is uniform, then it does work.
Of course, this is a stretch for average users.

> I say stretch, because while I think it'll work out and we'll end up
> programming the counters the same way on each cpu, we really do not make
> that guarantee either, pinned or not.
>
There is no guarantee. However, this is what is currently going on.

> I think I agree with Matt in that exposing this to userspace is really
> asking for trouble.
>
This is a separate patch for a good reason, it is optional. If you think
it is too risky, then drop it.

> Now, I've not yet read through the entire patch series, but how
> impossible is it to allow programming the exact same event on both HT
> siblings?

That would require global view of scheduling and multiplexing in sync
between HT to ensure corrupting events always face each other. But
again this also assume only one tool instance is running.

I think it is better to use the workaround and repatriate the counts
for corrupting events. That would allow correct counting. Sampling
is out on those.
