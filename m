Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbaHKNDP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:03:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33138 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbaHKNDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:03:14 -0400
Date: Mon, 11 Aug 2014 16:02:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: rogerable@realtek.com
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei_wang@realsil.com.cn
Subject: Re: [PATCH] mmc: rtsx: fix incorrect last byte in R2 response
Message-ID: <20140811130254.GP4856@mwanda>
References: <1407745936-18513-1-git-send-email-rogerable@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407745936-18513-1-git-send-email-rogerable@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 04:32:16PM +0800, rogerable@realtek.com wrote:
> From: Roger Tseng <rogerable@realtek.com>
> 
> Current code erroneously fill the last byte of R2 response with an undefined
> value. In addition, it is impossible to obtain the real values since the
> controller actually 'offloads' the last byte(CRC7, end bit) while receiving R2
> response. This could cause mmc stack to obtain inconsistent CID from the same
> card after resume and misidentify it as a different card.
> 
> Fix by assigning a dummy value 0x01 to the last byte of R2 response.
> 
> Signed-off-by: Roger Tseng <rogerable@realtek.com>
> ---
>  drivers/mmc/host/rtsx_pci_sdmmc.c |    1 +
>  drivers/mmc/host/rtsx_usb_sdmmc.c |    1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
> index dfde4a2..54849d8 100644
> --- a/drivers/mmc/host/rtsx_pci_sdmmc.c
> +++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
> @@ -412,6 +412,7 @@ static void sd_send_cmd_get_rsp(struct realtek_pci_sdmmc *host,
>  	}
>  
>  	if (rsp_type == SD_RSP_TYPE_R2) {
> +		ptr[16] = 1;

Avoid magic numbers like 16 and 0x1.

This is subtle enough that it deserves a comment.

		ptr[stat_idx] = 0x1 /* 0x1 chosen randomly */

>  		for (i = 0; i < 4; i++) {
>  			cmd->resp[i] = get_unaligned_be32(ptr + 1 + i * 4);
>  			dev_dbg(sdmmc_dev(host), "cmd->resp[%d] = 0x%08x\n",

There are a lot of magic numbers in this function.  We could get rid
of this i < 4 loop but doing:

		memcpy(cmd->resp, ptr + 1, resp_len);

Currently we don't use resp_len and the resp_len = 5 assignment is off
by one...  It should be resp_len = 4.  This function is quite ugly.

regards,
dan carpenter

