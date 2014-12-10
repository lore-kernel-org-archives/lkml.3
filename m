Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbaLJBmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 20:42:00 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:35460 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbaLJBl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 20:41:58 -0500
X-IronPort-AV: E=Sophos;i="5.07,549,1413270000"; 
   d="scan'208";a="52522197"
Message-ID: <5487A4C9.2000604@broadcom.com>
Date: Tue, 9 Dec 2014 17:41:29 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Varka Bhadram <varkabhadram@gmail.com>, Wolfram Sang <wsa@the-dreams.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Grant Likely" <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>,
        "Matt Porter" <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Russell King" <linux@arm.linux.org.uk>
CC: Scott Branden <sbranden@broadcom.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/4] i2c: iproc: Add Broadcom iProc I2C Driver
References: <Ray Jui <rjui@broadcom.com> <1418172891-19441-1-git-send-email-rjui@broadcom.com> <1418172891-19441-3-git-send-email-rjui@broadcom.com> <5487A2D6.8070901@gmail.com>
In-Reply-To: <5487A2D6.8070901@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/9/2014 5:33 PM, Varka Bhadram wrote:
>
> On Wednesday 10 December 2014 06:24 AM, Ray Jui wrote:
>> Add initial support to the Broadcom iProc I2C controller found in the
>> iProc family of SoCs.
>>
>> The iProc I2C controller has separate internal TX and RX FIFOs, each has
>> a size of 64 bytes. The iProc I2C controller supports two bus speeds
>> including standard mode (100kHz) and fast mode (400kHz)
>>
>> Signed-off-by: Ray Jui <rjui@broadcom.com>
>> Reviewed-by: Scott Branden <sbranden@broadcom.com>
>> ---
>>   drivers/i2c/busses/Kconfig         |    9 +
>>   drivers/i2c/busses/Makefile        |    1 +
>>   drivers/i2c/busses/i2c-bcm-iproc.c |  503
>> ++++++++++++++++++++++++++++++++++++
>>   3 files changed, 513 insertions(+)
>>   create mode 100644 drivers/i2c/busses/i2c-bcm-iproc.c
>>
>> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
>> index c1351d9..8a2eb7e 100644
>> --- a/drivers/i2c/busses/Kconfig
>> +++ b/drivers/i2c/busses/Kconfig
>> @@ -372,6 +372,15 @@ config I2C_BCM2835
>>         This support is also available as a module.  If so, the module
>>         will be called i2c-bcm2835.
>> +config I2C_BCM_IPROC
>> +    tristate "Broadcom iProc I2C controller"
>> +    depends on ARCH_BCM_IPROC
>> +    help
>> +      If you say yes to this option, support will be included for the
>> +      Broadcom iProc I2C controller.
>> +
>> +      If you don't know what to do here, say N.
>> +
>>   config I2C_BCM_KONA
>>       tristate "BCM Kona I2C adapter"
>>       depends on ARCH_BCM_MOBILE
>> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
>> index 5e6c822..216e7be 100644
>> --- a/drivers/i2c/busses/Makefile
>> +++ b/drivers/i2c/busses/Makefile
>> @@ -33,6 +33,7 @@ obj-$(CONFIG_I2C_AT91)        += i2c-at91.o
>>   obj-$(CONFIG_I2C_AU1550)    += i2c-au1550.o
>>   obj-$(CONFIG_I2C_AXXIA)        += i2c-axxia.o
>>   obj-$(CONFIG_I2C_BCM2835)    += i2c-bcm2835.o
>> +obj-$(CONFIG_I2C_BCM_IPROC)    += i2c-bcm-iproc.o
>>   obj-$(CONFIG_I2C_BLACKFIN_TWI)    += i2c-bfin-twi.o
>>   obj-$(CONFIG_I2C_CADENCE)    += i2c-cadence.o
>>   obj-$(CONFIG_I2C_CBUS_GPIO)    += i2c-cbus-gpio.o
>> diff --git a/drivers/i2c/busses/i2c-bcm-iproc.c
>> b/drivers/i2c/busses/i2c-bcm-iproc.c
>> new file mode 100644
>> index 0000000..0e6e603
>> --- /dev/null
>> +++ b/drivers/i2c/busses/i2c-bcm-iproc.c
>> @@ -0,0 +1,503 @@
>> +/*
>> + * Copyright (C) 2014 Broadcom Corporation
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License as
>> + * published by the Free Software Foundation version 2.
>> + *
>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
>> + * kind, whether express or implied; without even the implied warranty
>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/device.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/sched.h>
>> +#include <linux/i2c.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/clk.h>
>> +#include <linux/io.h>
>> +#include <linux/slab.h>
>> +#include <linux/delay.h>
>> +
>> +#define CFG_OFFSET                   0x00
>> +#define CFG_RESET_SHIFT              31
>> +#define CFG_EN_SHIFT                 30
>> +#define CFG_M_RETRY_CNT_SHIFT        16
>> +#define CFG_M_RETRY_CNT_MASK         0x0f
>> +
>> +#define TIM_CFG_OFFSET               0x04
>> +#define TIME_CFG_MODE_400_SHIFT      31
>> +
>> +#define M_FIFO_CTRL_OFFSET           0x0c
>> +#define M_FIFO_RX_FLUSH_SHIFT        31
>> +#define M_FIFO_TX_FLUSH_SHIFT        30
>> +#define M_FIFO_RX_CNT_SHIFT          16
>> +#define M_FIFO_RX_CNT_MASK           0x7f
>> +#define M_FIFO_RX_THLD_SHIFT         8
>> +#define M_FIFO_RX_THLD_MASK          0x3f
>> +
>> +#define M_CMD_OFFSET                 0x30
>> +#define M_CMD_START_BUSY_SHIFT       31
>> +#define M_CMD_STATUS_SHIFT           25
>> +#define M_CMD_STATUS_MASK            0x07
>> +#define M_CMD_STATUS_SUCCESS         0x0
>> +#define M_CMD_STATUS_LOST_ARB        0x1
>> +#define M_CMD_STATUS_NACK_ADDR       0x2
>> +#define M_CMD_STATUS_NACK_DATA       0x3
>> +#define M_CMD_STATUS_TIMEOUT         0x4
>> +#define M_CMD_PROTOCOL_SHIFT         9
>> +#define M_CMD_PROTOCOL_MASK          0xf
>> +#define M_CMD_PROTOCOL_BLK_WR        0x7
>> +#define M_CMD_PROTOCOL_BLK_RD        0x8
>> +#define M_CMD_PEC_SHIFT              8
>> +#define M_CMD_RD_CNT_SHIFT           0
>> +#define M_CMD_RD_CNT_MASK            0xff
>> +
>> +#define IE_OFFSET                    0x38
>> +#define IE_M_RX_FIFO_FULL_SHIFT      31
>> +#define IE_M_RX_THLD_SHIFT           30
>> +#define IE_M_START_BUSY_SHIFT        28
>> +
>> +#define IS_OFFSET                    0x3c
>> +#define IS_M_RX_FIFO_FULL_SHIFT      31
>> +#define IS_M_RX_THLD_SHIFT           30
>> +#define IS_M_START_BUSY_SHIFT        28
>> +
>> +#define M_TX_OFFSET                  0x40
>> +#define M_TX_WR_STATUS_SHIFT         31
>> +#define M_TX_DATA_SHIFT              0
>> +#define M_TX_DATA_MASK               0xff
>> +
>> +#define M_RX_OFFSET                  0x44
>> +#define M_RX_STATUS_SHIFT            30
>> +#define M_RX_STATUS_MASK             0x03
>> +#define M_RX_PEC_ERR_SHIFT           29
>> +#define M_RX_DATA_SHIFT              0
>> +#define M_RX_DATA_MASK               0xff
>> +
>> +#define I2C_TIMEOUT_MESC             100
>> +#define M_TX_RX_FIFO_SIZE            64
>> +
>> +enum bus_speed_index {
>> +    I2C_SPD_100K = 0,
>> +    I2C_SPD_400K,
>> +};
>> +
>> +struct bcm_iproc_i2c_dev {
>> +    struct device *device;
>> +
>> +    void __iomem *base;
>> +    struct i2c_msg *msg;
>> +
>> +    struct i2c_adapter adapter;
>> +
>> +    struct completion done;
>> +};
>> +
>> +/*
>> + * Can be expanded in the future if more interrupt status bits are
>> utilized
>> + */
>> +#define ISR_MASK (1 << IS_M_START_BUSY_SHIFT)
>> +
>> +static irqreturn_t bcm_iproc_i2c_isr(int irq, void *data)
>> +{
>> +    struct bcm_iproc_i2c_dev *dev = data;
>> +    u32 status = readl(dev->base + IS_OFFSET);
>> +
>> +    status &= ISR_MASK;
>> +
>> +    if (!status)
>> +        return IRQ_NONE;
>> +
>> +    writel(status, dev->base + IS_OFFSET);
>> +    complete_all(&dev->done);
>> +
>> +    return IRQ_HANDLED;
>> +}
>> +
>> +static int __wait_for_bus_idle(struct bcm_iproc_i2c_dev *dev)
>> +{
>> +    unsigned long timeout = jiffies +
>> msecs_to_jiffies(I2C_TIMEOUT_MESC);
>> +
>> +    while (readl(dev->base + M_CMD_OFFSET) &
>> +            (1 << M_CMD_START_BUSY_SHIFT)) {
>> +        if (time_after(jiffies, timeout)) {
>> +            dev_err(dev->device, "wait for bus idle timeout\n");
>> +            return -ETIMEDOUT;
>> +        }
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +static int bcm_iproc_i2c_format_addr(struct bcm_iproc_i2c_dev *dev,
>> +        struct i2c_msg *msg, u8 *addr)
>> +{
>
> Match open parenthesis..
>
> static int bcm_iproc_i2c_format_addr(struct bcm_iproc_i2c_dev *dev,
>                       struct i2c_msg *msg, u8 *addr)
>
>
Okay I can make this change.
>> +
>> +    if (msg->flags & I2C_M_TEN) {
>> +        dev_err(dev->device, "no support for 10-bit address\n");
>> +        return -EINVAL;
>> +    }
>> +
>> +    *addr = (msg->addr << 1) & 0xfe;
>> +
>> +    if (msg->flags & I2C_M_RD)
>> +        *addr |= 1;
>> +
>> +    return 0;
>> +}
>> +
>> +static int bcm_iproc_i2c_check_status(struct bcm_iproc_i2c_dev *dev)
>> +{
>> +    u32 val;
>> +
>> +    val = readl(dev->base + M_CMD_OFFSET);
>> +    val = (val >> M_CMD_STATUS_SHIFT) & M_CMD_STATUS_MASK;
>> +
>> +    switch (val) {
>> +    case M_CMD_STATUS_SUCCESS:
>> +        return 0;
>> +
>> +    case M_CMD_STATUS_LOST_ARB:
>> +        dev_err(dev->device, "lost bus arbitration\n");
>> +        return -EREMOTEIO;
>> +
>> +    case M_CMD_STATUS_NACK_ADDR:
>> +        dev_err(dev->device, "NAK addr:0x%02x\n", dev->msg->addr);
>> +        return -EREMOTEIO;
>> +
>> +    case M_CMD_STATUS_NACK_DATA:
>> +        dev_err(dev->device, "NAK data\n");
>> +        return -EREMOTEIO;
>> +
>> +    case M_CMD_STATUS_TIMEOUT:
>> +        dev_err(dev->device, "bus timeout\n");
>> +        return -ETIMEDOUT;
>> +
>> +    default:
>> +        dev_err(dev->device, "unknown error code=%d\n", val);
>> +        return -EREMOTEIO;
>> +    }
>> +
>> +    return -EREMOTEIO;
>> +}
>> +
>> +static int bcm_iproc_i2c_xfer_single_msg(struct bcm_iproc_i2c_dev *dev,
>> +        struct i2c_msg *msg)
>> +{
>
> dto...
>
One more indent? Sure.

>> +    int ret, i;
>> +    u8 addr;
>> +    u32 val;
>> +    unsigned long time_left = msecs_to_jiffies(I2C_TIMEOUT_MESC);
>> +
>> +    if (msg->len < 1 || msg->len > M_TX_RX_FIFO_SIZE - 1) {
>> +        dev_err(dev->device,
>> +            "supported data length is 1 - %u bytes\n",
>> +                M_TX_RX_FIFO_SIZE - 1);
>> +        return -EINVAL;
>> +    }
>> +
>> +    dev->msg = msg;
>> +    ret = __wait_for_bus_idle(dev);
>> +    if (ret)
>> +        return ret;
>> +
>> +    ret = bcm_iproc_i2c_format_addr(dev, msg, &addr);
>> +    if (ret)
>> +        return ret;
>> +
>> +    /* load slave address into the TX FIFO */
>> +    writel(addr, dev->base + M_TX_OFFSET);
>> +
>> +    /* for a write transaction, load data into the TX FIFO */
>> +    if (!(msg->flags & I2C_M_RD)) {
>> +        for (i = 0; i < msg->len; i++) {
>> +            val = msg->buf[i];
>> +
>> +            /* mark the last byte */
>> +            if (i == msg->len - 1)
>> +                val |= 1 << M_TX_WR_STATUS_SHIFT;
>> +
>> +            writel(val, dev->base + M_TX_OFFSET);
>> +        }
>> +    }
>> +
>> +    /* mark as incomplete before starting the transaction */
>> +    reinit_completion(&dev->done);
>> +
>> +    /*
>> +     * Enable the "start busy" interrupt, which will be triggered after
>> +     * the transaction is done
>> +     */
>> +    writel(1 << IE_M_START_BUSY_SHIFT, dev->base + IE_OFFSET);
>> +
>> +    /*
>> +     * Now we can activate the transfer. For a read operation,
>> specify the
>> +     * number of bytes to read
>> +     */
>> +    val = 1 << M_CMD_START_BUSY_SHIFT;
>> +    if (msg->flags & I2C_M_RD) {
>> +        val |= (M_CMD_PROTOCOL_BLK_RD << M_CMD_PROTOCOL_SHIFT) |
>> +            (msg->len << M_CMD_RD_CNT_SHIFT);
>> +    } else {
>> +        val |= (M_CMD_PROTOCOL_BLK_WR << M_CMD_PROTOCOL_SHIFT);
>> +    }
>> +    writel(val, dev->base + M_CMD_OFFSET);
>> +
>> +    time_left = wait_for_completion_timeout(&dev->done, time_left);
>> +
>> +    /* disable all interrupts */
>> +    writel(0, dev->base + IE_OFFSET);
>> +
>> +    if (!time_left) {
>> +        dev_err(dev->device, "transaction times out\n");
>> +
>> +        /* flush FIFOs */
>> +        val = (1 << M_FIFO_RX_FLUSH_SHIFT) |
>> +            (1 << M_FIFO_TX_FLUSH_SHIFT);
>> +        writel(val, dev->base + M_FIFO_CTRL_OFFSET);
>> +        return -EREMOTEIO;
>> +    }
>> +
>> +    ret = bcm_iproc_i2c_check_status(dev);
>> +    if (ret) {
>> +        /* flush both TX/RX FIFOs */
>> +        val = (1 << M_FIFO_RX_FLUSH_SHIFT) |
>> +            (1 << M_FIFO_TX_FLUSH_SHIFT);
>> +        writel(val, dev->base + M_FIFO_CTRL_OFFSET);
>> +        return ret;
>> +    }
>> +
>> +    /*
>> +     * For a read operation, we now need to load the data from FIFO
>> +     * into the memory buffer
>> +     */
>> +    if (msg->flags & I2C_M_RD) {
>> +        for (i = 0; i < msg->len; i++) {
>> +            msg->buf[i] = (readl(dev->base + M_RX_OFFSET) >>
>> +                    M_RX_DATA_SHIFT) & M_RX_DATA_MASK;
>> +        }
>> +    }
>> +
>> +    dev_dbg(dev->device, "xfer %c, addr=0x%02x, len=%d\n",
>> +            (msg->flags & I2C_M_RD) ? 'R' : 'W', msg->addr,
>> +            msg->len);
>> +    dev_dbg(dev->device, "**** data start ****\n");
>> +    for (i = 0; i < msg->len; i++)
>> +        dev_dbg(dev->device, "0x%02x ",  msg->buf[i]);
>> +    dev_dbg(dev->device, "**** data end ****\n");
>> +
>> +    return 0;
>> +}
>> +
>> +static int bcm_iproc_i2c_xfer(struct i2c_adapter *adapter,
>> +                 struct i2c_msg msgs[], int num)
>> +{
>> +    struct bcm_iproc_i2c_dev *dev = i2c_get_adapdata(adapter);
>> +    int ret, i;
>> +
>> +    /* go through all messages */
>> +    for (i = 0; i < num; i++) {
>> +        ret = bcm_iproc_i2c_xfer_single_msg(dev, &msgs[i]);
>> +        if (ret) {
>> +            dev_err(dev->device, "xfer failed\n");
>> +            return ret;
>> +        }
>> +    }
>> +
>> +    return num;
>> +}
>> +
>> +static uint32_t bcm_iproc_i2c_functionality(struct i2c_adapter *adap)
>> +{
>> +    return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
>> +}
>> +
>> +static const struct i2c_algorithm bcm_iproc_algo = {
>> +    .master_xfer = bcm_iproc_i2c_xfer,
>> +    .functionality = bcm_iproc_i2c_functionality,
>> +};
>> +
>> +static int bcm_iproc_i2c_cfg_speed(struct bcm_iproc_i2c_dev *dev)
>> +{
>> +    unsigned int bus_speed, speed_bit;
>> +    u32 val;
>> +    int ret = of_property_read_u32(dev->device->of_node,
>> "clock-frequency",
>> +                       &bus_speed);
>> +    if (ret < 0) {
>> +        dev_err(dev->device, "missing clock-frequency property\n");
>> +        return -ENODEV;
>> +    }
>> +
>> +    switch (bus_speed) {
>> +    case 100000:
>> +        speed_bit = 0;
>> +        break;
>> +    case 400000:
>> +        speed_bit = 1;
>> +        break;
>> +    default:
>> +        dev_err(dev->device, "%d Hz bus speed not supported\n",
>> +                bus_speed);
>> +        dev_err(dev->device, "valid speeds are 100khz and 400khz\n");
>> +        return -EINVAL;
>> +    }
>> +
>> +    val = readl(dev->base + TIM_CFG_OFFSET);
>> +    val &= ~(1 << TIME_CFG_MODE_400_SHIFT);
>> +    val |= speed_bit << TIME_CFG_MODE_400_SHIFT;
>> +    writel(val, dev->base + TIM_CFG_OFFSET);
>> +
>> +    dev_info(dev->device, "bus set to %u Hz\n", bus_speed);
>> +
>> +    return 0;
>> +}
>> +
>> +static int bcm_iproc_i2c_init(struct bcm_iproc_i2c_dev *dev)
>> +{
>> +    u32 val;
>> +
>> +    /* put controller in reset */
>> +    val = readl(dev->base + CFG_OFFSET);
>> +    val |= 1 << CFG_RESET_SHIFT;
>> +    val &= ~(1 << CFG_EN_SHIFT);
>> +    writel(val, dev->base + CFG_OFFSET);
>> +
>> +    /* wait 100 usec per spec */
>> +    udelay(100);
>> +
>> +    /* bring controller out of reset */
>> +    val = readl(dev->base + CFG_OFFSET);
>> +    val &= ~(1 << CFG_RESET_SHIFT);
>> +    writel(val, dev->base + CFG_OFFSET);
>> +
>> +    /* flush TX/RX FIFOs and set RX FIFO threshold to zero */
>> +    val = (1 << M_FIFO_RX_FLUSH_SHIFT) | (1 << M_FIFO_TX_FLUSH_SHIFT);
>> +    writel(val, dev->base + M_FIFO_CTRL_OFFSET);
>> +
>> +    /* disable all interrupts */
>> +    val = 0;
>> +    writel(val, dev->base + IE_OFFSET);
>> +
>> +    /* clear all pending interrupts */
>> +    val = readl(dev->base + IS_OFFSET);
>> +    writel(val, dev->base + IS_OFFSET);
>> +
>> +    return 0;
>> +}
>> +
>> +static void bcm_iproc_i2c_enable(struct bcm_iproc_i2c_dev *dev)
>> +{
>> +    u32 val;
>> +
>> +    val = readl(dev->base + CFG_OFFSET);
>> +    val |= 1 << CFG_EN_SHIFT;
>> +    writel(val, dev->base + CFG_OFFSET);
>> +}
>> +
>> +static void bcm_iproc_i2c_disable(struct bcm_iproc_i2c_dev *dev)
>> +{
>> +    u32 val;
>> +
>> +    val = readl(dev->base + CFG_OFFSET);
>> +    val &= ~(1 << CFG_EN_SHIFT);
>> +    writel(val, dev->base + CFG_OFFSET);
>> +}
>> +
>> +static int bcm_iproc_i2c_probe(struct platform_device *pdev)
>> +{
>> +    int irq, ret = 0;
>> +    struct bcm_iproc_i2c_dev *dev;
>> +    struct i2c_adapter *adap;
>> +    struct resource *res;
>> +
>> +    dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
>> +    if (!dev)
>> +        return -ENOMEM;
>> +
>> +    platform_set_drvdata(pdev, dev);
>> +    dev->device = &pdev->dev;
>> +    init_completion(&dev->done);
>> +
>> +    res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +    if (!res)
>> +        return -ENODEV;
>
> We can remove this resource check. This checking will happen with
> devm_ioremap_resource()
>
Don't you need to obtain a valid resource and pass it into 
devm_ioremap_resource? Without 'res' being assigned a valid resource, 
devm_ioremap_resource will reject with "invalid resource".

>> +    dev->base = devm_ioremap_resource(dev->device, res);
>> +    if (IS_ERR(dev->base))
>> +        return -ENOMEM;
>> +
>> +    ret = bcm_iproc_i2c_init(dev);
>> +    if (ret)
>> +        return ret;
>> +
>> +    ret = bcm_iproc_i2c_cfg_speed(dev);
>> +    if (ret)
>> +        return ret;
>> +
>> +    irq = platform_get_irq(pdev, 0);
>> +    if (irq < 0) {
>> +        dev_err(dev->device, "no irq resource\n");
>> +        return irq;
>> +    }
>> +
>> +    ret = devm_request_irq(&pdev->dev, irq, bcm_iproc_i2c_isr,
>> +            IRQF_SHARED, pdev->name, dev);
>> +    if (ret) {
>> +        dev_err(dev->device, "unable to request irq %i\n", irq);
>> +        return ret;
>> +    }
>> +
>> +    bcm_iproc_i2c_enable(dev);
>> +
>> +    adap = &dev->adapter;
>> +    i2c_set_adapdata(adap, dev);
>> +    strlcpy(adap->name, "Broadcom iProc I2C adapter",
>> sizeof(adap->name));
>> +    adap->algo = &bcm_iproc_algo;
>> +    adap->dev.parent = &pdev->dev;
>> +    adap->dev.of_node = pdev->dev.of_node;
>> +
>> +    ret = i2c_add_adapter(adap);
>> +    if (ret) {
>> +        dev_err(dev->device, "failed to add adapter\n");
>> +        return ret;
>> +    }
>> +
>> +    dev_info(dev->device, "device registered successfully\n");
>> +
>> +    return 0;
>> +}
>> +
>> +static int bcm_iproc_i2c_remove(struct platform_device *pdev)
>> +{
>> +    struct bcm_iproc_i2c_dev *dev = platform_get_drvdata(pdev);
>> +
>> +    i2c_del_adapter(&dev->adapter);
>> +    bcm_iproc_i2c_disable(dev);
>> +
>> +    return 0;
>> +}
>> +
>> +static const struct of_device_id bcm_iproc_i2c_of_match[] = {
>> +    {.compatible = "brcm,iproc-i2c",},
>> +    {},
>> +};
>> +MODULE_DEVICE_TABLE(of, bcm_iproc_i2c_of_match);
>> +
>> +static struct platform_driver bcm_iproc_i2c_driver = {
>> +    .driver = {
>> +           .name = "bcm-iproc-i2c",
>> +           .owner = THIS_MODULE,
>
> No need to update this field. Its updated by module_platform_driver().
>
Okay will get rid of .owner = THIS_MODULES,

>> +           .of_match_table = bcm_iproc_i2c_of_match,
>> +           },
>> +    .probe = bcm_iproc_i2c_probe,
>> +    .remove = bcm_iproc_i2c_remove,
>> +};
>> +module_platform_driver(bcm_iproc_i2c_driver);
>> +
>> +MODULE_AUTHOR("Ray Jui <rjui@broadcom.com>");
>> +MODULE_DESCRIPTION("Broadcom iProc I2C Driver");
>> +MODULE_LICENSE("GPL v2");
>
