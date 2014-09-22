Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbaIVJTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:19:05 -0400
Received: from exprod7og121.obsmtp.com ([64.18.2.20]:32781 "EHLO
	exprod7og121.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbaIVJTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:19:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140920121242.GA3833@katana>
References: <1408967482-17723-1-git-send-email-anders.berg@avagotech.com>
	<20140920121242.GA3833@katana>
Date: Mon, 22 Sep 2014 11:19:00 +0200
Message-ID: <CAE0=X_0VQ8rWrUgbsgKm1MwCP8bwWm3UJPq9p=xNDfjP4CC7Bg@mail.gmail.com>
Subject: Re: [PATCH] i2c: axxia: Add I2C driver for AXM55xx
From: Anders Berg <anders.berg@avagotech.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: devicetree <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2014 at 2:12 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> Hi,
>
> thanks for the submission.

Sure. Thanks for the comments. I'll update the patch and submit a v2.

>
> On Mon, Aug 25, 2014 at 01:51:22PM +0200, Anders Berg wrote:
>> Add I2C bus driver for the controller found in the LSI Axxia family SoCs. The
>> driver implements 10-bit addressing and SMBus transfer modes via emulation
>> (including SMBus block data read).
>>
>> Signed-off-by: Anders Berg <anders.berg@avagotech.com>
>
> Looks pretty good already. Still, some comments:
>
>> +config I2C_AXXIA
>> +     tristate "Axxia I2C controller"
>> +     depends on ARCH_AXXIA
>> +     help
>> +       Say yes if you want to support the I2C bus on Axxia platforms.
>> +
>> +       If you don't know, say Y.
>
> I'd say skip this sentence and consider 'default y' if it is really
> needed on this platform.

Ok. Dropped the last sentence and defaulting to 'y'.

>
>> diff --git a/drivers/i2c/busses/i2c-axxia.c b/drivers/i2c/busses/i2c-axxia.c
>> new file mode 100644
>> index 0000000..e6c9b88
>> --- /dev/null
>> +++ b/drivers/i2c/busses/i2c-axxia.c
>> @@ -0,0 +1,591 @@
>> +/*
>> + * drivers/i2c/busses/i2c-axxia.c
>
> No pathnames please, they might get stale.
>

Got it.

>> + *
>> + * This driver implements I2C master functionality using the LSI API2C
>> + * controller.
>> + *
>> + * This software is licensed under the terms of the GNU General Public
>> + * License version 2, as published by the Free Software Foundation, and
>> + * may be copied, distributed, and modified under those terms.
>> + */
>> +#include <linux/clk.h>
>> +#include <linux/clkdev.h>
>> +#include <linux/err.h>
>> +#include <linux/i2c.h>
>> +#include <linux/init.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/module.h>
>> +#include <linux/io.h>
>> +#include <linux/kernel.h>
>> +#include <linux/platform_device.h>
>
> At least of.h, too?
>

Ok, added.

>> +
>> +#define SCL_WAIT_TIMEOUT_NS 25000000
>> +#define I2C_XFER_TIMEOUT    (msecs_to_jiffies(250))
>> +#define I2C_STOP_TIMEOUT    (msecs_to_jiffies(100))
>> +#define FIFO_SIZE           8
>> +
>> +#define GLOBAL_CONTROL               0x00
>> +#define   GLOBAL_MST_EN         BIT(0)
>> +#define   GLOBAL_SLV_EN         BIT(1)
>> +#define   GLOBAL_IBML_EN        BIT(2)
>> +#define INTERRUPT_STATUS     0x04
>> +#define INTERRUPT_ENABLE     0x08
>> +#define   INT_SLV               BIT(1)
>> +#define   INT_MST               BIT(0)
>> +#define WAIT_TIMER_CONTROL   0x0c
>> +#define   WT_EN                      BIT(15)
>> +#define   WT_VALUE(_x)               ((_x) & 0x7fff)
>> +#define IBML_TIMEOUT         0x10
>> +#define IBML_LOW_MEXT                0x14
>> +#define IBML_LOW_SEXT                0x18
>> +#define TIMER_CLOCK_DIV              0x1c
>> +#define I2C_BUS_MONITOR              0x20
>> +#define SOFT_RESET           0x24
>> +#define MST_COMMAND          0x28
>> +#define   CMD_BUSY           (1<<3)
>
> The whole driver has 'spaces around operator' issues, please fix them.
>

Ok.

> ...
>
>
>> +     /* Find the prescaler value that makes tmo_clk fit in 15-bits counter.
>> +      */
>
> Minor: Make this a one line comment. Better readable.
>
> ...
>
>
>> +/**
>> + * axxia_i2c_empty_rx_fifo - Fetch data from RX FIFO and update SMBus block
>> + * transfer length if this is the first byte of such a transfer.
>> + */
>> +static int
>> +axxia_i2c_empty_rx_fifo(struct axxia_i2c_dev *idev)
>> +{
>> +     struct i2c_msg *msg = idev->msg;
>> +     size_t rx_fifo_avail = readl(idev->base + MST_RX_FIFO);
>> +     int bytes_to_transfer = min(rx_fifo_avail, msg->len - idev->msg_xfrd);
>> +
>> +     while (0 < bytes_to_transfer--) {
>
> Please put constants on the right side. Reading this is very
> twisting.

Ok.

>
>> +             int c = readl(idev->base + MST_DATA);
>> +
>> +             if (idev->msg_xfrd == 0 && i2c_m_recv_len(msg)) {
>> +                     /*
>> +                      * Check length byte for SMBus block read
>> +                      */
>> +                     if (c <= 0) {
>> +                             idev->msg_err = -EPROTO;
>> +                             i2c_int_disable(idev, ~0);
>> +                             complete(&idev->msg_complete);
>> +                             break;
>> +                     } else if (c > I2C_SMBUS_BLOCK_MAX) {
>> +                             c = I2C_SMBUS_BLOCK_MAX;
>
> What about returning -EPROTO here as well? I don't think that reading
> just a slice of all the data is helpful.
>

Right, that is probably true. This came from the device I was using to
test the block-read operation. This device violated the
I2C_SMBUS_BLOCK_MAX limit, so I added this truncation to at least get
something out...

But I agree, for real-world use it makes no sense to truncate the
message like this. I'll remove it.

> ...
>
>> +static irqreturn_t
>> +axxia_i2c_isr(int irq, void *_dev)
>
> Merge those into a single line please.
>

I'll fix all occurrences of this.

>> +{
>> +     struct axxia_i2c_dev *idev = _dev;
>> +     u32 status;
>> +
>> +     if (!idev->msg)
>> +             return IRQ_NONE;
>
> This is actually not true. There might be interrupt bits set, so there
> is an IRQ. There shouldn't be one, right, but that's another case IMO.
>

You could see it as: there is no interrupt that this handler is
interested in serving. I'd like to keep this test as there is some
legacy software that could be run on platforms with this driver that
access the I2C controller directly. If this happens, this test assures
that the user get an informative "unhandled irq" error message
(instead of a null pointer dereference).

> ...
>
>> +static int
>> +axxia_i2c_xfer_msg(struct axxia_i2c_dev *idev, struct i2c_msg *msg)
>> +{
>> +     u32 int_mask = MST_STATUS_ERR | MST_STATUS_SNS;
>> +     u32 rx_xfer, tx_xfer;
>> +     u32 addr_1, addr_2;
>> +     int ret;
>> +
>> +     if (msg->len == 0 || msg->len > 255)
>> +             return -EINVAL;
>
> Ouch, really? Maybe we should warn the user here.

Yeah, the transfer length register limits the length to 255. I'll add
a warning here.

>
>> +
>> +     idev->msg = msg;
>> +     idev->msg_xfrd = 0;
>> +     idev->msg_err = 0;
>> +     init_completion(&idev->msg_complete);
>
> reinit_completion?

Ok (learned something new there... :-)

>
>> +     ret = wait_for_completion_timeout(&idev->msg_complete,
>> +                                       I2C_XFER_TIMEOUT);
>> +
>> +     i2c_int_disable(idev, int_mask);
>> +
>> +     WARN_ON(readl(idev->base + MST_COMMAND) & CMD_BUSY);
>> +
>> +     if (ret == 0) {
>> +             dev_warn(idev->dev, "xfer timeout (%#x)\n", msg->addr);
>
> But no warning here. Timeouts can easily happen.

Ok.

>
>> +             idev->msg_err = -ETIMEDOUT;
>> +     }
>> +
>> +     if (unlikely(idev->msg_err))
>> +             axxia_i2c_init(idev);
>> +
>> +     return idev->msg_err;
>> +}
>> +
>> +static int
>> +axxia_i2c_stop(struct axxia_i2c_dev *idev)
>> +{
>> +     u32 int_mask = MST_STATUS_ERR | MST_STATUS_SCC;
>> +     int ret;
>> +
>> +     init_completion(&idev->msg_complete);
>
> reinit_completion
>
>> +
>> +     /* Issue stop */
>> +     writel(0xb, idev->base + MST_COMMAND);
>> +     i2c_int_enable(idev, int_mask);
>> +     ret = wait_for_completion_timeout(&idev->msg_complete,
>> +                                       I2C_STOP_TIMEOUT);
>> +     i2c_int_disable(idev, int_mask);
>> +     if (ret == 0)
>> +             return -ETIMEDOUT;
>> +
>> +     WARN_ON(readl(idev->base + MST_COMMAND) & CMD_BUSY);
>
> Message saying that bus is stuck should be enough? The call trace won't
> help here.
>

Agreed.


> ...
>
>> +#ifdef CONFIG_PM
>> +static int axxia_i2c_suspend(struct platform_device *pdev, pm_message_t state)
>> +{
>> +     return -EOPNOTSUPP;
>> +}
>> +
>> +static int axxia_i2c_resume(struct platform_device *pdev)
>> +{
>> +     return -EOPNOTSUPP;
>> +}
>> +#else
>> +#define axxia_i2c_suspend NULL
>> +#define axxia_i2c_resume NULL
>> +#endif
>
> Is this really better than to keep them empty?

Probably not. I'll remove these.

>
>> +static struct platform_driver axxia_i2c_driver = {
>> +     .probe   = axxia_i2c_probe,
>> +     .remove  = axxia_i2c_remove,
>> +     .suspend = axxia_i2c_suspend,
>> +     .resume  = axxia_i2c_resume,
>> +     .driver  = {
>> +             .name  = "axxia-i2c",
>> +             .owner = THIS_MODULE,
>
> owner can be dropped.

... and this.

/Anders
