Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab3JONf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:35:58 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:52070 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266Ab3JONf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:35:57 -0400
Message-ID: <525D44B9.7060901@gmail.com>
Date: Tue, 15 Oct 2013 07:35:53 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: mmap output file - v2
References: <1381805731-10398-1-git-send-email-dsahern@gmail.com> <87txgj9eir.fsf@sejong.aot.lge.com>
In-Reply-To: <87txgj9eir.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/13 1:31 AM, Namhyung Kim wrote:
> Hi David,
>
> On Mon, 14 Oct 2013 20:55:31 -0600, David Ahern wrote:
>> When recording raw_syscalls for the entire system, e.g.,
>>      perf record -e raw_syscalls:*,sched:sched_switch -a -- sleep 1
>>
>> you end up with a negative feedback loop as perf itself calls
>> write() fairly often. This patch handles the problem by mmap'ing the
>> file in chunks of 64M at a time and copies events from the event buffers
>> to the file avoiding write system calls.
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
>> [ perf record: Captured and wrote 8.203 MB /tmp/perf.data (~358388 samples) ]
>
> Why do they have that different size?

perf calls write() for each mmap, each time through the loop. Each write 
generates 2 events (syscall entry + exit) -- ie., generates more events. 
That's the negative feedback loop.


> [SNIP]
>> +
>> +		rec->mmap_addr = mmap(NULL, rec->mmap_size,
>> +				     PROT_WRITE | PROT_READ,
>> +				     MAP_SHARED,
>> +				     rec->output,
>> +				     offset);
>> +
>> +		if (rec->mmap_addr == MAP_FAILED) {
>> +			pr_err("mmap failed: %d: %s\n", errno, strerror(errno));
>> +			return -1;
>> +		}
>> +
>> +		/* expand file to include this mmap segment */
>> +		if (ftruncate(rec->output, offset + rec->mmap_size) != 0) {
>> +			pr_err("ftruncate failed\n");
>> +			return -1;
>> +		}
>
> I think this mmap + ftruncate should be reordered.  Although it looks
> work without problems the mmap man pages says it's unspecified behavior.
>
>         A file is mapped in multiples of the page size.  For a file that is not
>         a multiple of the page  size,  the  remaining  memory  is  zeroed  when
>         mapped, and writes to that region are not written out to the file.  The
>         effect of changing the size of the underlying file of a mapping on  the
>         pages  that  correspond  to  added  or  removed  regions of the file is
>         unspecified.

The mmap only expands the address range; the ftruncate expands the file 
behind the mmap. Both are needed and must succeed to function properly, 
and I don't see how the order matters. ie.,

This order has an extra call on the failure path:
   ftruncate
   mmap
   - on failure call ftruncate to reset file size

The order I have does not have that problem:
   mmap
   ftruncate

Here on failure just return -1 and we end the session.

David
