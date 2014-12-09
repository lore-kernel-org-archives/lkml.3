Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbaLIAlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 19:41:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55738 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131AbaLIAlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 19:41:14 -0500
MIME-Version: 1.0
In-Reply-To: <1417606684-20907-1-git-send-email-ming.lei@canonical.com>
References: <1417606684-20907-1-git-send-email-ming.lei@canonical.com>
Date: Tue, 9 Dec 2014 08:41:02 +0800
Message-ID: <CACVXFVMzQ8TkxsiUujUZR0E=0Lx=BtZ2BsLmhCTHk8D9dr8rag@mail.gmail.com>
Subject: Re: [PATCH] blk-mq: prevent unmapped hw queue from being scheduled
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Ming Lei <ming.lei@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 7:38 PM, Ming Lei <ming.lei@canonical.com> wrote:
> When one hardware queue has no mapped software queues, it
> shouldn't have been scheduled. Otherwise WARNING or OOPS
> can triggered.
>
> blk_mq_hw_queue_mapped() helper is introduce for fixing
> the problem.
>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  block/blk-mq.c |    8 ++++++--
>  block/blk-mq.h |    5 +++++
>  2 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index c95abc6..c916ad0 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -599,7 +599,7 @@ static void blk_mq_rq_timer(unsigned long priv)
>                  * If not software queues are currently mapped to this
>                  * hardware queue, there's nothing to check
>                  */
> -               if (!hctx->nr_ctx || !hctx->tags)
> +               if (!blk_mq_hw_queue_mapped(hctx))
>                         continue;
>
>                 blk_mq_tag_busy_iter(hctx, blk_mq_check_expired, &data);
> @@ -819,7 +819,8 @@ static int blk_mq_hctx_next_cpu(struct blk_mq_hw_ctx *hctx)
>
>  void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
>  {
> -       if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
> +       if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state) ||
> +           !blk_mq_hw_queue_mapped(hctx)))
>                 return;
>
>         if (!async) {
> @@ -926,6 +927,9 @@ static void blk_mq_delay_work_fn(struct work_struct *work)
>
>  void blk_mq_delay_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs)
>  {
> +       if (unlikely(!blk_mq_hw_queue_mapped(hctx)))
> +               return;
> +
>         kblockd_schedule_delayed_work_on(blk_mq_hctx_next_cpu(hctx),
>                         &hctx->delay_work, msecs_to_jiffies(msecs));
>  }
> diff --git a/block/blk-mq.h b/block/blk-mq.h
> index d567d52..206230e 100644
> --- a/block/blk-mq.h
> +++ b/block/blk-mq.h
> @@ -115,4 +115,9 @@ static inline void blk_mq_set_alloc_data(struct blk_mq_alloc_data *data,
>         data->hctx = hctx;
>  }
>
> +static inline bool blk_mq_hw_queue_mapped(struct blk_mq_hw_ctx *hctx)
> +{
> +       return hctx->nr_ctx && hctx->tags;
> +}
> +
>  #endif

Gentle ping...

Without the change, it is easy to trigger following warning/oops in
my virtio-scsi test.

[  124.286891] ------------[ cut here ]------------
[  124.288310] WARNING: CPU: 0 PID: 522 at block/blk-mq.c:705
__blk_mq_run_hw_queue+0x69/0x315()
[  124.290219] Modules linked in: ipv6 serio_raw
[  124.291338] CPU: 0 PID: 522 Comm: kworker/0:1H Tainted: G        W
    3.18.0-rc6-next-20141201 #57
