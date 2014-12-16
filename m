Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbaLPGdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 01:33:38 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:33112 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaLPGdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 01:33:37 -0500
MIME-Version: 1.0
In-Reply-To: <548F4A99.7040409@ti.com>
References: <1418378690-3466-1-git-send-email-lftan@altera.com>
	<548AFDE9.6000909@gmail.com>
	<548F4A99.7040409@ti.com>
Date: Tue, 16 Dec 2014 14:33:34 +0800
X-Google-Sender-Auth: RAIzHEWvuXVCue_rOs1I9m2A2-w
Message-ID: <CAFiDJ5-b9qsLKj8Qh2+yx8_Y1nv5CG1PHyn2Se0zzZLSHWTKNg@mail.gmail.com>
Subject: Re: [PATCH (resend)] mailbox: Add Altera mailbox driver
From: Ley Foon Tan <lftan@altera.com>
To: Suman Anna <s-anna@ti.com>
Cc: Dinh Nguyen <dinh.linux@gmail.com>, Jassi Brar <jassisinghbrar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 4:54 AM, Suman Anna <s-anna@ti.com> wrote:
> Hi Ley Foon,
>
> On 12/12/2014 08:38 AM, Dinh Nguyen wrote:
>>
>>
>> On 12/12/14, 4:04 AM, Ley Foon Tan wrote:
>>> The Altera mailbox allows for interprocessor communication. It supports
>>> only one channel and work as either sender or receiver.
>
> I have a few more comments in addition to those that Dinh provided.
>
>>>
>>> Signed-off-by: Ley Foon Tan <lftan@altera.com>
>>> ---
>>>  .../devicetree/bindings/mailbox/altera-mailbox.txt |  49 +++
>>>  drivers/mailbox/Kconfig                            |   6 +
>>>  drivers/mailbox/Makefile                           |   2 +
>>>  drivers/mailbox/mailbox-altera.c                   | 404 +++++++++++++++++++++
>>>  4 files changed, 461 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/mailbox/altera-mailbox.txt
>>>  create mode 100644 drivers/mailbox/mailbox-altera.c
>>>
>>> diff --git a/Documentation/devicetree/bindings/mailbox/altera-mailbox.txt b/Documentation/devicetree/bindings/mailbox/altera-mailbox.txt
>>> new file mode 100644
>>> index 0000000..c261979
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/mailbox/altera-mailbox.txt
>>> @@ -0,0 +1,49 @@
>>> +Altera Mailbox Driver
>>> +=====================
>>> +
>>> +Required properties:
>>> +- compatible :      "altr,mailbox-1.0".
>
> I am not sure on this convention, sounds like IP version number. Please
> check this with a DT maintainer.
Our other soft IPs compatible strings all have 1.0 version number. Eg:
altr,juart-1.0.
So, we want to keep it as same format.

>>> diff --git a/drivers/mailbox/Kconfig b/drivers/mailbox/Kconfig
>>> index c04fed9..84325f2 100644
>>> --- a/drivers/mailbox/Kconfig
>>> +++ b/drivers/mailbox/Kconfig
>>> @@ -45,4 +45,10 @@ config PCC
>>>        states). Select this driver if your platform implements the
>>>        PCC clients mentioned above.
>>>
>>> +config ALTERA_MBOX
>>> +    tristate "Altera Mailbox"
>
> You haven't used any depends on here, this driver is not applicable on
> all platforms, right?
It is a soft IP, so it is not limited to our platform only.
Other soft IP drivers also don't have 'depend on', so I think should be fine.


