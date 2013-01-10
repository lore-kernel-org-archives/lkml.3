Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab3AJUQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 15:16:08 -0500
Received: from 212.199.104.198.static.012.net.il ([212.199.104.198]:36913 "EHLO
	lx-merez.qi.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753217Ab3AJUQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 15:16:06 -0500
From: Maya Erez <merez@codeaurora.org>
To: linux-mmc@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Maya Erez <merez@codeaurora.org>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 3/3] mmc: core: Add MMC BKOPS statistics and debugfs ability to print them
Date: Thu, 10 Jan 2013 22:15:21 +0200
Message-Id: <1357848921-9596-4-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKOPS statistics are used for BKOPS unit tests and APT tests
to determine test success or failure.
the BKOPS statistics provide the following information:
The number of times BKOPS were issued according to it's severity level
The number of times BKOPS were interrupted by HPI.
The number of times the host went into suspend

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
---
 drivers/mmc/core/bus.c     |    2 +
 drivers/mmc/core/core.c    |   53 ++++++++++++++++++++
 drivers/mmc/core/debugfs.c |  114 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mmc/card.h   |   12 +++++
 include/linux/mmc/core.h   |    2 +
 5 files changed, 183 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index 420cb67..47f883b 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -250,6 +250,8 @@ struct mmc_card *mmc_alloc_card(struct mmc_host *host, struct device_type *type)
 	card->dev.release = mmc_release_card;
 	card->dev.type = type;
 
+	spin_lock_init(&card->bkops_info.bkops_stats.lock);
+
 	return card;
 }
 
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index e22584a..7405243 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -79,6 +79,30 @@ MODULE_PARM_DESC(
 	removable,
 	"MMC/SD cards are removable and may be removed during suspend");
 
+#define MMC_UPDATE_BKOPS_STATS_HPI(stats)	\
+	do {					\
+		spin_lock(&stats.lock);		\
+		if (stats.enabled)		\
+			stats.hpi++;		\
+		spin_unlock(&stats.lock);	\
+	} while (0);
+#define MMC_UPDATE_BKOPS_STATS_SUSPEND(stats)	\
+	do {					\
+		spin_lock(&stats.lock);		\
+		if (stats.enabled)		\
+			stats.suspend++;	\
+		spin_unlock(&stats.lock);	\
+	} while (0);
+#define MMC_UPDATE_STATS_BKOPS_SEVERITY_LEVEL(stats, level)		\
+	do {								\
+		if (level <= 0 || level > BKOPS_NUM_OF_SEVERITY_LEVELS)	\
+			break;						\
+		spin_lock(&stats.lock);					\
+		if (stats.enabled)					\
+			stats.bkops_level[level-1]++;			\
+		spin_unlock(&stats.lock);				\
+	} while (0);
+
 /*
  * Internal function. Schedule delayed work in the MMC work queue.
  */
@@ -255,6 +279,29 @@ mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
 	host->ops->request(host, mrq);
 }
 
