Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaFJT3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:29:36 -0400
Received: from mga14.intel.com ([192.55.52.115]:22606 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbaFJT3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:29:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,1010,1392192000"; 
   d="scan'208";a="545867667"
Date: Tue, 10 Jun 2014 13:29:27 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: Jens Axboe <axboe@fb.com>
cc: Keith Busch <keith.busch@intel.com>,
        =?ISO-8859-15?Q?Matias_Bj=F8rling?= <m@bjorling.me>,
        "willy@linux.intel.com" <willy@linux.intel.com>,
        "sbradshaw@micron.com" <sbradshaw@micron.com>,
        "tom.leiming@gmail.com" <tom.leiming@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH v7] NVMe: conversion to blk-mq
In-Reply-To: <A52B97CC-6D77-468B-9A9B-A5888AE63580@fb.com>
Message-ID: <alpine.LRH.2.03.1406101140490.4699@AMR>
References: <1402392038-5268-1-git-send-email-m@bjorling.me> <1402392038-5268-2-git-send-email-m@bjorling.me>,<alpine.LRH.2.03.1406100945250.4699@AMR> <A52B97CC-6D77-468B-9A9B-A5888AE63580@fb.com>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1187652616-1402428568=:4699"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1187652616-1402428568=:4699
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 10 Jun 2014, Jens Axboe wrote:
>> On Jun 10, 2014, at 9:52 AM, Keith Busch <keith.busch@intel.com> wrote:
>>
>>> On Tue, 10 Jun 2014, Matias Bjørling wrote:
>>> This converts the current NVMe driver to utilize the blk-mq layer.
>>
>> I'd like to run xfstests on this, but it is failing mkfs.xfs. I honestly
>> don't know much about this area, but I think this may be from the recent
>> chunk sectors patch causing a __bio_add_page to reject adding a new page.
>
> Gah, yes that's a bug in the chunk patch. It must always allow a single page
> at any offset. I'll test and send out a fix.

I have two devices, one formatted 4k, the other 512. The 4k is used as
the TEST_DEV and 512 is used as SCRATCH_DEV. I'm always hitting a BUG when
unmounting the scratch dev in xfstests generic/068. The bug looks like
nvme was trying to use an SGL that doesn't map correctly to a PRP.

Also, it doesn't look like this driver can recover from an unresponsive
device, leaving tasks in uniterruptible sleep state forever. Still looking
into that one though; as far as I can tell the device is perfectly fine,
but lots of "Cancelling I/O"  messages are getting logged.

