Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbaI2QKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:10:54 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:37817 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbaI2QKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:10:51 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: getarunks@gmail.com
Date: Mon, 29 Sep 2014 21:40:50 +0530
X-Google-Sender-Auth: yaLv92nrB_ChzURFi0eYJVbVt_0
Message-ID: <CAKZGPAPS+x2V3Ajj323EUStpWGmZ6taOuovjqA3_kaYXA3T_Ag@mail.gmail.com>
Subject: [Workqueue] crash in process_one_work
From: Arun KS <arunks.linux@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: laijs@cn.fujitsu.com, tj@kernel.org, Silesh C V <saileshcv@gmail.com>,
        Arun KS <getarunks@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun/Lai,

I am seeing the following crash in 3.10.49 kernel.

[ 1133.893817] Unable to handle kernel NULL pointer dereference at
virtual address 00000004
[ 1133.893821] pgd = c0004000
[ 1133.893827] [00000004] *pgd=00000000
[ 1133.893834] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
[ 1133.893841] Modules linked in:
[ 1133.893849] CPU: 2 PID: 5359 Comm: kworker/u8:20 Not tainted
3.10.28-g99b6153-00006-gc32dab7 #1
[ 1133.893859] task: d8c2aa00 ti: e79a4000 task.ti: e79a4000
[ 1133.893873] PC is at process_one_work+0x18/0x448
[ 1133.893878] LR is at process_one_work+0x14/0x448
[ 1133.893887] pc : [<c0135218>]    lr : [<c0135214>]    psr: 400f0093
               sp : e79a5ef8  ip : daf7f100  fp : 00000089
[ 1133.893891] r10: daf7f118  r9 : ee80e820  r8 : ee80e800
[ 1133.893897] r7 : c111872e  r6 : ee80e800  r5 : ed7cf150  r4 : daf7f100
[ 1133.893902] r3 : ffffffe0  r2 : 00000081  r1 : ed7cf150  r0 : 00000000
[ 1133.893908] Flags: nZcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
Segment kernel
[ 1133.893914] Control: 10c5383d  Table: a7dbc06a  DAC: 00000015

Pasting the code snippet of process_one_work function where crash happens,

struct pool_workqueue *pwq = get_work_pwq(work);
struct worker_pool *pool = worker->pool;
bool cpu_intensive = pwq->wq->flags & WQ_CPU_INTENSIVE;

get_work_pwq returned NULL because WORK_STRUCT_PWQ flag was not set on
work_struct->data. And the crash happened while dereferencing the NULL
pointer. There is no NULL check here, which signifies that this
condition must not have happened.

The corresponding work_struct looks likes this,

crash> struct work_struct ed7cf150
struct work_struct {
  data = {
    counter = 0xffffffe0
  },
  entry = {
    next = 0xed7cf154,
    prev = 0xed7cf154
  },
  func = 0xc0140ac4 <async_run_entry_fn>
}

The value of data is 0xffffffe0, which is basically the value after an
INIT_WORK() or WORK_DATA_INIT().
This can happen if a driver calls INIT_WORK on same struct work again
after queuing it.

>From the above details of the work_struct shows that the work is
queued from kernel/async.c. async_schedule dynamically allocates the
work_struct and queues it to system_unbonded_wq. And possibility of
calling INIT_WORK on same work is not there.

After inspecting ramdump for async_entry structure in kernel/async.c

crash> struct async_entry ed7cf140
struct async_entry {
  domain_list = {
    next = 0xed7cf140,
    prev = 0xed7cf140
  },
  global_list = {
    next = 0xed7cf148,
    prev = 0xed7cf148
  },
  work = {
    data = {
      counter = 0xffffffe0
    },
    entry = {
      next = 0xed7cf154,
      prev = 0xed7cf154
    },
    func = 0xc0140ac4 <async_run_entry_fn>
  },
  cookie = 0x263e5,
  func = 0xc074dda0 <dapm_post_sequence_async>,
  data = 0xed48432c,
  domain = 0xe5457dec
}

the func points to dapm_post_sequence_async. and you can see the
domain_list and global_list is empty. Which shows that the work has
finished execution and there is no pending execution in async.

But how come this struct work was with work queue data structures?
Is there any corner case in work queue which can miss unlinking the
struct_work from pool_workqueue after executing them?

I really appreciate your inputs/pointers.
Please let me know if you want any more information from the crashed system.

Thanks,
Arun
