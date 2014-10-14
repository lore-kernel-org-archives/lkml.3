Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbaJNIBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 04:01:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbaJNIA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 04:00:58 -0400
Date: Tue, 14 Oct 2014 16:00:50 +0800
From: Dave Young <dyoung@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: stuck at mutex_lock_killable in interate_dir
Message-ID: <20141014080050.GA9165@dhcp-16-198.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[sent an same email on the calprit machine, but I did not receive it,
thus resend it, sorry for duplicate if you got the original one]

I got a 'D' state mutt process, it's killable though.
I think kernel stuck at below code:

linux/fs/readdir.c:
iterate_dir() -> mutex_lock_killable(&inode->i_mutex);

Any idea about this? known issue?

BTW, I can keep the laptop on for testing about 1 day. I'm not sure I can
reproduce it after rebooting.

[20522.102611] ------------[ cut here ]------------
[20522.102636] WARNING: CPU: 3 PID: 4201 at kernel/watchdog.c:267 watchdog_overflow_callback+0xf1/0x109()
[20522.102641] Watchdog detected hard LOCKUP on cpu 3
[20522.102645] Modules linked in: macvtap macvlan kvm_intel ext3 jbd pl2303 usbserial iwldvm i915 snd_hda_codec_hdmi mac80211 e1000e snd_hda_codec_conexant snd_hda_codec_generic iwlwifi btusb bluetooth sdhci_pci snd_hda_intel sdhci mmc_core cfg80211 i2c_algo_bit snd_hda_controller ptp snd_hda_codec snd_hwdep snd_pcm drm_kms_helper drm efivars snd_timer lpc_ich pps_core wmi thinkpad_acpi rfkill video loop
[20522.102744] CPU: 3 PID: 4201 Comm: mutt Not tainted 3.17.0-rc6+ #24
[20522.102750] Hardware name: LENOVO 4236NUC/4236NUC, BIOS 83ET76WW (1.46 ) 07/05/2013
[20522.102755]  0000000000000000 ffff88021e2c6c28 ffffffff8149af7b ffff88021e2c6c70
[20522.102767]  ffff88021e2c6c60 ffffffff810638c9 ffffffff810d8719 0000000000000003
[20522.102777]  0000000000000000 ffff88021e2c6d98 ffff88021e2c6ef8 ffff88021e2c6cc0
[20522.102788] Call Trace:
[20522.102793]  <NMI>  [<ffffffff8149af7b>] dump_stack+0x4e/0x7a
[20522.102817]  [<ffffffff810638c9>] warn_slowpath_common+0x75/0x8e
[20522.102826]  [<ffffffff810d8719>] ? watchdog_overflow_callback+0xf1/0x109
[20522.102836]  [<ffffffff81063929>] warn_slowpath_fmt+0x47/0x49
[20522.102847]  [<ffffffff810e1ed6>] ? perf_event_task_disable+0x7f/0x7f
[20522.102856]  [<ffffffff810d8719>] watchdog_overflow_callback+0xf1/0x109
[20522.102865]  [<ffffffff810e43ee>] __perf_event_overflow+0x131/0x22a
[20522.102873]  [<ffffffff810e1ed6>] ? perf_event_task_disable+0x7f/0x7f
[20522.102885]  [<ffffffff810399ef>] ? x86_perf_event_set_period+0x101/0x111
[20522.102894]  [<ffffffff810e4959>] perf_event_overflow+0x14/0x16
[20522.102903]  [<ffffffff8103e576>] intel_pmu_handle_irq+0x33f/0x3c8
[20522.102914]  [<ffffffff81038cb0>] perf_event_nmi_handler+0x25/0x3e
[20522.102925]  [<ffffffff8102c264>] nmi_handle.isra.2+0x7a/0xdb
[20522.102933]  [<ffffffff8102c1ea>] ? local_touch_nmi+0x1f/0x1f
[20522.102946]  [<ffffffff81090920>] ? validate_chain.isra.27+0x4/0x9ae
[20522.102954]  [<ffffffff8102c39d>] do_nmi+0xd8/0x34c
[20522.102964]  [<ffffffff814a4d11>] end_repeat_nmi+0x1e/0x2e
[20522.102975]  [<ffffffff8123dab1>] ? __this_cpu_preempt_check+0x13/0x16
[20522.102985]  [<ffffffff81090920>] ? validate_chain.isra.27+0x4/0x9ae
[20522.102995]  [<ffffffff81090920>] ? validate_chain.isra.27+0x4/0x9ae
[20522.103004]  [<ffffffff81090920>] ? validate_chain.isra.27+0x4/0x9ae
[20522.103008]  <<EOE>>  <IRQ>  [<ffffffff810937e0>] __lock_acquire+0x6ed/0xb24
[20522.103031]  [<ffffffff8123022e>] ? sha_transform+0x246/0x1068
[20522.103041]  [<ffffffff810940ee>] lock_acquire+0xa4/0xc4
[20522.103051]  [<ffffffff810ad830>] ? lock_hrtimer_base.isra.26+0x20/0x43
[20522.103062]  [<ffffffff814a2206>] _raw_spin_lock_irqsave+0x4b/0x5c
[20522.103070]  [<ffffffff810ad830>] ? lock_hrtimer_base.isra.26+0x20/0x43
[20522.103079]  [<ffffffff810ad830>] lock_hrtimer_base.isra.26+0x20/0x43
[20522.103087]  [<ffffffff810ad870>] hrtimer_try_to_cancel+0x1d/0x8d
[20522.103095]  [<ffffffff810ad8f0>] hrtimer_cancel+0x10/0x1b
[20522.103106]  [<ffffffff810b999e>] tick_nohz_restart+0x12/0x7d
[20522.103116]  [<ffffffff810ba394>] __tick_nohz_full_check+0xa1/0xa6
[20522.103126]  [<ffffffff810ba3a2>] nohz_full_kick_work_func+0x9/0xb
[20522.103135]  [<ffffffff810dc4fc>] irq_work_run_list+0x4a/0x68
[20522.103145]  [<ffffffff810b9e9c>] ? tick_sched_handle+0x47/0x47
[20522.103153]  [<ffffffff810dc544>] irq_work_run+0x2a/0x4a
[20522.103162]  [<ffffffff810ad433>] update_process_times+0x4c/0x60
[20522.103171]  [<ffffffff810b9e97>] tick_sched_handle+0x42/0x47
[20522.103180]  [<ffffffff810b9ed1>] tick_sched_timer+0x35/0x53
[20522.103188]  [<ffffffff810ad992>] __run_hrtimer.isra.28+0x57/0xb0
[20522.103197]  [<ffffffff810adee7>] hrtimer_interrupt+0xeb/0x1d2
[20522.103211]  [<ffffffff811ac980>] ? ext4_follow_link+0x1c/0x1c
[20522.103220]  [<ffffffff8104dc2a>] local_apic_timer_interrupt+0x4e/0x51
[20522.103228]  [<ffffffff8104e041>] smp_apic_timer_interrupt+0x3a/0x4b
[20522.103236]  [<ffffffff814a4002>] apic_timer_interrupt+0x72/0x80
[20522.103240]  <EOI>  [<ffffffff811ac9af>] ? str2hashbuf_signed+0x2f/0x80
[20522.103257]  [<ffffffff811acba2>] ext4fs_dirhash+0x122/0x218
[20522.103266]  [<ffffffff81121548>] ? __kmalloc+0x82/0xfe
[20522.103276]  [<ffffffff811a0e7d>] htree_dirblock_to_tree+0xd2/0x135
[20522.103285]  [<ffffffff811a1b13>] ext4_htree_fill_tree+0x173/0x21d
[20522.103294]  [<ffffffff8123da9c>] ? debug_smp_processor_id+0x17/0x19
[20522.103306]  [<ffffffff8119471c>] ext4_readdir+0x27e/0x73f
[20522.103316]  [<ffffffff8149f1ab>] ? mutex_lock_killable_nested+0x33d/0x59a
[20522.103325]  [<ffffffff81137910>] ? iterate_dir+0x38/0xff
[20522.103332]  [<ffffffff81137910>] ? iterate_dir+0x38/0xff
[20522.103341]  [<ffffffff81137948>] iterate_dir+0x70/0xff
[20522.103349]  [<ffffffff81137d91>] SyS_getdents+0x7a/0xda
[20522.103356]  [<ffffffff81137aa6>] ? fillonedir+0xcf/0xcf
[20522.103364]  [<ffffffff814a30d8>] tracesys+0xe1/0xe6
[20522.103371] ---[ end trace 949cb4fa0993f833 ]---
[20553.806845] INFO: rcu_preempt detected stalls on CPUs/tasks: { 3} (detected by 0, t=18002 jiffies, g=181109, c=181108, q=0)
[20553.806872] Task dump for CPU 3:
[20553.806879] mutt            R  running task    12768  4201   1825 0x00080008
[20553.806897]  ffff8802133ae000 0000000000000006 0000000000000007 ffffea000849f540
[20553.806909]  0000000000000046 ffff8802133ae000 ffffffff81498748 ffff8802150019c0
[20553.806921]  ffff880206707ba8 ffffffff8123dab1 ffff880206707bc8 ffffffff81091ce9
[20553.806933] Call Trace:
[20553.806953]  [<ffffffff81498748>] ? __slab_alloc.isra.63.constprop.70+0x3c7/0x3e5
[20553.806964]  [<ffffffff8123dab1>] ? __this_cpu_preempt_check+0x13/0x16
[20553.806977]  [<ffffffff81091ce9>] ? trace_hardirqs_on_caller+0x1b7/0x1d7
[20553.806986]  [<ffffffff81091d16>] ? trace_hardirqs_on+0xd/0xf
[20553.806999]  [<ffffffff81194c3e>] ? ext4_htree_store_dirent+0x2d/0xeb
[20553.807011]  [<ffffffff81150084>] ? __getblk+0x1f/0x2a6
[20553.807024]  [<ffffffff811ac9af>] ? str2hashbuf_signed+0x2f/0x80
[20553.807032]  [<ffffffff811acba2>] ? ext4fs_dirhash+0x122/0x218
[20553.807041]  [<ffffffff81121548>] ? __kmalloc+0x82/0xfe
[20553.807051]  [<ffffffff811a0e7d>] ? htree_dirblock_to_tree+0xd2/0x135
[20553.807061]  [<ffffffff811a1b13>] ? ext4_htree_fill_tree+0x173/0x21d
[20553.807069]  [<ffffffff8123da9c>] ? debug_smp_processor_id+0x17/0x19
[20553.807080]  [<ffffffff8119471c>] ? ext4_readdir+0x27e/0x73f
[20553.807092]  [<ffffffff8149f1ab>] ? mutex_lock_killable_nested+0x33d/0x59a
[20553.807101]  [<ffffffff81137910>] ? iterate_dir+0x38/0xff
[20553.807108]  [<ffffffff81137910>] ? iterate_dir+0x38/0xff
[20553.807116]  [<ffffffff81137948>] ? iterate_dir+0x70/0xff
[20553.807125]  [<ffffffff81137d91>] ? SyS_getdents+0x7a/0xda
[20553.807132]  [<ffffffff81137aa6>] ? fillonedir+0xcf/0xcf
[20553.807141]  [<ffffffff814a30d8>] ? tracesys+0xe1/0xe6

Thanks
Dave
