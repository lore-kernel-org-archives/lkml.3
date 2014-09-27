Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaI0FUy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 01:20:54 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44]:51305 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaI0FUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 01:20:52 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: getarunks@gmail.com
Date: Sat, 27 Sep 2014 10:50:52 +0530
X-Google-Sender-Auth: TGZbVtEMRPipocpOVxcqd8zCL1o
Message-ID: <CAKZGPANQ7cB-M8vyyUAbVdae6Cjy7ydHX0MoNmpkvVDg1kmKrA@mail.gmail.com>
Subject: [3.10.49 stable kernel] crash in process_one_work
From: Arun KS <arunks.linux@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tj@kernel.org
Cc: Arun KS <getarunks@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,

I m seen the following crash in 3.10 kernel workqueue.

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


struct pool_workqueue *pwq = get_work_pwq(work);
get_work_pwq returned NULL because WORK_STRUCT_PWQ was not set on
work_struct->data.

The work_struct looks likes this,

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


The value of data is 0xffffffe0. I can think of only two reason for
this value in data.
1) driver calls INIT_WORK on same worker again after queuing.
2) workqueue subsytem called clear_work_data(work);

>From the above details of the work_struct shows that the work is
queued from kernel/asyc.c.
async_schedule dynamically allocates the work_struct and possibility
of calling INIT_WORK is not there.

I m suspecting the second reason.

Your inputs are really appreciated.
Please let me know if you want any more information from the crashed system.

Thanks,
Arun
