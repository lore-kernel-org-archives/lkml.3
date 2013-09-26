Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab3IZTYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 15:24:35 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:48464 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab3IZTXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 15:23:48 -0400
From: Grant Grundler <grundler@chromium.org>
To: Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCH 6/7] mmc: core: protect references to host->areq with host->lock
Date: Thu, 26 Sep 2013 12:22:59 -0700
Message-Id: <1380223380-22451-7-git-send-email-grundler@chromium.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380223380-22451-1-git-send-email-grundler@chromium.org>
References: <1380223380-22451-1-git-send-email-grundler@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Races between host->areq being NULL or not are resulting in mmcqd
hung_task panics. Like this one:

<3>[  240.501202] INFO: task mmcqd/1:85 blocked for more than 120 seconds.
<3>[  240.501213] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
<6>[  240.501223] mmcqd/1         D 80528020     0    85      2 0x00000000
<5>[  240.501254] [<80528020>] (__schedule+0x614/0x780) from [<80528550>] (schedule+0x94/0x98)
<5>[  240.501269] [<80528550>] (schedule+0x94/0x98) from [<80526270>] (schedule_timeout+0x38/0x2d0)
<5>[  240.501284] [<80526270>] (schedule_timeout+0x38/0x2d0) from [<805283a4>] (wait_for_common+0x164/0x1a0)
<5>[  240.501298] [<805283a4>] (wait_for_common+0x164/0x1a0) from [<805284b8>] (wait_for_completion+0x20/0x24)
<5>[  240.501313] [<805284b8>] (wait_for_completion+0x20/0x24) from [<803d7068>] (mmc_wait_for_req_done+0x2c/0x84)
<5>[  240.501327] [<803d7068>] (mmc_wait_for_req_done+0x2c/0x84) from [<803d81c0>] (mmc_start_req+0x60/0x120)
<5>[  240.501342] [<803d81c0>] (mmc_start_req+0x60/0x120) from [<803e402c>] (mmc_blk_issue_rw_rq+0xa0/0x3a8)
<5>[  240.501355] [<803e402c>] (mmc_blk_issue_rw_rq+0xa0/0x3a8) from [<803e4758>] (mmc_blk_issue_rq+0x424/0x478)
<5>[  240.501368] [<803e4758>] (mmc_blk_issue_rq+0x424/0x478) from [<803e587c>] (mmc_queue_thread+0xb0/0x118)
<5>[  240.501382] [<803e587c>] (mmc_queue_thread+0xb0/0x118) from [<8004d61c>] (kthread+0xa8/0xbc)
<5>[  240.501396] [<8004d61c>] (kthread+0xa8/0xbc) from [<8000f1c8>] (kernel_thread_exit+0x0/0x8)
<0>[  240.501407] Kernel panic - not syncing: hung_task: blocked tasks
<5>[  240.501421] [<800150a4>] (unwind_backtrace+0x0/0x114) from [<80521920>] (dump_stack+0x20/0x24)
<5>[  240.501434] [<80521920>] (dump_stack+0x20/0x24) from [<80521a90>] (panic+0xa8/0x1f4)
<5>[  240.501447] [<80521a90>] (panic+0xa8/0x1f4) from [<80086d3c>] (watchdog+0x1f4/0x25c)
<5>[  240.501459] [<80086d3c>] (watchdog+0x1f4/0x25c) from [<8004d61c>] (kthread+0xa8/0xbc)
<5>[  240.501471] [<8004d61c>] (kthread+0xa8/0xbc) from [<8000f1c8>] (kernel_thread_exit+0x0/0x8)

I was able to reproduce the mmcqd "hung task" timeout consistently
with this fio command line on an Exynos5250 system with Toshiba HS200
eMMC running in HS200 mode:
	fio --name=short_randwrite --size=2G --time_based --runtime=3m \
		--readwrite=randwrite --numjobs=2 --bs=4k --norandommap \
		--ioengine=psync --direct=0 --filename=/dev/mmcblk0p5

I believe the key parameters are "--numjobs=2" (or more) and "randwrite"
workload.  Then the completions are happening around the same time as
mmc_start_req() is referencing and/or updating host->areq.

I was NOT able to consistently reproduce the problem on a similar
Exynos 5250 system which had "engineering samples" of Samsung HS200
capable eMMC installed. Just my clue that the timing is different
(and the fio performance numbers are different too).

Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 drivers/mmc/core/core.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 36cfe91..e5a9599 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -529,29 +529,40 @@ struct mmc_async_req *mmc_start_req(struct mmc_host *host,
 {
 	int saved_err = 0;
 	int start_err = 0;
-	struct mmc_async_req *saved_areq = host->areq;
+	struct mmc_async_req *saved_areq;
+	unsigned long flags;
 
-	if (!saved_areq && !areq)
-		/* Nothing to do...some code is polling. */
+	spin_lock_irqsave(&host->lock, flags);
+	saved_areq = host->areq;
+	if (!saved_areq && !areq) {
+		/* Nothing? Code is racing to harvest a completion. */
+		spin_unlock_irqrestore(&host->lock, flags);
 		goto set_error;
+	}
 
 	/* Prepare a new request */
 	if (areq)
 		mmc_pre_req(host, areq->mrq, !saved_areq);
 
 	if (saved_areq) {
+		/* This thread owns this IO (saved_areq) for now. */
+		host->areq = NULL;
+		spin_unlock_irqrestore(&host->lock, flags);
+
 		saved_err = mmc_wait_for_data_req_done(host, saved_areq->mrq,	areq);
 		if (saved_err == MMC_BLK_NEW_REQUEST) {
-			/*
-			 * The previous request was not completed,
-			 * nothing to return
-			 */
+			spin_lock_irqsave(&host->lock, flags);
+			BUG_ON(host->areq != NULL);
+
+			/* Not completed. Don't report it. */
+			host->areq = saved_areq;
 			saved_areq = NULL;
+			saved_err = 0;
+			spin_unlock_irqrestore(&host->lock, flags);
 			goto set_error;
 		}
-		/*
-		 * Check BKOPS urgency for each R1 response
-		 */
+
+		/* Check BKOPS urgency for each R1 response */
 		if (host->card && mmc_card_mmc(host->card) &&
 		    ((mmc_resp_type(saved_areq->mrq->cmd) == MMC_RSP_R1) ||
 		     (mmc_resp_type(saved_areq->mrq->cmd) == MMC_RSP_R1B)) &&
@@ -562,11 +573,12 @@ struct mmc_async_req *mmc_start_req(struct mmc_host *host,
 	/* Don't start something new if previous one failed. */
 	if (!saved_err && areq) {
 		start_err = __mmc_start_data_req(host, areq->mrq);
+
 		/* Cancel a prepared request if it was not started. */
 		if (start_err) {
 			mmc_post_req(host, areq->mrq, -EINVAL);
 			host->areq = NULL;
-		} else 
+		} else
 			host->areq = areq;
 	}
 
-- 
1.8.4

