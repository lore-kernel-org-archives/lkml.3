Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbaFBWuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 18:50:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:4805 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbaFBWuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 18:50:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,960,1392192000"; 
   d="scan'208";a="541465624"
Date: Mon, 2 Jun 2014 16:49:41 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: =?ISO-8859-15?Q?Matias_Bj=F8rling?= <m@bjorling.me>
cc: willy@linux.intel.com, keith.busch@intel.com, sbradshaw@micron.com,
        axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, hch@infradead.org
Subject: Re: [PATCH v5] conversion to blk-mq
In-Reply-To: <1401742510-10827-1-git-send-email-m@bjorling.me>
Message-ID: <alpine.LRH.2.03.1406021642480.11244@AMR>
References: <1401742510-10827-1-git-send-email-m@bjorling.me>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2052132426-1401749382=:11244"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2052132426-1401749382=:11244
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 2 Jun 2014, Matias Bjørling wrote:
> Hi Matthew and Keith,
>
> Here is an updated patch with the feedback from the previous days. It's against
> Jens' for-3.16/core tree. You may use the nvmemq_wip_review branch at:

I'm testing this on my normal hardware now. As I feared, hot removal
doesn't work while the device is actively being managed. Here's the oops:

[ 1267.018283] BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
[ 1267.018288] IP: [<ffffffff811c51b8>] blk_mq_map_queue+0xf/0x1e
[ 1267.018292] PGD b5ed5067 PUD b57e2067 PMD 0
[ 1267.018294] Oops: 0000 [#1] SMP
[ 1267.018343] Modules linked in: nvme parport_pc ppdev lp parport dlm sctp libcrc32c configfs nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc md4 hmac cifs bridge stp llc joydev jfs hid_generic usbhid hid loop md_mod x86_pkg_temp_thermal coretemp kvm_intel kvm iTCO_wdt iTCO_vendor_support crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk_helper cryptd microcode ehci_pci ehci_hcd usbcore pcspkr lpc_ich acpi_cpufreq ioatdma mfd_core usb_common i2c_i801 evdev wmi ipmi_si tpm_tis ipmi_msghandler tpm processor thermal_sys button ext4 crc16 jbd2 mbcache dm_mod nbd sg sr_mod cdrom sd_mod crc_t10dif crct10dif_common isci libsas ahci scsi_transport_sas libahci igb libata ptp pps_core i2c_algo_bit scsi_mod i2c_core dca [last unloaded: nvme]
[ 1267.018346] CPU: 1 PID: 6618 Comm: nvme_id_ctrl Tainted: G        W     3.15.0-rc1+ #2
[ 1267.018347] Hardware name: Intel Corporation S2600GZ/S2600GZ, BIOS SE5C600.86B.02.02.0002.122320131210 12/23/2013
[ 1267.018349] task: ffff88042879eef0 ti: ffff8800b5f14000 task.ti: ffff8800b5f14000
[ 1267.018354] RIP: 0010:[<ffffffff811c51b8>]  [<ffffffff811c51b8>] blk_mq_map_queue+0xf/0x1e
[ 1267.018356] RSP: 0018:ffff8800b5f15db0  EFLAGS: 00010206
[ 1267.018357] RAX: 0000000000000000 RBX: ffffe8fbffa21e80 RCX: ffff88042f3952e0
[ 1267.018359] RDX: 0000000000001c10 RSI: 0000000000000001 RDI: ffff8800b5e9f008
[ 1267.018360] RBP: ffff88042d993480 R08: ffff8800b5e18cc0 R09: 0000000000000000
[ 1267.018362] R10: 0000000000000ca0 R11: 0000000000000ca0 R12: ffff8800b5f15e94
[ 1267.018363] R13: 0000000000003a98 R14: 00007fffc7b44c40 R15: 0000000000000000
[ 1267.018365] FS:  00007feb4cb05700(0000) GS:ffff88043f620000(0000) knlGS:0000000000000000
[ 1267.018367] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1267.018369] CR2: 0000000000000004 CR3: 00000000b50f2000 CR4: 00000000000407e0
[ 1267.018369] Stack:
[ 1267.018372]  ffffffff811c6334 00000000fffffffc ffff88042d993480 00000000fffffffc
[ 1267.018375]  ffffffffa0532d73 0000000000000ca0 00000000fffffff4 ffff88042562b440
[ 1267.018378]  ffff88042d853000 0000000000001000 ffffffffa05348f3 ffffc9001518b2a8
[ 1267.018378] Call Trace:
[ 1267.018383]  [<ffffffff811c6334>] ? blk_mq_free_request+0x37/0x48
[ 1267.018388]  [<ffffffffa0532d73>] ? __nvme_submit_admin_cmd+0x7f/0x8a [nvme]
[ 1267.018392]  [<ffffffffa05348f3>] ? nvme_user_admin_cmd+0x144/0x1b1 [nvme]
[ 1267.018397]  [<ffffffffa053497d>] ? nvme_dev_ioctl+0x1d/0x2b [nvme]
[ 1267.018399]  [<ffffffff81125916>] ? do_vfs_ioctl+0x3f2/0x43b
[ 1267.018402]  [<ffffffff8105ca6b>] ? finish_task_switch+0x84/0xc4
[ 1267.018406]  [<ffffffff81394a8c>] ? __schedule+0x45c/0x4f0
[ 1267.018408]  [<ffffffff811259ad>] ? SyS_ioctl+0x4e/0x7d
[ 1267.018411]  [<ffffffff8139c6d2>] ? system_call_fastpath+0x16/0x1b
[ 1267.018435] Code: 8b 4a 38 48 39 4e 38 72 12 74 06 b8 01 00 00 00 c3 48 8b 4a 60 48 39 4e 60 73 f0 c3 66 66 66 66 90 48 8b 87 e0 00 00 00 48 63 f6 <8b> 14 b0 48 8b 87 f8 00 00 00 48 8b 04 d0 c3 89 ff f0 48 0f ab
[ 1267.018438] RIP  [<ffffffff811c51b8>] blk_mq_map_queue+0xf/0x1e
[ 1267.018439]  RSP <ffff8800b5f15db0>
[ 1267.018440] CR2: 0000000000000004
[ 1267.018443] ---[ end trace 1e244ae5f3ceb23b ]---

--8323328-2052132426-1401749382=:11244--
