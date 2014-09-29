Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbaI2CGP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 22:06:15 -0400
Received: from outbound-smtp02.blacknight.com ([81.17.249.8]:60827 "EHLO
	outbound-smtp02.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753399AbaI2CGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 22:06:14 -0400
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: [PATCH 0/1] x86: Quark: Enable correct cache size/type reporting
Date: Mon, 29 Sep 2014 03:06:11 +0100
Message-Id: <1411956372-16469-1-git-send-email-pure.logic@nexus-software.ie>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quark X1000 lacks cpuid(4). It has cpuid(2) but returns no cache
descriptors we can work with i.e. cpuid(2) returns
eax=0x00000001 ebx=0x00000000 ecx=0x00000000 edx=0x00000000

Quark X1000 contains a 16k 4-way set associative unified L1 cache
with 256 sets

This patch emulates cpuid(4) in a similar way to other x86
processors like AMDs which don't support cpuid(4). The Quark code
is based on the existing AMD code.

Before applying this patch we see
/ # cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 5
model           : 9
model name      : 05/09
stepping        : 0
cpu MHz         : 399.076
cache size      : 0 KB
fdiv_bug        : no
f00f_bug        : yes
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 7
wp              : yes
flags           : fpu vme pse tsc msr pae cx8 apic pbe nx smep
bugs            : f00f
bogomips        : 798.15
clflush size    : 32
cache_alignment : 32
address sizes   : 32 bits physical, 32 bits virtual
power management:

With no entries in
/sys/devices/system/cpu/cpu0/cache/*/*

After applying this patch we see
/ # cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 5
model           : 9
model name      : 05/09
stepping        : 0
cpu MHz         : 399.076
cache size      : 16 KB
fdiv_bug        : no
f00f_bug        : yes
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 7
wp              : yes
flags           : fpu vme pse tsc msr pae cx8 apic pbe nx smep
bugs            : f00f
bogomips        : 798.15
clflush size    : 32
cache_alignment : 32
address sizes   : 32 bits physical, 32 bits virtual
power management:

/ # ls /sys/devices/system/cpu/cpu0/cache/*/*
/sys/devices/system/cpu/cpu0/cache/index0/coherency_line_size
/sys/devices/system/cpu/cpu0/cache/index0/level
/sys/devices/system/cpu/cpu0/cache/index0/number_of_sets
/sys/devices/system/cpu/cpu0/cache/index0/physical_line_partition
/sys/devices/system/cpu/cpu0/cache/index0/shared_cpu_list
/sys/devices/system/cpu/cpu0/cache/index0/shared_cpu_map
/sys/devices/system/cpu/cpu0/cache/index0/size
/sys/devices/system/cpu/cpu0/cache/index0/type
/sys/devices/system/cpu/cpu0/cache/index0/ways_of_associativity

/ # for i in /sys/devices/system/cpu/cpu0/cache/*/* ; do echo -n "`basename $i`:
 " && cat $i ; done
coherency_line_size: 16
level: 1
number_of_sets: 256
physical_line_partition: 1
shared_cpu_list:
shared_cpu_map: 0
size: 16K
type: Unified
ways_of_associativity: 4

Bryan O'Donoghue (1):
  x86: Quark: Enable correct cache size/type reporting

 arch/x86/kernel/cpu/intel_cacheinfo.c | 78 +++++++++++++++++++++++++++++++++--
 1 file changed, 75 insertions(+), 3 deletions(-)

-- 
1.9.1

