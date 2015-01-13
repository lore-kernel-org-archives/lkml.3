Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbbAMGly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 01:41:54 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:64065 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557AbbAMGlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 01:41:52 -0500
From: Jialing Fu <jlfu@marvell.com>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Konstantin Dorfman <kdorfman@codeaurora.org>,
        Seungwon Jeon <tgih.jun@samsung.com>
CC: Jialing Fu <jlfu@marvell.com>
Subject: [PATCH] mmc: core: fix race condition in mmc_wait_data_done
Date: Tue, 13 Jan 2015 14:42:46 +0800
Message-ID: <1421131366-29685-1-git-send-email-jlfu@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-13_03:2015-01-12,2015-01-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1501130070
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following panic is captured in ker3.14, but the issue still exists
in latest kernel.
---------------------------------------------------------------------
[   20.738217] c0 3136 (Compiler) Unable to handle kernel NULL pointer dereference
at virtual address 00000578
......
[   20.738499] c0 3136 (Compiler) PC is at _raw_spin_lock_irqsave+0x24/0x60
[   20.738527] c0 3136 (Compiler) LR is at _raw_spin_lock_irqsave+0x20/0x60
[   20.740134] c0 3136 (Compiler) Call trace:
[   20.740165] c0 3136 (Compiler) [<ffffffc0008ee900>] _raw_spin_lock_irqsave+0x24/0x60
[   20.740200] c0 3136 (Compiler) [<ffffffc0000dd024>] __wake_up+0x1c/0x54
[   20.740230] c0 3136 (Compiler) [<ffffffc000639414>] mmc_wait_data_done+0x28/0x34
[   20.740262] c0 3136 (Compiler) [<ffffffc0006391a0>] mmc_request_done+0xa4/0x220
[   20.740314] c0 3136 (Compiler) [<ffffffc000656894>] sdhci_tasklet_finish+0xac/0x264
[   20.740352] c0 3136 (Compiler) [<ffffffc0000a2b58>] tasklet_action+0xa0/0x158
[   20.740382] c0 3136 (Compiler) [<ffffffc0000a2078>] __do_softirq+0x10c/0x2e4
[   20.740411] c0 3136 (Compiler) [<ffffffc0000a24bc>] irq_exit+0x8c/0xc0
[   20.740439] c0 3136 (Compiler) [<ffffffc00008489c>] handle_IRQ+0x48/0xac
[   20.740469] c0 3136 (Compiler) [<ffffffc000081428>] gic_handle_irq+0x38/0x7c
----------------------------------------------------------------------

Because in SMP, "mrq" has race condition between below two paths:
path1: CPU0: <tasklet context>
  static void mmc_wait_data_done(struct mmc_request *mrq)
  {
    mrq->host->context_info.is_done_rcv = true;
    //
    // If CPU0 has just finished "is_done_rcv = true" in path1, and at
    // this moment, IRQ or ICache line missing happens in CPU0.
    // What happens in CPU1 (path2)?
    //
    // If the mmcqd thread in CPU1(path2) hasn't entered to sleep mode:
    // path2 would have chance to break from wait_event_interruptible
    // in mmc_wait_for_data_req_done and continue to run for next
    // mmc_request (mmc_blk_rw_rq_prep).
    //
    // Within mmc_blk_rq_prep, mrq is cleared to 0.
    // If below line still gets host from "mrq" as the result of
    // compiler, the panic happens as we traced.
    wake_up_interruptible(&mrq->host->context_info.wait);
  }

path2: CPU1: <The mmcqd thread runs mmc_queue_thread>
 static int mmc_wait_for_data_req_done(...
 {
    ...
    while (1) {
          wait_event_interruptible(context_info->wait,
                  (context_info->is_done_rcv ||
                   context_info->is_new_req));

  static void mmc_blk_rw_rq_prep(...
  {
    ...
    memset(brq, 0, sizeof(struct mmc_blk_request));

This issue happens very coincidentally; however adding mdelay(1) in
mmc_wait_data_done as below could duplicate it easily.
  static void mmc_wait_data_done(struct mmc_request *mrq)
  {
    mrq->host->context_info.is_done_rcv = true;
    mdelay(1);
    wake_up_interruptible(&mrq->host->context_info.wait);
  }
At runtime, IRQ or ICache line missing may just happen at the same place
of the mdelay(1).

This patch gets the mmc_context_info at the beginning of function, it can
avoid this race condition.

Signed-off-by: Jialing Fu <jlfu@marvell.com>
---
 drivers/mmc/core/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 9584bff..f08c9a8 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -326,8 +326,10 @@ EXPORT_SYMBOL(mmc_start_bkops);
  */
 static void mmc_wait_data_done(struct mmc_request *mrq)
 {
-	mrq->host->context_info.is_done_rcv = true;
-	wake_up_interruptible(&mrq->host->context_info.wait);
+	struct mmc_context_info *context_info = &mrq->host->context_info;
+
+	context_info->is_done_rcv = true;
+	wake_up_interruptible(&context_info->wait);
 }
 
 static void mmc_wait_done(struct mmc_request *mrq)
-- 
1.9.1

