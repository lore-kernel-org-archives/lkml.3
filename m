Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab3JRX1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 19:27:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757730Ab3JRX1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 19:27:33 -0400
Date: Fri, 18 Oct 2013 13:42:24 -0400
Message-Id: <201310181742.r9IHgO1q021001@ib.usersys.redhat.com>
From: Doug Ledford <dledford@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Doug Ledford <dledford@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
In-Reply-To: 20131017084121.GC22705@gmail.com
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-10-17, Ingo wrote:
> * Neil Horman <nhorman@tuxdriver.com> wrote:
> 
>> On Mon, Oct 14, 2013 at 03:18:47PM -0700, Eric Dumazet wrote:
>> > On Mon, 2013-10-14 at 14:19 -0700, Eric Dumazet wrote:
>> > > On Mon, 2013-10-14 at 16:28 -0400, Neil Horman wrote:
>> > > 
>> > > > So, early testing results today.  I wrote a test module that, allocated a 4k
>> > > > buffer, initalized it with random data, and called csum_partial on it 100000
>> > > > times, recording the time at the start and end of that loop.  Results on a 2.4
>> > > > GHz Intel Xeon processor:
>> > > > 
>> > > > Without patch: Average execute time for csum_partial was 808 ns
>> > > > With patch: Average execute time for csum_partial was 438 ns
>> > > 
>> > > Impressive, but could you try again with data out of cache ?
>> > 
>> > So I tried your patch on a GRE tunnel and got following results on a
>> > single TCP flow. (short result : no visible difference)

[ to Eric ]

You didn't show profile data from before and after the patch, only after.  And it
showed csum_partial at 19.9% IIRC.  That's a much better than I get on my test
machines (even though this is on a rhel6.5-beta kernel, understand that the entire
IB stack in rhel6.5-beta is up to a 3.10 level, with parts closer to 3.11+):

For IPoIB in connected mode, where there is no rx csum offload:

::::::::::::::
rhel6.5-beta-cm-no-offload-oprofile-run1
::::::::::::::
CPU: Intel Architectural Perfmon, speed 3392.17 MHz (estimated)
Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a unit mask of 0x00 (No unit mask) count 100000
Samples on CPU 0
Samples on CPU 4
Samples on CPU 6 (edited out as it was only a few samples and ruined
                  line wrapping)
samples  %        samples  %        image name               symbol name
98588    59.1431  215      57.9515  vmlinux    csum_partial_copy_generic
3003      1.8015  8         2.1563  vmlinux                  tcp_sendmsg
2219      1.3312  0              0  vmlinux            irq_entries_start
2076      1.2454  4         1.0782  vmlinux         avc_has_perm_noaudit
1815      1.0888  0              0  mlx4_ib.ko           mlx4_ib_poll_cq

So, here anyway, it's 60%.  At that level of showing, there is a lot more to be
gained from an improvement to that function.  And here's the measured performance
from those runs:

[root@rdma-master rhel6.5-beta-client]# more rhel6.5-beta-cm-no-offload-netperf.output 
Recv   Send    Send                          Utilization
Socket Socket  Message  Elapsed              Send     Recv
Size   Size    Size     Time     Throughput  local    remote
bytes  bytes   bytes    secs.    MBytes  /s  % S      % S
 87380  16384  16384    20.00      2815.29   7.92     12.80  
 87380  16384  16384    20.00      2798.22   7.88     12.87  
 87380  16384  16384    20.00      2786.74   7.79     12.84

The test machine has 8 logical CPUs, so 12.5% is 100% of a single CPU.  That
said, the receive side is obviously the bottleneck here, and 60% of that
bottleneck is csum_partial.

[ snip a bunch of Neil's measurements ]

>> Based on these, prefetching is obviously a a good improvement, but not 
>> as good as parallel execution, and the winner by far is doing both.

OK, this is where I have to chime in that these tests can *not* be used
to say anything about prefetch, and not just for the reasons Ingo lists
in his various emails to this thread.  In fact I would argue that Ingo's
methodology on this is wrong as well.

All prefetch operations get sent to an access queue in the memory controller
where they compete with both other reads and writes for the available memory
bandwidth.  The optimal prefetch window is not a factor of memory bandwidth
and latency, it's a factor of memory bandwidth, memory latency, current memory
access queue depth at time prefetch is issued, and memory bank switch time *
number of queued memory operations that will require a bank switch.  In other
words, it's much more complex and also much more fluid than any static
optimization can pull out.  So every time I see someone run a series of micro-
benchmarks like you just did, where the system was only doing the micro-
benchmark and not a real workload, and we draw conclusions about optimal
prefetch distances from that test, I cringe inside and I think I even die...
just a little.

A better test for this, IMO, would be to start a local kernel compile with at
least twice as many gcc instances allowed as you have CPUs, *then* run your
benchmark kernel module and see what prefetch distance works well.  This
distance should be far enough out that it can withstand other memory pressure,
yet not so far as to constantly be prefetching, tossing the result out of cache
due to pressure, then fetching/stalling that same memory on load.  And it may
not benchmark as well on a quiescent system running only the micro-benchmark,
but it should end up performing better in actual real world usage.

> Also, it would be nice to see standard deviation noise numbers when two 
> averages are close to each other, to be able to tell whether differences 
> are statistically significant or not.
> 
> For example 'perf stat --repeat' will output stddev for you:
> 
>   comet:~/tip> perf stat --repeat 20 --null bash -c 'usleep $((RANDOM*10))'
> 
>    Performance counter stats for 'bash -c usleep $((RANDOM*10))' (20 runs):
> 
>        0.189084480 seconds time elapsed                                          ( +- 11.95% )

[ snip perf usage tips ]

I ran my original tests with oprofile.  I'll rerun the last one plus some new
tests with the various incarnations of this patch using perf and report the
results back here.

However, the machines I ran these tests on were limited by a 40GBit/s line
speed, with a theoretical max of 4GBytes/s due to bit encoding on the wire,
and I think limited even a bit lower by theoretical limit of useful data
across a PCI-e gen2 x8 bus.  So I wouldn't expect the throughput to go
much higher even if this helps, it should mainly reduce CPU usage.  I can
try the same tests on a 56GBit/s link and with cards that have PCI-e
gen3 and see how those machines do by comparison (the hosts are identical,
just the cards are different).
