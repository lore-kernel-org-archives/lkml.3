Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaFWJAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:00:24 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:49214 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaFWJAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:00:19 -0400
MIME-Version: 1.0
In-Reply-To: <20140623084254.GK19860@laptop.programming.kicks-ass.net>
References: <1403193509-22393-1-git-send-email-eranian@google.com>
	<1403193509-22393-3-git-send-email-eranian@google.com>
	<20140623084254.GK19860@laptop.programming.kicks-ass.net>
Date: Mon, 23 Jun 2014 11:00:18 +0200
Message-ID: <CABPqkBTXvBwwQ1vWkfQRtq7=GxS_KyE94wSOxPaBCffeJ7yc+A@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf/x86: fix constraints for load latency and
 precise events
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Joe Mario <jmario@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Mon, Jun 23, 2014 at 10:42 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Jun 19, 2014 at 05:58:29PM +0200, Stephane Eranian wrote:
>> The load latency does not have to be constrained to counter 3
>> on any of SNB, IVB, HSW. It operates fine on any PEBS-capable
>> counter.
>>
>> The precise store event for SNB, IVB needs to be on counter 3.
>> But on Haswell, precise store is implemented differently and
>> the constraint is not needed anymore, so we remove it.
>>
>> The artificial constraint on counter 3 was used to ease
>> scheduling because the load latency events rely on an
>> extra MSR which is shared for all the counters. But
>> perf_events has an infrastructure to handle shared_regs
>> and does not need to constrain the load latency event to
>> a single counter. It was already using that infrastructure
>> with the constraint on counter 3. By eliminating the constraint
>> on load latency, it becomes possible to measure loads and stores
>> precisely without multiplexing.
>
> So that all makes sense, except why did they pick the same constraint to
> begin with? If they'd picked cnt2 for ll and cnt3 (as per the hardware
> constraint) for st, this would've already been possible right?
>
I don't know why they did it this way. I think somehow, it is believe that
ll and st cannot be captured together (and putting both on cnt3 enforces
that). But when it seems to be working fine. If someone from Intel can
confirm this is okay/not okay then we can revisit.

> Except of course, that the SDM states that no other PEBS event should be
> active when using ll; we don't enforce that (although userspace could
> request exclusive). What about this constraint? Is the SDM wrong about
> this?

For LL this is usually the case if you assume a single measurement is
active. But in system-wide on a shared system, it is possible to have
other events active on the same CPU. I have not tried that to see the
impact on ll.

You can say the same with PREC_DIST which up until HSW needs to be
taken alone, i.e., no other event active. We don't enforce that either, it would
cause problems with the NMI watchdog.
