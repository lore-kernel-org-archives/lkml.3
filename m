Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030234AbaDBUBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:01:08 -0400
Received: from mail1.windriver.com ([147.11.146.13]:49362 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964779AbaDBUBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:01:06 -0400
Message-ID: <533C6C90.3000708@windriver.com>
Date: Wed, 2 Apr 2014 16:01:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Brown, Len" <len.brown@intel.com>
CC: "WYSOCKI, RAFAL" <rafael.j.wysocki@intel.com>,
        Arne Bockholdt <linux-kernel@bockholdt.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Regression in intel_idle on Avaton/Rangely Mohon Peak board
References: <533B0288.2020304@windriver.com> <1A7043D5F58CCB44A599DFD55ED4C948452FD582@FMSMSX106.amr.corp.intel.com>
In-Reply-To: <1A7043D5F58CCB44A599DFD55ED4C948452FD582@FMSMSX106.amr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.56.57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-04-01 05:59 PM, Brown, Len wrote:
>> I've got an eval board with a 1.7GHz Avaton/C2000 that hangs at boot
>> shortly after the idle driver registration -- typically 1/2 dozen
>> dmesg lines later, around rtc init, or net stack init.
> 
> Paul,
> Please boot the failing board with "intel_idle.max_cstate=0"
> to disable intel_idle entirely, and then show the C-states
> exported by acpi_idle, that predumably, are stable on both boards:
> 
> dmesg | grep idle
> grep . /sys/devices/system/cpu/cpu0/cpuidle/*/*
> 
> Then go back and boot with "intel_idle.max_cstate=N"
> where N is incremented by 1 until when the system fails
> and note the largest N that still works.

The dying board works for N=1, fails for N=2.

root@localhost:/sys/devices/system/cpu/cpuidle# grep . *
current_driver:intel_idle
current_governor_ro:menu
root@localhost:/sys/devices/system/cpu/cpuidle# dmesg|grep idle
[    0.000000] Command line: BOOT_IMAGE=/boot/bzImage-current console=tty0 noinitrd root=/dev/sda4 rw ip=dhcp selinux=0 enforcing=0 intel_idle.max_cstate=1
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/bzImage-current console=tty0 noinitrd root=/dev/sda4 rw ip=dhcp selinux=0 enforcing=0 intel_idle.max_cstate=1
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.217203] cpuidle: using governor ladder
[    0.217309] cpuidle: using governor menu
[    0.840598] intel_idle: MWAIT substates: 0x33000020
[    0.840662] intel_idle: v0.4 model 0x4D
[    0.840668] intel_idle: lapic_timer_reliable_states 0x2
[    0.840673] intel_idle: max_cstate 1 reached
root@localhost:/sys/devices/system/cpu/cpuidle#

Another interesting data point -- the dying board doesn't die if
I boot 3.14's x86-64 defconfig.  Nothing immediately jumps out at
me in the dying .config ; there are a few tweaks in there like
RCU_NOCB etc. that I'll have to weed out with a pseudo .config
bisect I guess....

I'll go get the N=1 and N=2 data for the working board next.

Paul.
--

> 
>> The interesting part is that a nearly identical board, but with
>> different (newer/faster) CPU and newer BIOS doesn't have the hang.
> 
> Possibly an electrical bug in the earlier board.
> Maybe they worked around it by disabling a C-state in ACPI
> and didn't test upstream Linux?
> 
> I'd be interested in the acpi_idle output above for both the
> new and old boards to see if they are exporting different states
> on the two boards.
> 
> dmidecode isn't useful in this case.  The CPUID in /proc/cpuinfo
> may be useful if the problem turns out to be associated with
> some stepping.
> 
> thanks,
> -Len
> 
