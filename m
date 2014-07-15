Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbaGOLit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 07:38:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758438AbaGOLiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 07:38:46 -0400
Message-ID: <53C512B1.7060409@redhat.com>
Date: Tue, 15 Jul 2014 13:38:25 +0200
From: Maurizio Lombardi <mlombard@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
CC: ming.lei@canonical.com, dongsu.park@profitbricks.com, jet.chen@intel.com,
        viro@zeniv.linux.org.uk, hch@lst.de, kmo@daterainc.com,
        axboe@kernel.dk, akpm@linux-foundation.org, axboe@fb.com
Subject: Re: Bug_ON with patch: bio: modify __bio_add_page() to accept pages
 that don't start a new segment
References: <53C4E2F0.8000307@linux.vnet.ibm.com>
In-Reply-To: <53C4E2F0.8000307@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/15/2014 10:14 AM, Mike Qiu wrote:
> My Power7 box boot fail with commit:
> 
> 254c4407cb84a6dec90336054615b0f0e996bb7c
> bio: modify __bio_add_page() to accept pages that don't start a new segment
> 
> Just revert it will works for me.

This looks strange to me because, even after reverting my patch, the kernel still panics
with a different call trace:


[   68.999477] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
[   69.007411] IP: [<ffffffff81322238>] blk_throtl_drain+0x28/0x110
[   69.013510] PGD 222e5f067 PUD 21bdab067 PMD 0
[   69.018051] Oops: 0000 [#1] SMP
[   69.021335] Modules linked in: serpent_avx_x86_64 serpent_sse2_x86_64 serpent_generic dm_crypt loop iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi cfg80211 rfkill x86_pkg_temp_thermal coretemp kvm_intel bnx2x kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel e1000e tpm_infineon ptp iTCO_wdt pcspkr iTCO_vendor_support tpm_tis pps_core microcode ipmi_si serio_raw i2c_i801 ipmi_msghandler mdio tpm ie31200_edac video lpc_ich mfd_core shpchp edac_core xfs libcrc32c ast i2c_algo_bit drm_kms_helper ttm drm ata_generic pata_acpi
[   69.070767] CPU: 3 PID: 11130 Comm: cryptsetup Not tainted 3.16.0-rc5-next-20140714+ #2
[   69.078862] Hardware name: wortmann To be filled by O.E.M./P8B-M Series, BIOS 6103 12/06/2012
[   69.087413] task: ffff8802225c0930 ti: ffff88021bda0000 task.ti: ffff88021bda0000
[   69.094977] RIP: 0010:[<ffffffff81322238>]  [<ffffffff81322238>] blk_throtl_drain+0x28/0x110
[   69.103529] RSP: 0018:ffff88021bda3b60  EFLAGS: 00010046
[   69.108866] RAX: 0000000000000000 RBX: ffff880222001638 RCX: 000000007fffffff
[   69.116110] RDX: 000000000000000b RSI: 0000000000000000 RDI: 0000000000000000
[   69.123337] RBP: ffff88021bda3b78 R08: 0000000000000000 R09: ffff8800c9011ff0
[   69.130562] R10: ffff88021bda3b78 R11: ffffffff8132fd61 R12: ffff880222001638
[   69.137764] R13: ffff88021c84e600 R14: ffff880222001c30 R15: 0000000000000000
[   69.144981] FS:  00007f81fd8fb840(0000) GS:ffff88022fd80000(0000) knlGS:0000000000000000
[   69.153144] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   69.158931] CR2: 0000000000000028 CR3: 000000021bdac000 CR4: 00000000000407e0
[   69.166131] Stack:
[   69.168160]  ffff880222001638 0000000000000000 ffff880222001c40 ffff88021bda3b88
[   69.175671]  ffffffff8131f36e ffff88021bda3bb8 ffffffff8130294e ffff880222001638
[   69.183182]  ffffffff819c9580 ffff880222001638 ffff88021af91800 ffff88021bda3bd0
[   69.190740] Call Trace:
[   69.193218]  [<ffffffff8131f36e>] blkcg_drain_queue+0xe/0x10
[   69.198921]  [<ffffffff8130294e>] __blk_drain_queue+0x6e/0x150
[   69.204804]  [<ffffffff81302a8d>] blk_queue_bypass_start+0x5d/0x80
[   69.211050]  [<ffffffff8131e668>] blkcg_deactivate_policy+0x38/0x120
[   69.217437]  [<ffffffff81322454>] blk_throtl_exit+0x34/0x50
[   69.223094]  [<ffffffff8131f3aa>] blkcg_exit_queue+0x3a/0x40
[   69.228822]  [<ffffffff81305ee6>] blk_release_queue+0x26/0xe0
[   69.234600]  [<ffffffff8132fd47>] kobject_cleanup+0x77/0x1b0
[   69.240345]  [<ffffffff8132fbf8>] kobject_put+0x28/0x60
[   69.245596]  [<ffffffff81302b9b>] blk_cleanup_queue+0xeb/0x120
[   69.251464]  [<ffffffff81546cb1>] __dm_destroy+0x1d1/0x250
[   69.257043]  [<ffffffff81547a53>] dm_destroy+0x13/0x20
[   69.262265]  [<ffffffff8154d1fe>] dev_remove+0x11e/0x180
[   69.267614]  [<ffffffff8154d0e0>] ? dev_suspend+0x250/0x250
[   69.273269]  [<ffffffff8154d8d6>] ctl_ioctl+0x246/0x4e0
[   69.278549]  [<ffffffff8154db83>] dm_ctl_ioctl+0x13/0x20
[   69.283920]  [<ffffffff811e08d8>] do_vfs_ioctl+0x2d8/0x4b0
[   69.289458]  [<ffffffff811e0b31>] SyS_ioctl+0x81/0xa0
[   69.294544]  [<ffffffff811166b6>] ? __audit_syscall_exit+0x236/0x2e0
[   69.300964]  [<ffffffff816d5369>] system_call_fastpath+0x16/0x1b
[   69.307020] Code: 00 00 00 66 66 66 66 90 55 48 89 e5 41 55 41 54 49 89 fc 53 4c 8b af e0 06 00 00 49 8b 85 88 00 00 00 31 ff 48 8b 80 68 05 00 00 <48> 8b 70 28 e8 3f 44 de ff 48 85 c0 48 89 c3 74 61 0f 1f 80 00
[   69.327190] RIP  [<ffffffff81322238>] blk_throtl_drain+0x28/0x110
[   69.333402]  RSP <ffff88021bda3b60>
[   69.336937] CR2: 0000000000000028
[   69.340275] ---[ end trace 3c89b44a6f5a2b9f ]---

Regards,
Maurizio Lombardi
