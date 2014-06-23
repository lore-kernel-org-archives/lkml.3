Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbaFWS4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:56:07 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:50785 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbaFWS4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:56:05 -0400
MIME-Version: 1.0
In-Reply-To: <1403549545-6535-1-git-send-email-spargaonkar@suse.com>
References: <1403549545-6535-1-git-send-email-spargaonkar@suse.com>
Date: Mon, 23 Jun 2014 13:56:02 -0500
Message-ID: <CADT32e+Nj3zWoq-duZ91cHfdPFkdVG0bayAJUzPXXpqh+Fvx+A@mail.gmail.com>
Subject: Re: [PATCH] blkio: Release blkg infrastructure only after last policy
 is deactivated.
From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
        Shirish Pargaonkar <spargaonkar@suse.com>, ssant@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the type of oopses observed...

1)

Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=2048 NUMA pSeries
Modules linked in: bfa ch scsi_dh_alua fcoe megaraid_sas qla2xxx libosd
scsi_debug(-) lpfc qla4xxx stex iscsi_boot_sysfs bnx2fc cnic uio libfcoe libfc
scsi_dh_emc crc_t10dif scsi_transport_fc ps3stor_lib scsi_dh libiscsi
scsi_transport_iscsi af_packet xfs libcrc32c autofs4 btrfs xor raid6_pq sr_mod
cdrom ohci_pci ohci_hcd ehci_hcd ibmvscsi(X) scsi_transport_srp scsi_tgt
virtio_blk virtio_net usbcore usb_common virtio_pci virtio_ring virtio dm_mod
sg scsi_mod [last unloaded: sd_mod]
Supported: Yes
CPU: 0 PID: 5757 Comm: modprobe Tainted: G        W    X 3.12.14-1-default #1
task: c00000007a029510 ti: c000000003124000 task.ti: c000000003124000
NIP: c0000000003d503c LR: c0000000003d1c60 CTR: c0000000003db920
REGS: c000000003126c70 TRAP: 0300   Tainted: G        W    X
(3.12.14-1-default)
MSR: 8000000100009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 24082822  XER: 00000000
SOFTE: 0
CFAR: 00003fffb3f5855c
DAR: 0000000000000028, DSISR: 40000000

