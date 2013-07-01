Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab3GAOtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:49:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54646 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab3GAOs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:48:59 -0400
Date: Mon, 1 Jul 2013 16:48:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: Use asm-goto to implement mutex fast path on x86-64
Message-ID: <20130701144851.GH23515@pd.tnic>
References: <1372416851-56830-1-git-send-email-wedsonaf@gmail.com>
 <20130628111948.GA31065@gmail.com>
 <20130628140938.GA24819@pd.tnic>
 <CANeycqpiXO-B1+f-OXZfHaxxPd2aVEL0kutFp6-sALHqXNrazQ@mail.gmail.com>
 <20130630220004.GA23124@pd.tnic>
 <20130701075046.GB1681@gmail.com>
 <20130701102306.GC23515@pd.tnic>
 <20130701111122.GA18772@gmail.com>
 <20130701122954.GD23515@pd.tnic>
 <20130701125045.GA24336@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130701125045.GA24336@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 02:50:46PM +0200, Ingo Molnar wrote:
> > Yep, I didn't run -a since I wanted to trace only the build process.
> > Btw, the build-kernel.sh script looks like this:
> > 
> > #!/bin/bash
> > 
> > NUM_CPUS=$(cat /proc/cpuinfo | grep processor | wc -l)
> > MAKE_OPTS=-j$(($NUM_CPUS+1))
> > 
> > echo 3 > /proc/sys/vm/drop_caches
> > make $MAKE_OPTS mrproper
> > make $MAKE_OPTS oldconfig
> > make $MAKE_OPTS
> > <EOF>
> > 
> > Let me try your perf tracing variant.

Ok, I removed the output directory to your trace command because it was
complaining about .config missing even if I put it both in the source
tree and in defconfig-build/ so I ended up with:

perf stat --repeat 10 -a --sync --pre 'make -s clean; echo 1 > /proc/sys/vm/drop_caches' make -s -j64 bzImage

which should be basically the same.

And yes, this way we don't see the speedup - numbers are almost the
same. Now on to find out why do I see a speedup with my way of running
the trace.

plain 3.10
==========

 Performance counter stats for 'make -s -j64 bzImage' (10 runs):

     960155.777354 task-clock                #    7.996 CPUs utilized            ( +-  0.13% ) [100.00%]
           600,993 context-switches          #    0.626 K/sec                    ( +-  0.29% ) [100.00%]
            32,764 cpu-migrations            #    0.034 K/sec                    ( +-  0.40% ) [100.00%]
        25,449,932 page-faults               #    0.027 M/sec                    ( +-  0.00% )
 3,146,429,834,505 cycles                    #    3.277 GHz                      ( +-  0.12% ) [83.27%]
 2,402,804,186,892 stalled-cycles-frontend   #   76.37% frontend cycles idle     ( +-  0.10% ) [83.30%]
 1,844,806,444,182 stalled-cycles-backend    #   58.63% backend  cycles idle     ( +-  0.16% ) [66.61%]
 1,801,184,009,281 instructions              #    0.57  insns per cycle
                                             #    1.33  stalled cycles per insn  ( +-  0.15% ) [83.27%]
   402,482,696,262 branches                  #  419.185 M/sec                    ( +-  0.04% ) [83.58%]
    17,550,736,725 branch-misses             #    4.36% of all branches          ( +-  0.09% ) [83.25%]

     120.072676076 seconds time elapsed                                          ( +-  0.13% )

+ patch
=======

 Performance counter stats for 'make -s -j64 bzImage' (10 runs):

     960212.466648 task-clock                #    7.996 CPUs utilized            ( +-  0.11% ) [100.00%]
           600,078 context-switches          #    0.625 K/sec                    ( +-  0.23% ) [100.00%]
            32,708 cpu-migrations            #    0.034 K/sec                    ( +-  0.51% ) [100.00%]
        25,450,046 page-faults               #    0.027 M/sec                    ( +-  0.00% )
 3,141,378,247,404 cycles                    #    3.272 GHz                      ( +-  0.09% ) [83.32%]
 2,398,997,896,542 stalled-cycles-frontend   #   76.37% frontend cycles idle     ( +-  0.16% ) [83.39%]
 1,841,987,157,784 stalled-cycles-backend    #   58.64% backend  cycles idle     ( +-  0.19% ) [66.70%]
 1,798,363,791,924 instructions              #    0.57  insns per cycle
                                             #    1.33  stalled cycles per insn  ( +-  0.12% ) [83.39%]
   403,257,285,840 branches                  #  419.967 M/sec                    ( +-  0.07% ) [83.39%]
    17,552,193,349 branch-misses             #    4.35% of all branches          ( +-  0.07% ) [83.20%]

     120.079804432 seconds time elapsed                                          ( +-  0.11% )

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
