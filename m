Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965826AbaKNTLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:11:10 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:57595 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965580AbaKNTLI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:11:08 -0500
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3293A5D8@ORSMSX114.amr.corp.intel.com>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
 <20141112220058.GA5295@redhat.com> <CALCETrWA5z7-1fiz_9N0Qi2OR5s1jCkHiynCtTD_+9taOBs-Mg@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292BAB4@ORSMSX114.amr.corp.intel.com>
 <CALCETrU8uyc4nu-5MBXQR0PY0rexUhPkuPRLK+gWt0gEWMDhTA@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292BD44@ORSMSX114.amr.corp.intel.com>
 <CALCETrUpqSpcKFRM6a1zJWebEVZxNd-5pyBW4fU19+HgcBv+2Q@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292CB9A@ORSMSX114.amr.corp.intel.com>
 <CALCETrVx7hGZodWfAoU1oee1SW7XXSn3Lr8Vs9JTOUMNtLXY4A@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292D57B@ORSMSX114.amr.corp.intel.com>
 <CALCETrVB9VQPqFb7GQyxmVEKYtPhppmZS8SewQmtre+3_su9FA@mail.gmail.com>
 <CALCETrVJE25Txr5vRKAxHpeKx9p0VJBbat44w+X4gT8qX7a4bg@mail.gmail.com>
 <CALCETrVYWAOzaHqet8gS5hafvQC9prrH05qgc+v5dxSL9AF8bg@mail.gmail.com> <3908561D78D1C84285E8C5FCA982C28F3293A5D8@ORSMSX114.amr.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 14 Nov 2014 11:10:46 -0800
Message-ID: <CALCETrVHS2YM+bWeoSpZgk3Q8P3rVVHmG5o9T55f+EkTj6He4A@mail.gmail.com>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from userspace
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 9:49 AM, Luck, Tony <tony.luck@intel.com> wrote:
>> Can you also try rebasing onto what will probably be v3?
>>
>> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/tag/?id=paranoid-stack-v2.9
>
> Built that - with none of my other changes ... i.e. still use TIF_NOTIFY_MCE etc. No printk()
> in the MCE context.
>
> System ran 736 injection/consumption/recovery cycles and then got an RCU
> stall - followed by a zillion soft lockups.

Grr.  I must be missing something rather basic here.

So far, the only thing I've come up with is that do_machine_check
seems to be missing exception_enter or the equivalent.  Do you have
CONFIG_CONTEXT_TRACKING on and/or full nohz enabled?  I don't think
that this explains my bug, though.

These traces seem to suggest that you're in stop_machine.  I wonder
how you got there.  This could also be an artifact of whatever
corruption is screwing everything up in the first place, though.

I'm still not seeing the bug.  I'll see if I can get EINJ working this
afternoon.

--Andy