GPR00: c0000000003d1c60 c000000003126ef0 c0000000010779d8 0000000000000000
GPR04: 0000000000000001 0000000000000000 c00000007d1c7628 0000000000000001
GPR08: 0000000000000000 0000000000000000 c0000000003db920 c0000000003ad3d0
GPR12: 0000000024082828 c00000000fe80000 0000000010020bc0 0000000000000000
GPR16: 0000000000000000 0000000000000001 000000001003a068 00000000100204a0
GPR20: 00003fffeeb812d0 0000000000000000 0000000000000000 00003fffeeb812c8
GPR24: 000001001ade02b0 c000000077121100 c000000078b39c40 0000000000000000
GPR28: c000000078b3a290 c000000078b39c40 c00000007e087480 c000000078b39c40
NIP [c0000000003d503c] .blk_throtl_drain+0x2c/0x180
LR [c0000000003d1c60] .blkcg_drain_queue+0x10/0x30
PACATMSCRATCH [800000010000d033]
Call Trace:
[c000000003126ef0] [c000000003126f90] 0xc000000003126f90 (unreliable)
[c000000003126f80] [c0000000003d1c60] .blkcg_drain_queue+0x10/0x30
[c000000003126ff0] [c0000000003ad74c] .__blk_drain_queue+0xac/0x240
[c000000003127090] [c0000000003afd18] .blk_queue_bypass_start+0xa8/0x110
[c000000003127110] [c0000000003d0af4] .blkcg_deactivate_policy+0x64/0x210
[c0000000031271c0] [c0000000003d5310] .blk_throtl_exit+0x40/0x70
[c000000003127240] [c0000000003d1cd8] .blkcg_exit_queue+0x58/0x80
[c0000000031272c0] [c0000000003b38f0] .blk_release_queue+0x30/0x150
[c000000003127340] [c0000000003e4750] .kobject_cleanup+0xd0/0x230
[c0000000031273d0] [c0000000003ad3e4] .blk_put_queue+0x14/0x30
[c000000003127440] [d0000000005a368c]
.scsi_device_dev_release_usercontext+0x11c/0x180 [scsi_mod]
[c0000000031274f0] [c0000000000d7b08] .execute_in_process_context+0x88/0xa0
[c000000003127560] [d0000000005a355c] .scsi_device_dev_release+0x1c/0x30
[scsi_mod]
[c0000000031275d0] [c0000000004c5ee4] .device_release+0x54/0xe0
[c000000003127660] [c0000000003e4750] .kobject_cleanup+0xd0/0x230
[c0000000031276f0] [c0000000004c64dc] .put_device+0x1c/0x30
[c000000003127760] [d0000000005a44a8] .__scsi_remove_device+0xe8/0x150
[scsi_mod]
[c0000000031277e0] [d0000000005a2034] .scsi_forget_host+0x94/0xa0 [scsi_mod]
[c000000003127860] [d000000000593574] .scsi_remove_host+0x94/0x1a0 [scsi_mod]
[c0000000031278f0] [d000000003f43344] .sdebug_driver_remove+0x44/0xf0
[scsi_debug]
[c000000003127990] [c0000000004cc03c] .__device_release_driver+0x9c/0x120
[c000000003127a10] [c0000000004cc0f0] .device_release_driver+0x30/0x60
[c000000003127a90] [c0000000004cb58c] .bus_remove_device+0x12c/0x1d0
[c000000003127b20] [c0000000004c67cc] .device_del+0x15c/0x250
[c000000003127bb0] [c0000000004c68ec] .device_unregister+0x2c/0x90
[c000000003127c30] [d000000003f42d94] .sdebug_remove_adapter+0x94/0xe0
[scsi_debug]
[c000000003127cb0] [d000000003f488e0] .scsi_debug_exit+0x34/0xdfc [scsi_debug]
[c000000003127d30] [c000000000142ad4] .SyS_delete_module+0x1f4/0x340
[c000000003127e30] [c000000000009efc] syscall_exit+0x0/0x7c
Instruction dump:
4bfffd18 7c0802a6 fba1ffe8 fbc1fff0 fbe1fff8 7c7d1b78 f8010010 f821ff71
ebc30700 e93e00a0 38600000 e92905c8 <e8890028> 4bd7b541 60000000 7c7f1b79
---[ end trace e7bf9df70e311596 ]---


2)

