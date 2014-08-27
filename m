Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935519AbaH0RjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:39:00 -0400
Received: from mail-yk0-f174.google.com ([209.85.160.174]:48789 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935441AbaH0Ri5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:38:57 -0400
MIME-Version: 1.0
In-Reply-To: <53FB8820.4010202@wwwdotorg.org>
References: <1408381705-3623-1-git-send-email-abrestic@chromium.org>
	<1408381705-3623-3-git-send-email-abrestic@chromium.org>
	<53FB8820.4010202@wwwdotorg.org>
Date: Wed, 27 Aug 2014 10:38:56 -0700
X-Google-Sender-Auth: VMUKswunlBGr66PljCwN2qZl0us
Message-ID: <CAL1qeaERHeKKNpqh9qHOppgT7ymvntisdjVvZheP78U6NaPz-A@mail.gmail.com>
Subject: Re: [PATCH v2 2/9] mailbox: Add NVIDIA Tegra XUSB mailbox driver
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Jassi Brar <jassisinghbrar@gmail.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
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

On Mon, Aug 25, 2014 at 12:01 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/18/2014 11:08 AM, Andrew Bresticker wrote:
>>
>> The Tegra xHCI controller's firmware communicates requests to the host
>> processor through a mailbox interface.  While there is only a single
>> communication channel, messages sent by the controller can be divided
>> into two groups: those intended for the PHY driver and those intended
>> for the host-controller driver.  This mailbox driver exposes the two
>> channels and routes incoming messages to the appropriate channel based
>> on the command encoded in the message.
>
>
>> diff --git a/drivers/mailbox/tegra-xusb-mailbox.c
>> b/drivers/mailbox/tegra-xusb-mailbox.c
>
>
>> +#define XUSB_CFG_ARU_MBOX_CMD                  0xe4
>> +#define  MBOX_FALC_INT_EN                      BIT(27)
>> +#define  MBOX_PME_INT_EN                       BIT(28)
>> +#define  MBOX_SMI_INT_EN                       BIT(29)
>> +#define  MBOX_XHCI_INT_EN                      BIT(30)
>> +#define  MBOX_INT_EN                           BIT(31)
>
>
> Those field names don't match the documentation in the TRM; they're called
> DEST_xxx rather than xxx_INT_EN. I'm not sure what that disconnect means
> (i.e. whether it's just a different naming choice, or there's some practical
> disconnect that will cause issues.)

Hmm... interestingly *_INT_EN is the convention the downstream kernels
used.  DEST_* is definitely more accurate as I'm pretty sure these
bits select the destination for the interrupt.

>> +static struct mbox_chan *mbox_cmd_to_chan(struct tegra_xusb_mbox *mbox,
>> u32 cmd)
>> +{
>> +       switch (cmd) {
>> +       case MBOX_CMD_INC_FALC_CLOCK:
>> +       case MBOX_CMD_DEC_FALC_CLOCK:
>> +       case MBOX_CMD_INC_SSPI_CLOCK:
>> +       case MBOX_CMD_DEC_SSPI_CLOCK:
>> +       case MBOX_CMD_SET_BW:
>> +               return &mbox->mbox.chans[TEGRA_XUSB_MBOX_CHAN_HOST];
>> +       case MBOX_CMD_SAVE_DFE_CTLE_CTX:
>> +       case MBOX_CMD_START_HSIC_IDLE:
>> +       case MBOX_CMD_STOP_HSIC_IDLE:
>> +               return &mbox->mbox.chans[TEGRA_XUSB_MBOX_CHAN_PHY];
>> +       default:
>> +               return NULL;
>> +       }
>> +}
>
>
> This makes me think that the CHAN_HOST/CHAN_PHY values are purely a facet of
> the Linux driver's message de-multiplexing, rather than anything to do with
> the HW.

Yup, they are...

> I'm not even sure if it's appropriate for the low-level mailbox driver to
> know about the semantics of the message, rather than simply sending them on
> to the client driver? Perhaps when drivers register(?) for callbacks(?) for
> messages, they should state which types of messages they want to listen to?

So there's not really a way for the client driver to tell the mailbox
driver which types of messages it wants to listen to on a particular
channel with the mailbox framework - it simply provides a way for
clients to bind with channels.  I think there are a couple of options
here, either: a) have a channel per message (as you mentioned in the
previous patch), which allows the client to only register for messages
(channels) it wants to handle, or b) extend the mailbox framework to
allow shared channels so that both clients can receive messages on the
single channel and handle messages appropriately.   The disadvantage
of (a) is that the commands are firmware defined and could
theoretically change between releases of the firmware, though I'm not
sure how common that is in practice.  So that leaves (b) - Jassi, what
do you think about having shared (non-exclusive) channels?

>> +static irqreturn_t tegra_xusb_mbox_irq(int irq, void *p)
>
>
>> +       /* Clear mbox interrupts */
>>
>> +       reg = mbox_readl(mbox, XUSB_CFG_ARU_SMI_INTR);
>> +       if (reg & MBOX_SMI_INTR_FW_HANG)
>> +               dev_err(mbox->mbox.dev, "Controller firmware hang\n");
>> +       mbox_writel(mbox, reg, XUSB_CFG_ARU_SMI_INTR);
>
>
>> +       /*
>>
>> +        * Set the mailbox back to idle.  The recipient of the message is
>> +        * responsible for sending an ACK/NAK, if necessary.
>> +        */
>> +       reg = mbox_readl(mbox, XUSB_CFG_ARU_MBOX_CMD);
>> +       reg &= ~MBOX_SMI_INT_EN;
>> +       mbox_writel(mbox, reg, XUSB_CFG_ARU_MBOX_CMD);
>
>
> Does the protocol not allow the remote firmware to send another message
> until the host has ack'd/nak'd the message; the code above turns off the IRQ
> that indicated to the host that a message was sent to it...

While the firmware generally will not send another message until the
previous one is ACK'd/NAK'd (with the exception of the SET_BW
command), the above does not prevent it from doing so.  I believe the
controller sets up the DEST_* bits properly before sending another
message.

>> +static int tegra_xusb_mbox_probe(struct platform_device *pdev)
>
>
>> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>
>> +       if (!res)
>> +               return -ENODEV;
>
>
> Should devm_request_mem_region() be called here to claim the region?

No, the xHCI host driver also needs to map these registers, so they
cannot be mapped exclusively here.

>> +       mbox->regs = devm_ioremap_nocache(&pdev->dev, res->start,
>> +                                         resource_size(res));
>> +       if (!mbox->regs)
>> +               return -ENOMEM;
>
>
> Is _nocache required? I don't see other drivers using it. I assume there's
> nothing special about the mbox registers.

I'll drop the _nocache.

>> +       mbox->irq = platform_get_irq(pdev, 0);
>> +       if (mbox->irq < 0)
>> +               return mbox->irq;
>> +       ret = devm_request_irq(&pdev->dev, mbox->irq, tegra_xusb_mbox_irq,
>> 0,
>> +                              dev_name(&pdev->dev), mbox);
>
>
> Is it possible for an IRQ to occur after tegra_xusb_mbox_remove() has
> returned, but before the cleanup for the devm IRQ allocation occurs? If that
> happens, will the code handle it gracefully, or crash?

It looks like mbox_chan_received_data() will crash if the channel is
unbound, so yes, this needs to be fixed.
