Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab3GAW2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:28:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36431 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808Ab3GAW2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:28:11 -0400
Date: Tue, 2 Jul 2013 00:28:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: Use asm-goto to implement mutex fast path on x86-64
Message-ID: <20130701222802.GK23515@pd.tnic>
References: <20130628111948.GA31065@gmail.com>
 <20130628140938.GA24819@pd.tnic>
 <CANeycqpiXO-B1+f-OXZfHaxxPd2aVEL0kutFp6-sALHqXNrazQ@mail.gmail.com>
 <20130630220004.GA23124@pd.tnic>
 <20130701075046.GB1681@gmail.com>
 <20130701102306.GC23515@pd.tnic>
 <20130701111122.GA18772@gmail.com>
 <20130701122954.GD23515@pd.tnic>
 <20130701125045.GA24336@gmail.com>
 <20130701144851.GH23515@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130701144851.GH23515@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 04:48:51PM +0200, Borislav Petkov wrote:
> And yes, this way we don't see the speedup - numbers are almost the
> same. Now on to find out why do I see a speedup with my way of running
> the trace.

Ok, I think I know what happens:

When I do:

perf stat --repeat 10 -a --sync --pre 'make -s clean; echo 1 > /proc/sys/vm/drop_caches' make -s -j64 bzImage

I get:

 Performance counter stats for 'make -s -j64 bzImage' (10 runs):

     961485.910628 task-clock                #    7.996 CPUs utilized            ( +-  0.13% ) [100.00%]
           603,572 context-switches          #    0.628 K/sec                    ( +-  0.30% ) [100.00%]
            33,044 cpu-migrations            #    0.034 K/sec                    ( +-  0.42% ) [100.00%]
        25,450,364 page-faults               #    0.026 M/sec                    ( +-  0.00% )
 3,143,626,158,370 cycles                    #    3.270 GHz                      ( +-  0.12% ) [83.38%]
 2,405,039,723,306 stalled-cycles-frontend   #   76.51% frontend cycles idle     ( +-  0.09% ) [83.25%]
 1,844,508,780,556 stalled-cycles-backend    #   58.67% backend  cycles idle     ( +-  0.19% ) [66.75%]
 1,799,457,879,494 instructions              #    0.57  insns per cycle
                                             #    1.34  stalled cycles per insn  ( +-  0.15% ) [83.36%]
   403,458,465,170 branches                  #  419.620 M/sec                    ( +-  0.06% ) [83.38%]
    17,545,329,408 branch-misses             #    4.35% of all branches          ( +-  0.11% ) [83.25%]

     120.239128672 seconds time elapsed                                          ( +-  0.13% )


VS when I do

perf stat --repeat 10 -a --sync ../build-kernel.sh

where the script contains the same commands:

$ cat ../build-kernel.sh
#!/bin/bash

make -s clean
echo 1 > /proc/sys/vm/drop_caches
make -s -j64 bzImage
$

I get:

 Performance counter stats for '../build-kernel.sh' (10 runs):

    1032358.179282 task-clock                #    7.996 CPUs utilized            ( +-  0.09% ) [100.00%]
           635,967 context-switches          #    0.616 K/sec                    ( +-  0.15% ) [100.00%]
            37,220 cpu-migrations            #    0.036 K/sec                    ( +-  0.27% ) [100.00%]
        26,005,286 page-faults               #    0.025 M/sec                    ( +-  0.00% )
 3,164,022,396,373 cycles                    #    3.065 GHz                      ( +-  0.10% ) [83.37%]
 2,434,722,583,577 stalled-cycles-frontend   #   76.95% frontend cycles idle     ( +-  0.11% ) [83.34%]
 1,865,760,946,076 stalled-cycles-backend    #   58.97% backend  cycles idle     ( +-  0.18% ) [66.76%]
 1,810,237,888,844 instructions              #    0.57  insns per cycle
                                             #    1.34  stalled cycles per insn  ( +-  0.10% ) [83.40%]
   406,259,324,254 branches                  #  393.526 M/sec                    ( +-  0.12% ) [83.32%]
    17,610,395,405 branch-misses             #    4.33% of all branches          ( +-  0.09% ) [83.21%]

     129.102139999 seconds time elapsed                                          ( +-  0.09% )

The difference is, in the second case, we're tracing those two also:

make -s clean
echo 1 > /proc/sys/vm/drop_caches

which could be responsible for the variance in timings. I'll run those
tomorrow to confirm.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
