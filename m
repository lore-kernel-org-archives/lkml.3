Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315Ab3EGA5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 20:57:54 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:62427 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179Ab3EGA5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 20:57:52 -0400
MIME-Version: 1.0
In-Reply-To: <2183106.5nsY0q0PTD@vostro.rjw.lan>
References: <CAOULuObQq+WPf97LdsD5kN6cq=E9TvaHzqGzdKSWRme-Nk+WQQ@mail.gmail.com>
	<1612326.XDA8n1le4S@vostro.rjw.lan>
	<CAOULuObvuy_iTWp3sgqcvk39eF3KN2X77St=2A6w-BaeokFr2Q@mail.gmail.com>
	<2183106.5nsY0q0PTD@vostro.rjw.lan>
Date: Mon, 6 May 2013 20:57:51 -0400
Message-ID: <CAOULuObmovvZQDibCJto-KN8DbpQpBwMsmFh1nmXj+hFwE1CaQ@mail.gmail.com>
Subject: Re: Immediate wakeup after suspend
From: Parag Warudkar <parag.lkml@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 8:45 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> I have tried disabling EHC1 and EHC2 without any difference.
>
> That may mean one of two things: (1) After you'd tried that they appeared as
> disabled, but the immediate wakeup still happened or (2) you'd tried to
> disable them, but they still appeared as enabled.
>
> Which one of them is it?
>

#1 - that is they appeared disabled but the wakeup was still
immediate. I tried that at least twice before sending the initial
email and got the immediate wakeups both times but  when I tried to
recreate this right now with the same kernel and now I get a bunch of
WARN_ON()s but no immediate wakeups. (I can still wake it up by
pressing power button.)
I will test more and also bisect to see what is going on.

Looks like unrelatedly mce is adding a timer on offline CPU or something.

