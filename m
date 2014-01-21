Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbaAUWKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 17:10:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaAUWKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 17:10:39 -0500
Date: Tue, 21 Jan 2014 14:10:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Subject: Re: 3.13: BUG: unable to handle kernel paging request at
 00000000b4343e88
Message-Id: <20140121141037.f76dba61212c5597ff733207@linux-foundation.org>
In-Reply-To: <alpine.SOC.1.00.1401211228410.25614@math.ut.ee>
References: <alpine.SOC.1.00.1401211228410.25614@math.ut.ee>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jan 2014 12:34:24 +0200 (EET) Meelis Roos <mroos@linux.ee> wrote:

> My HP DL585 G1 gets a the following BUG on module load with 3.13. Have 
> not noticed it with any earlier kernel, including 3.13-rc8.
> 
> BUG: unable to handle kernel paging request at 00000000b4343e88
> 
> This is somewhat reproducible - on second boot, it was ordered 
> differently with respect to other boot messages. Second dmesg is also 
> below.

It looks like gcov exploded when running a module's constructors or
init function, but I'm unable to work out which module it was :(

> ...
>
> [    2.606767] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    2.617386] input: PC Speaker as /devices/platform/pcspkr/input/input3
> [    2.634146] BUG: unable to handle kernel paging request at 00000000b4343e88
> [    2.634499] IP: [<ffffffff8109e31b>] wake_up_process+0xb/0x50
> [    2.634766] PGD 0 
> [    2.635009] Oops: 0000 [#1] SMP 
> [    2.635210] Floppy drive(s): fd0 is 1.44M
> [    2.635718] Modules linked in: floppy(+) edac_core(+) pcspkr k8temp(+) ehci_hcd tg3(+) ptp usbcore pps_core libphy hpwdt hpilo usb_common i2c_amd756 i2c_core pata_amd amd_rng libata ioapic evdev shpchp
> [    2.636037] CPU: 2 PID: 368 Comm: modprobe Not tainted 3.13.0 #45
> [    2.636037] Hardware name: HP ProLiant DL585 G1, BIOS A01 02/14/2007
> [    2.636037] task: ffff8803f981c400 ti: ffff8803f98be000 task.ti: ffff8803f98be000
> [    2.636037] RIP: 0010:[<ffffffff8109e31b>]  [<ffffffff8109e31b>] wake_up_process+0xb/0x50
> [    2.636037] RSP: 0018:ffff8803f98bfd78  EFLAGS: 00010206
> [    2.636037] RAX: ffffffff81ba70c0 RBX: 00000000b4343e88 RCX: 00000000000010cd
> [    2.636037] RDX: ffffffff81ac40a8 RSI: 00000000000149a0 RDI: 00000000b4343e88
> [    2.636037] RBP: ffffffffa0231958 R08: 00000000000149a0 R09: ffff8802fbc149a0
> [    2.636037] R10: ffffea0007e73980 R11: ffff8800b8803b00 R12: ffffffffa0231940
> [    2.636037] R13: ffff8803f98bfe78 R14: 0000000000000000 R15: 0000000000000000
> [    2.636037] FS:  00007f375b73a700(0000) GS:ffff8802fbc00000(0000) knlGS:0000000000000000
> [    2.636037] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    2.636037] CR2: 00000000b4343e88 CR3: 00000000bc337000 CR4: 00000000000007e0
> [    2.636037] Stack:
> [    2.636037]  ffffffff81ac40a0 ffffffff81607663 ffffffffa0230400 ffffffff8160772b
> [    2.636037]  0000000000000000 ffffffff81110ac5 0000000000000004 ffffffff810f7b2b
> [    2.636037]  ffffffff810f4000 0000000000000000 0000000000000000 ffffffff00000003
> [    2.636037] Call Trace:
> [    2.636037]  [<ffffffff81607663>] ? __mutex_unlock_slowpath+0x53/0x80
> [    2.636037]  [<ffffffff8160772b>] ? mutex_unlock+0x2b/0x40
> [    2.636037]  [<ffffffff81110ac5>] ? __gcov_init+0x65/0xb0
> [    2.636037]  [<ffffffff810f7b2b>] ? load_module+0x223b/0x2710
> [    2.636037]  [<ffffffff810f4000>] ? get_modinfo.isra.35+0x110/0x110
> [    2.636037]  [<ffffffff8160a0f2>] ? page_fault+0x22/0x30
> [    2.636037]  [<ffffffff810f80ee>] ? SyS_init_module+0xee/0x140
> [    2.636037]  [<ffffffff816131a1>] ? tracesys+0xd4/0xd9
> [    2.649431] tg3 0000:02:06.0 eth0: Tigon3 [partno(349321-001) rev 2100] (PCIX:100MHz:64-bit) MAC address 00:13:21:07:9c:e3
> [    2.649435] tg3 0000:02:06.0 eth0: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
> [    2.649438] tg3 0000:02:06.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[0]
> [    2.649441] tg3 0000:02:06.0 eth0: dma_rwctrl[769f4000] dma_mask[64-bit]
> [    2.636037] Code: 48 83 ec 08 31 d2 48 ff 05 13 58 da 00 e8 ae fb ff ff 48 ff 05 0f 58 da 00 48 83 c4 08 c3 66 90 48 ff 05 a9 54 da 00 53 48 89 fb <48> 8b 07 a8 0c 75 18 48 89 df 31 d2 be 03 00 00 00 e8 7f fb ff 
> [    2.651880] FDC 0 is a National Semiconductor PC87306
> [    2.650994] RIP  [<ffffffff8109e31b>] wake_up_process+0xb/0x50
> [    2.650994]  RSP <ffff8803f98bfd78>
> [    2.650994] CR2: 00000000b4343e88
> [    2.653524] ---[ end trace 1c83e7195a307878 ]---
> [    2.705936] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
>
> ...
>

Maybe it's tg3.

Could you add `ignore_loglevel' to the kernel boot parameters?  That
should make all pr_debug()s come out and they include the module's
name.