[  124.293335] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS Bochs 01/01/2011
[  124.295116] Workqueue: kblockd blk_mq_run_work_fn
[  124.296031]  00000000000002c1 ffff880016bf7c28 ffffffff814992ac
0000000080000000
[  124.297487]  0000000000000000 ffff880016bf7c68 ffffffff81044cb9
ffff880016bf7c58
[  124.298971]  ffffffff81237fd6 ffff88001cb7ec00 ffff88001d09e4c0
ffff88001cb7e400
[  124.300439] Call Trace:
[  124.300900]  [<ffffffff814992ac>] dump_stack+0x4f/0x7b
[  124.301876]  [<ffffffff81044cb9>] warn_slowpath_common+0xa1/0xbb
[  124.303008]  [<ffffffff81237fd6>] ? __blk_mq_run_hw_queue+0x69/0x315
[  124.304229]  [<ffffffff81044ced>] warn_slowpath_null+0x1a/0x1c
[  124.305303]  [<ffffffff81237fd6>] __blk_mq_run_hw_queue+0x69/0x315
[  124.306456]  [<ffffffff8108119c>] ? __lock_is_held+0x31/0x52
[  124.307543]  [<ffffffff812382bb>] blk_mq_run_work_fn+0x15/0x17
[  124.308631]  [<ffffffff8105adc9>] process_one_work+0x282/0x468
[  124.309730]  [<ffffffff8105ac94>] ? process_one_work+0x14d/0x468
[  124.310831]  [<ffffffff8105b22e>] worker_thread+0x250/0x2b5
[  124.311881]  [<ffffffff8105afde>] ? process_scheduled_works+0x2f/0x2f
[  124.313066]  [<ffffffff8105fc59>] kthread+0xba/0xc2
[  124.313965]  [<ffffffff8106567e>] ? finish_task_switch+0x5d/0x122
[  124.315114]  [<ffffffff81069227>] ? preempt_count_sub+0xc4/0xd1
[  124.316200]  [<ffffffff8105fb9f>] ? __init_kthread_worker+0x5a/0x5a
[  124.317376]  [<ffffffff814a016c>] ret_from_fork+0x7c/0xb0
[  124.318392]  [<ffffffff8105fb9f>] ? __init_kthread_worker+0x5a/0x5a
[  124.319943] ---[ end trace 3119f396c663862f ]---
[  133.865477] EXT4-fs (sda): mounted filesystem with ordered data
mode. Opts: (null)
[  181.990071] random: nonblocking pool is initialized
[  184.301383] BUG: unable to handle kernel paging request at ffffffff81d52400
[  184.302085] IP: [<ffffffff8105a2ed>] __queue_work+0xec/0x2be
[  184.302085] PGD 1a12067 PUD 1a13063 PMD 8000000001c00062
[  184.302085] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  184.302085] Dumping ftrace buffer:
[  184.302085]    (ftrace buffer empty)
[  184.302085] Modules linked in: ipv6 serio_raw
[  184.302085] CPU: 0 PID: 522 Comm: kworker/0:1H Tainted: G        W
    3.18.0-rc6-next-20141201 #57
