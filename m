Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209Ab3I0CY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 22:24:57 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45828 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab3I0CYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 22:24:55 -0400
X-AuditID: 9c930179-b7c8bae000006c65-2d-5244ec755264
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: mmap output file - RFC
References: <1379901959-5285-1-git-send-email-dsahern@gmail.com>
	<20130926175105.GB9121@krava.brq.redhat.com>
Date: Fri, 27 Sep 2013 11:24:53 +0900
In-Reply-To: <20130926175105.GB9121@krava.brq.redhat.com> (Jiri Olsa's message
	of "Thu, 26 Sep 2013 19:51:05 +0200")
Message-ID: <87a9izovbe.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri and David,

On Thu, 26 Sep 2013 19:51:05 +0200, Jiri Olsa wrote:
> On Sun, Sep 22, 2013 at 08:05:59PM -0600, David Ahern wrote:
>> When recording raw_syscalls for the entire system, e.g.,
>>     perf record -e raw_syscalls:*,sched:sched_switch -a -- sleep 1
>> 
>> you end up with a negative feedback loop as perf itself calls
>> write() fairly often. This patch mmap's the file in chunks of 64M
>> at a time and copies events from the event buffers to the file
>> avoiding write system calls.
>
> moved processing into userspace:
>
>     17.24%  -17.10%  libpthread-2.15.so  [.] __write_nocancel                    
>      ...
>      0.07%   +0.64%  libc-2.15.so        [.] __memcpy_sse2                               
>      0.02%  +51.84%  libc-2.15.so        [.] __memcpy_ssse3_back                         
>      0.01%   +0.34%  libc-2.15.so        [.] __mempcpy_sse2                              
>      ...
>> 
>> Before (with write syscall):
>> 
>> perf record -o /tmp/perf.data -e raw_syscalls:*,sched:sched_switch -a -- sleep 1
>> [ perf record: Woken up 0 times to write data ]
>> [ perf record: Captured and wrote 81.843 MB /tmp/perf.data (~3575786 samples) ]
>> 
>> After (using mmap):
>> 
>> perf record -o /tmp/perf.data -e raw_syscalls:*,sched:sched_switch -a -- sleep 1
>> [ perf record: Woken up 31 times to write data ]
>
>                           ^^^^^^^^
> but it's still faster, since we finally get perf a chance to sleep ;-)
>
> new time:
> 	real    0m30.392s
> 	user    0m0.041s
> 	sys     0m0.389s
>
> old time:
> 	real    0m32.235s
> 	user    0m3.080s
> 	sys     0m14.444s

But why the new user time took so short?  I guess it should take at
least 10 seconds or so.  Any ideas?

>
>
>> [ perf record: Captured and wrote 8.203 MB /tmp/perf.data (~358388 samples) ]
>> 
>> Before I get too far down this path I wanted to get comments on the approach.
>
> I think it's worthwhile doing this

Indeed!  It looks like a nice improvement.

Thanks,
Namhyung
