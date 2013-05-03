Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763219Ab3ECSJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 14:09:10 -0400
Received: from mailout.micron.com ([137.201.242.129]:35216 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab3ECSJI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 14:09:08 -0400
X-Greylist: delayed 831 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 May 2013 14:09:08 EDT
From: "Luca Porzio (lporzio)" <lporzio@micron.com>
To: "merez@codeaurora.org" <merez@codeaurora.org>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4] mmc: card: Adding support for sanitize in eMMC 4.5
Thread-Topic: [PATCH v4] mmc: card: Adding support for sanitize in eMMC 4.5
Thread-Index: AQHOReEvBDw2lm4RfkiDjkZIeBlhepjv0f6AgAPxKDA=
Date: Fri, 3 May 2013 17:55:02 +0000
Message-ID: <26E7A31274623843B0E8CF86148BFE32B030F2D2@NTXAVZMBX04.azit.micron.com>
References: <n> <1367353620-2983-1-git-send-email-merez@codeaurora.org>
 <20156afaa810d94e35d0b72456fc3c4a.squirrel@www.codeaurora.org>
In-Reply-To: <20156afaa810d94e35d0b72456fc3c4a.squirrel@www.codeaurora.org>
Accept-Language: it-IT, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.176.66.86]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19842.000
X-TM-AS-Result: No--26.324100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maya,

This looks good to me.

Thanks,
   Luca

