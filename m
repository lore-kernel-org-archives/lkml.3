Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaDSTda (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 15:33:30 -0400
Received: from stator.leun.net ([85.214.203.199]:34691 "EHLO stator.leun.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbaDSTdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 15:33:24 -0400
Date: Sat, 19 Apr 2014 21:32:54 +0200
From: Michael Leun <lkml20140418@newton.leun.net>
To: linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath9k-devel@venema.h4ckr.net, Mihir Shete <smihir@qti.qualcomm.com>,
        Henri Bahini <hbahini@qca.qualcomm.com>,
        Tushnim Bhattacharyya <tushnimb@qca.qualcomm.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: 3.14 Regression, kernel panic when suspend, looks ath9k /
 wireless related
Message-ID: <20140419213254.0b4c4b6a@xenia.leun.net>
In-Reply-To: <20140419031554.253c98c3@xenia.leun.net>
References: <20140419031554.253c98c3@xenia.leun.net>
Organization: Not Organized
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Apr 2014 03:15:54 +0200
Michael Leun <lkml20140418@newton.leun.net> wrote:

> Hi,
> 
> since 3.14 I get an kernel panic when trying to suspend or hibernate
> (and in several other situations). Looks ath9k or wireless related,
> does not happen when I for test
> remove /lib/modules/3.14.1/kernel/net/wireless/ath* (also from
> initrd).
> 
> Did not bisect yet, but could if needed.

Did bisect now, yields:

2a901468c221e778af52603e006a53d286e81f90 is the first bad commit
commit 2a901468c221e778af52603e006a53d286e81f90
Author: Luis R. Rodriguez <mcgrof@do-not-panic.com>
Date:   Mon Nov 11 22:15:31 2013 +0100

    cfg80211: add an option to disable processing country IEs
    
    Certain vendors may want to disable the processing of
    country IEs so that they can continue using the regulatory
    domain the driver or user has set.  Currently there is no
    way to stop the core from processing country IEs, so add
    support to the core to ignore country IE hints.
    
    Cc: Mihir Shete <smihir@qti.qualcomm.com>
    Cc: Henri Bahini <hbahini@qca.qualcomm.com>
    Cc: Tushnim Bhattacharyya <tushnimb@qca.qualcomm.com>
    Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

:040000 040000 86bdd39a7e40b95bb6a0332e0b654706cfb1e1fb a760753abc0241b363f71f78f13e4d42e47b7777 M      include
:040000 040000 e0201f43d8aa53af3c950df61a2dfd21797187cd c53a936c815f3489145ae8ce0a6041ef2592d4d8 M      net


Reverting this commit from v3.14.1 makes the issue go away.




[  116.006227] PM: Syncing filesystems ... done.
[  116.238271] PM: Preparing system for mem sleep
[  116.382917] Freezing user space processes ... (elapsed 0.001 seconds) done.
[  116.384816] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[  116.386178] PM: Entering mem sleep
[  116.386855] wlan0: deauthenticating from 90:f6:52:4e:ba:b6 by local choice (reason=3)
[  116.406743] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  116.406926] BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
[  116.407009] IP:[  116.407022] sd 0:0:0:0: [sda] Stopping disk

[  116.407092]  [<ffffffffa002c1f1>] reg_todo+0xc1/0x4c0 [cfg80211]
[  116.407151] PGD 366ad067 PUD 366ac067 PMD 0 
[  116.407212] Oops: 0000 [#1] SMP 
[  116.407258] Modules linked in: netconsole configfs bnep bluetooth 6lowpan_iphc ipt_REJECT xt_LOG xt_limit xt_recent iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 iptable_filter nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack xt_tcpudp ip6table_filter ip6_tables nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack ip_tables x_tables ctr ccm snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_pcm snd_seq iTCO_wdt acer_wmi sparse_keymap iTCO_vendor_support ath9k snd_seq_device snd_timer snd_mixer_oss snd atl1c coretemp shpchp lpc_ich pcspkr joydev i2c_i801 hid_multitouch serio_raw mfd_core ac wmi battery acpi_cpufreq soundcore sg sha256_ssse3 sha256_generic cbc linear md_mod af_packet usbhid i915 uhci_hcd i2c_algo_bit drm_kms_helper drm ehci_pci ehci_hcd video usbcore button usb_common scsi_dh_rdac scsi_dh_alua scsi_dh_emc scsi_dh_hp_sw scsi_dh dm_mirror dm_region_hash dm_log dm_crypt dm_snap!
 shot dm_bufio dm_mod glue_helper lrw gf128mul ablk_helper cryptd aes_x86_64 arc4 ath9k_common ath9k_hw ath mac80211 cfg80211 rfkill fan processor thermal [last unloaded: ath9k]
[  116.408005] CPU: 1 PID: 3405 Comm: kworker/1:3 Tainted: G          I  3.14.1 #3
[  116.408005] Hardware name: Acer Aspire 1825PTZ/JM12-MS-CAP, BIOS V1.3127 04/23/2010
[  116.408005] Workqueue: events reg_todo [cfg80211]
[  116.408005] task: ffff8801b38225d0 ti: ffff8800370cc000 task.ti: ffff8800370cc000
[  116.408005] RIP: 0010:[<ffffffffa002c1f1>]  [<ffffffffa002c1f1>] reg_todo+0xc1/0x4c0 [cfg80211]
[  116.408005] RSP: 0018:ffff8800370cdde8  EFLAGS: 00010297
[  116.408005] RAX: ffffffffa0075360 RBX: ffff8801b256e530 RCX: 0000000000000003
[  116.408005] RDX: 0000000000000000 RSI: ffff8801bfc92ed8 RDI: 0000000000000000
[  116.408005] RBP: ffff8800370cde20 R08: fffe801d4b000000 R09: 9600000000000000
[  116.408005] R10: 00017fe2550752c0 R11: 0000000000000000 R12: 0000000000000000
[  116.408005] R13: ffff8801b256e51c R14: ffff8801b256e500 R15: 0000000000000040
[  116.408005] FS:  0000000000000000(0000) GS:ffff8801bfc80000(0000) knlGS:0000000000000000
[  116.408005] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  116.408005] CR2: 0000000000000038 CR3: 0000000037bb9000 CR4: 00000000000407e0
[  116.408005] Stack:
[  116.408005]  ffff8800370cde20 ffffffffa004aaff ffff8801b2f9f800 ffff8801bfc92ec0
[  116.408005]  ffffffffa00752c0 0000000000000000 0000000000000040 ffff8800370cde68
[  116.408005]  ffffffff81071dd8 00000000b2e45800 ffff8801bfc96a00 ffff8801bfc92ed8
[  116.408005] Call Trace:
[  116.408005]  [<ffffffffa004aaff>] ? disconnect_work+0xbf/0xd0 [cfg80211]
[  116.408005]  [<ffffffff81071dd8>] process_one_work+0x178/0x420
[  116.408005]  [<ffffffff810729f9>] worker_thread+0x119/0x3a0
[  116.408005]  [<ffffffff810728e0>] ? rescuer_thread+0x360/0x360
[  116.408005]  [<ffffffff81078f9d>] kthread+0xcd/0xf0
[  116.408005]  [<ffffffff81078ed0>] ? kthread_create_on_node+0x180/0x180
[  116.408005]  [<ffffffff8159a24c>] ret_from_fork+0x7c/0xb0
[  116.408005]  [<ffffffff81078ed0>] ? kthread_create_on_node+0x180/0x180
[  116.408005] Code: 86 02 00 00 83 f9 01 0f 84 cc 01 00 00 72 4b 83 f9 03 0f 85 a2 01 00 00 48 8b 05 6b 91 04 00 8b 50 14 83 fa 01 0f 84 63 03 00 00 <41> f6 44 24 38 10 0f 85 3e 03 00 00 0f b6 4b ec f6 81 00 5d 64 
[  116.408005] RIP  [<ffffffffa002c1f1>] reg_todo+0xc1/0x4c0 [cfg80211]
[  116.408005]  RSP <ffff8800370cdde8>
[  116.408005] CR2: 0000000000000038
[  116.408005] ---[ end trace fab5039fc72cc2f8 ]---
[  116.421606] BUG: unable to handle kernel paging request at ffffffffffffffd8
[  116.424210] IP: [<ffffffff8107953b>] kthread_data+0xb/0x20
[  116.425551] PGD 1a0f067 PUD 1a11067 PMD 0 
[  116.425551] Oops: 0000 [#2] SMP 
[  116.425551] Modules linked in: netconsole configfs bnep bluetooth 6lowpan_iphc ipt_REJECT xt_LOG xt_limit xt_recent iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 iptable_filter nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack xt_tcpudp ip6table_filter ip6_tables nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack ip_tables x_tables ctr ccm snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_pcm snd_seq iTCO_wdt acer_wmi sparse_keymap iTCO_vendor_support ath9k snd_seq_device snd_timer snd_mixer_oss snd atl1c coretemp shpchp lpc_ich pcspkr joydev i2c_i801 hid_multitouch serio_raw mfd_core ac wmi battery acpi_cpufreq soundcore sg sha256_ssse3 sha256_generic cbc linear md_mod af_packet usbhid i915 uhci_hcd i2c_algo_bit drm_kms_helper drm ehci_pci ehci_hcd video usbcore button usb_common scsi_dh_rdac scsi_dh_alua scsi_dh_emc scsi_dh_hp_sw scsi_dh dm_mirror dm_region_hash dm_log dm_crypt dm_snap!
 shot dm_bufio dm_mod glue_helper lrw gf128mul ablk_helper cryptd aes_x86_64 arc4 ath9k_common ath9k_hw ath mac80211 cfg80211 rfkill fan processor thermal [last unloaded: ath9k]
[  116.425551] CPU: 1 PID: 3405 Comm: kworker/1:3 Tainted: G      D   I  3.14.1 #3
[  116.425551] Hardware name: Acer Aspire 1825PTZ/JM12-MS-CAP, BIOS V1.3127 04/23/2010
[  116.425551] task: ffff8801b38225d0 ti: ffff8800370cc000 task.ti: ffff8800370cc000
[  116.425551] RIP: 0010:[<ffffffff8107953b>]  [<ffffffff8107953b>] kthread_data+0xb/0x20
[  116.425551] RSP: 0018:ffff8800370cda40  EFLAGS: 00010002
[  116.425551] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000007
[  116.425551] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8801b38225d0
[  116.425551] RBP: ffff8800370cda40 R08: 0000000000000000 R09: 0000000000000246
[  116.425551] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801b3822ae0
[  116.425551] R13: 0000000000000001 R14: ffff8801b38225c0 R15: ffff8801b38225d0
[  116.425551] FS:  0000000000000000(0000) GS:ffff8801bfc80000(0000) knlGS:0000000000000000
[  116.425551] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  116.425551] CR2: 0000000000000028 CR3: 0000000037bb9000 CR4: 00000000000407e0
[  116.425551] Stack:
[  116.425551]  ffff8800370cda58 ffffffff81072ffc ffff8801bfc93640 ffff8800370cdab8
[  116.425551]  ffffffff8158e6ab ffff8801b38225d0 ffff8800370cdfd8 0000000000013640
[  116.425551]  0000000000013640 ffff8801b38225d0 ffff8801b3822d00 ffff8801b38225c0
[  116.425551] Call Trace:
[  116.425551]  [<ffffffff81072ffc>] wq_worker_sleeping+0xc/0x80
[  116.425551]  [<ffffffff8158e6ab>] __schedule+0x52b/0x760
[  116.425551]  [<ffffffff8158e904>] schedule+0x24/0x70
[  116.425551]  [<ffffffff810598ff>] do_exit+0x6cf/0xa40
[  116.425551]  [<ffffffff810adc88>] ? console_unlock+0x1e8/0x3f0
[  116.425551]  [<ffffffff81592e87>] oops_end+0x97/0xe0
[  116.425551]  [<ffffffff815862af>] no_context+0x279/0x286
[  116.425551]  [<ffffffff8158632a>] __bad_area_nosemaphore+0x6e/0x1c7
[  116.425551]  [<ffffffff81586491>] bad_area_nosemaphore+0xe/0x10
[  116.425551]  [<ffffffff8159547c>] __do_page_fault+0x8c/0x520
[  116.425551]  [<ffffffff8100a875>] ? native_sched_clock+0x35/0x90
[  116.425551]  [<ffffffff8108e77d>] ? set_next_entity+0x8d/0xa0
[  116.425551]  [<ffffffff8106fca0>] ? insert_work+0x50/0xa0
[  116.425551]  [<ffffffff81595932>] do_page_fault+0x22/0x30
[  116.425551]  [<ffffffff81592338>] page_fault+0x28/0x30
[  116.425551]  [<ffffffffa002c1f1>] ? reg_todo+0xc1/0x4c0 [cfg80211]
[  116.425551]  [<ffffffffa002c1bb>] ? reg_todo+0x8b/0x4c0 [cfg80211]
[  116.425551]  [<ffffffffa004aaff>] ? disconnect_work+0xbf/0xd0 [cfg80211]
[  116.425551]  [<ffffffff81071dd8>] process_one_work+0x178/0x420
[  116.425551]  [<ffffffff810729f9>] worker_thread+0x119/0x3a0
[  116.425551]  [<ffffffff810728e0>] ? rescuer_thread+0x360/0x360
[  116.425551]  [<ffffffff81078f9d>] kthread+0xcd/0xf0
[  116.425551]  [<ffffffff81078ed0>] ? kthread_create_on_node+0x180/0x180
[  116.425551]  [<ffffffff8159a24c>] ret_from_fork+0x7c/0xb0
[  116.425551]  [<ffffffff81078ed0>] ? kthread_create_on_node+0x180/0x180
[  116.425551] Code: 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 8b 87 b8 04 00 00 55 48 89 e5 <48> 8b 40 d8 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 
[  116.425551] RIP  [<ffffffff8107953b>] kthread_data+0xb/0x20
[  116.425551]  RSP <ffff8800370cda40>
[  116.425551] CR2: ffffffffffffffd8
[  116.425551] ---[ end trace fab5039fc72cc2f9 ]---
[  116.425551] Fixing recursive fault but reboot is needed!
[  116.573796] Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 0
[  116.573796] Shutting down cpus with NMI
[  116.573796] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[  116.573796] drm_kms_helper: panic occurred, switching back to text console
[  116.573796] Rebooting in 90 seconds..



-- 
MfG,

Michael Leun

