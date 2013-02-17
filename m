Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab3BQG0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 01:26:16 -0500
Received: from mout.gmx.net ([212.227.17.21]:59834 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856Ab3BQG0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 01:26:15 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+SFGlL/jWS9LxSIiA7oz4lGmA+nKR1XzGL8slRu/
	q+oFT6nwUL12cp
Message-ID: <1361082363.6088.21.camel@marge.simpson.net>
Subject: Re: [RFC] sched: The removal of idle_balance()
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Clark Williams <clark@redhat.com>,
        Andrew Theurer <habanero@us.ibm.com>
Date: Sun, 17 Feb 2013 07:26:03 +0100
In-Reply-To: <1361031150.23152.133.camel@gandalf.local.home>
References: <1360908819.23152.97.camel@gandalf.local.home>
	 <1360913172.4736.20.camel@marge.simpson.net>
	 <1361031150.23152.133.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-02-16 at 11:12 -0500, Steven Rostedt wrote:
> On Fri, 2013-02-15 at 08:26 +0100, Mike Galbraith wrote:
> > On Fri, 2013-02-15 at 01:13 -0500, Steven Rostedt wrote:
> > 
> > > Think about it some more, just because we go idle isn't enough reason to
> > > pull a runable task over. CPUs go idle all the time, and tasks are woken
> > > up all the time. There's no reason that we can't just wait for the sched
> > > tick to decide its time to do a bit of balancing. Sure, it would be nice
> > > if the idle CPU did the work. But I think that frame of mind was an
> > > incorrect notion from back in the early 2000s and does not apply to
> > > today's hardware, or perhaps it doesn't apply to the (relatively) new
> > > CFS scheduler. If you want aggressive scheduling, make the task rt, and
> > > it will do aggressive scheduling.
> > 
> > (the throttle is supposed to keep idle_balance() from doing severe
> > damage, that may want a peek/tweak)
> > 
> > Hackbench spreads itself with FORK/EXEC balancing, how does say a kbuild
> > do with no idle_balance()?
> > 
> 
> Interesting, I added this patch and it brought down my hackbench to the
> same level as removing idle_balance().

The typo did it's job well :)

Hrm, turning idle balancing off here does not help hackbench at all.

3.8.0-master

Q6600 +SD_BALANCE_NEWIDLE
 Performance counter stats for 'hackbench -l 500' (100 runs):

       5221.559519 task-clock                #    4.001 CPUs utilized            ( +-  0.26% ) [100.00%]
            129863 context-switches          #    0.025 M/sec                    ( +-  3.65% ) [100.00%]
              7576 cpu-migrations            #    0.001 M/sec                    ( +-  4.60% ) [100.00%]
             31095 page-faults               #    0.006 M/sec                    ( +-  0.39% )
       12258227539 cycles                    #    2.348 GHz                      ( +-  0.27% ) [49.91%]
   <not supported> stalled-cycles-frontend 
   <not supported> stalled-cycles-backend  
        5395089628 instructions              #    0.44  insns per cycle          ( +-  0.28% ) [74.99%]
        1012563262 branches                  #  193.920 M/sec                    ( +-  0.28% ) [75.08%]
          43217098 branch-misses             #    4.27% of all branches          ( +-  0.23% ) [75.01%]

       1.305024749 seconds time elapsed                                          ( +-  0.26% )

Q6600 -SD_BALANCE_NEWIDLE

 Performance counter stats for 'hackbench -l 500' (100 runs):

       5356.549500 task-clock                #    4.001 CPUs utilized            ( +-  0.37% ) [100.00%]
            153093 context-switches          #    0.029 M/sec                    ( +-  3.20% ) [100.00%]
              6887 cpu-migrations            #    0.001 M/sec                    ( +-  4.65% ) [100.00%]
             31248 page-faults               #    0.006 M/sec                    ( +-  0.48% )
       12141992004 cycles                    #    2.267 GHz                      ( +-  0.30% ) [49.90%]
   <not supported> stalled-cycles-frontend 
   <not supported> stalled-cycles-backend  
        5426436261 instructions              #    0.45  insns per cycle          ( +-  0.22% ) [75.00%]
        1016967893 branches                  #  189.855 M/sec                    ( +-  0.22% ) [75.09%]
          43207200 branch-misses             #    4.25% of all branches          ( +-  0.13% ) [75.01%]

       1.338768889 seconds time elapsed                                          ( +-  0.37% )

E5620+HT +SD_BALANCE_NEWIDLE
 Performance counter stats for 'hackbench -l 500' (100 runs):

       3884.162557 task-clock                #    7.997 CPUs utilized            ( +-  0.14% ) [100.00%]
             97366 context-switches          #    0.025 M/sec                    ( +-  1.68% ) [100.00%]
             12383 CPU-migrations            #    0.003 M/sec                    ( +-  3.29% ) [100.00%]
             30749 page-faults               #    0.008 M/sec                    ( +-  0.13% )
        9377671582 cycles                    #    2.414 GHz                      ( +-  0.11% ) [83.04%]
        6973792586 stalled-cycles-frontend   #   74.37% frontend cycles idle     ( +-  0.15% ) [83.27%]
        2529338603 stalled-cycles-backend    #   26.97% backend  cycles idle     ( +-  0.32% ) [66.93%]
        5214109586 instructions              #    0.56  insns per cycle        
                                             #    1.34  stalled cycles per insn  ( +-  0.07% ) [83.50%]
         984681811 branches                  #  253.512 M/sec                    ( +-  0.07% ) [83.56%]
           7050196 branch-misses             #    0.72% of all branches          ( +-  0.49% ) [83.24%]

       0.485726223 seconds time elapsed                                          ( +-  0.14% )

E5620+HT -SD_BALANCE_NEWIDLE
 Performance counter stats for 'hackbench -l 500' (100 runs):

       4124.204725 task-clock                #    7.996 CPUs utilized            ( +-  0.20% ) [100.00%]
            151292 context-switches          #    0.037 M/sec                    ( +-  1.49% ) [100.00%]
             12504 CPU-migrations            #    0.003 M/sec                    ( +-  2.84% ) [100.00%]
             30685 page-faults               #    0.007 M/sec                    ( +-  0.07% )
        9566938118 cycles                    #    2.320 GHz                      ( +-  0.16% ) [83.09%]
        7483411444 stalled-cycles-frontend   #   78.22% frontend cycles idle     ( +-  0.22% ) [83.21%]
        2848475061 stalled-cycles-backend    #   29.77% backend  cycles idle     ( +-  0.38% ) [66.82%]
        5360541017 instructions              #    0.56  insns per cycle        
                                             #    1.40  stalled cycles per insn  ( +-  0.11% ) [83.48%]
        1011027557 branches                  #  245.145 M/sec                    ( +-  0.11% ) [83.59%]
           7964016 branch-misses             #    0.79% of all branches          ( +-  0.55% ) [83.32%]

       0.515779138 seconds time elapsed                                          ( +-  0.20% )

	-Mike

