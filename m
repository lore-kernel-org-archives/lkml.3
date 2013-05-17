Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab3EQN4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:56:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50109 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197Ab3EQN4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:56:44 -0400
Date: Fri, 17 May 2013 15:56:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: NOHZ: WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule, round 2
Message-ID: <20130517135641.GF23035@pd.tnic>
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz>
 <20130509125040.GF27333@pd.tnic>
 <20130509125859.GG27333@pd.tnic>
 <20130515184528.GO4442@linux.vnet.ibm.com>
 <20130515224358.GF11783@pd.tnic>
 <20130515235512.GT4442@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130515235512.GT4442@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 04:55:13PM -0700, Paul E. McKenney wrote:
> I never saw the problem, so I have to defer to you on this one. I will
> hold off on the patch unless the problem shows up again.

Thanks Paul.

Well, it's not this problem, but another one. Let me check if everyone
is on CC... nope, tglx is missing, added.

Ok, here's the setup:

CONFIG_NO_HZ_COMMON=y
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
CONFIG_NO_HZ_FULL_ALL=y
CONFIG_NO_HZ=y
CONFIG_RCU_FAST_NO_HZ=y

Tree is Linus from today + tip/master, i.e. it has all fixes, even

commit f7ea0fd639c2c48d3c61b6eec75362be290c6874
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Mon May 13 21:40:27 2013 +0200

    tick: Don't invoke tick_nohz_stop_sched_tick() if the cpu is offline

Now, when I halt the box, I see these splats originating from cpufreq's
od_dbs_timer adding a workqueue which does add_timer_on:


