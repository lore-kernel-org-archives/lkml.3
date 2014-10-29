Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbaJ2SCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 14:02:40 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34090 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbaJ2SCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 14:02:37 -0400
MIME-Version: 1.0
In-Reply-To: <20141029113415.GD28356@ulmo.nvidia.com>
References: <1414535277-15645-1-git-send-email-abrestic@chromium.org>
	<1414535277-15645-3-git-send-email-abrestic@chromium.org>
	<20141029113415.GD28356@ulmo.nvidia.com>
Date: Wed, 29 Oct 2014 11:02:36 -0700
X-Google-Sender-Auth: 8k4kScw_KPGOtNThqn3tWkfURxY
Message-ID: <CAL1qeaG2DFyfsPa2wgDqOkYTbnJ-tXoiV48AF9EaSCf1QCtOyQ@mail.gmail.com>
Subject: Re: [PATCH RESEND V4 2/9] mailbox: Add NVIDIA Tegra XUSB mailbox driver
From: Andrew Bresticker <abrestic@chromium.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +     for (i = 0; i < ARRAY_SIZE(mbox->vchan_allocated); i++) {
>> +             if (mbox->vchan_allocated[i])
>> +                     mbox_chan_received_data(&mbox->mbox.chans[i], &msg);
>> +     }
>
> It seems like the only reason why you need to explicitly check for an
> allocated channel is that mbox_chan_received_data() would otherwise
> crash. Are mailbox drivers really supposed to keep track of whether a
> channel has been requested by a client? Isn't that something that should
> be done in the core?

Yeah, I'd agree that this is something that should be handled by the core.

>> +static int tegra_xusb_mbox_probe(struct platform_device *pdev)
>> +{
>> +     struct tegra_xusb_mbox *mbox;
>> +     struct resource *res;
>> +     int ret;
>> +
>> +     mbox = devm_kzalloc(&pdev->dev, sizeof(*mbox), GFP_KERNEL);
>> +     if (!mbox)
>> +             return -ENOMEM;
>> +     platform_set_drvdata(pdev, mbox);
>> +     spin_lock_init(&mbox->lock);
>> +
>> +     mbox->mbox.dev = &pdev->dev;
>> +     mbox->mbox.chans = devm_kcalloc(&pdev->dev, TEGRA_XUSB_MBOX_NUM_CHANS,
>> +                                     sizeof(*mbox->mbox.chans), GFP_KERNEL);
>> +     if (!mbox->mbox.chans)
>> +             return -ENOMEM;
>> +     mbox->mbox.num_chans = TEGRA_XUSB_MBOX_NUM_CHANS;
>> +     mbox->mbox.ops = &tegra_xusb_mbox_chan_ops;
>> +     mbox->mbox.txdone_poll = true;
>> +     mbox->mbox.txpoll_period = 0; /* no need to actually poll */
>
> Does the core perhaps need special handling for this? It seems like
> poll_txdone() will always rearm the timer used to do the polling,
> irrespective of whether the transfer is actually done or not.

Yeah, that doesn't seem quite right...

> Maybe something like this patch would be more correct in handling
> this:
>
> diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
> index afcb430508ec..85691a7d8ca6 100644
> --- a/drivers/mailbox/mailbox.c
> +++ b/drivers/mailbox/mailbox.c
> @@ -117,10 +117,11 @@ static void poll_txdone(unsigned long data)
>                 struct mbox_chan *chan = &mbox->chans[i];
>
>                 if (chan->active_req && chan->cl) {
> -                       resched = true;
>                         txdone = chan->mbox->ops->last_tx_done(chan);
>                         if (txdone)
>                                 tx_tick(chan, 0);
> +                       else
> +                               resched = true;
>                 }
>         }

... but we still need to re-arm the timer if tx_tick() submits another
message.  Perhaps the better thing to do is to have msg_submit() arm
the timer.

>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +     if (!res)
>> +             return -ENODEV;
>> +     mbox->regs = devm_ioremap(&pdev->dev, res->start, resource_size(res));
>> +     if (!mbox->regs)
>> +             return -ENOMEM;
>
> This doesn't look right. Upon closer inspection, the reason why you
> don't use devm_request_resource() is because these registers are shared
> with the XHCI controller.
>
> Perhaps a better design would be for the XHCI driver to expose the
> mailbox rather than split it off into a separate driver.

Well that's what I had originally, but then it was suggested I make it
a separate driver.

Stephen also brought this up during review and suggested that some
sort of MFD would be the best way to structure this, but was fine with
the way I have it now.  I can move this driver around (again) if you
feel that strongly about it...

>> diff --git a/include/soc/tegra/xusb.h b/include/soc/tegra/xusb.h
>> new file mode 100644
>> index 0000000..cfe211d
>> --- /dev/null
>> +++ b/include/soc/tegra/xusb.h
>
> Perhaps this should really be named xusb-mbox.h?

I'd prefer to leave it as xusb.h so that any other XUSB-related
definitions can be left here.
