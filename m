Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbaENJxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:53:38 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:34052 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbaENJxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:53:36 -0400
MIME-Version: 1.0
In-Reply-To: <1399457217-22846-1-git-send-email-ludovic.desroches@atmel.com>
References: <1399457217-22846-1-git-send-email-ludovic.desroches@atmel.com>
Date: Wed, 14 May 2014 11:53:35 +0200
Message-ID: <CAPDyKFqeunnWmguTH89byNc5Yy+CBY4avMeeon3ZSfNMmGJa9Q@mail.gmail.com>
Subject: Re: [PATCH RFC] mmc: add slot argument to mmc_of_parse
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Chris Ball <chris@printf.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 May 2014 12:06, Ludovic Desroches <ludovic.desroches@atmel.com> wrote:
> Some hosts manage several slots. In these case information such as the bus
> width, chip detect and others are into the slot node. So we have to parse
> child nodes. If not NULL, slot node will be used instead of the device
> node.
>
> Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
> ---
>
> Hi,
>
> Since this patch is only a RFC, I have not yet updated drivers using this
> function.
>
> I would like to use mmc_of_parse to reduce code duplication. My issue is that
> atmel mci is a bit different from others mci host since it can provide
> several slots, so it allocates several mmc hosts. By the way, it is not the
> only one.
>
> When calling mmc_alloc_host, host->parent is set to &pdev->dev. mmc_of_parse
> uses host->parent->of_node but in my case settings are in the slot nodes so in
> the child nodes. That's why I would like to have a way to tell which node I
> want to use.

Seems reasonable, thanks for working on this!

>
>
> Regards
>
> Ludovic
>
>
>
>  drivers/mmc/core/host.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
> index fdea825..ed6cea5 100644
> --- a/drivers/mmc/core/host.c
> +++ b/drivers/mmc/core/host.c
> @@ -300,13 +300,15 @@ static inline void mmc_host_clk_sysfs_init(struct mmc_host *host)
>  /**
>   *     mmc_of_parse() - parse host's device-tree node
>   *     @host: host whose node should be parsed.
> + *     @slot: some devices provide several slots so the node to parse
> + *     is not the host one.
>   *
>   * To keep the rest of the MMC subsystem unaware of whether DT has been
>   * used to to instantiate and configure this host instance or not, we
>   * parse the properties and set respective generic mmc-host flags and
>   * parameters.
>   */
> -int mmc_of_parse(struct mmc_host *host)
> +int mmc_of_parse(struct mmc_host *host, struct device_node *slot)
>  {
>         struct device_node *np;
>         u32 bus_width;
> @@ -317,7 +319,10 @@ int mmc_of_parse(struct mmc_host *host)
>         if (!host->parent || !host->parent->of_node)
>                 return 0;
>
> -       np = host->parent->of_node;
> +       if (slot)
> +               np = slot;
> +       else
> +               np = host->parent->of_node;
>
>         /* "bus-width" is translated to MMC_CAP_*_BIT_DATA flags */
>         if (of_property_read_u32(np, "bus-width", &bus_width) < 0) {
> --
> 1.7.9.5
>

How about adding a new API, __mmc_of_parse((struct mmc_host *host,
struct device_node *slot)
Then let the old API mmc_of_parse() remain as is, but let it call the
new API with slot == NULL.

Atmel can then use the new API, but the other drivers can remain as is.

Kind regards
Ulf Hansson
