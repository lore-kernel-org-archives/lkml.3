Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab3FETMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 15:12:21 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:43964 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955Ab3FETMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 15:12:19 -0400
Date: Wed, 5 Jun 2013 21:12:16 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-kernel@vger.kernel.org
Subject: 3.10.0-rc4 oops in scsi_lib.c:1196
Message-ID: <20130605191216.GA25024@samfundet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a setup with an LSI2008 controller running md (RAID-1 and RAID-6) with
LVM on top, and I'm seeing this on boot, pretty much under fsck:

[   15.235697] ------------[ cut here ]------------
[   15.235738] md: resync of RAID array md1
[   15.235740] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[   15.235742] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
[   15.235752] md: using 128k window, over a total of 2930111488k.
[   15.266826] kernel BUG at drivers/scsi/scsi_lib.c:1196!
[   15.272305] invalid opcode: 0000 [#1] SMP 
[   15.276771] Modules linked in: acpi_cpufreq mperf coretemp kvm_intel kvm iTCO_wdt iTCO_vendor_support microcode pcspkr i2c_i801 ehci
_pci i2c_core lpc_ich mfd_core evbug evdev ext4 crc16 jbd2 mbcache dm_mod raid456 async_raid6_recov async_memcpy async_pq async_xor asy
nc_tx xor raid6_pq raid1 md_mod sg sd_mod usbhid crc32c_intel ide_pci_generic ide_core e1000e ata_piix ptp pps_core uhci_hcd ehci_hcd m
pt2sas raid_class unix
[   15.318120] CPU: 6 PID: 1614 Comm: md1_raid6 Not tainted 3.10.0-rc4 #1
[   15.324905] Hardware name: Supermicro X8DTL/X8DTL, BIOS 2.1a       12/30/2011
[   15.332288] task: ffff88061eadc410 ti: ffff88061d1a2000 task.ti: ffff88061d1a2000
[   15.340217] RIP: 0010:[<ffffffff812440b6>]  [<ffffffff812440b6>] scsi_setup_fs_cmnd+0x48/0x90
[   15.349271] RSP: 0018:ffff88061d1a3b48  EFLAGS: 00010046
[   15.354828] RAX: 0000000000000000 RBX: ffff880621a3e000 RCX: 0000000000000002
[   15.362217] RDX: 0000000000000001 RSI: ffff88061fd17530 RDI: ffff880621a3e000
[   15.369598] RBP: ffff88061d1a3b58 R08: ffff880621b76b00 R09: ffff880621678c58
[   15.376985] R10: ffff880621678c58 R11: 0000000000000000 R12: ffff88061fd17530
[   15.384402] R13: 0000000000000008 R14: ffff88061fd9c800 R15: 0000000000001000
[   15.391838] FS:  0000000000000000(0000) GS:ffff8806272c0000(0000) knlGS:0000000000000000
[   15.400382] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   15.406375] CR2: 00007fda91b26d26 CR3: 0000000001595000 CR4: 00000000000007e0
[   15.413761] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   15.421144] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   15.428530] Stack:
[   15.430788]  ffff88061fd17530 000000002efbf980 ffff88061d1a3bd8 ffffffffa0139967
[   15.438866]  0000000000000000 ffff880621b76b00[   15.442789] usb 4-1: new low-speed USB device number 4 using uhci_hcd
 ffff88061d1a3ba8 ffffffff8119e9a1
[   15.453782]  ffff88061d1a3ba8 ffff88061f2d0000 ffff88061f2d0000 ffff880621a3e000
[   15.461854] Call Trace:
[   15.464553]  [<ffffffffa0139967>] sd_prep_fn+0x3bb/0xc76 [sd_mod]
[   15.470898]  [<ffffffff8119e9a1>] ? deadline_remove_request.isra.4+0x7e/0x86
[   15.478197]  [<ffffffff8118de29>] blk_peek_request+0xdd/0x1d9
[   15.484193]  [<ffffffff8124396d>] scsi_request_fn+0x4a/0x51b
[   15.490102]  [<ffffffff81189997>] __blk_run_queue+0x2e/0x38
[   15.495929]  [<ffffffff8118c4a4>] queue_unplugged+0x55/0x7d
[   15.501780]  [<ffffffff8118e204>] blk_flush_plug_list+0x137/0x1b9
[   15.508120]  [<ffffffff8118e297>] blk_finish_plug+0x11/0x32
[   15.513940]  [<ffffffffa01d233a>] raid5d+0x370/0x3f3 [raid456]
[   15.520032]  [<ffffffff81382c48>] ? schedule_timeout+0x24/0x19c
[   15.526200]  [<ffffffffa016c568>] md_thread+0x11e/0x13c [md_mod]
[   15.532454]  [<ffffffff810534ca>] ? abort_exclusive_wait+0x8a/0x8a
[   15.538891]  [<ffffffffa016c44a>] ? md_register_thread+0xd0/0xd0 [md_mod]
[   15.545930]  [<ffffffff81052b9a>] kthread+0xb5/0xbd
[   15.551059]  [<ffffffff81052ae5>] ? kthread_freezable_should_stop+0x43/0x43
[   15.558313]  [<ffffffff8138c06c>] ret_

The backtrace is cut off at this point (the serial console is not always reliable).

It dies every time. 3.9.0 is fine.

/* Steinar */
-- 
Homepage: http://www.sesse.net/

