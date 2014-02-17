Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbaBQJWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:22:07 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:52461 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbaBQJWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:22:03 -0500
Date: Mon, 17 Feb 2014 09:21:55 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Alessandro Gardich <gremlin@gremlin.it>,
        Dmitry Artamonow <mad_soft@inbox.ru>
Subject: Re: [PATCH] RFC: MFD: driver for Atmel Microcontroller on iPaq h3xxx
Message-ID: <20140217092155.GB17875@lee--X1>
References: <1391175275-27347-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1391175275-27347-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This adds a driver for the Atmel Microcontroller found on the
> iPAQ h3xxx series. This device handles some keys, the
> touchscreen, and the battery monitoring.
> 
> This is a port of a driver from handhelds.org 2.6.21 kernel,
> written by Alessandro Gardich based on Andrew Christians
> original HAL-driver. It has been heavily cleaned and
> converted to mfd-core by Dmitry Artamonow and rewritten
> again for the v3.x series kernels by Linus Walleij,
> bringing back some of the functionality lost from Andrew's
> original driver.
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Signed-off-by: Alessandro Gardich <gremlin@gremlin.it>
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

>  drivers/mfd/Kconfig            |  10 +
>  drivers/mfd/Makefile           |   1 +
>  drivers/mfd/ipaq-micro.c       | 488 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/ipaq-micro.h | 149 +++++++++++++
>  4 files changed, 648 insertions(+)
>  create mode 100644 drivers/mfd/ipaq-micro.c
>  create mode 100644 include/linux/mfd/ipaq-micro.h

<snip>

> +++ b/drivers/mfd/ipaq-micro.c
> @@ -0,0 +1,488 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.

Can you put this at the bottom of the header?

> + * Compaq iPAQ h3xxx Atmel microcontroller companion support
> + *
> + * This is an Atmel AT90LS8535 with a special flashed-in firmware that
> + * implements the special protocol used by this driver.
> + *
> + * based on previous kernel 2.4 version by Andrew Christian
> + * Author : Alessandro Gardich <gremlin@gremlin.it>
> + * Author : Dmitry Artamonow <mad_soft@inbox.ru>
> + * Author : Linus Walleij <linus.walleij@linaro.org>
> + */
> +
> +#include <linux/module.h>

Does it matter that you're using:

  module_platform_driver();

... yet you can't build this as a module?

<snip>

> +static void ipaq_micro_trigger_tx(struct ipaq_micro *micro)
> +{
> +	struct ipaq_micro_txdev *tx = &micro->tx;
> +	struct ipaq_micro_msg *msg = micro->msg;
> +	int i, j;
> +	u8 checksum;
> +	u32 val;
> +
> +	j = 0;

Tiny nit:
  The naming convention of 'j' could be more indicative of its function. 

> +	tx->buf[j++] = (u8) CHAR_SOF;

Is this cast required?

> +	checksum = ((msg->id & 0x0f) << 4) | (msg->tx_len & 0x0f);
> +	tx->buf[j++] = checksum;
> +
> +	for (i = 0; i < msg->tx_len; i++) {
> +		tx->buf[j++] = msg->tx_data[i];
> +		checksum += msg->tx_data[i];
> +	}
> +
> +	tx->buf[j++] = checksum;
> +	tx->len = j;
> +	tx->index = 0;
> +	print_hex_dump(KERN_DEBUG, "data: ", DUMP_PREFIX_OFFSET, 16, 1,
> +		       tx->buf, tx->len, true);
> +
> +

Too many new lines.

> +	val = readl(micro->base + UTCR3);
> +	val |= UTCR3_TIE; /* enable interrupt */
> +	writel(val, micro->base + UTCR3);

The comment should encompass all three lines of code.

> +}
> +
> +

Too many new lines.

