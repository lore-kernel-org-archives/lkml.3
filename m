Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbaKZPVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:21:40 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:63181 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbaKZPVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:21:39 -0500
Message-ID: <5475F003.6070209@kernel.dk>
Date: Wed, 26 Nov 2014 08:21:39 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?TWF0aWFzIEJqw7hybGluZw==?= <m@bjorling.me>, axboe@fb.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] null_blk: boundary check queue_mode and irqmode
References: <1417014178-13007-1-git-send-email-m@bjorling.me>
In-Reply-To: <1417014178-13007-1-git-send-email-m@bjorling.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2014 08:02 AM, Matias Bjørling wrote:
> When either queue_mode or irq_mode parameter is set outside its boundaries, the
> driver will not complete requests. This stalls driver initialization when
> partitions are probed. Fix by setting out of bound values to the parameters
> default.
>
> Signed-off-by: Matias Bjørling <m@bjorling.me>
> ---
>   drivers/block/null_blk.c | 14 +++++++++++++-
>   1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
> index caa6121..efe9f76 100644
> --- a/drivers/block/null_blk.c
> +++ b/drivers/block/null_blk.c
> @@ -506,7 +506,7 @@ static int null_add_dev(void)
>   		rv = init_driver_queues(nullb);
>   		if (rv)
>   			goto out_cleanup_blk_queue;
> -	} else {
> +	} else if (queue_mode == NULL_Q_RQ) {
>   		nullb->q = blk_init_queue_node(null_request_fn, &nullb->lock, home_node);
>   		if (!nullb->q) {
>   			rv = -ENOMEM;
> @@ -574,6 +574,18 @@ static int __init null_init(void)
>   		bs = PAGE_SIZE;
>   	}
>
> +	if (queue_mode < 0 || queue_mode > NULL_Q_MQ) {
> +		pr_warn("null_blk: invalid queue mode\n");
> +		pr_warn("null_blk: defaults queue mode to multiqueue\n");
> +		queue_mode = NULL_Q_MQ;
> +	}
> +
> +	if (irqmode < 0 || irqmode > NULL_IRQ_TIMER) {
> +		pr_warn("null_blk: invalid irq mode\n");
> +		pr_warn("null_blk: defauls irq mode to softirq\n");
> +		irqmode = NULL_IRQ_SOFTIRQ;
> +	}

Lets fix these by using module_param_cb() instead to reject invalid 
values upfront.

-- 
Jens Axboe

