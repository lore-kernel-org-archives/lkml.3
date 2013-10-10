Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab3JJC7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 22:59:43 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:16924 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab3JJC7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 22:59:41 -0400
Message-ID: <525617E6.3030200@huawei.com>
Date: Thu, 10 Oct 2013 10:58:46 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xishi Qiu <qiuxishi@huawei.com>, <vgoyal@redhat.com>,
        Li Zefan <lizefan@huawei.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [BUG] kdump won't work if invalid TSS fault happens in irq context
References: <52561232.2060505@huawei.com>
In-Reply-To: <52561232.2060505@huawei.com>
X-Forwarded-Message-Id: <52561232.2060505@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I write a module, and find kdump can't boot in the following case.
Kernel version is 3.4.24, Intel(R) Xeon(R) CPU	E5620, and kernel v3.12 
has the same problem too.

Here is the code:
struct timer_list g_timer;

void tmrhnd_invtssfault(unsigned long data)
{
	long __res;
	printk(KERN_EMERG "invalid TSS fault in interrupt context.\n");
	__asm__ volatile("int $0x0A" : "=a"(__res):);
}

{
	...
	init_timer(&g_timer);
	g_timer.expires = jiffies + 10;
	g_timer.data = 0;
	g_timer.function = tmrhnd_invtssfault;
	add_timer(&g_timer);
	...
}

