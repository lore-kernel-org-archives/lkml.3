Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab3ITHdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 03:33:09 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53324 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab3ITHdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 03:33:07 -0400
MIME-Version: 1.0
In-Reply-To: <1379611214-1089-1-git-send-email-grundler@chromium.org>
References: <1379611214-1089-1-git-send-email-grundler@chromium.org>
Date: Fri, 20 Sep 2013 09:33:06 +0200
Message-ID: <CAPDyKFr0h=uTz4xOAULLc0Ff23xB-xVuuk+XnBz_Uq5YMryHbA@mail.gmail.com>
Subject: Re: [PATCH] mmc: core: remove issue_fn indirect function call
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Grant Grundler <grundler@chromium.org>
Cc: Chris Ball <cjb@laptop.org>, Seungwon Jeon <tgih.jun@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 September 2013 19:20, Grant Grundler <grundler@chromium.org> wrote:
> struct mmc_queue defines issue_fn as an indirect function call.
> issue_fn field only gets set to mmc_blk_issue_rq and only gets
> invoked immediately after calling blk_fetch_request().
> Don't bother with indirect function call - it's pointless and just
> obfuscates the code.
>
> Signed-off-by: Grant Grundler <grundler@chromium.org>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

> ---
>  drivers/mmc/card/block.c | 1 -
>  drivers/mmc/card/queue.c | 2 +-
>  drivers/mmc/card/queue.h | 1 -
>  3 files changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index 1a3163f..b2cdd10 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -2072,7 +2072,6 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
>         if (ret)
>                 goto err_putdisk;
>
> -       md->queue.issue_fn = mmc_blk_issue_rq;
>         md->queue.data = md;
>
>         md->disk->major = MMC_BLOCK_MAJOR;
> diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
> index fa9632e..6f9adc5 100644
> --- a/drivers/mmc/card/queue.c
> +++ b/drivers/mmc/card/queue.c
> @@ -67,7 +67,7 @@ static int mmc_queue_thread(void *d)
>                 if (req || mq->mqrq_prev->req) {
>                         set_current_state(TASK_RUNNING);
>                         cmd_flags = req ? req->cmd_flags : 0;
> -                       mq->issue_fn(mq, req);
> +                       mmc_blk_issue_rq(mq, req);
>                         if (mq->flags & MMC_QUEUE_NEW_REQUEST) {
>                                 mq->flags &= ~MMC_QUEUE_NEW_REQUEST;
>                                 continue; /* fetch again */
> diff --git a/drivers/mmc/card/queue.h b/drivers/mmc/card/queue.h
> index 5752d50..35380015 100644
> --- a/drivers/mmc/card/queue.h
> +++ b/drivers/mmc/card/queue.h
> @@ -51,7 +51,6 @@ struct mmc_queue {
>  #define MMC_QUEUE_SUSPENDED    (1 << 0)
>  #define MMC_QUEUE_NEW_REQUEST  (1 << 1)
>
> -       int                     (*issue_fn)(struct mmc_queue *, struct request *);
>         void                    *data;
>         struct request_queue    *queue;
>         struct mmc_queue_req    mqrq[2];
> --
> 1.8.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
