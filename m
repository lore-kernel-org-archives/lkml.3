Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab3AJUQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 15:16:00 -0500
Received: from 212.199.104.198.static.012.net.il ([212.199.104.198]:36892 "EHLO
	lx-merez.qi.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753217Ab3AJUP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 15:15:57 -0500
From: Maya Erez <merez@codeaurora.org>
To: linux-mmc@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Maya Erez <merez@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 2/3] mmc: allow the host controller to poll for BKOPS completion
Date: Thu, 10 Jan 2013 22:15:20 +0200
Message-Id: <1357848921-9596-3-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to allow the card to perform the required BKOPS and prevent
the need for critical BKOPS, we would like to prevent BKOPS interruption
when possible.
In case the controller calls mmc_suspend_host when runtime suspend is
idle, the BKOPS operation will be interrupted. To prevent this we would
like to prevent the runtime suspend idle until BKOPS is completed.
This patch adds a flag to allow the controller to mark if the polling is
required or not.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/mmc/core/core.c  |   82 +++++++++++++++++++++++++++++++++++++++++++++-
 drivers/mmc/core/mmc.c   |    3 ++
 include/linux/mmc/card.h |    5 +++
 include/linux/mmc/core.h |    1 +
 include/linux/mmc/host.h |    2 +-
 5 files changed, 91 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index c8cb98e..e22584a 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -364,7 +364,15 @@ void mmc_start_bkops(struct mmc_card *card, bool from_exception)
 	}
 	mmc_card_clr_need_bkops(card);
 	mmc_card_set_doing_bkops(card);
-	card->bkops_info.sectors_changed = 0;
+
+	if (card->host->caps2 & MMC_CAP2_POLL_FOR_BKOPS_COMP) {
+		pr_debug("%s: %s: starting the polling thread\n",
+			 mmc_hostname(card->host), __func__);
+		queue_work(system_nrt_wq,
+			   &card->bkops_info.poll_for_completion);
+	} else {
+		card->bkops_info.sectors_changed = 0;
+	}
 
 out:
 	mmc_release_host(card->host);
