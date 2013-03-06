Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3CFTHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 14:07:45 -0500
Received: from usindpps05.hds.com ([207.126.252.18]:54053 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab3CFTHn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 14:07:43 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "H. Peter Anvin (hpa@zytor.com)" <hpa@zytor.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: [PATCH]Skip unnecessary WARN_ON in panic case
Thread-Topic: [PATCH]Skip unnecessary WARN_ON in panic case
Thread-Index: Ac4anDzq+rG7ySZjS3KQDJuvdM1EoA==
Date: Wed, 6 Mar 2013 19:06:46 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41AF5CB8B@USINDEM103.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-03-06_05:2013-03-06,2013-03-06,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1303060164
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Problem]

When kernel panics, unnecessary WARN_ON() may be printed after panic messages in a following scenario.
 - A panicked cpu stops other cpus via smp_send_stop().
 - Other cpus turn to be offline in stop_this_cpu().
 - The panicked cpu enables interrupt.
 - native_smp_send_reschedule() is called via a timer interrupt on the panicked cpu.
 - The panicked cpu tries to send a reschedule IPI to other cpus
 - The panicked cpu hits WARN_ON() because other cpus have already been offlined.

If an user has just a VGA console, panic messages may be missed because they are floated outside a screen 
due to messages of the WARN_ON().
In this case, it could be difficult to investigate the reason why a kernel panicked.

Here is an actual result of the scenario above.

