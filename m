Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbaACWpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 17:45:42 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:49218 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbaACWpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 17:45:41 -0500
Message-ID: <52C73D90.3020904@gmail.com>
Date: Fri, 03 Jan 2014 15:45:36 -0700
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
References: <528E1EE6.9040407@tu-dresden.de> <20131127135137.GA24403@gmail.com> <52B437AA.4090102@tu-dresden.de> <52B479E1.7020204@gmail.com> <20131223131051.GB585@localhost.localdomain> <52B84C49.70001@gmail.com> <20131226151429.GA15303@localhost.localdomain> <52BC4A13.1090508@gmail.com> <20131226153033.GC15303@localhost.localdomain> <52C46083.9070605@gmail.com> <20140103220745.GB11061@localhost.localdomain>
In-Reply-To: <20140103220745.GB11061@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/3/14, 3:07 PM, Frederic Weisbecker wrote:
> On Wed, Jan 01, 2014 at 11:37:55AM -0700, David Ahern wrote:
>> On 12/26/13, 8:30 AM, Frederic Weisbecker wrote:
>>> On Thu, Dec 26, 2013 at 10:24:03AM -0500, David Ahern wrote:
>>>> On 12/26/13, 10:14 AM, Frederic Weisbecker wrote:
>>>>>> I was carrying that patch while working on perf-kvm-stat-live last
>>>>>> Fall. It does not solve the problem for live commands, so ended up
>>>>>> dropping it and going with local (to the command) hacks. I still
>>>>>> think for live commands getting a perf_clock timestamp at the start
>>>>>> of a round and using that as the flush time will work best.
>>
>> For perf-kvm-stat-live using perf_clock value at the start of the
>> round as the flush time works beautifully:
>>
>> https://github.com/dsahern/linux/commit/ba8b7b63d5dbdc95aedbbafa670c2232e0cc07a2
>>
>> Never once failed with "Warning: Timestamp below last timeslice
>> flush" error.
>
> I'm not sure I understand why we need that. Why doesn't it work by simply flushing
> events prior to the earliest timestamp among every CPUs last event?

Here's one scenario. Consider N-mmaps:

        |----- t_flush
        v
0   -----|---x------------------------
1   -----|----|------------------------
...      |
N   -----|-------ssss-|-----------------

      t_start t_1 ... t_N

You start a round at some time -- t_start. By starting a round it means 
you go to mmap 0 and check for events, then mmap 1, ..., mmap N. It 
takes a finite amount of time to move from one mmap to another.

Assume there are no events on mmap 0, 1, ... N-1 but samples are 
generated in mmap N. In the time it takes to move forward from 0 to N, a 
sample can be generated for mmap 0 and written to the buffer - the 'x' 
above. It now contains a timestamp < than samples on any other mmap and 
out pops the flush error.

perf-kvm can have over 650,000 events per second and those tend to come 
in bunches on a single mmap. So even if you go for a "max of the min 
times across mmaps" it is often wrong.

The non-perf_clock logic in perf-kvm uses the min time across all mmaps 
and even it occasionally fails with the flush error.

David


>
> I can see one remaining issue when an event interrupts another in a CPU. If the
> interrupt happens after perf_prepare_sample() -> perf_clock() and perf_output_begin(),
> we may have locally non-monotonic timestamps in a CPU buffer.
>
> That could be solved with a heuristic similar to yours: flush events prior a few millisecs
> before the barrier since interrupt are supposed to be short. Or we could move the perf_clock()
> event snapshot to perf_output_sample() to make sure that the event space is reserved before
> we get the timestamp, thus the interrupting events having superior timestamps are guaranteed
> to be past the interrupted event in the stream.
>

