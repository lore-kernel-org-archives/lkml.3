Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933641Ab3D3U3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 16:29:14 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27855 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933300Ab3D3U3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 16:29:11 -0400
X-IronPort-AV: E=Sophos;i="4.87,582,1363158000"; 
   d="scan'208";a="42932761"
Message-ID: <89b3f0806c8d715774708917a97112ae.squirrel@www.codeaurora.org>
In-Reply-To: <1366661792-28710-1-git-send-email-merez@codeaurora.org>
References: <n> <1366661792-28710-1-git-send-email-merez@codeaurora.org>
Date: Tue, 30 Apr 2013 13:29:10 -0700
Subject: Re: [PATCH] mmc: block: Add MMC write packing statistics
From: merez@codeaurora.org
To: "Maya Erez" <merez@codeaurora.org>
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "Maya Erez" <merez@codeaurora.org>,
        "open list" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Can we push this change to kernel-3.10?

Thanks,
Maya
> The write packing statistics are used for debug purposes, in order
> to get the amount of packing in different scenarios.
> The statistics also include the reason for stopping the creation of
> the packed request.
>
> Signed-off-by: Maya Erez <merez@codeaurora.org>
>
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index e12a03c..2dc48ae 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -64,6 +64,11 @@ MODULE_ALIAS("mmc:block");
>  				  (rq_data_dir(req) == WRITE))
>  #define PACKED_CMD_VER	0x01
>  #define PACKED_CMD_WR	0x02
> +#define MMC_BLK_UPDATE_STOP_REASON(stats, reason)			\
> +	do {								\
> +		if (stats->enabled)					\
> +			stats->pack_stop_reason[reason]++;		\
> +	} while (0)
>
>  static DEFINE_MUTEX(block_mutex);
>
> @@ -1405,6 +1410,35 @@ static inline u8 mmc_calc_packed_hdr_segs(struct
> request_queue *q,
>  	return nr_segs;
>  }
>
> +struct mmc_wr_pack_stats *mmc_blk_get_packed_statistics(struct mmc_card
> *card)
> +{
> +	if (!card)
> +		return NULL;
> +
> +	return &card->wr_pack_stats;
> +}
> +EXPORT_SYMBOL(mmc_blk_get_packed_statistics);
> +
> +void mmc_blk_init_packed_statistics(struct mmc_card *card)
> +{
> +	int max_num_of_packed_reqs = 0;
> +
> +	if (!card || !card->wr_pack_stats.packing_events)
> +		return;
> +
> +	max_num_of_packed_reqs = card->ext_csd.max_packed_writes;
> +
> +	spin_lock(&card->wr_pack_stats.lock);
> +	memset(card->wr_pack_stats.packing_events, 0,
> +		(max_num_of_packed_reqs + 1) *
> +	       sizeof(*card->wr_pack_stats.packing_events));
> +	memset(&card->wr_pack_stats.pack_stop_reason, 0,
> +		sizeof(card->wr_pack_stats.pack_stop_reason));
> +	card->wr_pack_stats.enabled = true;
> +	spin_unlock(&card->wr_pack_stats.lock);
> +}
> +EXPORT_SYMBOL(mmc_blk_init_packed_statistics);
> +
>  static u8 mmc_blk_prep_packed_list(struct mmc_queue *mq, struct request
> *req)
>  {
>  	struct request_queue *q = mq->queue;
> @@ -1418,6 +1452,7 @@ static u8 mmc_blk_prep_packed_list(struct mmc_queue
> *mq, struct request *req)
>  	bool put_back = true;
>  	u8 max_packed_rw = 0;
>  	u8 reqs = 0;
> +	struct mmc_wr_pack_stats *stats = &card->wr_pack_stats;
>
>  	if (!(md->flags & MMC_BLK_PACKED_CMD))
>  		goto no_packed;
> @@ -1464,31 +1499,44 @@ static u8 mmc_blk_prep_packed_list(struct
> mmc_queue *mq, struct request *req)
>  		spin_unlock_irq(q->queue_lock);
>  		if (!next) {
>  			put_back = false;
> +			MMC_BLK_UPDATE_STOP_REASON(stats, EMPTY_QUEUE);
>  			break;
>  		}
>
>  		if (mmc_large_sector(card) &&
> -		    !IS_ALIGNED(blk_rq_sectors(next), 8))
> +		    !IS_ALIGNED(blk_rq_sectors(next), 8)) {
> +			MMC_BLK_UPDATE_STOP_REASON(stats, LARGE_SEC_ALIGN);
>  			break;
> +		}
>
>  		if (next->cmd_flags & REQ_DISCARD ||
> -		    next->cmd_flags & REQ_FLUSH)
> +		    next->cmd_flags & REQ_FLUSH) {
> +			MMC_BLK_UPDATE_STOP_REASON(stats, FLUSH_OR_DISCARD);
>  			break;
> +		}
>
> -		if (rq_data_dir(cur) != rq_data_dir(next))
> +		if (rq_data_dir(cur) != rq_data_dir(next)) {
> +			MMC_BLK_UPDATE_STOP_REASON(stats, WRONG_DATA_DIR);
>  			break;
> +		}
>
>  		if (mmc_req_rel_wr(next) &&
> -		    (md->flags & MMC_BLK_REL_WR) && !en_rel_wr)
> +		    (md->flags & MMC_BLK_REL_WR) && !en_rel_wr) {
> +			MMC_BLK_UPDATE_STOP_REASON(stats, REL_WRITE);
>  			break;
> +		}
>
>  		req_sectors += blk_rq_sectors(next);
> -		if (req_sectors > max_blk_count)
> +		if (req_sectors > max_blk_count) {
> +			MMC_BLK_UPDATE_STOP_REASON(stats, EXCEEDS_SECTORS);
>  			break;
> +		}
>
>  		phys_segments +=  next->nr_phys_segments;
> -		if (phys_segments > max_phys_segs)
> +		if (phys_segments > max_phys_segs) {
> +			MMC_BLK_UPDATE_STOP_REASON(stats, EXCEEDS_SEGMENTS);
>  			break;
> +		}
>
>  		list_add_tail(&next->queuelist, &mqrq->packed->list);
>  		cur = next;
> @@ -1501,6 +1549,15 @@ static u8 mmc_blk_prep_packed_list(struct mmc_queue
> *mq, struct request *req)
>  		spin_unlock_irq(q->queue_lock);
>  	}
>
> +	if (stats->enabled) {
> +		if (reqs + 1 <= card->ext_csd.max_packed_writes)
> +			stats->packing_events[reqs + 1]++;
> +		if (reqs + 1 == max_packed_rw)
> +			MMC_BLK_UPDATE_STOP_REASON(stats, THRESHOLD);
> +	}
> +
> +	spin_unlock(&stats->lock);
> +
>  	if (reqs > 0) {
>  		list_add(&req->queuelist, &mqrq->packed->list);
>  		mqrq->packed->nr_entries = ++reqs;
> diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
> index e219c97..4417bf1 100644
> --- a/drivers/mmc/core/bus.c
> +++ b/drivers/mmc/core/bus.c
> @@ -250,6 +250,8 @@ struct mmc_card *mmc_alloc_card(struct mmc_host *host,
> struct device_type *type)
>  	card->dev.release = mmc_release_card;
>  	card->dev.type = type;
>
> +	spin_lock_init(&card->wr_pack_stats.lock);
> +
>  	return card;
>  }
>
> @@ -353,6 +355,8 @@ void mmc_remove_card(struct mmc_card *card)
>  		device_del(&card->dev);
>  	}
>
> +	kfree(card->wr_pack_stats.packing_events);
> +
>  	put_device(&card->dev);
>  }
>
> diff --git a/drivers/mmc/core/debugfs.c b/drivers/mmc/core/debugfs.c
> index 35c2f85..054839d 100644
> --- a/drivers/mmc/core/debugfs.c
> +++ b/drivers/mmc/core/debugfs.c
> @@ -334,6 +334,176 @@ static const struct file_operations
> mmc_dbg_ext_csd_fops = {
>  	.llseek		= default_llseek,
>  };
>
> +static int mmc_wr_pack_stats_open(struct inode *inode, struct file *filp)
> +{
> +	struct mmc_card *card = inode->i_private;
> +
> +	filp->private_data = card;
> +	card->wr_pack_stats.print_in_read = 1;
> +	return 0;
> +}
> +
> +#define TEMP_BUF_SIZE 256
> +static ssize_t mmc_wr_pack_stats_read(struct file *filp, char __user
> *ubuf,
> +				size_t cnt, loff_t *ppos)
> +{
> +	struct mmc_card *card = filp->private_data;
> +	struct mmc_wr_pack_stats *pack_stats;
> +	int i;
> +	int max_num_of_packed_reqs = 0;
> +	char *temp_buf;
> +
> +	if (!card)
> +		return cnt;
> +
> +	if (!card->wr_pack_stats.print_in_read)
> +		return 0;
> +
> +	if (!card->wr_pack_stats.enabled) {
> +		pr_info("%s: write packing statistics are disabled\n",
> +			 mmc_hostname(card->host));
> +		goto exit;
> +	}
> +
> +	pack_stats = &card->wr_pack_stats;
> +
> +	if (!pack_stats->packing_events) {
> +		pr_info("%s: NULL packing_events\n", mmc_hostname(card->host));
> +		goto exit;
> +	}
> +
> +	max_num_of_packed_reqs = card->ext_csd.max_packed_writes;
> +
> +	temp_buf = kmalloc(TEMP_BUF_SIZE, GFP_KERNEL);
> +	if (!temp_buf)
> +		goto exit;
> +
> +	spin_lock(&pack_stats->lock);
> +
> +	snprintf(temp_buf, TEMP_BUF_SIZE, "%s: write packing statistics:\n",
> +		mmc_hostname(card->host));
> +	strlcat(ubuf, temp_buf, cnt);
> +
> +	/*
> +	 * The statistics are kept in the index that equals the number of
> +	 * packed requests. Therefore we need to print the values in indexes
> +	 * 1 to max_num_of_packed_reqs.
> +	 */
> +	for (i = 1 ; i <= max_num_of_packed_reqs ; ++i) {
> +		if (pack_stats->packing_events[i]) {
> +			snprintf(temp_buf, TEMP_BUF_SIZE,
> +				 "%s: Packed %d reqs - %d times\n",
> +				mmc_hostname(card->host), i,
> +				pack_stats->packing_events[i]);
> +			strlcat(ubuf, temp_buf, cnt);
> +		}
> +	}
> +
> +	snprintf(temp_buf, TEMP_BUF_SIZE,
> +		 "%s: stopped packing due to the following reasons:\n",
> +		 mmc_hostname(card->host));
> +	strlcat(ubuf, temp_buf, cnt);
> +
> +	if (pack_stats->pack_stop_reason[EXCEEDS_SEGMENTS]) {
> +		snprintf(temp_buf, TEMP_BUF_SIZE,
> +			 "%s: %d times: exceed max num of segments\n",
> +			 mmc_hostname(card->host),
> +			 pack_stats->pack_stop_reason[EXCEEDS_SEGMENTS]);
> +		strlcat(ubuf, temp_buf, cnt);
> +	}
> +	if (pack_stats->pack_stop_reason[EXCEEDS_SECTORS]) {
> +		snprintf(temp_buf, TEMP_BUF_SIZE,
> +			 "%s: %d times: exceed max num of sectors\n",
> +			mmc_hostname(card->host),
> +			pack_stats->pack_stop_reason[EXCEEDS_SECTORS]);
> +		strlcat(ubuf, temp_buf, cnt);
> +	}
> +	if (pack_stats->pack_stop_reason[WRONG_DATA_DIR]) {
> +		snprintf(temp_buf, TEMP_BUF_SIZE,
> +			 "%s: %d times: wrong data direction\n",
> +			mmc_hostname(card->host),
> +			pack_stats->pack_stop_reason[WRONG_DATA_DIR]);
> +		strlcat(ubuf, temp_buf, cnt);
> +	}
> +	if (pack_stats->pack_stop_reason[FLUSH_OR_DISCARD]) {
> +		snprintf(temp_buf, TEMP_BUF_SIZE,
> +			 "%s: %d times: flush or discard\n",
> +			mmc_hostname(card->host),
> +			pack_stats->pack_stop_reason[FLUSH_OR_DISCARD]);
> +		strlcat(ubuf, temp_buf, cnt);
> +	}
> +	if (pack_stats->pack_stop_reason[EMPTY_QUEUE]) {
> +		snprintf(temp_buf, TEMP_BUF_SIZE,
> +			 "%s: %d times: empty queue\n",
> +			mmc_hostname(card->host),
> +			pack_stats->pack_stop_reason[EMPTY_QUEUE]);
> +		strlcat(ubuf, temp_buf, cnt);
> +	}
> +	if (pack_stats->pack_stop_reason[REL_WRITE]) {
> +		snprintf(temp_buf, TEMP_BUF_SIZE,
> +			 "%s: %d times: rel write\n",
> +			mmc_hostname(card->host),
> +			pack_stats->pack_stop_reason[REL_WRITE]);
> +		strlcat(ubuf, temp_buf, cnt);
> +	}
> +	if (pack_stats->pack_stop_reason[THRESHOLD]) {
> +		snprintf(temp_buf, TEMP_BUF_SIZE,
> +			 "%s: %d times: Threshold\n",
> +			mmc_hostname(card->host),
> +			pack_stats->pack_stop_reason[THRESHOLD]);
> +		strlcat(ubuf, temp_buf, cnt);
> +	}
> +	if (pack_stats->pack_stop_reason[LARGE_SEC_ALIGN]) {
> +		snprintf(temp_buf, TEMP_BUF_SIZE,
> +			 "%s: %d times: large sector alignment\n",
> +			mmc_hostname(card->host),
> +			pack_stats->pack_stop_reason[LARGE_SEC_ALIGN]);
> +		strlcat(ubuf, temp_buf, cnt);
> +	}
> +
> +	spin_unlock(&pack_stats->lock);
> +
> +	kfree(temp_buf);
> +
> +	pr_info("%s", ubuf);
> +
> +exit:
> +	if (card->wr_pack_stats.print_in_read == 1) {
> +		card->wr_pack_stats.print_in_read = 0;
> +		return strnlen(ubuf, cnt);
> +	}
> +
> +	return 0;
> +}
> +
> +static ssize_t mmc_wr_pack_stats_write(struct file *filp,
> +				       const char __user *ubuf, size_t cnt,
> +				       loff_t *ppos)
> +{
> +	struct mmc_card *card = filp->private_data;
> +	int value;
> +
> +	if (!card)
> +		return cnt;
> +
> +	sscanf(ubuf, "%d", &value);
> +	if (value) {
> +		mmc_blk_init_packed_statistics(card);
> +	} else {
> +		spin_lock(&card->wr_pack_stats.lock);
> +		card->wr_pack_stats.enabled = false;
> +		spin_unlock(&card->wr_pack_stats.lock);
> +	}
> +
> +	return cnt;
> +}
> +
> +static const struct file_operations mmc_dbg_wr_pack_stats_fops = {
> +	.open		= mmc_wr_pack_stats_open,
> +	.read		= mmc_wr_pack_stats_read,
> +	.write		= mmc_wr_pack_stats_write,
> +};
> +
>  void mmc_add_card_debugfs(struct mmc_card *card)
>  {
>  	struct mmc_host	*host = card->host;
> @@ -366,6 +536,12 @@ void mmc_add_card_debugfs(struct mmc_card *card)
>  					&mmc_dbg_ext_csd_fops))
>  			goto err;
>
> +	if (mmc_card_mmc(card) && (card->ext_csd.rev >= 6) &&
> +	    (card->host->caps2 & MMC_CAP2_PACKED_WR))
> +		if (!debugfs_create_file("wr_pack_stats", S_IRUSR, root, card,
> +					 &mmc_dbg_wr_pack_stats_fops))
> +			goto err;
> +
>  	return;
>
>  err:
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> index 0cbd1ef..ee8cdf7 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -1304,6 +1304,24 @@ static int mmc_init_card(struct mmc_host *host, u32
> ocr,
>  		} else {
>  			card->ext_csd.packed_event_en = 1;
>  		}
> +
> +	}
> +
> +	if (!oldcard) {
> +		if ((host->caps2 & MMC_CAP2_PACKED_CMD) &&
> +		    (card->ext_csd.max_packed_writes > 0)) {
> +			/*
> +			 * We would like to keep the statistics in an index
> +			 * that equals the num of packed requests
> +			 * (1 to max_packed_writes)
> +			 */
> +			card->wr_pack_stats.packing_events = kzalloc(
> +				(card->ext_csd.max_packed_writes + 1) *
> +				sizeof(*card->wr_pack_stats.packing_events),
> +				GFP_KERNEL);
> +			if (!card->wr_pack_stats.packing_events)
> +				goto free_card;
> +		}
>  	}
>
>  	if (!oldcard)
> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
> index f31725b..66732a7 100644
> --- a/include/linux/mmc/card.h
> +++ b/include/linux/mmc/card.h
> @@ -226,6 +226,26 @@ struct mmc_part {
>  #define MMC_BLK_DATA_AREA_RPMB	(1<<3)
>  };
>
> +enum mmc_packed_stop_reasons {
> +	EXCEEDS_SEGMENTS = 0,
> +	EXCEEDS_SECTORS,
> +	WRONG_DATA_DIR,
> +	FLUSH_OR_DISCARD,
> +	EMPTY_QUEUE,
> +	REL_WRITE,
> +	THRESHOLD,
> +	LARGE_SEC_ALIGN,
> +	MAX_REASONS,
> +};
> +
> +struct mmc_wr_pack_stats {
> +	u32 *packing_events;
> +	u32 pack_stop_reason[MAX_REASONS];
> +	spinlock_t lock;
> +	bool enabled;
> +	bool print_in_read;
> +};
> +
>  /*
>   * MMC device
>   */
> @@ -294,6 +314,7 @@ struct mmc_card {
>  	struct dentry		*debugfs_root;
>  	struct mmc_part	part[MMC_NUM_PHY_PARTITION]; /* physical partitions */
>  	unsigned int    nr_parts;
> +	struct mmc_wr_pack_stats wr_pack_stats; /* packed commands stats*/
>  };
>
>  /*
> @@ -520,4 +541,8 @@ extern void mmc_unregister_driver(struct mmc_driver
> *);
>  extern void mmc_fixup_device(struct mmc_card *card,
>  			     const struct mmc_fixup *table);
>
> +extern struct mmc_wr_pack_stats *mmc_blk_get_packed_statistics(
> +			struct mmc_card *card);
> +extern void mmc_blk_init_packed_statistics(struct mmc_card *card);
> +
>  #endif /* LINUX_MMC_CARD_H */
> --
> 1.7.3.3
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Maya Erez
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

