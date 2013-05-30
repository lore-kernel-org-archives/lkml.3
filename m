Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab3E3NrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 09:47:24 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47245 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab3E3NrS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 09:47:18 -0400
Date: Thu, 30 May 2013 14:47:18 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: alex.shi@intel.com, peterz@infradead.org, mingo@kernel.org,
        preeti@linux.vnet.ibm.com, vincent.guittot@linaro.org, efault@gmx.de,
        pjt@google.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Cc: arjan@linux.intel.com, len.brown@intel.com, corbet@lwn.net,
        tglx@linutronix.de
Subject: [RFC] Comparison of power-efficient scheduling patch sets
Message-ID: <20130530134718.GB32728@e103034-lin>
MIME-Version: 1.0
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 30 May 2013 13:47:14.0983 (UTC) FILETIME=[317A1B70:01CE5D3C]
X-MC-Unique: 113053014471601401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A number of patch sets related to power-efficient scheduling have been
posted over the last couple of months. Most of them do not have much
data to back them up, so I decided to do some testing.

Common for all of the patch sets that I have tested, except one, is that
they attempt to pack tasks on as few cpus as possible to allow the
remaining cpus to enter deeper sleep states - a strategy that should
make sense on most platforms that support per-cpu power gating and
multi-socket machines.

Kernel: 3.9

Patch sets:
rlb-v4: sched: use runnable load based balance (Alex Shi)
        <https://lkml.org/lkml/2013/4/27/13>
pas-v7: sched: power aware scheduling (Alex Shi)
        <https://lkml.org/lkml/2013/4/3/732>
pst-v3: sched: packing small tasks (Vincent Guittot)
        <https://lkml.org/lkml/2013/3/22/183>
pst-v4: sched: packing small tasks (Vincent Guittot)
        <https://lkml.org/lkml/2013/4/25/396>

Configuration:
pas-v7: Set to "powersaving" mode.
pst-v4: Set to "Full" packing mode.

Platform:
ARM TC2 (test-chip), 2xCortex-A15 + 3xCortex-A7. Cortex-A15s disabled.

Measurement technique:
Time spent non-idle (not in idle state) for each cpu based on cpuidle
ftrace events. TC2 does not have per-core power-gating, so packing
inside the A7 cluster does not lead to any significant power savings.
Note that any product grade hardware (TC2 is a test-chip) will very
likely have per-core power-gating, so in those cases packing will have
an appreciable effect on power savings.
Measuring non-idle time rather than power should give a more clear idea
about the effect of the patch sets given that the idle back-end is
highly implementation specific.

Benchmarks:
audio playback (Android): 30s mp3 file playback on Android.
bbench+audio (Android): Web page rendering while doing mp3 playback.
andebench_native (Android): Android benchmark running in native mode.
cyclictest: Short periodic tasks.

Results:
Two runs for each patch set.

audio playback (Android) SMP
non-idle %  cpu 0  cpu 1  cpu 2
3.9_1       11.96   2.86   2.48
3.9_2       12.64   2.81   1.88
rlb-v4_1    12.61   2.44   1.90
rlb-v4_2    12.45   2.44   1.90
pas-v7_1    16.17   0.03   0.24
pas-v7_2    16.08   0.28   0.07
pst-v3_1    15.18   2.76   1.70
pst-v3_2    15.13   0.80   0.38
pst-v4_1    16.14   0.05   0.00
pst-v4_2    16.34   0.06   0.00

bbench+audio (Android) SMP
non-idle %  cpu 0  cpu 1  cpu 2  render time
3.9_1       25.00  20.73  21.22   812
3.9_2       24.29  19.78  22.34   795
rlb-v4_1    23.84  19.36  22.74   782
rlb-v4_2    24.07  19.36  22.74   797
pas-v7_1    28.29  17.86  16.01   869
pas-v7_2    28.62  18.54  15.05   908
pst-v3_1    29.14  20.59  21.72   830
pst-v3_2    27.69  18.81  20.06   830
pst-v4_1    42.20  13.63   2.29   880
pst-v4_2    41.56  14.40   2.17   935

andebench_native (8 threads) (Android) SMP
non-idle %  cpu 0  cpu 1  cpu 2  Score
3.9_1       99.22  98.88  99.61   4139
3.9_2       99.56  99.31  99.46   4148
rlb-v4_1    99.49  99.61  99.53   4153
rlb-v4_2    99.56  99.61  99.53   4149
pas-v7_1    99.53  99.59  99.29   4149
pas-v7_2    99.42  99.63  99.48   4150
pst-v3_1    97.89  99.33  99.42   4097
pst-v3_2    99.16  99.62  99.42   4097
pst-v4_1    99.34  99.01  99.59   4146
pst-v4_2    99.49  99.52  99.20   4146

cyclictest SMP
non-idle %  cpu 0  cpu 1  cpu 2
3.9_1        9.13   8.88   8.41
3.9_2       10.27   8.02   6.30
rlb-v4_1     8.88   8.09   8.11
rlb-v4_2     8.49   8.09   8.11
pas-v7_1    10.20   0.02  11.50
pas-v7_2     7.86  14.31   0.02
pst-v3_1    20.44   8.68   7.97
pst-v3_2    20.41   0.78   1.00
pst-v4_1    21.32   0.21   0.05
pst-v4_2    21.56   0.21   0.04

Overall, pas-v7 seems to do a fairly good job at packing. The idle time
distribution seems to be somewhere between pst-v3 and the more
aggressive pst-v4 for all the benchmarks. pst-v4 manages to keep two
cpus nearly idle (<0.25% non-idle) for both cyclictest and audio, which
is better than both pst-v3 and pas-v7. pas-v7 fails to pack cyclictest.
Packing does come at at cost which can be seen for bbench+audio, where
pst-v3 and rlb-v4 get better render times than pas-v7 and pst-v4 which
do more aggressive packing. rlb-v4 does not pack, it is only included
for reference.

>From a packing perspective pst-v4 seems to do the best job for the
workloads that I have tested on ARM TC2. The less aggressive packing in
pst-v3 may be a better choice for in terms of performance.

I'm well aware that these tests are heavily focused on mobile workloads.
I would therefore encourage people to share your test results for your
workloads on your platforms to complete the picture. Comments are also
welcome.

Thanks,
Morten


