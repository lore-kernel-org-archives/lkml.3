Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648Ab3GBK3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 06:29:23 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48226 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755709Ab3GBK3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 06:29:21 -0400
Date: Tue, 2 Jul 2013 12:29:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: Use asm-goto to implement mutex fast path on x86-64
Message-ID: <20130702102918.GE4535@pd.tnic>
References: <20130701075046.GB1681@gmail.com>
 <20130701102306.GC23515@pd.tnic>
 <20130701111122.GA18772@gmail.com>
 <20130701122954.GD23515@pd.tnic>
 <20130701125045.GA24336@gmail.com>
 <20130701144851.GH23515@pd.tnic>
 <20130701222802.GK23515@pd.tnic>
 <CANeycqoq8LwLMoXEYdPE6m9eKVB7pRLw1hkSCjJ=jjDj9ej-Cw@mail.gmail.com>
 <20130701224421.GL23515@pd.tnic>
 <20130702063912.GA3143@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130702063912.GA3143@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 08:39:12AM +0200, Ingo Molnar wrote:
> Yeah - I didn't know your CPU count, -j64 is what I use.

Right, but the -j make jobs argument - whenever it is higher than the
core count - shouldn't matter too much to the workload because all those
threads remain runnable but simply wait to get a shot to run.

Maybe the overhead of setting up threads which are more than necessary
could be of issue although those measurements didn't show that. It
actually showed that -j64 build is a second faster on the average than
-j(core_count+1).

> Also, just in case it wasn't clear: thanks for the measurements

I thank you guys for listening - it is so much fun playing with this! :)

> - and I'd be in favor of merging this patch if it shows any
> improvement or if measurements lie within noise, because per asm
> review the change should be a win.

Right, so we can say for sure that machine utilization drops a bit:

+ 600,993 context-switches
- 600,078 context-switches

- 3,146,429,834,505 cycles
+ 3,141,378,247,404 cycles

- 2,402,804,186,892 stalled-cycles-frontend
+ 2,398,997,896,542 stalled-cycles-frontend

- 1,844,806,444,182 stalled-cycles-backend
+ 1,841,987,157,784 stalled-cycles-backend

- 1,801,184,009,281 instructions
+ 1,798,363,791,924 instructions

and a couple more.

Considering the simple change, this is clearly a win albeit a small one.

Disadvantages:

- 25,449,932 page-faults
+ 25,450,046 page-faults

- 402,482,696,262 branches
+ 403,257,285,840 branches

- 17,550,736,725 branch-misses
+ 17,552,193,349 branch-misses

It looks to me like this way we're a wee bit less predictable to the
machine but it seems it recovers at some point. Again, considering it
doesn't hurt runtime or some other aspect more gravely, we can accept
them.

The moral of the story: never ever use prerequisite stuff like

echo <N> > .../drop_caches

in the to-be-traced workload because it lies to ya:

$ cat ../build-kernel.sh
#!/bin/bash

make -s clean
echo 1 > /proc/sys/vm/drop_caches

$ perf stat --repeat 10 -a --sync --pre '../build-kernel.sh' make -s -j64 bzImage

 Performance counter stats for 'make -s -j64 bzImage' (10 runs):

     960601.373972 task-clock                #    7.996 CPUs utilized            ( +-  0.19% ) [100.00%]
           601,511 context-switches          #    0.626 K/sec                    ( +-  0.16% ) [100.00%]
            32,780 cpu-migrations            #    0.034 K/sec                    ( +-  0.31% ) [100.00%]
        25,449,646 page-faults               #    0.026 M/sec                    ( +-  0.00% )
 3,142,081,058,378 cycles                    #    3.271 GHz                      ( +-  0.11% ) [83.40%]
 2,401,261,614,189 stalled-cycles-frontend   #   76.42% frontend cycles idle     ( +-  0.08% ) [83.39%]
 1,845,047,843,816 stalled-cycles-backend    #   58.72% backend  cycles idle     ( +-  0.14% ) [66.65%]
 1,797,566,509,722 instructions              #    0.57  insns per cycle
                                             #    1.34  stalled cycles per insn  ( +-  0.10% ) [83.43%]
   403,531,133,058 branches                  #  420.082 M/sec                    ( +-  0.09% ) [83.37%]
    17,562,347,910 branch-misses             #    4.35% of all branches          ( +-  0.10% ) [83.20%]

     120.128371521 seconds time elapsed                                          ( +-  0.19% )


VS


$ cat ../build-kernel.sh
#!/bin/bash

make -s clean
echo 1 > /proc/sys/vm/drop_caches
make -s -j64 bzImage


$ perf stat --repeat 10 -a --sync ../build-kernel.sh

 Performance counter stats for '../build-kernel.sh' (10 runs):

    1032946.552711 task-clock                #    7.996 CPUs utilized            ( +-  0.09% ) [100.00%]
           636,651 context-switches          #    0.616 K/sec                    ( +-  0.13% ) [100.00%]
            37,443 cpu-migrations            #    0.036 K/sec                    ( +-  0.31% ) [100.00%]
        26,005,318 page-faults               #    0.025 M/sec                    ( +-  0.00% )
 3,164,715,146,894 cycles                    #    3.064 GHz                      ( +-  0.10% ) [83.38%]
 2,436,459,399,308 stalled-cycles-frontend   #   76.99% frontend cycles idle     ( +-  0.10% ) [83.35%]
 1,877,644,323,184 stalled-cycles-backend    #   59.33% backend  cycles idle     ( +-  0.20% ) [66.52%]
 1,815,075,000,778 instructions              #    0.57  insns per cycle
                                             #    1.34  stalled cycles per insn  ( +-  0.09% ) [83.19%]
   406,020,700,850 branches                  #  393.070 M/sec                    ( +-  0.07% ) [83.40%]
    17,578,808,228 branch-misses             #    4.33% of all branches          ( +-  0.12% ) [83.35%]

     129.176026516 seconds time elapsed                                          ( +-  0.09% )


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
