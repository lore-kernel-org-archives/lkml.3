Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbaHRJdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:33:39 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:35993 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaHRJdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:33:37 -0400
MIME-Version: 1.0
In-Reply-To: <1408082761-15333-3-git-send-email-rogerable@realtek.com>
References: <1408082761-15333-1-git-send-email-rogerable@realtek.com>
	<1408082761-15333-3-git-send-email-rogerable@realtek.com>
Date: Mon, 18 Aug 2014 11:33:36 +0200
Message-ID: <CAPDyKFpwu_Zas+oBRnrsTzYoNYzn1mrWyBJ_LepgP+US-55h5Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] mmc: rtsx_usb_sdmmc: fix incorrect last byte in R2 response
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Roger <rogerable@realtek.com>
Cc: Chris Ball <chris@printf.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        Wei WANG <wei_wang@realsil.com.cn>, micky <micky_ching@realsil.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 August 2014 08:06,  <rogerable@realtek.com> wrote:
> From: Roger Tseng <rogerable@realtek.com>
>
> Current code erroneously fill the last byte of R2 response with an undefined
> value. In addition, the controller actually 'offloads' the last byte
> (CRC7, end bit) while receiving R2 response and thus it's impossible to get the
> actual value. This could cause mmc stack to obtain inconsistent CID from the
> same card after resume and misidentify it as a different card.
>
> Fix by assigning dummy CRC and end bit: {7'b0, 1} = 0x1 to the last byte of R2.
>
> Cc: <stable@vger.kernel.org> # v3.16+
> Fixes: c7f6558d84af ("mmc: Add realtek USB sdmmc host driver")
> Signed-off-by: Roger Tseng <rogerable@realtek.com>

Thanks! Applied for next.

Kind regards
Uffe


> ---
>  drivers/mmc/host/rtsx_usb_sdmmc.c |    7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/mmc/host/rtsx_usb_sdmmc.c b/drivers/mmc/host/rtsx_usb_sdmmc.c
> index 5d3766e792f0..d9153a7d160d 100644
> --- a/drivers/mmc/host/rtsx_usb_sdmmc.c
> +++ b/drivers/mmc/host/rtsx_usb_sdmmc.c
> @@ -435,6 +435,13 @@ static void sd_send_cmd_get_rsp(struct rtsx_usb_sdmmc *host,
>         }
>
>         if (rsp_type == SD_RSP_TYPE_R2) {
> +               /*
> +                * The controller offloads the last byte {CRC-7, end bit 1'b1}
> +                * of response type R2. Assign dummy CRC, 0, and end bit to the
> +                * byte(ptr[16], goes into the LSB of resp[3] later).
> +                */
> +               ptr[16] = 1;
> +
>                 for (i = 0; i < 4; i++) {
>                         cmd->resp[i] = get_unaligned_be32(ptr + 1 + i * 4);
>                         dev_dbg(sdmmc_dev(host), "cmd->resp[%d] = 0x%08x\n",
> --
> 1.7.10.4
>