[  184.302085] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS Bochs 01/01/2011
[  184.302085] Workqueue: kblockd blk_mq_requeue_work
[  184.302085] task: ffff88001610d180 ti: ffff880016bf4000 task.ti:
ffff880016bf4000
[  184.302085] RIP: 0010:[<ffffffff8105a2ed>]  [<ffffffff8105a2ed>]
__queue_work+0xec/0x2be
[  184.302085] RSP: 0018:ffff880016bf7bd8  EFLAGS: 00010086
[  184.302085] RAX: ffff88001fbd2ec0 RBX: ffffffff81d52400 RCX: 0000000000000000
[  184.302085] RDX: 0000000000000000 RSI: ffffffff821cc970 RDI: ffffffff81a4fad0
[  184.302085] RBP: ffff880016bf7c18 R08: ffffffff821cc970 R09: ffffffff821cc970
[  184.302085] R10: ffffffff821cc970 R11: ffff88000000006c R12: ffff88001cb7ec88
[  184.302085] R13: 0000000000000001 R14: ffff88001e420400 R15: 0000000000000001
[  184.302085] FS:  0000000000000000(0000) GS:ffff88001fa00000(0000)
knlGS:0000000000000000
[  184.302085] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  184.302085] CR2: ffffffff81d52400 CR3: 000000001999b000 CR4: 00000000000006f0
[  184.302085] Stack:
[  184.302085]  ffff88001d09e4c0 ffff88001d30e000 ffff88001cb7f448
0000000000000001
[  184.302085]  ffff88001e420400 ffff88001cb7ec88 0000000000000001
0000000000000000
[  184.302085]  ffff880016bf7c58 ffffffff8105a5dc 0000000000000002
0000000000000282
[  184.302085] Call Trace:
[  184.302085]  [<ffffffff8105a5dc>] __queue_delayed_work+0xb5/0x114
[  184.302085]  [<ffffffff8105a966>] queue_delayed_work_on+0x54/0x77
[  184.302085]  [<ffffffff8122cb02>] kblockd_schedule_delayed_work_on+0x1b/0x20
[  184.302085]  [<ffffffff8123891a>] blk_mq_run_hw_queue+0xd5/0xda
[  184.302085]  [<ffffffff81238f8f>] blk_mq_start_hw_queue+0x18/0x1a
[  184.302085]  [<ffffffff81238fc2>] blk_mq_start_hw_queues+0x31/0x38
[  184.302085]  [<ffffffff81239c95>] blk_mq_requeue_work+0xc5/0xd1
[  184.302085]  [<ffffffff8105adc9>] process_one_work+0x282/0x468
[  184.302085]  [<ffffffff8105ac94>] ? process_one_work+0x14d/0x468
[  184.302085]  [<ffffffff8105b22e>] worker_thread+0x250/0x2b5
[  184.302085]  [<ffffffff8105afde>] ? process_scheduled_works+0x2f/0x2f
[  184.302085]  [<ffffffff8105fc59>] kthread+0xba/0xc2
[  184.302085]  [<ffffffff8106567e>] ? finish_task_switch+0x5d/0x122
[  184.302085]  [<ffffffff81069227>] ? preempt_count_sub+0xc4/0xd1
[  184.302085]  [<ffffffff8105fb9f>] ? __init_kthread_worker+0x5a/0x5a
[  184.302085]  [<ffffffff814a016c>] ret_from_fork+0x7c/0xb0
[  184.302085]  [<ffffffff8105fb9f>] ? __init_kthread_worker+0x5a/0x5a
[  184.302085] Code: 03 1c c5 d0 bb b5 81 eb 15 44 89 ff e8 89 4d fe
ff 4c 89 f7 89 c6 e8 9e fe ff ff 48 89 c3 4c 89 e7 e8 33 fb ff ff 48
85 c0 74 3b <48> 3b 03 74 36 48 89 c7 48 89 45 c8 e8 55 50 44 00 48 8b
55 c8
[  184.302085] RIP  [<ffffffff8105a2ed>] __queue_work+0xec/0x2be
[  184.302085]  RSP <ffff880016bf7bd8>
[  184.302085] CR2: ffffffff81d52400
[  184.302085] ---[ end trace 3119f396c6638630 ]---
[  184.360165] BUG: unable to handle kernel paging request at ffffffffffffff98
[  184.361025] IP: [<ffffffff81060371>] kthread_data+0x10/0x16
[  184.361025] PGD 1a12067 PUD 1a14067 PMD 0
[  184.361025] Oops: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC
[  184.361025] Dumping ftrace buffer:
[  184.361025]    (ftrace buffer empty)
[  184.361025] Modules linked in: ipv6 serio_raw
[  184.361025] CPU: 0 PID: 522 Comm: kworker/0:1H Tainted: G      D W
    3.18.0-rc6-next-20141201 #57