+void mmc_blk_init_bkops_statistics(struct mmc_card *card)
+{
+	int i;
+	struct mmc_bkops_stats *bkops_stats;
+
+	if (!card)
+		return;
+
+	bkops_stats = &card->bkops_info.bkops_stats;
+
+	spin_lock(&bkops_stats->lock);
+
+	for (i = 0 ; i < BKOPS_NUM_OF_SEVERITY_LEVELS ; ++i)
+		bkops_stats->bkops_level[i] = 0;
+
+	bkops_stats->suspend = 0;
+	bkops_stats->hpi = 0;
+	bkops_stats->enabled = true;
+
+	spin_unlock(&bkops_stats->lock);
+}
+EXPORT_SYMBOL(mmc_blk_init_bkops_statistics);
+
 /**
  * mmc_start_delayed_bkops() - Start a delayed work to check for
  *      the need of non urgent BKOPS
@@ -362,6 +409,8 @@ void mmc_start_bkops(struct mmc_card *card, bool from_exception)
 			mmc_hostname(card->host), err);
 		goto out;
 	}
+	MMC_UPDATE_STATS_BKOPS_SEVERITY_LEVEL(card->bkops_info.bkops_stats,
+					card->ext_csd.raw_bkops_status);
 	mmc_card_clr_need_bkops(card);
 	mmc_card_set_doing_bkops(card);
 
@@ -762,6 +811,8 @@ int mmc_stop_bkops(struct mmc_card *card)
 		err = 0;
 	}
 
+	MMC_UPDATE_BKOPS_STATS_HPI(card->bkops_info.bkops_stats);
+
 out:
 	return err;
 }
@@ -2614,6 +2665,8 @@ int mmc_suspend_host(struct mmc_host *host)
 				err = mmc_stop_bkops(host->card);
 				if (err)
 					goto out;
+				MMC_UPDATE_BKOPS_STATS_SUSPEND(host->
+						card->bkops_info.bkops_stats);
 			}
 			err = host->bus_ops->suspend(host);
 		}
diff --git a/drivers/mmc/core/debugfs.c b/drivers/mmc/core/debugfs.c
index 35c2f85..30738cb 100644
--- a/drivers/mmc/core/debugfs.c
+++ b/drivers/mmc/core/debugfs.c
@@ -334,6 +334,114 @@ static const struct file_operations mmc_dbg_ext_csd_fops = {
 	.llseek		= default_llseek,
 };
 
+static int mmc_bkops_stats_open(struct inode *inode, struct file *filp)
+{
+	struct mmc_card *card = inode->i_private;
+
+	filp->private_data = card;
+
+	card->bkops_info.bkops_stats.print_stats = 1;
+	return 0;
+}
+
+#define TEMP_BUF_SIZE 256
+static ssize_t mmc_bkops_stats_read(struct file *filp, char __user *ubuf,
+				     size_t cnt, loff_t *ppos)
+{
+	struct mmc_card *card = filp->private_data;
+	struct mmc_bkops_stats *bkops_stats;
+	int i;
+	char *temp_buf;
+
+	if (!card)
+		return cnt;
+
+	bkops_stats = &card->bkops_info.bkops_stats;
+
+	if (!bkops_stats->print_stats)
+		return 0;
+
+	if (!bkops_stats->enabled) {
+		pr_info("%s: bkops statistics are disabled\n",
+			 mmc_hostname(card->host));
+		goto exit;
+	}
+
+	temp_buf = kmalloc(TEMP_BUF_SIZE, GFP_KERNEL);
+	if (!temp_buf)
+		goto exit;
+
+	spin_lock(&bkops_stats->lock);
+
+	memset(ubuf, 0, cnt);
+
+	snprintf(temp_buf, TEMP_BUF_SIZE, "%s: bkops statistics:\n",
+		mmc_hostname(card->host));
+	strlcat(ubuf, temp_buf, cnt);
+
+	for (i = 0 ; i < BKOPS_NUM_OF_SEVERITY_LEVELS ; ++i) {
+		snprintf(temp_buf, TEMP_BUF_SIZE,
+			 "%s: BKOPS: due to level %d: %u\n",
+		 mmc_hostname(card->host), i, bkops_stats->bkops_level[i]);
+		strlcat(ubuf, temp_buf, cnt);
+	}
+
+	snprintf(temp_buf, TEMP_BUF_SIZE,
+		 "%s: BKOPS: stopped due to HPI: %u\n",
+		 mmc_hostname(card->host), bkops_stats->hpi);
+	strlcat(ubuf, temp_buf, cnt);
+
+	snprintf(temp_buf, TEMP_BUF_SIZE,
+		 "%s: BKOPS: how many time host was suspended: %u\n",
+		 mmc_hostname(card->host), bkops_stats->suspend);
+	strlcat(ubuf, temp_buf, cnt);
+
+	spin_unlock(&bkops_stats->lock);
+
+	kfree(temp_buf);
+
+	pr_info("%s", ubuf);
+
+exit:
+	if (bkops_stats->print_stats == 1) {
+		bkops_stats->print_stats = 0;
+		return strnlen(ubuf, cnt);
+	}
+
+	return 0;
+}
+
+static ssize_t mmc_bkops_stats_write(struct file *filp,
+				      const char __user *ubuf, size_t cnt,
+				      loff_t *ppos)
+{
+	struct mmc_card *card = filp->private_data;
+	int value;
+	struct mmc_bkops_stats *bkops_stats;
+
+	if (!card)
+		return cnt;
+
+	bkops_stats = &card->bkops_info.bkops_stats;
+
+	sscanf(ubuf, "%d", &value);
+	if (value) {
+		mmc_blk_init_bkops_statistics(card);
+	} else {
+		spin_lock(&bkops_stats->lock);
+		bkops_stats->enabled = false;
+		spin_unlock(&bkops_stats->lock);
+	}
+
+	return cnt;
+}
+
+static const struct file_operations mmc_dbg_bkops_stats_fops = {
+	.open		= mmc_bkops_stats_open,
+	.read		= mmc_bkops_stats_read,
+	.write		= mmc_bkops_stats_write,
+};
+
 void mmc_add_card_debugfs(struct mmc_card *card)
 {
 	struct mmc_host	*host = card->host;
@@ -366,6 +474,12 @@ void mmc_add_card_debugfs(struct mmc_card *card)
 					&mmc_dbg_ext_csd_fops))
 			goto err;
 
+	if (mmc_card_mmc(card) && (card->ext_csd.rev >= 5) &&
+	    card->ext_csd.bkops_en)
+		if (!debugfs_create_file("bkops_stats", S_IRUSR, root, card,
+					 &mmc_dbg_bkops_stats_fops))
+			goto err;
+
 	return;
 
 err:
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 806a99b..cffd7e9 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -210,6 +210,16 @@ struct mmc_part {
 #define MMC_BLK_DATA_AREA_RPMB	(1<<3)
 };
 
+#define BKOPS_NUM_OF_SEVERITY_LEVELS	3
+struct mmc_bkops_stats {
+	spinlock_t		lock;
+	bool			enabled;
+	unsigned int		hpi;    /* hpi issued   */
+	unsigned int		suspend;/* card sleed issued */
+	bool			print_stats;
+	unsigned int bkops_level[BKOPS_NUM_OF_SEVERITY_LEVELS];
+};
+
 /**
  * struct mmc_bkops_info - BKOPS data
  * @dw:	Idle time bkops delayed work
@@ -222,6 +232,7 @@ struct mmc_part {
  * @size_percentage_to_queue_delayed_work: the changed
  *        percentage of sectors that should issue check for
  *        BKOPS need
+ * @bkops_stats: BKOPS statistics
  * @poll_for_completion:	Poll on BKOPS completion
  * @cancel_delayed_work: A flag to indicate if the delayed work
  *        should be cancelled
@@ -234,6 +245,7 @@ struct mmc_bkops_info {
 	unsigned int		delay_ms;
 	unsigned int		min_sectors_to_queue_delayed_work;
 	unsigned int		size_percentage_to_queue_delayed_work;
+	struct mmc_bkops_stats  bkops_stats;
 /*
  * A default time for checking the need for non urgent BKOPS once mmcqd
  * is idle.
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index 2b7355a..1e2266b 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -190,6 +190,8 @@ extern int mmc_flush_cache(struct mmc_card *);
 
 extern int mmc_detect_card_removed(struct mmc_host *host);
 
+extern void mmc_blk_init_bkops_statistics(struct mmc_card *card);
+
 /**
  *	mmc_claim_host - exclusively claim a host
  *	@host: mmc host to claim
-- 
1.7.3.3
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
