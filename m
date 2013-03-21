Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab3CUTts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 15:49:48 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15344 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab3CUTtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 15:49:47 -0400
X-IronPort-AV: E=Sophos;i="4.84,888,1355126400"; 
   d="scan'208";a="31654287"
Message-ID: <024eaaf711ee8e1438484a3bf8436cc9.squirrel@www.codeaurora.org>
In-Reply-To: <26E7A31274623843B0E8CF86148BFE32B02F5779@NTXAVZMBX04.azit.micron.com>
References: <1361705927-10524-1-git-send-email-ygardi@codeaurora.org>
    <26E7A31274623843B0E8CF86148BFE32B02F5779@NTXAVZMBX04.azit.micron.com>
Date: Thu, 21 Mar 2013 12:49:46 -0700
Subject: RE: [PATCH v1] mmc: card: Adding support for sanitize in eMMC 4.5
From: merez@codeaurora.org
To: "Luca Porzio (lporzio)" <lporzio@micron.com>
Cc: "Yaniv Gardi" <ygardi@codeaurora.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luca,

Having a timeout that takes into consideration the card size would be
artificial as we cannot have the ability to create a function for its
calculation that will fit all the card vendors.

I suggest keeping it as a constant value for simplicity, as 4 minutes
cover all the card sizes.

