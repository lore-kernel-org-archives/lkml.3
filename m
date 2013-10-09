Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab3JIHOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 03:14:19 -0400
Received: from mout.gmx.net ([212.227.15.19]:59930 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab3JIHOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 03:14:18 -0400
Message-ID: <1381302852.5388.40.camel@marge.simpson.net>
Subject: Re: [PATCH 3/3] perf record: mmap output file
From: Mike Galbraith <efault@gmx.de>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Date: Wed, 09 Oct 2013 09:14:12 +0200
In-Reply-To: <1381289214-24885-4-git-send-email-dsahern@gmail.com>
References: <1381289214-24885-1-git-send-email-dsahern@gmail.com>
	 <1381289214-24885-4-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V03:K0:OgQHHcJ+Yv5V8veehTGZrfOiHsBV9dTw/Hrnjbf0njyMUpLgIXm
 6b2zKoayOIFjD4zHPKa8JHIksCfQ3KmLm/z/F97BT8kDMmVRZo00EEf6X+4evpaGi4Twdtp
 0FieHjyDD9iKTHPvqnNUb621SKp7UDXyRAazb+Spr7Nh19VYRRVLMfWNzNaFoa7w29FbH4J
 3NZm9RMxBMJWQXMX6c3LQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-08 at 21:26 -0600, David Ahern wrote: 
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

You cured some annoying lost chunks too.

master (cache is hot in target tip tree)

[ perf record: Woken up 0 times to write data ]
[ perf record: Captured and wrote 1398.520 MB perf.data (~61102281 samples) ]
Warning:
Processed 15894046 events and lost 15 chunks!

Check IO/CPU overload!


 Performance counter stats for 'sh -c cd /usr/local/src/kernel/linux-3.x-tip/tools/perf; make clean; perf record -a -e raw_syscalls:* -- make -j4':

      90405.531301 task-clock                #    2.580 CPUs utilized          
             18433 context-switches          #    0.204 K/sec                  
              1503 cpu-migrations            #    0.017 K/sec                  
           2543758 page-faults               #    0.028 M/sec                  
      214649052820 cycles                    #    2.374 GHz                     [50.40%]
   <not supported> stalled-cycles-frontend 
   <not supported> stalled-cycles-backend  
      201026412643 instructions              #    0.94  insns per cycle         [75.48%]
       41960433084 branches                  #  464.136 M/sec                   [75.22%]
        1835477524 branch-misses             #    4.37% of all branches         [75.13%]

      35.039394045 seconds time elapsed


patched master
marge:/usr/local/src/kernel/linux-3.x.git/tools/perf # export PERF=`pwd`/perf

[ perf record: Woken up 1070 times to write data ]
[ perf record: Captured and wrote 269.060 MB perf.data (~11755404 samples) ]

 Performance counter stats for 'sh -c cd /usr/local/src/kernel/linux-3.x-tip/tools/perf; make clean; $PERF record -a -e raw_syscalls:* -- make -j4':

      67553.069792 task-clock                #    2.934 CPUs utilized          
             16183 context-switches          #    0.240 K/sec                  
               880 cpu-migrations            #    0.013 K/sec                  
           2253888 page-faults               #    0.033 M/sec                  
      159940676657 cycles                    #    2.368 GHz                     [50.20%]
   <not supported> stalled-cycles-frontend 
   <not supported> stalled-cycles-backend  
      152420909413 instructions              #    0.95  insns per cycle         [75.39%]
       32857102452 branches                  #  486.389 M/sec                   [75.58%]
        1674403244 branch-misses             #    5.10% of all branches         [75.15%]

      23.020412569 seconds time elapsed

