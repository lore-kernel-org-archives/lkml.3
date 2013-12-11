Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab3LKCZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 21:25:31 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:51652 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab3LKCZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 21:25:30 -0500
Date: Tue, 10 Dec 2013 18:25:26 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, angus.clark@st.com, linus.walleij@linaro.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH v3 33/36] mtd: st_spi_fsm: Supply the MX25xxx chip
 specific configuration call-back
Message-ID: <20131211022526.GO27149@ld-irv-0074.broadcom.com>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
 <1385727565-25794-34-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385727565-25794-34-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 12:19:22PM +0000, Lee Jones wrote:
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mtd/devices/st_spi_fsm.c | 84 ++++++++++++++++++++++++++++++++++++++++
>  drivers/mtd/devices/st_spi_fsm.h |  4 +-
>  2 files changed, 87 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
> index f1276e5..be66a49 100644
> --- a/drivers/mtd/devices/st_spi_fsm.c
> +++ b/drivers/mtd/devices/st_spi_fsm.c
> @@ -620,6 +645,65 @@ static int stfsm_prepare_rwe_seqs_default(struct stfsm *fsm)
>  	return 0;
>  }
>  
> +static int stfsm_mx25_config(struct stfsm *fsm)
> +{
> +	uint32_t flags = fsm->info->flags;
> +	uint32_t data_pads;
> +	uint8_t sta;
> +	int ret;
> +	bool soc_reset;
> +
> +	/* Disable support for 'WRITE_1_4_4' (limited to 20MHz which is of
> +	 * marginal benefit on our hardware and doesn't justify implementing
> +	 * different READ/WRITE frequencies).
> +	 */
> +	flags &= ~FLASH_FLAG_WRITE_1_4_4;

Huh? flags is a local variable, and you only use it for checking 32-bit
addressing mode in this function. So this flags modification is
effectively thrown away. Perhaps you meant

	fsm->info->flags &= ~FLASH_FLAG_WRITE_1_4_4;

? But then you're back to modifying static data (the device table)
through a per-instance reference. That's not good behavior. Rather,
couldn't you just remove this flag from the table entry in the first
place?

Brian
