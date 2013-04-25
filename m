Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab3DYGU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 02:20:57 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:55707 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3DYGU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 02:20:56 -0400
MIME-Version: 1.0
In-Reply-To: <1366707297-31309-5-git-send-email-b32955@freescale.com>
References: <1366707297-31309-1-git-send-email-b32955@freescale.com>
	<1366707297-31309-5-git-send-email-b32955@freescale.com>
Date: Wed, 24 Apr 2013 23:20:55 -0700
Message-ID: <CAN8TOE-yrawXsZzUX-SfNq+COJsRfPNJZJiJBZ=e7uavBPis5g@mail.gmail.com>
Subject: Re: [PATCH V3 4/9] mtd: get the ECC info from the Extended Parameter Page
From: Brian Norris <computersforpeace@gmail.com>
To: Huang Shijie <b32955@freescale.com>
Cc: dwmw2@infradead.org, dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 1:54 AM, Huang Shijie <b32955@freescale.com> wrote:
> Since the ONFI 2.1, the onfi spec adds the Extended Parameter Page
> to store the ECC info.
>
> The onfi spec tells us that if the nand chip's recommended ECC codeword
> size is not 512 bytes, then the @ecc_bits is 0xff. The host _SHOULD_ then
> read the Extended ECC information that is part of the extended parameter
> page to retrieve the ECC requirements for this device.
>
> This patch implement the reading of the Extended Parameter Page, and parses
> the sections for ECC type, and get the ECC info from the ECC section.
>
> Tested this patch with Micron MT29F64G08CBABAWP.
>
> Signed-off-by: Huang Shijie <b32955@freescale.com>
> ---
>  drivers/mtd/nand/nand_base.c |   72 ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 72 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
> index beff911..584cb0f 100644
> --- a/drivers/mtd/nand/nand_base.c
> +++ b/drivers/mtd/nand/nand_base.c
> @@ -2846,6 +2846,73 @@ static u16 onfi_crc16(u16 crc, u8 const *p, size_t len)
>         return crc;
>  }
>
> +/* Parse the Extended Parameter Page. */
> +static int nand_flash_detect_ext_param_page(struct mtd_info *mtd,
> +               struct nand_chip *chip, struct nand_onfi_params *p)
> +{
> +       struct onfi_ext_param_page *ep;
> +       struct onfi_ext_section *s;
> +       struct onfi_ext_ecc_info *ecc;
> +       uint8_t *cursor;
> +       int len;
> +       int ret;
> +       int i;
> +
> +       len = le16_to_cpu(p->ext_param_page_length) * 16;
> +       ep = kmalloc(len, GFP_KERNEL);
> +       if (!ep) {
> +               pr_debug("Out of memory.\n");

I believe people are trying to kill such messages from the kernel. If
kmalloc() fails to allocate memory, the mm system should give plenty
of scary and helpful messages anyway. This print message just becomes
bloat, then.

> +               ret = -ENOMEM;
> +               goto ext_out;
> +       }
> +
> +       /* Send our own NAND_CMD_PARAM. */
> +       chip->cmdfunc(mtd, NAND_CMD_PARAM, 0, -1);
> +
> +       /*
> +        * Use the Change Read Columm command to skip the ONFI Parameter Pages.
> +        * The nand_command() does not support the Change Read Columm command,
> +        * use the nand_command_lp() instead.
> +        */
> +       nand_command_lp(mtd, NAND_CMD_RNDOUT,
> +                       sizeof(*p) * p->num_of_param_pages , -1);

No, you cannot do this. Some drivers will provide their own cmdfunc,
so nand_command_lp() is unexpected for those drivers.

Your problem seems, instead, that you are executing this function too
early, before nand_flash_get_type() is able to assign
nand_command_lp() to be your cmdfunc. You might just want to call this
function after the following lines in nand_flash_get_type():

        /* Do not replace user supplied command function! */
        if (mtd->writesize > 512 && chip->cmdfunc == nand_command)
                chip->cmdfunc = nand_command_lp;

> +       /* Read out the Extended Parameter Page. */
> +       chip->read_buf(mtd, (uint8_t *)ep, len);
> +       if ((onfi_crc16(ONFI_CRC_BASE, ((uint8_t *)ep) + 2, len - 2)
> +               != le16_to_cpu(ep->crc)) || strncmp(ep->sig, "EPPS", 4)) {
> +               pr_debug("fail in the CRC.\n");
> +               ret = -EINVAL;
> +               goto ext_out;
> +       }
> +
> +       /* find the ECC section. */
> +       cursor = (uint8_t *)(ep + 1);
> +       for (i = 0; i < ONFI_EXT_SECTION_MAX; i++) {
> +               s = ep->sections + i;
> +               if (s->type == ONFI_SECTION_TYPE_2)
> +                       break;
> +               cursor += s->length * 16;
> +       }
> +       if (i == ONFI_EXT_SECTION_MAX) {
> +               pr_debug("We can not find the ECC section.\n");
> +               ret = -EINVAL;
> +               goto ext_out;
> +       }
> +
> +       /* get the info we want. */
> +       ecc = (struct onfi_ext_ecc_info *)cursor;
> +       chip->ecc_strength = ecc->ecc_bits;
> +       chip->ecc_size = 1 << ecc->codeword_size;
> +
> +       pr_info("ONFI extended param page detected.\n");
> +       return 0;
> +
> +ext_out:
> +       kfree(ep);
> +       return ret;
> +}
> +
>  /*
>   * Check if the NAND chip is ONFI compliant, returns 1 if it is, 0 otherwise.
>   */
> @@ -2914,6 +2981,11 @@ static int nand_flash_detect_onfi(struct mtd_info *mtd, struct nand_chip *chip,
>         if (p->ecc_bits != 0xff) {
>                 chip->ecc_strength = p->ecc_bits;
>                 chip->ecc_size = 512;
> +       } else if (chip->onfi_version >= 21 &&
> +               (onfi_feature(chip) & ONFI_FEATURE_EXT_PARAM_PAGE)) {
> +               /* The Extended Parameter Page is supported since ONFI 2.1. */
> +               if (nand_flash_detect_ext_param_page(mtd, chip, p))
> +                       pr_info("Failed to detect the extended param page.\n");
>         }
>
>         pr_info("ONFI flash detected\n");

Brian