@@ -372,6 +380,78 @@ out:
 EXPORT_SYMBOL(mmc_start_bkops);
 
 /**
+ * mmc_bkops_completion_polling() - Poll on the card status to
+ * wait for the non-blocking BKOPS completion
+ * @work:	The completion polling work
+ *
+ * The on-going reading of the card status will prevent the card
+ * from getting into suspend while it is in the middle of
+ * performing BKOPS.
+ * Since the non blocking BKOPS can be interrupted by a fetched
+ * request we also check IF mmc_card_doing_bkops in each
+ * iteration.
+ */
+void mmc_bkops_completion_polling(struct work_struct *work)
+{
+	struct mmc_card *card = container_of(work, struct mmc_card,
+			bkops_info.poll_for_completion);
+	unsigned long timeout_jiffies = jiffies +
+		msecs_to_jiffies(BKOPS_COMPLETION_POLLING_TIMEOUT_MS);
+	u32 status;
+	int err;
+
+	/*
+	 * Wait for the BKOPs to complete. Keep reading the status to prevent
+	 * the host from getting into suspend
+	 */
+	do {
+		mmc_claim_host(card->host);
+
+		if (!mmc_card_doing_bkops(card))
+			goto out;
+
+		err = mmc_send_status(card, &status);
+		if (err) {
+			pr_err("%s: error %d requesting status\n",
+			       mmc_hostname(card->host), err);
+			goto out;
+		}
+
+		/*
+		 * Some cards mishandle the status bits, so make sure to check
+		 * both the busy indication and the card state.
+		 */
+		if ((status & R1_READY_FOR_DATA) &&
+		    (R1_CURRENT_STATE(status) != R1_STATE_PRG)) {
+			pr_debug("%s: %s: completed BKOPs, exit polling\n",
+				 mmc_hostname(card->host), __func__);
+			mmc_card_clr_doing_bkops(card);
+			card->bkops_info.sectors_changed = 0;
+			goto out;
+		}
+
+		mmc_release_host(card->host);
+
+		/*
+		 * Sleep before checking the card status again to allow the
+		 * card to complete the BKOPs operation
+		 */
+		msleep(BKOPS_COMPLETION_POLLING_INTERVAL_MS);
+	} while (time_before(jiffies, timeout_jiffies));
+
+	pr_err("%s: %s: exit polling due to timeout, stop bkops\n",
+	       mmc_hostname(card->host), __func__);
+	err = mmc_stop_bkops(card);
+	if (err)
+		pr_err("%s: %s: mmc_stop_bkops failed, err=%d\n",
+			       mmc_hostname(card->host), __func__, err);
+
+	return;
+out:
+	mmc_release_host(card->host);
+}
+
+/**
  * mmc_start_idle_time_bkops() - check if a non urgent BKOPS is
  * needed
  * @work:	The idle time BKOPS work
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 2f25488..61bfb8f 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -1550,6 +1550,9 @@ int mmc_attach_mmc(struct mmc_host *host)
 		INIT_DELAYED_WORK(&host->card->bkops_info.dw,
 				  mmc_start_idle_time_bkops);
 
+		INIT_WORK(&host->card->bkops_info.poll_for_completion,
+			  mmc_bkops_completion_polling);
+
 		/*
 		 * The host controller can set the time to start the BKOPS in
 		 * order to prevent a race condition before starting BKOPS
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 1676506..806a99b 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -222,6 +222,7 @@ struct mmc_part {
  * @size_percentage_to_queue_delayed_work: the changed
  *        percentage of sectors that should issue check for
  *        BKOPS need
+ * @poll_for_completion:	Poll on BKOPS completion
  * @cancel_delayed_work: A flag to indicate if the delayed work
  *        should be cancelled
  * @sectors_changed:  number of  sectors written or
@@ -238,6 +239,10 @@ struct mmc_bkops_info {
  * is idle.
  */
 #define MMC_IDLE_BKOPS_TIME_MS 200
+	struct work_struct	poll_for_completion;
+/* Polling timeout and interval for waiting on non-blocking BKOPs completion */
+#define BKOPS_COMPLETION_POLLING_TIMEOUT_MS (4 * 60 * 1000) /* in ms */
+#define BKOPS_COMPLETION_POLLING_INTERVAL_MS 1000 /* in ms */
 	bool			cancel_delayed_work;
 	unsigned int		sectors_changed;
 /*
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index c6426c6..2b7355a 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -147,6 +147,7 @@ extern int mmc_wait_for_app_cmd(struct mmc_host *, struct mmc_card *,
 extern void mmc_start_bkops(struct mmc_card *card, bool from_exception);
 extern void mmc_start_delayed_bkops(struct mmc_card *card);
 extern void mmc_start_idle_time_bkops(struct work_struct *work);
+extern void mmc_bkops_completion_polling(struct work_struct *work);
 extern int __mmc_switch(struct mmc_card *, u8, u8, u8, unsigned int, bool);
 extern int mmc_switch(struct mmc_card *, u8, u8, u8, unsigned int);
 
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 61a10c1..6a588da 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -258,7 +258,7 @@ struct mmc_host {
 #define MMC_CAP2_HC_ERASE_SZ	(1 << 9)	/* High-capacity erase size */
 #define MMC_CAP2_CD_ACTIVE_HIGH	(1 << 10)	/* Card-detect signal active high */
 #define MMC_CAP2_RO_ACTIVE_HIGH	(1 << 11)	/* Write-protect signal active high */
-
+#define MMC_CAP2_POLL_FOR_BKOPS_COMP (1 << 17)	/* poll for bkops completion */
 	mmc_pm_flag_t		pm_caps;	/* supported pm features */
 
 #ifdef CONFIG_MMC_CLKGATE
-- 
1.7.3.3
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
