Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680AbaFCOoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:44:04 -0400
Received: from mx1.configcenter.info ([31.47.242.144]:53225 "EHLO
	mx1.configcenter.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaFCOoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:44:02 -0400
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jun 2014 10:44:01 EDT
Message-ID: <538DDDB5.1090206@bonorden.de>
Date: Tue, 03 Jun 2014 16:37:41 +0200
From: Olaf Bonorden <olaf@bonorden.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel BUG at mm/memory.c:3797 (KVM?)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For testing our product we use many virtual machines (KVM, qemu), 
created and destroyed automatically. Every couple of days, a host system 
(different HP blades) reports a kernel bug:

kernel BUG at 
/home/abuild/rpmbuild/BUILD/kernel-default-3.14.2/linux-3.14/mm/memory.c:3797!

After that, some system calls hang and never return, esp. the access of 
procfs for one PID, s.t. "ps x" and others are not working anymore.
Looks like some resources in the kernel are blocked after that error, 
only a reboot helps.

OS: OpenSuSE 13.1 (also with 12.3)
Kernel: 3.14.2 from 
http://download.opensuse.org/repositories/Kernel:/stable/standard/ (also 
with some older ones, e.g., 3.12)
Hardware: HP G7, 2x Xeon X5650, 2.67 GHz, 32 GB ram, also seen on HP G8, 
2x Xeon E5-2650, 128 GB ram

Details of /var/log/messages:

kernel: [2845476.690313] invalid opcode: 0000 [#1] SMP
kernel: [2845476.690316] Modules linked in: ip6table_filter ip6_tables 
iptable_filter ip_tables ebtable_nat nfsv3 nfs_acl ebtables x_tables nfs
  lockd sunrpc 8021q mrp garp af_packet bridge stp llc cachefiles 
fscache intel_powerclamp coretemp kvm_intel joydev kvm crct10dif_pclmul 
crc32_pclmul crc32c_intel ghash_clmulni_intel bn
x2 aesni_intel ablk_helper pcspkr sg be2net hpilo serio_raw ipmi_si 
iTCO_wdt iTCO_vendor_support hpwdt cryptd gpio_ich lrw lpc_ich mfd_core 
acpi_power_meter shpchp ipmi_msghandler gf128
mul button glue_helper aes_x86_64 i7core_edac edac_core ehci_pci 
vhost_net macvtap macvlan vhost tun edd hid_generic usbhid ttm uhci_hcd 
drm_kms_helper ehci_hcd drm i2c_algo_bit sysimgb
lt usbcore sysfillrect syscopyarea usb_common scsi_dh_rdac scsi_dh_alua 
scsi_dh_emc scsi_dh_hp_sw scsi_dh fan processor be2iscsi 
iscsi_boot_sysfs libiscsi scsi_transport_iscsi thermal h
psa
kernel: [2845476.690383] CPU: 13 PID: 20701 Comm: qemu-system-x86 
Tainted: G          I  3.14.2-1.g1474ea5-default #1
kernel: [2845476.690385] Hardware name: HP ProLiant BL460c G7, BIOS I27 
05/05/2011
kernel: [2845476.690388] task: ffff880037748090 ti: ffff880401042000 
task.ti: ffff880401042000
kernel: [2845476.690390] RIP: 0010:[<ffffffff81166da1>] 
[<ffffffff81166da1>] handle_mm_fault+0xe51/0xef0
kernel: [2845476.690398] RSP: 0000:ffff880401043dd0  EFLAGS: 00010246
kernel: [2845476.690400] RAX: 0000000000000100 RBX: 00007f795181aff0 
RCX: ffff880401043b78
kernel: [2845476.690402] RDX: 0000000000000000 RSI: 0000000000000000 
RDI: 80000000510009e6
kernel: [2845476.690404] RBP: ffff880400539e00 R08: 0000000000000000 
R09: 0000000000000000
kernel: [2845476.690406] R10: 0000000000003ebb R11: 00000000000000a9 
R12: ffff880400218460
kernel: [2845476.690408] R13: ffff8804017b2b80 R14: ffff8804017b2b80 
R15: ffff880037748090
kernel: [2845476.690411] FS:  00007f7a22ca89c0(0000) 
GS:ffff880417cc0000(0000) knlGS:0000000000000000
kernel: [2845476.690413] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: [2845476.690415] CR2: 00007f795181aff0 CR3: 00000000e14f7000 
CR4: 00000000000027e0
kernel: [2845476.690417] Stack:
kernel: [2845476.690418]  dead000000200200 ffff8807000000a9 
ffff8808002d7080 0000000000000019
kernel: [2845476.690424]  ffff880000000000 ffff880401043c70 
ffffffff811ba620 dead000000100100
kernel: [2845476.690428]  dead000000000080 ffff88045c425740 
ffff88080026d340 00000000000000a9
kernel: [2845476.690433] Call Trace:
kernel: [2845476.690445]  [<ffffffff815bc04a>] __do_page_fault+0x15a/0x500
kernel: [2845476.690454]  [<ffffffff815b8cf8>] page_fault+0x28/0x30
kernel: [2845476.690461]  [<00007f7a1cbb96db>] 0x7f7a1cbb96da
kernel: [2845476.690463] Code: 89 d9 4c 89 e2 48 89 ee 4c 89 ef 44 89 5c 
24 08 e8 35 c1 ff ff 85 c0 0f 85 9d f5 ff ff 49 8b 3c 24 44 8b 5c 24 0
8 e9 80 f3 ff ff <0f> 0b be 8e 00 00 00 48 c7 c7 28 17 81 81 44 89 5c 24 
08 e8 e7
kernel: [2845476.690494] RIP  [<ffffffff81166da1>] 
handle_mm_fault+0xe51/0xef0
kernel: [2845476.690498]  RSP <ffff880401043dd0>
kernel: [2845476.690501] ---[ end trace 43620a041f7ad4b8 ]---

Any ideas?

Regards,
   Olaf