>
> [  203.326117] mce: Uncorrected hardware memory error in user-access at 100f07f800
> [  203.326193] MCE 0x100f07f: Killing harderrors:12052 due to hardware memory corruption
> [  203.326195] MCE 0x100f07f: dirty LRU page recovery: Recovered
> [  204.721893] mce: Uncorrected hardware memory error in user-access at 100f7073c0
> [  204.721906] INFO: rcu_sched self-detected stall on CPU { 91}  (t=60002 jiffies g=5125 c=5124 q=0)
> [  204.721908] Task dump for CPU 91:
> [  204.721911] kworker/91:1    R  running task        0  1033      2 0x00000008
> [  204.721925] Workqueue: events_power_efficient fb_flashcursor
> [  204.721929]  ffff880c6767def0 00000000c74bfa96 ffff880c6fa63d68 ffffffff81099d68
> [  204.721930]  000000000000005b ffffffff819d1140 ffff880c6fa63d88 ffffffff8109d38d
> [  204.721932]  0000000000000087 000000000000000c ffff880c6fa63db8 ffffffff810caed0
> [  204.721933] Call Trace:
> [  204.721946]  <IRQ>  [<ffffffff81099d68>] sched_show_task+0xa8/0x110
> [  204.721951]  [<ffffffff8109d38d>] dump_cpu_task+0x3d/0x50
> [  204.721961]  [<ffffffff810caed0>] rcu_dump_cpu_stacks+0x90/0xd0
> [  204.721967]  [<ffffffff810cec17>] rcu_check_callbacks+0x497/0x710
> [  204.721974]  [<ffffffff810d3b7b>] update_process_times+0x4b/0x80
> [  204.721986]  [<ffffffff810e37c5>] tick_sched_handle.isra.19+0x25/0x60
> [  204.721989]  [<ffffffff810e3845>] tick_sched_timer+0x45/0x80
> [  204.721992]  [<ffffffff810d4887>] __run_hrtimer+0x77/0x1d0
> [  204.721995]  [<ffffffff810e3800>] ? tick_sched_handle.isra.19+0x60/0x60
> [  204.721997]  [<ffffffff810d4c77>] hrtimer_interrupt+0xf7/0x240
> [  204.722008]  [<ffffffff810455ab>] local_apic_timer_interrupt+0x3b/0x70
> [  204.722018]  [<ffffffff8165f8d5>] smp_apic_timer_interrupt+0x45/0x60
> [  204.722020]  [<ffffffff8165d91d>] apic_timer_interrupt+0x6d/0x80
> [  204.722034]  <EOI>  [<ffffffff810c1a38>] ? console_unlock+0x418/0x460
> [  204.722037]  [<ffffffff8135600d>] fb_flashcursor+0x5d/0x140
> [  204.722040]  [<ffffffff8135b8e0>] ? bit_clear+0x120/0x120
> [  204.722049]  [<ffffffff81086b5e>] process_one_work+0x14e/0x3f0
> [  204.722051]  [<ffffffff8108726b>] worker_thread+0x11b/0x510
> [  204.722053]  [<ffffffff81087150>] ? rescuer_thread+0x350/0x350
> [  204.722057]  [<ffffffff8108c9f1>] kthread+0xe1/0x100
> [  204.722059]  [<ffffffff8108c910>] ? kthread_create_on_node+0x1b0/0x1b0
> [  204.722074]  [<ffffffff8165c97c>] ret_from_fork+0x7c/0xb0
> [  204.722076]  [<ffffffff8108c910>] ? kthread_create_on_node+0x1b0/0x1b0
> [  227.462386] NMI watchdog: BUG: soft lockup - CPU#18 stuck for 22s! [migration/18:134]
> [  227.462452] Modules linked in: einj ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack cfg80211 rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_mangle iptable_security iptable_raw sg iptable_filter ip_tables vfat fat iTCO_wdt iTCO_vendor_support x86_pkg_temp_thermal coretemp kvm ixgbe crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel ptp lrw gf128mul pps_core glue_helper mdio dca ablk_helper sb_edac cryptd edac_core lpc_ich pcspkr shpchp i2c_i801 mfd_core ipmi_si wmi ipmi_msghandler acpi_pad xfs libcrc32c sd_mod mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper sr_mod cdrom ttm drm ahci libahci mpt2sas libata raid_class i2c_core scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod
> [  227.462470] CPU: 18 PID: 134 Comm: migration/18 Tainted: G   M    W      3.18.0-rc3 #1
> [  227.462472] Hardware name: Intel Corporation BRICKLAND/BRICKLAND, BIOS BRHSXSD1.86B.0058.D01.1410201505 10/20/2014
> [  227.462474] task: ffff880c68605ef0 ti: ffff880c67d9c000 task.ti: ffff880c67d9c000
> [  227.462484] RIP: 0010:[<ffffffff81105570>]  [<ffffffff81105570>] multi_cpu_stop+0x70/0xf0
> [  227.462485] RSP: 0018:ffff880c67d9fd68  EFLAGS: 00000293
> [  227.462487] RAX: 0000000000000000 RBX: ffff880c6f814840 RCX: ffffffffffffffff
> [  227.462488] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffffffff81ab3320
> [  227.462489] RBP: ffff880c67d9fd88 R08: ffffffff81ab3328 R09: ffff881467e58d90
> [  227.462490] R10: ffffffff81ab3320 R11: 0000000000000001 R12: 0000000000000000
> [  227.462492] R13: ffff880c677c7800 R14: ffff880c67000800 R15: ffff880c00000000
> [  227.462494] FS:  0000000000000000(0000) GS:ffff880c6f800000(0000) knlGS:0000000000000000
> [  227.462495] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  227.462496] CR2: 00007f2147fcce90 CR3: 0000000001978000 CR4: 00000000001407e0
> [  227.462498] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  227.462500] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  227.462500] Stack:
> [  227.462503]  ffff880c65a8fd20 ffff880c6f80f0a0 ffff880c65a8fdb8 ffff880c6f80f0a8
> [  227.462505]  ffff880c67d9fe58 ffffffff81105778 ffffffff81095387 0000000000000010
> [  227.462507]  0000000000000282 ffff880c67d9fdc8 0000000000000018 0000000000000000
> [  227.462508] Call Trace:
> [  227.462512]  [<ffffffff81105778>] cpu_stopper_thread+0x78/0x150
> [  227.462516]  [<ffffffff81095387>] ? finish_task_switch+0x57/0x180
> [  227.462522]  [<ffffffff81657f67>] ? __schedule+0x2f7/0x7e0
> [  227.462531]  [<ffffffff8109096f>] smpboot_thread_fn+0xff/0x1b0
> [  227.462534]  [<ffffffff81090870>] ? SyS_setgroups+0x1a0/0x1a0
> [  227.462537]  [<ffffffff8108c9f1>] kthread+0xe1/0x100
> [  227.462539]  [<ffffffff8108c910>] ? kthread_create_on_node+0x1b0/0x1b0
> [  227.462544]  [<ffffffff8165c97c>] ret_from_fork+0x7c/0xb0
> [  227.462547]  [<ffffffff8108c910>] ? kthread_create_on_node+0x1b0/0x1b0
> [  227.462572] Code: 23 66 2e 0f 1f 84 00 00 00 00 00 83 fb 03 75 05 45 84 ed 75 66 f0 41 ff 4c 24 24 74 26 89 da 83 fa 04 74 3d f3 90 41 8b 5c 24 20 <39> d3 74 f0 83 fb 02 75 d7 fa 66 0f 1f 44 00 00 eb d8 66 0f 1f
> [  227.478401] NMI watchdog: BUG: soft lockup - CPU#19 stuck for 22s! [migration/19:142]
> [  227.478437] Modules linked in: einj ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack cfg80211 rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_mangle iptable_security iptable_raw sg iptable_filter ip_tables vfat fat iTCO_wdt iTCO_vendor_support x86_pkg_temp_thermal coretemp kvm ixgbe crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel ptp lrw gf128mul pps_core glue_helper mdio dca ablk_helper sb_edac cryptd edac_core lpc_ich pcspkr shpchp i2c_i801 mfd_core ipmi_si wmi ipmi_msghandler acpi_pad xfs libcrc32c sd_mod mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper sr_mod cdrom ttm drm ahci libahci mpt2sas libata raid_class i2c_core scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod
> [  227.478448] CPU: 19 PID: 142 Comm: migration/19 Tainted: G   M    W    L 3.18.0-rc3 #1
> [  227.478449] Hardware name: Intel Corporation BRICKLAND/BRICKLAND, BIOS BRHSXSD1.86B.0058.D01.1410201505 10/20/2014
> [  227.478451] task: ffff880c67dc1b20 ti: ffff880c67dd0000 task.ti: ffff880c67dd0000
> [  227.478456] RIP: 0010:[<ffffffff81105570>]  [<ffffffff81105570>] multi_cpu_stop+0x70/0xf0
> [  227.478457] RSP: 0018:ffff880c67dd3d68  EFLAGS: 00000293
> [  227.478459] RAX: 0000000000000000 RBX: ffff880c6f834840 RCX: ffffffffffffffff
> [  227.478460] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffffffff81ab3320
> [  227.478461] RBP: ffff880c67dd3d88 R08: ffffffff81ab3328 R09: ffff881467e59b20
> [  227.478462] R10: 0000000000000004 R11: 0000000000000005 R12: 0000000000000000
> [  227.478463] R13: ffff880c677c6000 R14: ffff880c67002800 R15: ffff880c00000000
> [  227.478464] FS:  0000000000000000(0000) GS:ffff880c6f820000(0000) knlGS:0000000000000000
> [  227.478466] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  227.478467] CR2: 00007f09b6e2eef0 CR3: 0000000001978000 CR4: 00000000001407e0
> [  227.478468] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  227.478469] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  227.478470] Stack:
> [  227.478472]  ffff880c65a8fd20 ffff880c6f82f0a0 ffff880c65a8fdb8 ffff880c6f82f0a8
> [  227.478474]  ffff880c67dd3e58 ffffffff81105778 ffffffff81095387 0000000000000010
> [  227.478476]  0000000000000216 ffff880c67dd3dc8 0000000000000018 0000000000000000
> [  227.478477] Call Trace:
> [  227.478480]  [<ffffffff81105778>] cpu_stopper_thread+0x78/0x150
> [  227.478483]  [<ffffffff81095387>] ? finish_task_switch+0x57/0x180
> [  227.478486]  [<ffffffff81657f67>] ? __schedule+0x2f7/0x7e0
> [  227.478491]  [<ffffffff8109096f>] smpboot_thread_fn+0xff/0x1b0
> [  227.478494]  [<ffffffff81090870>] ? SyS_setgroups+0x1a0/0x1a0
> [  227.478496]  [<ffffffff8108c9f1>] kthread+0xe1/0x100
> [  227.478498]  [<ffffffff8108c910>] ? kthread_create_on_node+0x1b0/0x1b0
> [  227.478502]  [<ffffffff8165c97c>] ret_from_fork+0x7c/0xb0
> [  227.478504]  [<ffffffff8108c910>] ? kthread_create_on_node+0x1b0/0x1b0
> [  227.478526] Code: 23 66 2e 0f 1f 84 00 00 00 00 00 83 fb 03 75 05 45 84 ed 75 66 f0 41 ff 4c 24 24 74 26 89 da 83 fa 04 74 3d f3 90 41 8b 5c 24 20 <39> d3 74 f0 83 fb 02 75 d7 fa 66 0f 1f 44 00 00 eb d8 66 0f 1f
> [  227.493414] NMI watchdog: BUG: soft lockup - CPU#20 stuck for 22s! [migration/20:149]
> [  227.493448] Modules linked in: einj ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack cfg80211 rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_mangle iptable_security iptable_raw sg iptable_filter ip_tables vfat fat iTCO_wdt iTCO_vendor_support x86_pkg_temp_thermal coretemp kvm ixgbe crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel ptp lrw gf128mul pps_core glue_helper mdio dca ablk_helper sb_edac cryptd edac_core lpc_ich pcspkr shpchp i2c_i801 mfd_core ipmi_si wmi ipmi_msghandler acpi_pad xfs libcrc32c sd_mod mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper sr_mod cdrom ttm drm ahci libahci mpt2sas libata raid_class i2c_core scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod
> [  227.493460] CPU: 20 PID: 149 Comm: migration/20 Tainted: G   M    W    L 3.18.0-rc3 #1
>
>> It adds debugging for inappropriate reschedules from the wrong stack.
>> Setting CONFIG_DEBUG_ATOMIC_SLEEP might also be a good idea.
>
> Will add that for next build/test
>
> -Tony

-- 
Andy Lutomirski
AMA Capital Management, LLC
