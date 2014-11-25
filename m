Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaKYSwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 13:52:45 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:27677 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaKYSwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:52:43 -0500
Message-ID: <5474D0A1.2020600@oracle.com>
Date: Tue, 25 Nov 2014 13:55:29 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Richard Hendershot <rshendershot@mchsi.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH 3.17 100/141] x86, microcode: Fix accessing dis_ucode_ldr
 on 32-bit
References: <20141119205150.700188369@linuxfoundation.org> <20141119205153.916605840@linuxfoundation.org> <5474C67A.7040200@oracle.com> <20141125182410.GB4128@pd.tnic> <5474CDCE.6040000@oracle.com> <20141125184351.GC4128@pd.tnic>
In-Reply-To: <20141125184351.GC4128@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 01:43 PM, Borislav Petkov wrote:
> On Tue, Nov 25, 2014 at 01:43:26PM -0500, Boris Ostrovsky wrote:
>> I don't think this routine is called on PV.
> They're either both called or none is. At least on baremetal, that is.
>

PV guests don't start with startup_32.

We are coming from a resume into load_ucode_ap as:

[   38.644599] BUG: unable to handle kernel paging request at 0197eec0
[   38.644599] IP: [<c1071fa6>] load_ucode_ap+0x6/0xe0
[   38.644599] *pdpt = 0000000003267007 *pde = 0000000000000000
[   38.644599] Oops: 0000 [#1] SMP
[   38.644599] Modules linked in: sg sd_mod dm_multipath dm_mod 
xen_evtchn iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi 
scsi_transport_iscsi scsi_mod libcrc32c crc32c_generic radeon fbcon 
tileblit font bitblit ttm softcursor drm_kms_helper x86_pkg_temp_thermal 
crc32c_intel xen_blkfront xen_netfront xen_fbfront fb_sys_fops sysimgblt 
sysfillrect syscopyarea xen_kbdfront xenfs xen_privcmd
[   38.644599] CPU: 0 PID: 9 Comm: migration/0 Tainted: G W      
3.18.0-rc6upstream-00001-g0de9524 #1
[   38.644599] task: eb894650 ti: eb89c000 task.ti: eb89c000
[   38.644599] EIP: 0061:[<c1071fa6>] EFLAGS: 00010082 CPU: 0
[   38.644599] EIP is at load_ucode_ap+0x6/0xe0
[   38.644599] EAX: 00000000 EBX: c1823160 ECX: 00000000 EDX: c197eee0
[   38.644599] ESI: eb9bded0 EDI: c1793e95 EBP: eb89de28 ESP: eb89de20
[   38.644599]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0069
[   38.644599] CR0: 80050033 CR2: 0197eec0 CR3: 03280000 CR4: 00042660
[   38.644599] Stack:
[   38.644599]  eb89de30 c10539b0 eb89de30 c1070f9d eb89de54 c140de9e 
eb9bded0 eb89de54
[   38.644599]  c103dbcc 00000008 deadbeef eb9bded0 eb9bdee4 eb89de80 
c1397f57 00000000
[   38.644599]  00000000 80000002 eb9bdf1c 00000000 00000002 00000003 
eb9bded0 eb9bdee4
[   38.644599] Call Trace:
[   38.644599]  [<c10539b0>] ? i8237A_resume+0xb0/0xe0
[   38.644599]  [<c1070f9d>] mc_bp_resume+0x3d/0x50
[   38.644599]  [<c140de9e>] syscore_resume+0x4e/0x190
[   38.644599]  [<c103dbcc>] ? xen_timer_resume+0x3c/0x60
[   38.644599]  [<c1397f57>] xen_suspend+0x77/0xf0
[   38.644599]  [<c110dc63>] multi_cpu_stop+0x93/0xc0
[   38.644599]  [<c110de76>] cpu_stopper_thread+0x46/0x170
[   38.644599]  [<c110dbd0>] ? irq_cpu_stop_queue_work+0x20/0x20
[   38.644599]  [<c162c536>] ? __schedule+0x356/0x880
[   38.644599]  [<c10b7aab>] ? default_wake_function+0xb/0x10
[   38.644599]  [<c10c7c00>] ? __wake_up_common+0x40/0x70
[   38.644599]  [<c1630730>] ? _raw_spin_unlock_irqrestore+0x20/0x90
[   38.644599]  [<c1630730>] ? _raw_spin_unlock_irqrestore+0x20/0x90
[   38.644599]  [<c16304ef>] ? _raw_spin_lock_irqsave+0x1f/0x80
[   38.644599]  [<c16306bf>] ? _raw_spin_lock_irq+0xf/0x60
[   38.644599]  [<c10aff47>] smpboot_thread_fn+0x117/0x1a0
[   38.644599]  [<c10ac824>] kthread+0xa4/0xc0
[   38.644599]  [<c10afe30>] ? smpboot_create_threads+0x60/0x60
[   38.644599]  [<c1630bc1>] ret_from_kernel_thread+0x21/0x30
[   38.644599]  [<c10ac780>] ? kthread_freezable_should_stop+0x60/0x60
[   38.644599] Code: 55 cc eb 93 89 44 24 04 66 31 f6 c7 04 24 78 f0 74 
c1 e8 84 9f 5b 00 eb ae 90 90 90 90 90 90 90 90 90 90 90 90 55 89 e5 83 
ec 08 <80> 3d c0 ee 97 01 00 89 1c 24 89 74 24 04 74 12 8b 1c 24 8b 74
[   38.644599] EIP: [<c1071fa6>] load_ucode_ap+0x6/0xe0 SS:ESP 0069:eb89de20
[   38.644599] CR2: 000000000197eec0
[   38.644599] ---[ end trace 0ad7358b42202518 ]---
[   38.644599] Kernel panic - not syncing: Fatal exception
[   38.644599] Kernel Offset: 0x0 from 0xc1000000 (relocation range: 
0xc0000000-0xed7fdfff)




-boris
