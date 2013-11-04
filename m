Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3KDSlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:41:17 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:2725 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008Ab3KDSlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 13:41:15 -0500
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <5277EA3A.4020001@broadcom.com>
Date: Mon, 4 Nov 2013 10:40:58 -0800
From: "Ray Jui" <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101
 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Seungwon Jeon" <tgih.jun@samsung.com>, "Chris Ball" <cjb@laptop.org>,
        rjui@broadcom.com
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mmc: fix host release issue after discard
 operation
References: <1382810624-17659-1-git-send-email-rjui@broadcom.com>
In-Reply-To: <1382810624-17659-1-git-send-email-rjui@broadcom.com>
X-WSS-ID: 7E6935A94RS4607184-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2013 11:03 AM, Ray Jui wrote:
> Under function mmc_blk_issue_rq, after an MMC discard operation,
> the MMC request data structure may be freed in memory. Later in
> the same function, the check of req->cmd_flags & MMC_REQ_SPECIAL_MASK
> is dangerous and invalid. It causes the MMC host not to be released
> when it should
>
> This patch fixes the issue by marking the special request down before
> the discard/flush operation
>
> Reported by: Harold (SoonYeal) Yang <haroldsy@broadcom.com>
> Signed-off-by: Ray Jui <rjui@broadcom.com>
> Reviewed-by: Seungwon Jeon <tgih.jun@samsung.com>
> ---
>   drivers/mmc/card/block.c |    7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index 1a3163f..4e8212c 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -1959,6 +1959,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
>   	struct mmc_card *card = md->queue.card;
>   	struct mmc_host *host = card->host;
>   	unsigned long flags;
> +	unsigned int cmd_flags = req ? req->cmd_flags : 0;
>
>   	if (req && !mq->mqrq_prev->req)
>   		/* claim host only for the first request */
> @@ -1974,7 +1975,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
>   	}
>
>   	mq->flags &= ~MMC_QUEUE_NEW_REQUEST;
> -	if (req && req->cmd_flags & REQ_DISCARD) {
> +	if (cmd_flags & REQ_DISCARD) {
>   		/* complete ongoing async transfer before issuing discard */
>   		if (card->host->areq)
>   			mmc_blk_issue_rw_rq(mq, NULL);
> @@ -1983,7 +1984,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
>   			ret = mmc_blk_issue_secdiscard_rq(mq, req);
>   		else
>   			ret = mmc_blk_issue_discard_rq(mq, req);
> -	} else if (req && req->cmd_flags & REQ_FLUSH) {
> +	} else if (cmd_flags & REQ_FLUSH) {
>   		/* complete ongoing async transfer before issuing flush */
>   		if (card->host->areq)
>   			mmc_blk_issue_rw_rq(mq, NULL);
> @@ -1999,7 +2000,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
>
>   out:
>   	if ((!req && !(mq->flags & MMC_QUEUE_NEW_REQUEST)) ||
> -	     (req && (req->cmd_flags & MMC_REQ_SPECIAL_MASK)))
> +	     (cmd_flags & MMC_REQ_SPECIAL_MASK))
>   		/*
>   		 * Release host when there are no more requests
>   		 * and after special request(discard, flush) is done.
>
Hi Seungwon/Chris,

Have you got a chance to review the MMC discard patch V2? The patch v2 
makes changes from v1 based on Seungwon's review comments.

Thanks,

Ray Jui