modprobe -r scsi_debug
cpu 0x3: Vector: 300 (Data Access) at [c0000002db203300]
pc: c0000000003d10fc: blk_throtl_drain+0x3c/0x190
lr: c0000000003cd7b8: blkcg_drain_queue+0x28/0x40
sp: c0000002db203580
msr: 8000000100009033
dar: 28
dsisr: 40000000
current = 0xc0000002d4fe9510
paca    = 0xc000000007e40a80     softe: 0     irq_happened: 0x01
pid   = 6783, comm = modprobe
enter ? for help
[c0000002db2035c0] c0000000003cd7b8 blkcg_drain_queue+0x28/0x40
[c0000002db2035f0] c0000000003a640c __blk_drain_queue+0xbc/0x250
[c0000002db203640] c0000000003a8bb8 blk_queue_bypass_start+0xb8/0x120
[c0000002db203680] c0000000003cc548 blkcg_deactivate_policy+0x78/0x220
[c0000002db2036d0] c0000000003d7670 cfq_exit_queue+0x120/0x170
[c0000002db203720] c0000000003a0bec elevator_exit+0x5c/0x90
[c0000002db203750] c0000000003ad008 blk_release_queue+0x98/0x160
[c0000002db203780] c0000000003e2124 kobject_cleanup+0xd4/0x240
[c0000002db203800] c0000000003a604c blk_put_queue+0x2c/0x50
[c0000002db203830] d0000000028c55bc
scsi_device_dev_release_usercontext+0x12c/0x190 [scsi_mod]
[c0000002db203890] c0000000000c29b4 execute_in_process_context+0xa4/0xd0
[c0000002db2038c0] d0000000028c5474 scsi_device_dev_release+0x34/0x50
[scsi_mod]
[c0000002db2038f0] c0000000004c3c10 device_release+0x60/0xf0
[c0000002db203970] c0000000003e2124 kobject_cleanup+0xd4/0x240
[c0000002db2039f0] c0000000004c4324 put_device+0x34/0x50
[c0000002db203a20] d0000000028c66e4 __scsi_remove_device+0xf4/0x150 [scsi_mod]
[c0000002db203a50] d0000000028c3844 scsi_forget_host+0xa4/0xc0 [scsi_mod]
[c0000002db203a80] d0000000028b3a24 scsi_remove_host+0xa4/0x1b0 [scsi_mod]
[c0000002db203ac0] d000000002093c04 sdebug_driver_remove+0x54/0x100
[scsi_debug]
[c0000002db203b50] c0000000004caa9c __device_release_driver+0xac/0x130
[c0000002db203b80] c0000000004cab60 device_release_driver+0x40/0x70
[c0000002db203bb0] c0000000004c9f18 bus_remove_device+0x138/0x1e0
[c0000002db203c30] c0000000004c466c device_del+0x16c/0x260
[c0000002db203c70] c0000000004c479c device_unregister+0x3c/0xa0
[c0000002db203ce0] d0000000020934e4 sdebug_remove_adapter+0xa4/0xf0
[scsi_debug]
[c0000002db203d10] d000000002099410 scsi_debug_exit+0x3c/0x116c [scsi_debug]
[c0000002db203d40] c00000000013b520 SyS_delete_module+0x200/0x350
[c0000002db203e30] c000000000009dfc syscall_exit+0x0/0x7c
--- Exception: c01 (System Call) at 00003fff92974040
SP (3fffd65d4cc0) is in userspace

On Mon, Jun 23, 2014 at 1:52 PM,  <shirishpargaonkar@gmail.com> wrote:
> From: Shirish Pargaonkar <spargaonkar@suse.com>
>
> Release blkg infrastructure only after last policy is deactivated
> (i.e. let blkg_destroy_all() be called only from blkcg_deactivate_policy())
>
> Otherwise, module can oops because root_blkg gets assigned NULL during
> cleanup and we attempt draining the service queues via root_blkg afterwords.
>
> Signed-off-by: Shirish Pargaonkar <spargaonkar@suse.com>
> Reported-and-tested-by: Sachin Sant <ssant@in.ibm.com>
> ---
>  block/blk-cgroup.c | 15 ---------------
>  block/blk-sysfs.c  |  2 +-
>  2 files changed, 1 insertion(+), 16 deletions(-)
>
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 069bc20..3920de6 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -878,21 +878,6 @@ void blkcg_drain_queue(struct request_queue *q)
>         blk_throtl_drain(q);
>  }
>
> -/**
> - * blkcg_exit_queue - exit and release blkcg part of request_queue
> - * @q: request_queue being released
> - *
> - * Called from blk_release_queue().  Responsible for exiting blkcg part.
> - */
> -void blkcg_exit_queue(struct request_queue *q)
> -{
> -       spin_lock_irq(q->queue_lock);
> -       blkg_destroy_all(q);
> -       spin_unlock_irq(q->queue_lock);
> -
> -       blk_throtl_exit(q);
> -}
> -
>  /*
>   * We cannot support shared io contexts, as we have no mean to support
>   * two tasks with the same ioc in two different groups without major rework
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 23321fb..ee24cd2 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -503,7 +503,7 @@ static void blk_release_queue(struct kobject *kobj)
>
>         blk_sync_queue(q);
>
> -       blkcg_exit_queue(q);
> +       blk_throtl_exit(q);
>
>         if (q->elevator) {
>                 spin_lock_irq(q->queue_lock);
> --
> 1.8.3.2
>
