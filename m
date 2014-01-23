Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765AbaAWNG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 08:06:27 -0500
Received: from bitcube.co.uk ([109.74.192.214]:33299 "EHLO mail.bitcube.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466AbaAWNGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 08:06:24 -0500
X-Greylist: delayed 510 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Jan 2014 08:06:24 EST
Message-ID: <52E111C3.6090300@smop.co.uk>
Date: Thu, 23 Jan 2014 12:57:39 +0000
From: Adrian Bridgett <adrian@smop.co.uk>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Mysterious hard hangs on 3.11.0-15
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We recently upgraded our hadoop cluster from 3.5.0 to 3.11.0 and started 
experiencing unusual lockups.  Everything will be fine (busy, load 
average of say 90) and then the load will jump up to 500 or so and the 
box will stop responding (ping might work briefly), DRAC (Dell's remote 
management cards) just show a blank screen and the box is unresponsive.  
Something about the load we are running seems to be causing this as 
we'll have several nodes do this within a few minute of each other.   
I'm wondering if it's a stray job, we do use cgroups to limit the cpu 
and memory (as we have other stuff on that cluster which is more 
important than hadoop) and this often fires just before (we have some 
jobs that need improving).  Nothing in the logs at all.  We've 
downgraded the boxes and they are happy again.

Fortunately one machine eventually logged a hard lockup and lots of soft 
lockups.  It's a 5000 line output so I've just put the head portion 
here, full code here
http://pastebin.ca/2577620 or please ping me.

2014-01-18T13:48:27.853241+00:00 bl-cassoop-p11 kernel: [74679.844989] 
Memory cgroup out of memory: Kill process 36617 (java) score 27 or 
sacrifice child
2014-01-18T13:48:51.796175+00:00 bl-cassoop-p11 kernel: [74698.770893] 
------------[ cut here ]------------
2014-01-18T13:48:51.796195+00:00 bl-cassoop-p11 kernel: [74698.770904] 
WARNING: CPU: 15 PID: 36402 at 
/build/buildd/linux-lts-saucy-3.11.0/kernel/watchdog.c:245 
watchdog_overflow_callback+0x9a/0xc0()
2014-01-18T13:48:51.796198+00:00 bl-cassoop-p11 kernel: [74698.770905] 
Watchdog detected hard LOCKUP on cpu 15
2014-01-18T13:48:51.796202+00:00 bl-cassoop-p11 kernel: [74698.770907] 
Modules linked in: mpt2sas scsi_transport_sas raid_class mptctl mptbase 
ipmi_si ipmi_devintf ipmi_msghandler dell_rbu ext2 bonding vesafb dcdbas 
gpio_ich mei_me shpchp mei joydev sb_edac lpc_ich edac_core wmi mac_hid 
acpi_power_meter coretemp hid_generic usbhid hid ixgbe tg3 dca ptp mdio 
pps_core [last unloaded: ipmi_si]
2014-01-18T13:48:51.796205+00:00 bl-cassoop-p11 kernel: [74698.770928] 
CPU: 15 PID: 36402 Comm: java Tainted: G        W 3.11.0-15-generic 
#23~precise1-Ubuntu
2014-01-18T13:48:51.796207+00:00 bl-cassoop-p11 kernel: [74698.770929] 
Hardware name: Dell Inc. PowerEdge R720xd/0X6H47, BIOS 2.1.3 11/20/2013
2014-01-18T13:48:51.796208+00:00 bl-cassoop-p11 kernel: [74698.770931]  
00000000000000f5 ffff88301f2e7ba8 ffffffff8173bc0e 0000000000000007
2014-01-18T13:48:51.796210+00:00 bl-cassoop-p11 kernel: [74698.770936]  
ffff88301f2e7bf8 ffff88301f2e7be8 ffffffff810653ac 0000000000000000
2014-01-18T13:48:51.796211+00:00 bl-cassoop-p11 kernel: [74698.770938]  
ffff882ffa548000 0000000000000000 ffff88301f2e7d20 0000000000000000
2014-01-18T13:48:51.796212+00:00 bl-cassoop-p11 kernel: [74698.770941] 
Call Trace:
2014-01-18T13:48:51.796215+00:00 bl-cassoop-p11 kernel: [74698.770943]  
<NMI>  [<ffffffff8173bc0e>] dump_stack+0x46/0x58
2014-01-18T13:48:51.796218+00:00 bl-cassoop-p11 kernel: [74698.770955]  
[<ffffffff810653ac>] warn_slowpath_common+0x8c/0xc0
2014-01-18T13:48:51.796220+00:00 bl-cassoop-p11 kernel: [74698.770958]  
[<ffffffff81065496>] warn_slowpath_fmt+0x46/0x50
2014-01-18T13:48:51.796223+00:00 bl-cassoop-p11 kernel: [74698.770960]  
[<ffffffff810fbf8a>] watchdog_overflow_callback+0x9a/0xc0
2014-01-18T13:48:51.796251+00:00 bl-cassoop-p11 kernel: [74698.770965]  
[<ffffffff8113f9cc>] __perf_event_overflow+0x9c/0x220
2014-01-18T13:48:51.796254+00:00 bl-cassoop-p11 kernel: [74698.770970]  
[<ffffffff81029828>] ? x86_perf_event_set_period+0xd8/0x150
2014-01-18T13:48:51.796255+00:00 bl-cassoop-p11 kernel: [74698.770973]  
[<ffffffff811402d4>] perf_event_overflow+0x14/0x20
2014-01-18T13:48:51.796257+00:00 bl-cassoop-p11 kernel: [74698.770977]  
[<ffffffff81030ff6>] intel_pmu_handle_irq+0x1a6/0x2a0
2014-01-18T13:48:51.796260+00:00 bl-cassoop-p11 kernel: [74698.770982]  
[<ffffffff811813d1>] ? unmap_kernel_range_noflush+0x11/0x20
2014-01-18T13:48:51.796262+00:00 bl-cassoop-p11 kernel: [74698.770987]  
[<ffffffff81426163>] ? ghes_copy_tofrom_phys+0x113/0x210
2014-01-18T13:48:51.796263+00:00 bl-cassoop-p11 kernel: [74698.770992]  
[<ffffffff817496a4>] perf_event_nmi_handler+0x34/0x60
2014-01-18T13:48:51.796265+00:00 bl-cassoop-p11 kernel: [74698.770995]  
[<ffffffff81748caa>] nmi_handle.isra.3+0x8a/0x1a0
2014-01-18T13:48:51.796278+00:00 bl-cassoop-p11 kernel: [74698.770998]  
[<ffffffff81427160>] ? ghes_print_estatus.constprop.10+0x70/0x70
2014-01-18T13:48:51.796280+00:00 bl-cassoop-p11 kernel: [74698.771000]  
[<ffffffff81748f39>] default_do_nmi+0xe9/0x240
2014-01-18T13:48:51.796281+00:00 bl-cassoop-p11 kernel: [74698.771003]  
[<ffffffff81749120>] do_nmi+0x90/0xd0
2014-01-18T13:48:51.796284+00:00 bl-cassoop-p11 kernel: [74698.771006]  
[<ffffffff817481c1>] end_repeat_nmi+0x1e/0x2e
2014-01-18T13:48:51.796286+00:00 bl-cassoop-p11 kernel: [74698.771011]  
[<ffffffff813817d3>] ? __write_lock_failed+0x13/0x20
2014-01-18T13:48:51.796287+00:00 bl-cassoop-p11 kernel: [74698.771014]  
[<ffffffff813817d3>] ? __write_lock_failed+0x13/0x20
2014-01-18T13:48:51.796289+00:00 bl-cassoop-p11 kernel: [74698.771016]  
[<ffffffff813817d3>] ? __write_lock_failed+0x13/0x20
2014-01-18T13:48:51.796291+00:00 bl-cassoop-p11 kernel: [74698.771017]  
<<EOE>>  [<ffffffff8174787e>] _raw_write_lock_irq+0x1e/0x20
2014-01-18T13:48:51.796292+00:00 bl-cassoop-p11 kernel: [74698.771023]  
[<ffffffff810676e5>] forget_original_parent+0x35/0x1a0
2014-01-18T13:48:51.796294+00:00 bl-cassoop-p11 kernel: [74698.771026]  
[<ffffffff81067867>] exit_notify+0x17/0x110
2014-01-18T13:48:51.796296+00:00 bl-cassoop-p11 kernel: [74698.771028]  
[<ffffffff81067f84>] do_exit+0x1f4/0x480
2014-01-18T13:48:51.796298+00:00 bl-cassoop-p11 kernel: [74698.771034]  
[<ffffffff8107511b>] ? __dequeue_signal+0x6b/0xb0
2014-01-18T13:48:51.796300+00:00 bl-cassoop-p11 kernel: [74698.771036]  
[<ffffffff810682a4>] do_group_exit+0x44/0xa0
2014-01-18T13:48:51.796301+00:00 bl-cassoop-p11 kernel: [74698.771039]  
[<ffffffff81078281>] get_signal_to_deliver+0x231/0x480
2014-01-18T13:48:51.796303+00:00 bl-cassoop-p11 kernel: [74698.771045]  
[<ffffffff81013c57>] do_signal+0x47/0x140
2014-01-18T13:48:51.796305+00:00 bl-cassoop-p11 kernel: [74698.771049]  
[<ffffffff8108cee4>] ? hrtimer_start_range_ns+0x14/0x20
2014-01-18T13:48:51.796306+00:00 bl-cassoop-p11 kernel: [74698.771055]  
[<ffffffff810ca0c8>] ? do_futex+0xd8/0x1b0
2014-01-18T13:48:51.796308+00:00 bl-cassoop-p11 kernel: [74698.771057]  
[<ffffffff81013dd8>] do_notify_resume+0x88/0xc0
2014-01-18T13:48:51.796309+00:00 bl-cassoop-p11 kernel: [74698.771060]  
[<ffffffff81747c7c>] retint_signal+0x48/0x8c
2014-01-18T13:48:51.796311+00:00 bl-cassoop-p11 kernel: [74698.771061] 
---[ end trace 51e5206791572efe ]---
2014-01-18T13:48:51.796313+00:00 bl-cassoop-p11 kernel: [74703.802920] 
BUG: soft lockup - CPU#30 stuck for 23s! [java:36244]
2014-01-18T13:48:51.796317+00:00 bl-cassoop-p11 kernel: [74703.809108] 
Modules linked in: mpt2sas scsi_transport_sas raid_class mptctl mptbase 
ipmi_si ipmi_devintf ipmi_msghandler dell_rbu ext2 bonding vesafb dcdbas 
gpio_ich mei_me shpchp mei joydev sb_edac lpc_ich edac_core wmi mac_hid 
acpi_power_meter coretemp hid_generic usbhid hid ixgbe tg3 dca ptp mdio 
pps_core [last unloaded: ipmi_si]
2014-01-18T13:48:51.796319+00:00 bl-cassoop-p11 kernel: [74703.809136] 
CPU: 30 PID: 36244 Comm: java Tainted: G        W 3.11.0-15-generic 
#23~precise1-Ubuntu
2014-01-18T13:48:51.796320+00:00 bl-cassoop-p11 kernel: [74703.809137] 
Hardware name: Dell Inc. PowerEdge R720xd/0X6H47, BIOS 2.1.3 11/20/2013
2014-01-18T13:48:51.796322+00:00 bl-cassoop-p11 kernel: [74703.809140] 
task: ffff881894a69770 ti: ffff88188471e000 task.ti: ffff88188471e000
2014-01-18T13:48:51.796362+00:00 bl-cassoop-p11 kernel: [74703.809142] 
RIP: 0010:[<ffffffff810cb4a6>] [<ffffffff810cb4a6>] 
generic_exec_single+0x86/0xb0
2014-01-18T13:48:51.796364+00:00 bl-cassoop-p11 kernel: [74703.809148] 
RSP: 0018:ffff88188471f868  EFLAGS: 00000202
2014-01-18T13:48:51.796366+00:00 bl-cassoop-p11 kernel: [74703.809150] 
RAX: 0000000000000286 RBX: ffff88187fffcb08 RCX: 0000000000000001
2014-01-18T13:48:51.796367+00:00 bl-cassoop-p11 kernel: [74703.809151] 
RDX: ffff881887d73470 RSI: 0000000000000286 RDI: 0000000000000286
2014-01-18T13:48:51.796369+00:00 bl-cassoop-p11 kernel: [74703.809153] 
RBP: ffff88188471f8a8 R08: ffff882ff7b925d0 R09: 0000000000000100
2014-01-18T13:48:51.796370+00:00 bl-cassoop-p11 kernel: [74703.809154] 
R10: 00000000000035de R11: 0000000000000001 R12: 0000000000000000
2014-01-18T13:48:51.796372+00:00 bl-cassoop-p11 kernel: [74703.809156] 
R13: ffff88187fffcb00 R14: ffff88187fffcb08 R15: ffffffff00000000
2014-01-18T13:48:51.796374+00:00 bl-cassoop-p11 kernel: [74703.809158] 
FS:  00007ff4881c1700(0000) GS:ffff88181fbe0000(0000) knlGS:0000000000000000
2014-01-18T13:48:51.796375+00:00 bl-cassoop-p11 kernel: [74703.809160] 
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
2014-01-18T13:48:51.796376+00:00 bl-cassoop-p11 kernel: [74703.809162] 
CR2: 00007f9151de8880 CR3: 0000000001c0d000 CR4: 00000000000407e0
2014-01-18T13:48:51.796378+00:00 bl-cassoop-p11 kernel: [74703.809164] 
Stack:
2014-01-18T13:48:51.796379+00:00 bl-cassoop-p11 kernel: [74703.809165]  
ffff88284c8d0000 ffff881887d73470 0000000000000003 000000000000000f
2014-01-18T13:48:51.796381+00:00 bl-cassoop-p11 kernel: [74703.809172]  
ffffffff8105ae90 000000000000001e ffffffff81d03da0 000000000000001e
2014-01-18T13:48:51.796382+00:00 bl-cassoop-p11 kernel: [74703.809176]  
ffff88188471f918 ffffffff810cb5a5 ffff88188471f8d8 ffff88188471f8d8
2014-01-18T13:48:51.796384+00:00 bl-cassoop-p11 kernel: [74703.809181] 
Call Trace:
2014-01-18T13:48:51.796386+00:00 bl-cassoop-p11 kernel: [74703.809188]  
[<ffffffff8105ae90>] ? leave_mm+0x70/0x70
2014-01-18T13:48:51.796388+00:00 bl-cassoop-p11 kernel: [74703.809191]  
[<ffffffff810cb5a5>] smp_call_function_single+0xd5/0x160
2014-01-18T13:48:51.796390+00:00 bl-cassoop-p11 kernel: [74703.809195]  
[<ffffffff8105ae90>] ? leave_mm+0x70/0x70
2014-01-18T13:48:51.796391+00:00 bl-cassoop-p11 kernel: [74703.809198]  
[<ffffffff8105ae90>] ? leave_mm+0x70/0x70
2014-01-18T13:48:51.796393+00:00 bl-cassoop-p11 kernel: [74703.809201]  
[<ffffffff810cb9b7>] smp_call_function_many+0x287/0x2d0
2014-01-18T13:48:51.796395+00:00 bl-cassoop-p11 kernel: [74703.809206]  
[<ffffffff81733789>] ? memcg_check_events.part.44+0x8c/0xa5
2014-01-18T13:48:51.796397+00:00 bl-cassoop-p11 kernel: [74703.809210]  
[<ffffffff8105afee>] native_flush_tlb_others+0x2e/0x30
2014-01-18T13:48:51.796399+00:00 bl-cassoop-p11 kernel: [74703.809214]  
[<ffffffff8105b0d0>] flush_tlb_mm_range+0x70/0x230
2014-01-18T13:48:51.796401+00:00 bl-cassoop-p11 kernel: [74703.809220]  
[<ffffffff8116f30c>] tlb_flush_mmu+0x3c/0xa0
2014-01-18T13:48:51.796402+00:00 bl-cassoop-p11 kernel: [74703.809223]  
[<ffffffff81171190>] zap_pte_range+0x250/0x450
2014-01-18T13:48:51.796404+00:00 bl-cassoop-p11 kernel: [74703.809226]  
[<ffffffff81171556>] unmap_page_range+0x1c6/0x320
2014-01-18T13:48:51.796406+00:00 bl-cassoop-p11 kernel: [74703.809231]  
[<ffffffff81155a73>] ? __pagevec_lru_add_fn+0x103/0x230
2014-01-18T13:48:51.796407+00:00 bl-cassoop-p11 kernel: [74703.809235]  
[<ffffffff81171737>] unmap_single_vma+0x87/0x100
2014-01-18T13:48:51.796409+00:00 bl-cassoop-p11 kernel: [74703.809238]  
[<ffffffff81171fe4>] unmap_vmas+0x54/0xa0
2014-01-18T13:48:51.796411+00:00 bl-cassoop-p11 kernel: [74703.809242]  
[<ffffffff8117a5cc>] exit_mmap+0x9c/0x170
2014-01-18T13:48:51.796413+00:00 bl-cassoop-p11 kernel: [74703.809247]  
[<ffffffff8174621a>] ? io_schedule+0xaa/0xd0
2014-01-18T13:48:51.796414+00:00 bl-cassoop-p11 kernel: [74703.809251]  
[<ffffffff81062fea>] mmput.part.22+0x4a/0x110
2014-01-18T13:48:51.796416+00:00 bl-cassoop-p11 kernel: [74703.809254]  
[<ffffffff810630d9>] mmput+0x29/0x30
2014-01-18T13:48:51.796417+00:00 bl-cassoop-p11 kernel: [74703.809258]  
[<ffffffff81067d46>] exit_mm+0x146/0x190
2014-01-18T13:48:51.796419+00:00 bl-cassoop-p11 kernel: [74703.809263]  
[<ffffffff8110b2cb>] ? taskstats_exit+0x1cb/0x270
2014-01-18T13:48:51.796420+00:00 bl-cassoop-p11 kernel: [74703.809266]  
[<ffffffff81067ef3>] do_exit+0x163/0x480
2014-01-18T13:48:51.796422+00:00 bl-cassoop-p11 kernel: [74703.809271]  
[<ffffffff8107511b>] ? __dequeue_signal+0x6b/0xb0
2014-01-18T13:48:51.796424+00:00 bl-cassoop-p11 kernel: [74703.809275]  
[<ffffffff810682a4>] do_group_exit+0x44/0xa0
2014-01-18T13:48:51.796426+00:00 bl-cassoop-p11 kernel: [74703.809278]  
[<ffffffff81078281>] get_signal_to_deliver+0x231/0x480
2014-01-18T13:48:51.796427+00:00 bl-cassoop-p11 kernel: [74703.809284]  
[<ffffffff81013c57>] do_signal+0x47/0x140
2014-01-18T13:48:51.796429+00:00 bl-cassoop-p11 kernel: [74703.809289]  
[<ffffffff811b42e4>] ? vfs_read+0xb4/0x180
2014-01-18T13:48:51.796430+00:00 bl-cassoop-p11 kernel: [74703.809292]  
[<ffffffff81013dd8>] do_notify_resume+0x88/0xc0
2014-01-18T13:48:51.796432+00:00 bl-cassoop-p11 kernel: [74703.809297]  
[<ffffffff81750c1a>] int_signal+0x12/0x17
2014-01-18T13:48:51.796435+00:00 bl-cassoop-p11 kernel: [74703.809299] 
Code: 89 5d 08 4c 89 2b 48 89 53 08 48 89 1a e8 d3 c0 67 00 4c 3b 6d c8 
74 2b 45 85 ff 75 0a eb 0e 66 0f 1f 44 00 00 f3 90 f6 43 20 01 <75> f8 
48 8b 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d
2014-01-18T13:48:55.443947+00:00 bl-cassoop-p11 kernel: [74707.452254] 
BUG: soft lockup - CPU#0 stuck for 22s! [java:42506]
....

Thanks for any help/advice - more than happy to help in any way I can,

Adrian

