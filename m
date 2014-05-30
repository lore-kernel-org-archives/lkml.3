Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbaE3Bhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:37:37 -0400
Received: from ns.horizon.com ([71.41.210.147]:36937 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753464AbaE3Bhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:37:36 -0400
Date: 29 May 2014 21:37:34 -0400
Message-ID: <20140530013734.13780.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tim.c.chen@linux.intel.com
Subject: Re: [RFC PATCH] crypto: crc32c-pclmul - Use pmovzxdq to shrink K_table
Cc: herbert@gondor.apana.org.au, james.guilford@intel.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1401412036.2970.459.camel@schen9-DESK>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is odd.  On my Ivy Bridge system the CPU speed from /proc/cpuinfo 
> is at max freq once I set the performance governor.  
> The numbers above almost look like
> the cpu frequency is fluctuating and an average is taken.
> What version of the kernel are you running?  Is 
> CONFIG_CPU_FREQ_GOV_PERFORMANCE compiled in?

Yes; I have

CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

However scaling_available_governor only lists "performance powersave"

> Does /sys/devices/system/cpu/cpu?/cpufreq/scaling_cur_freq
> also changes?

That fine does not exist.  However,
/sys/devices/system/cpu/cpu?/cpufreq/cpuinfo_cur_freq
exists and changes.  Several snapshots:

	Snap1	Snap2	Snap3	Snap4
cpu0	1255875	1255875	1255875	1255875
cpu1	1202750 1202750 1202750 1415250
cpu2	1680875 1255875 1468375 1468375
cpu3	1202750 1255875 1521500 1521500
cpu4	1946500 1255875 1255875 1255875
cpu5	2690250 2371500 1946500 1734000

> Can you check what are the available governors in your system
> and available frequencies?

> cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
performance powersave
> cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
cat: /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies: No such file or directory
$ ls /sys/devices/system/cpu/cpu0/cpufreq/
affected_cpus     cpuinfo_transition_latency   scaling_governor
cpuinfo_cur_freq  related_cpus                 scaling_max_freq
cpuinfo_max_freq  scaling_available_governors  scaling_min_freq
cpuinfo_min_freq  scaling_driver               scaling_setspeed
$ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed
<unsupported>

> If userspace governor is available, you can try set the governor
> to userspace, then pin frequency to 3400 MHz (assuming that's your
> max) with command like:

I'll have to recompile and reboot, but sure.

Do you want me to change from the intel_pstate driver while I'm at it?

> BTW, why do you place the K table in .text, instead of .rodata? 

Because the jump table before it was in .text, and if I try to move
*that* to .rodata I get a linker error.  So I just put the K_table
right next to it.

However, it's all moot: my current v3 does move K_table to .rodata.