[   49.338878] EXT4-fs (sda7): re-mounted. Opts: (null)
[   51.502417] kvm: exiting hardware virtualization
[   51.597330] ACPI: Preparing to enter system sleep state S5
[   51.603147] Disabling non-boot CPUs ...
[   51.616759] ------------[ cut here ]------------
[   51.621460] WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x58/0x60()
[   51.629638] Modules linked in: ext2 vfat fat loop snd_hda_codec_hdmi usbhid snd_hda_codec_realtek coretemp kvm_intel kvm snd_hda_intel snd_hda_codec crc32_pclmul crc32c_intel ghash_clmulni_intel snd_hwdep snd_pcm aesni_intel sb_edac aes_x86_64 ehci_pci snd_page_alloc glue_helper snd_timer xhci_hcd snd iTCO_wdt iTCO_vendor_support ehci_hcd edac_core lpc_ich acpi_cpufreq lrw gf128mul ablk_helper cryptd mperf usbcore usb_common soundcore mfd_core dcdbas evdev pcspkr processor i2c_i801 button microcode
[   51.675581] CPU: 0 PID: 244 Comm: kworker/1:1 Tainted: G        W    3.10.0-rc1+ #10
[   51.683407] Hardware name: Dell Inc. Precision T3600/0PTTT9, BIOS A08 01/24/2013
[   51.690901] Workqueue: events od_dbs_timer
[   51.695069]  0000000000000009 ffff88043a2f5b68 ffffffff8161441c ffff88043a2f5ba8
[   51.702602]  ffffffff8103e540 0000000000000033 0000000000000001 ffff88043d5f8000
[   51.710136]  00000000ffff0ce1 0000000000000001 ffff88044fc4fc08 ffff88043a2f5bb8
[   51.717691] Call Trace:
[   51.720191]  [<ffffffff8161441c>] dump_stack+0x19/0x1b
[   51.725396]  [<ffffffff8103e540>] warn_slowpath_common+0x70/0xa0
[   51.731473]  [<ffffffff8103e58a>] warn_slowpath_null+0x1a/0x20
[   51.737378]  [<ffffffff81025628>] native_smp_send_reschedule+0x58/0x60
[   51.744013]  [<ffffffff81072cfd>] wake_up_nohz_cpu+0x2d/0xa0
[   51.749745]  [<ffffffff8104f6bf>] add_timer_on+0x8f/0x110
[   51.755214]  [<ffffffff8105f6fe>] __queue_delayed_work+0x16e/0x1a0
[   51.761470]  [<ffffffff8105f251>] ? try_to_grab_pending+0xd1/0x1a0
[   51.767724]  [<ffffffff8105f78a>] mod_delayed_work_on+0x5a/0xa0
[   51.773719]  [<ffffffff814f6b5d>] gov_queue_work+0x4d/0xc0
[   51.779271]  [<ffffffff814f60cb>] od_dbs_timer+0xcb/0x170
[   51.784734]  [<ffffffff8105e75d>] process_one_work+0x1fd/0x540
[   51.790634]  [<ffffffff8105e6f2>] ? process_one_work+0x192/0x540
[   51.796711]  [<ffffffff8105ef22>] worker_thread+0x122/0x380
[   51.802350]  [<ffffffff8105ee00>] ? rescuer_thread+0x320/0x320
[   51.808264]  [<ffffffff8106634a>] kthread+0xea/0xf0
[   51.813200]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   51.819644]  [<ffffffff81623d5c>] ret_from_fork+0x7c/0xb0
[   51.918165] nouveau E[     DRM] GPU lockup - switching to software fbcon
[   51.930505]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   51.936994] ---[ end trace f419538ada83b5c5 ]---
[   51.942915] ------------[ cut here ]------------
[   51.942928] ------------[ cut here ]------------
[   51.942936] WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x58/0x60()
[   51.942974] Modules linked in: ext2 vfat fat loop snd_hda_codec_hdmi usbhid snd_hda_codec_realtek coretemp kvm_intel kvm snd_hda_intel snd_hda_codec crc32_pclmul crc32c_intel ghash_clmulni_intel snd_hwdep snd_pcm aesni_intel sb_edac aes_x86_64 ehci_pci snd_page_alloc glue_helper snd_timer xhci_hcd snd iTCO_wdt iTCO_vendor_support ehci_hcd edac_core lpc_ich acpi_cpufreq lrw gf128mul ablk_helper cryptd mperf usbcore usb_common soundcore mfd_core dcdbas evdev pcspkr processor i2c_i801 button microcode
[   51.942978] CPU: 5 PID: 740 Comm: kworker/3:2 Tainted: G        W    3.10.0-rc1+ #10
[   51.942979] Hardware name: Dell Inc. Precision T3600/0PTTT9, BIOS A08 01/24/2013
[   51.942985] Workqueue: events od_dbs_timer
[   51.942990]  0000000000000009 ffff88043ab0db68 ffffffff8161441c ffff88043ab0dba8
[   51.942994]  ffffffff8103e540 000000003ab0dbf8 0000000000000003 ffff88043d708000
[   51.942998]  00000000ffff0d32 0000000000000003 ffff88044fccfc08 ffff88043ab0dbb8
[   51.942999] Call Trace:
[   51.943005]  [<ffffffff8161441c>] dump_stack+0x19/0x1b
[   51.943010]  [<ffffffff8103e540>] warn_slowpath_common+0x70/0xa0
[   51.943014]  [<ffffffff8103e58a>] warn_slowpath_null+0x1a/0x20
[   51.943017]  [<ffffffff81025628>] native_smp_send_reschedule+0x58/0x60
[   51.943021]  [<ffffffff81072cfd>] wake_up_nohz_cpu+0x2d/0xa0
[   51.943027]  [<ffffffff8104f6bf>] add_timer_on+0x8f/0x110
[   51.943031]  [<ffffffff8105f6fe>] __queue_delayed_work+0x16e/0x1a0
[   51.943035]  [<ffffffff8105f251>] ? try_to_grab_pending+0xd1/0x1a0
[   51.943038]  [<ffffffff8105f78a>] mod_delayed_work_on+0x5a/0xa0
[   51.943043]  [<ffffffff814f6b5d>] gov_queue_work+0x4d/0xc0
[   51.943046]  [<ffffffff814f60cb>] od_dbs_timer+0xcb/0x170
[   51.943050]  [<ffffffff8105e75d>] process_one_work+0x1fd/0x540
[   51.943053]  [<ffffffff8105e6f2>] ? process_one_work+0x192/0x540
[   51.943057]  [<ffffffff8105ef22>] worker_thread+0x122/0x380
[   51.943060]  [<ffffffff8105ee00>] ? rescuer_thread+0x320/0x320
[   51.943063]  [<ffffffff8106634a>] kthread+0xea/0xf0
[   51.943068]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   51.943071]  [<ffffffff81623d5c>] ret_from_fork+0x7c/0xb0
[   51.943074]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   51.943076] ---[ end trace f419538ada83b5c6 ]---
[   52.178461] WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x58/0x60()
[   52.188097] Modules linked in: ext2 vfat fat loop snd_hda_codec_hdmi usbhid snd_hda_codec_realtek coretemp kvm_intel kvm snd_hda_intel snd_hda_codec crc32_pclmul crc32c_intel ghash_clmulni_intel snd_hwdep snd_pcm aesni_intel sb_edac aes_x86_64 ehci_pci snd_page_alloc glue_helper snd_timer xhci_hcd snd iTCO_wdt iTCO_vendor_support ehci_hcd edac_core lpc_ich acpi_cpufreq lrw gf128mul ablk_helper cryptd mperf usbcore usb_common soundcore mfd_core dcdbas evdev pcspkr processor i2c_i801 button microcode
[   52.238477] CPU: 0 PID: 85 Comm: kworker/2:1 Tainted: G        W    3.10.0-rc1+ #10
[   52.247669] Hardware name: Dell Inc. Precision T3600/0PTTT9, BIOS A08 01/24/2013
[   52.256604] Workqueue: events od_dbs_timer
[   52.262219]  0000000000000009 ffff88043b62db68 ffffffff8161441c ffff88043b62dba8
[   52.271194]  ffffffff8103e540 0000000000000033 0000000000000002 ffff88043d6dc000
[   52.280163]  00000000ffff0d32 0000000000000002 ffff88044fc8fc08 ffff88043b62dbb8
[   52.289141] Call Trace:
[   52.293066]  [<ffffffff8161441c>] dump_stack+0x19/0x1b
[   52.299704]  [<ffffffff8103e540>] warn_slowpath_common+0x70/0xa0
[   52.307213]  [<ffffffff8103e58a>] warn_slowpath_null+0x1a/0x20
[   52.314540]  [<ffffffff81025628>] native_smp_send_reschedule+0x58/0x60
[   52.322592]  [<ffffffff81072cfd>] wake_up_nohz_cpu+0x2d/0xa0
[   52.329763]  [<ffffffff8104f6bf>] add_timer_on+0x8f/0x110
[   52.336660]  [<ffffffff8105f6fe>] __queue_delayed_work+0x16e/0x1a0
[   52.344349]  [<ffffffff8105f251>] ? try_to_grab_pending+0xd1/0x1a0
[   52.352031]  [<ffffffff8105f78a>] mod_delayed_work_on+0x5a/0xa0
[   52.359458]  [<ffffffff814f6b5d>] gov_queue_work+0x4d/0xc0
[   52.366438]  [<ffffffff814f60cb>] od_dbs_timer+0xcb/0x170
[   52.373338]  [<ffffffff8105e75d>] process_one_work+0x1fd/0x540
[   52.380670]  [<ffffffff8105e6f2>] ? process_one_work+0x192/0x540
[   52.388176]  [<ffffffff8105ef22>] worker_thread+0x122/0x380
[   52.395247]  [<ffffffff8105ee00>] ? rescuer_thread+0x320/0x320
[   52.402588]  [<ffffffff8106634a>] kthread+0xea/0xf0
[   52.408954]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   52.416830]  [<ffffffff81623d5c>] ret_from_fork+0x7c/0xb0
[   52.423722]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   52.431588] ---[ end trace f419538ada83b5c7 ]---
[   52.460411] ------------[ cut here ]------------
[   52.467744] WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x58/0x60()
[   52.478684] Modules linked in: ext2 vfat fat loop snd_hda_codec_hdmi usbhid snd_hda_codec_realtek coretemp kvm_intel kvm snd_hda_intel snd_hda_codec crc32_pclmul crc32c_intel ghash_clmulni_intel snd_hwdep snd_pcm aesni_intel sb_edac aes_x86_64 ehci_pci snd_page_alloc glue_helper snd_timer xhci_hcd snd iTCO_wdt iTCO_vendor_support ehci_hcd edac_core lpc_ich acpi_cpufreq lrw gf128mul ablk_helper cryptd mperf usbcore usb_common soundcore mfd_core dcdbas evdev pcspkr processor i2c_i801 button microcode
[   52.533573] CPU: 5 PID: 740 Comm: kworker/3:2 Tainted: G        W    3.10.0-rc1+ #10
[   52.544303] ------------[ cut here ]------------
[   52.544305] WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x58/0x60()
[   52.544317] Modules linked in: ext2 vfat fat loop snd_hda_codec_hdmi usbhid snd_hda_codec_realtek coretemp kvm_intel kvm snd_hda_intel snd_hda_codec crc32_pclmul crc32c_intel ghash_clmulni_intel snd_hwdep snd_pcm aesni_intel sb_edac aes_x86_64 ehci_pci snd_page_alloc glue_helper snd_timer xhci_hcd snd iTCO_wdt iTCO_vendor_support ehci_hcd edac_core lpc_ich acpi_cpufreq lrw gf128mul ablk_helper cryptd mperf usbcore usb_common soundcore mfd_core dcdbas evdev pcspkr processor i2c_i801 button microcode
[   52.544318] CPU: 0 PID: 71 Comm: kworker/4:1 Tainted: G        W    3.10.0-rc1+ #10
[   52.544318] Hardware name: Dell Inc. Precision T3600/0PTTT9, BIOS A08 01/24/2013
[   52.544322] Workqueue: events od_dbs_timer
[   52.544324]  0000000000000009 ffff88043c271b68 ffffffff8161441c ffff88043c271ba8
[   52.544325]  ffffffff8103e540 0000000000000033 0000000000000004 ffff88043d738000
[   52.544326]  00000000ffff0dc8 0000000000000004 ffff88044fd0fc08 ffff88043c271bb8
[   52.544327] Call Trace:
[   52.544330]  [<ffffffff8161441c>] dump_stack+0x19/0x1b
[   52.544333]  [<ffffffff8103e540>] warn_slowpath_common+0x70/0xa0
[   52.544334]  [<ffffffff8103e58a>] warn_slowpath_null+0x1a/0x20
[   52.544335]  [<ffffffff81025628>] native_smp_send_reschedule+0x58/0x60
[   52.544337]  [<ffffffff81072cfd>] wake_up_nohz_cpu+0x2d/0xa0
[   52.544340]  [<ffffffff8104f6bf>] add_timer_on+0x8f/0x110
[   52.544342]  [<ffffffff8105f6fe>] __queue_delayed_work+0x16e/0x1a0
[   52.544343]  [<ffffffff8105f251>] ? try_to_grab_pending+0xd1/0x1a0
[   52.544344]  [<ffffffff8105f78a>] mod_delayed_work_on+0x5a/0xa0
[   52.544346]  [<ffffffff814f6b5d>] gov_queue_work+0x4d/0xc0
[   52.544347]  [<ffffffff814f60cb>] od_dbs_timer+0xcb/0x170
[   52.544348]  [<ffffffff8105e75d>] process_one_work+0x1fd/0x540
[   52.544349]  [<ffffffff8105e6f2>] ? process_one_work+0x192/0x540
[   52.544350]  [<ffffffff8105ef22>] worker_thread+0x122/0x380
[   52.544351]  [<ffffffff8105ee00>] ? rescuer_thread+0x320/0x320
[   52.544353]  [<ffffffff8106634a>] kthread+0xea/0xf0
[   52.544354]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   52.544356]  [<ffffffff81623d5c>] ret_from_fork+0x7c/0xb0
[   52.544357]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   52.544357] ---[ end trace f419538ada83b5c8 ]---
[   52.798038] Hardware name: Dell Inc. Precision T3600/0PTTT9, BIOS A08 01/24/2013
[   52.806551] Workqueue: events od_dbs_timer
[   52.811736]  0000000000000009 ffff88043ab0db68 ffffffff8161441c ffff88043ab0dba8
[   52.820284]  ffffffff8103e540 0000000000000033 0000000000000003 ffff88043d708000
[   52.828828]  00000000ffff0db3 0000000000000003 ffff88044fccfc08 ffff88043ab0dbb8
[   52.837372] Call Trace:
[   52.840874]  [<ffffffff8161441c>] dump_stack+0x19/0x1b
[   52.847090]  [<ffffffff8103e540>] warn_slowpath_common+0x70/0xa0
[   52.854176]  [<ffffffff8103e58a>] warn_slowpath_null+0x1a/0x20
[   52.861086]  [<ffffffff81025628>] native_smp_send_reschedule+0x58/0x60
[   52.868694]  [<ffffffff81072cfd>] wake_up_nohz_cpu+0x2d/0xa0
[   52.875432]  [<ffffffff8104f6bf>] add_timer_on+0x8f/0x110
[   52.881902]  [<ffffffff8105f6fe>] __queue_delayed_work+0x16e/0x1a0
[   52.889160]  [<ffffffff8105f251>] ? try_to_grab_pending+0xd1/0x1a0
[   52.896416]  [<ffffffff8105f78a>] mod_delayed_work_on+0x5a/0xa0
[   52.903409]  [<ffffffff814f6b5d>] gov_queue_work+0x4d/0xc0
[   52.909966]  [<ffffffff814f60cb>] od_dbs_timer+0xcb/0x170
[   52.916434]  [<ffffffff8105e75d>] process_one_work+0x1fd/0x540
[   52.923342]  [<ffffffff8105e6f2>] ? process_one_work+0x192/0x540
[   52.930427]  [<ffffffff8105ef22>] worker_thread+0x122/0x380
[   52.937074]  [<ffffffff8105ee00>] ? rescuer_thread+0x320/0x320
[   52.943983]  [<ffffffff8106634a>] kthread+0xea/0xf0
[   52.949926]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   52.957370]  [<ffffffff81623d5c>] ret_from_fork+0x7c/0xb0
[   52.963841]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   52.971275] ---[ end trace f419538ada83b5c9 ]---
[   52.976979] nouveau W[   PFIFO][0000:03:00.0] unknown intr 0x00400000, ch 1
[   53.092122] ------------[ cut here ]------------
[   53.099585] WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x58/0x60()
[   53.110571] Modules linked in: ext2 vfat fat loop snd_hda_codec_hdmi usbhid snd_hda_codec_realtek coretemp kvm_intel kvm snd_hda_intel snd_hda_codec crc32_pclmul crc32c_intel ghash_clmulni_intel snd_hwdep snd_pcm aesni_intel sb_edac aes_x86_64 ehci_pci snd_page_alloc glue_helper snd_timer xhci_hcd snd iTCO_wdt iTCO_vendor_support ehci_hcd edac_core lpc_ich acpi_cpufreq lrw gf128mul ablk_helper cryptd mperf usbcore usb_common soundcore mfd_core dcdbas evdev pcspkr processor i2c_i801 button microcode
[   53.165267] CPU: 0 PID: 123 Comm: kworker/5:1 Tainted: G        W    3.10.0-rc1+ #10
[   53.175902] Hardware name: Dell Inc. Precision T3600/0PTTT9, BIOS A08 01/24/2013
[   53.186190] Workqueue: events od_dbs_timer
[   53.193136]  0000000000000009 ffff88043b277b68 ffffffff8161441c ffff88043b277ba8
[   53.203477]  ffffffff8103e540 000000003b277bb8 0000000000000005 ffff88043d764000
[   53.213727]  00000000ffff0e52 0000000000000005 ffff88044fd4fc08 ffff88043b277bb8
[   53.223894] Call Trace:
[   53.228887]  [<ffffffff8161441c>] dump_stack+0x19/0x1b
[   53.236593]  [<ffffffff8103e540>] warn_slowpath_common+0x70/0xa0
[   53.245160]  [<ffffffff8103e58a>] warn_slowpath_null+0x1a/0x20
[   53.253519]  [<ffffffff81025628>] native_smp_send_reschedule+0x58/0x60
[   53.262582]  [<ffffffff81072cfd>] wake_up_nohz_cpu+0x2d/0xa0
[   53.270756]  [<ffffffff8104f6bf>] add_timer_on+0x8f/0x110
[   53.278654]  [<ffffffff8105f6fe>] __queue_delayed_work+0x16e/0x1a0
[   53.287335]  [<ffffffff8105f251>] ? try_to_grab_pending+0xd1/0x1a0
[   53.296002]  [<ffffffff8105f78a>] mod_delayed_work_on+0x5a/0xa0
[   53.304412]  [<ffffffff814f6b5d>] gov_queue_work+0x4d/0xc0
[   53.312388]  [<ffffffff814f60cb>] od_dbs_timer+0xcb/0x170
[   53.320267]  [<ffffffff8105e75d>] process_one_work+0x1fd/0x540
[   53.328584]  [<ffffffff8105e6f2>] ? process_one_work+0x192/0x540
[   53.337083]  [<ffffffff8105ef22>] worker_thread+0x122/0x380
[   53.345142]  [<ffffffff8105ee00>] ? rescuer_thread+0x320/0x320
[   53.353484]  [<ffffffff8106634a>] kthread+0xea/0xf0
[   53.360847]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   53.369709]  [<ffffffff81623d5c>] ret_from_fork+0x7c/0xb0
[   53.377603]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
[   53.386474] ---[ end trace f419538ada83b5ca ]---
[   53.395276] Power down.
[   53.399033] acpi_power_off called

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
