Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab3CNFKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 01:10:41 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:53692 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab3CNFKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 01:10:39 -0400
MIME-Version: 1.0
In-Reply-To: <1363229965-13128-4-git-send-email-b32955@freescale.com>
References: <1363229965-13128-1-git-send-email-b32955@freescale.com>
	<1363229965-13128-4-git-send-email-b32955@freescale.com>
Date: Wed, 13 Mar 2013 22:10:38 -0700
Message-ID: <CAN8TOE9aGckZ2PrCCPQe4ZgW6Aph3otXGohNuRPssu8f302xaA@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] mtd: add 4 Toshiba nand chips for the full-id case
From: Brian Norris <computersforpeace@gmail.com>
To: Huang Shijie <b32955@freescale.com>
Cc: dwmw2@infradead.org, artem.bityutskiy@linux.intel.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 7:59 PM, Huang Shijie <b32955@freescale.com> wrote:
> I have 4 Toshiba nand chips which can not be parsed out by the
> id data. We can not get the oob size from the id data. So add them
> as the full-id nand chips in the first of nand_flash_ids.
>
> The nand_get_flash_type() scans the full id nands firstly.
> If a full-id nand matchs, it will not continue to parse other
> non-full-id nand types, else it will continue to parse the non-full-id nands.
>
> Signed-off-by: Huang Shijie <b32955@freescale.com>
> ---
>  drivers/mtd/nand/nand_ids.c |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mtd/nand/nand_ids.c b/drivers/mtd/nand/nand_ids.c
> index 625bc89..38b8cee 100644
> --- a/drivers/mtd/nand/nand_ids.c
> +++ b/drivers/mtd/nand/nand_ids.c
> @@ -10,6 +10,7 @@
>   */
>  #include <linux/module.h>
>  #include <linux/mtd/nand.h>
> +#include <linux/sizes.h>
>
>  #define LP_OPTIONS NAND_SAMSUNG_LP_OPTIONS
>  #define LP_OPTIONS16 (LP_OPTIONS | NAND_BUSWIDTH_16)
> @@ -22,6 +23,27 @@
>   * extended chip ID.
>   */
>  struct nand_flash_dev nand_flash_ids[] = {
> +       /*
> +        * The full-id nands may share the same Device ID with the non-full-id
> +        * nands. In order to distinguish the two type nands, we put the
> +        * full-id nands in the first of the table. So the nand_get_flash_type()
> +        * scans the full id nands firstly. If a full-id nand matchs, it will
> +        * not continue to parse other non-full-id nand types, else it will
> +        * continue to parse the non-full-id nands.
> +        */

There are a few grammar/language issues (nands -> NAND chips, id ->
ID, firstly -> first). Also, I don't think you need to explain the
full search here. I would rewrite this whole paragraph as:

"Some incompatible NAND chips share device ID's and so must be listed
by full ID. We list them first so that we can easily identify the most
specific match."

> +       {"TC58NVG2S0F 4G 3.3V 8-bit",
> +               { .id = {0x98, 0xdc, 0x90, 0x26, 0x76, 0x15, 0x01, 0x08} },
> +                       SZ_4K, SZ_512, SZ_256K, 0, 224},
> +       {"TC58NVG3S0F 8G 3.3V 8-bit",
> +               { .id = {0x98, 0xd3, 0x90, 0x26, 0x76, 0x15, 0x02, 0x08} },
> +                       SZ_4K, SZ_1K, SZ_256K, 0, 232},
> +       {"TC58NVG5D2 32G 3.3V 8-bit",
> +               { .id = {0x98, 0xd7, 0x94, 0x32, 0x76, 0x56, 0x09, 0x00} },
> +                       SZ_8K, SZ_4K, SZ_1M, 0, 640},
> +       {"TC58NVG6D2 64G 3.3V 8-bit",
> +               { .id = {0x98, 0xde, 0x94, 0x82, 0x76, 0x56, 0x04, 0x20} },
> +                       SZ_8K, SZ_8K, SZ_2M, 0, 640},
> +
>         LEGACY_ID_NAND("NAND 4MiB 5V 8-bit",   0x6B, 512, 4, 0x2000, 0),
>         LEGACY_ID_NAND("NAND 4MiB 3,3V 8-bit", 0xE3, 512, 4, 0x2000, 0),
>         LEGACY_ID_NAND("NAND 4MiB 3,3V 8-bit", 0xE5, 512, 4, 0x2000, 0),

Brian
