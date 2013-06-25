Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab3FYJ7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 05:59:12 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:33130 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab3FYJ7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 05:59:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130624084338.GI28407@twins.programming.kicks-ass.net>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
	<20130624084338.GI28407@twins.programming.kicks-ass.net>
Date: Tue, 25 Jun 2013 11:59:09 +0200
Message-ID: <CABPqkBRqiNVZnioV_R4sfam1QwHwXZgo36Gixxg5ALPbLbiXfw@mail.gmail.com>
Subject: Re: [PATCH 0/8] perf: add ability to sample physical data addresses
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 10:43 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Jun 21, 2013 at 04:20:40PM +0200, Stephane Eranian wrote:
>> This patch series extends perf_events with the ability to sample
>> physical data addresses. This is useful with the memory access
>> sampling mode added just recently. In particular, it helps
>> disambiguate data addresses between two processes, such as
>> in the case of a shared memory segment mapped at different
>> addresses in different processes.
>>
>> The patch adds the PERF_SAMPLE_PHYS_ADDR sample_type.
>> A 64-bit address is added to the sample record for
>> the corresponding event.
>>
>> On Intel X86, it is used with the PEBS Load Latency
>> support. On other architectures, zero is returned.
>>
>> The patch series also demonstrates the use of this
>> new feature by extending perf report, mem, record
>> with a --phys-addr option. When enable, it will
>> capture physical data address and display it.
>> This is implemented as a new sort_order (symbol_paddr).
>>
>
> So I'm a bit puzzled by this thing...
>
> What exact problem are we trying to solve here? Only the shared memory
> mapped at different addresses between processes thing mentioned earlier?
>
That is indeed one problem I am trying to address here based on actual
feedback of people building tools on top of PEBS-LL.

> The big problem I see with all this is that typically memory is subject
> to being moved about at random; be it either from paging, compaction,
> NUMA policies or explicit page migration.
>
One guarantee we have is that the physical does correspond to the virtual
address at the time of the interrupt.

But yeah, if physical pages are swapped during the run, then things become
a lot more complicated. I am not trying to address this.

Can page move for shared memory segments?


> Such would completely shatter physical page relations.
>
> If the shared memory thing is really the issue, doesn't perf already
> have the process memory layout (/proc/$PID/maps and aux stream mmap
> updates) with which it can compute map relative offsets and compare
> thusly?

Not sure I understand this.
suppose the same shared memory segment is mapped at two different
addresses by shmat(). First, I don't know if those show up in /proc/maps.
Second, what offset are you talking about here?
