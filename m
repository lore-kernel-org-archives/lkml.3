Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab3CBTtZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 14:49:25 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57387 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab3CBTtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 14:49:24 -0500
Date: Sat, 2 Mar 2013 19:49:23 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Russ Dill <russ.dill@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: fasync race in fs/fcntl.c
Message-ID: <20130302194923.GE4503@ZenIV.linux.org.uk>
References: <CA+Bv8XZM7yO-=vrGZg5LFLik8YkQiMC9ppCgQbyi1yuLiKstJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+Bv8XZM7yO-=vrGZg5LFLik8YkQiMC9ppCgQbyi1yuLiKstJQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 02, 2013 at 03:00:28AM -0800, Russ Dill wrote:
> I'm seeing a race in fs/fcntl.c. I'm not sure exactly how the race is
> occurring, but the following is my best guess. A kernel log is
> attached.

[snip the analysis - it's a different lock anyway]

The traces below are essentially sys_execve() getting to get_random_bytes(),
to kill_fasync(), to send_sigio(), which spins on tasklist_lock.

Could you rebuild it with lockdep enabled and try to reproduce that?
I very much doubt that this execve() is a part of deadlock - it's
getting caught on one, but it shouldn't be holding any locks that
nest inside tasklist_lock at that point, so even it hadn't been there,
the process holding tasklist_lock probably wouldn't have progressed any
further...

> I exercise this by running a UML instance which uses /dev/random.
> After a day or so, I'll eventually get a crash or a hang. I captured
> this with netconsole.
> 
> 
> [172635.399438] ------------[ cut here ]------------
> [172635.399449] WARNING: at
> /build/buildd/linux-3.8.0/kernel/watchdog.c:246
> watchdog_overflow_callback+0x9c/0xd0()
> [172635.399451] Hardware name: VPCSE190X
> [172635.399454] Watchdog detected hard LOCKUP on cpu 0
> [172635.399456] Modules linked in: ftdi_sio netconsole(F) configfs(F)
> ext2(F) nls_iso8859_1(F) usb_storage(F) pl2303 usbserial snd
> _usb_audio snd_usbmidi_lib parport_pc(F) ppdev(F) lp(F) parport(F)
> bnep rfcomm bluetooth binfmt_misc(F) dm_crypt(F) uvcvideo arc4(
> F) snd_hda_codec_hdmi iwldvm snd_hda_codec_realtek snd_hda_intel
> videobuf2_vmalloc videobuf2_memops mac80211 videobuf2_core snd_hd
> a_codec videodev snd_hwdep(F) coretemp snd_pcm(F) snd_page_alloc(F)
> joydev(F) iwlwifi[172635.399521] ------------[ cut here ]------------
> [172635.399525] WARNING: at
> /build/buildd/linux-3.8.0/net/core/skbuff.c:573
> skb_release_head_state+0xed/0x100()
> [172635.399525] Hardware name: VPCSE190X
> [172635.399526] Modules linked in: ftdi_sio netconsole(F) configfs(F)
> ext2(F) nls_iso8859_1(F) usb_storage(F) pl2303 usbserial snd_usb_audio
> snd_usbmidi_lib parport_pc(F) ppdev(F) lp(F) parport(F) bnep rfcomm
> bluetooth binfmt_misc(F) dm_crypt(F) uvcvideo arc4(F)
> snd_hda_codec_hdmi iwldvm snd_hda_codec_realtek snd_hda_intel
> videobuf2_vmalloc videobuf2_memops mac80211 videobuf2_core
> snd_hda_codec videodev snd_hwdep(F) coretemp snd_pcm(F)
> snd_page_alloc(F) joydev(F) iwlwifi kvm_intel snd_seq_midi(F)
> snd_seq_midi_event(F) snd_rawmidi(F) kvm cfg80211 dm_multipath(F)
> snd_seq(F) snd_seq_device(F) tpm_infineon snd_timer(F) psmouse(F)
> snd(F) soundcore(F) scsi_dh serio_raw(F) sony_laptop rtsx_pci_ms mei
> microcode(F) memstick mac_hid pcspkr lpc_ich tpm_tis firewire_sbp2
> firewire_core crc_itu_t(F) btrfs(F) zlib_deflate(F) libcrc32c(F)
> hid_generic usbhid hid rtsx_pci_sdmmc ghash_clmulni_intel(F)
> aesni_intel(F) aes_x86_64(F) xts(F) lrw(F) gf128mul(F) ablk_helper(F)
> cryptd(F) radeon ahci(F) libahci(F) r8169 i915 ttm i2c_algo_bit
> drm_kms_helper video(F) drm rtsx_pci
> [172635.399572] Pid: 12575, comm: flock Tainted: GF
> 3.8.0-7-generic #15-Ubuntu
> [172635.399572] Call Trace:
> [172635.399573]  <NMI>  [<ffffffff810587cf>] warn_slowpath_common+0x7f/0xc0
> [172635.399577]  [<ffffffff8105882a>] warn_slowpath_null+0x1a/0x20
> [172635.399579]  [<ffffffff815b51bd>] skb_release_head_state+0xed/0x100
> [172635.399580]  [<ffffffff815b4fb2>] __kfree_skb+0x12/0xa0
> [172635.399582]  [<ffffffff815b551c>] consume_skb+0x2c/0x80
> [172635.399586]  [<ffffffffa014cf47>] rtl8169_poll+0x4b7/0x6d0 [r8169]
> [172635.399590]  [<ffffffff815d96c2>] netpoll_poll_dev+0x162/0x580
> [172635.399593]  [<ffffffff815b666b>] ? __alloc_skb+0x8b/0x2a0
> [172635.399595]  [<ffffffff815d9c6c>] netpoll_send_skb_on_dev+0x18c/0x3a0
> [172635.399598]  [<ffffffff815da198>] netpoll_send_udp+0x278/0x2a0
> [172635.399600]  [<ffffffffa07c4967>] write_msg+0xc7/0x110 [netconsole]
> [172635.399603]  [<ffffffff810594f1>]
> call_console_drivers.constprop.13+0x91/0x100
> [172635.399605]  [<ffffffff81059e4b>] console_unlock+0x2db/0x420
> [172635.399606]  [<ffffffff8105a7dd>] vprintk_emit+0x1fd/0x4e0
> [172635.399608]  [<ffffffff810e8ffc>] ? watchdog_overflow_callback+0x9c/0xd0
> [172635.399610]  [<ffffffff816b78c1>] printk+0x67/0x69
> [172635.399613]  [<ffffffff810c0423>] print_modules+0xa3/0xd0
> [172635.399617]  [<ffffffff810587ca>] warn_slowpath_common+0x7a/0xc0
> [172635.399618]  [<ffffffff810588cc>] warn_slowpath_fmt+0x4c/0x50
> [172635.399620]  [<ffffffff8109170d>] ? sched_clock_cpu+0xbd/0x110
> [172635.399623]  [<ffffffff810e8f60>] ? touch_nmi_watchdog+0x80/0x80
> [172635.399625]  [<ffffffff810e8ffc>] watchdog_overflow_callback+0x9c/0xd0
> [172635.399627]  [<ffffffff8112609d>] __perf_event_overflow+0x9d/0x230
> [172635.399630]  [<ffffffff81025277>] ? x86_perf_event_set_period+0xd7/0x160
> [172635.399632]  [<ffffffff81126cb4>] perf_event_overflow+0x14/0x20
> [172635.399634]  [<ffffffff8102ad8b>] intel_pmu_handle_irq+0x1ab/0x330
> [172635.399637]  [<ffffffff816c5b9d>] perf_event_nmi_handler+0x1d/0x20
> [172635.399640]  [<ffffffff816c5351>] nmi_handle.isra.0+0x51/0x80
> [172635.399641]  [<ffffffff816c5460>] do_nmi+0xe0/0x360
> [172635.399643]  [<ffffffff816c4981>] end_repeat_nmi+0x1e/0x2e
> [172635.399645]  [<ffffffff813536d9>] ? __read_lock_failed+0x9/0x20
> [172635.399648]  [<ffffffff813536d9>] ? __read_lock_failed+0x9/0x20
> [172635.399649]  [<ffffffff813536d9>] ? __read_lock_failed+0x9/0x20
> [172635.399651]  <<EOE>>  [<ffffffff816c3e13>] _raw_read_lock+0x13/0x20
> [172635.399654]  [<ffffffff811a4532>] send_sigio+0x52/0xf0
> [172635.399656]  [<ffffffff811a4631>] kill_fasync+0x61/0x90
> [172635.399658]  [<ffffffff8143ad83>] account+0x113/0x1d0
> [172635.399661]  [<ffffffff816c4618>] ? page_fault+0x28/0x30
> [172635.399663]  [<ffffffff8143b335>] extract_entropy+0x65/0x140
> [172635.399664]  [<ffffffff8143b650>] get_random_bytes+0x20/0x30
> [172635.399666]  [<ffffffff816bb2a9>] create_elf_tables+0xaa/0x614
> [172635.399669]  [<ffffffff811e8a84>] load_elf_binary+0xae4/0xe00
> [172635.399672]  [<ffffffff811e7fa0>] ? load_elf_library+0x240/0x240
> [172635.399674]  [<ffffffff8119999e>] search_binary_handler+0x19e/0x340
> [172635.399677]  [<ffffffff8119ad15>] do_execve_common.isra.22+0x3c5/0x470
> [172635.399679]  [<ffffffff8119add8>] do_execve+0x18/0x20
> [172635.399680]  [<ffffffff8119b07d>] sys_execve+0x3d/0x60
> [172635.399682]  [<ffffffff816ccb49>] stub_execve+0x69/0xc0
> [172635.399685] ---[ end trace 5ccb38c703860d58 ]---
> [172635.399687] ------------[ cut here ]------------
> [172635.399688] WARNING: at
> /build/buildd/linux-3.8.0/net/core/skbuff.c:573
> skb_release_head_state+0xed/0x100()
> [172635.399689] Hardware name: VPCSE190X
> [172635.399689] Modules linked in: ftdi_sio netconsole(F) configfs(F)
> ext2(F) nls_iso8859_1(F) usb_storage(F) pl2303 usbserial snd_usb_audio
> snd_usbmidi_lib parport_pc(F) ppdev(F) lp(F) parport(F) bnep rfcomm
> bluetooth binfmt_misc(F) dm_crypt(F) uvcvideo arc4(F)
> snd_hda_codec_hdmi iwldvm snd_hda_codec_realtek snd_hda_intel
> videobuf2_vmalloc videobuf2_memops mac80211 videobuf2_core
> snd_hda_codec videodev snd_hwdep(F) coretemp snd_pcm(F)
> snd_page_alloc(F) joydev(F) iwlwifi kvm_intel snd_seq_midi(F)
> snd_seq_midi_event(F) snd_rawmidi(F) kvm cfg80211 dm_multipath(F)
> snd_seq(F) snd_seq_device(F) tpm_infineon snd_timer(F) psmouse(F)
> snd(F) soundcore(F) scsi_dh serio_raw(F) sony_laptop rtsx_pci_ms mei
> microcode(F) memstick mac_hid pcspkr lpc_ich tpm_tis firewire_sbp2
> firewire_core crc_itu_t(F) btrfs(F) zlib_deflate(F) libcrc32c(F)
> hid_generic usbhid hid rtsx_pci_sdmmc ghash_clmulni_intel(F)
> aesni_intel(F) aes_x86_64(F) xts(F) lrw(F) gf128mul(F) ablk_helper(F)
> cryptd(F) radeon ahci(F) libahci(F) r8169 i915 ttm i2c_algo_bit
> drm_kms_helper video(F) drm rtsx_pci
> [172635.399725] Pid: 12575, comm: flock Tainted: GF       W
> 3.8.0-7-generic #15-Ubuntu
> [172635.399726] Call Trace:
> [172635.399726]  <NMI>  [<ffffffff810587cf>] warn_slowpath_common+0x7f/0xc0
> [172635.399728]  [<ffffffff8105882a>] warn_slowpath_null+0x1a/0x20
> [172635.399729]  [<ffffffff815b51bd>] skb_release_head_state+0xed/0x100
> [172635.399731]  [<ffffffff815b4fb2>] __kfree_skb+0x12/0xa0
> [172635.399732]  [<ffffffff815b551c>] consume_skb+0x2c/0x80
> [172635.399735]  [<ffffffffa014cf47>] rtl8169_poll+0x4b7/0x6d0 [r8169]
> [172635.399738]  [<ffffffff815d96c2>] netpoll_poll_dev+0x162/0x580
> [172635.399740]  [<ffffffff815b666b>] ? __alloc_skb+0x8b/0x2a0
> [172635.399742]  [<ffffffff815d9c6c>] netpoll_send_skb_on_dev+0x18c/0x3a0
> [172635.399744]  [<ffffffff815da198>] netpoll_send_udp+0x278/0x2a0
> [172635.399746]  [<ffffffffa07c4967>] write_msg+0xc7/0x110 [netconsole]
> [172635.399749]  [<ffffffff810594f1>]
> call_console_drivers.constprop.13+0x91/0x100
> [172635.399750]  [<ffffffff81059e4b>] console_unlock+0x2db/0x420
> [172635.399752]  [<ffffffff8105a7dd>] vprintk_emit+0x1fd/0x4e0
> [172635.399754]  [<ffffffff810e8ffc>] ? watchdog_overflow_callback+0x9c/0xd0
> [172635.399756]  [<ffffffff816b78c1>] printk+0x67/0x69
> [172635.399757]  [<ffffffff810c0423>] print_modules+0xa3/0xd0
> [172635.399760]  [<ffffffff810587ca>] warn_slowpath_common+0x7a/0xc0
> [172635.399761]  [<ffffffff810588cc>] warn_slowpath_fmt+0x4c/0x50
> [172635.399763]  [<ffffffff8109170d>] ? sched_clock_cpu+0xbd/0x110
> [172635.399765]  [<ffffffff810e8f60>] ? touch_nmi_watchdog+0x80/0x80
> [172635.399766]  [<ffffffff816c4981>] end_repeat_nmi+0x1e/0x2e
>  [<ffffffff811a4631>] kill_fasync+0x61/0x90
> [172635.399793]  [<ffffffff8143ad83>] account+0x113/0x1d0
> [172635.399794]  [<ffffffff816c4618>] ? page_fault+0x28/0x30
> [172635.399796] [172635.399800]  [<ffffffff816bb2a9>]
> create_elf_tables+0xaa/0x614
> [172635.399802]  [<ffffffff811e8a84>] load_elf_binary+0xae4/0xe00
> [172635.399804]  [<ffffffff811e7fa0>] ? load_elf_library+0x240/0x240
>  [<ffffffff8119ad15>] do_execve_common.isra.22+0x3c5/0x470
> [172635.399810]  [<ffffffff8119add8>] do_execve+0x18/0x20
> [172635.399812]  [<ffffffff8119b07d>] sys_execve+0x3d/0x60
> [172635.399813]  netconsole(F) configfs(F) ext2(F) bnep rfcomm
> bluetooth binfmt_misc(F) dm_crypt(F) uvcvideo arc4(F)
> snd_hda_codec_hdmi iwldvm snd_hwdep(F) coretemp snd_pcm(F)
> snd_page_alloc(F) joydev(F) iwlwifi kvm_intel snd_seq_midi(F) scsi_dh
> serio_raw(F) sony_laptop rtsx_pci_ms mei aes_x86_64(F) xts(F) lrw(F)
> gf128mul(F) ablk_helper(F) i2c_algo_bit drm_kms_helper[172635.399858]
> [<ffffffff815b51bd>] skb_release_head_state+0xed/0x100
> [172635.399860]  [<ffffffff815b4fb2>] __kfree_skb+0x12/0xa0
> [172635.399861]  [<ffffffff815b551c>] consume_skb+0x2c/0x80
>  [<ffffffff815b666b>] ? __alloc_skb+0x8b/0x2a0
> [172635.399870]  [<ffffffff815d9c6c>] netpoll_send_skb_on_dev+0x18c/0x3a0
>  [<ffffffff810e8ffc>] ? watchdog_overflow_callback+0x9c/0xd0
> [172635.399884]  [<ffffffff816b78c1>] printk+0x67/0x69
>  [<ffffffff810588cc>] warn_slowpath_fmt+0x4c/0x50
> [172635.399891]  [<ffffffff8109170d>] ? sched_clock_cpu+0xbd/0x110
> [172635.399893]  [<ffffffff810e8f60>] ? touch_nmi_watchdog+0x80/0x80
> [172635.399894]  [<ffffffff810e8ffc>] watchdog_overflow_callback+0x9c/0xd0
> [172635.399896] [172635.399903] [172635.399907] [172635.399912]
> [<ffffffff813536d9>] ? __read_lock_failed+0x9/0x20
> [172635.399914]  [<ffffffff813536d9>] ? __read_lock_failed+0x9/0x20
> [172635.399916]  <<EOE>>  [<ffffffff816c3e13>] _raw_read_lock+0x13/0x20
> [172635.399918]  [<ffffffff811a4532>] send_sigio+0x52/0xf0
>  [<ffffffff816bb2a9>] create_elf_tables+0xaa/0x614
> [172635.399929] [172635.399939]  [<ffffffff8119b07d>] sys_execve+0x3d/0x60
> [172635.399941]  [<ffffffff816ccb49>] stub_execve+0x69/0xc0
> [172635.399943] ---[ end trace 5ccb38c703860d5a ]---
> [172635.399944] ------------[ cut here ]------------
>  nls_iso8859_1(F) usb_storage(F) parport_pc(F) ppdev(F) bluetooth
> binfmt_misc(F) snd_hda_intel videobuf2_vmalloc videobuf2_memops
> mac80211 videobuf2_core snd_hda_codec videodev snd_hwdep(F) snd_pcm(F)
> snd_page_alloc(F) joydev(F) iwlwifi kvm_intel snd_seq_midi(F)
> snd_seq_midi_event(F) dm_multipath(F) snd_seq(F) snd_seq_device(F)
> tpm_infineon snd_timer(F)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
