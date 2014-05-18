Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaERNm3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 09:42:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57468 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbaERNm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 09:42:26 -0400
Date: Sun, 18 May 2014 15:42:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: Francis Moreau <francis.moro@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Matt Fleming <matt@console-pimps.org>,
        linux-efi <linux-efi@vger.kernel.org>
Subject: Re: kernel 3.14.2 oops: seems related to EFI
Message-ID: <20140518134206.GA8040@pd.tnic>
References: <53777F7B.8060407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53777F7B.8060407@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 05:25:47PM +0200, Francis Moreau wrote:
> [  +0.018677] general protection fault: 0000 [#1] PREEMPT SMP
> [  +0.000068] Modules linked in: usb_storage tun raid1 md_mod loop fuse
> joydev coretemp hwmon arc4 intel_rapl x86_pkg_temp_thermal
> intel_powerclamp kvm_intel nls_iso8859_1 nls_cp437 iTCO_wdt kvm vfat fat
> iTCO_vendor_support iwldvm uvcvideo led_class crct10dif_pclmul
> crc32_pclmul crc32c_intel ghash_clmulni_intel mac80211 videobuf2_vmalloc
> videobuf2_memops videobuf2_core aesni_intel videodev aes_x86_64
> snd_hda_codec_hdmi lrw gf128mul mousedev glue_helper btusb
> snd_hda_codec_via ablk_helper media cryptd iwlwifi snd_hda_codec_generic
> bluetooth psmouse microcode i2c_i801 serio_raw cfg80211 6lowpan_iphc
> rtsx_pci_ms r8169 memstick rfkill lpc_ich mii snd_hda_intel
> snd_hda_codec thermal snd_hwdep wmi snd_pcm tpm_infineon snd_timer
> tpm_tis mei_me snd tpm mei shpchp evdev soundcore processor battery
> mac_hid ac
> [  +0.000803]  ext4 crc16 mbcache jbd2 hid_generic usbhid hid bcache
> sd_mod sr_mod crc_t10dif cdrom crct10dif_common rtsx_pci_sdmmc mmc_core
> atkbd libps2 ahci libahci ehci_pci libata xhci_hcd ehci_hcd scsi_mod
> rtsx_pci usbcore usb_common i8042 serio i915 video button intel_gtt
> i2c_algo_bit drm_kms_helper drm i2c_core
> [  +0.000328] CPU: 0 PID: 30835 Comm: systemd-udevd Not tainted
> 3.14.2-1-ARCH #1
> [  +0.000064] Hardware name: CLEVO CO.                        W55xEU
>                       /W55xEU                          , BIOS 4.6.5
> 03/05/2013
> [  +0.000102] task: ffff880405ee6bf0 ti: ffff880400f4a000 task.ti:
> ffff880400f4a000
> [  +0.000060] RIP: 0010:[<ffffffff810655af>]  [<ffffffff810655af>]
> efi_call5+0x6f/0xf0
> [  +0.000071] RSP: 0018:ffff880400f4bdb0  EFLAGS: 00010002
> [  +0.000045] RAX: 0000000080050033 RBX: ffff8804040e3000 RCX:
> ffff8804040e3000
> [  +0.000055] RDX: ffff8804040e3400 RSI: ffff8804040e3000 RDI:
> bff7fffff7afffff

So you get a #GP while executing call *rdi and %rdi is supposed to
contain ->get_variable. But instead it contains some very funky shit:

0xbff7fffff7afffff

Who made it contain that nuisance of a pointer which thinks it is
->get_variable, huh? If only I could get my hands on that guy! :-P

Ok, seriously, how reproducible is this? Can you reproduce with the
latest upstream kernel too, i.e. 3.15-rc5+?

Thanks.

(leaving in the rest for reference).

> [  +0.000056] RBP: ffff880400f4be80 R08: 0000000000000000 R09:
> ffff880400f4bec0
> [  +0.000055] R10: 0000000000000000 R11: 0000000000000246 R12:
> ffff8804040e3400
> [  +0.000056] R13: 0000000000000000 R14: ffff880400f4bec0 R15:
> 000000000009b000
> [  +0.002960] FS:  00007fb6167c97c0(0000) GS:ffff88041e200000(0000)
> knlGS:0000000000000000
> [  +0.002958] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  +0.003177] CR2: 00007fb61581f4c0 CR3: 000000000009b000 CR4:
> 00000000001427e0
> [  +0.003258] Stack:
> [  +0.003257]  0000000000000201 8000000000000065 ffff880400000000
> ffff880100000000
> [  +0.003328]  0000000000000000 0000000000000000 ffff880400f4be50
> 0000000080050033
> [  +0.003354]  0000000000ff0000 0000000000000000 00ffffffffffffff
> 0000000000000000
> [  +0.003368] Call Trace:
> [  +0.003389]  [<ffffffff81064901>] ? virt_efi_get_variable+0x51/0x80
> [  +0.003353]  [<ffffffff813dbb71>] efivar_entry_size+0x41/0x80
> [  +0.003315]  [<ffffffff81245659>] efivarfs_file_read+0x49/0x100
> [  +0.003326]  [<ffffffff811ba797>] vfs_read+0x97/0x160
> [  +0.003305]  [<ffffffff811bb2e9>] SyS_read+0x59/0xd0
> [  +0.003263]  [<ffffffff81517629>] system_call_fastpath+0x16/0x1b
> [  +0.003239] Code: 89 c8 48 89 f1 80 3d e8 16 7d 00 00 74 1d 4c 89 3d
> c7 16 7d 00 41 0f 20 df 4c 89 3d c4 16 7d 00 4c 8b 3d c5 16 7d 00 41 0f
> 22 df <ff> d7 80 3d c0 16 7d 00 00 74 41 4c 8b 3d a7 16 7d 00 41 0f 22
> [  +0.003648] RIP  [<ffffffff810655af>] efi_call5+0x6f/0xf0
> [  +0.003511]  RSP <ffff880400f4bdb0>
> [  +0.024630] ---[ end trace 3670998c9a49abb7 ]---
> [  +0.000005] note: systemd-udevd[30835] exited with preempt_count 2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
