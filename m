Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499AbaLJRE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 12:04:56 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:43957 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238AbaLJREy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:04:54 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mika.westerberg@linux.intel.com,
        benjamin.tissoires@redhat.com, aduggan@synaptics.com, jkosina@suse.cz
Subject: NULL pointer dereference in i2c-hid
Date: Wed, 10 Dec 2014 18:04:51 +0100
Message-ID: <31518562.V5Oyo0POsI@xps13>
User-Agent: KMail/4.14.2 (Linux/3.18.0+; KDE/4.14.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

my laptop uses a touchpad that needs hid-rmi along with i2c-hid to work.
i2c-hid and hid-rmi can be loaded and unloaded independelty from each
other, however since 34f439e4afcd ("HID: i2c-hid: add runtime PM support")
if I unload hid-rmi and after it I also unload i2c-hid, I get a NULL
pointer dereference.

I have already reported this problem in the Bugzilla [1], but since that
report is about something else, I'm reporting this separately.

Here the dmesg:

[   79.691459] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   79.691532] IP: [<ffffffffa05bc049>] __i2c_hid_command+0x49/0x310 [i2c_hid]
[   79.691591] PGD 0 
[   79.691611] Oops: 0002 [#1] SMP 
[   79.691641] Modules linked in: ctr ccm binfmt_misc rfcomm bnep vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) i2c_hid(-) nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc ecb btusb uvcvideo bluetooth videobuf2_vmalloc joydev videobuf2_memops videobuf2_core hid_multitouch v4l2_common videodev usbhid media hid dell_wmi sparse_keymap arc4 nls_utf8 nls_cp437 iTCO_wdt iTCO_vendor_support intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel iwlmvm dell_laptop dcdbas aesni_intel mac80211 aes_x86_64 glue_helper snd_hda_codec_realtek lrw gf128mul snd_hda_codec_generic ablk_helper cryptd snd_hda_codec_hdmi iwlwifi psmouse cfg80211 serio_raw sg rfkill lpc_ich mfd_core ehci_pci i2c_i801 ehci_hcd thermal wmi
[   79.692330]  battery sdhci_acpi sdhci mmc_core intel_rst snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm i2c_designware_platform xhci_pci i2c_designware_core xhci_hcd snd_timer usbcore snd mei_me soundcore ac evdev usb_common mei shpchp processor fuse parport_pc ppdev lp parport [last unloaded: hid_rmi]
[   79.692602] CPU: 0 PID: 2898 Comm: rmmod Tainted: G           O   3.18.0+ #1
[   79.692655] Hardware name: Dell Inc. XPS13 9333/0GFTRT, BIOS A04 03/19/2014
[   79.692705] task: ffff8801eae4a340 ti: ffff8800b4608000 task.ti: ffff8800b4608000
[   79.692758] RIP: 0010:[<ffffffffa05bc049>]  [<ffffffffa05bc049>] __i2c_hid_command+0x49/0x310 [i2c_hid]
[   79.692830] RSP: 0018:ffff8800b460bce8  EFLAGS: 00010206
[   79.692868] RAX: ffffffffa05be720 RBX: ffff880212cb2f80 RCX: 0000000000000000
[   79.692919] RDX: 0000000000000000 RSI: 0000000000000022 RDI: 0000000000000011
[   79.692968] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[   79.693018] R10: ffff880216400000 R11: 0000000000000000 R12: 0000000000000004
[   79.693067] R13: 0000000000000000 R14: ffff880214c08400 R15: 0000000000000000
[   79.693119] FS:  00007fd597c22700(0000) GS:ffff88021f200000(0000) knlGS:0000000000000000
[   79.693175] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   79.693216] CR2: 0000000000000000 CR3: 00000000b46b5000 CR4: 00000000001407f0
[   79.693266] Stack:
[   79.693283]  ffff880215b79800 ffff880214c92b00 ffff880214c084ce ffff880212d68920
[   79.693344]  0000000000000004 ffffffff810424e1 0000000000000096 ffffffff81042855
[   79.693405]  0000000000000292 ffff8800cfe77600 0000000000000096 ffff880214c08400
[   79.693467] Call Trace:
[   79.693494]  [<ffffffff810424e1>] ? __unmask_ioapic+0x21/0x30
[   79.693537]  [<ffffffff81042855>] ? unmask_ioapic+0x25/0x40
[   79.693581]  [<ffffffffa05bc35b>] ? i2c_hid_set_power+0x4b/0xa0 [i2c_hid]
[   79.693632]  [<ffffffffa05bc3cf>] ? i2c_hid_runtime_resume+0x1f/0x30 [i2c_hid]
[   79.693689]  [<ffffffff814c08fb>] ? __rpm_callback+0x2b/0x70
[   79.693733]  [<ffffffff814c0961>] ? rpm_callback+0x21/0x90
[   79.693776]  [<ffffffff814c0dec>] ? rpm_resume+0x41c/0x600
[   79.693820]  [<ffffffff814c1e1c>] ? __pm_runtime_resume+0x4c/0x80
[   79.693868]  [<ffffffff814b8588>] ? __device_release_driver+0x28/0x100
[   79.693917]  [<ffffffff814b8d90>] ? driver_detach+0xa0/0xb0
[   79.693959]  [<ffffffff814b82cc>] ? bus_remove_driver+0x4c/0xb0
[   79.694006]  [<ffffffff810d1cfd>] ? SyS_delete_module+0x11d/0x1d0
[   79.694054]  [<ffffffff8165f107>] ? int_signal+0x12/0x17
[   79.694095]  [<ffffffff8165ee69>] ? system_call_fastpath+0x12/0x17
[   79.694139] Code: 9f c0 00 00 00 44 8b 66 08 44 0f b6 6e 0c 8b 3e 48 8b 6b 40 48 81 fe 70 e7 5b a0 0f 84 51 02 00 00 89 fe 83 c7 01 0f b6 74 33 10 <40> 88 75 00 0f b6 74 3b 10 40 88 75 01 41 83 fc 02 7e 0f 0f b6 
[   79.694422] RIP  [<ffffffffa05bc049>] __i2c_hid_command+0x49/0x310 [i2c_hid]
[   79.694478]  RSP <ffff8800b460bce8>
[   79.694503] CR2: 0000000000000000
[   79.712214] ---[ end trace e97e4d6468e56036 ]---


Regards,
Gabriele

[1] https://bugzilla.kernel.org/show_bug.cgi?id=81141