[  184.361025] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS Bochs 01/01/2011
[  184.361025] task: ffff88001610d180 ti: ffff880016bf4000 task.ti:
ffff880016bf4000
[  184.361025] RIP: 0010:[<ffffffff81060371>]  [<ffffffff81060371>]
kthread_data+0x10/0x16
[  184.361025] RSP: 0000:ffff880016bf77b8  EFLAGS: 00010046
[  184.361025] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88001fbd3538
[  184.361025] RDX: 0000000000000006 RSI: 0000000000000000 RDI: ffff88001610d180
[  184.361025] RBP: ffff880016bf77b8 R08: ffffffff81f62ec0 R09: 000000000000b8cb
[  184.361025] R10: ffff88001610d180 R11: ffff88001fbd3480 R12: 0000000000000000
[  184.361025] R13: 0000000000000000 R14: ffff88001610d180 R15: 0000000000000001
[  184.361025] FS:  0000000000000000(0000) GS:ffff88001fa00000(0000)
knlGS:0000000000000000
[  184.361025] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  184.361025] CR2: 0000000000000028 CR3: 0000000019970000 CR4: 00000000000006f0
[  184.361025] Stack:
[  184.361025]  ffff880016bf77e8 ffffffff8105bc3f ffff88001fbd3480
ffff88001fbd3480
[  184.361025]  0000000000000000 0000000000000040 ffff880016bf7858
ffffffff8149b3c1
[  184.361025]  ffff880016bf7848 ffff880016bf4000 ffff88001610d180
00000000001d3480
[  184.361025] Call Trace:
[  184.361025]  [<ffffffff8105bc3f>] wq_worker_sleeping+0x19/0x9e
[  184.361025]  [<ffffffff8149b3c1>] __schedule+0x1f9/0x696
[  184.361025]  [<ffffffff8149b9bb>] schedule+0x69/0x6b
[  184.361025]  [<ffffffff81047ab8>] do_exit+0x9ec/0x9ee
[  184.361025]  [<ffffffff81005f93>] oops_end+0xb2/0xba
[  184.361025]  [<ffffffff81d52400>] ? do_name+0x112/0x288
[  184.361025]  [<ffffffff81494cca>] no_context+0x317/0x345
[  184.361025]  [<ffffffff812de375>] ? virtqueue_add_sgs+0x7d/0x8c
[  184.361025]  [<ffffffff81d52400>] ? do_name+0x112/0x288
[  184.361025]  [<ffffffff81494ed5>] __bad_area_nosemaphore+0x1dd/0x1fe
[  184.361025]  [<ffffffff81d52400>] ? do_name+0x112/0x288
[  184.361025]  [<ffffffff81494f09>] bad_area_nosemaphore+0x13/0x15
[  184.361025]  [<ffffffff81038be5>] __do_page_fault+0x3f8/0x438
[  184.361025]  [<ffffffff8149fcd6>] ? _raw_spin_unlock_irqrestore+0x3f/0x60
[  184.361025]  [<ffffffff810806c5>] ? trace_hardirqs_on_caller+0x1c1/0x1e0
[  184.361025]  [<ffffffff812dede6>] ? vp_notify+0x21/0x25
[  184.361025]  [<ffffffff812ddc1a>] ? virtqueue_notify+0x19/0x2b
[  184.361025]  [<ffffffff814a20e3>] ? error_sti+0x5/0x6
[  184.361025]  [<ffffffff8126c80c>] ? __this_cpu_preempt_check+0x13/0x15
[  184.361025]  [<ffffffff8107e735>] ? trace_hardirqs_off_caller+0x131/0x13d
[  184.361025]  [<ffffffff8125788d>] ? trace_hardirqs_off_thunk+0x3a/0x3f
[  184.361025]  [<ffffffff81038c31>] do_page_fault+0xc/0xe
[  184.361025]  [<ffffffff814a1ee2>] page_fault+0x22/0x30
[  184.361025]  [<ffffffff81d52400>] ? do_name+0x112/0x288
[  184.361025]  [<ffffffff8105a2ed>] ? __queue_work+0xec/0x2be
[  184.361025]  [<ffffffff8105a2e8>] ? __queue_work+0xe7/0x2be
[  184.361025]  [<ffffffff8105a5dc>] __queue_delayed_work+0xb5/0x114
[  184.361025]  [<ffffffff8105a966>] queue_delayed_work_on+0x54/0x77
[  184.361025]  [<ffffffff8122cb02>] kblockd_schedule_delayed_work_on+0x1b/0x20
[  184.361025]  [<ffffffff8123891a>] blk_mq_run_hw_queue+0xd5/0xda
[  184.361025]  [<ffffffff81238f8f>] blk_mq_start_hw_queue+0x18/0x1a
[  184.361025]  [<ffffffff81238fc2>] blk_mq_start_hw_queues+0x31/0x38
[  184.361025]  [<ffffffff81239c95>] blk_mq_requeue_work+0xc5/0xd1
[  184.361025]  [<ffffffff8105adc9>] process_one_work+0x282/0x468
[  184.361025]  [<ffffffff8105ac94>] ? process_one_work+0x14d/0x468
[  184.361025]  [<ffffffff8105b22e>] worker_thread+0x250/0x2b5
[  184.361025]  [<ffffffff8105afde>] ? process_scheduled_works+0x2f/0x2f
[  184.361025]  [<ffffffff8105fc59>] kthread+0xba/0xc2
[  184.361025]  [<ffffffff8106567e>] ? finish_task_switch+0x5d/0x122
[  184.361025]  [<ffffffff81069227>] ? preempt_count_sub+0xc4/0xd1
[  184.361025]  [<ffffffff8105fb9f>] ? __init_kthread_worker+0x5a/0x5a
[  184.361025]  [<ffffffff814a016c>] ret_from_fork+0x7c/0xb0
[  184.361025]  [<ffffffff8105fb9f>] ? __init_kthread_worker+0x5a/0x5a
[  184.361025] Code: 40 ab 00 00 48 8b 80 d8 08 00 00 48 89 e5 5d 48
8b 40 88 48 c1 e8 02 83 e0 01 c3 0f 1f 44 00 00 48 8b 87 d8 08 00 00
55 48 89 e5 <48> 8b 40 98 5d c3 0f 1f 44 00 00 55 ba 08 00 00 00 48 89
e5 48
[  184.361025] RIP  [<ffffffff81060371>] kthread_data+0x10/0x16
[  184.361025]  RSP <ffff880016bf77b8>
[  184.361025] CR2: ffffffffffffff98
[  184.361025] ---[ end trace 3119f396c6638631 ]---
[  184.361025] Fixing recursive fault but reboot is needed!
[  184.361025] BUG: scheduling while atomic: kworker/0:1H/522/0x00000004
[  184.361025] INFO: lockdep is turned off.
[  184.361025] Modules linked in: ipv6 serio_raw
[  184.361025] irq event stamp: 716
[  184.361025] hardirqs last  enabled at (715): [<ffffffff8149fcd6>]
_raw_spin_unlock_irqrestore+0x3f/0x60
[  184.361025] hardirqs last disabled at (716): [<ffffffff8105a944>]
queue_delayed_work_on+0x32/0x77
[  184.361025] softirqs last  enabled at (416): [<ffffffff81048a59>]
__do_softirq+0x347/0x3a1
[  184.361025] softirqs last disabled at (411): [<ffffffff81048c93>]
irq_exit+0x40/0x94
[  184.361025] Preemption disabled at:[<ffffffff81005f93>] oops_end+0xb2/0xba
[  184.361025]
[  184.361025] CPU: 0 PID: 522 Comm: kworker/0:1H Tainted: G      D W
    3.18.0-rc6-next-20141201 #57
