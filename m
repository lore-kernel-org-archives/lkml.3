Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab3HCPq3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 11:46:29 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:57244 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3HCPq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 11:46:28 -0400
Date: Sat, 3 Aug 2013 17:46:22 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Kevin Hilman <khilman@linaro.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [GIT PULL] nohz patches for 3.12 preview v3
Message-ID: <20130803154619.GA26307@somewhere>
References: <1375317100-20651-1-git-send-email-fweisbec@gmail.com>
 <20130801082959.GJ3008@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801082959.GJ3008@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 10:29:59AM +0200, Peter Zijlstra wrote:
> On Thu, Aug 01, 2013 at 02:31:17AM +0200, Frederic Weisbecker wrote:
> > Hi,
> > 
> > So none of the patches from the previous v2 posting have changed.
> > I've just added two more in order to fix build crashes reported
> > by Wu Fengguang:
> > 
> >       hardirq: Split preempt count mask definitions
> >       m68k: hardirq_count() only need preempt_mask.h
> > 
> > If no comment arise, I'll send a pull request to Ingo in a few days.
> 
> So I did a drive-by review and didn't spot anything really weird.
> 
> However, it would be very good to include some performance figures that
> show what effect all this effort had.
> 
> I'm assuming its good (TM) ;-)

Thanks for your review :)

So here are a few benchmarks, those have been generated with 50 loops of hackbench
in perf stat:

   perf stat -r 50 hackbench

Be careful with the results because my machine is not the best for such testing. It generates sometimes
profiles that contradict altogether. There is sometimes non-deterministic behaviour out there.
But still the following results reveal some coherent tendencies.

So lets first compare the full dynticks dynamic off-case (full dynticks built but no cpu in full dynticks range)
before and after the patchset.

* Before patchset, NO_HZ_FULL=y but no CPUs defined in the full dynticks range

 Performance counter stats for './hackbench' (50 runs):

       2085,711227 task-clock                #    3,665 CPUs utilized            ( +-  0,20% )
            17 150 context-switches          #    0,008 M/sec                    ( +-  2,63% )
             2 787 cpu-migrations            #    0,001 M/sec                    ( +-  3,73% )
            24 642 page-faults               #    0,012 M/sec                    ( +-  0,13% )
     4 570 011 562 cycles                    #    2,191 GHz                      ( +-  0,27% ) [69,39%]
       615 260 904 stalled-cycles-frontend   #   13,46% frontend cycles idle     ( +-  0,41% ) [69,37%]
     2 858 928 434 stalled-cycles-backend    #   62,56% backend  cycles idle     ( +-  0,29% ) [69,44%]
     1 886 501 443 instructions              #    0,41  insns per cycle        
                                             #    1,52  stalled cycles per insn  ( +-  0,21% ) [69,46%]
       321 845 039 branches                  #  154,309 M/sec                    ( +-  0,27% ) [69,38%]
         8 086 056 branch-misses             #    2,51% of all branches          ( +-  0,40% ) [69,37%]

       0,569151871 seconds time elapsed


* After patchset, NO_HZ_FULL=y but no CPUs defined in the full dynticks range:

 Performance counter stats for './hackbench' (50 runs):

       1832,559228 task-clock                #    3,630 CPUs utilized            ( +-  0,88% )
            18 284 context-switches          #    0,010 M/sec                    ( +-  2,70% )
             2 877 cpu-migrations            #    0,002 M/sec                    ( +-  3,57% )
            24 643 page-faults               #    0,013 M/sec                    ( +-  0,12% )
     3 997 096 098 cycles                    #    2,181 GHz                      ( +-  0,94% ) [69,60%]
       497 409 356 stalled-cycles-frontend   #   12,44% frontend cycles idle     ( +-  0,45% ) [69,59%]
     2 828 069 690 stalled-cycles-backend    #   70,75% backend  cycles idle     ( +-  0,61% ) [69,69%]
     1 195 418 817 instructions              #    0,30  insns per cycle        
                                             #    2,37  stalled cycles per insn  ( +-  2,27% ) [69,75%]
       217 876 716 branches                  #  118,892 M/sec                    ( +-  3,13% ) [69,79%]
         5 895 622 branch-misses             #    2,71% of all branches          ( +-  0,44% ) [69,65%]

       0,504899242 seconds time elapsed


Looking at the time elapsed, it's a rough difference of 11% performance gain after the patchset.


Now lets compare static full dynticks off case (NO_HZ_FULL=n) and dynamic full dynticks off case (NO_HZ_FULL=y
but no CPU in "nohz_full=" boot option (namely the above former profile), all after the patchset:

* After patchset, CONFIG_NO_HZ=n, CONFIG_RCU_NOCBS=n, CONFIG_CPU_ACCOUNTING_TICK=y, CONFIG_RCU_USER_QS=n:
  a classical dynticks idle kernel.

 Performance counter stats for './hackbench' (50 runs):

       1784,878581 task-clock                #    3,595 CPUs utilized            ( +-  0,26% )
            18 130 context-switches          #    0,010 M/sec                    ( +-  2,52% )
             2 850 cpu-migrations            #    0,002 M/sec                    ( +-  3,15% )
            24 683 page-faults               #    0,014 M/sec                    ( +-  0,11% )
     3 899 468 529 cycles                    #    2,185 GHz                      ( +-  0,31% ) [69,63%]
       476 759 654 stalled-cycles-frontend   #   12,23% frontend cycles idle     ( +-  0,59% ) [69,58%]
     2 789 090 317 stalled-cycles-backend    #   71,52% backend  cycles idle     ( +-  0,35% ) [69,51%]
     1 156 184 197 instructions              #    0,30  insns per cycle        
                                             #    2,41  stalled cycles per insn  ( +-  0,19% ) [69,54%]
       207 501 450 branches                  #  116,255 M/sec                    ( +-  0,21% ) [69,66%]
         5 029 776 branch-misses             #    2,42% of all branches          ( +-  0,32% ) [69,69%]

       0,496525053 seconds time elapsed


Compared to the dynamic off case above, it's 0.496525053 VS 0.504899242. Roughly 1.6 % performance loss.

To conclude, the patchset improves the current upstream situation a lot in any case (11% better for the dynamic off case).

But even after this patchset, there is still some work to do if we want to make full dynticks dynamic off case near invisible
compared to a dyntick idle kernel. ie: we need to remove that 1.6% performance loss. Now this seem to be some good progress
toward that direction.

Thanks.
