Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbaENKRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 06:17:21 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:51950 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205AbaENKRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 06:17:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140511100502.1491.qmail@ns.horizon.com>
References: <20140511100211.1334.qmail@ns.horizon.com>
	<20140511100502.1491.qmail@ns.horizon.com>
Date: Wed, 14 May 2014 12:17:15 +0200
Message-ID: <CAPDyKFo9xZ-z6eM0zG2A+=Bwj0EVyGxm=m28Lh9cHPSB+8qq1w@mail.gmail.com>
Subject: Re: [PATCH 2/3] drivers/mmc/host/mmc_spi.c: Use get/put_unaligned_be32
From: Ulf Hansson <ulf.hansson@linaro.org>
To: George Spelvin <linux@horizon.com>
Cc: Pavel Machek <pavel@ucw.cz>, arik@wizery.com, david.gnedt@davizone.at,
        eliad@wizery.com, jan.nikitenko@gmail.com,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        linux-wireless@vger.kernel.org, John Linville <linville@tuxdriver.com>,
        luca@coelho.fi, Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 May 2014 12:05, George Spelvin <linux@horizon.com> wrote:
> Very minor source and binary size reduction.
>
> Signed-off-by: George Spelvin <linux@horizon.com>
> ---
> I spotted this while making the previous crc7 change.
>
> This looks simple enough, but I don't actually have one of these devices to test.
> At least one other careful desk-check is solicited.

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Feel free to take this through the wireless tree as well. I assumes
it's that same patchset as the other spi related fixes?

Kind regards
Ulf Hansson

>
>  drivers/mmc/host/mmc_spi.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
> index 338e2202ea..cc8d4a6099 100644
> --- a/drivers/mmc/host/mmc_spi.c
> +++ b/drivers/mmc/host/mmc_spi.c
> @@ -448,7 +448,6 @@ mmc_spi_command_send(struct mmc_spi_host *host,
>  {
>         struct scratch          *data = host->data;
>         u8                      *cp = data->status;
> -       u32                     arg = cmd->arg;
>         int                     status;
>         struct spi_transfer     *t;
>
> @@ -465,14 +464,12 @@ mmc_spi_command_send(struct mmc_spi_host *host,
>          * We init the whole buffer to all-ones, which is what we need
>          * to write while we're reading (later) response data.
>          */
> -       memset(cp++, 0xff, sizeof(data->status));
> +       memset(cp, 0xff, sizeof(data->status));
>
> -       *cp++ = 0x40 | cmd->opcode;
> -       *cp++ = (u8)(arg >> 24);
> -       *cp++ = (u8)(arg >> 16);
> -       *cp++ = (u8)(arg >> 8);
> -       *cp++ = (u8)arg;
> -       *cp++ = crc7_be(0, &data->status[1], 5) | 0x01;
> +       cp[1] = 0x40 | cmd->opcode;
> +       put_unaligned_be32(cmd->arg, cp+2);
> +       cp[6] = crc7_be(0, cp+1, 5) | 0x01;
> +       cp += 7;
>
>         /* Then, read up to 13 bytes (while writing all-ones):
>          *  - N(CR) (== 1..8) bytes of all-ones
> @@ -711,10 +708,7 @@ mmc_spi_writeblock(struct mmc_spi_host *host, struct spi_transfer *t,
>          * so we have to cope with this situation and check the response
>          * bit-by-bit. Arggh!!!
>          */
> -       pattern  = scratch->status[0] << 24;
> -       pattern |= scratch->status[1] << 16;
> -       pattern |= scratch->status[2] << 8;
> -       pattern |= scratch->status[3];
> +       pattern = get_unaligned_be32(scratch->status);
>
>         /* First 3 bit of pattern are undefined */
>         pattern |= 0xE0000000;
> --
> 1.9.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
