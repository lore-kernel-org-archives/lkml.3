Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935599Ab3BOHpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 02:45:45 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55924 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935514Ab3BOHpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 02:45:44 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-20-511de7a20fa6
Date: Fri, 15 Feb 2013 16:45:38 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Clark Williams <clark@redhat.com>,
        Andrew Theurer <habanero@us.ibm.com>
Subject: Re: [RFC] sched: The removal of idle_balance()
Message-ID: <20130215074538.GA25845@lge.com>
References: <1360908819.23152.97.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360908819.23152.97.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Steven.

On Fri, Feb 15, 2013 at 01:13:39AM -0500, Steven Rostedt wrote:

>  Performance counter stats for '/work/c/hackbench 500' (100 runs):
> 
>      199820.045583 task-clock                #    8.016 CPUs utilized            ( +-  5.29% ) [100.00%]
>          3,594,264 context-switches          #    0.018 M/sec                    ( +-  5.94% ) [100.00%]
>            352,240 cpu-migrations            #    0.002 M/sec                    ( +-  3.31% ) [100.00%]
>          1,006,732 page-faults               #    0.005 M/sec                    ( +-  0.56% )
>    293,801,912,874 cycles                    #    1.470 GHz                      ( +-  4.20% ) [100.00%]
>    261,808,125,109 stalled-cycles-frontend   #   89.11% frontend cycles idle     ( +-  4.38% ) [100.00%]
>    <not supported> stalled-cycles-backend  
>    135,521,344,089 instructions              #    0.46  insns per cycle        
>                                              #    1.93  stalled cycles per insn  ( +-  4.37% ) [100.00%]
>     26,198,116,586 branches                  #  131.109 M/sec                    ( +-  4.59% ) [100.00%]
>        115,326,812 branch-misses             #    0.44% of all branches          ( +-  4.12% )
> 
>       24.929136087 seconds time elapsed                                          ( +-  5.31% )
> 
>  Performance counter stats for '/work/c/hackbench 500' (100 runs):
> 
>       98258.962617 task-clock                #    7.998 CPUs utilized            ( +- 12.12% ) [100.00%]
>          2,572,651 context-switches          #    0.026 M/sec                    ( +-  9.35% ) [100.00%]
>            224,004 cpu-migrations            #    0.002 M/sec                    ( +-  5.01% ) [100.00%]
>            913,813 page-faults               #    0.009 M/sec                    ( +-  0.71% )
>    215,927,081,108 cycles                    #    2.198 GHz                      ( +-  5.48% ) [100.00%]
>    189,246,626,321 stalled-cycles-frontend   #   87.64% frontend cycles idle     ( +-  6.07% ) [100.00%]
>    <not supported> stalled-cycles-backend  
>    102,965,954,824 instructions              #    0.48  insns per cycle        
>                                              #    1.84  stalled cycles per insn  ( +-  5.40% ) [100.00%]
>     19,280,914,558 branches                  #  196.226 M/sec                    ( +-  5.89% ) [100.00%]
>         87,284,617 branch-misses             #    0.45% of all branches          ( +-  5.06% )
> 
>       12.285025160 seconds time elapsed                                          ( +- 12.14% )

IMHO, cycles is somewhat strange.
Why one is 1.470 GHz, other is 2.198 GHz? 

In my quick test, I get below result.

- Before Patch
Permance counter stats for 'perf bench sched messaging -g 300' (10 runs):

      40847.488740 task-clock                #    3.232 CPUs utilized            ( +-  1.24% )
           511,070 context-switches          #    0.013 M/sec                    ( +-  7.28% )
           117,882 cpu-migrations            #    0.003 M/sec                    ( +-  5.14% )
         1,360,501 page-faults               #    0.033 M/sec                    ( +-  0.12% )
   118,534,394,180 cycles                    #    2.902 GHz                      ( +-  1.23% ) [50.70%]
   <not supported> stalled-cycles-frontend 
   <not supported> stalled-cycles-backend  
    46,217,340,271 instructions              #    0.39  insns per cycle          ( +-  0.56% ) [76.93%]
     8,592,447,548 branches                  #  210.354 M/sec                    ( +-  0.75% ) [75.50%]
       273,367,481 branch-misses             #    3.18% of all branches          ( +-  0.26% ) [75.49%]

      12.639049245 seconds time elapsed                                          ( +-  2.29% )

- After Patch
 Performance counter stats for 'perf bench sched messaging -g 300' (10 runs):

      42053.008632 task-clock                #    2.932 CPUs utilized            ( +-  0.91% )
           672,759 context-switches          #    0.016 M/sec                    ( +-  2.76% )
            83,374 cpu-migrations            #    0.002 M/sec                    ( +-  4.46% )
         1,362,900 page-faults               #    0.032 M/sec                    ( +-  0.20% )
   121,457,601,848 cycles                    #    2.888 GHz                      ( +-  0.93% ) [50.75%]
   <not supported> stalled-cycles-frontend 
   <not supported> stalled-cycles-backend  
    47,854,828,552 instructions              #    0.39  insns per cycle          ( +-  0.36% ) [77.09%]
     8,981,553,714 branches                  #  213.577 M/sec                    ( +-  0.42% ) [75.41%]
       274,229,438 branch-misses             #    3.05% of all branches          ( +-  0.20% ) [75.44%]

      14.340330678 seconds time elapsed                                          ( +-  1.79% )

Thanks.