[ 1699.184107] ------------[ cut here ]------------
[ 1699.184163] WARNING: at arch/x86/kernel/smp.c:123
native_smp_send_reschedule+0x58/0x60()
[ 1699.185720] Modules linked in: fuse binfmt_misc vfat fat arc4
snd_hda_codec_hdmi ath9k snd_hda_codec_cirrus ath9k_common
snd_hda_intel ath9k_hw snd_hda_codec ath snd_hwdep snd_pcm_oss
mac80211 snd_mixer_oss snd_pcm snd_page_alloc mperf coretemp
snd_seq_dummy kvm_intel snd_seq_oss kvm snd_seq_midi
snd_seq_midi_event ehci_pci snd_rawmidi ehci_hcd cfg80211 microcode
snd_seq snd_timer snd_seq_device snd apple_bl applesmc hid_appleir
soundcore joydev input_polldev lpc_ich mfd_core rfkill loop ext4
mbcache jbd2 usb_storage hid_logitech_dj radeon i2c_algo_bit
drm_kms_helper ttm drm ahci libahci libata tg3 firewire_ohci
firewire_core i2c_core crc32c_intel ptp video crc_itu_t pps_core
uhci_hcd ghash_clmulni_intel button
[ 1699.185769] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W    3.9.0+ #6
[ 1699.185794] Hardware name: Apple Inc.
iMac12,1/Mac-942B5BF58194151B, BIOS    IM121.88Z.0047.B1F.1201241648
01/24/12
[ 1699.185910]  0000000000000009 ffff8808441b9dc0 ffffffff815024f7
ffff8808441b9df8
[ 1699.186022]  ffffffff8104a270 0000000000000001 ffff8808441f0000
000000010007c511
[ 1699.186135]  0000000000000001 ffff88086fa4cac0 ffff8808441b9e08
ffffffff8104a2ba
[ 1699.186157] Call Trace:
[ 1699.186240]  [<ffffffff815024f7>] dump_stack+0x19/0x1b
[ 1699.186318]  [<ffffffff8104a270>] warn_slowpath_common+0x70/0xa0
[ 1699.186409]  [<ffffffff8104a2ba>] warn_slowpath_null+0x1a/0x20
[ 1699.186489]  [<ffffffff81025c18>] native_smp_send_reschedule+0x58/0x60
[ 1699.186566]  [<ffffffff8107c354>] wake_up_nohz_cpu+0xa4/0xd0
[ 1699.186652]  [<ffffffff8105a9a6>] add_timer_on+0x96/0x140
[ 1699.186748]  [<ffffffff8101e222>] mce_start_timer.isra.13+0x62/0x70
[ 1699.186829]  [<ffffffff8101e285>] __mcheck_cpu_init_timer+0x55/0x60
[ 1699.186913]  [<ffffffff814f83dd>] mcheck_cpu_init+0x372/0x3f8
[ 1699.187002]  [<ffffffff814f5e31>] identify_cpu+0x3bb/0x3c8
[ 1699.187087]  [<ffffffff814f5e52>] identify_secondary_cpu+0x14/0x1b
[ 1699.187165]  [<ffffffff814f876d>] smp_store_cpu_info+0x38/0x3a
[ 1699.187243]  [<ffffffff814f8c3b>] start_secondary+0x138/0x251
[ 1699.187343] ---[ end trace bf535ebf0040fc5a ]---
[ 1699.189787] Intel pstate controlling: cpu 1
[ 1699.189950] CPU1 is up
[ 1699.189965] smpboot: Booting Node 0 Processor 2 APIC 0x4
[ 1699.201271] ------------[ cut here ]------------
[ 1699.201326] WARNING: at arch/x86/kernel/smp.c:123
native_smp_send_reschedule+0x58/0x60()
[ 1699.202848] Modules linked in: fuse binfmt_misc vfat fat arc4
snd_hda_codec_hdmi ath9k snd_hda_codec_cirrus ath9k_common
snd_hda_intel ath9k_hw snd_hda_codec ath snd_hwdep snd_pcm_oss
mac80211 snd_mixer_oss snd_pcm snd_page_alloc mperf coretemp
snd_seq_dummy kvm_intel snd_seq_oss kvm snd_seq_midi
snd_seq_midi_event ehci_pci snd_rawmidi ehci_hcd cfg80211 microcode
snd_seq snd_timer snd_seq_device snd apple_bl applesmc hid_appleir
soundcore joydev input_polldev lpc_ich mfd_core rfkill loop ext4
mbcache jbd2 usb_storage hid_logitech_dj radeon i2c_algo_bit
drm_kms_helper ttm drm ahci libahci libata tg3 firewire_ohci
firewire_core i2c_core crc32c_intel ptp video crc_itu_t pps_core
uhci_hcd ghash_clmulni_intel button
[ 1699.202896] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G        W    3.9.0+ #6
[ 1699.202920] Hardware name: Apple Inc.
iMac12,1/Mac-942B5BF58194151B, BIOS    IM121.88Z.0047.B1F.1201241648
01/24/12
[ 1699.203033]  0000000000000009 ffff8808441bbdc0 ffffffff815024f7
ffff8808441bbdf8
[ 1699.203142]  ffffffff8104a270 0000000000000002 ffff8808442bc000
000000010007c50e
[ 1699.203253]  0000000000000002 ffff88086fa8cac0 ffff8808441bbe08
ffffffff8104a2ba
[ 1699.203275] Call Trace:
[ 1699.203356]  [<ffffffff815024f7>] dump_stack+0x19/0x1b
[ 1699.203432]  [<ffffffff8104a270>] warn_slowpath_common+0x70/0xa0
[ 1699.203522]  [<ffffffff8104a2ba>] warn_slowpath_null+0x1a/0x20
[ 1699.203599]  [<ffffffff81025c18>] native_smp_send_reschedule+0x58/0x60
[ 1699.203674]  [<ffffffff8107c354>] wake_up_nohz_cpu+0xa4/0xd0
[ 1699.203758]  [<ffffffff8105a9a6>] add_timer_on+0x96/0x140
[ 1699.203853]  [<ffffffff8101e222>] mce_start_timer.isra.13+0x62/0x70
[ 1699.203933]  [<ffffffff8101e285>] __mcheck_cpu_init_timer+0x55/0x60
[ 1699.204014]  [<ffffffff814f83dd>] mcheck_cpu_init+0x372/0x3f8
[ 1699.204101]  [<ffffffff814f5e31>] identify_cpu+0x3bb/0x3c8
[ 1699.204184]  [<ffffffff814f5e52>] identify_secondary_cpu+0x14/0x1b
[ 1699.204260]  [<ffffffff814f876d>] smp_store_cpu_info+0x38/0x3a
[ 1699.204336]  [<ffffffff814f8c3b>] start_secondary+0x138/0x251
[ 1699.204436] ---[ end trace bf535ebf0040fc5b ]---
[ 1699.206956] Intel pstate controlling: cpu 2
[ 1699.207079] CPU2 is up
[ 1699.207093] smpboot: Booting Node 0 Processor 3 APIC 0x6
[ 1699.218398] ------------[ cut here ]------------
[ 1699.218455] WARNING: at arch/x86/kernel/smp.c:123
native_smp_send_reschedule+0x58/0x60()
[ 1699.220021] Modules linked in: fuse binfmt_misc vfat fat arc4
snd_hda_codec_hdmi ath9k snd_hda_codec_cirrus ath9k_common
snd_hda_intel ath9k_hw snd_hda_codec ath snd_hwdep snd_pcm_oss
mac80211 snd_mixer_oss snd_pcm snd_page_alloc mperf coretemp
snd_seq_dummy kvm_intel snd_seq_oss kvm snd_seq_midi
snd_seq_midi_event ehci_pci snd_rawmidi ehci_hcd cfg80211 microcode
snd_seq snd_timer snd_seq_device snd apple_bl applesmc hid_appleir
soundcore joydev input_polldev lpc_ich mfd_core rfkill loop ext4
mbcache jbd2 usb_storage hid_logitech_dj radeon i2c_algo_bit
drm_kms_helper ttm drm ahci libahci libata tg3 firewire_ohci
firewire_core i2c_core crc32c_intel ptp video crc_itu_t pps_core
uhci_hcd ghash_clmulni_intel button
[ 1699.220069] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G        W    3.9.0+ #6
[ 1699.220095] Hardware name: Apple Inc.
iMac12,1/Mac-942B5BF58194151B, BIOS    IM121.88Z.0047.B1F.1201241648
01/24/12
[ 1699.220212]  0000000000000009 ffff8808441bddc0 ffffffff815024f7
ffff8808441bddf8
[ 1699.220324]  ffffffff8104a270 0000000000000003 ffff880844304000
000000010007c637
[ 1699.220438]  0000000000000003 ffff88086faccac0 ffff8808441bde08
ffffffff8104a2ba
[ 1699.220461] Call Trace:
[ 1699.220543]  [<ffffffff815024f7>] dump_stack+0x19/0x1b
[ 1699.220622]  [<ffffffff8104a270>] warn_slowpath_common+0x70/0xa0
[ 1699.220715]  [<ffffffff8104a2ba>] warn_slowpath_null+0x1a/0x20
[ 1699.220795]  [<ffffffff81025c18>] native_smp_send_reschedule+0x58/0x60
[ 1699.220872]  [<ffffffff8107c354>] wake_up_nohz_cpu+0xa4/0xd0
[ 1699.220959]  [<ffffffff8105a9a6>] add_timer_on+0x96/0x140
[ 1699.221056]  [<ffffffff8101e222>] mce_start_timer.isra.13+0x62/0x70
[ 1699.221139]  [<ffffffff8101e285>] __mcheck_cpu_init_timer+0x55/0x60
[ 1699.221223]  [<ffffffff814f83dd>] mcheck_cpu_init+0x372/0x3f8
[ 1699.221313]  [<ffffffff814f5e31>] identify_cpu+0x3bb/0x3c8
[ 1699.221398]  [<ffffffff814f5e52>] identify_secondary_cpu+0x14/0x1b
[ 1699.221476]  [<ffffffff814f876d>] smp_store_cpu_info+0x38/0x3a
[ 1699.221554]  [<ffffffff814f8c3b>] start_secondary+0x138/0x251
[ 1699.221655] ---[ end trace bf535ebf0040fc5c ]---

Parag
