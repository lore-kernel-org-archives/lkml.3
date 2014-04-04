Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbaDDKFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 06:05:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36453 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbaDDKFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 06:05:14 -0400
Message-ID: <533E839C.9090500@ti.com>
Date: Fri, 4 Apr 2014 15:34:12 +0530
From: sourav <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Yuan Yao <yao.yuan@freescale.com>
CC: <wsa@the-dreams.de>, <marex@denx.de>, <mark.rutland@arm.com>,
        <shawn.guo@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] i2c: add DMA support for freescale i2c driver
References: <1396579272-19542-1-git-send-email-yao.yuan@freescale.com> <1396579272-19542-2-git-send-email-yao.yuan@freescale.com> <533E8033.70904@ti.com>
In-Reply-To: <533E8033.70904@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> +
>> +    dma->chan_tx = dma_request_slave_channel(dev, "tx");
>> +    return 0;

To be more clear,
return here looks to be some leftover.

> ?? Looks to be some leftover?
>> +    if (!dma->chan_tx) {
>> +        dev_info(dev, "DMA tx channel request failed\n");
>> +        ret = -ENODEV;
>> +        goto fail_al;
>> +    }
>> +
>> +    dma_sconfig.dst_addr = phy_addr +
>> +                (IMX_I2C_I2DR<<  i2c_imx->hwdata->regshift);
>> +    dma_sconfig.dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
>> +    dma_sconfig.dst_maxburst = 1;
>> +    dma_sconfig.direction = DMA_MEM_TO_DEV;
>> +    ret = dmaengine_slave_config(dma->chan_tx,&dma_sconfig);
>> +    if (ret<  0) {
>> +        dev_info(dev, "DMA slave config failed, err = %d\n", ret);
>> +        goto fail_tx;
>> +    }
>> +
>> +    dma->chan_rx = dma_request_slave_channel(dev, "rx");
>> +    if (!dma->chan_rx) {
>> +        dev_info(dev, "DMA rx channel request failed\n");
>> +        ret = -ENODEV;
>> +        goto fail_tx;
>> +    }
>> +
>> +    dma_sconfig.src_addr = phy_addr +
>> +                (IMX_I2C_I2DR<<  i2c_imx->hwdata->regshift);
>> +    dma_sconfig.src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
>> +    dma_sconfig.src_maxburst = 1;
>> +    dma_sconfig.direction = DMA_DEV_TO_MEM;
>> +    ret = dmaengine_slave_config(dma->chan_rx,&dma_sconfig);
>> +    if (ret<  0) {
>> +        dev_info(dev, "DMA slave config failed, err = %d\n", ret);
>> +        goto fail_rx;
>> +    }
>> +
>> +    i2c_imx->dma = dma;
>> +
>> +    init_completion(&dma->cmd_complete);
>> +
>> +    return 0;
>> +
>> +fail_rx:
>> +    dma_release_channel(dma->chan_rx);
>> +fail_tx:
>> +    dma_release_channel(dma->chan_tx);
>> +fail_al:
>> +    devm_kfree(dev, dma);
>> +
>> +    return ret;
>> +}
>> +
>> +static void i2c_imx_dma_callback(void *arg)
>> +{
>> +    struct imx_i2c_struct *i2c_imx = (struct imx_i2c_struct *)arg;
>> +    struct imx_i2c_dma *dma = i2c_imx->dma;
>> +
>> +    dma_unmap_single(dma->chan_using->device->dev, dma->dma_buf,
>> +            dma->dma_len, dma->dma_data_dir);
>> +    complete(&dma->cmd_complete);
>> +}
>> +
>> +static int i2c_imx_dma_xfer(struct imx_i2c_struct *i2c_imx,
>> +                    struct i2c_msg *msgs)
>> +{
>> +    struct imx_i2c_dma *dma = i2c_imx->dma;
>> +    struct dma_async_tx_descriptor *txdesc;
>> +    struct device *dev =&i2c_imx->adapter.dev;
>> +
>> +    dma->dma_buf = dma_map_single(dma->chan_using->device->dev, 
>> msgs->buf,
>> +                    dma->dma_len, dma->dma_data_dir);
>> +    if (dma_mapping_error(dma->chan_using->device->dev, 
>> dma->dma_buf)) {
>> +        dev_err(dev, "DMA mapping failed\n");
>> +        return -EINVAL;
>> +    }
>> +
>> +    txdesc = dmaengine_prep_slave_single(dma->chan_using, dma->dma_buf,
>> +                    dma->dma_len, dma->dma_transfer_dir,
>> +                    DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>> +    if (!txdesc) {
>> +        dev_err(dev, "Not able to get desc for DMA xfer\n");
>> +        dma_unmap_single(dma->chan_using->device->dev, dma->dma_buf,
>> +                    dma->dma_len, dma->dma_data_dir);
>> +        return -EINVAL;
>> +    }
>> +
>> +    txdesc->callback = i2c_imx_dma_callback;
>> +    txdesc->callback_param = i2c_imx;
>> +    dmaengine_submit(txdesc);
>> +    dma_async_issue_pending(dma->chan_using);
>> +
>> +    return 0;
>> +}
>> +
>> +static void i2c_imx_dma_free(struct imx_i2c_struct *i2c_imx)
>> +{
>> +    struct imx_i2c_dma *dma = i2c_imx->dma;
>> +
>> +    dma->dma_buf = 0;
>> +    dma->dma_len = 0;
>> +
>> +    dma_release_channel(dma->chan_tx);
>> +    dma->chan_tx = NULL;
>> +
>> +    dma_release_channel(dma->chan_rx);
>> +    dma->chan_rx = NULL;
>> +
>> +    dma->chan_using = NULL;
>> +}
>> +
>>   /** Functions for IMX I2C adapter driver 
>> ***************************************
>>   
>> *******************************************************************************/
>>
>> @@ -334,6 +483,11 @@ static int i2c_imx_start(struct imx_i2c_struct 
>> *i2c_imx)
>>
>>       temp |= I2CR_IIEN | I2CR_MTX | I2CR_TXAK;
>>       imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
>> +
>> +    temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
>> +    temp&= ~I2CR_DMAEN;
>> +    imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
>> +
>>       return result;
>>   }
>>
>> @@ -427,44 +581,101 @@ static irqreturn_t i2c_imx_isr(int irq, void 
>> *dev_id)
>>
>>   static int i2c_imx_write(struct imx_i2c_struct *i2c_imx, struct 
>> i2c_msg *msgs)
>>   {
>> -    int i, result;
>> +    int i, result, timeout = IMX_I2C_DMA_TIMEOUT;
>> +    unsigned int temp = 0;
>> +    struct imx_i2c_dma *dma = i2c_imx->dma;
>> +    struct device *dev =&i2c_imx->adapter.dev;
>>
>> -    dev_dbg(&i2c_imx->adapter.dev, "<%s>  write slave address: 
>> addr=0x%x\n",
>> +    dev_dbg(dev, "<%s>  write slave address: addr=0x%x\n",
>>           __func__, msgs->addr<<  1);
>> +    if (dma&&  msgs->len>= IMX_I2C_DMA_THRESHOLD) {
>> +        reinit_completion(&i2c_imx->dma->cmd_complete);
>> +        dma->chan_using = dma->chan_tx;
>> +        dma->dma_transfer_dir = DMA_MEM_TO_DEV;
>> +        dma->dma_data_dir = DMA_TO_DEVICE;
>> +        dma->dma_len = msgs->len - 1;
>> +        result = i2c_imx_dma_xfer(i2c_imx, msgs);
>> +        if (result)
>> +            return result;
>>
>> -    /* write slave address */
>> -    imx_i2c_write_reg(msgs->addr<<  1, i2c_imx, IMX_I2C_I2DR);
>> -    result = i2c_imx_trx_complete(i2c_imx);
>> -    if (result)
>> -        return result;
>> -    result = i2c_imx_acked(i2c_imx);
>> -    if (result)
>> -        return result;
>> -    dev_dbg(&i2c_imx->adapter.dev, "<%s>  write data\n", __func__);
>> +        temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
>> +        temp |= I2CR_DMAEN;
>> +        imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
>>
>> -    /* write data */
>> -    for (i = 0; i<  msgs->len; i++) {
>> -        dev_dbg(&i2c_imx->adapter.dev,
>> -            "<%s>  write byte: B%d=0x%X\n",
>> -            __func__, i, msgs->buf[i]);
>> -        imx_i2c_write_reg(msgs->buf[i], i2c_imx, IMX_I2C_I2DR);
>> +        /* write slave address */
>> +        imx_i2c_write_reg(msgs->addr<<  1, i2c_imx, IMX_I2C_I2DR);
>> +        result = wait_for_completion_interruptible_timeout(
>> + &i2c_imx->dma->cmd_complete,
>> +                    msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT));
>> +        if (result<= 0) {
>> +            dmaengine_terminate_all(dma->chan_using);
>> +            if (result)
>> +                return result;
>> +            else
>> +                return -ETIMEDOUT;
>> +        }
>> +
>> +        /* waiting for Transfer complete. */
>> +        while (timeout--) {
>> +            temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
>> +            if (temp&  I2SR_ICF)
>> +                break;
>> +            udelay(10);
>> +        }
>> +
>> +        if (!timeout)
>> +            return -ETIMEDOUT;
>> +        temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
>> +        temp&= ~I2CR_DMAEN;
>> +        imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
>> +
>> +        /* write the last byte */
>> +        imx_i2c_write_reg(msgs->buf[msgs->len-1],
>> +                    i2c_imx, IMX_I2C_I2DR);
>>           result = i2c_imx_trx_complete(i2c_imx);
>>           if (result)
>>               return result;
>> +
>> +        result = i2c_imx_acked(i2c_imx);
>> +        if (result)
>> +            return result;
>> +    } else {
>> +        /* write slave address */
>> +        imx_i2c_write_reg(msgs->addr<<  1, i2c_imx, IMX_I2C_I2DR);
>> +        result = i2c_imx_trx_complete(i2c_imx);
>> +        if (result)
>> +            return result;
>> +
>>           result = i2c_imx_acked(i2c_imx);
>>           if (result)
>>               return result;
>> +
>> +        dev_dbg(dev, "<%s>  write data\n", __func__);
>> +
>> +        /* write data */
>> +        for (i = 0; i<  msgs->len; i++) {
>> +            dev_dbg(dev, "<%s>  write byte: B%d=0x%X\n",
>> +                __func__, i, msgs->buf[i]);
>> +            imx_i2c_write_reg(msgs->buf[i], i2c_imx, IMX_I2C_I2DR);
>> +            result = i2c_imx_trx_complete(i2c_imx);
>> +            if (result)
>> +                return result;
>> +            result = i2c_imx_acked(i2c_imx);
>> +            if (result)
>> +                return result;
>> +        }
>>       }
>>       return 0;
>>   }
>>
>>   static int i2c_imx_read(struct imx_i2c_struct *i2c_imx, struct 
>> i2c_msg *msgs)
>>   {
>> -    int i, result;
>> +    int i, result, timeout = IMX_I2C_DMA_TIMEOUT;
>>       unsigned int temp;
>> +    struct imx_i2c_dma *dma = i2c_imx->dma;
>> +    struct device *dev =&i2c_imx->adapter.dev;
>>
>> -    dev_dbg(&i2c_imx->adapter.dev,
>> -        "<%s>  write slave address: addr=0x%x\n",
>> +    dev_dbg(dev, "<%s>  write slave address: addr=0x%x\n",
>>           __func__, (msgs->addr<<  1) | 0x01);
>>
>>       /* write slave address */
>> @@ -476,7 +687,7 @@ static int i2c_imx_read(struct imx_i2c_struct 
>> *i2c_imx, struct i2c_msg *msgs)
>>       if (result)
>>           return result;
>>
>> -    dev_dbg(&i2c_imx->adapter.dev, "<%s>  setup bus\n", __func__);
>> +    dev_dbg(dev, "<%s>  setup bus\n", __func__);
>>
>>       /* setup bus to read data */
>>       temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
>> @@ -486,35 +697,81 @@ static int i2c_imx_read(struct imx_i2c_struct 
>> *i2c_imx, struct i2c_msg *msgs)
>>       imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
>>       imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR); /* dummy read */
>>
>> -    dev_dbg(&i2c_imx->adapter.dev, "<%s>  read data\n", __func__);
>> +    dev_dbg(dev, "<%s>  read data\n", __func__);
>>
>> -    /* read data */
>> -    for (i = 0; i<  msgs->len; i++) {
>> -        result = i2c_imx_trx_complete(i2c_imx);
>> +    if (dma&&  msgs->len>= IMX_I2C_DMA_THRESHOLD) {
>> +        temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
>> +        temp |= I2CR_DMAEN;
>> +        imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
>> +
>> +        reinit_completion(&i2c_imx->dma->cmd_complete);
>> +        dma->chan_using = dma->chan_rx;
>> +        dma->dma_transfer_dir = DMA_DEV_TO_MEM;
>> +        dma->dma_data_dir = DMA_FROM_DEVICE;
>> +        dma->dma_len = msgs->len - 2;
>> +        result = i2c_imx_dma_xfer(i2c_imx, msgs);
>>           if (result)
>>               return result;
>> -        if (i == (msgs->len - 1)) {
>> -            /* It must generate STOP before read I2DR to prevent
>> -               controller from generating another clock cycle */
>> -            dev_dbg(&i2c_imx->adapter.dev,
>> -                "<%s>  clear MSTA\n", __func__);
>> -            temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
>> -            temp&= ~(I2CR_MSTA | I2CR_MTX);
>> -            imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
>> -            i2c_imx_bus_busy(i2c_imx, 0);
>> -            i2c_imx->stopped = 1;
>> -        } else if (i == (msgs->len - 2)) {
>> -            dev_dbg(&i2c_imx->adapter.dev,
>> -                "<%s>  set TXAK\n", __func__);
>> -            temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
>> -            temp |= I2CR_TXAK;
>> -            imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
>> +
>> +        result = wait_for_completion_interruptible_timeout(
>> + &i2c_imx->dma->cmd_complete,
>> +                    msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT));
>> +        if (result<= 0) {
>> +            dmaengine_terminate_all(dma->chan_using);
>> +            if (result)
>> +                return result;
>> +            else
>> +                return -ETIMEDOUT;
>>           }
>> -        msgs->buf[i] = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
>> -        dev_dbg(&i2c_imx->adapter.dev,
>> -            "<%s>  read byte: B%d=0x%X\n",
>> -            __func__, i, msgs->buf[i]);
>> +
>> +        /* waiting for Transfer complete. */
>> +        while (timeout--) {
>> +            temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
>> +            if (temp&  I2SR_ICF)
>> +                break;
>> +            udelay(10);
>> +        }
>> +
>> +        if(!timeout)
>> +            return -ETIMEDOUT;
>> +        temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
>> +        temp&= ~I2CR_DMAEN;
>> +        imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
>> +    } else {
>> +        /* read data */
>> +        for (i = 0; i<  msgs->len - 2; i++) {
>> +            result = i2c_imx_trx_complete(i2c_imx);
>> +            if (result)
>> +                return result;
>> +            msgs->buf[i] = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
>> +            dev_dbg(dev, "<%s>  read byte: B%d=0x%X\n",
>> +                __func__, i, msgs->buf[i]);
>> +        }
>> +        result = i2c_imx_trx_complete(i2c_imx);
>>       }
>> +
>> +    /* read n-1 byte data */
>> +    temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
>> +    temp |= I2CR_TXAK;
>> +    imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
>> +
>> +    msgs->buf[msgs->len-2] = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
>> +    /* read n byte data */
>> +    result = i2c_imx_trx_complete(i2c_imx);
>> +    if (result)
>> +        return result;
>> +
>> +    /*
>> +     * It must generate STOP before read I2DR to prevent
>> +     * controller from generating another clock cycle
>> +     */
>> +    temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
>> +    temp&= ~(I2CR_MSTA | I2CR_MTX);
>> +    imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
>> +    i2c_imx_bus_busy(i2c_imx, 0);
>> +    i2c_imx->stopped = 1;
>> +    msgs->buf[msgs->len-1] = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
>> +
>>       return 0;
>>   }
>>
>> @@ -601,6 +858,7 @@ static int i2c_imx_probe(struct platform_device 
>> *pdev)
>>       void __iomem *base;
>>       int irq, ret;
>>       u32 bitrate;
>> +    u32 phy_addr;
>>
>>       dev_dbg(&pdev->dev, "<%s>\n", __func__);
>>
>> @@ -611,6 +869,7 @@ static int i2c_imx_probe(struct platform_device 
>> *pdev)
>>       }
>>
>>       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +    phy_addr = res->start;
>>       base = devm_ioremap_resource(&pdev->dev, res);
>>       if (IS_ERR(base))
>>           return PTR_ERR(base);
>> @@ -696,6 +955,10 @@ static int i2c_imx_probe(struct platform_device 
>> *pdev)
>>           i2c_imx->adapter.name);
>>       dev_info(&i2c_imx->adapter.dev, "IMX I2C adapter registered\n");
>>
>> +    /* Init DMA config if support*/
>> +    if (i2c_imx_dma_request(i2c_imx, (dma_addr_t)phy_addr))
>> +        dev_warn(&pdev->dev, "can't request DMA\n");
>> +
>>       return 0;   /* Return OK */
>>   }
>>
>> @@ -707,6 +970,9 @@ static int i2c_imx_remove(struct platform_device 
>> *pdev)
>>       dev_dbg(&i2c_imx->adapter.dev, "adapter removed\n");
>>       i2c_del_adapter(&i2c_imx->adapter);
>>
>> +    if (i2c_imx->dma)
>> +        i2c_imx_dma_free(i2c_imx);
>> +
>>       /* setup chip registers to defaults */
>>       imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IADR);
>>       imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IFDR);
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

