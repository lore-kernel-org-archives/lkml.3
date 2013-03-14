Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab3CNFRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 01:17:40 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:57252 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab3CNFRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 01:17:38 -0400
MIME-Version: 1.0
In-Reply-To: <1363229965-13128-3-git-send-email-b32955@freescale.com>
References: <1363229965-13128-1-git-send-email-b32955@freescale.com>
	<1363229965-13128-3-git-send-email-b32955@freescale.com>
Date: Wed, 13 Mar 2013 22:17:38 -0700
Message-ID: <CAN8TOE9zAfGry1KjhHXyonHE0n6n=sPx1Gz4EmiAejY+e7CKzw@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] mtd: add the support to parse out the full-id nand type
From: Brian Norris <computersforpeace@gmail.com>
To: Huang Shijie <b32955@freescale.com>
Cc: dwmw2@infradead.org, artem.bityutskiy@linux.intel.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,

A few nitpicks, and a few real comments.

On Wed, Mar 13, 2013 at 7:59 PM, Huang Shijie <b32955@freescale.com> wrote:
> When we meet a full-id nand type which @mfr_id is true, we can use
> the find_full_id_nand() to parse out the neccessary information for a

s/neccessary/necessary

> nand chip.
>
> If we meet a non full-id nand type, we can handle it in the lagacy way.

s/lagacy/legacy

> Signed-off-by: Huang Shijie <b32955@freescale.com>
> ---
>  drivers/mtd/nand/nand_base.c |   36 +++++++++++++++++++++++++++++++++---
>  1 files changed, 33 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
> index 72eada2..b7ad9fd 100644
> --- a/drivers/mtd/nand/nand_base.c
> +++ b/drivers/mtd/nand/nand_base.c
> @@ -3123,6 +3123,30 @@ static void nand_decode_bbm_options(struct mtd_info *mtd,
>                 chip->bbt_options |= NAND_BBT_SCAN2NDPAGE;
>  }
>
> +static inline bool is_full_id_nand(struct nand_flash_dev *type)
> +{
> +       return type->mfr_id;
> +}

If we restore the id_len field (as I recommended in reply to the cover
letter), then I think this check would be better performed as:

return !type->id_len;

That would really be a more specific and accurate test and can
compensate for some wildly unlikely case in which a manufacturer uses
manufacturer ID = 0.

> +static bool find_full_id_nand(struct mtd_info *mtd, struct nand_chip *chip,
> +                  struct nand_flash_dev *type, u8 *id_data, int *busw)
> +{
> +       if (!strncmp(type->id, id_data, 8)) {
> +               mtd->writesize = type->pagesize;
> +               mtd->erasesize = type->erasesize;
> +               mtd->oobsize = type->oobsize;
> +
> +               chip->cellinfo = id_data[2];
> +               chip->chipsize = (uint64_t)type->chipsize << 20;
> +               chip->options |= type->options;
> +
> +               *busw = type->options & NAND_BUSWIDTH_16;
> +
> +               return true;
> +       }
> +       return false;
> +}
> +
>  /*
>   * Get the flash and manufacturer id and lookup if the type is supported.
>   */
> @@ -3174,9 +3198,15 @@ static struct nand_flash_dev *nand_get_flash_type(struct mtd_info *mtd,
>         if (!type)
>                 type = nand_flash_ids;
>
> -       for (; type->name != NULL; type++)
> -               if (*dev_id == type->dev_id)
> -                       break;
> +       for (; type->name != NULL; type++) {
> +               if (is_full_id_nand(type)) {
> +                       if (find_full_id_nand(mtd, chip, type, id_data, &busw))
> +                               goto ident_done;
> +               } else {
> +                       if (*dev_id == type->dev_id)

Combine the previous two lines to:

} else if (*dev_id == type->dev_id) {

> +                               break;
> +               }
> +       }
>
>         chip->onfi_version = 0;
>         if (!type->name || !type->pagesize) {

Brian
