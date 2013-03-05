Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176Ab3CEHbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 02:31:48 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:44186 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab3CEHbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 02:31:47 -0500
MIME-Version: 1.0
Date: Tue, 5 Mar 2013 15:31:45 +0800
Message-ID: <CALZhoSR0+SzPLHzJafmny=o8PJ2d7MaH9N6_6s0QZ_oCQm43Xg@mail.gmail.com>
Subject: workqueue panic in 3.4 kernel
From: Lei Wen <adrian.wenl@gmail.com>
To: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        leiwen@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

We met one panic issue related workqueue based over 3.4.5 Linux kernel.

Panic log as:
[153587.035369] Unable to handle kernel NULL pointer dereference at
virtual address 00000004
[153587.043731] pgd = e1e74000
[153587.046691] [00000004] *pgd=00000000
[153587.050567] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
[153587.056152] Modules linked in: hwmap(O) cidatattydev(O) gs_diag(O)
diag(O) gs_modem(O) ccinetdev(O) cci_datastub(O) citty(O) msocketk(O)
smsmdtv seh(O) cploaddev(O) blcr(O) blcr_imports(O) geu(O) galcore(O)
[153587.076416] CPU: 0    Tainted: G           O  (3.4.5+ #1)
[153587.082092] PC is at delayed_work_timer_fn+0x1c/0x28
[153587.087249] LR is at delayed_work_timer_fn+0x18/0x28
[153587.092468] pc : [<c014c7bc>]    lr : [<c014c7b8>]    psr: 20000113
[153587.092468] sp : e1e3bf00  ip : 00000001  fp : 0000000a
[153587.104400] r10: 00000001  r9 : 578914dc  r8 : c014c7a0
[153587.109832] r7 : 00000101  r6 : bf03d554  r5 : 00000000  r4 : bf03d544
[153587.116638] r3 : 00000101  r2 : bf03d544  r1 : c1a0b27c  r0 : 00000000
[153587.123352] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM
Segment user
[153587.130737] Control: 10c53c7d  Table: 21e7404a  DAC: 00000015
[153587.611328] [<c014c7bc>] (delayed_work_timer_fn+0x1c/0x28) from
[<c014185c>] (run_timer_softirq+0x260/0x384)
[153587.621368] [<c014185c>] (run_timer_softirq+0x260/0x384) from
[<c013abfc>] (__do_softirq+0x11c/0x244)
[153587.630828] [<c013abfc>] (__do_softirq+0x11c/0x244) from
[<c013b144>] (irq_exit+0x44/0x98)
[153587.639373] [<c013b144>] (irq_exit+0x44/0x98) from [<c0113ca0>]
(handle_IRQ+0x7c/0xb8)
[153587.647583] [<c0113ca0>] (handle_IRQ+0x7c/0xb8) from [<c01084ac>]
(gic_handle_irq+0x34/0x58)
[153587.656188] [<c01084ac>] (gic_handle_irq+0x34/0x58) from
[<c0112b3c>] (__irq_usr+0x3c/0x60)

With checking memory,  we find work->data becomes 0x300, when it try
to call get_work_cwq
in delayed_work_timer_fn. Thus cwq becomes NULL before calls __queue_work.
So it is reasonable kernel get panic when it try to access wq with cwq->wq.

To fix it, we try to backport below patches:
commit 60c057bca22285efefbba033624763a778f243bf
Author: Lai Jiangshan <laijs@cn.fujitsu.com>
Date:   Wed Feb 6 18:04:53 2013 -0800

    workqueue: add delayed_work->wq to simplify reentrancy handling

commit 1265057fa02c7bed3b6d9ddc8a2048065a370364
Author: Tejun Heo <tj@kernel.org>
Date:   Wed Aug 8 09:38:42 2012 -0700

    workqueue: fix CPU binding of flush_delayed_work[_sync]()

And add below change to make sure __cancel_work_timer cannot preempt
between run_timer_softirq and delayed_work_timer_fn.
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index bf4888c..0e9f77c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2627,7 +2627,7 @@ static bool __cancel_work_timer(struct work_struct *work,
                ret = (timer && likely(del_timer(timer)));
                if (!ret)
                        ret = try_to_grab_pending(work);
-               wait_on_work(work);
+               flush_work(work);
        } while (unlikely(ret < 0));

        clear_work_data(work);

Do you think this fix is enough? And add flush_work directly in
__cancel_work_timer is ok for
the fix?

Thanks,
Lei
