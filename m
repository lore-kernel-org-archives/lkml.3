Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160Ab3I2EDv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 00:03:51 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:11567 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab3I2EDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 00:03:49 -0400
Message-ID: <5247A62B.7060405@huawei.com>
Date: Sun, 29 Sep 2013 12:01:47 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: IRQ SMP affinity Problem
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
   I found problems about irq affinity in my machine, I don't know whether it's my machine problem
or linux can not support irq affinity setting in my machine. Do you have time to help point out that?
Thank you very much!

According to your Documentation/IRQ-Affiniy.txt
I try to test irq affinity in my machine.
Because apic flat will only be selected when possible cpus < 8, But my machine CPUs > 8, really 24 cpus,
so I forced code to select apic flat model. like

 55 void __init default_setup_apic_routing(void)
 56 {
 57 #ifdef CONFIG_X86_X2APIC
 58         if (x2apic_mode
 59 #ifdef CONFIG_X86_UV
 60                        && apic != &apic_x2apic_uv_x
 61 #endif
 62                        ) {
 63                 if (x2apic_phys)
 64                         apic = &apic_x2apic_phys;
 65                 else
 66                         apic = &apic_x2apic_cluster;
 67         }
 68 #endif
 69 /*
 70         if (apic == &apic_flat && num_possible_cpus() > 8)     ----> I mask these two line codes to force kernel use apic flat.
 71                 apic = &apic_physflat;
 72 */
 73         printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);


dmesg:
.........
Performance Events: Westmere events, Intel PMU driver.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
ACPI: Core revision 20090903
Setting APIC routing to flat   ------------------------> apic use flat model now
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU           E5620  @ 2.40GHz stepping 02
Booting Node   1, Processors  #1 #2 #3
Brought up 4 CPUs
Total of 4 processors activated (19200.97 BogoMIPS).


linux-drf:/lib/modules/2.6.32.12-qiuxishi-5-default/source # cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 44
model name	: Intel(R) Xeon(R) CPU           E5620  @ 2.40GHz
stepping	: 2
cpu MHz		: 1600.000
cache size	: 12288 KB
physical id	: 1
siblings	: 4
core id		: 0
cpu cores	: 4
apicid		: 32
initial apicid	: 32
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt aes lahf_lm ida arat tpr_shadow vnmi flexpriority ept vpid
bogomips	: 4800.57
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

[.........................snip.............................]

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 44
model name	: Intel(R) Xeon(R) CPU           E5620  @ 2.40GHz
stepping	: 2
cpu MHz		: 1600.000
cache size	: 12288 KB
physical id	: 1
siblings	: 4
core id		: 10
cpu cores	: 4
apicid		: 52
initial apicid	: 52
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt aes lahf_lm ida arat tpr_shadow vnmi flexpriority ept vpid
bogomips	: 4800.15
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

linux-drf:/lib/modules/2.6.32.12-qiuxishi-5-default/source # cat /proc/interrupts
            CPU0       CPU1       CPU2       CPU3
   0:         84          0          0          5   IO-APIC-edge      timer
   ......................
  24:       2845          0          0          0   IO-APIC-fasteoi   eth2
  32:       8617       1201          0          0   IO-APIC-fasteoi   ioc0

linux-drf:/lib/modules/2.6.32.12-qiuxishi-5-default/source # cat /proc/irq/24/smp_affinity
ffffff

I try to set irq 24(eth2) affinity to all f, but irqs from eth2 always deliver to cpu0,
my machine cpu is Intel Xeon, so is linux cannot support irq affinity in Intel Xeon or something wrong in my test or irq setting?


I found Intel Programming Guide 3A 10.6.2 say:
"In operating systems that use the lowest priority delivery mode but do not update
the TPR, the TPR information saved in the chipset will potentially cause the interrupt
to be always delivered to the same processor from the logical set".


So in my Xeon machine, the irq affinity work is normal?




-- 
Thanks!
Yijing

