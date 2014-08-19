Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbaHSSLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 14:11:46 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36921 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbaHSSLj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 14:11:39 -0400
From: Amit Kucheria <amit.kucheria@linaro.org>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [ANNOUNCE] (Resend) Tools to analyse PM and scheduling behaviour
User-Agent: Notmuch/0.18.1+69~gf92342c (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 19 Aug 2014 23:41:37 +0530
Message-ID: <87mwb0fixy.fsf@matterhorn.verdurent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Apologies for the resend. Gmail plain-text mode still sends multipart
messages that includes text/html and vger doesn't like that.)

Received: by 10.107.1.149 with HTTP; Fri, 8 Aug 2014 06:54:01 -0700 (PDT)
Date: Fri, 8 Aug 2014 19:24:01 +0530
Delivered-To: amit.kucheria@linaro.org
Message-ID: <CAP245DUSAHO_VBoBMy4KQaaA6_0a-i3Y3u4utnK8ji3UMVniyA@mail.gmail.com>
Subject: [ANNOUNCE] Tools to analyse PM and scheduling behaviour
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>
Cc: "Gross\, Mark" <mark.gross@intel.com>, Paul McKenney <Paul.McKenney@us.ibm.com>, Morten Rasmussen <Morten.Rasmussen@arm.com>, Dietmar Eggemann <Dietmar.Eggemann@arm.com>, Preeti U Murthy <preeti@linux.vnet.ibm.com>, Daniel Lezcano <daniel.lezcano@linaro.org>, Vincent Guittot <vincent.guittot@linaro.org>, Mike Turquette <mturquette@linaro.org>, Juri Lelli <juri.lelli@arm.com>, sched-tools@linaro.org

Hi all,

At the Energy-Aware Scheduling workshop at Kernel Summit last year[1],
maintainers identified a need for tools that would make it easier to
analyse changes to scheduling and power management behaviour of a system.
In order to satisfy that need, the Power Management working group at Linaro
has created idlestat[2]. The key design principles of idlestat are to
minimize measurement overhead during a trace capture and be accurate in
capturing P-state and C-state transitions while being architecture-agnostic.

Another requirement was to give maintainers the ability to benchmark kernel
changes against typical mobile workloads without having to run a system
like Android. In order to satisfy that need, we’ve created a workload
generator[3] (by extending rt-app) to allow simulation of typical mobile
use cases[4].

An example usage of both tools together would be:
 sudo ./idlestat --trace -f /tmp/mytrace -t 100 -- rt-app mp3.json

This should allow us to do repeatable analysis of the power management and
scheduling behaviour of the system with well-crafted workloads.

We’re soliciting early feedback from community on the direction of idlestat
and rt-app and enhancements that would make the tools more useful. I also
want to propose idlestat as a candidate for inclusion into kernel tools
directory.

Idlestat Details
----------------
Idlestat uses FTRACE to capture traces related to C-state and P-state
transitions of the CPU and wakeups (IRQ, IPI) on the system and then
post-processes the data to print statistics. It is designed to be used
non-interactively. Idlestat can deduce the idle time for a cluster as an
intersection between the idle times of all the cpus belonging to the same
cluster. This data is useful to analyse and optimise scheduling behaviour.
The tool will also list how many times the menu governor mis-predicts
target residency in a C-state.

In the future, we plan to add a ‘diff mode’ to allow comparison of two
trace files (useful for regression tracking) and to allow inputting an
energy model for the CPU so that the tool can output a rough energy
consumption estimate for the workload. See the wiki[2] for other ideas for
new features.

A sample run on 24-core Intel XEON with HT disabled and all but two cpus in
each cluster offlined (for the sake of keeping the output short) looks as
follows:

sudo ./idlestat --trace -f /tmp/mytrace -t 10 -p -c -w
Log is 12.934396 secs long with 148153 events
--------------------------------------------------------------------------------
| C-state  |   min    |   max    |   avg    |   total  | hits  |  over |
under |
--------------------------------------------------------------------------------
| clusterA
    |
--------------------------------------------------------------------------------
|   C6-IVT |      0us |  21.02ms |    364us | 244.85ms |   673 |     0 |
  0 |
--------------------------------------------------------------------------------
|             cpu0
    |
--------------------------------------------------------------------------------
|   C1-IVT |     31us |     42us |     37us |    111us |     3 |     0 |
  0 |
|  C1E-IVT |     21us |    112us |     52us |    155us |     3 |     2 |
  0 |
|   C3-IVT |     40us |    276us |    178us |   1.07ms |     6 |     2 |
  0 |
|   C6-IVT |      2us |  21.13ms |    580us | 260.23ms |   449 |   318 |
  0 |
--------------------------------------------------------------------------------
|             cpu1
    |
--------------------------------------------------------------------------------
|     POLL |     17us |     17us |     17us |     17us |     1 |     0 |
  1 |
|   C1-IVT |      6us |     95us |     49us |   1.09ms |    22 |     0 |
  3 |
|  C1E-IVT |      4us |    166us |    108us |   2.16ms |    20 |     3 |
  4 |
|   C3-IVT |      6us |    274us |    167us |   4.51ms |    27 |     7 |
  0 |
|   C6-IVT |      1us |  52.56ms |    372us |   11.07s | 29794 | 23533 |
  0 |
--------------------------------------------------------------------------------
| clusterB
    |
--------------------------------------------------------------------------------
|   C6-IVT |      0us |  85.65ms |   2.21ms |   11.33s |  5121 |     0 |
  0 |
--------------------------------------------------------------------------------
|             cpu6
    |
--------------------------------------------------------------------------------
|   C1-IVT |     44us |     44us |     44us |     44us |     1 |     0 |
  0 |
|  C1E-IVT |    164us |    164us |    164us |    164us |     1 |     0 |
  1 |
|   C3-IVT |    258us |    258us |    258us |    258us |     1 |     0 |
  0 |
|   C6-IVT |      1us |  85.65ms |   2.24ms |   11.43s |  5113 |  1358 |
  0 |
--------------------------------------------------------------------------------
|             cpu7
    |
--------------------------------------------------------------------------------
|   C1-IVT |      9us |      9us |      9us |      9us |     1 |     0 |
  0 |
|   C3-IVT |    298us |    298us |    298us |    298us |     1 |     0 |
  0 |
|   C6-IVT |     22us |    1.50s | 279.02ms |   12.83s |    46 |     3 |
  0 |
--------------------------------------------------------------------------------

----------------------------------------------------------------
| P-state  |   min    |   max    |   avg    |   total  | hits  |
----------------------------------------------------------------
|             cpu0                                             |
----------------------------------------------------------------
|  2.60GHz |      0us |   12.56s |  59.79ms |   12.62s |   211 |
|  2.20GHz |  12.01ms |  12.01ms |  12.01ms |  12.01ms |     1 |
|  1.50GHz |      0us |   2.66ms |     95us |   3.53ms |    37 |
|  1.20GHz |      1us |  14.24ms |    368us |  26.85ms |    73 |
----------------------------------------------------------------
|             cpu1                                             |
----------------------------------------------------------------
|  2.60GHz |      0us |   6.43ms |     57us | 757.08ms | 13341 |
|  2.50GHz |      0us |   6.82ms |     79us |  31.93ms |   404 |
|  2.40GHz |      0us |   6.59ms |    111us |  11.43ms |   103 |
|  2.30GHz |      0us |   5.82ms |     29us |  29.27ms |   999 |
|  2.20GHz |      0us |   7.80ms |     49us |  79.03ms |  1618 |
|  2.10GHz |      0us |   4.96ms |     66us |  30.72ms |   465 |
|  2.00GHz |      0us |   9.01ms |     33us |  40.57ms |  1246 |
|  1.90GHz |      0us |   6.16ms |     57us |  24.81ms |   434 |
|  1.80GHz |      0us |  11.56ms |    101us |  77.03ms |   764 |
|  1.70GHz |      0us |  12.97ms |     96us |  58.47ms |   606 |
|  1.60GHz |      0us |  12.94ms |     98us |  85.31ms |   867 |
|  1.50GHz |      0us |  11.99ms |    166us |  35.10ms |   211 |
|  1.40GHz |      0us |   3.64ms |     62us |  26.97ms |   433 |
|  1.30GHz |   7.99ms |   7.99ms |   7.99ms |   7.99ms |     1 |
|  1.20GHz |      0us |  15.29ms |     64us | 531.01ms |  8291 |
----------------------------------------------------------------
|             cpu6                                             |
----------------------------------------------------------------
|  2.60GHz |      1us |   6.10ms |    215us | 658.53ms |  3059 |
|  2.30GHz |     20us |   5.57ms |    205us |  21.16ms |   103 |
|  2.20GHz |     18us |   7.42ms |    201us |  26.49ms |   132 |
|  2.00GHz |     21us |    367us |    159us |   4.77ms |    30 |
|  1.90GHz |     21us |   8.96ms |    259us |  18.42ms |    71 |
|  1.80GHz |     72us |   6.09ms |    280us |  11.49ms |    41 |
|  1.70GHz |      2us |   5.40ms |    173us |  38.69ms |   224 |
|  1.60GHz |      2us |   3.95ms |    188us |  11.50ms |    61 |
|  1.50GHz |      2us |  11.66ms |    323us |  38.39ms |   119 |
|  1.40GHz |      2us |  11.94ms |    364us |  61.85ms |   170 |
|  1.30GHz |      5us |  10.72ms |    315us |  24.27ms |    77 |
|  1.20GHz |      2us |  15.83ms |    608us | 569.34ms |   937 |
----------------------------------------------------------------
|             cpu7                                             |
----------------------------------------------------------------
|  2.60GHz |      5us |  75.74ms |   8.43ms |  75.88ms |     9 |
|  1.70GHz |   1.41ms |   1.41ms |   1.41ms |   1.41ms |     1 |
|  1.20GHz |     10us |   4.87ms |    181us |   7.07ms |    39 |
----------------------------------------------------------------

--------------------------------------------
| Wakeup |  #  |       Name      |  Count  |
--------------------------------------------
|             cpu0                         |
--------------------------------------------
| irq    | 117 |     eth0-TxRx-6 |     355 |
| ipi    | --- |      RESCHEDULE |       2 |
--------------------------------------------
|             cpu1                         |
--------------------------------------------
| irq    | 115 |     eth0-TxRx-4 |   29654 |
| irq    | 130 |     eth1-TxRx-1 |       4 |
| irq    | 111 |     eth0-TxRx-0 |       1 |
| irq    | 112 |     eth0-TxRx-1 |       3 |
--------------------------------------------
|             cpu6                         |
--------------------------------------------
| ipi    | --- |      RESCHEDULE |     274 |
--------------------------------------------
|             cpu7                         |
--------------------------------------------
| ipi    | --- |      RESCHEDULE |       4 |
--------------------------------------------

The IPI statistics require support for generic IPI tracing[4] to land
upstream.

Workload Generator Details
--------------------------
The Workload Generator is based on rt-app. Shared resources, waits, signals
and locking order can be specified for each thread in a JSON description to
construct complex interdependencies. This allows simulation of interesting
use-cases. The repository contains examples of a mp3 and web-browsing
workload.

The method to construct the JSON description is quite manual currently. We
capture the trace of a workload of interest (say, on Android) and analyse
it in kernelshark. We then construct the JSON description by hand until its
resultant trace looks similar to the trace from the real workload.

The immediate goal is to expand the library to cover the common mobile
workloads. We’re also working with the rt-app maintainer to get our changes
merged.

Thanks to ARM for help in specifying the mobile workloads and reviewing the
results.

Please play with the tools and let us know what you think. You can write to
sched-tools@linaro.org if you want to contact us off-list.

Regards,
Amit

[1] http://lwn.net/Articles/571414/
[2]
https://wiki.linaro.org/WorkingGroups/PowerManagement/Resources/Tools/Idlestat
[3]
https://wiki.linaro.org/WorkingGroups/PowerManagement/Resources/Tools/WorkloadGen
[4] https://lkml.org/lkml/2014/1/7/355
[5] https://lkml.org/lkml/2014/7/25/610