> +int ipaq_micro_tx_msg(struct ipaq_micro *micro, struct ipaq_micro_msg *msg)
> +{
> +	unsigned long flags;
> +
> +	dev_dbg(micro->dev, "TX msg: %02x, %d bytes\n", msg->id, msg->tx_len);
> +
> +	spin_lock_irqsave(&micro->lock, flags);
> +	if (micro->msg != NULL) {

if (!micro->msg) is preferred.

> +		list_add_tail(&msg->node, &micro->queue);
> +		spin_unlock_irqrestore(&micro->lock, flags);
> +		return 0;
> +	}
> +	micro->msg = msg;
> +	ipaq_micro_trigger_tx(micro);
> +	spin_unlock_irqrestore(&micro->lock, flags);
> +	return 0;
> +}
> +EXPORT_SYMBOL(ipaq_micro_tx_msg);
> +
> +static void micro_rx_msg(struct ipaq_micro *micro, u8 id, int len, u8 *data)
> +{
> +	int i;
> +

<snip>

> +	case MSG_KEYBOARD:
> +		if (micro->key != NULL)

!micro->key

> +			micro->key(micro->key_data, len, data);
> +		else
> +			dev_dbg(micro->dev, "ipaq micro : key message ignored, "
> +				"no handle \n");

Log print spread over two lines. Doesn't Checkpatch complain about
this?

> +		break;
> +	case MSG_TOUCHSCREEN:
> +		if (micro->ts != NULL)

!micro->ts ...  etc etc

> +			micro->ts(micro->ts_data, len, data);
> +		else
> +			dev_dbg(micro->dev, "ipaq micro : touchscreen message "
> +				"ignored, no handle \n");

Print spill.

> +static char *ipaq_micro_str(u8 *wchar, u8 len)
> +{
> +	char retstr[256];
> +	u8 i;
> +
> +	for (i = 0; i < len / 2; i++)
> +		retstr[i] = wchar[i*2];

It's common practice to space out the [i*2] for readability.

<snip>

> +static void micro_tx_chars(struct ipaq_micro *micro)
> +{
> +	struct ipaq_micro_txdev *tx = &micro->tx;
> +	u32 val;
> +
> +	while ((tx->index < tx->len) &&
> +	       (readl(micro->base + UTSR1) & UTSR1_TNF)) {
> +		writel(tx->buf[tx->index], micro->base + UTDR);

This is pretty messy. Better broken out? Your call.

<snip>

> +	/* Stop interrupts */
> +	val = readl(micro->base + UTCR3);
> +	val &= ~UTCR3_TIE;
> +	writel(val, micro->base + UTCR3);

Ah, so it's correct here. Please see my comment surrounding "start
interrupts" above.

> +}
> +
> +static void micro_reset_comm(struct ipaq_micro *micro)
> +{
> +	struct ipaq_micro_rxdev *rx = &micro->rx;
> +	u32 val;

New line here please.

> +	if (micro->msg)
> +		complete(&micro->msg->ack);
> +
> +	/* Initialize Serial channel protocol frame */
> +	rx->state = STATE_SOF;  /* Reset the state machine */
> +
> +	/* Set up interrupts */
> +	writel(0x01, micro->sdlc + 0x0); /* Select UART mode */
> +
> +	/* Clean up CR3 */
> +	writel(0x0, micro->base + UTCR3);
> +	/* Format: 8N1 */
> +	writel(UTCR0_8BitData | UTCR0_1StpBit, micro->base + UTCR0);
> +	/* Baud rate: 115200 */
> +	writel(0x0, micro->base + UTCR1);
> +	writel(0x1, micro->base + UTCR2);

Any reason for squishing these together?

> +	/* Clear SR0 */
> +	writel(0xff, micro->base + UTSR0);
> +	/* Enable RX int */
> +	writel(UTCR3_TXE | UTCR3_RXE | UTCR3_RIE, micro->base + UTCR3);
> +	val = readl(micro->base + UTCR3);
> +	val &= ~UTCR3_TIE; /* Disable TX int */
> +	writel(val, micro->base + UTCR3);
> +}

<snip>

> +static struct mfd_cell micro_cells[] = {
> +	{
> +		.name = "ipaq-micro-backlight",
> +	},
> +	{
> +		.name = "ipaq-micro-battery",
> +	},
> +	{
> +		.name = "ipaq-micro-keys",
> +	},
> +	{
> +		.name = "ipaq-micro-ts",
> +	},
> +	{
> +		.name = "ipaq-micro-leds",
> +	},
> +};

Is Device Tree ever going to be supported on the iPAC? If not, I think
it's okay for you to make these single line entries.

> +static int micro_suspend(struct device *dev)
> +{
> +	return 0;
> +}

Doesn't the PM framework check for NULL .suspend?

> +static int micro_probe(struct platform_device *pdev)
> +{
> +	struct ipaq_micro *micro;
> +	struct resource *res;
> +	int ret;
> +	int irq;
> +
> +	micro = devm_kzalloc(&pdev->dev, sizeof(*micro), GFP_KERNEL);
> +	if (!micro)
> +		return -ENOMEM;
> +	micro->dev = &pdev->dev;
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -EINVAL;
> +	micro->base = devm_request_and_ioremap(&pdev->dev, res);
> +	if (!micro->base)
> +		return -ENOMEM;
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	if (!res)
> +		return -EINVAL;
> +	micro->sdlc = devm_request_and_ioremap(&pdev->dev, res);
> +	if (!micro->sdlc)
> +		return -ENOMEM;
> +	micro_reset_comm(micro);
> +	irq = platform_get_irq(pdev, 0);
> +	if (!irq)
> +		return -EINVAL;

Can you space all of these out a bit?

> +	ret = devm_request_irq(&pdev->dev, irq, micro_serial_isr,
> +			       IRQF_SHARED, "ipaq-micro",
> +			       micro);
> +	if (ret) {
> +		dev_err(&pdev->dev, "%s: unable to grab serial port IRQ\n",
> +			__func__);

Any need to print the function name if you know the name of the
device?

> +		return ret;
> +	} else
> +		dev_info(&pdev->dev, "grabbed serial port IRQ\n");
> +
> +

Too many new lines.

> +	spin_lock_init(&micro->lock);
> +	INIT_LIST_HEAD(&micro->queue);
> +	platform_set_drvdata(pdev, micro);
> +
> +	ret = mfd_add_devices(&pdev->dev, pdev->id, micro_cells,
> +			      ARRAY_SIZE(micro_cells), NULL, 0, NULL);
> +	if (ret) {
> +		dev_err(&pdev->dev, "error adding MFD cells");
> +		return ret;
> +	}

New line here.

> +	/* Check version */
> +	ipaq_micro_get_version(micro);
> +	dev_info(&pdev->dev, "Atmel micro ASIC version %s\n", micro->version);
> +	ipaq_micro_eeprom_dump(micro);
> +
> +	return 0;
> +}
> +
> +static int micro_remove(struct platform_device *pdev)
> +{
> +	struct ipaq_micro *micro = platform_get_drvdata(pdev);
> +	u32 val;
> +
> +	mfd_remove_devices(&pdev->dev);
> +	val = readl(micro->base + UTCR3);
> +	val &= ~(UTCR3_RXE | UTCR3_RIE); /* disable receive interrupt */
> +	val &= ~(UTCR3_TXE | UTCR3_TIE); /* disable transmit interrupt */
> +	writel(val, micro->base + UTCR3);
> +	return 0;

Break these up please.

> +}
> +
> +static const struct dev_pm_ops micro_dev_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(micro_suspend, micro_resume)
> +};
> +
> +static struct platform_driver micro_device_driver = {
> +	.driver   = {
> +		.name	= "ipaq-h3xxx-micro",
> +		.pm	= &micro_dev_pm_ops,
> +	},
> +	.probe    = micro_probe,
> +	.remove   = micro_remove,
> +	/* .shutdown = micro_suspend, // FIXME */
> +};
> +module_platform_driver(micro_device_driver);

It may seem silly for these piece of h/w, but don't we have a 'no new
device drivers without DT support rule'?

> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("driver for iPAQ Atmel micro core and backlight");
> diff --git a/include/linux/mfd/ipaq-micro.h b/include/linux/mfd/ipaq-micro.h
> new file mode 100644
> index 000000000000..9466e97ff236
> --- /dev/null
> +++ b/include/linux/mfd/ipaq-micro.h
> @@ -0,0 +1,149 @@
> +/*
> + * Header file for the compaq Micro MFD
> + */
> +
> +#ifndef _MFD_IPAQ_MICRO_H_
> +#define _MFD_IPAQ_MICRO_H_
> +
> +#include <linux/spinlock.h>
> +#include <linux/completion.h>
> +#include <linux/list.h>
> +struct device;

What's this for?

<snip>

> +static inline int
> +ipaq_micro_tx_msg_sync(struct ipaq_micro *micro,
> +		       struct ipaq_micro_msg *msg)
> +{
> +	int ret;
> +
> +	init_completion(&msg->ack);
> +	ret = ipaq_micro_tx_msg(micro, msg);
> +	wait_for_completion(&msg->ack);
> +
> +	return ret;
> +}
> +
> +static inline int
> +ipaq_micro_tx_msg_async(struct ipaq_micro *micro,
> +			struct ipaq_micro_msg *msg)
> +{
> +	init_completion(&msg->ack);
> +	return ipaq_micro_tx_msg(micro, msg);
> +}

Why are these in here? Where else are they called from?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