>>> +
>>> +static inline struct altera_mbox *to_altera_mbox(struct mbox_chan *chan)
>>> +{
>>> +    if (!chan)
>>> +            return NULL;
>>> +
>>> +    return container_of(chan, struct altera_mbox, chan);
>>> +}
>>> +
>>> +static inline int altera_mbox_full(struct altera_mbox *mbox)
>>> +{
>>> +    u32 status;
>>> +
>>> +    status = __raw_readl(mbox->mbox_base + MAILBOX_STS_REG);
>
> You may want to replace all the __raw_readl/__raw_writel with regular
> readl/writel or its equivalent relaxed versions depending on your needs.
Okay.


>>> +static int altera_mbox_send_data(struct mbox_chan *chan, void *data)
>>> +{
>>> +    struct altera_mbox *mbox = to_altera_mbox(chan);
>>> +    u32 *udata = (u32 *)data;
>>> +
>>> +    if (!mbox || !data)
>>> +            return -EINVAL;
>>> +    if (!mbox->is_sender) {
>>> +            dev_warn(mbox->dev,
>>> +                    "failed to send. This is receiver mailbox.\n");
>>> +            return -EINVAL;
>>> +    }
>>> +
>>> +    if (altera_mbox_full(mbox))
>>> +            return -EBUSY;
>
> I think this logic in general will conflict between interrupt and poll
> mode. send_data is supposed to return -EBUSY only in polling mode and
> not in interrupt mode.
What is the recommended error code for this case? BTW, omap-mailbox.c
also return -EBUSY if mailbox is full.

>>> +
>>> +    /* Enable interrupt before send */
>>> +    altera_mbox_tx_intmask(mbox, true);
>
> Is this true and required in Polling mode too?
Add checking for interrupt mode here.


>
> Do you even need the chans variable, don't see it getting used
> anywhere. You are directly using the mbox->chan during registration..
Will update this.
>
>>
>>> +    struct resource *regs;
>>> +    int ret;
>>> +
>>> +    mbox = devm_kzalloc(&pdev->dev, sizeof(struct altera_mbox),
>
> Use sizeof(*mbox)
Okay.

>
>>> +            GFP_KERNEL);
>
> You have a few "Alignment should match open parenthesis" checks
> generated with the --strict option on checkpatch. I am not sure if Jassi
> is requiring them, but I would recommend that you fix all of them.
Okay, will check these.

>
>>> +    if (!mbox)
>>> +            return -ENOMEM;
>>> +
>>> +    regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>> +    if (!regs)
>>> +            return -ENXIO;
>
> You can remove the check for regs, devm_ioremap_resource is capable
> of handling the error.
Okay.

>>> +
>>> +    mbox->mbox_base = devm_ioremap_resource(&pdev->dev, regs);
>>> +    if (IS_ERR(mbox->mbox_base))
>>> +            return PTR_ERR(mbox->mbox_base);
>>> +
>>> +    /* Check is it a sender or receiver? */
>>> +    mbox->is_sender = altera_mbox_is_sender(mbox);
>>> +
>>> +    mbox->irq = platform_get_irq(pdev, 0);
>>> +    if (mbox->irq >= 0)
>>> +            mbox->intr_mode = true;
>
> This seems to be a poor way of setting up the mode. Is it the same IP
> block but different integration on different SoCs? Or on the same SoC,
> and you can use it either by interrupt driven or by polling.
Yes, it can use interrupt or polling mode depends on hardware configurations.
It is a soft IP and can be configured with different hardware configurations.

>>> +
>>> +    mbox->dev = &pdev->dev;
>>> +
>>> +    /* Hardware supports only one channel. */
>>> +    chans[0] = &mbox->chan;
>>> +    mbox->controller.dev = mbox->dev;
>>> +    mbox->controller.num_chans = 1;
>>> +    mbox->controller.chans =  &mbox->chan;
>>> +    mbox->controller.ops = &altera_mbox_ops;
>>> +
>>> +    if (mbox->is_sender) {
>>> +            if (mbox->intr_mode)
>>> +                    mbox->controller.txdone_irq = true;
>>> +            else {
>>> +                    mbox->controller.txdone_poll = true;
>>> +                    mbox->controller.txpoll_period = MBOX_POLLING_MS;
>>> +            }
>>
>> Need braces around the if as well.
>>
>>> +    }
>>> +
>>> +    ret = mbox_controller_register(&mbox->controller);
>>> +    if (ret) {
>>> +            dev_err(&pdev->dev, "Register mailbox failed\n");
>>> +            goto err;
>>> +    }
>>> +
>>> +    platform_set_drvdata(pdev, mbox);
>>> +    return 0;
>
> Not required, ret should be 0 if mbox_controller_register succeeds.
Okay.
>
>>> +err:
>>> +    return ret;
>>> +}
>>> +
>>> +static int altera_mbox_remove(struct platform_device *pdev)
>>> +{
>>> +    struct altera_mbox *mbox = platform_get_drvdata(pdev);
>>> +
>>> +    if (!mbox)
>>> +            return -EINVAL;
>>> +
>>> +    mbox_controller_unregister(&mbox->controller);
>>> +
>>> +    platform_set_drvdata(pdev, NULL);
>
> This is not required.
Okay.
>
>>> +    return 0;
>>> +}
>>> +
>>> +static const struct of_device_id altera_mbox_match[] = {
>>> +    { .compatible = "altr,mailbox-1.0" },
>>> +    { /* Sentinel */ }
>>> +};
>>> +
>>> +MODULE_DEVICE_TABLE(of, altera_mbox_match);
>>> +
>>> +static struct platform_driver altera_mbox_driver = {
>>> +    .probe  = altera_mbox_probe,
>>> +    .remove = altera_mbox_remove,
>>> +    .driver = {
>>> +            .name   = DRIVER_NAME,
>>> +            .owner  = THIS_MODULE,
>>> +            .of_match_table = altera_mbox_match,
>
> of_match_ptr(altera_mbox_match).
Okay.
>
>>> +    },
>>> +};
>>> +
>>> +static int altera_mbox_init(void)
>>> +{
>>> +    return platform_driver_register(&altera_mbox_driver);
>>> +}
>>> +
>>> +static void altera_mbox_exit(void)
>>> +{
>>> +    platform_driver_unregister(&altera_mbox_driver);
>>> +}
>
> Use module_platform_driver here as you are using just regular platform
> driver register and unregister.
>
Okay.

Thanks for reviewing.

Regards.