Here is the log:
[   87.801066] kpgenm: invalid TSS fault in interrupt context.
[   87.976956] BUG: unable to handle kernel paging request at ffffffff81467489
[   87.983979] IP: [<ffffffff81099070>] down_read_trylock+0x10/0x20
[   87.990017] PGD 1a0d067 PUD 1a11063 PMD 14001e1 
[   87.994708] Oops: 0003 [#1] SMP 
[   87.997985] CPU 2 
[   87.999833] Modules linked in: kpgen(O) igb(O) netmap_lin(O) megaraid_sas sr_mod mpt2sas raid_class uhci_hcd usb_storage ide_cd_mod ide_core mptctl mptsas ata_piix acpi_cpufreq mperf tg3 usbhid hid nfs lockd fscache auth_rpcgss nfs_acl sunrpc cdrom scsi_transport_sas e1000 mptscsih mptbase ipmi_devintf ipmi_msghandler ext2 ac dm_mod af_packet af_key zlib_deflate loop coretemp crc32c_intel ghash_clmulni_intel aesni_intel cryptd ipv6 aes_x86_64 aes_generic pcspkr i2c_i801 mei(C) sg iTCO_wdt microcode iTCO_vendor_support dca rtc_cmos container ext3 jbd mbcache i915 drm_kms_helper drm i2c_algo_bit i2c_core sd_mod crc_t10dif ahci libahci ehci_hcd libata button usbcore usb_common thermal video fan intel_agp intel_gtt processor thermal_sys hwmon scsi_dh_rdac scsi_dh_alua scsi_dh_emc scsi_dh_hp_sw scsi_dh scsi_mod [last unloaded: igb]
[   88.075236] 
[   88.076738] Pid: 1417644280, comm: ԨF.??? Tainted: G         C O 3.4.24.13-0.1-default #1 INSYDE eChiefRiver/Type2 - Board Product Name1
[   88.089319] RIP: 0010:[<ffffffff81099070>]  [<ffffffff81099070>] down_read_trylock+0x10/0x20
[   88.097783] RSP: 0018:ffff8802547fbc88  EFLAGS: 00010002
[   88.103101] RAX: 4c10246c894c1824 RBX: 0000000000000001 RCX: ffffffff81467429
[   88.110238] RDX: 4c10246c894c1825 RSI: 0000000000000010 RDI: ffffffff81467489
[   88.117373] RBP: ffff8802547fbc88 R08: ffff8802547fbfd8 R09: 0000000000000000
[   88.124511] R10: ffff88025f28dc50 R11: 0000000000000000 R12: 0000000000000001
[   88.131648] R13: 0000000000000010 R14: ffff8802547fbda8 R15: 0000000000000028
[   88.138786] FS:  0000000000000000(0000) GS:ffff88025f280000(0000) knlGS:0000000000000000
[   88.146876] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   88.152626] CR2: ffffffff81467489 CR3: 0000000001a0b000 CR4: 00000000001407e0
[   88.159764] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   88.166901] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   88.174039] Process ԨF.??? (pid: 1417644280, threadinfo ffff8802547fa000, task ffff8802547f8440)
[   88.183082] Stack:
[   88.185101]  ffff8802547fbd98 ffffffff8146aa24 ffffffffa02ca194 ffffffff81467489
[   88.192601]  ffff8802547f8440 ffffffff81467429 ffff8802547fbe78 ffffffff814675f5
[   88.200084]  0000000000000028 ffff8802547fbe88 0000000000000000 ffffffffa02ca194
[   88.207571] Call Trace:
[   88.210031]  [<ffffffff8146aa24>] do_page_fault+0x184/0x4b0
[   88.215617]  [<ffffffffa02ca194>] ? tmrhnd_invtssfault+0x14/0x20 [kpgen]
[   88.222327]  [<ffffffff81467489>] ? retint_signal+0x25/0x8c
[   88.227901]  [<ffffffff81467429>] ? restore_args+0x30/0x30
[   88.233390]  [<ffffffff814675f5>] ? page_fault+0x25/0x30
[   88.238706]  [<ffffffffa02ca194>] ? tmrhnd_invtssfault+0x14/0x20 [kpgen]
[   88.245411]  [<ffffffffa02ca194>] ? tmrhnd_invtssfault+0x14/0x20 [kpgen]
[   88.252112]  [<ffffffff81467429>] ? restore_args+0x30/0x30
[   88.257604]  [<ffffffff8146a8d4>] ? do_page_fault+0x34/0x4b0
[   88.263265]  [<ffffffff814675f5>] page_fault+0x25/0x30
[   88.268408]  [<ffffffffa02ca194>] ? tmrhnd_invtssfault+0x14/0x20 [kpgen]
[   88.275110]  [<ffffffff814675f5>] ? page_fault+0x25/0x30
[   88.280427]  [<ffffffffa02ca194>] ? tmrhnd_invtssfault+0x14/0x20 [kpgen]
[   88.287130]  [<ffffffffa02ca194>] ? tmrhnd_invtssfault+0x14/0x20 [kpgen]
[   88.293835]  [<ffffffff81467429>] ? restore_args+0x30/0x30
[   88.299322]  [<ffffffff8146a8d4>] ? do_page_fault+0x34/0x4b0
[   88.304987]  [<ffffffff8145c19e>] ? start_secondary+0x7a/0x7c
[   88.310733] Code: c0 83 fa 01 5b 0f 94 c0 41 5c c9 c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 55 48 89 e5 48 8b 07 48 89 c2 48 83 c2 01 7e 07 <f0> 48 0f b1 17 75 f0 48 f7 d0 c9 48 c1 e8 3f c3 55 31 c0 48 ba 
[   88.330974] RIP  [<ffffffff81099070>] down_read_trylock+0x10/0x20
[   88.337097]  RSP <ffff8802547fbc88>
[   88.340590] CR2: ffffffff81467489
[   88.343921] BUG: unable to handle kernel paging request at ffffffff81467489
[   88.350926] IP: [<ffffffff81099070>] down_read_trylock+0x10/0x20
[   88.356962] PGD 1a0d067 PUD 1a11063 PMD 14001e1 
[   88.361664] Oops: 0003 [#2] SMP 
[   88.364940] CPU 2 
[   88.366788] Modules linked in: kpgen(O) igb(O) netmap_lin(O) megaraid_sas sr_mod mpt2sas raid_class uhci_hcd usb_storage ide_cd_mod ide_core mptctl mptsas ata_piix acpi_cpufreq mperf tg3 usbhid hid nfs lockd fscache auth_rpcgss nfs_acl sunrpc cdrom scsi_transport_sas e1000 mptscsih mptbase ipmi_devintf ipmi_msghandler ext2 ac dm_mod af_packet af_key zlib_deflate loop coretemp crc32c_intel ghash_clmulni_intel aesni_intel cryptd ipv6 aes_x86_64 aes_generic pcspkr i2c_i801 mei(C) sg iTCO_wdt microcode iTCO_vendor_support dca rtc_cmos container ext3 jbd mbcache i915 drm_kms_helper drm i2c_algo_bit i2c_core sd_mod crc_t10dif ahci libahci ehci_hcd libata button usbcore usb_common thermal video fan intel_agp intel_gtt processor thermal_sys hwmon scsi_dh_rdac scsi_dh_alua scsi_dh_emc scsi_dh_hp_sw scsi_dh scsi_mod [last unloaded: igb]
[   88.442070] 
[   88.443570] Pid: 1417644280, comm: ԨF.??? Tainted: G         C O 3.4.24.13-0.1-default #1 INSYDE eChiefRiver/Type2 - Board Product Name1
[   88.456162] RIP: 0010:[<ffffffff81099070>]  [<ffffffff81099070>] down_read_trylock+0x10/0x20
[   88.464628] RSP: 0018:ffff8802547fb588  EFLAGS: 00010002
[   88.469943] RAX: 4c10246c894c1824 RBX: 0000000000000001 RCX: ffffffff81467429
[   88.477080] RDX: 4c10246c894c1825 RSI: 0000000000000000 RDI: ffffffff81467489
[   88.484216] RBP: ffff8802547fb588 R08: 00000000000000d0 R09: 0000000000000000
[   88.491355] R10: ffffffff81abb680 R11: 0000000000000000 R12: 0000000000000018
[   88.498493] R13: 0000000000000000 R14: ffff8802547fb6a8 R15: 0000000000000028
[   88.505630] FS:  0000000000000000(0000) GS:ffff88025f280000(0000) knlGS:0000000000000000
[   88.513721] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   88.519469] CR2: ffffffff81467489 CR3: 0000000001a0b000 CR4: 00000000001407e0
[   88.526607] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   88.533745] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   88.540881] Process ԨF.??? (pid: 1417644280, threadinfo ffff8802547fa000, task ffff8802547f8440)
[   88.549924] Stack:
[   88.551945]  ffff8802547fb698 ffffffff8146aa24 ffff8802547fb608 ffffffff81467489
[   88.559446]  ffff8802547f8440 ffffffff81467429 ffff8802d47fb6e8 547fb6e900000041
[   88.566937]  ffffffff6c106009 0000000000040000 ffff8802547fb608 ffff8802547fb6d8
[   88.574438] Call Trace:
[   88.576898]  [<ffffffff8146aa24>] do_page_fault+0x184/0x4b0
[   88.582474]  [<ffffffff81467489>] ? retint_signal+0x25/0x8c
[   88.588050]  [<ffffffff81467429>] ? restore_args+0x30/0x30
[   88.593545]  [<ffffffff81255d80>] ? sprintf+0x40/0x50
[   88.598604]  [<ffffffff810a573d>] ? kallsyms_lookup+0xdd/0x100
[   88.604442]  [<ffffffff814675f5>] page_fault+0x25/0x30
[   88.609586]  [<ffffffff8114f78e>] ? cache_alloc_refill+0x5e/0x290
[   88.615691]  [<ffffffff8115086d>] __kmalloc_track_caller+0x24d/0x260
[   88.622056]  [<ffffffff81005a9d>] ? register_nmi_handler+0x8d/0x170
[   88.628337]  [<ffffffff81120690>] kstrndup+0x40/0x80
[   88.633314]  [<ffffffff81021570>] ? machine_crash_shutdown+0x10/0x10
[   88.639676]  [<ffffffff81005a9d>] register_nmi_handler+0x8d/0x170
[   88.645780]  [<ffffffff81467489>] ? retint_signal+0x25/0x8c
[   88.651356]  [<ffffffff81467489>] ? retint_signal+0x25/0x8c
[   88.656935]  [<ffffffff810216ba>] nmi_shootdown_cpus+0x5a/0xc0
[   88.662780]  [<ffffffff8102a230>] native_machine_crash_shutdown+0x40/0x1a0
[   88.669665]  [<ffffffff810a686a>] ? append_elf_note+0x7a/0xa0
[   88.675423]  [<ffffffff81467489>] ? retint_signal+0x25/0x8c
[   88.681008]  [<ffffffff81467489>] ? retint_signal+0x25/0x8c
[   88.686592]  [<ffffffff8102156a>] machine_crash_shutdown+0xa/0x10
[   88.692697]  [<ffffffff810a6ec7>] crash_kexec+0x57/0x100  // kdump will boot soon, but it failed, right?
[   88.698021]  [<ffffffff81467429>] ? restore_args+0x30/0x30
[   88.703518]  [<ffffffff81467489>] ? retint_signal+0x25/0x8c
[   88.709095]  [<ffffffff81099070>] ? down_read_trylock+0x10/0x20
[   88.715029]  [<ffffffff81468178>] oops_end+0xb8/0xf0
[   88.720008]  [<ffffffff810325a9>] no_context+0x119/0x200
[   88.725329]  [<ffffffff81467489>] ? retint_signal+0x25/0x8c
[   88.730915]  [<ffffffff810327bd>] __bad_area_nosemaphore+0x12d/0x220
[   88.737280]  [<ffffffff81467489>] ? retint_signal+0x25/0x8c
[   88.742866]  [<ffffffff810328be>] bad_area_nosemaphore+0xe/0x10
[   88.748797]  [<ffffffff8146a9a0>] do_page_fault+0x100/0x4b0
[   88.754380]  [<ffffffff81467489>] ? retint_signal+0x25/0x8c
[   88.759967]  [<ffffffff81467429>] ? restore_args+0x30/0x30
[   88.765463]  [<ffffffff814675f5>] ? page_fault+0x25/0x30

