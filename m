Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbaDNLwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:52:34 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:33241 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548AbaDNLw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:52:29 -0400
MIME-Version: 1.0
In-Reply-To: <1396995583-5475-1-git-send-email-markus.mayer@linaro.org>
References: <1396995583-5475-1-git-send-email-markus.mayer@linaro.org>
Date: Mon, 14 Apr 2014 13:52:28 +0200
Message-ID: <CAPDyKFoNnmqc_6Vz7kTGk6yY5W64Wc2Q8MmWz1fNgUNX1PP61g@mail.gmail.com>
Subject: Re: [PATCH RESEND] mmc: Delay the card_event callback into the
 mmc_rescan worker
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Markus Mayer <markus.mayer@linaro.org>
Cc: Chris Ball <chris@printf.net>, Christian Daudt <bcm@fixthebug.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 April 2014 00:19, Markus Mayer <markus.mayer@linaro.org> wrote:
> This change removes the callback from atomic context which it doesn't
> need to be in, and puts it in line with the debounced rescan.
>
> This code is based on these e-mail threads with Christian Daudt:
>
>   https://lkml.org/lkml/2013/8/19/539
>   https://lkml.org/lkml/2014/3/19/79
>
> Signed-off-by: Markus Mayer <markus.mayer@linaro.org>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

> ---
>  drivers/mmc/core/core.c      |    5 +++++
>  drivers/mmc/core/slot-gpio.c |    4 +---
>  include/linux/mmc/host.h     |    2 ++
>  3 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 098374b..ff7fd2e 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -2421,6 +2421,11 @@ void mmc_rescan(struct work_struct *work)
>                 container_of(work, struct mmc_host, detect.work);
>         int i;
>
> +       if (host->trigger_card_event && host->ops->card_event) {
> +               host->ops->card_event(host);
> +               host->trigger_card_event = false;
> +       }
> +
>         if (host->rescan_disable)
>                 return;
>
> diff --git a/drivers/mmc/core/slot-gpio.c b/drivers/mmc/core/slot-gpio.c
> index 46596b71..4029c85 100644
> --- a/drivers/mmc/core/slot-gpio.c
> +++ b/drivers/mmc/core/slot-gpio.c
> @@ -29,9 +29,7 @@ static irqreturn_t mmc_gpio_cd_irqt(int irq, void *dev_id)
>         /* Schedule a card detection after a debounce timeout */
>         struct mmc_host *host = dev_id;
>
> -       if (host->ops->card_event)
> -               host->ops->card_event(host);
> -
> +       host->trigger_card_event = true;
>         mmc_detect_change(host, msecs_to_jiffies(200));
>
>         return IRQ_HANDLED;
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index 99f5709..63b983b 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -322,6 +322,8 @@ struct mmc_host {
>         int                     rescan_disable; /* disable card detection */
>         int                     rescan_entered; /* used with nonremovable devices */
>
> +       bool                    trigger_card_event; /* card_event necessary */
> +
>         struct mmc_card         *card;          /* device attached to this host */
>
>         wait_queue_head_t       wq;
> --
> 1.7.9.5
>
