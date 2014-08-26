Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009AbaHZGUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 02:20:23 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:10379 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbaHZGUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 02:20:21 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-47-53fc272354b9
Message-id: <53FC271A.9080108@samsung.com>
Date: Tue, 26 Aug 2014 08:20:10 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Joonyoung Shim <jy0922.shim@samsung.com>, Inki Dae <inki.dae@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 14/15] drm/exynos/fimc: simplify buffer queuing
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
 <1408693946-15456-15-git-send-email-a.hajda@samsung.com>
 <53FC20EC.7070209@samsung.com>
In-reply-to: <53FC20EC.7070209@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsVy+t/xy7rK6n+CDR7+5bC48vU9m8Wk+xNY
	LF7cu8hicbbpDbvF5V1z2CxmnN/HZLH2yF12ixmTX7I5cHjc7z7O5NG3ZRWjx+dNcgHMUVw2
	Kak5mWWpRfp2CVwZ55YtYyv4J1PRtvoqSwPjbPEuRg4OCQETiUVfqroYOYFMMYkL99azdTFy
	cQgJLGWUeHb3PTOE84lRYuW2D4wgVbwCWhKXO+8yg9gsAqoS/471sYDYbAKaEn8332QDsUUF
	wiSe/TrIBFEvKPFj8j2wGhEBX4kt/18zggxlFljAJPHtQQdYkbCAs8TaRceYILbNZ5Q42HoJ
	bBungLbEivdbGEFOZRbQk7h/UQskzCwgL7F5zVvmCYwCs5DsmIVQNQtJ1QJG5lWMoqmlyQXF
	Sem5hnrFibnFpXnpesn5uZsYIaH9ZQfj4mNWhxgFOBiVeHg/lPwOFmJNLCuuzD3EKMHBrCTC
	y/AQKMSbklhZlVqUH19UmpNafIiRiYNTqoFRc+tjpbyNs8O+FtiZ2AdrWh/cFCyYuPGw8VQh
	hm2XVM7dv2a6Uvi1mYdN2Lr5Uzr65ovrPBM6lMLsrLax+WdAuIOw/1GX671bdxuf3LV5rf/F
	/NWSjvI2ejNdts+2izURly1Z88hY/cxit5dTVKRyen4KWL1bUfiyKCtIrqDW7oHakXdhugFK
	LMUZiYZazEXFiQAq5uXFSwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 07:53 AM, Joonyoung Shim wrote:
> Hi Andrzej,
>
> On 08/22/2014 04:52 PM, Andrzej Hajda wrote:
>> The patch removes redundant checks, redundant HW reads
>> and simplifies code.
>>
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>> ---
>>  drivers/gpu/drm/exynos/exynos_drm_fimc.c | 64 ++++++++------------------------
>>  1 file changed, 15 insertions(+), 49 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
>> index bd6628d..b20078e 100644
>> --- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
>> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
>> @@ -1124,67 +1124,34 @@ static int fimc_dst_set_size(struct device *dev, int swap,
>>  	return 0;
>>  }
>>  
>> -static int fimc_dst_get_buf_count(struct fimc_context *ctx)
>> -{
>> -	u32 cfg, buf_num;
>> -
>> -	cfg = fimc_read(ctx, EXYNOS_CIFCNTSEQ);
>> -
>> -	buf_num = hweight32(cfg);
>> -
>> -	DRM_DEBUG_KMS("buf_num[%d]\n", buf_num);
>> -
>> -	return buf_num;
>> -}
>> -
>> -static int fimc_dst_set_buf_seq(struct fimc_context *ctx, u32 buf_id,
>> +static void fimc_dst_set_buf_seq(struct fimc_context *ctx, u32 buf_id,
>>  		enum drm_exynos_ipp_buf_type buf_type)
>>  {
>> -	struct exynos_drm_ippdrv *ippdrv = &ctx->ippdrv;
>> -	bool enable;
>> -	u32 cfg;
>> -	u32 mask = 0x00000001 << buf_id;
>> -	int ret = 0;
>>  	unsigned long flags;
>> +	u32 buf_num;
>> +	u32 cfg;
>>  
>>  	DRM_DEBUG_KMS("buf_id[%d]buf_type[%d]\n", buf_id, buf_type);
>>  
>>  	spin_lock_irqsave(&ctx->lock, flags);
>>  
>> -	/* mask register set */
>>  	cfg = fimc_read(ctx, EXYNOS_CIFCNTSEQ);
>>  
>> -	switch (buf_type) {
>> -	case IPP_BUF_ENQUEUE:
>> -		enable = true;
>> -		break;
>> -	case IPP_BUF_DEQUEUE:
>> -		enable = false;
>> -		break;
>> -	default:
>> -		dev_err(ippdrv->dev, "invalid buf ctrl parameter.\n");
>> -		ret =  -EINVAL;
>> -		goto err_unlock;
>> -	}
>> +	if (buf_type == IPP_BUF_ENQUEUE)
>> +		cfg |= (1 << buf_id);
>> +	else
>> +		cfg &= (1 << buf_id);
> ~ Missing?

Yes, thanks for pointing it out.

Regards
Andrzej

>
>>  
>> -	/* sequence id */
>> -	cfg &= ~mask;
>> -	cfg |= (enable << buf_id);
>>  	fimc_write(ctx, cfg, EXYNOS_CIFCNTSEQ);
>>  
>> -	/* interrupt enable */
>> -	if (buf_type == IPP_BUF_ENQUEUE &&
>> -	    fimc_dst_get_buf_count(ctx) >= FIMC_BUF_START)
>> -		fimc_mask_irq(ctx, true);
>> +	buf_num = hweight32(cfg);
>>  
>> -	/* interrupt disable */
>> -	if (buf_type == IPP_BUF_DEQUEUE &&
>> -	    fimc_dst_get_buf_count(ctx) <= FIMC_BUF_STOP)
>> +	if (buf_type == IPP_BUF_ENQUEUE && buf_num >= FIMC_BUF_START)
>> +		fimc_mask_irq(ctx, true);
>> +	else if (buf_type == IPP_BUF_DEQUEUE && buf_num <= FIMC_BUF_STOP)
>>  		fimc_mask_irq(ctx, false);
>>  
>> -err_unlock:
>>  	spin_unlock_irqrestore(&ctx->lock, flags);
>> -	return ret;
>>  }
>>  
>>  static int fimc_dst_set_addr(struct device *dev,
>> @@ -1242,7 +1209,9 @@ static int fimc_dst_set_addr(struct device *dev,
>>  		break;
>>  	}
>>  
>> -	return fimc_dst_set_buf_seq(ctx, buf_id, buf_type);
>> +	fimc_dst_set_buf_seq(ctx, buf_id, buf_type);
>> +
>> +	return 0;
>>  }
>>  
>>  static struct exynos_drm_ipp_ops fimc_dst_ops = {
>> @@ -1297,10 +1266,7 @@ static irqreturn_t fimc_irq_handler(int irq, void *dev_id)
>>  
>>  	DRM_DEBUG_KMS("buf_id[%d]\n", buf_id);
>>  
>> -	if (fimc_dst_set_buf_seq(ctx, buf_id, IPP_BUF_DEQUEUE) < 0) {
>> -		DRM_ERROR("failed to dequeue.\n");
>> -		return IRQ_HANDLED;
>> -	}
>> +	fimc_dst_set_buf_seq(ctx, buf_id, IPP_BUF_DEQUEUE);
>>  
>>  	event_work->ippdrv = ippdrv;
>>  	event_work->buf_id[EXYNOS_DRM_OPS_DST] = buf_id;
>>
>