SysRq : Trigger a crash
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff81346056>] sysrq_handle_crash+0x16/0x20
PGD 127f0c067 PUD 11c7fd067 PMD 0 
Oops: 0002 [#1] SMP 
Modules linked in: ebtable_nat ebtables xt_CHECKSUM iptable_mangle bridge autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 vfat fat vhost_net macvtap macvlan tun uinput sg iTCO_wdt iTCO_vendor_support dcdbas acpi_cpufreq freq_table mperf coretemp kvm_intel kvm crc32c_intel microcode pcspkr i7core_edac edac_core lpc_ich mfd_core bnx2 ext4(F) mbcache(F) jbd2(F) sr_mod(F) cdrom(F) sd_mod(F) crc_t10dif(F) pata_acpi(F) ata_generic(F) ata_piix(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F)
CPU 2 
Pid: 4225, comm: bash Tainted: GF            3.9.0-rc1+ #9 Dell Inc. PowerEdge T310/02P9X9
RIP: 0010:[<ffffffff81346056>]  [<ffffffff81346056>] sysrq_handle_crash+0x16/0x20
RSP: 0018:ffff8801298b1e18  EFLAGS: 00010096
RAX: 000000000000000f RBX: 0000000000000063 RCX: ffff88013f24fb10
RDX: 0000000000000000 RSI: ffff88013f24df08 RDI: 0000000000000063
RBP: ffff8801298b1e18 R08: 0000000000000003 R09: 00000000000115e4
R10: 0000000000000371 R11: 0000000000000372 R12: ffffffff81aa5a40
R13: 0000000000000286 R14: 0000000000000007 R15: 0000000000000000
FS:  00007fcaed1b1700(0000) GS:ffff88013f240000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000128d91000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process bash (pid: 4225, threadinfo ffff8801298b0000, task ffff880128d15580)
Stack:
 ffff8801298b1e58 ffffffff81346969 ffff8801298b1f38 0000000000000002
 ffff880129605e80 00007fcaed1c2000 0000000000000002 fffffffffffffffb
 ffff8801298b1e88 ffffffff81346a1a ffff8801298b1eb8 00007fcaed1c2000
Call Trace:
 [<ffffffff81346969>] __handle_sysrq+0x129/0x190
 [<ffffffff81346a1a>] write_sysrq_trigger+0x4a/0x50
 [<ffffffff811e4cb9>] proc_reg_write+0x79/0xb0
 [<ffffffff8117f104>] vfs_write+0xb4/0x130
 [<ffffffff8117f8cf>] sys_write+0x5f/0xa0
 [<ffffffff81570a19>] system_call_fastpath+0x16/0x1b
Code: 48 81 c7 08 08 00 00 e8 c9 1b 22 00 31 c0 e9 62 ff ff ff 90 90 55 48 89 e5 66 66 66 66 90 c7 05 cd 02 9f 00 01 00 00 00 0f ae f8 <c6> 04 25 00 00 00 00 01 c9 c3 55 48 89 e5 66 66 66 66 90 8d 47 
RIP  [<ffffffff81346056>] sysrq_handle_crash+0x16/0x20
 RSP <ffff8801298b1e18>
CR2: 0000000000000000
---[ end trace b3d5243c59d80623 ]---
Kernel panic - not syncing: Fatal exception
------------[ cut here ]------------
WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x5c/0x60()
Hardware name: PowerEdge T310
Modules linked in: ebtable_nat ebtables xt_CHECKSUM iptable_mangle bridge autofs4 sunrpc 8021q garp stp llc cpufreq_ondemand ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ipv6 vfat fat vhost_net macvtap macvlan tun uinput sg iTCO_wdt iTCO_vendor_support dcdbas acpi_cpufreq freq_table mperf coretemp kvm_intel kvm crc32c_intel microcode pcspkr i7core_edac edac_core lpc_ich mfd_core bnx2 ext4(F) mbcache(F) jbd2(F) sr_mod(F) cdrom(F) sd_mod(F) crc_t10dif(F) pata_acpi(F) ata_generic(F) ata_piix(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F)
Pid: 4225, comm: bash Tainted: GF     D      3.9.0-rc1+ #9
Call Trace:
 <IRQ>  [<ffffffff81056daf>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff81056e0a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff8103918c>] native_smp_send_reschedule+0x5c/0x60
 [<ffffffff81092976>] trigger_load_balance+0x1c6/0x240
 [<ffffffff81089fff>] scheduler_tick+0x10f/0x140
 [<ffffffff81066f29>] update_process_times+0x69/0x80
 [<ffffffff810b1859>] tick_sched_handle+0x39/0x80
 [<ffffffff810b1a84>] tick_sched_timer+0x54/0x90
 [<ffffffff8107f1a3>] __run_hrtimer+0x83/0x1d0
 [<ffffffff810b1a30>] ? tick_nohz_handler+0xc0/0xc0
 [<ffffffff8107f576>] hrtimer_interrupt+0xf6/0x240
 [<ffffffff810435d6>] hpet_interrupt_handler+0x16/0x40
 [<ffffffff810e0f8d>] handle_irq_event_percpu+0x6d/0x210
 [<ffffffff8105f745>] ? __do_softirq+0x165/0x260
 [<ffffffff810e1172>] handle_irq_event+0x42/0x70
 [<ffffffff810e48c9>] handle_edge_irq+0x69/0x120
 [<ffffffff810164ac>] handle_irq+0x5c/0x150
 [<ffffffff8105f57b>] ? irq_enter+0x1b/0x80
 [<ffffffff8157265d>] do_IRQ+0x5d/0xe0
 [<ffffffff8156822d>] common_interrupt+0x6d/0x6d
 <EOI>  [<ffffffff815649d0>] ? panic+0x19c/0x1e4
 [<ffffffff8156492d>] ? panic+0xf9/0x1e4
 [<ffffffff81569114>] oops_end+0xe4/0x100
 [<ffffffff8104aa7e>] no_context+0x11e/0x1f0
 [<ffffffff8104ac7d>] __bad_area_nosemaphore+0x12d/0x230
 [<ffffffff8104adee>] bad_area+0x4e/0x60
 [<ffffffff8156c04e>] __do_page_fault+0x43e/0x490
 [<ffffffff81058b33>] ? call_console_drivers.clone.3+0xa3/0x110
 [<ffffffff81080f4f>] ? up+0x2f/0x50
 [<ffffffff81058404>] ? wake_up_klogd+0x34/0x40
 [<ffffffff81058f9d>] ? console_unlock+0x25d/0x290
 [<ffffffff8156c0ae>] do_page_fault+0xe/0x10
 [<ffffffff81568518>] page_fault+0x28/0x30
 [<ffffffff81346056>] ? sysrq_handle_crash+0x16/0x20
 [<ffffffff81346969>] __handle_sysrq+0x129/0x190
 [<ffffffff81346a1a>] write_sysrq_trigger+0x4a/0x50
 [<ffffffff811e4cb9>] proc_reg_write+0x79/0xb0
 [<ffffffff8117f104>] vfs_write+0xb4/0x130
 [<ffffffff8117f8cf>] sys_write+0x5f/0xa0
 [<ffffffff81570a19>] system_call_fastpath+0x16/0x1b
---[ end trace b3d5243c59d80624 ]---

[Solution]

Skip WARN_ON() when a panicked cpu which is set to stopping_cpu in
smp_send_stop() calls native_smp_send_reschedule().

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 arch/x86/kernel/smp.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 48d2b7d..35168b1 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -120,7 +120,11 @@ static bool smp_no_nmi_ipi = false;
 static void native_smp_send_reschedule(int cpu)
 {
 	if (unlikely(cpu_is_offline(cpu))) {
-		WARN_ON(1);
+		/*
+		 * Skip WARN_ON() if cpu is stopping
+		 * to avoid printing spurious messages.
+		 */
+		WARN_ON(raw_smp_processor_id() != atomic_read(&stopping_cpu));
 		return;
 	}
 	apic->send_IPI_mask(cpumask_of(cpu), RESCHEDULE_VECTOR);
-- 
1.7.1





