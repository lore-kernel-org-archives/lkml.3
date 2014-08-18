Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbaHRJdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:33:17 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:62384 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaHRJdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:33:15 -0400
MIME-Version: 1.0
In-Reply-To: <1408082761-15333-2-git-send-email-rogerable@realtek.com>
References: <1408082761-15333-1-git-send-email-rogerable@realtek.com>
	<1408082761-15333-2-git-send-email-rogerable@realtek.com>
Date: Mon, 18 Aug 2014 11:33:15 +0200
Message-ID: <CAPDyKFrd8VzoHrYE17xZEncnfHquC5xBbj_ncHSw08WQHjYK8w@mail.gmail.com>
Subject: Re: [PATCH 1/2] mmc: rtsx_pci_sdmmc: fix incorrect last byte in R2 response
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

Thanks! Applied for next.

Kind regards
Uffe

>
> Cc: <stable@vger.kernel.org> # v3.8+
> Fixes: ff984e57d36e ("mmc: Add realtek pcie sdmmc host driver")
> Signed-off-by: Roger Tseng <rogerable@realtek.com>
> ---
>  drivers/mmc/host/rtsx_pci_sdmmc.c |    7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
> index dfde4a210238..b2537e2f26b1 100644
> --- a/drivers/mmc/host/rtsx_pci_sdmmc.c
> +++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
> @@ -412,6 +412,13 @@ static void sd_send_cmd_get_rsp(struct realtek_pci_sdmmc *host,
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