> -----Original Message-----
> From: linux-mmc-owner@vger.kernel.org [mailto:linux-mmc-
> owner@vger.kernel.org] On Behalf Of merez@codeaurora.org
> Sent: Wednesday, May 01, 2013 9:44 AM
> To: Maya Erez
> Cc: linux-mmc@vger.kernel.org; linux-arm-msm@vger.kernel.org; Maya
> Erez; Yaniv Gardi; open list
> Subject: Re: [PATCH v4] mmc: card: Adding support for sanitize in eMMC
> 4.5
> 
> Hi,
> 
> Ulf / Luca - I would appreciate if you could review this new version
> with
> high priority.
> If you don't have additional concerns I would like to try and push the
> changes to kernel-3.10.
> 
> Thanks,
> Maya
> > The sanitize support is added as a user-app ioctl call, and
> > was removed from the block-device request, since its purpose is
> > to be invoked not via File-System but by a user.
> > This feature deletes the unmap memory region of the eMMC card,
> > by writing to a specific register in the EXT_CSD.
> > unmap region is the memory region that was previously deleted
> > (by erase, trim or discard operation).
> > In order to avoid timeout when sanitizing large-scale cards,
> > the timeout for sanitize operation is 240 seconds.
> >
> > Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
> > Signed-off-by: Maya Erez <merez@codeaurora.org>
> > ---
> >  drivers/mmc/card/block.c   |   67
> > ++++++++++++++++++++++++++++++--------------
> >  drivers/mmc/card/queue.c   |    2 +-
> >  drivers/mmc/core/core.c    |   22 ++++++++++++++
> >  drivers/mmc/core/mmc_ops.c |    2 +
> >  include/linux/mmc/core.h   |    2 +
> >  5 files changed, 73 insertions(+), 22 deletions(-)
> >
> > diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> > index e12a03c..d3fbc21 100644
> > --- a/drivers/mmc/card/block.c
> > +++ b/drivers/mmc/card/block.c
> > @@ -58,6 +58,8 @@ MODULE_ALIAS("mmc:block");
> >  #define INAND_CMD38_ARG_SECTRIM1 0x81
> >  #define INAND_CMD38_ARG_SECTRIM2 0x88
> >  #define MMC_BLK_TIMEOUT_MS  (10 * 60 * 1000)        /* 10 minute
> timeout
> > */
> > +#define MMC_SANITIZE_REQ_TIMEOUT 240000
> > +#define MMC_EXTRACT_INDEX_FROM_ARG(x) ((x & 0x00FF0000) >> 16)
> >
> >  #define mmc_req_rel_wr(req)	(((req->cmd_flags & REQ_FUA) || \
> >  				  (req->cmd_flags & REQ_META)) && \
> > @@ -409,6 +411,34 @@ static int ioctl_rpmb_card_status_poll(struct
> > mmc_card *card, u32 *status,
> >  	return err;
> >  }
> >
> > +static int ioctl_do_sanitize(struct mmc_card *card)
> > +{
> > +	int err;
> > +
> > +	if (!mmc_can_sanitize(card)) {
> > +		pr_warn("%s: %s - SANITIZE is not supported\n",
> > +			mmc_hostname(card->host), __func__);
> > +		err = -EOPNOTSUPP;
> > +		goto out;
> > +	}
> > +
> > +	pr_debug("%s: %s - SANITIZE IN PROGRESS...\n",
> > +		mmc_hostname(card->host), __func__);
> > +
> > +	err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
> > +					EXT_CSD_SANITIZE_START, 1,
> > +					MMC_SANITIZE_REQ_TIMEOUT);
> > +
> > +	if (err)
> > +		pr_err("%s: %s - EXT_CSD_SANITIZE_START failed. err=%d\n",
> > +		       mmc_hostname(card->host), __func__, err);
> > +
> > +	pr_debug("%s: %s - SANITIZE COMPLETED\n", mmc_hostname(card-
> >host),
> > +					     __func__);
> > +out:
> > +	return err;
> > +}
> > +
> >  static int mmc_blk_ioctl_cmd(struct block_device *bdev,
> >  	struct mmc_ioc_cmd __user *ic_ptr)
> >  {
> > @@ -511,6 +541,16 @@ static int mmc_blk_ioctl_cmd(struct block_device
> > *bdev,
> >  			goto cmd_rel_host;
> >  	}
> >
> > +	if (MMC_EXTRACT_INDEX_FROM_ARG(cmd.arg) ==
> EXT_CSD_SANITIZE_START) {
> > +		err = ioctl_do_sanitize(card);
> > +
> > +		if (err)
> > +			pr_err("%s: ioctl_do_sanitize() failed. err = %d",
> > +			       __func__, err);
> > +
> > +		goto cmd_rel_host;
> > +	}
> > +
> >  	mmc_wait_for_req(card->host, &mrq);
> >
> >  	if (cmd.error) {
> > @@ -940,10 +980,10 @@ static int mmc_blk_issue_secdiscard_rq(struct
> > mmc_queue *mq,
> >  {
> >  	struct mmc_blk_data *md = mq->data;
> >  	struct mmc_card *card = md->queue.card;
> > -	unsigned int from, nr, arg, trim_arg, erase_arg;
> > +	unsigned int from, nr, arg;
> >  	int err = 0, type = MMC_BLK_SECDISCARD;
> >
> > -	if (!(mmc_can_secure_erase_trim(card) || mmc_can_sanitize(card)))
> {
> > +	if (!(mmc_can_secure_erase_trim(card))) {
> >  		err = -EOPNOTSUPP;
> >  		goto out;
> >  	}
> > @@ -951,23 +991,11 @@ static int mmc_blk_issue_secdiscard_rq(struct
> > mmc_queue *mq,
> >  	from = blk_rq_pos(req);
> >  	nr = blk_rq_sectors(req);
> >
> > -	/* The sanitize operation is supported at v4.5 only */
> > -	if (mmc_can_sanitize(card)) {
> > -		erase_arg = MMC_ERASE_ARG;
> > -		trim_arg = MMC_TRIM_ARG;
> > -	} else {
> > -		erase_arg = MMC_SECURE_ERASE_ARG;
> > -		trim_arg = MMC_SECURE_TRIM1_ARG;
> > -	}
> > +	if (mmc_can_trim(card) && !mmc_erase_group_aligned(card, from,
> nr))
> > +		arg = MMC_SECURE_TRIM1_ARG;
> > +	else
> > +		arg = MMC_SECURE_ERASE_ARG;
> >
> > -	if (mmc_erase_group_aligned(card, from, nr))
> > -		arg = erase_arg;
> > -	else if (mmc_can_trim(card))
> > -		arg = trim_arg;
> > -	else {
> > -		err = -EINVAL;
> > -		goto out;
> > -	}
> >  retry:
> >  	if (card->quirks & MMC_QUIRK_INAND_CMD38) {
> >  		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
> > @@ -1003,9 +1031,6 @@ retry:
> >  			goto out;
> >  	}
> >
> > -	if (mmc_can_sanitize(card))
> > -		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
> > -				 EXT_CSD_SANITIZE_START, 1, 0);
> >  out_retry:
> >  	if (err && !mmc_blk_reset(md, card->host, type))
> >  		goto retry;
> > diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
> > index 9447a0e..fa9632e 100644
> > --- a/drivers/mmc/card/queue.c
> > +++ b/drivers/mmc/card/queue.c
> > @@ -173,7 +173,7 @@ static void mmc_queue_setup_discard(struct
> > request_queue *q,
> >  	/* granularity must not be greater than max. discard */
> >  	if (card->pref_erase > max_discard)
> >  		q->limits.discard_granularity = 0;
> > -	if (mmc_can_secure_erase_trim(card) || mmc_can_sanitize(card))
> > +	if (mmc_can_secure_erase_trim(card))
> >  		queue_flag_set_unlocked(QUEUE_FLAG_SECDISCARD, q);
> >  }
> >
> > diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> > index 37c5dad..c103962 100644
> > --- a/drivers/mmc/core/core.c
> > +++ b/drivers/mmc/core/core.c
> > @@ -402,6 +402,7 @@ static int mmc_wait_for_data_req_done(struct
> mmc_host
> > *host,
> >  			context_info->is_done_rcv = false;
> >  			context_info->is_new_req = false;
> >  			cmd = mrq->cmd;
> > +
> >  			if (!cmd->error || !cmd->retries ||
> >  			    mmc_card_removed(host->card)) {
> >  				err = host->areq->err_check(host->card,
> > @@ -436,6 +437,27 @@ static void mmc_wait_for_req_done(struct
> mmc_host
> > *host,
> >  		wait_for_completion(&mrq->completion);
> >
> >  		cmd = mrq->cmd;
> > +
> > +		/*
> > +		 * If host has timed out waiting for the sanitize
> > +		 * to complete, card might be still in programming state
> > +		 * so let's try to bring the card out of programming
> > +		 * state.
> > +		 */
> > +		if (cmd->sanitize_busy && cmd->error == -ETIMEDOUT) {
> > +			if (!mmc_interrupt_hpi(host->card)) {
> > +				pr_warning("%s: %s: Interrupted "
> > +					   "sanitize\n",
> > +					   mmc_hostname(host),
> > +					   __func__);
> > +				cmd->error = 0;
> > +				break;
> > +			} else {
> > +				pr_err("%s: %s: Failed to interrupt "
> > +				       "sanitize\n",
> > +				       mmc_hostname(host), __func__);
> > +			}
> > +		}
> >  		if (!cmd->error || !cmd->retries ||
> >  		    mmc_card_removed(host->card))
> >  			break;
> > diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
> > index 49f04bc..124af52 100644
> > --- a/drivers/mmc/core/mmc_ops.c
> > +++ b/drivers/mmc/core/mmc_ops.c
> > @@ -431,6 +431,8 @@ int __mmc_switch(struct mmc_card *card, u8 set,
> u8
> > index, u8 value,
> >
> >
> >  	cmd.cmd_timeout_ms = timeout_ms;
> > +	if (index == EXT_CSD_SANITIZE_START)
> > +		cmd.sanitize_busy = true;
> >
> >  	err = mmc_wait_for_cmd(card->host, &cmd, MMC_CMD_RETRIES);
> >  	if (err)
> > diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
> > index 39613b9..bd06ff5 100644
> > --- a/include/linux/mmc/core.h
> > +++ b/include/linux/mmc/core.h
> > @@ -96,6 +96,8 @@ struct mmc_command {
> >   */
> >
> >  	unsigned int		cmd_timeout_ms;	/* in milliseconds */
> > +	/* Set this flag only for blocking sanitize request */
> > +	bool			sanitize_busy;
> >
> >  	struct mmc_data		*data;		/* data segment
> associated with cmd */
> >  	struct mmc_request	*mrq;		/* associated request */
> > --
> > 1.7.3.3
> > --
> > QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a
> member
> > of Code Aurora Forum, hosted by The Linux Foundation
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-mmc"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> --
> Maya Erez
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a
> member
> of Code Aurora Forum, hosted by The Linux Foundation
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