[  184.361025] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS Bochs 01/01/2011
[  184.361025]  0000000000000000 ffff880016bf73a8 ffffffff814992ac
0000000080000004
[  184.361025]  ffff88001610d180 ffff880016bf73c8 ffffffff8149575d
0000000000000001
[  184.361025]  ffff88001fbd3480 ffff880016bf7438 ffffffff8149b26c
ffffffff81091003
[  184.361025] Call Trace:
[  184.361025]  [<ffffffff814992ac>] dump_stack+0x4f/0x7b
[  184.361025]  [<ffffffff8149575d>] __schedule_bug+0xb3/0xc3
[  184.361025]  [<ffffffff8149b26c>] __schedule+0xa4/0x696
[  184.361025]  [<ffffffff81091003>] ? kmsg_dump+0x24/0x1aa
[  184.361025]  [<ffffffff8149b9bb>] schedule+0x69/0x6b
[  184.361025]  [<ffffffff810471d3>] do_exit+0x107/0x9ee
[  184.361025]  [<ffffffff81091180>] ? kmsg_dump+0x1a1/0x1aa
[  184.361025]  [<ffffffff81091003>] ? kmsg_dump+0x24/0x1aa
[  184.361025]  [<ffffffff81005f93>] oops_end+0xb2/0xba
[  184.361025]  [<ffffffff81494cca>] no_context+0x317/0x345
[  184.361025]  [<ffffffff8118c72a>] ? fsnotify_clear_marks_by_inode+0x30/0xb7
[  184.361025]  [<ffffffff81494ed5>] __bad_area_nosemaphore+0x1dd/0x1fe
[  184.361025]  [<ffffffff8118c72a>] ? fsnotify_clear_marks_by_inode+0x30/0xb7
[  184.361025]  [<ffffffff81494f09>] bad_area_nosemaphore+0x13/0x15
[  184.361025]  [<ffffffff81038be5>] __do_page_fault+0x3f8/0x438
[  184.361025]  [<ffffffff8109a67c>] ? __call_rcu.constprop.64+0x1ed/0x206
[  184.361025]  [<ffffffff8108051a>] ? trace_hardirqs_on_caller+0x16/0x1e0
[  184.361025]  [<ffffffff8107cd8d>] ? rcu_read_unlock+0x5d/0x5d
[  184.361025]  [<ffffffff810eae88>] ? time_hardirqs_off+0x1b/0x2f
[  184.361025]  [<ffffffff814a20e3>] ? error_sti+0x5/0x6
[  184.361025]  [<ffffffff8107e623>] ? trace_hardirqs_off_caller+0x1f/0x13d
[  184.361025]  [<ffffffff8125788d>] ? trace_hardirqs_off_thunk+0x3a/0x3f
[  184.361025]  [<ffffffff81038c31>] do_page_fault+0xc/0xe
[  184.361025]  [<ffffffff814a1ee2>] page_fault+0x22/0x30
[  184.361025]  [<ffffffff81060371>] ? kthread_data+0x10/0x16
[  184.361025]  [<ffffffff8106777f>] ? dequeue_task+0x66/0x6d
[  184.361025]  [<ffffffff8105bc3f>] wq_worker_sleeping+0x19/0x9e
[  184.361025]  [<ffffffff8149b3c1>] __schedule+0x1f9/0x696
[  184.361025]  [<ffffffff8149b9bb>] schedule+0x69/0x6b
[  184.361025]  [<ffffffff81047ab8>] do_exit+0x9ec/0x9ee
[  184.361025]  [<ffffffff81005f93>] oops_end+0xb2/0xba
[  184.361025]  [<ffffffff81d52400>] ? do_name+0x112/0x288
[  184.361025]  [<ffffffff81494cca>] no_context+0x317/0x345
[  184.361025]  [<ffffffff812de375>] ? virtqueue_add_sgs+0x7d/0x8c
[  184.361025]  [<ffffffff81d52400>] ? do_name+0x112/0x288
[  184.361025]  [<ffffffff81494ed5>] __bad_area_nosemaphore+0x1dd/0x1fe
[  184.361025]  [<ffffffff81d52400>] ? do_name+0x112/0x288
[  184.361025]  [<ffffffff81494f09>] bad_area_nosemaphore+0x13/0x15
[  184.361025]  [<ffffffff81038be5>] __do_page_fault+0x3f8/0x438
[  184.361025]  [<ffffffff8149fcd6>] ? _raw_spin_unlock_irqrestore+0x3f/0x60
[  184.361025]  [<ffffffff810806c5>] ? trace_hardirqs_on_caller+0x1c1/0x1e0
[  184.361025]  [<ffffffff812dede6>] ? vp_notify+0x21/0x25
[  184.361025]  [<ffffffff812ddc1a>] ? virtqueue_notify+0x19/0x2b
[  184.361025]  [<ffffffff814a20e3>] ? error_sti+0x5/0x6
[  184.361025]  [<ffffffff8126c80c>] ? __this_cpu_preempt_check+0x13/0x15
[  184.361025]  [<ffffffff8107e735>] ? trace_hardirqs_off_caller+0x131/0x13d
[  184.361025]  [<ffffffff8125788d>] ? trace_hardirqs_off_thunk+0x3a/0x3f
[  184.361025]  [<ffffffff81038c31>] do_page_fault+0xc/0xe
[  184.361025]  [<ffffffff814a1ee2>] page_fault+0x22/0x30
[  184.361025]  [<ffffffff81d52400>] ? do_name+0x112/0x288
[  184.361025]  [<ffffffff8105a2ed>] ? __queue_work+0xec/0x2be
[  184.361025]  [<ffffffff8105a2e8>] ? __queue_work+0xe7/0x2be
[  184.361025]  [<ffffffff8105a5dc>] __queue_delayed_work+0xb5/0x114
[  184.361025]  [<ffffffff8105a966>] queue_delayed_work_on+0x54/0x77
[  184.361025]  [<ffffffff8122cb02>] kblockd_schedule_delayed_work_on+0x1b/0x20
[  184.361025]  [<ffffffff8123891a>] blk_mq_run_hw_queue+0xd5/0xda
[  184.361025]  [<ffffffff81238f8f>] blk_mq_start_hw_queue+0x18/0x1a
[  184.361025]  [<ffffffff81238fc2>] blk_mq_start_hw_queues+0x31/0x38
[  184.361025]  [<ffffffff81239c95>] blk_mq_requeue_work+0xc5/0xd1
[  184.361025]  [<ffffffff8105adc9>] process_one_work+0x282/0x468
[  184.361025]  [<ffffffff8105ac94>] ? process_one_work+0x14d/0x468
[  184.361025]  [<ffffffff8105b22e>] worker_thread+0x250/0x2b5
[  184.361025]  [<ffffffff8105afde>] ? process_scheduled_works+0x2f/0x2f
[  184.361025]  [<ffffffff8105fc59>] kthread+0xba/0xc2
[  184.361025]  [<ffffffff8106567e>] ? finish_task_switch+0x5d/0x122
[  184.361025]  [<ffffffff81069227>] ? preempt_count_sub+0xc4/0xd1
[  184.361025]  [<ffffffff8105fb9f>] ? __init_kthread_worker+0x5a/0x5a
[  184.361025]  [<ffffffff814a016c>] ret_from_fork+0x7c/0xb0
[  184.361025]  [<ffffffff8105fb9f>] ? __init_kthread_worker+0x5a/0x5a


Thanks,
Ming Lei
