Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab3DVVEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 17:04:42 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:36419 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3DVVEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 17:04:41 -0400
MIME-Version: 1.0
In-Reply-To: <1366616878-29481-3-git-send-email-b32955@freescale.com>
References: <1366616878-29481-1-git-send-email-b32955@freescale.com>
	<1366616878-29481-3-git-send-email-b32955@freescale.com>
Date: Mon, 22 Apr 2013 14:04:40 -0700
Message-ID: <CAN8TOE8EwK1iaDOjBPpUhQmzn=AK-2LufufwwMON6gf=-zZa+Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/8] mtd: add a helper to get the supported features
 for ONFI nand
From: Brian Norris <computersforpeace@gmail.com>
To: Huang Shijie <b32955@freescale.com>
Cc: dwmw2@infradead.org, dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Huang Shijie <shijie8@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 12:47 AM, Huang Shijie <b32955@freescale.com> wrote:
> From: Huang Shijie <shijie8@gmail.com>
>
> add a helper to get the supported features for ONFI nand.
> Also add the neccessary macros.
>
> Signed-off-by: Huang Shijie <b32955@freescale.com>
> ---
>  include/linux/mtd/nand.h |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
> index 210bf36..122322c 100644
> --- a/include/linux/mtd/nand.h
> +++ b/include/linux/mtd/nand.h
> @@ -202,6 +202,11 @@ typedef enum {
>  /* Keep gcc happy */
>  struct nand_chip;
>
> +/* ONFI features */
> +#define ONFI_FEATURE_16_BIT_BUS                (1 << 0)
> +#define ONFI_FEATURE_EXT_PARAM_PAGE    (1 << 7)
> +#define ONFI_FEATURE_UNKNOWN           (1 << 15)

Where did you get the UNKNOWN field from? Bit 15 looks like a reserved
field (in ONFI 3.1, at least) and certainly does *not* represent a
null value. Instead, I think it does not need a macro at all, and we
can just use 0 for non-ONFI chips.

>  /* ONFI timing mode, used in both asynchronous and synchronous mode */
>  #define ONFI_TIMING_MODE_0             (1 << 0)
>  #define ONFI_TIMING_MODE_1             (1 << 1)
> @@ -750,6 +755,14 @@ struct platform_nand_chip *get_platform_nandchip(struct mtd_info *mtd)
>         return chip->priv;
>  }
>
> +/* return the supported features. */
> +static inline int onfi_feature(struct nand_chip *chip)
> +{
> +       if (!chip->onfi_version)
> +               return ONFI_FEATURE_UNKNOWN;

As noted above, just this macro is incorrect.

> +       return le16_to_cpu(chip->onfi_params.features);

Just make the whole function:

return chip->onfi_version ? le16_to_cpu(chip->onfi_params.features) : 0;

It is up to the caller to ensure that they don't rely on the returned
value for non-ONFI chips.

> +}
> +
>  /* return the supported asynchronous timing mode. */
>  static inline int onfi_get_async_timing_mode(struct nand_chip *chip)
>  {

Brian
