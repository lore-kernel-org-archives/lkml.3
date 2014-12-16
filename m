Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750981AbaLPJ6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 04:58:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaLPJ6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 04:58:32 -0500
Message-ID: <549001F6.5080202@redhat.com>
Date: Tue, 16 Dec 2014 10:57:10 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgTGFuemVuZMO2cmZlcg==?= 
	<david.lanzendoerfer@o2s.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-mmc@vger.kernel.org,
        Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        Peter Griffin <peter.griffin@linaro.org>, Chen-Yu Tsai <wens@csie.org>,
        =?UTF-8?B?5p2O5oOz?= <lixiang@allwinnertech.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] mmc: sunxi: Reset behavior fix
References: <20141216003412.15488.54812.stgit@dizzy-6.o2s.ch> <20141216003756.15488.34861.stgit@dizzy-6.o2s.ch>
In-Reply-To: <20141216003756.15488.34861.stgit@dizzy-6.o2s.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 16-12-14 01:37, David Lanzendörfer wrote:
> When there is only one DES available the DMA performs a FIFO reset and waits until the reinitialization has been completed.
> Disabling the SDXC_IDMAC_DES0_DIC bit prevents the DMA from sending an interrupt after it has finished this reinitialization.
>
> The flags SDXC_IDMAC_DES0_FD and SDXC_IDMAC_DES0_LD are both required in order to use the controller with more than one DES.
>
> Signed-off-by: David Lanzendörfer <david.lanzendoerfer@o2s.ch>
> Reported-by: 李想 <lixiang@allwinnertech.com>
> ---
>   drivers/mmc/host/sunxi-mmc.c |   12 +++++++++++-
>   1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mmc/host/sunxi-mmc.c b/drivers/mmc/host/sunxi-mmc.c
> index 50bd3d2..5331c88 100644
> --- a/drivers/mmc/host/sunxi-mmc.c
> +++ b/drivers/mmc/host/sunxi-mmc.c
> @@ -310,7 +310,17 @@ static void sunxi_mmc_init_idma_des(struct sunxi_mmc_host *host,
>   	}
>
>   	pdes[0].config |= SDXC_IDMAC_DES0_FD;
> -	pdes[i - 1].config = SDXC_IDMAC_DES0_OWN | SDXC_IDMAC_DES0_LD;
> +
> +	/*
> +	 * When there is only one DES available the DMA performs a FIFO reset and waits
> +	 * until the reinitialization has been completed.
> +	 * Disabling the SDXC_IDMAC_DES0_DIC bit prevents the DMA from sending an interrupt
> +	 * after it has finished this reinitialization.
> +	 */
> +	pdes[i - 1].config = SDXC_IDMAC_DES0_OWN;
> +	pdes[i - 1].config |= SDXC_IDMAC_DES0_FD;
> +	pdes[i - 1].config |= SDXC_IDMAC_DES0_LD;
> +	pdes[i - 1].config &= ~SDXC_IDMAC_DES0_DIC;
>
>   	/*
>   	 * Avoid the io-store starting the idmac hitting io-mem before the

This is wrong. For one you are starting with an assignment, so you could just as well
set all the flags you want with a single line / assignment. Besides that you're setting
the FD flag, which should only be set for the first descriptor of a transfer, so for
multi descriptor transfers this is wrong.

Please see the patch which I send you which gets this right.

Regards,

Hans

