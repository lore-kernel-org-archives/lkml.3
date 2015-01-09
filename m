Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbbAISwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 13:52:18 -0500
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:60701 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751067AbbAISwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 13:52:16 -0500
MIME-Version: 1.0
In-Reply-To: <20141111203237.GB6443@katana>
References: <1412726809-7525-1-git-send-email-fkan@apm.com>
	<1412726809-7525-5-git-send-email-fkan@apm.com>
	<20141111203237.GB6443@katana>
Date: Fri, 9 Jan 2015 10:52:15 -0800
Message-ID: <CAL85gmB172hgTCHUQ=sshAAYjOwpNKc=YdovjfTFXfnW7LJTLQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] i2c: busses: add SLIMpro I2C device driver on APM
 X-Gene platform
From: Feng Kan <fkan@apm.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: patches <patches@apm.com>, jassisingbrar@gmail.com,
        =devicetree@vger.kernel.org, linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hieu Le <hnle@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 12:32 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> On Tue, Oct 07, 2014 at 05:06:47PM -0700, Feng Kan wrote:
>> Add SLIMpro I2C device driver on APM X-Gene platform. This I2C
>> device driver use the SLIMpro Mailbox driver to tunnel message to
>> the SLIMpro coprocessor to do the work of accessing I2C components.
>>
>> Signed-off-by: Feng Kan <fkan@apm.com>
>> Signed-off-by: Hieu Le <hnle@apm.com>
>
> Thank you for this submission!
>
>> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
>> index 2e45ae3..a03042c 100644
>> --- a/drivers/i2c/busses/Kconfig
>> +++ b/drivers/i2c/busses/Kconfig
>> @@ -1009,6 +1009,15 @@ config I2C_CROS_EC_TUNNEL
>>         connected there. This will work whatever the interface used to
>>         talk to the EC (SPI, I2C or LPC).
>>
>> +config I2C_XGENE_SLIMPRO
>> +     tristate "APM X-Gene SoC I2C SLIMpro devices support"
>> +     depends on ARCH_XGENE && XGENE_SLIMPRO_MBOX
>> +     help
>> +       Enable I2C bus access using the APM X-Gene SoC SLIMpro
>> +       co-processor. The I2C device access the I2C bus via the X-Gene
>> +       to SLIMpro (On chip coprocessor) mailbox mechanism.
>> +       If unsure, say N.
>> +
>
> I guess this is a driver for embedded? If so, please sort it properly.
Sorry, having let this dangle for  a while.  I will fix up comments and submit
another version. I can move this to embedded, however Xgene is
suppose to be a server class chip.
>
>>  config SCx200_ACB
>>       tristate "Geode ACCESS.bus support"
>>       depends on X86_32 && PCI
>> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
>> index 49bf07e..22b5f0c 100644
>> --- a/drivers/i2c/busses/Makefile
>> +++ b/drivers/i2c/busses/Makefile
>> @@ -99,6 +99,7 @@ obj-$(CONFIG_I2C_CROS_EC_TUNNEL)    += i2c-cros-ec-tunnel.o
>>  obj-$(CONFIG_I2C_ELEKTOR)    += i2c-elektor.o
>>  obj-$(CONFIG_I2C_PCA_ISA)    += i2c-pca-isa.o
>>  obj-$(CONFIG_I2C_SIBYTE)     += i2c-sibyte.o
>> +obj-$(CONFIG_I2C_XGENE_SLIMPRO) += i2c-xgene-slimpro.o
>
> Ditto.
>
>>  obj-$(CONFIG_SCx200_ACB)     += scx200_acb.o
>>
>>  ccflags-$(CONFIG_I2C_DEBUG_BUS) := -DDEBUG
>> diff --git a/drivers/i2c/busses/i2c-xgene-slimpro.c b/drivers/i2c/busses/i2c-xgene-slimpro.c
>> new file mode 100644
>> index 0000000..2cf6c33
>> --- /dev/null
>> +++ b/drivers/i2c/busses/i2c-xgene-slimpro.c
>> @@ -0,0 +1,531 @@
>> +/*
>> + * X-Gene SLIMpro I2C Driver
>> + *
>> + * Copyright (c) 2014, Applied Micro Circuits Corporation
>> + * Author: Feng Kan <fkan@apm.com>
>> + * Author: Hieu Le <hnle@apm.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License as
>> + * published by the Free Software Foundation; either version 2 of
>> + * the License, or (at your option) any later version.
>
> The license preamble and MODULE_LICENSE do not match!
>
>> +#include <linux/module.h>
>> +#include <linux/version.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/of.h>
>> +#include <linux/i2c.h>
>> +#include <linux/mailbox_client.h>
>> +#include <linux/delay.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/dma-mapping.h>
>
> Please sort the includes.
>
>> +
>> +#define XGENE_SLIMPRO_I2C            "xgene-slimpro-i2c"
>
> Only used once, not really needed
>
>> +
>> +#define SLIMPRO_I2C_WAIT_COUNT               10000
>> +
>> +#define SLIMPRO_OP_TO_MS             1000    /* Operation time out in ms */
>
> *_TOUT_* or *_TIMEOUT_*. TO sounds like a conversion, from op to ms :)
>
>> +#define SLIMPRO_IIC_BUS                      1
>
> What does this '1' mean?
>
>> +static int start_i2c_msg_xfer(struct slimpro_i2c_dev *ctx)
>> +{
>> +     int count;
>> +     unsigned long flags;
>> +
>> +     if (ctx->mbox_client.tx_block) {
>> +             if (!wait_for_completion_timeout(&ctx->rd_complete,
>> +                                              msecs_to_jiffies
>> +                                              (SLIMPRO_OP_TO_MS)))
>> +                     return -EIO;
>
> That should be -ETIMEDOUT, no?
>
>> +     } else {
>> +             spin_lock_irqsave(&ctx->lock, flags);
>> +             ctx->i2c_rx_poll = 1;
>> +             for (count = SLIMPRO_I2C_WAIT_COUNT; count > 0; count--) {
>> +                     if (ctx->i2c_rx_poll == 0)
>> +                             break;
>> +                     udelay(100);
>> +             }
>> +
>> +             if (count == 0) {
>> +                     ctx->i2c_rx_poll = 0;
>> +                     ctx->mbox_client.tx_block = true;
>> +                     spin_unlock_irqrestore(&ctx->lock, flags);
>> +                     return -EIO;
>
> ditto.
>
>> +             }
>> +             ctx->mbox_client.tx_block = true;
>> +             spin_unlock_irqrestore(&ctx->lock, flags);
>> +     }
>> +
>> +     /* Check of invalid data or no device */
>> +     if (*ctx->resp_msg == 0xffffffff)
>> +             return -ENODEV;
>> +
>> +     return 0;
>> +}
>> +
>> +static int slimpro_i2c_blkrd(struct slimpro_i2c_dev *ctx, u32 chip, u32 addr,
>> +                             u32 addrlen, u32 protocol, u32 readlen,
>> +                             u32 with_data_len, void *data)
>> +{
>> +     dma_addr_t paddr;
>> +     u32 msg[3];
>> +     int rc;
>> +
>> +     paddr = dma_map_single(ctx->dev, ctx->dma_buffer, readlen,
>> +                            DMA_FROM_DEVICE);
>> +     if (dma_mapping_error(ctx->dev, paddr)) {
>> +             dev_err(&ctx->adapter.dev, "Error in mapping dma buffer %p\n",
>> +                     ctx->dma_buffer);
>> +             rc = -EIO;
>
> Return the err value from dma_mapping_error?
>
>> +             goto err;
>> +     }
>> +
>> +     if (irqs_disabled())
>> +             ctx->mbox_client.tx_block = false;
>> +
>> +     msg[0] = SLIMPRO_IIC_ENCODE_MSG(SLIMPRO_IIC_BUS, chip,
>> +                                     SLIMPRO_IIC_READ, protocol, addrlen,
>> +                                     readlen);
>> +     msg[1] = SLIMPRO_IIC_ENCODE_FLAG_BUFADDR |
>> +              SLIMPRO_IIC_ENCODE_FLAG_WITH_DATA_LEN(with_data_len) |
>> +              SLIMPRO_IIC_ENCODE_UPPER_BUFADDR(paddr) |
>> +              SLIMPRO_IIC_ENCODE_ADDR(addr);
>> +     msg[2] = (u32) paddr;
>> +     ctx->resp_msg = msg;
>> +
>> +     if (ctx->mbox_client.tx_block)
>> +             init_completion(&ctx->rd_complete);
>
> reinit_completion? and init_completion in probe?
>
>> +
>> +     rc = mbox_send_message(ctx->mbox_chan, &msg);
>> +     if (rc < 0)
>> +             goto err_unmap;
>> +
>> +     rc = start_i2c_msg_xfer(ctx);
>> +
>> +     /* Copy to destination */
>> +     memcpy(data, ctx->dma_buffer, readlen);
>> +
>> +err_unmap:
>> +     dma_unmap_single(ctx->dev, paddr, readlen, DMA_FROM_DEVICE);
>> +err:
>> +     ctx->resp_msg = NULL;
>> +     return rc;
>> +}
>> +
>> +static int slimpro_i2c_blkwr(struct slimpro_i2c_dev *ctx, u32 chip,
>> +                          u32 addr, u32 addrlen, u32 protocol, u32 writelen,
>> +                          void *data)
>> +{
>> +     dma_addr_t paddr;
>> +     u32 msg[3];
>> +     int rc;
>> +
>> +     memcpy(ctx->dma_buffer, data, writelen);
>> +     paddr = dma_map_single(ctx->dev, ctx->dma_buffer, writelen,
>> +                            DMA_TO_DEVICE);
>> +     if (dma_mapping_error(ctx->dev, paddr)) {
>> +             dev_err(&ctx->adapter.dev, "Error in mapping dma buffer %p\n",
>> +                     ctx->dma_buffer);
>> +             rc = -EIO;
>
> same as above
>
>> +             goto err;
>> +     }
>> +
>> +     if (irqs_disabled())
>> +             ctx->mbox_client.tx_block = false;
>> +
>> +     msg[0] = SLIMPRO_IIC_ENCODE_MSG(SLIMPRO_IIC_BUS, chip,
>> +                                     SLIMPRO_IIC_WRITE, protocol, addrlen,
>> +                                     writelen);
>> +     msg[1] = SLIMPRO_IIC_ENCODE_FLAG_BUFADDR |
>> +              SLIMPRO_IIC_ENCODE_UPPER_BUFADDR(paddr) |
>> +              SLIMPRO_IIC_ENCODE_ADDR(addr);
>> +     msg[2] = (u32) paddr;
>> +     ctx->resp_msg = msg;
>> +
>> +     if (ctx->mbox_client.tx_block)
>> +             init_completion(&ctx->rd_complete);
>
> ditto
>
>> +
>> +     rc = mbox_send_message(ctx->mbox_chan, &msg);
>> +     if (rc < 0)
>> +             goto err_unmap;
>> +
>> +     rc = start_i2c_msg_xfer(ctx);
>> +
>> +err_unmap:
>> +     dma_unmap_single(ctx->dev, paddr, writelen, DMA_TO_DEVICE);
>> +err:
>> +     ctx->resp_msg = NULL;
>> +     return rc;
>> +}
>> +
>> +static struct platform_driver xgene_slimpro_i2c_driver = {
>> +     .probe  = xgene_slimpro_i2c_probe,
>> +     .remove = xgene_slimpro_i2c_remove,
>> +     .driver = {
>> +             .name   = XGENE_SLIMPRO_I2C,
>> +             .owner  = THIS_MODULE,
>
> Not needed.
>
>> +             .of_match_table = of_match_ptr(xgene_slimpro_i2c_id)
>> +     },
>> +};
>> +
>> +module_platform_driver(xgene_slimpro_i2c_driver);
>> +
>> +MODULE_DESCRIPTION("APM X-Gene SLIMpro I2C driver");
>> +MODULE_LICENSE("GPL v2");
>
> So, only minor stuff. Looking good already to me.
Will fix the rest of the comments, thanks
>
> Thanks,
>
>    Wolfram
>
