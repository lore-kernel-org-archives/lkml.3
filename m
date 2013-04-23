Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab3DWSpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 14:45:22 -0400
Received: from mx2.compro.net ([12.186.155.4]:5204 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757156Ab3DWSpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 14:45:20 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Apr 2013 14:45:20 EDT
X-IronPort-AV: E=Sophos;i="4.87,536,1363147200"; 
   d="scan'208";a="9969783"
Message-ID: <5176D532.5050202@compro.net>
Date: Tue, 23 Apr 2013 14:38:42 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Mark Hounschell <dmarkh@cfl.rr.com>
Subject: Out of tree serial tty driver?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been maintaining a couple of Digi International serial port card 
(XP and AP) drivers for years now because, well, they just won't do it 
anymore. In any case, I'm moving from a 3.4.x kernel, that works just 
fine, to a 3.8.8 kernel, that does not. I have code that does something 
like this:

	tty_set_operations(&SerialDriver, &SerialOps);
	tty_register_driver(&SerialDriver);
	maxminor = NumBoards * 64;
	for (i = 0; i < maxminor; i++)
		tty_register_device(&SerialDriver, i, NULL);

The first call to tty_register_device barfs:

[   76.528626] BUG: unable to handle kernel NULL pointer dereference at 
   (null)
[   76.528628] IP: [<c02fa460>] cdev_init+0x30/0x90
[   76.528632] *pde = 00000000
[   76.528634] Oops: 0002 [#1] PREEMPT SMP
[   76.528636] Modules linked in: kvm snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm nvidia(PO) osst snd_seq 
dgdm(O+) snd_timer snd_seq_device eprm(O) st sr_mod sg synclink_gt snd 
crc32c_intel aesni_intel ablk_helper cryptd lrw gpiohsd(O) k10temp 
lcrsmem(O) hdlc aes_i586 3c59x firewire_ohci pcspkr xts gf128mul mxm_wmi 
shpchp soundcore i2c_piix4 firewire_core snd_page_alloc crc_itu_t cdrom 
wmi pci_hotplug r8169 fam15h_power microcode rtom(O) button edd autofs4 
ext4 jbd2 crc16 xhci_hcd scsi_dh_hp_sw scsi_dh_emc scsi_dh_alua 
scsi_dh_rdac scsi_dh ata_generic pata_atiixp aic7xxx aic79xx 
scsi_transport_spi
[   76.528661] Pid: 393, comm: systemd-udevd Tainted: P           O 
3.8.8-lcrs #8 Gigabyte Technology Co., Ltd. GA-990FXA-UD5/GA-990FXA-UD5
[   76.528662] EIP: 0060:[<c02fa460>] EFLAGS: 00010246 CPU: 4
[   76.528664] EIP is at cdev_init+0x30/0x90
[   76.528665] EAX: 00000000 EBX: 00000000 ECX: 0000000f EDX: 0000003c
[   76.528667] ESI: c06d38c0 EDI: 00000000 EBP: ed449d0c ESP: ed449d00
[   76.528668]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   76.528669] CR0: 8005003b CR2: f72f9920 CR3: 2ebc8000 CR4: 000407d0
[   76.528670] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   76.528672] DR6: ffff0ff0 DR7: 00000400
[   76.528673] Process systemd-udevd (pid: 393, ti=ed448000 
task=ee753240 task.ti=ed448000)
[   76.528674] Stack:
[   76.528675]  fb396220 00000000 04600000 ed449d30 c04780a6 c0826710 
0000003c 00000000
[   76.528678]  00000000 fb396220 00000000 04600000 ed449dac c0478d52 
00000001 ed449d60
[   76.528681]  00000000 00000002 00000000 04600000 00000730 ed449d60 
00000000 00000000
[   76.528684] Call Trace:
[   76.528688]  [<c04780a6>] tty_cdev_add+0x56/0x80
[   76.528690]  [<c0478d52>] tty_register_device_attr+0x192/0x220
[   76.528693]  [<c02fa96d>] ? register_chrdev_region+0x4d/0xa0
[   76.528695]  [<c0478dfa>] tty_register_device+0x1a/0x20
[   76.528702]  [<fb37e701>] dgdm_tty_init+0x601/0x660 [dgdm]
[   76.528707]  [<fb375818>] init_module+0x2008/0x22f0 [dgdm]
[   76.528711]  [<c069d843>] ? notifier_call_chain+0x43/0x60
[   76.528716]  [<fb373810>] ? dgdm_boardread+0x430/0x430 [dgdm]
[   76.528718]  [<c0201222>] do_one_initcall+0x112/0x160
[   76.528721]  [<c0252707>] ? __blocking_notifier_call_chain+0x47/0x60
[   76.528723]  [<c02849d8>] load_module+0x1c58/0x2280
[   76.528729]  [<c028508d>] sys_init_module+0x8d/0xf0
[   76.528734]  [<c069ad1d>] syscall_call+0x7/0xb
[   76.528735] Code: 0c a8 01 89 5d f4 89 c3 89 75 f8 89 d6 ba 3c 00 00 
00 89 7d fc 89 c7 75 52 f7 c7 02 00 00 00 75 5a 89 d1 31 c0 c1 e9 02 f6 
c2 02 <f3> ab 74 08 66 c7 07 00 00 83 c7 02 83 e2 01 74 03 c6 07 00 8d
[   76.528753] EIP: [<c02fa460>] cdev_init+0x30/0x90 SS:ESP 0068:ed449d00
[   76.528756] CR2: 0000000000000000
[   76.528758] ---[ end trace 99a84df60dc687d6 ]---


I've put a printk in tty_io.c that shows the NULL pointer in 
driver->cdevs, that I assume. is what is causing it to barf. The first 4 
below are from Synclink-GT driver. The last is mine.

tty_cdev_add: Entered. driver = 0xeebd9900 driver->cdevs = 0xe678b800 
index = 0 name = ttySLG0
tty_cdev_add: Entered. driver = 0xeebd9900 driver->cdevs = 0xe678b800 
index = 1 name = ttySLG1
tty_cdev_add: Entered. driver = 0xeebd9900 driver->cdevs = 0xe678b800 
index = 2 name = ttySLG2
tty_cdev_add: Entered. driver = 0xeebd9900 driver->cdevs = 0xe678b800 
index = 3 name = ttySLG3
tty_cdev_add: Entered. driver = 0xf6d723a0 driver->cdevs = 0x00000000 
index = 0 name = tty_dgdm_G0

Was it expected that the tty changes from 3.4 to 3.8 would cause out of 
kernel drivers to fail? I've tried adding cdev_alloc and cdev_init but 
things seem to get much worse when I do.

I do maintain all of our GPL kernel drivers but do NOT consider my self 
very knowledgeable in the area of the kernel.  Any tips or pointers 
would be appreciated.

Thanks in advance
Mark
