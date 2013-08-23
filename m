Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab3HWJA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 05:00:26 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:50879 "EHLO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab3HWJAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 05:00:23 -0400
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Aug 2013 05:00:23 EDT
Message-ID: <521722EE.70209@fold.natur.cuni.cz>
Date: Fri, 23 Aug 2013 10:53:02 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:23.0) Gecko/20100101 Firefox/23.0 SeaMonkey/2.20
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>,
        mingo@redhat.com, peterz@infradead.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [sched_delayed] sched: RT throttling activated
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  I tried to figure out what this message really means. I came to 
https://rt.wiki.kernel.org/index.php/Frequently_Asked_Questions
but I am still lost. I lack in the FAQ some user-related information.
The first paragraph is still unclear to me. I have a i7-2640M based
laptop, hyperthreading is enabled by BIOS but I shut down the two
emulated cores by (no BIOS option to disable HT):

echo 0 > /sys/devices/system/cpu/cpu2/online
echo 0 > /sys/devices/system/cpu/cpu3/online

At least I hope I shutdown those emulated ones. i7z claims I did the
right thing and IntelPerformanceCounterMonitorV2.5.1/pcm.x application
says the same:

 EXEC  : instructions per nominal CPU cycle
 IPC   : instructions per CPU cycle
 FREQ  : relation to nominal CPU frequency='unhalted clock ticks'/'invariant timer ticks' (includes Intel Turbo Boost)
 AFREQ : relation to nominal CPU frequency while in active state (not in power-saving C state)='unhalted clock ticks'/'invariant timer ticks while in C0-state'  (includes Intel Turbo Boost)
 L3MISS: L3 cache misses 
 L2MISS: L2 cache misses (including other core's L2 cache *hits*) 
 L3HIT : L3 cache hit ratio (0.00-1.00)
 L2HIT : L2 cache hit ratio (0.00-1.00)
 L3CLK : ratio of CPU cycles lost due to L3 cache misses (0.00-1.00), in some cases could be >1.0 due to a higher memory latency
 L2CLK : ratio of CPU cycles lost due to missing L2 cache but still hitting L3 cache (0.00-1.00)
 READ  : bytes read from memory controller (in GBytes)
 WRITE : bytes written to memory controller (in GBytes)
 TEMP  : Temperature reading in 1 degree Celsius relative to the TjMax temperature (thermal headroom): 0 corresponds to the max temperature


 Core (SKT) | EXEC | IPC  | FREQ  | AFREQ | L3MISS | L2MISS | L3HIT | L2HIT | L3CLK | L2CLK  | READ  | WRITE | TEMP

   0    0     1.78   1.51   1.18    1.18    1595 K   3363 K    0.53    0.00    0.09    0.02     N/A     N/A     23
   1    0     1.21   1.03   1.18    1.18    9359 K     13 M    0.31    0.00    0.51    0.04     N/A     N/A     24
-------------------------------------------------------------------------------------------------------------------
 SKT    0     1.50   1.27   1.18    1.18      10 M     16 M    0.35    0.00    0.30    0.03    1.32    0.37     24
-------------------------------------------------------------------------------------------------------------------
 TOTAL  *     1.50   1.27   1.18    1.18      10 M     16 M    0.35    0.00    0.30    0.03    1.32    0.37     N/A

 Instructions retired: 8368 M ; Active cycles: 6594 M ; Time (TSC): 2797 Mticks ; C0 (active,non-halted) core residency: 100.00 %

 C1 core residency: 0.00 %; C3 core residency: 0.00 %; C6 core residency: 0.00 %; C7 core residency: 0.00 %
 C2 package residency: 0.00 %; C3 package residency: 0.00 %; C6 package residency: 0.00 %; C7 package residency: 0.00 %

 PHYSICAL CORE IPC                 : 1.27 => corresponds to 31.73 % utilization for cores in active state
 Instructions per nominal CPU cycle: 1.50 => corresponds to 37.40 % core utilization over time interval
----------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------
 SKT    0 package consumed 28.18 Joules
----------------------------------------------------------------------------------------------
 TOTAL:                    28.18 Joules





Why do I get the message at all? I have in 3.10.9 kernel:

...
CONFIG_IOSCHED_DEADLINE=y
CONFIG_DEFAULT_IOSCHED="deadline"
...
CONFIG_NR_CPUS=4
...
# CONFIG_PREEMPT_RCU is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
...
# CONFIG_SCHED_MC is not set
CONFIG_SCHED_HRTICK=y

I fear this is about CPU being overloaded (both cores loaded
by user processes), by why do I get the message at all?



Cpu speed from cpuinfo 2796.00Mhz
cpuinfo might be wrong if cpufreq is enabled. To guess correctly try estimating via tsc
Linux's inbuilt cpu_khz code emulated now
True Frequency (without accounting Turbo) 2796 MHz
  CPU Multiplier 28x || Bus clock frequency (BCLK) 99.86 MHz

Socket [0] - [physical cores=2, logical cores=2, max online cores ever=2]
  TURBO ENABLED on 2 Cores, Hyper Threading OFF
  Max Frequency without considering Turbo 2895.86 MHz (99.86 x [29])
  Max TURBO Multiplier (if Enabled) with 1/2/3/4 Cores is  35x/33x/33x/33x
  Real Current Frequency 3295.29 MHz [99.86 x 33.00] (Max of below)
        Core [core-id]  :Actual Freq (Mult.)      C0%   Halt(C1)%  C3 %   C6 %   C7 %  Temp
        Core 1 [0]:       3295.28 (33.00x)       100       0       0       0       0    76
        Core 2 [1]:       3295.29 (33.00x)       100       0       0       0       0    76



Would you please clarify what the "[sched_delayed] sched: RT throttling activated"
really means? Is that because there is some RT-requiring application on my system?
I don't know of any (or don't care about real-time responsiveness except that ALSA
drivers require me to have CONFIG_SND_HRTIMER=y). Per Goggle answers could the
culprit be nfsd? Then I will recompile is as a module.

# ps -ef |  grep nfs
root       920     2  0 Aug22 ?        00:00:00 [nfsiod]
#


Thank you,
Martin
