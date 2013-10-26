Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab3JZAkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 20:40:45 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4243 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab3JZAko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 20:40:44 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <526B0F80.602@broadcom.com>
Date: Fri, 25 Oct 2013 17:40:32 -0700
From: "Ray Jui" <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101
 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Seungwon Jeon" <tgih.jun@samsung.com>, "'Chris Ball'" <cjb@laptop.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: fix host release issue after discard operation
References: <1C995FCD38EDD646A035D3E5892E8C7C04C189A8@SJEXCHMB13.corp.ad.broadcom.com>
 <001301ced16e$f2695480$d73bfd80$%jun@samsung.com>
In-Reply-To: <001301ced16e$f2695480$d73bfd80$%jun@samsung.com>
X-WSS-ID: 7E75D0F41501656988-01-01
Content-Type: text/plain;
 charset=windows-1252;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2013 3:42 AM, Seungwon Jeon wrote:
> Hi Ray,
>
> On Fri, October 25, 2013, Ray Jui wrote:
>> Under function mmc_blk_issue_rq, after an MMC discard operation,
>> the MMC request data structure may be freed in memory. Later in
>> the same function, the check of req->cmd_flags & MMC_REQ_SPECIAL_MASK
>> is dangerous and invalid. It causes the MMC host not being released
>> when it should
>>
>> This patch fixes the issue by marking the special request down before
>> the discard/flush operation
>>
>> Reported by: Harold (SoonYeal) Yang <haroldsy@broadcom.com>
>> Signed-off-by: Ray Jui <rjui@broadcom.com>
>> ---
>>   drivers/mmc/card/block.c |    8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
>> index 1a3163f..9e8e970 100644
>> --- a/drivers/mmc/card/block.c
>> +++ b/drivers/mmc/card/block.c
>> @@ -1954,7 +1954,7 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
>>
>>   static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
>>   {
>> -	int ret;
>> +	int ret, req_is_special = 0;
> It would be better to use boolean?
>
> Either, in a different way, I considered to save the cmd_flags like below.
> unsigned int cmd_flags = req ? req->cmd_flags : 0;
>
> Then, we could replace several 'if statement' without dereference.
> if (req && req->cmd_flags & REQ_DISCARD) -> if (cmd_flags & REQ_DISCARD)
>
> Just my suggestion.
>
> Thanks,
> Seungwon Jeon
>>   	struct mmc_blk_data *md = mq->data;
>>   	struct mmc_card *card = md->queue.card;
>>   	struct mmc_host *host = card->host;
>> @@ -1973,6 +1973,10 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
>>   		goto out;
>>   	}
>>
>> +	/* mark special request here since req may be freed later */
>> +	if (req && (req->cmd_flags & MMC_REQ_SPECIAL_MASK))
>> +		req_is_special = 1;
>> +
>>   	mq->flags &= ~MMC_QUEUE_NEW_REQUEST;
>>   	if (req && req->cmd_flags & REQ_DISCARD) {
>>   		/* complete ongoing async transfer before issuing discard */
>> @@ -1999,7 +2003,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
>>
>>   out:
>>   	if ((!req && !(mq->flags & MMC_QUEUE_NEW_REQUEST)) ||
>> -	     (req && (req->cmd_flags & MMC_REQ_SPECIAL_MASK)))
>> +	     req_is_special)
>>   		/*
>>   		 * Release host when there are no more requests
>>   		 * and after special request(discard, flush) is done.
>> --
>> 1.7.9.5
>
>
Hi Seungwon,

I like your suggestion. It makes the code simpler. I'll make the change 
and submit patch v2.

Thanks,

Ray Jui

