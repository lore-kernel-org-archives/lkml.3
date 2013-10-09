Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab3JIGAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 02:00:06 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:50043 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab3JIGAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 02:00:03 -0400
Date: Wed, 9 Oct 2013 07:59:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/3] perf record: mmap output file
Message-ID: <20131009055957.GA7664@gmail.com>
References: <1381289214-24885-1-git-send-email-dsahern@gmail.com>
 <1381289214-24885-4-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381289214-24885-4-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> When recording raw_syscalls for the entire system, e.g.,
>     perf record -e raw_syscalls:*,sched:sched_switch -a -- sleep 1
> 
> you end up with a negative feedback loop as perf itself calls
> write() fairly often. This patch handles the problem by mmap'ing the
> file in chunks of 64M at a time and copies events from the event buffers
> to the file avoiding write system calls.
> 
> Before (with write syscall):
> 
> perf record -o /tmp/perf.data -e raw_syscalls:*,sched:sched_switch -a -- sleep 1
> [ perf record: Woken up 0 times to write data ]
> [ perf record: Captured and wrote 81.843 MB /tmp/perf.data (~3575786 samples) ]
> 
> After (using mmap):
> 
> perf record -o /tmp/perf.data -e raw_syscalls:*,sched:sched_switch -a -- sleep 1
> [ perf record: Woken up 31 times to write data ]
> [ perf record: Captured and wrote 8.203 MB /tmp/perf.data (~358388 samples) ]
> 
> In addition to perf-trace benefits using mmap lowers the overhead of
> perf-record. For example,
> 
>   perf stat -i -- perf record -g -o /tmp/perf.data openssl speed aes
> 
> showsi a drop in time, CPU cycles, and instructions all drop by more than a
> factor of 3. Jiri also ran a test that showed a big improvement.

Here are some thoughts on how 'perf record' tracing performance could be 
further improved:

1)

The use of non-temporal stores (MOVNTQ) to copy the ring-buffer into the 
file buffer makes sure the CPU cache is not trashed by the copying - which 
is the largest 'collateral damage' copying does.

glibc does not appear to expose non-temporal instructions so it's going to 
be architecture dependent - but we could build the copy_user_nocache() 
function from the kernel proper (or copy it - we could even simplify it: 
knowing that only large and page aligned buffers are going to be copied 
with it).

See how tools/perf/bench/mem-mem* does that to be able to measure the 
kernel's memcpy() and memset() function performance.

2)

Yet another method would be to avoid the copies altogether via the splice 
system-call - see:

	git grep splice kernel/trace/

To make splice low-overhead we'd have to introduce a mode to not mmap the 
data part of the perf ring-buffer and splice the data straight from the 
perf fd into a temporary pipe and over from the pipe into the target file 
(or socket).

OTOH non-temporal stores are incredibly simple and memory bandwidth is 
plenty on modern systems so I'd certainly try that route first.

Thanks,

	Ingo
