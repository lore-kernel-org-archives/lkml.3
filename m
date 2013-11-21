Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab3KUSvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 13:51:33 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:50292 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab3KUSvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 13:51:31 -0500
Date: Thu, 21 Nov 2013 13:51:20 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: LKML <linux-kernel@vger.kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: perf/poll: another perf_fuzzer lockup
Message-ID: <alpine.DEB.2.10.1311211346000.16856@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So I'm not sure what to make of this one.  I was trying to reproduce the 
sw_pagetable soft lockup and got the following instead.  I think it's
perf_event related as the fuzzer does stomp on poll() with perf_event fds 
but I am never sure exactly how to interpret the backtraces.

This is with 3.12 on a core2 machine.

Vince

[  199.784001] ------------[ cut here ]------------                             
[  199.784001] WARNING: CPU: 0 PID: 2801 at kernel/watchdog.c:245 watchdog_overflow_callback+0x9b/0xa6()                                                        
[  199.784001] Watchdog detected hard LOCKUP on cpu 0                           
[  199.784001] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative f71882fg evdev mcs7830 usbnet coretemp pcspkr psmouse serio_raw acpi_cpufreq wmi video ohci_pci processor button ohci_hcd i2c_nforce2 thermal_sys sg ehci_pci ehci_hcd sd_mod usbcore usb_common                       
[  199.784001] CPU: 0 PID: 2801 Comm: perf_fuzzer Not tainted 3.12.0 #4         
[  199.784001] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIOS 080015  10/19/2012                                                            
[  199.784001]  00000000000000f5 ffff88011fc07bc8 ffffffff8151d8ec 00000000000000f5                                                                             
[  199.784001]  ffff88011fc07c18 ffff88011fc07c08 ffffffff8103cda9 ffff88011fc07bf8                                                                             
[  199.784001]  ffffffff810a137f ffff88011b313400 0000000000000000 ffff88011fc07d48                                                                             
[  199.784001] Call Trace:                                                      
[  199.784001]  <NMI>  [<ffffffff8151d8ec>] dump_stack+0x49/0x5d                
[  199.784001]  [<ffffffff8103cda9>] warn_slowpath_common+0x81/0x9b             
[  199.784001]  [<ffffffff810a137f>] ? watchdog_overflow_callback+0x9b/0xa6     
[  199.784001]  [<ffffffff8103ce66>] warn_slowpath_fmt+0x46/0x48                
[  199.784001]  [<ffffffff810a137f>] watchdog_overflow_callback+0x9b/0xa6       
[  199.784001]  [<ffffffff810cbb94>] __perf_event_overflow+0x137/0x1c1          
[  199.784001]  [<ffffffff810cc23a>] perf_event_overflow+0x14/0x16              
[  199.784001]  [<ffffffff81018fbd>] intel_pmu_handle_irq+0x2b8/0x34d           
[  199.784001]  [<ffffffff81522253>] perf_event_nmi_handler+0x2d/0x4a           
[  199.784001]  [<ffffffff81521b86>] nmi_handle+0x5e/0x13a                      
[  199.784001]  [<ffffffff81521d0a>] do_nmi+0xa8/0x2c0                          
[  199.784001]  [<ffffffff81521337>] end_repeat_nmi+0x1e/0x2e                   
[  199.784001]  [<ffffffff81520abf>] ? _raw_spin_lock+0x26/0x2a                 
[  199.784001]  [<ffffffff81520abf>] ? _raw_spin_lock+0x26/0x2a                 
[  199.784001]  [<ffffffff81520abf>] ? _raw_spin_lock+0x26/0x2a                 
[  199.784001]  <<EOE>>  [<ffffffff81069ed5>] load_balance+0x2f2/0x609          
[  199.784001]  [<ffffffff8106a3d8>] idle_balance+0x9a/0x10c                    
[  199.784001]  [<ffffffff8151f5a6>] __schedule+0x290/0x54b                     
[  199.784001]  [<ffffffff8105beae>] ? __hrtimer_start_range_ns+0x2ed/0x2ff     
[  199.784001]  [<ffffffff8151fbbf>] schedule+0x64/0x66                         
[  199.784001]  [<ffffffff8151ed18>] schedule_hrtimeout_range_clock+0xed/0x134  
[  199.784001]  [<ffffffff8105b659>] ? update_rmtp+0x65/0x65                    
[  199.784001]  [<ffffffff8105beee>] ? hrtimer_start_range_ns+0x14/0x16         
[  199.784001]  [<ffffffff8151ed72>] schedule_hrtimeout_range+0x13/0x15         
[  199.784001]  [<ffffffff8112274d>] poll_schedule_timeout+0x48/0x64            
[  199.784001]  [<ffffffff81123453>] do_sys_poll+0x437/0x4d5                    
[  199.784001]  [<ffffffff811228cf>] ? __pollwait+0xcc/0xcc                     
[  199.784001]  [<ffffffff811228cf>] ? __pollwait+0xcc/0xcc                     
[  199.784001]  [<ffffffff811228cf>] ? __pollwait+0xcc/0xcc                     
[  199.784001]  [<ffffffff811228cf>] ? __pollwait+0xcc/0xcc                     
[  199.784001]  [<ffffffff811228cf>] ? __pollwait+0xcc/0xcc                     
[  199.784001]  [<ffffffff811228cf>] ? __pollwait+0xcc/0xcc                     
[  199.784001]  [<ffffffff811228cf>] ? __pollwait+0xcc/0xcc                     
[  199.784001]  [<ffffffff811228cf>] ? __pollwait+0xcc/0xcc                     
[  199.784001]  [<ffffffff811228cf>] ? __pollwait+0xcc/0xcc                     
[  199.784001]  [<ffffffff81123544>] SyS_poll+0x53/0xbc                         
[  199.784001]  [<ffffffff81527b56>] system_call_fastpath+0x1a/0x1f             
[  199.784001] ---[ end trace 1de1e48ddacc5178 ]---                             
[  199.784001] perf samples too long (7070598 > 10000), lowering kernel.perf_event_max_sample_rate to 12500                                                     
[  199.784001] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 933.271 msecs                                                                   
[  199.784001] perf samples too long (7015378 > 20000), lowering kernel.perf_event_max_sample_rate to 6250                                                      
[  199.784001] perf samples too long (6960587 > 40000), lowering kernel.perf_event_max_sample_rate to 3250                                                      
[  199.784001] perf samples too long (6906224 > 76923), lowering kernel.perf_event_max_sample_rate to 1750                                                      
[  199.784001] perf samples too long (6852286 > 142857), lowering kernel.perf_event_max_sample_rate to 1000                                                     
[  199.784001] perf samples too long (6798770 > 250000), lowering kernel.perf_event_max_sample_rate to 500                                                      
[  199.784001] perf samples too long (6745671 > 500000), lowering kernel.perf_event_max_sample_rate to 250                                                      