Thanks,
Maya
> Hi Yaniv,
>
>> -----Original Message-----
>> From: linux-mmc-owner@vger.kernel.org [mailto:linux-mmc-
>> owner@vger.kernel.org] On Behalf Of Yaniv Gardi
>> Sent: Sunday, February 24, 2013 12:39 PM
>> To: linux-mmc@vger.kernel.org; vgoyal@redhat.com; tj@kernel.org; linux-
>> kernel@vger.kernel.org
>> Cc: linux-arm-msm@vger.kernel.org; Yaniv Gardi
>> Subject: [PATCH v1] mmc: card: Adding support for sanitize in eMMC 4.5
>>
>> The sanitize support is added as a user-app ioctl call, and
>> was removed from the block-device request, since its purpose is
>> to be invoked not via File-System but by a user.
>> This feature deletes the unmap memory region of the eMMC card,
>> by writing to a specific register in the EXT_CSD.
>> unmap region is the memory region that was previously deleted
>> (by erase, trim or discard operation).
>> In order to avoid timeout when sanitizing large-scale cards,
>> the timeout for sanitize operation is 240 seconds.
>>
>> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>>
>> ---
>>  drivers/mmc/card/block.c |   68
>> +++++++++++++++++++++++++++++++-----------
>> ---
>>  drivers/mmc/card/queue.c |    2 +-
>>  include/linux/mmc/host.h |    1 +
>>  3 files changed, 49 insertions(+), 22 deletions(-)
>>
>> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
>> index 21056b9..21bb8b4 100644
>> --- a/drivers/mmc/card/block.c
>> +++ b/drivers/mmc/card/block.c
>> @@ -58,6 +58,8 @@ MODULE_ALIAS("mmc:block");
>>  #define INAND_CMD38_ARG_SECTRIM1 0x81
>>  #define INAND_CMD38_ARG_SECTRIM2 0x88
>>  #define MMC_BLK_TIMEOUT_MS  (10 * 60 * 1000)        /* 10 minute
>> timeout
>> */
>> +#define MMC_SANITIZE_REQ_TIMEOUT 240000
>
> Though I would agree that 4 minutes is a reasonable sanitize time,
> the sanitize command may also depend on card size.
> As such I am not sure whether it can be regarded as a constant or
> needs to be proportional to card size.
>
>> +#define MMC_EXTRACT_INDEX_FROM_ARG(x) ((x & 0x00FF0000) >> 16)
>>
>>  static DEFINE_MUTEX(block_mutex);
>>
>> @@ -394,6 +396,35 @@ static int ioctl_rpmb_card_status_poll(struct
>> mmc_card
>> *card, u32 *status,
>>  	return err;
>>  }
>>
>> +static int ioctl_do_sanitize(struct mmc_card *card)
>> +{
>> +	int err;
>> +
>> +	if (!(mmc_can_sanitize(card) &&
>> +	      (card->host->caps2 & MMC_CAP2_SANITIZE))) {
>> +			pr_warn("%s: %s - SANITIZE is not supported\n",
>> +				mmc_hostname(card->host), __func__);
>> +			err = -EOPNOTSUPP;
>> +			goto out;
>> +	}
>> +
>> +	pr_debug("%s: %s - SANITIZE IN PROGRESS...\n",
>> +		mmc_hostname(card->host), __func__);
>> +
>> +	err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>> +					EXT_CSD_SANITIZE_START, 1,
>> +					MMC_SANITIZE_REQ_TIMEOUT);
>> +
>> +	if (err)
>> +		pr_err("%s: %s - EXT_CSD_SANITIZE_START failed. err=%d\n",
>> +		       mmc_hostname(card->host), __func__, err);
>> +
>
> In case of Sanitize timeout, the eMMC might go in an unclear state.
> May I suggest to:
> - issue an HPI before leaving thus bring the eMMC back into safe status
> - report the 'sanitize not complete error' and let the user decide on
>   Whether he wants to re-issue (i.e. continue) the sanitize or just let
>   it go.
>
> Thanks,
>    Luca
>
>> +	pr_debug("%s: %s - SANITIZE COMPLETED\n", mmc_hostname(card->host),
>> +					     __func__);
>> +out:
>> +	return err;
>> +}
>> +
>>  static int mmc_blk_ioctl_cmd(struct block_device *bdev,
>>  	struct mmc_ioc_cmd __user *ic_ptr)
>>  {
>> @@ -496,6 +527,16 @@ static int mmc_blk_ioctl_cmd(struct block_device
>> *bdev,
>>  			goto cmd_rel_host;
>>  	}
>>
>> +	if (MMC_EXTRACT_INDEX_FROM_ARG(cmd.arg) == EXT_CSD_SANITIZE_START) {
>> +		err = ioctl_do_sanitize(card);
>> +
>> +		if (err)
>> +			pr_err("%s: ioctl_do_sanitize() failed. err = %d",
>> +			       __func__, err);
>> +
>> +		goto cmd_rel_host;
>> +	}
>> +
>>  	mmc_wait_for_req(card->host, &mrq);
>>
>>  	if (cmd.error) {
>> @@ -925,10 +966,10 @@ static int mmc_blk_issue_secdiscard_rq(struct
>> mmc_queue *mq,
>>  {
>>  	struct mmc_blk_data *md = mq->data;
>>  	struct mmc_card *card = md->queue.card;
>> -	unsigned int from, nr, arg, trim_arg, erase_arg;
>> +	unsigned int from, nr, arg;
>>  	int err = 0, type = MMC_BLK_SECDISCARD;
>>
>> -	if (!(mmc_can_secure_erase_trim(card) || mmc_can_sanitize(card))) {
>> +	if (!(mmc_can_secure_erase_trim(card))) {
>>  		err = -EOPNOTSUPP;
>>  		goto out;
>>  	}
>> @@ -936,23 +977,11 @@ static int mmc_blk_issue_secdiscard_rq(struct
>> mmc_queue *mq,
>>  	from = blk_rq_pos(req);
>>  	nr = blk_rq_sectors(req);
>>
>> -	/* The sanitize operation is supported at v4.5 only */
>> -	if (mmc_can_sanitize(card)) {
>> -		erase_arg = MMC_ERASE_ARG;
>> -		trim_arg = MMC_TRIM_ARG;
>> -	} else {
>> -		erase_arg = MMC_SECURE_ERASE_ARG;
>> -		trim_arg = MMC_SECURE_TRIM1_ARG;
>> -	}
>> +	if (mmc_can_trim(card) && !mmc_erase_group_aligned(card, from, nr))
>> +		arg = MMC_SECURE_TRIM1_ARG;
>> +	else
>> +		arg = MMC_SECURE_ERASE_ARG;
>>
>> -	if (mmc_erase_group_aligned(card, from, nr))
>> -		arg = erase_arg;
>> -	else if (mmc_can_trim(card))
>> -		arg = trim_arg;
>> -	else {
>> -		err = -EINVAL;
>> -		goto out;
>> -	}
>>  retry:
>>  	if (card->quirks & MMC_QUIRK_INAND_CMD38) {
>>  		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>> @@ -988,9 +1017,6 @@ retry:
>>  			goto out;
>>  	}
>>
>> -	if (mmc_can_sanitize(card))
>> -		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>> -				 EXT_CSD_SANITIZE_START, 1, 0);
>>  out_retry:
>>  	if (err && !mmc_blk_reset(md, card->host, type))
>>  		goto retry;
>> diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
>> index fadf52e..483f0e8 100644
>> --- a/drivers/mmc/card/queue.c
>> +++ b/drivers/mmc/card/queue.c
>> @@ -148,7 +148,7 @@ static void mmc_queue_setup_discard(struct
>> request_queue *q,
>>  	/* granularity must not be greater than max. discard */
>>  	if (card->pref_erase > max_discard)
>>  		q->limits.discard_granularity = 0;
>> -	if (mmc_can_secure_erase_trim(card) || mmc_can_sanitize(card))
>> +	if (mmc_can_secure_erase_trim(card))
>>  		queue_flag_set_unlocked(QUEUE_FLAG_SECDISCARD, q);
>>  }
>>
>> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
>> index 61a10c1..045e9f7 100644
>> --- a/include/linux/mmc/host.h
>> +++ b/include/linux/mmc/host.h
>> @@ -258,6 +258,7 @@ struct mmc_host {
>>  #define MMC_CAP2_HC_ERASE_SZ	(1 << 9)	/* High-capacity erase size */
>>  #define MMC_CAP2_CD_ACTIVE_HIGH	(1 << 10)	/* Card-detect signal active
>> high */
>>  #define MMC_CAP2_RO_ACTIVE_HIGH	(1 << 11)	/* Write-protect signal
>> active
>> high */
>> +#define MMC_CAP2_SANITIZE	(1 << 12)		/* Support Sanitize */
>>
>>  	mmc_pm_flag_t		pm_caps;	/* supported pm features */
>>
>> --
>> 1.7.6
>> --
>> Sent by a consultant of the Qualcomm Innovation Center, Inc.
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
>> Forum
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Maya Erez
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

