Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbaLANvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:51:20 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:44489 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083AbaLANvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:51:17 -0500
MIME-Version: 1.0
In-Reply-To: <1417192911-16719-1-git-send-email-muth@cypress.com>
References: <1417192911-16719-1-git-send-email-muth@cypress.com>
Date: Mon, 1 Dec 2014 14:51:16 +0100
Message-ID: <CACRpkdYbbheP5KTuj7f+2cJXrOjjkRZjR0-bth1DF3kCig6n5A@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] gpio: add support for Cypress CYUSBS234 USB-GPIO adapter
From: Linus Walleij <linus.walleij@linaro.org>
To: Muthu Mani <muth@cypress.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Alexandre Courbot <gnurou@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Rajaram Regupathy <rera@cypress.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 5:41 PM, Muthu Mani <muth@cypress.com> wrote:

> Adds support for USB-GPIO interface of Cypress Semiconductor
> CYUSBS234 USB-Serial Bridge controller.
>
> The GPIO get/set can be done through vendor command on control endpoint
> for the configured gpios.
>
> Details about the device can be found at:
> http://www.cypress.com/?rID=84126
>
> Signed-off-by: Muthu Mani <muth@cypress.com>
> Signed-off-by: Rajaram Regupathy <rera@cypress.com>
> ---
> Changes since v3:

(..)
> +config GPIO_CYUSBS23X
> +       tristate "CYUSBS23x GPIO support"
> +       depends on MFD_CYUSBS23X && USB

Doesn't MFD_CYUSV23X already depend on USB?

> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +#include <linux/mutex.h>
> +#include <linux/platform_device.h>
> +
> +#include <linux/usb.h>
> +#include <linux/gpio.h>
> +
> +#include <linux/mfd/cyusbs23x.h>

Why this arbitrary newlines? Add this

#include <linus/bitops.h>

> +struct cyusbs_gpio {
> +       struct gpio_chip gpio;
> +       struct cyusbs23x *cyusbs;
> +       u32 out_gpio;
> +       u32 out_value;
> +       u32 in_gpio;
> +};

Add kerneldoc to this struct so we know what the out/in etc are.

> +static int cy_gpio_get(struct gpio_chip *chip,
> +                       unsigned offset)
> +{
> +       int ret;
> +       char *buf;
> +       u16 wIndex, wValue;
> +       struct cyusbs_gpio *gpio = to_cyusbs_gpio(chip);
> +       struct cyusbs23x *cyusbs = gpio->cyusbs;
> +
> +       if (gpio->out_gpio & (1 << offset))
> +               return gpio->out_value & (1 << offset);

Rewrite like this:

if (gpio->out_gpio & BIT(offset))
             return !!(gpio->out_value & BIT(offset));

(!! will clamp  to [0,1])

> +       wValue = offset;
> +       wIndex = 0;
> +       buf = kmalloc(CY_GPIO_GET_LEN, GFP_KERNEL);
> +       if (buf == NULL)
> +               return -ENOMEM;
> +
> +       ret = usb_control_msg(cyusbs->usb_dev,
> +                       usb_rcvctrlpipe(cyusbs->usb_dev, 0),
> +                       CY_GPIO_GET_VALUE_CMD,
> +                       USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
> +                       wValue, wIndex, buf, CY_GPIO_GET_LEN,
> +                       CY_USBS_CTRL_XFER_TIMEOUT);
> +       if (ret == CY_GPIO_GET_LEN) {
> +               dev_dbg(chip->dev, "%s: offset=%d %02X %02X\n",
> +                       __func__, offset, buf[0], buf[1]);
> +               if (buf[0] == 0)
> +                       ret = buf[1];

ret = !!buf[1];

> +               else
> +                       ret = -EIO;
> +       } else {
> +               dev_err(chip->dev, "%s: offset=%d %d\n", __func__, offset, ret);
> +               ret = -EIO;
> +       }
> +
> +       kfree(buf);
> +       return ret;
> +}
> +
> +static void cy_gpio_set(struct gpio_chip *chip,
> +                       unsigned offset, int value)
> +{
> +       int ret;
> +       u16 wIndex, wValue;
> +       struct cyusbs_gpio *gpio = to_cyusbs_gpio(chip);
> +       struct cyusbs23x *cyusbs = gpio->cyusbs;
> +
> +       wValue = offset;
> +       wIndex = value;
> +
> +       ret = usb_control_msg(cyusbs->usb_dev,
> +                       usb_sndctrlpipe(cyusbs->usb_dev, 0),
> +                       CY_GPIO_SET_VALUE_CMD,
> +                       USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
> +                       wValue, wIndex, NULL, 0, CY_USBS_CTRL_XFER_TIMEOUT);
> +       if (ret < 0)
> +               dev_err(chip->dev, "error setting gpio %d: %d\n", offset, ret);
> +       else {
> +               if (value)
> +                       gpio->out_value |= (1 << offset);
> +               else
> +                       gpio->out_value &= ~(1 << offset);

Use the BIT(offset) pattern here and everywhere else in the file.

> +static int cy_get_device_config(struct cyusbs23x *cyusbs, u8 *buf)
> +{
> +       int ret;
> +
> +       ret = usb_control_msg(cyusbs->usb_dev,
> +                       usb_sndctrlpipe(cyusbs->usb_dev, 0),
> +                       CY_DEV_ENABLE_CONFIG_READ_CMD,
> +                       USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
> +                       0xA6BC, 0xB1B0, NULL, 0,

Aren't these 16bit numbers #defined somewhere?

#define CYUSB_VID 0xA6BC and use that?

> +static int cy_gpio_retrieve_gpio_details(struct cyusbs_gpio *gpio)
> +{
> +       int ret;
> +       u32 drive0, drive1;
> +       u8 *buf;
> +       struct cyusbs23x *cyusbs = gpio->cyusbs;
> +
> +       buf = kzalloc(CY_DEVICE_CONFIG_SIZE, GFP_KERNEL);
> +       if (buf == NULL)
> +               return -ENOMEM;
> +
> +       ret = cy_get_device_config(cyusbs, buf);
> +       if (ret) {
> +               dev_err(&cyusbs->usb_dev->dev,
> +                       "could not retrieve device configuration\n");
> +               goto error;
> +       }
> +
> +       /* Retrieve the GPIO configuration details */
> +       drive0 = *((u32 *)&buf[436]);
> +       drive1 = *((u32 *)&buf[440]);
> +       gpio->out_gpio = drive0 | drive1;
> +       gpio->out_value = drive1;
> +       gpio->in_gpio = *((u32 *)&buf[444]);

These offsets seem horribly arbitrary. Is there a spec of the packet
format to reference in that comment?

Yours,
Linus Walleij
