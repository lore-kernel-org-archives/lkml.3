Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab3L1Cc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 21:32:29 -0500
Received: from srv.ahhyes.net ([65.19.176.90]:18947 "EHLO srv.ahhyes.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935Ab3L1Cc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 21:32:28 -0500
X-Greylist: delayed 433 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Dec 2013 21:32:28 EST
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sat, 28 Dec 2013 13:24:29 +1100
From: Alex <xor@xor.bz>
To: <linux-kernel@vger.kernel.org>
Subject: TSC Problems (warp between CPUs)
Message-ID: <b65bbca027bb2a473f989e60871c2dd2@xor.bz>
User-Agent: Roundcube Webmail/0.8.4
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: xor@xor.bz
X-SA-Exim-Scanned: No (on srv.ahhyes.net); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi There,

Firstly, apologies for the length of this post, however there is a bit 
of information I need to give so it is clear to everyone
what is happening, what I have tried, and what I am hoping to achieve.

I am having a problem with getting the TSC clocksource to work on my 
new system. I have been trying to work with my motherboard manufacturer 
(gigabyte)
to try and alert them to a possible BIOS bug but I am not getting 
anywhere with them (replies in broken english, problem not being 
understood
by their support etc).

CPU: Intel i7-4930K
Motherboard: Gigabyte GA-X79-UP4 with latest bios.

Some info on the problem (various outputs of shell commands):
-------------------------------------------------------------

alex@desktop:~$ uname -a
Linux desktop 3.12.5-custom #1 SMP PREEMPT Sat Dec 21 17:28:12 EST 2013 
x86_64 x86_64 x86_64 GNU/Linux

alex@desktop:~$ dmesg | grep -i tsc
tsc: Fast TSC calibration using PIT
tsc: Detected 3400.159 MHz processor
TSC deadline timer enabled
TSC synchronization [CPU#0 -> CPU#1]:
Measured 6618476436 cycles TSC warp between CPUs, turning off TSC 
clock.
tsc: Marking TSC unstable due to check_tsc_sync_source failed

alex@desktop:~$ cat 
/sys/devices/system/clocksource/clocksource0/available_clocksource
hpet acpi_pm

alex@desktop:~$ cat 
/sys/devices/system/clocksource/clocksource0/current_clocksource
hpet

alex@desktop:~$ cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 62
model name      : Intel(R) Core(TM) i7-4930K CPU @ 3.40GHz
stepping        : 4
microcode       : 0x416
cpu MHz         : 3400.159
cache size      : 12288 KB
physical id     : 0
siblings        : 12
core id         : 0
cpu cores       : 6
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe 
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good 
nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid dca sse4_1 sse4_2 
x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm arat 
epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid 
fsgsbase smep erms
bogomips        : 6800.31
clflush size    : 64
cache_alignment : 64
address sizes   : 46 bits physical, 48 bits virtual
power management:

processor       : 1

<and this continues for processor id's up to 11>

------------------------

As you can see "nonstop_tsc" is supported.

What I have tried doing to address the issue:
---------------------------------------------

* Tried disabling all power/energy saving functions in the CPU cores
* CPU Eist/freqency Scaling is disabled.
* Nothing is overclocked.
* No CPU turbo function enabled.

None of the above have helped. Some digging around on the net has led 
me back to the BIOS being the issue, in that it is using an MSR to write 
to the TSC and leaving it in an inconsistent state.


An interesting quote I found online, apparently from a linux kernel 
dev:
------------------------------------------------------------------------

so the way the hardware works is that there is 1 "master" tsc in the 
CPU package, that gets started when the cpu package comes out of reset. 
all logical cpus keep an offset value from that, which starts at 0, and 
the "master + offset" value is what gets returned on rdtsc. if someone 
writes to the tsc (using an MSR), what actually happens is that the 
master tsc does not change, only the per logical cpu offset gets 
changed.

Linux does not write to the TSC since quite a while... which means the 
BIOS is doing that. It really should not.
---------------------------

What I am wanting to know, is whether there is any way I can work 
around what is likely to be a BIOS bug by having the kernel 
intentionally reset the TSC.

I saw a patch floating around on the net that does something like this 
(for tsc-sync.c):

+       wrmsrl(MSR_IA32_TSC, 0);
         rdtsc_barrier();
         start = get_cycles();
         rdtsc_barrier();

Is there any safe patch to force the TSC to be reset/reinitialized that 
I can add to the kernel?


I have a number of applications that will benefit from TSC timing 
rather than HPET and would really like to try and get TSC to work.

Kind Regards,
Alex.


