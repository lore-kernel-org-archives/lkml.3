Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbaKXIex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 03:34:53 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:43188 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbaKXIeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 03:34:50 -0500
MIME-Version: 1.0
In-Reply-To: <1416264102-1323-6-git-send-email-abrestic@chromium.org>
References: <1416264102-1323-1-git-send-email-abrestic@chromium.org>
	<1416264102-1323-6-git-send-email-abrestic@chromium.org>
Date: Mon, 24 Nov 2014 14:04:49 +0530
Message-ID: <CAJe_ZhdTvZZqERttAM_o6U6MZCOjk=oXpWFPf8W=DdW1j=Nx=g@mail.gmail.com>
Subject: Re: [PATCH V5 05/12] mailbox: Add NVIDIA Tegra XUSB mailbox driver
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 November 2014 at 04:11, Andrew Bresticker <abrestic@chromium.org> wrote:

> +
> +static int tegra_xusb_mbox_send_data(struct mbox_chan *chan, void *data)
> +{
> +       struct tegra_xusb_mbox *mbox = to_tegra_mbox(chan->mbox);
> +       struct tegra_xusb_mbox_msg *msg = data;
> +       unsigned long flags;
> +       u32 reg, owner;
> +
> +       dev_dbg(mbox->mbox.dev, "TX message %#x:%#x\n", msg->cmd, msg->data);
> +
> +       /* ACK/NAK must be sent with the controller as the mailbox owner */
> +       if (msg->cmd == MBOX_CMD_ACK || msg->cmd == MBOX_CMD_NAK)
> +               owner = MBOX_OWNER_FW;
> +       else
> +               owner = MBOX_OWNER_SW;
> +
> +       spin_lock_irqsave(&mbox->lock, flags);
> +
> +       /* Acquire mailbox */
> +       if (mbox_readl(mbox, XUSB_CFG_ARU_MBOX_OWNER) != MBOX_OWNER_NONE) {
> +               dev_err(mbox->mbox.dev, "Mailbox not idle\n");
> +               goto busy;
> +       }
> +       mbox_writel(mbox, owner, XUSB_CFG_ARU_MBOX_OWNER);
> +       if (mbox_readl(mbox, XUSB_CFG_ARU_MBOX_OWNER) != owner) {
> +               dev_err(mbox->mbox.dev, "Failed to acquire mailbox");
> +               goto busy;
> +       }
> +
> +       mbox_writel(mbox, mbox_pack_msg(msg), XUSB_CFG_ARU_MBOX_DATA_IN);
> +       reg = mbox_readl(mbox, XUSB_CFG_ARU_MBOX_CMD);
> +       reg |= MBOX_INT_EN | MBOX_DEST_FALC;
> +       mbox_writel(mbox, reg, XUSB_CFG_ARU_MBOX_CMD);
> +
> +       spin_unlock_irqrestore(&mbox->lock, flags);
> +
> +       return 0;
> +busy:
> +       spin_unlock_irqrestore(&mbox->lock, flags);
> +       return -EBUSY;
> +}
> +
> +static int tegra_xusb_mbox_startup(struct mbox_chan *chan)
> +{
> +       return 0;
> +}
> +
> +static void tegra_xusb_mbox_shutdown(struct mbox_chan *chan)
> +{
> +}
> +
> +static bool tegra_xusb_mbox_last_tx_done(struct mbox_chan *chan)
> +{
> +       /*
> +        * Transmissions are assumed to be completed as soon as they are
> +        * written to the mailbox.
> +        */
> +       return true;
>
In .send_data() you you mark the channel busy by setting the
XUSB_CFG_ARU_MBOX_OWNER to !MBOX_OWNER_NONE, which remains so until
you get an IRQ. So maybe you should check for the OWNER_NONE flag in
.last_tx_done()?

-Jassi
