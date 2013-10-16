Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab3JPBwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 21:52:53 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:47814 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab3JPBww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 21:52:52 -0400
X-AuditID: 9c93017d-b7b2eae000005519-a5-525df1722c12
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: mmap output file - v2
References: <1381805731-10398-1-git-send-email-dsahern@gmail.com>
	<87txgj9eir.fsf@sejong.aot.lge.com> <525D44B9.7060901@gmail.com>
Date: Wed, 16 Oct 2013 10:52:50 +0900
In-Reply-To: <525D44B9.7060901@gmail.com> (David Ahern's message of "Tue, 15
	Oct 2013 07:35:53 -0600")
Message-ID: <87haci9e31.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013 07:35:53 -0600, David Ahern wrote:
> On 10/15/13 1:31 AM, Namhyung Kim wrote:
>> Hi David,
>>
>> On Mon, 14 Oct 2013 20:55:31 -0600, David Ahern wrote:
>>> When recording raw_syscalls for the entire system, e.g.,
>>>      perf record -e raw_syscalls:*,sched:sched_switch -a -- sleep 1
>>>
>>> you end up with a negative feedback loop as perf itself calls
>>> write() fairly often. This patch handles the problem by mmap'ing the
>>> file in chunks of 64M at a time and copies events from the event buffers
>>> to the file avoiding write system calls.
>>>
>>> Before (with write syscall):
>>>
>>> perf record -o /tmp/perf.data -e raw_syscalls:*,sched:sched_switch -a -- sleep 1
>>> [ perf record: Woken up 0 times to write data ]
>>> [ perf record: Captured and wrote 81.843 MB /tmp/perf.data (~3575786 samples) ]
>>>
>>> After (using mmap):
>>>
>>> perf record -o /tmp/perf.data -e raw_syscalls:*,sched:sched_switch -a -- sleep 1
>>> [ perf record: Woken up 31 times to write data ]
>>> [ perf record: Captured and wrote 8.203 MB /tmp/perf.data (~358388 samples) ]
>>
>> Why do they have that different size?
>
> perf calls write() for each mmap, each time through the loop. Each
> write generates 2 events (syscall entry + exit) -- ie., generates more
> events. That's the negative feedback loop.

Aha, okay.  So it mostly matters to syscall tracing, right?  For a
normal record session, it seems that the effect is not that large:

Before:

  $ perf stat -r3 --null --sync -- perf record -a -- sleep 5
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.467 MB perf.data (~20420 samples) ]
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.544 MB perf.data (~23750 samples) ]
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.482 MB perf.data (~21073 samples) ]
  
   Performance counter stats for 'perf record -a -- sleep 5' (3 runs):
  
         5.174476094 seconds time elapsed                                          ( +-  0.07% )

  $ perf record -- perf bench sched pipe
  # Running sched/pipe benchmark...
  # Executed 1000000 pipe operations between two processes
  
       Total time: 21.271 [sec]
  
        21.271357 usecs/op
            47011 ops/sec
  [ perf record: Woken up 21 times to write data ]
  [ perf record: Captured and wrote 5.643 MB perf.data (~246524 samples) ]


After:

  $ perf stat -r3 --null --sync -- perf record -a -- sleep 5
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.459 MB perf.data (~20055 samples) ]
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.463 MB perf.data (~20230 samples) ]
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.467 MB perf.data (~20401 samples) ]
  
   Performance counter stats for 'perf record -a -- sleep 5' (3 runs):
  
         5.085910919 seconds time elapsed                                          ( +-  0.06% )

  $ perf record -- perf bench sched pipe
  # Running sched/pipe benchmark...
  # Executed 1000000 pipe operations between two processes
  
       Total time: 21.175 [sec]
  
        21.175406 usecs/op
            47224 ops/sec
  [ perf record: Woken up 21 times to write data ]
  [ perf record: Captured and wrote 5.612 MB perf.data (~245206 samples) ]


Thanks,
Namhyung
