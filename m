Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaLOGWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 01:22:35 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:62149 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaLOGWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 01:22:31 -0500
MIME-Version: 1.0
Date: Mon, 15 Dec 2014 14:22:29 +0800
X-Google-Sender-Auth: KLU8En2psk8PxmALTn-0pwiZwCs
Message-ID: <CAFiDJ58uQifY7th-mzvm2mjgJdw_MWmWFFhDPYT9TomOexiVNw@mail.gmail.com>
Subject: Re: [PATCH (resend)] mailbox: Add Altera mailbox driver
From: Ley Foon Tan <lftan@altera.com>
To: Dinh Nguyen <dinh.linux@gmail.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Suman Anna <s-anna@ti.com>, devicetree@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 10:38 PM, Dinh Nguyen <dinh.linux@gmail.com> wrote:

>> +
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/device.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/io.h>
>> +#include <linux/of.h>
>> +#include <linux/mailbox_controller.h>
>
> Alphabetize the headers.
Okay.


>> +static int altera_mbox_startup_sender(struct mbox_chan *chan)
>> +{
>> +     int ret;
>> +     struct altera_mbox *mbox = to_altera_mbox(chan);
>> +
>> +     if (mbox->intr_mode) {
>> +             ret = request_irq(mbox->irq, altera_mbox_tx_interrupt, 0,
>
> Use devm_request_irq, since you didn't have and don't need use free_irq
> in the shutdown function.
We want to free_irq when it shutdown. That means nobody requests for
that mailbox (or channel) and request_irq() again if someone requests
for a mailbox.

>
>> +                     DRIVER_NAME, chan);
>> +             if (unlikely(ret)) {
>> +                     dev_err(mbox->dev,
>> +                             "failed to register mailbox interrupt:%d\n",
>> +                             ret);
>> +                     return ret;
>> +             }
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static int altera_mbox_startup_receiver(struct mbox_chan *chan)
>> +{
>> +     int ret;
>> +     struct altera_mbox *mbox = to_altera_mbox(chan);
>> +
>> +     if (mbox->intr_mode) {
>> +             ret = request_irq(mbox->irq, altera_mbox_rx_interrupt, 0,
>> +                     DRIVER_NAME, chan);
>
> Use devm_request_irq
>
>
>> +             if (unlikely(ret)) {
>> +                     dev_err(mbox->dev,
>> +                             "failed to register mailbox interrupt:%d\n",
>> +                             ret);
>> +                     return ret;
>> +             }
>> +             altera_mbox_rx_intmask(mbox, true);
>> +     } else {
>> +             /* Setup polling timer */
>> +             setup_timer(&mbox->rxpoll_timer, altera_mbox_poll_rx,
>> +                     (unsigned long)chan);
>> +             mod_timer(&mbox->rxpoll_timer,
>> +                     jiffies + msecs_to_jiffies(MBOX_POLLING_MS));
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static int altera_mbox_send_data(struct mbox_chan *chan, void *data)
>> +{
>> +     struct altera_mbox *mbox = to_altera_mbox(chan);
>> +     u32 *udata = (u32 *)data;
>> +
>> +     if (!mbox || !data)
>> +             return -EINVAL;
>> +     if (!mbox->is_sender) {
>> +             dev_warn(mbox->dev,
>> +                     "failed to send. This is receiver mailbox.\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     if (altera_mbox_full(mbox))
>> +             return -EBUSY;
>> +
>> +     /* Enable interrupt before send */
>> +     altera_mbox_tx_intmask(mbox, true);
>> +
>> +     /* Pointer register must write before command register */
>> +     __raw_writel(udata[MBOX_PTR], mbox->mbox_base + MAILBOX_PTR_REG);
>> +     __raw_writel(udata[MBOX_CMD], mbox->mbox_base + MAILBOX_CMD_REG);
>> +
>> +     return 0;
>> +}
>> +
>> +static bool altera_mbox_last_tx_done(struct mbox_chan *chan)
>> +{
>> +     struct altera_mbox *mbox = to_altera_mbox(chan);
>> +
>> +     if (WARN_ON(!mbox))
>> +             return false;
>
> Are these checks necessary? Shouldn't the driver probe function have
> already failed?
Will removed.

>> +
>> +     /* Return false if mailbox is full */
>> +     return altera_mbox_full(mbox) ? false : true;
>> +}
>> +
>> +static bool altera_mbox_peek_data(struct mbox_chan *chan)
>> +{
>> +     struct altera_mbox *mbox = to_altera_mbox(chan);
>> +
>> +     if (WARN_ON(!mbox))
>> +             return false;
>> +
>> +     return altera_mbox_pending(mbox) ? true : false;
>> +}
>> +
>> +static int altera_mbox_startup(struct mbox_chan *chan)
>> +{
>> +     struct altera_mbox *mbox = to_altera_mbox(chan);
>> +     int ret = 0;
>> +
>> +     if (!mbox)
>> +             return -EINVAL;
>> +
>> +     if (mbox->is_sender)
>> +             ret = altera_mbox_startup_sender(chan);
>> +     else
>> +             ret = altera_mbox_startup_receiver(chan);
>> +
>> +     return ret;
>> +}
>> +
>> +static void altera_mbox_shutdown(struct mbox_chan *chan)
>> +{
>> +     struct altera_mbox *mbox = to_altera_mbox(chan);
>> +
>> +     if (WARN_ON(!mbox))
>> +             return;
>> +
>> +     if (mbox->intr_mode) {
>> +             /* Unmask all interrupt masks */
>> +             __raw_writel(~0, mbox->mbox_base + MAILBOX_INTMASK_REG);
>> +             free_irq(mbox->irq, chan);
>> +     } else if (!mbox->is_sender)
>> +             del_timer_sync(&mbox->rxpoll_timer);
>
> Need braces around the else as well.
Noted.
>
>> +}
>> +
>> +static struct mbox_chan_ops altera_mbox_ops = {
>> +     .send_data = altera_mbox_send_data,
>> +     .startup = altera_mbox_startup,
>> +     .shutdown = altera_mbox_shutdown,
>> +     .last_tx_done = altera_mbox_last_tx_done,
>> +     .peek_data = altera_mbox_peek_data,
>> +};
>> +
>> +static int altera_mbox_probe(struct platform_device *pdev)
>> +{
>> +     struct altera_mbox *mbox;
>> +     struct mbox_chan *chans[1];
>
> It would be cleaner if you use devm_kzalloc to allocate the channel here.
Okay.
>
>> +     struct resource *regs;
>> +     int ret;
>> +
>> +     mbox = devm_kzalloc(&pdev->dev, sizeof(struct altera_mbox),
>> +             GFP_KERNEL);
>> +     if (!mbox)
>> +             return -ENOMEM;
>> +
>> +     regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +     if (!regs)
>> +             return -ENXIO;
>> +
>> +     mbox->mbox_base = devm_ioremap_resource(&pdev->dev, regs);
>> +     if (IS_ERR(mbox->mbox_base))
>> +             return PTR_ERR(mbox->mbox_base);
>> +
>> +     /* Check is it a sender or receiver? */
>> +     mbox->is_sender = altera_mbox_is_sender(mbox);
>> +
>> +     mbox->irq = platform_get_irq(pdev, 0);
>> +     if (mbox->irq >= 0)
>> +             mbox->intr_mode = true;
>> +
>> +     mbox->dev = &pdev->dev;
>> +
>> +     /* Hardware supports only one channel. */
>> +     chans[0] = &mbox->chan;
>> +     mbox->controller.dev = mbox->dev;
>> +     mbox->controller.num_chans = 1;
>> +     mbox->controller.chans =  &mbox->chan;
>> +     mbox->controller.ops = &altera_mbox_ops;
>> +
>> +     if (mbox->is_sender) {
>> +             if (mbox->intr_mode)
>> +                     mbox->controller.txdone_irq = true;
>> +             else {
>> +                     mbox->controller.txdone_poll = true;
>> +                     mbox->controller.txpoll_period = MBOX_POLLING_MS;
>> +             }
>
> Need braces around the if as well.
Noted.
>

Regards
Ley Foon
