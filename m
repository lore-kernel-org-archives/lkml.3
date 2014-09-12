Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbaILLyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 07:54:37 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:37997 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbaILLyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 07:54:35 -0400
MIME-Version: 1.0
In-Reply-To: <541178D6.6010303@de.ibm.com>
References: <541178D6.6010303@de.ibm.com>
Date: Fri, 12 Sep 2014 19:54:34 +0800
Message-ID: <CACVXFVO7Oo9GeagPhejngfoeySxOP4EqWz_GN6kYv2956-Wtxg@mail.gmail.com>
Subject: Re: blk-mq crash under KVM in multiqueue block code (with virtio-blk
 and ext4)
From: Ming Lei <tom.leiming@gmail.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: rusty Russell <rusty@rustcorp.com.au>,
        "ms >> Michael S. Tsirkin" <mst@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, KVM list <kvm@vger.kernel.org>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org >> Linux Kernel Mailing List" 
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 6:26 PM, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
> Folks,
>
> we have seen the following bug with 3.16 as a KVM guest. It suspect the blk-mq rework that happened between 3.15 and 3.16, but it can be something completely different.
>

Care to share how you reproduce the issue?

> [   65.992022] Unable to handle kernel pointer dereference in virtual kernel address space
> [   65.992187] failing address: ccccccccccccd000 TEID: ccccccccccccd803
> [   65.992363] Fault in home space mode while using kernel ASCE.
> [   65.992365] AS:0000000000a7c007 R3:0000000000000024
> [   65.993754] Oops: 0038 [#1] SMP
> [   65.993923] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi virtio_balloon vhost_net vhost macvtap macvlan kvm dm_multipath virtio_net virtio_blk sunrpc
> [   65.994274] CPU: 0 PID: 44 Comm: kworker/u6:2 Not tainted 3.16.0-20140814.0.c66c84c.fc18-s390xfrob #1
> [   65.996043] Workqueue: writeback bdi_writeback_workfn (flush-251:32)
> [   65.996222] task: 0000000002250000 ti: 0000000002258000 task.ti: 0000000002258000
> [   65.996228] Krnl PSW : 0704f00180000000 00000000003ed114 (blk_mq_tag_to_rq+0x20/0x38)
> [   65.997299]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:3 PM:0 EA:3
>                Krnl GPRS: 0000000000000040 cccccccccccccccc 0000000001619000 000000000000004e
> [   65.997301]            000000000000004e 0000000000000000 0000000000000001 0000000000a0de18
> [   65.997302]            0000000077ffbe18 0000000077ffbd50 000000006d72d620 000000000000004f
> [   65.997304]            0000000001a99400 0000000000000080 00000000003eddee 0000000077ffbc28
> [   65.997864] Krnl Code: 00000000003ed106: e31020300004        lg      %r1,48(%r2)
>                           00000000003ed10c: 91082044            tm      68(%r2),8
>                          #00000000003ed110: a7840009            brc     8,3ed122
>                          >00000000003ed114: e34016880004        lg      %r4,1672(%r1)
>                           00000000003ed11a: 59304100            c       %r3,256(%r4)
>                           00000000003ed11e: a7840003            brc     8,3ed124
>                           00000000003ed122: 07fe                bcr     15,%r14
>                           00000000003ed124: b9040024            lgr     %r2,%r4
> [   65.998221] Call Trace:
> [   65.998224] ([<0000000000000001>] 0x1)
> [   65.998227]  [<00000000003f17b6>] blk_mq_tag_busy_iter+0x7a/0xc4
> [   65.998228]  [<00000000003edcd6>] blk_mq_rq_timer+0x96/0x13c
> [   65.999226]  [<000000000013ee60>] call_timer_fn+0x40/0x110
> [   65.999230]  [<000000000013f642>] run_timer_softirq+0x2de/0x3d0
> [   65.999238]  [<0000000000135b70>] __do_softirq+0x124/0x2ac
> [   65.999241]  [<0000000000136000>] irq_exit+0xc4/0xe4
> [   65.999435]  [<000000000010bc08>] do_IRQ+0x64/0x84
> [   66.437533]  [<000000000067ccd8>] ext_skip+0x42/0x46
> [   66.437541]  [<00000000003ed7b4>] __blk_mq_alloc_request+0x58/0x1e8
> [   66.437544] ([<00000000003ed788>] __blk_mq_alloc_request+0x2c/0x1e8)
> [   66.437547]  [<00000000003eef82>] blk_mq_map_request+0xc2/0x208
> [   66.437549]  [<00000000003ef860>] blk_sq_make_request+0xac/0x350
> [   66.437721]  [<00000000003e2d6c>] generic_make_request+0xc4/0xfc
> [   66.437723]  [<00000000003e2e56>] submit_bio+0xb2/0x1a8
> [   66.438373]  [<000000000031e8aa>] ext4_io_submit+0x52/0x80
> [   66.438375]  [<000000000031ccfa>] ext4_writepages+0x7c6/0xd0c
> [   66.438378]  [<00000000002aea20>] __writeback_single_inode+0x54/0x274
> [   66.438379]  [<00000000002b0134>] writeback_sb_inodes+0x28c/0x4ec
> [   66.438380]  [<00000000002b042e>] __writeback_inodes_wb+0x9a/0xe4
> [   66.438382]  [<00000000002b06a2>] wb_writeback+0x22a/0x358
> [   66.438383]  [<00000000002b0cd0>] bdi_writeback_workfn+0x354/0x538
> [   66.438618]  [<000000000014e3aa>] process_one_work+0x1aa/0x418
> [   66.438621]  [<000000000014ef94>] worker_thread+0x48/0x524
> [   66.438625]  [<00000000001560ca>] kthread+0xee/0x108
> [   66.438627]  [<000000000067c76e>] kernel_thread_starter+0x6/0xc
> [   66.438628]  [<000000000067c768>] kernel_thread_starter+0x0/0xc
> [   66.438629] Last Breaking-Event-Address:
> [   66.438631]  [<00000000003edde8>] blk_mq_timeout_check+0x6c/0xb8
>
> I looked into the dump, and the full function is  (annotated by me to match the source code)
> r2= tags
> r3= tag (4e)
> Dump of assembler code for function blk_mq_tag_to_rq:
>    0x00000000003ed0f4 <+0>:     lg      %r1,96(%r2)                     # r1 has now tags->rqs
>    0x00000000003ed0fa <+6>:     sllg    %r2,%r3,3                       # r2 has tag*8
>    0x00000000003ed100 <+12>:    lg      %r2,0(%r2,%r1)                  # r2 now has rq (=tags->rqs[tag])
>    0x00000000003ed106 <+18>:    lg      %r1,48(%r2)                     # r1 now has rq->q
>    0x00000000003ed10c <+24>:    tm      68(%r2),8                       # test for rq->cmd_flags & REQ_FLUSH_SEQ
>    0x00000000003ed110 <+28>:    je      0x3ed122 <blk_mq_tag_to_rq+46>  #  if not goto 3ed122
>    0x00000000003ed114 <+32>:    lg      %r4,1672(%r1)                   # r4 = rq->q->flush_rq  <-------- CRASHES as rq->q points to cccccccccccc
>    0x00000000003ed11a <+38>:    c       %r3,256(%r4)                    # compare tag with rq->q->flush_rq->tag
>    0x00000000003ed11e <+42>:    je      0x3ed124 <blk_mq_tag_to_rq+48>  # if equal goto ..124
>    0x00000000003ed122 <+46>:    br      %r14                            # return (with return value == r2)
>    0x00000000003ed124 <+48>:    lgr     %r2,%r4                         # return value = r4
>    0x00000000003ed128 <+52>:    br      %r14                            # return
>
> Does anyone have an idea?
> The request itself is completely filled with cc

That is very weird, the 'rq' is got from hctx->tags,  and rq should be
valid, and rq->q shouldn't have been changed even though it was
double free or double allocation.

> I am currently asking myself if blk_mq_map_request should protect against softirq here but I cant say for sure,as I have never looked into that code before.

No, it needn't the protection.

Thanks,
