Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaKKVvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:51:43 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:49985 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaKKVvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:51:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Feng Kan <fkan@apm.com>, patches@apm.com, jassisingbrar@gmail.com,
        =devicetree@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hieu Le <hnle@apm.com>
Subject: Re: [PATCH 4/6] i2c: busses: add SLIMpro I2C device driver on APM X-Gene platform
Date: Tue, 11 Nov 2014 22:51:36 +0100
Message-ID: <1894616.4yY7dajl4R@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412726809-7525-5-git-send-email-fkan@apm.com>
References: <1412726809-7525-1-git-send-email-fkan@apm.com> <1412726809-7525-5-git-send-email-fkan@apm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:nGEQnSM43oBUy4g5N8jA6WNGDqGLIfe08nznGgyZAfG
 d6BgNjB+EvQhXHu7MqwLkRh15o7EzHWkfMv6b2VwGVMu2A//9n
 Mj4nuv2WCYgzpgNQuxnz9hQPN6WaO6BLwXQkXtE6TdFAgn3v+c
 GwAbfWMEbKlX2CtRXzMYOjTV2ZZvWTZ1IxLVtQZCPm7pu+FQf7
 ZDzBNob1b39FaGTV19bfL+iCQ/bC3e9w8CVkTkS93aRMFLx2lD
 2lDLVveJyPymPqZfa1SNlCK6NWf6fg+hiAeScTQafk4D2i0HRf
 KQsY6QCQKcMThoYUQPe85swr0D413HOG9uid1NTaJaSr5Sl8ls
 V6gcu2WTCi9zP1G0P8+A=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 October 2014 17:06:47 Feng Kan wrote:
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index 2e45ae3..a03042c 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -1009,6 +1009,15 @@ config I2C_CROS_EC_TUNNEL
>  	  connected there. This will work whatever the interface used to
>  	  talk to the EC (SPI, I2C or LPC).
>  
> +config I2C_XGENE_SLIMPRO
> +	tristate "APM X-Gene SoC I2C SLIMpro devices support"
> +	depends on ARCH_XGENE && XGENE_SLIMPRO_MBOX

Why this dependency on XGENE_SLIMPRO_MBOX?

Better replace it with a dependency on MAILBOX.

> +	} else {
> +		spin_lock_irqsave(&ctx->lock, flags);
> +		ctx->i2c_rx_poll = 1;
> +		for (count = SLIMPRO_I2C_WAIT_COUNT; count > 0; count--) {
> +			if (ctx->i2c_rx_poll == 0)
> +				break;
> +			udelay(100);
> +		}

No, you can't block the CPU for an extended amount of time with
interrupts disabled. Please kill this code.

> +	ctx->resp_msg = data;
> +	if (ctx->mbox_client.tx_block)
> +		init_completion(&ctx->rd_complete);

reinit_completion()?

> +static int slimpro_i2c_blkrd(struct slimpro_i2c_dev *ctx, u32 chip, u32 addr,
> +				u32 addrlen, u32 protocol, u32 readlen,
> +				u32 with_data_len, void *data)
> +{
> +	dma_addr_t paddr;
> +	u32 msg[3];
> +	int rc;
> +
> +	paddr = dma_map_single(ctx->dev, ctx->dma_buffer, readlen,
> +			       DMA_FROM_DEVICE);

ctx->dev is probably the wrong device here. The i2c controller is not
DMA capable itself, you need to have a pointer to the device that actually
performs the DMA here.


> +	/* Request mailbox channel */
> +	cl->dev = &pdev->dev;
> +	cl->rx_callback = slimpro_i2c_rx_cb;
> +	cl->tx_done = slimpro_i2c_tx_done;
> +	cl->tx_block = true;
> +	cl->tx_tout = SLIMPRO_OP_TO_MS;
> +	cl->knows_txdone = false;
> +	cl->chan_name = "i2c-slimpro";
> +	ctx->mbox_chan = mbox_request_channel(cl);

This is not the correct interface.

> +	rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
> +	if (rc)
> +		dev_warn(&pdev->dev, "Unable to set dma mask\n");

Are you sure that this is the correct device to perform the DMA?

Moreover, the mask doesn't match the usage: the slimpro_i2c_blkrd
function passes in only the lower 32 bit of the address, which would
be DMA_BIT_MASK(32).

> +#ifdef CONFIG_OF
> +static struct of_device_id xgene_slimpro_i2c_id[] = {
> +	{.compatible = "apm,xgene-slimpro-i2c" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, xgene_slimpro_i2c_dt_ids);
> +#endif
> +
> +static struct platform_driver xgene_slimpro_i2c_driver = {
> +	.probe	= xgene_slimpro_i2c_probe,
> +	.remove	= xgene_slimpro_i2c_remove,
> +	.driver	= {
> +		.name	= XGENE_SLIMPRO_I2C,
> +		.owner	= THIS_MODULE,
> +		.of_match_table = of_match_ptr(xgene_slimpro_i2c_id)
> +	},
> +};

The driver only supports DT, so just drop the #ifdef and the of_match_ptr().

