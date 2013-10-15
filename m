Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3JOHbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 03:31:12 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:62658 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab3JOHbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 03:31:10 -0400
X-AuditID: 9c93017e-b7c81ae000002d4e-b3-525cef3cdaab
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: mmap output file - v2
References: <1381805731-10398-1-git-send-email-dsahern@gmail.com>
Date: Tue, 15 Oct 2013 16:31:08 +0900
In-Reply-To: <1381805731-10398-1-git-send-email-dsahern@gmail.com> (David
	Ahern's message of "Mon, 14 Oct 2013 20:55:31 -0600")
Message-ID: <87txgj9eir.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Mon, 14 Oct 2013 20:55:31 -0600, David Ahern wrote:
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

Why do they have that different size?

>
[SNIP]
> +/* mmap file big chunks at a time */
> +#define MMAP_OUTPUT_SIZE   (64*1024*1024)

Why did you choose 64MB for the size?  Did you also test other sizes?


[SNIP]
> +
> +		rec->mmap_addr = mmap(NULL, rec->mmap_size,
> +				     PROT_WRITE | PROT_READ,
> +				     MAP_SHARED,
> +				     rec->output,
> +				     offset);
> +
> +		if (rec->mmap_addr == MAP_FAILED) {
> +			pr_err("mmap failed: %d: %s\n", errno, strerror(errno));
> +			return -1;
> +		}
> +
> +		/* expand file to include this mmap segment */
> +		if (ftruncate(rec->output, offset + rec->mmap_size) != 0) {
> +			pr_err("ftruncate failed\n");
> +			return -1;
> +		}

I think this mmap + ftruncate should be reordered.  Although it looks
work without problems the mmap man pages says it's unspecified behavior.

       A file is mapped in multiples of the page size.  For a file that is not
       a multiple of the page  size,  the  remaining  memory  is  zeroed  when
       mapped, and writes to that region are not written out to the file.  The
       effect of changing the size of the underlying file of a mapping on  the
       pages  that  correspond  to  added  or  removed  regions of the file is
       unspecified.


Thanks,
Namhyung