[  478.580863] ------------[ cut here ]------------
[  478.586111] kernel BUG at drivers/block/nvme-core.c:486!
[  478.592130] invalid opcode: 0000 [#1] SMP
[  478.596963] Modules linked in: xfs nvme parport_pc ppdev lp parport dlm sctp libcrc32c configfs nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc md4 hmac cifs bridge stp llc jfs joydev hid_generic usbhid hid loop md_mod x86_pkg_temp_thermal coretemp kvm_intel kvm iTCO_wdt iTCO_vendor_support ghash_clmulni_intel aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk_helper cryptd microcode ehci_pci ehci_hcd pcspkr usbcore acpi_cpufreq lpc_ich ioatdma mfd_core usb_common i2c_i801 evdev wmi tpm_tis ipmi_si tpm ipmi_msghandler processor thermal_sys button ext4 crc16 jbd2 mbcache dm_mod nbd sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common crc32c_intel isci libsas ahci libahci scsi_transport_sas igb libata ptp pps_core i2c_algo_bit scsi_mod i2c_core dca [last unloaded: nvme]
[  478.682913] CPU: 5 PID: 17969 Comm: fsstress Not tainted 3.15.0-rc8+ #19
[  478.690510] Hardware name: Intel Corporation S2600GZ/S2600GZ, BIOS SE5C600.86B.02.02.0002.122320131210 12/23/2013
[  478.702126] task: ffff88042bc18cf0 ti: ffff88042d3f0000 task.ti: ffff88042d3f0000
[  478.710624] RIP: 0010:[<ffffffffa04bc8e6>]  [<ffffffffa04bc8e6>] nvme_setup_prps+0x1b8/0x1eb [nvme]
[  478.720971] RSP: 0018:ffff88042d3f38c8  EFLAGS: 00010286
[  478.727013] RAX: 0000000000000014 RBX: ffff88042b96e400 RCX: 0000000803d0e000
[  478.735096] RDX: 0000000000000015 RSI: 0000000000000246 RDI: ffff88042b96e6b0
[  478.743177] RBP: 0000000000015e00 R08: 0000000000000000 R09: 0000000000000e00
[  478.751264] R10: 0000000000000e00 R11: ffff88042d3f3900 R12: ffff88042b96e6d0
[  478.759349] R13: ffff880823f40e00 R14: ffff88042b96e710 R15: 00000000fffffc00
[  478.767435] FS:  00007f92eb29c700(0000) GS:ffff88043f6a0000(0000) knlGS:0000000000000000
[  478.776614] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  478.783143] CR2: 00007f92e401ff18 CR3: 000000042b5d5000 CR4: 00000000000407e0
[  478.791218] Stack:
[  478.793558]  ffff8808229367c0 0000000805205000 ffff880400000014 00000a0029abf540
[  478.802302]  ffff88082bcd8140 0000031000000020 0000000000000017 0000000823f40e00
[  478.811045]  0000000000000e00 ffff880827de3300 ffff88042b96e400 ffff88082ad60c40
[  478.819789] Call Trace:
[  478.822630]  [<ffffffffa04bca5e>] ? nvme_queue_rq+0x145/0x33b [nvme]
[  478.829859]  [<ffffffff811c854f>] ? blk_mq_make_request+0xd7/0x140
[  478.836891]  [<ffffffff811bf583>] ? generic_make_request+0x98/0xd5
[  478.843906]  [<ffffffff811c0240>] ? submit_bio+0x100/0x109
[  478.850161]  [<ffffffff81142bc2>] ? dio_bio_submit+0x67/0x86
[  478.856596]  [<ffffffff81143a08>] ? do_blockdev_direct_IO+0x956/0xad8
[  478.863924]  [<ffffffffa0592a2e>] ? __xfs_get_blocks+0x410/0x410 [xfs]
[  478.871338]  [<ffffffffa0591c12>] ? xfs_vm_direct_IO+0xda/0x146 [xfs]
[  478.878652]  [<ffffffffa0592a2e>] ? __xfs_get_blocks+0x410/0x410 [xfs]
[  478.886066]  [<ffffffffa0592b00>] ? xfs_finish_ioend_sync+0x1a/0x1a [xfs]
[  478.893775]  [<ffffffff810d1749>] ? generic_file_direct_write+0xe2/0x145
[  478.901385]  [<ffffffffa05e81c0>] ? xfs_file_dio_aio_write+0x1ba/0x208 [xfs]
[  478.909391]  [<ffffffffa059c43d>] ? xfs_file_aio_write+0xc4/0x157 [xfs]
[  478.916892]  [<ffffffff8111801a>] ? do_sync_write+0x50/0x73
[  478.923227]  [<ffffffff81118b36>] ? vfs_write+0x9f/0xfc
[  478.929173]  [<ffffffff81118e22>] ? SyS_write+0x56/0x8a
[  478.935122]  [<ffffffff8139fe52>] ? system_call_fastpath+0x16/0x1b
[  478.942137] Code: 48 63 c2 41 81 ef 00 10 00 00 ff c2 83 7c 24 1c 00 49 89 4c c5 00 7e 35 48 81 c1 00 10 00 00 41 83 ff 00 0f 8f 6f ff ff ff 74 02 <0f> 0b 4c 89 e7 89 54 24 10 e8 03 e3 d2 e0 8b 54 24 10 49 89 c4
[  478.968952] RIP  [<ffffffffa04bc8e6>] nvme_setup_prps+0x1b8/0x1eb [nvme]
[  478.976638]  RSP <ffff88042d3f38c8>
[  478.980699] ---[ end trace 3323c3dc4ef42ff8 ]---
--8323328-1187652616-1402428568=:4699--
