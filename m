Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbaAHVsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:48:46 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:37542 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531AbaAHVsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:48:43 -0500
Message-ID: <52CDC7B5.6060704@gmail.com>
Date: Wed, 08 Jan 2014 14:48:37 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Joseph Schuchart <joseph.schuchart@tu-dresden.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        thomas.ilsche@tu-dresden.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Perf: Correct Assumptions about Sample Timestamps in
 Passes
References: <52B437AA.4090102@tu-dresden.de> <52B479E1.7020204@gmail.com> <20131223131051.GB585@localhost.localdomain> <52B84C49.70001@gmail.com> <20131226151429.GA15303@localhost.localdomain> <52BC4A13.1090508@gmail.com> <20131226153033.GC15303@localhost.localdomain> <52C46083.9070605@gmail.com> <20140103220745.GB11061@localhost.localdomain> <52C73D90.3020904@gmail.com> <20140104150539.GA17617@localhost.localdomain>
In-Reply-To: <20140104150539.GA17617@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/4/14, 8:05 AM, Frederic Weisbecker wrote:
> On Fri, Jan 03, 2014 at 03:45:36PM -0700, David Ahern wrote:
>> On 1/3/14, 3:07 PM, Frederic Weisbecker wrote:
>>> I'm not sure I understand why we need that. Why doesn't it work by simply flushing
>>> events prior to the earliest timestamp among every CPUs last event?
>>
>> Here's one scenario. Consider N-mmaps:
>>
>>         |----- t_flush
>>         v
>> 0   -----|---x------------------------
>> 1   -----|----|------------------------
>> ...      |
>> N   -----|-------ssss-|-----------------
>>
>>       t_start t_1 ... t_N
>>
>> You start a round at some time -- t_start. By starting a round it
>> means you go to mmap 0 and check for events, then mmap 1, ..., mmap
>> N. It takes a finite amount of time to move from one mmap to
>> another.
>>
>> Assume there are no events on mmap 0, 1, ... N-1 but samples are
>> generated in mmap N. In the time it takes to move forward from 0 to
>> N, a sample can be generated for mmap 0 and written to the buffer -
>> the 'x' above. It now contains a timestamp < than samples on any
>> other mmap and out pops the flush error.
>
> Lets reformulate as following. I'm copy-pasting the example in session.c
> but adapting it to your scenario.
>
>   *    ============ PASS n =================
>   *       CPU 0         |   CPU 1
>   *                     |
>   *          -          |         2
>   *          -          |         3
>   *          -          |         4  <--- max recorded
>   *
>   *    ============ PASS n + 1 ==============
>   *       CPU 0         |   CPU 1
>   *                     |
>   *          1          |         5
>   *          -          |         6
>   *          -          |         7 <---- max recorded
>   *
>   *      Flush every events below timestamp 4
>   *
>
> So in the first round, CPU 0 has no event by the time we read it. Then while
> we read the events from CPU 1 (val 2,3,4), a new one comes in concurrently
> in CPU 0 (val 1, which matches 's' in your example ). We missed it due to the
> linear mmap read on all buffers so we'll get it on the second round.
>
> We find it out in the second round, CPU 1 has also new events. At this time we know that
> if CPU 0 had events up to timestamp 4, we should have seen all of them because
> we read CPU 0 buffer in PASS n + 1 after we read CPU 1 buffer on PASS n.
>
> Of course that's what happens in a perfect world with the assumption that ordering
> is all correct, that events write/commit doesn't take too much time to complete,
> that perf_clock() is globally monotonic (and it's not IIUC). But a little heuristical
> correction on the timestamp barrier should prevent from issues with that.
>
> So this is how the code behaves currently and it should handle a case like above.

The existing code does not work. Your unstable tsc patch did not work. I 
have not tried Joseph's patch. Are you proposing that one or do you have 
something else in mind?

> Now there is still the problem of:
>
> 1) local timestamps not moving forward (could it happen when events happen in storm,
> when they overflow multiple times in once for example, and clock is not granular
> enough?)

Even at 650k events/sec I am not seeing this problem.

> Anyway this should be solved with the patch that takes the earliest last event on all
> CPU buffer instead of the maximum of a round as a barrier.
>
> 2) local timestamps not monotonic due to interrupting events. This could be fixed
> in the kernel with moving perf_clock() snapshot in perf_output_sample().
>

For perf-kvm the events are all tracepoints, so there should not be a 
problem of overlap due to interruption.

David
