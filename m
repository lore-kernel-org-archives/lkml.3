Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab3JCSMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:12:06 -0400
Received: from mail-ye0-f179.google.com ([209.85.213.179]:60335 "EHLO
	mail-ye0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab3JCSME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:12:04 -0400
Message-ID: <524DB377.2070909@gmail.com>
Date: Thu, 03 Oct 2013 14:12:07 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Kernel mailing list <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@redhat.com>
Subject: Re: [PATCH 1/1] x86_64: add config options to optimize for newer
 AMD processors
References: <52486938.4090009@gmail.com> <20130929180101.GB5490@pd.tnic> <5248905E.8000801@gmail.com> <20130929205051.GD5426@pd.tnic> <52489A59.7040108@gmail.com> <20130929213026.GF5426@pd.tnic> <524D5DAC.3000004@gmail.com> <CA+55aFwuV4u3ky-XT_P_sCOYjqUW1EvA3Q2NuZ=+LZ5O06jS3g@mail.gmail.com> <20131003165740.GA17417@pd.tnic>
In-Reply-To: <20131003165740.GA17417@pd.tnic>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-10-03 12:57, Borislav Petkov wrote:> On Thu, Oct 03, 2013 at 09:27:45AM -0700, Linus Torvalds wrote:
>> On Thu, Oct 3, 2013 at 5:06 AM, Austin S Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>> improved.  Building kernel 3.12-rc2 with allmodconfig using 8 jobs on a FX-8320 takes
>>>
>>> 22 minutes and 57 seconds on a kernel with CONFIG_MK8,
>>> 21 minutes and 35 seconds on a kernel with CONFIG_GENERIC, and
>>> 19 minutes and 11 seconds on a kernel with CONFIG_PILEDRIVER.
>>
>> That's certainly noticeable. Surprisingly so. What makes MK8 so bad in
>> particular, I wonder?
>>
>> Just out of interest, have you done any profiles on the kernel cost
>> here to see what it is that makes such a big difference. Because
>> normally on a kernel build, I see most of the overhead in path lookup.
>> But that's only true for otherwise optimized builds that don't have
>> system call auditing etc debugging that spreads the costs out over
>> everything..
> 
> Yeah, I was having some doubts about the numbers above so I ran my own
> benchmarking, machine is a Piledriver box:
> 
> vendor_id       : AuthenticAMD
> cpu family      : 21
> model           : 2
> model name      : AMD FX(tm)-8350 Eight-Core Processor
> stepping        : 0
> 
> and I don't really see any of those improvements above. Actually,
> -march=bdver2 is even slightly worse in comparison to mk8.
> 
> And the workload is of building a config specific to that machine but
> allmodconfig looks very similar, the numbers being simply higher.
> 
> $ zgrep MK8 /proc/config.gz
> CONFIG_MK8=y
> 
> /home/boris/bin/perf stat --repeat 10 -a --sync --pre /home/boris/kernel/pre-build-kernel.sh make -s -j64 bzImage
> 
>  Performance counter stats for 'make -s -j64 bzImage' (10 runs):
> 
>     1081808.628840 task-clock                #    7.996 CPUs utilized            ( +-  0.06% ) [100.00%]
>          1,203,753 context-switches          #    0.001 M/sec                    ( +-  0.04% ) [100.00%]
>             48,748 cpu-migrations            #    0.045 K/sec                    ( +-  0.59% ) [100.00%]
>         31,145,439 page-faults               #    0.029 M/sec                    ( +-  0.00% )
>  3,836,736,801,500 cycles                    #    3.547 GHz                      ( +-  0.03% ) [100.00%]
>    957,386,966,493 stalled-cycles-frontend   #   24.95% frontend cycles idle     ( +-  0.06% ) [100.00%]
>    218,581,249,251 stalled-cycles-backend    #    5.70% backend  cycles idle     ( +-  0.06% ) [100.00%]
>  2,466,632,641,972 instructions              #    0.64  insns per cycle
>                                              #    0.39  stalled cycles per insn  ( +-  0.00% ) [100.00%]
>    537,749,333,838 branches                  #  497.084 M/sec                    ( +-  0.00% ) [100.00%]
>     27,802,940,176 branch-misses             #    5.17% of all branches          ( +-  0.00% )
> 
>      135.292843025 seconds time elapsed                                          ( +-  0.06% )
> 
> 
> $ zgrep PILEDRIVER /proc/config.gz
> CONFIG_MPILEDRIVER=y
> 
> /home/boris/bin/perf stat --repeat 10 -a --sync --pre /home/boris/kernel/pre-build-kernel.sh make -s -j64 bzImage
> 
>  Performance counter stats for 'make -s -j64 bzImage' (10 runs):
> 
>     1085723.230470 task-clock                #    7.996 CPUs utilized            ( +-  0.10% ) [100.00%]
>          1,204,355 context-switches          #    0.001 M/sec                    ( +-  0.10% ) [100.00%]
>             49,143 cpu-migrations            #    0.045 K/sec                    ( +-  0.76% ) [100.00%]
>         31,196,575 page-faults               #    0.029 M/sec                    ( +-  0.00% )
>  3,851,255,065,133 cycles                    #    3.547 GHz                      ( +-  0.02% ) [100.00%]
>    958,840,197,117 stalled-cycles-frontend   #   24.90% frontend cycles idle     ( +-  0.09% ) [100.00%]
>    220,260,399,411 stalled-cycles-backend    #    5.72% backend  cycles idle     ( +-  0.04% ) [100.00%]
>  2,466,701,295,156 instructions              #    0.64  insns per cycle
>                                              #    0.39  stalled cycles per insn  ( +-  0.00% ) [100.00%]
>    537,992,040,195 branches                  #  495.515 M/sec                    ( +-  0.00% ) [100.00%]
>     27,860,290,286 branch-misses             #    5.18% of all branches          ( +-  0.00% )
> 
>      135.784111961 seconds time elapsed                                          ( +-  0.10% )
> 

Part of the difference between our results may be that I have my entire userspace built with -mtune=bdver2, so less of the time is spent in userspace.  Also, the part about using many more threads than cpu cores was with regards to sysbench, not the kernel build, for that I just used 8 jobs in make.

With regards to the differences shown above relative to CONFIG_MK8, that does actually make sense; with CONFIG_MK8, gcc makes very minimal use of extension instructions (afaik, only MMX, SSE, and 3Dnow!), this improves performance slightly on bulldozer derivatives because there are only half as many SSE and FP units as CPU cores (and the scheduler isn't as smart as it could be with regards to that, but that is something for another patch as far as I am concerned).


