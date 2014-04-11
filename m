Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbaDKVjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 17:39:19 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:62714 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbaDKVjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 17:39:17 -0400
Message-ID: <534860FD.3030702@gmail.com>
Date: Fri, 11 Apr 2014 18:39:09 -0300
From: Daniel Bristot de Oliveira <danielbristot@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Clark Williams <williams@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH RT] rwsem: The return of multi-reader PI rwsems
References: <20140409151922.5fa5d999@gandalf.local.home> <20140410094430.56ca9ee1@sluggy.gateway.2wire.net>
In-Reply-To: <20140410094430.56ca9ee1@sluggy.gateway.2wire.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/10/2014 11:44 AM, Clark Williams wrote:
> On Wed, 9 Apr 2014 15:19:22 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
>
>> This patch is built on top of the two other patches that I posted
>> earlier, which should not be as controversial.
>>
>> If you have any benchmark on large machines I would be very happy if
>> you could test this patch against the unpatched version of -rt.
>>
>> Cheers,
>>
>> -- Steve
>>
>
> Steven
>
> I wrote a program named whack_mmap_sem which creates a large (4GB)
> buffer, then creates 2 x ncpus threads that are affined across all the
> available cpus. These threads then randomly write into the buffer,
> which should cause page faults galore.
>
> I then built the following kernel configs:
>
>    vanilla-3.13.15  - no RT patches applied
>    rt-3.12.15       - PREEMPT_RT patchset
>    rt-3.12.15-fixes - PREEMPT_RT + rwsem fixes
>    rt-3.12.15-multi - PREEMPT_RT + rwsem fixes + rwsem-multi patch
>
> My test h/w was a Dell R520 with a 6-core Intel(R) Xeon(R) CPU E5-2430
> 0 @ 2.20GHz (hyperthreaded). So whack_mmap_sem created 24 threads
> which all partied in the 4GB address range.
>
> I ran whack_mmap_sem with the argument -w 100000 which means each
> thread does 100k writes to random locations inside the buffer and then
> did five runs per each kernel. At the end of the run whack_mmap_sem
> prints out the time of the run in microseconds.
>
> The means of each group of five test runs are:
>
>    vanilla.log:  1210117
>         rt.log:  17210953 (14.2 x slower than vanilla)
>   rt-fixes.log:  10062027 (8.3 x slower than vanilla)
>   rt-multi.log:  3179582  (2.x x slower than vanilla)
>

Hi

I ran Clark's test on a machine with 32 CPUs: 2 Sockets, 8 core/socket + HT

On this machine I ran 5 different kernels:

Vanilla:     3.12.15 - Vanilla
RT:          3.12.15 + Preempt-RT 3.12.15-rt25
FIX:         RT + rwsem fixes from rostedt
Multi:       FIX + Multi-reader PI
Multi -FULL: Multi + CONFIG_PREEMPT=y

I ran the test with the same parameters that Clark used, 100 iterations 
for each kernel. For each kernel I measure the min and max execution 
time, along with the avg execution time and the standard deviation.

The result was:

+-------+---------+----------+----------+-----------+-------------+
|       | Vanilla |    RT    |    FIX   |   Multi   | Multi -FULL |
--------+---------+----------+----------+-----------+-------------+
|MIN:   | 3806754 |  6092939 |  6324665 |   2633614 |     3867240 |
|AVG:   | 3875201 |  8162832 |  8007934 |   2736253 |     3961607 |
|MAX:   | 4062205 | 10951416 | 10574212 |   2972458 |     4139297 |
|STDEV: |   47645 |   927839 |   943482 |     52579 |      943482 |
+-------+---------+----------+----------+-----------+-------------+

A comparative of avg case to vanilla:

RT                    - 2.10x (slower)
FIX                   - 2.06x (slower)
Multi                 - 0.70x (faster?)
Multi no PREEMPT_FULL - 1.02x (equals?)

As we can see, the patch gave good results on Preempt-RT, but my results 
was a little bit weird, because the PREEMPT-RT + Multi patch became 
faster than vanilla.

In the standard deviation, the patch showed a good result as well, with 
the patch the std dev became ~17x smaller than on RT kernel without the 
patch, which means less jitter.

-- Daniel
