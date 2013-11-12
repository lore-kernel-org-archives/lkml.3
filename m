Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab3KLDKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 22:10:07 -0500
Received: from mail-qe0-f41.google.com ([209.85.128.41]:33023 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab3KLDKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 22:10:02 -0500
MIME-Version: 1.0
In-Reply-To: <1384273790.21369.15.camel@wxm-ubuntu>
References: <1384273790.21369.15.camel@wxm-ubuntu>
From: Paul Turner <pjt@google.com>
Date: Mon, 11 Nov 2013 19:09:32 -0800
Message-ID: <CAPM31RLMT583XzP=VuToFpyd1irwfRZGQsbJdby7GaUhD4b_GA@mail.gmail.com>
Subject: Re: [PATCH] [sched]: pick the NULL entity caused the panic.
To: "Wang, Xiaoming" <xiaoming.wang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, chuansheng.liu@intel.com,
        dongxing.zhang@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 8:29 AM, Wang, Xiaoming <xiaoming.wang@intel.com> wrote:
> cfs_rq get its group run queue but the value of
> cfs_rq->nr_running maybe zero, which will cause
> the panic in pick_next_task_fair.
> So the evaluated of cfs_rq->nr_running is needed.
>
> [15729.985797] BUG: unable to handle kernel NULL pointer dereference at 00000008
> [15729.993838] IP: [<c15266f1>] rb_next+0x1/0x50
> [15729.998745] *pdpt = 000000002861a001 *pde = 0000000000000000
> [15730.005221] Oops: 0000 [#1] PREEMPT SMP
> [15730.009677] Modules linked in: atomisp_css2400b0_v2 lm3554 ov2722 imx1x5 atmel_mxt_ts
> vxd392 videobuf_vmalloc videobuf_core lm_dump(O) bcm_bt_lpm hdmi_audio bcm4334x(O) kct_daemon(O)
> [15730.028159] CPU: 1 PID: 2510 Comm: mts Tainted: G W O 3.10.16-261326-g88236a2 #1
> [15730.037215] task: e86ff080 ti: e83ac000 task.ti: e83ac000
> [15730.043261] EIP: 0060:[<c15266f1>] EFLAGS: 00010046 CPU: 1
> [15730.049402] EIP is at rb_next+0x1/0x50
> [15730.053602] EAX: 00000008 EBX: f3655950 ECX: 004c090e EDX: 00000000
> [15730.060607] ESI: 00000000 EDI: 00000000 EBP: e83ada44 ESP: e83ada28
> [15730.067623] DS: 007b ES: 007b FS: 00d8 GS: 003b SS: 0068
> [15730.073668] CR0: 80050033 CR2: 00000008 CR3: 28095000 CR4: 001007f0
> [15730.080684] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [15730.087699] DR6: ffff0ff0 DR7: 00000400
> [15730.091994] Stack:
> [15730.094251] e83ada44 c12719f0 004c090e f3655900 e86ff334 f3655900 00000002 e83adacc
> [15730.103086] c1ae384f f3655900 0000254c b7581800 6be38330 0000004e 00000e4e c20d6900
> [15730.111922] f3655950 c20d6900 f3655900 e86ff080 f1d40600 cfcfa794 e83ada90 e83ada8c
> [15730.120754] Call Trace:
> [15730.123502] [<c12719f0>] ? pick_next_task_fair+0xf0/0x130
> [15730.129647] [<c1ae384f>] __schedule+0x11f/0x800
> [15730.134821] [<c12c7421>] ? tracer_tracing_is_on+0x11/0x30
> [15730.140964] [<c12c74ad>] ? tracing_is_on+0xd/0x10
> [15730.146331] [<c1ae8285>] ? sub_preempt_count+0x55/0xe0
> [15730.152185] [<c1266394>] ? finish_task_switch+0x54/0xb0
> [15730.158136] [<c1ae3fa3>] schedule+0x23/0x60
> [15730.162920] [<c1ae16e5>] schedule_timeout+0x165/0x280
> [15730.168676] [<c1ae8285>] ? sub_preempt_count+0x55/0xe0
> [15730.174529] [<c1ae350f>] wait_for_completion+0x6f/0xc0
> [15730.180382] [<c126b3e0>] ? try_to_wake_up+0x250/0x250
> [15730.186139] [<c1255658>] flush_work+0xa8/0x110
> [15730.191214] [<c1253fc0>] ? worker_pool_assign_id+0x40/0x40
> [15730.197457] [<c15c3955>] tty_flush_to_ldisc+0x25/0x30
> [15730.203212] [<c15bde18>] n_tty_poll+0x68/0x180
> [15730.208288] [<c15bddb0>] ? process_echoes+0x2c0/0x2c0
> [15730.214044] [<c15bb2fb>] tty_poll+0x6b/0x90
> [15730.218828] [<c15bddb0>] ? process_echoes+0x2c0/0x2c0
> [15730.224584] [<c1339862>] do_sys_poll+0x202/0x440
> [15730.229856] [<c1ae8285>] ? sub_preempt_count+0x55/0xe0
> [15730.235710] [<c13234a1>] ? kmem_cache_free+0x71/0x180
> [15730.241466] [<c13d2bfa>] ? jbd2_journal_stop+0x25a/0x370
> [15730.247513] [<c13d2bfa>] ? jbd2_journal_stop+0x25a/0x370
> [15730.253561] [<c13bb2df>] ? __ext4_journal_stop+0x5f/0x90
> [15730.259608] [<c139787d>] ? ext4_dirty_inode+0x4d/0x60
> [15730.265364] [<c1ae8285>] ? sub_preempt_count+0x55/0xe0
> [15730.271218] [<c13549ac>] ? generic_write_end+0xac/0x100
> [15730.277168] [<c13bb2df>] ? __ext4_journal_stop+0x5f/0x90
> [15730.283216] [<c1338780>] ? __pollwait+0xd0/0xd0
> [15730.288388] [<c1338780>] ? __pollwait+0xd0/0xd0
> [15730.293561] [<c1338780>] ? __pollwait+0xd0/0xd0
> [15730.298734] [<c1338780>] ? __pollwait+0xd0/0xd0
> [15730.303908] [<c12ecd85>] ? __generic_file_aio_write+0x245/0x470
> [15730.310635] [<c12ed059>] ? generic_file_aio_write+0xa9/0xd0
> [15730.316975] [<c138c910>] ? ext4_file_write+0xc0/0x460
> [15730.322730] [<c1ae8285>] ? sub_preempt_count+0x55/0xe0
> [15730.328583] [<c125d09f>] ? remove_wait_queue+0x3f/0x50
> [15730.334436] [<c1ae8285>] ? sub_preempt_count+0x55/0xe0
> [15730.340289] [<c12615e6>] ? __srcu_read_lock+0x66/0x90
> [15730.346045] [<c1ae8285>] ? sub_preempt_count+0x55/0xe0
> [15730.351899] [<c15407f6>] ? __percpu_counter_add+0x96/0xe0
> [15730.358043] [<c1329df1>] ? __sb_end_write+0x31/0x70
> [15730.363603] [<c13285c5>] ? vfs_write+0x165/0x1c0
> [15730.368874] [<c1339b4a>] SyS_poll+0x5a/0xd0
> [15730.373658] [<c1ae52a8>] syscall_call+0x7/0xb
> [15730.378639] [<c1ae0000>] ? add_sysfs_fw_map_entry+0x2f/0x85
>
> Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>
> Signed-off-by: Zhang Dongxing <dongxing.zhang@intel.com>
> ---
>  kernel/sched/fair.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 7c70201..2d440f9 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3708,7 +3708,7 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
>                 se = pick_next_entity(cfs_rq);
>                 set_next_entity(cfs_rq, se);
>                 cfs_rq = group_cfs_rq(se);
> -       } while (cfs_rq);
> +       } while (cfs_rq && cfs_rq->nr_running);
>
>         p = task_of(se);
>         if (hrtick_enabled(rq))

This can only happen when something else has already corrupted the
rb-tree.  Breaking out here is going to cause you to instead try
treating a group entity as a task, which will crash just as badly.

Could you describe what was being run when this crash occurred?

> --
> 1.7.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
