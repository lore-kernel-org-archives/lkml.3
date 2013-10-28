Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab3J1JJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 05:09:49 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:43822 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab3J1JJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 05:09:47 -0400
MIME-Version: 1.0
In-Reply-To: <871u369cq0.fsf@sejong.aot.lge.com>
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
	<1381468543-25334-7-git-send-email-namhyung@kernel.org>
	<CAFTL4hz-4ASg8iba6A7_wyU8RaT9a7e9oRkobAbz5+qOt9i9RQ@mail.gmail.com>
	<20131025130417.GB20423@ghostprotocols.net>
	<526A8F54.2040601@gmail.com>
	<CAFTL4hzX=0-_gK6E9V7oH3hrrCerVn_s8TVBsDspzLvpQEmtpw@mail.gmail.com>
	<526AB61B.80505@gmail.com>
	<871u369cq0.fsf@sejong.aot.lge.com>
Date: Mon, 28 Oct 2013 10:09:46 +0100
Message-ID: <CAFTL4hxbfJy9Tfw2j5ptW5k5AjCBYSuf5_+7U9ShWUQaDqOpdw@mail.gmail.com>
Subject: Re: [PATCH 6/8] perf tools: Add new comm infrastructure
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/28 Namhyung Kim <namhyung@kernel.org>:
> Hi David,
>
> On Fri, 25 Oct 2013 12:19:07 -0600, David Ahern wrote:
>> On 10/25/13 12:12 PM, Frederic Weisbecker wrote:
>>> Oh I see. It's possible that my massive conversion to use the comm
>>> accessor got blind at some point and left over a few things. I
>>> remember that I only lightly tested that new comm infrastructure. I
>>> mean I tested a lot of "perf report -s foo,bar" combinations for
>>> performance comparisons but I haven't tested the perf script and all
>>> the other perf tools.
>>>
>>> I'll rebase these patches and test that wider before resending.
>>
>> specifically, I see stuff like perf forking ls and comm still shows as
>> perf even though there is COMM record with the rename to ls. I believe
>> the test case was something like:
>>
>> perf sched record -- ls
>> perf script
>
> Hmm.. did you try my latest v5 patchset?  I couldn't reproduce the case
> at least for the command lines above.
>
>   $ perf script
>             perf 24810 [007] 1546517.815809: sched:sched_stat_runtime: comm=perf pid=24810 ru
>             perf 24810 [007] 1546517.815909: sched:sched_wakeup: comm=perf pid=24811 prio=120
>          swapper     0 [008] 1546517.815913: sched:sched_switch: prev_comm=swapper/8 prev_pid
>             perf 24810 [007] 1546517.815953: sched:sched_stat_runtime: comm=perf pid=24810 ru
>             perf 24810 [007] 1546517.815957: sched:sched_switch: prev_comm=perf prev_pid=2481
>             perf 24811 [008] 1546517.815992: sched:sched_wakeup: comm=migration/8 pid=48 prio
>             perf 24811 [008] 1546517.815993: sched:sched_stat_runtime: comm=perf pid=24811 ru
>             perf 24811 [008] 1546517.815993: sched:sched_switch: prev_comm=perf prev_pid=2481
>      migration/8    48 [008] 1546517.815996: sched:sched_migrate_task: comm=perf pid=24811 pr
>      migration/8    48 [008] 1546517.816000: sched:sched_switch: prev_comm=migration/8 prev_p
>          swapper     0 [009] 1546517.816002: sched:sched_switch: prev_comm=swapper/9 prev_pid
>               ls 24811 [009] 1546517.816808: sched:sched_stat_runtime: comm=ls pid=24811 runt
>
>
> Here, the process 24811 has only 3 samples before COMM event
>
>   $ perf report -D | grep 24811 | grep -v MMAP | head
>   0 0 0x629b0 [0x38]: PERF_RECORD_COMM: perf:24811
>   8 1546517815992058 0x65f50 [0x68]: PERF_RECORD_SAMPLE(IP, 1): 24811/24811: 0xffffffff81091512 period: 1 addr: 0
>    ... thread: perf:24811
>   8 1546517815993189 0x65fb8 [0x70]: PERF_RECORD_SAMPLE(IP, 1): 24811/24811: 0xffffffff81099d25 period: 83314 addr: 0
>    ... thread: perf:24811
>   8 1546517815993975 0x66028 [0x80]: PERF_RECORD_SAMPLE(IP, 1): 24811/24811: 0xffffffff81659d60 period: 1 addr: 0
>    ... thread: perf:24811
>   9 1546517816224342 0x66378 [0x38]: PERF_RECORD_COMM: ls:24811
>   9 1546517816808637 0x667f0 [0x70]: PERF_RECORD_SAMPLE(IP, 1): 24811/24811: 0xffffffff81099d25 period: 810663 addr: 0
>    ... thread: ls:24811
>
>   $ perf version
>   perf version 3.11.ge9eb20
>

Ah cool! Could you please remind me the name of that branch so that I
can do some tests and work on top of it?

Thanks.
