Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab3IZRvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 13:51:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab3IZRvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 13:51:44 -0400
Date: Thu, 26 Sep 2013 19:51:05 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: mmap output file - RFC
Message-ID: <20130926175105.GB9121@krava.brq.redhat.com>
References: <1379901959-5285-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379901959-5285-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22, 2013 at 08:05:59PM -0600, David Ahern wrote:
> When recording raw_syscalls for the entire system, e.g.,
>     perf record -e raw_syscalls:*,sched:sched_switch -a -- sleep 1
> 
> you end up with a negative feedback loop as perf itself calls
> write() fairly often. This patch mmap's the file in chunks of 64M
> at a time and copies events from the event buffers to the file
> avoiding write system calls.

moved processing into userspace:

    17.24%  -17.10%  libpthread-2.15.so  [.] __write_nocancel                    
     ...
     0.07%   +0.64%  libc-2.15.so        [.] __memcpy_sse2                               
     0.02%  +51.84%  libc-2.15.so        [.] __memcpy_ssse3_back                         
     0.01%   +0.34%  libc-2.15.so        [.] __mempcpy_sse2                              
     ...
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

                          ^^^^^^^^
but it's still faster, since we finally get perf a chance to sleep ;-)

new time:
	real    0m30.392s
	user    0m0.041s
	sys     0m0.389s

old time:
	real    0m32.235s
	user    0m3.080s
	sys     0m14.444s


> [ perf record: Captured and wrote 8.203 MB /tmp/perf.data (~358388 samples) ]
> 
> Before I get too far down this path I wanted to get comments on the approach.

I think it's worthwhile doing this

jirka
