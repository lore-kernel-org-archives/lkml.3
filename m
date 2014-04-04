Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbaDDT14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 15:27:56 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:46585 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaDDT1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 15:27:53 -0400
Date: Fri, 4 Apr 2014 14:28:00 -0500
From: Shaun Ruffell <sruffell@digium.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: Regression in 3.14: BUG in get_next_timer_interrupt()
Message-ID: <20140404192800.GA26301@digium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just updated one of my development machines to 3.14 from 3.12.5
and hit a BUG in get_next_timer_interrupt().

In order to get to this point, I had to apply commit (30f2555 "ipv6:
some ipv6 statistic counters failed to disable bh") from the current
master on top of 3.14 to get around a lockdep splat. I then also
just updated to the current master, as of April 3 2014 -
4a4389abdd9822fdf3c, and still hit the BUG.

It is consistently reproduceable when I login to the machine over
ssh. I don't have time right now to start searching for the source
but thought I would throw this out there in case someone else hits
it.

   BUG: unable to handle kernel paging request at 6b6b6b77
   IP: [<c104cb10>] get_next_timer_interrupt+0x140/0x230
   *pde = 00000000
   Oops: 0000 [#1] SMP
   Modules linked in: ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter ip_tables tun bridge stp cpufreq_powersave llc autofs4 cpufreq_ondemand ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 ppdev iTCO_wdt iTCO_vendor_support parport_pc parport microcode ipmi_si ipmi_msghandler video pcspkr sg i2c_i801 i2c_core lpc_ich mfd_core e1000e ptp pps_core acpi_cpufreq ext4 jbd2 mbcache sd_mod crc_t10dif crct10dif_common ahci libahci dm_mirror dm_region_hash dm_log dm_mod
   CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.14.0.sruffell.debug+ #33
   Hardware name: Intel Corporation S1200BTL/S1200BTL, BIOS S1200BT.86B.02.00.0035.030220120927 03/02/2012
   task: f4dfda00 ti: f4e2a000 task.ti: f4e2a000
   EIP: 0060:[<c104cb10>] EFLAGS: 00210007 CPU: 2
   EIP is at get_next_timer_interrupt+0x140/0x230
   EAX: 6b6b6b6b EBX: 3ffd091a ECX: f4e54a24 EDX: 00000000
   ESI: 00000011 EDI: f4e5499c EBP: f4e2befc ESP: f4e2bec8
    DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
   CR0: 80050033 CR2: 6b6b6b77 CR3: 019a3000 CR4: 000407d0
   Stack:
    00000000 00fffd0a fffd091a 3ffd0919 f4e54160 0000000a f4e5499c f4e54b9c
    f4e54d9c f4e54f9c d98e39d9 00000000 f54c2260 f4e2bf54 c10b7325 00000002
    00000001 00000000 c10b7520 9d48a980 00000018 c1074e4e 9d4a60c0 00000018
   Call Trace:
    [<c10b7325>] tick_nohz_stop_sched_tick+0x265/0x3d0
    [<c10b7520>] ? __tick_nohz_idle_enter+0x90/0x130
    [<c1074e4e>] ? sched_clock_cpu+0x13e/0x150
    [<c10b7520>] __tick_nohz_idle_enter+0x90/0x130
    [<c1078e75>] ? set_cpu_sd_state_idle+0x85/0xa0
    [<c10b7622>] tick_nohz_idle_enter+0x32/0x60
    [<c1084f93>] cpu_idle_loop+0x23/0x1c0
    [<c10b4792>] ? clockevents_config_and_register+0x22/0x30
    [<c108514f>] cpu_startup_entry+0x1f/0x30
    [<c102d956>] start_secondary+0x96/0xb0
   Code: 8b 45 dc 05 3c 0e 00 00 89 45 f0 8b 45 d0 83 e0 3f 89 45 e0 89 c6 90 8d 74 26 00 8b 04 f7 8d 0c f7 39 c8 74 1f 8d b6 00 00 00 00 <f6> 40 0c 01 75 0d 8b 50 08 39 da 0f 48 da ba 01 00 00 00 8b 00
   EIP: [<c104cb10>] get_next_timer_interrupt+0x140/0x230 SS:ESP 0068:f4e2bec8
   CR2: 000000006b6b6b77
   ---[ end trace b98242504b80ebf5 ]---

Cheers,
Shaun
