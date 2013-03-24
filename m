Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab3CXOTK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 10:19:10 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:57620 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab3CXOTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 10:19:08 -0400
MIME-Version: 1.0
Date: Sun, 24 Mar 2013 15:19:08 +0100
Message-ID: <CAG9S4UhcSSUDgf-_JXsqkjzDo0XU6wHhmU_u=W_Eg9qbi158tw@mail.gmail.com>
Subject: [REGRESSION] [CPUFREQ] 3.9.0-rcX
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        viresh.kumar@linaro.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(long e-mail, sorry ;-))

Last known good: 3.8.0

Short description:
1. On -rc3, after s2ram cpufreq does not set CPU on max frequency on
high load (on battery).
2. On -rc4 (this is not real regression because I change config
between -rc3 and rc4), "ondemand" does not work. Current frequency is
'strange' (792 MHz).

Detailed description:

1. Kernel 3.8.0:

I try:
# cd /sys/devices/system/cpu
# CPU_LIST="cpu0/cpufreq/ cpu1/cpufreq/ cpu2/cpufreq cpu3/cpufreq"
# for i in $CPU_LIST; do echo -e "\n\n==================\n$i"; grep ''
-R $i/*; done

Output (show only fisrt CPU, others are same):
cpu0/cpufreq/
cpu0/cpufreq//affected_cpus:0
cpu0/cpufreq//bios_limit:2200000
cpu0/cpufreq//cpuinfo_cur_freq:800000
cpu0/cpufreq//cpuinfo_max_freq:2200000
cpu0/cpufreq//cpuinfo_min_freq:800000
cpu0/cpufreq//cpuinfo_transition_latency:10000
cpu0/cpufreq//related_cpus:0 1 2 3
cpu0/cpufreq//scaling_available_frequencies:2200000 2000000 1900000
1800000 1700000 1600000 1500000 1400000 1300000 1200000 1100000
1000000 900000 800000
cpu0/cpufreq//scaling_available_governors:ondemand performance
cpu0/cpufreq//scaling_cur_freq:800000
cpu0/cpufreq//scaling_driver:acpi-cpufreq
cpu0/cpufreq//scaling_governor:ondemand
cpu0/cpufreq//scaling_max_freq:2200000
cpu0/cpufreq//scaling_min_freq:800000
cpu0/cpufreq//scaling_setspeed:<unsupported>

It is good: governor "on demand", frequencies also good (800MHz)

CASE 1
Run in other consoles "while true; do echo -n; done" (four times),
power on/off AC power, suspend to ram:

cpu0/cpufreq/
cpu0/cpufreq//affected_cpus:0
cpu0/cpufreq//bios_limit:2200000
cpu0/cpufreq//cpuinfo_cur_freq:2200000
cpu0/cpufreq//cpuinfo_max_freq:2200000
cpu0/cpufreq//cpuinfo_min_freq:800000
cpu0/cpufreq//cpuinfo_transition_latency:10000
cpu0/cpufreq//related_cpus:0 1 2 3
cpu0/cpufreq//scaling_available_frequencies:2200000 2000000 1900000
1800000 1700000 1600000 1500000 1400000 1300000 1200000 1100000
1000000 900000 800000
cpu0/cpufreq//scaling_available_governors:ondemand performance
cpu0/cpufreq//scaling_cur_freq:2200000
cpu0/cpufreq//scaling_driver:acpi-cpufreq
cpu0/cpufreq//scaling_governor:ondemand
cpu0/cpufreq//scaling_max_freq:2200000
cpu0/cpufreq//scaling_min_freq:800000
cpu0/cpufreq//scaling_setspeed:<unsupported>

Still is good, governor works as expected.



===============================================================================

Kernel 3.9.0-rc1

$ diff -uNr /boot/config-3.8.0 /boot/config-3.9.0-rc3  | grep -i CONFIG_X86_
 CONFIG_X86_64=y
 CONFIG_X86_MPPARSE=y
 # CONFIG_X86_EXTENDED_PLATFORM is not set
+# CONFIG_X86_INTEL_LPSS is not set
 CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
 CONFIG_X86_MSR=m
 CONFIG_X86_CPUID=m
 CONFIG_X86_PM_TIMER=y
+# CONFIG_X86_INTEL_PSTATE is not set
 # CONFIG_X86_PCC_CPUFREQ is not set
 CONFIG_X86_ACPI_CPUFREQ=m
 # CONFIG_X86_ACPI_CPUFREQ_CPB is not set
 CONFIG_X86_PLATFORM_DEVICES=y

CASE 2
After boot:
cpu0/cpufreq/
cpu0/cpufreq//affected_cpus:0 1 2 3
cpu0/cpufreq//bios_limit:2200000
cpu0/cpufreq//cpuinfo_cur_freq:800000
cpu0/cpufreq//cpuinfo_max_freq:2200000
cpu0/cpufreq//cpuinfo_min_freq:800000
cpu0/cpufreq//cpuinfo_transition_latency:10000
cpu0/cpufreq//related_cpus:0 1 2 3
cpu0/cpufreq//scaling_available_frequencies:2200000 2000000 1900000
1800000 1700000 1600000 1500000 1400000 1300000 1200000 1100000
1000000 900000 800000
cpu0/cpufreq//scaling_available_governors:ondemand performance
cpu0/cpufreq//scaling_cur_freq:800000
cpu0/cpufreq//scaling_driver:acpi-cpufreq
cpu0/cpufreq//scaling_governor:ondemand
cpu0/cpufreq//scaling_max_freq:2200000
cpu0/cpufreq//scaling_min_freq:800000
cpu0/cpufreq//scaling_setspeed:<unsupported>

(seems be ok)

CASE 3
Run in other consoles "while true; do echo -n; done":
cpu0/cpufreq/
cpu0/cpufreq//affected_cpus:0 1 2 3
cpu0/cpufreq//bios_limit:2200000
cpu0/cpufreq//cpuinfo_cur_freq:2200000
cpu0/cpufreq//cpuinfo_max_freq:2200000
cpu0/cpufreq//cpuinfo_min_freq:800000
cpu0/cpufreq//cpuinfo_transition_latency:10000
cpu0/cpufreq//related_cpus:0 1 2 3
cpu0/cpufreq//scaling_available_frequencies:2200000 2000000 1900000
1800000 1700000 1600000 1500000 1400000 1300000 1200000 1100000
1000000 900000 800000
cpu0/cpufreq//scaling_available_governors:ondemand performance
cpu0/cpufreq//scaling_cur_freq:2200000
cpu0/cpufreq//scaling_driver:acpi-cpufreq
cpu0/cpufreq//scaling_governor:ondemand
cpu0/cpufreq//scaling_max_freq:2200000
cpu0/cpufreq//scaling_min_freq:800000
cpu0/cpufreq//scaling_setspeed:<unsupported>

(still seems be ok)

CASE 4
Disconnect AC adapter
(the same as in 'CASE 3')

CASE 5
Suspend to ram and resume

cpu0/cpufreq/
cpu0/cpufreq//affected_cpus:0 1 2 3
cpu0/cpufreq//bios_limit:2200000
cpu0/cpufreq//cpuinfo_cur_freq:800000
cpu0/cpufreq//cpuinfo_max_freq:2200000
cpu0/cpufreq//cpuinfo_min_freq:800000
cpu0/cpufreq//cpuinfo_transition_latency:10000
cpu0/cpufreq//related_cpus:0 1 2 3
cpu0/cpufreq//scaling_available_frequencies:2200000 2000000 1900000
1800000 1700000 1600000 1500000 1400000 1300000 1200000 1100000
1000000 900000 800000
cpu0/cpufreq//scaling_available_governors:ondemand performance
cpu0/cpufreq//scaling_cur_freq:800000
cpu0/cpufreq//scaling_driver:acpi-cpufreq
cpu0/cpufreq//scaling_governor:ondemand
cpu0/cpufreq//scaling_max_freq:2200000
cpu0/cpufreq//scaling_min_freq:800000
cpu0/cpufreq//scaling_setspeed:<unsupported>

First error: frequency changed from 2,2GHz (maximum) to 800MHz
(minimum), despite the high CPU load.

CASE 6
Power on AC adapter:

cpu0/cpufreq/
cpu0/cpufreq//affected_cpus:0 1 2 3
cpu0/cpufreq//bios_limit:2200000
cpu0/cpufreq//cpuinfo_cur_freq:2200000
cpu0/cpufreq//cpuinfo_max_freq:2200000
cpu0/cpufreq//cpuinfo_min_freq:800000
cpu0/cpufreq//cpuinfo_transition_latency:10000
cpu0/cpufreq//related_cpus:0 1 2 3
cpu0/cpufreq//scaling_available_frequencies:2200000 2000000 1900000
1800000 1700000 1600000 1500000 1400000 1300000 1200000 1100000
1000000 900000 800000
cpu0/cpufreq//scaling_available_governors:ondemand performance
cpu0/cpufreq//scaling_cur_freq:2200000
cpu0/cpufreq//scaling_driver:acpi-cpufreq
cpu0/cpufreq//scaling_governor:ondemand
cpu0/cpufreq//scaling_max_freq:2200000
cpu0/cpufreq//scaling_min_freq:800000
cpu0/cpufreq//scaling_setspeed:<unsupported>

(now back to normal, until AC is disconnected)

===============================================================================

Kernel 3.9.0-rc4

I do some changes:
$ diff -uNr /boot/config-3.9.0-rc3  /boot/config-3.9.0-rc4 | grep -i CONFIG_X86_
 CONFIG_X86_64=y
-# CONFIG_X86_INTEL_PSTATE is not set
-# CONFIG_X86_PCC_CPUFREQ is not set
+CONFIG_X86_INTEL_PSTATE=y
+CONFIG_X86_PCC_CPUFREQ=m
 CONFIG_X86_ACPI_CPUFREQ=m
 # CONFIG_X86_ACPI_CPUFREQ_CPB is not set
 # CONFIG_X86_POWERNOW_K8 is not set

CASE 7
(normal boot)
CPU:

cpu0/cpufreq/
cpu0/cpufreq//affected_cpus:0
cpu0/cpufreq//cpuinfo_cur_freq:792000
cpu0/cpufreq//cpuinfo_max_freq:2200000
cpu0/cpufreq//cpuinfo_min_freq:800000
cpu0/cpufreq//cpuinfo_transition_latency:4294967295
cpu0/cpufreq//related_cpus:0
cpu0/cpufreq//scaling_available_governors:performance powersave
cpu0/cpufreq//scaling_driver:intel_pstate
cpu0/cpufreq//scaling_governor:powersave
cpu0/cpufreq//scaling_max_freq:2200000
cpu0/cpufreq//scaling_min_freq:800000
cpu0/cpufreq//scaling_setspeed:<unsupported>

(regardless of the cpu load, power, suspend) 'ondemand' governor is
not available.

Config, dmesg:
http://mrutecki.pl/download/kernel/3.9.0-rc4/cpufreq/


Regards

--
Maciej Rutecki
http://www.mrutecki.pl
