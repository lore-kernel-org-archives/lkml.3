Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab3KKL3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:29:19 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:42354 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab3KKL3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:29:10 -0500
Date: Mon, 11 Nov 2013 12:29:06 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/2] perf record: mmap output file - v4
Message-ID: <20131111112906.GE15810@gmail.com>
References: <1383884605-30968-1-git-send-email-dsahern@gmail.com>
 <1383884605-30968-3-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383884605-30968-3-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> When recording raw_syscalls for the entire system, e.g.,
>     perf record -e raw_syscalls:*,sched:sched_switch -a -- sleep 1
> 
> you end up with a negative feedback loop as perf itself calls write() fairly
> often. This patch handles the problem by mmap'ing the file in chunks of 64M at
> a time and copies events from the event buffers to the file avoiding write
> system calls.
> 
> Before (with write syscall):
> 
>     perf record -o /tmp/perf.data -e raw_syscalls:*,sched:sched_switch -a -- sleep 1
>     [ perf record: Woken up 0 times to write data ]
>     [ perf record: Captured and wrote 81.843 MB /tmp/perf.data (~3575786 samples) ]
> 
> After (using mmap):
> 
>     perf record -o /tmp/perf.data -e raw_syscalls:*,sched:sched_switch -a -- sleep 1
>     [ perf record: Woken up 31 times to write data ]
>     [ perf record: Captured and wrote 8.203 MB /tmp/perf.data (~358388 samples) ]
> 
> In addition to perf-trace benefits using mmap lowers the overhead of
> perf-record. For example,
> 
>   perf stat -i -- perf record -g -o /tmp/perf.data openssl speed aes
> 
> shows a drop in time, CPU cycles, and instructions all drop by more than a
> factor of 3. Jiri also ran a test that showed a big improvement.
> 
> v4: Refactoring per Ingo's comments
> 
> v3: Removed use of bytes_at_mmap_start at the stat() that set it
>     Added user option to control the size of the mmap for writing file.
> 
> v2: Removed msync call before munmap per Jiri's suggestion
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Stephane Eranian <eranian@google.com>
> ---
>  tools/perf/Documentation/perf-record.txt |   5 +
>  tools/perf/builtin-record.c              | 155 +++++++++++++++++++++++++++++++
>  2 files changed, 160 insertions(+)

Looks very clean now!

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
