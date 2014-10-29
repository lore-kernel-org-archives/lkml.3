Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569AbaJ2Le1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 07:34:27 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:47628 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbaJ2LeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 07:34:24 -0400
Date: Wed, 29 Oct 2014 12:34:18 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
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
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH RESEND V4 2/9] mailbox: Add NVIDIA Tegra XUSB mailbox
 driver
Message-ID: <20141029113415.GD28356@ulmo.nvidia.com>
References: <1414535277-15645-1-git-send-email-abrestic@chromium.org>
 <1414535277-15645-3-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XvKFcGCOAo53UbWW"
Content-Disposition: inline
In-Reply-To: <1414535277-15645-3-git-send-email-abrestic@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XvKFcGCOAo53UbWW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2014 at 03:27:49PM -0700, Andrew Bresticker wrote:
[...]
> diff --git a/drivers/mailbox/tegra-xusb-mailbox.c b/drivers/mailbox/tegra=
-xusb-mailbox.c
[...]
> +struct tegra_xusb_mbox {
> +	struct mbox_controller mbox;
> +	int irq;

It seems like this is unused outside of tegra_xusb_mbox_probe()

> +static int tegra_xusb_mbox_send_data(struct mbox_chan *chan, void *data)
> +{
> +	struct tegra_xusb_mbox *mbox =3D dev_get_drvdata(chan->mbox->dev);

In my opinion, container_of(chan->mbox, struct tegra_xusb_mbox, mbox)
would be a slightly more idiomatic way to do this.

> +	struct tegra_xusb_mbox_msg *msg =3D data;
> +	unsigned long flags;
> +	u32 reg, owner;
> +
> +	dev_dbg(mbox->mbox.dev, "TX message 0x%x:0x%x\n", msg->cmd, msg->data);

%#x saves you a character in the format string above.

> +static int tegra_xusb_mbox_startup(struct mbox_chan *chan)
> +{
> +	struct tegra_xusb_mbox *mbox =3D dev_get_drvdata(chan->mbox->dev);
> +	int idx =3D chan - mbox->mbox.chans;

unsigned?

> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&mbox->lock, flags);
> +	mbox->vchan_allocated[idx] =3D true;
> +	spin_unlock_irqrestore(&mbox->lock, flags);

The struct mbox_chan has a con_priv field, perhaps that can be used to
store virtual channel private data instead of keeping the extra
vchan_allocated field in the controller private context? That way you
don't wouldn't have to compute an index and use it to index the field
in the controller private context.

In this particular case I don't think you even need that field, since a
channel is requested when the mbox_chan.cl field in non-NULL.

> +static struct mbox_chan_ops tegra_xusb_mbox_chan_ops =3D {

I think this really ought to be static const. That would currently still
throw a warning because the core doesn't mark the mbox_controller.ops
field const, but I think it really should. Now also seems like a good
time to make that change because there don't seem to be any users yet.

> +static irqreturn_t tegra_xusb_mbox_irq(int irq, void *p)
> +{
> +	struct tegra_xusb_mbox *mbox =3D (struct tegra_xusb_mbox *)p;

There's no need for the explicit cast here.

> +	struct tegra_xusb_mbox_msg msg;
> +	int i;

unsigned?

> +	u32 reg;
> +
> +	spin_lock(&mbox->lock);
> +
> +	/* Clear mbox interrupts */
> +	reg =3D mbox_readl(mbox, XUSB_CFG_ARU_SMI_INTR);
> +	if (reg & MBOX_SMI_INTR_FW_HANG)
> +		dev_err(mbox->mbox.dev, "Controller firmware hang\n");
> +	mbox_writel(mbox, reg, XUSB_CFG_ARU_SMI_INTR);
> +
> +	reg =3D mbox_readl(mbox, XUSB_CFG_ARU_MBOX_DATA_OUT);
> +	mbox_unpack_msg(reg, &msg);
> +
> +	/*
> +	 * Set the mailbox back to idle.  The recipient of the message is
> +	 * responsible for sending an ACK/NAK, if necessary.
> +	 */
> +	reg =3D mbox_readl(mbox, XUSB_CFG_ARU_MBOX_CMD);
> +	reg &=3D ~MBOX_DEST_SMI;
> +	mbox_writel(mbox, reg, XUSB_CFG_ARU_MBOX_CMD);
> +	mbox_writel(mbox, MBOX_OWNER_NONE, XUSB_CFG_ARU_MBOX_OWNER);
> +
> +	dev_dbg(mbox->mbox.dev, "RX message 0x%x:0x%x\n", msg.cmd, msg.data);

Again 0x%x -> %#x to save characters.

> +	for (i =3D 0; i < ARRAY_SIZE(mbox->vchan_allocated); i++) {
> +		if (mbox->vchan_allocated[i])
> +			mbox_chan_received_data(&mbox->mbox.chans[i], &msg);
> +	}

It seems like the only reason why you need to explicitly check for an
allocated channel is that mbox_chan_received_data() would otherwise
crash. Are mailbox drivers really supposed to keep track of whether a
channel has been requested by a client? Isn't that something that should
be done in the core?

> +static struct mbox_chan *tegra_xusb_mbox_of_xlate(struct mbox_controller=
 *ctlr,
> +					const struct of_phandle_args *sp)
> +{
> +	struct tegra_xusb_mbox *mbox =3D dev_get_drvdata(ctlr->dev);

container_of()?

> +	struct mbox_chan *chan =3D NULL;
> +	unsigned long flags;
> +	int i;

unsigned?

> +static struct of_device_id tegra_xusb_mbox_of_match[] =3D {

static const, please.

> +static int tegra_xusb_mbox_probe(struct platform_device *pdev)
> +{
> +	struct tegra_xusb_mbox *mbox;
> +	struct resource *res;
> +	int ret;
> +
> +	mbox =3D devm_kzalloc(&pdev->dev, sizeof(*mbox), GFP_KERNEL);
> +	if (!mbox)
> +		return -ENOMEM;
> +	platform_set_drvdata(pdev, mbox);
> +	spin_lock_init(&mbox->lock);
> +
> +	mbox->mbox.dev =3D &pdev->dev;
> +	mbox->mbox.chans =3D devm_kcalloc(&pdev->dev, TEGRA_XUSB_MBOX_NUM_CHANS,
> +					sizeof(*mbox->mbox.chans), GFP_KERNEL);
> +	if (!mbox->mbox.chans)
> +		return -ENOMEM;
> +	mbox->mbox.num_chans =3D TEGRA_XUSB_MBOX_NUM_CHANS;
> +	mbox->mbox.ops =3D &tegra_xusb_mbox_chan_ops;
> +	mbox->mbox.txdone_poll =3D true;
> +	mbox->mbox.txpoll_period =3D 0; /* no need to actually poll */

Does the core perhaps need special handling for this? It seems like
poll_txdone() will always rearm the timer used to do the polling,
irrespective of whether the transfer is actually done or not. Maybe
something like this patch would be more correct in handling this:

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index afcb430508ec..85691a7d8ca6 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -117,10 +117,11 @@ static void poll_txdone(unsigned long data)
 		struct mbox_chan *chan =3D &mbox->chans[i];
=20
 		if (chan->active_req && chan->cl) {
-			resched =3D true;
 			txdone =3D chan->mbox->ops->last_tx_done(chan);
 			if (txdone)
 				tx_tick(chan, 0);
+			else
+				resched =3D true;
 		}
 	}
=20

The comment "no need to actually poll" isn't really appropriate in the
context of txpoll_period =3D 0.

> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -ENODEV;
> +	mbox->regs =3D devm_ioremap(&pdev->dev, res->start, resource_size(res));
> +	if (!mbox->regs)
> +		return -ENOMEM;

This doesn't look right. Upon closer inspection, the reason why you
don't use devm_request_resource() is because these registers are shared
with the XHCI controller.

Perhaps a better design would be for the XHCI driver to expose the
mailbox rather than split it off into a separate driver.

> +static struct platform_driver tegra_xusb_mbox_driver =3D {
> +	.probe	=3D tegra_xusb_mbox_probe,
> +	.remove	=3D tegra_xusb_mbox_remove,
> +	.driver	=3D {
> +		.name =3D "tegra-xusb-mbox",
> +		.of_match_table =3D of_match_ptr(tegra_xusb_mbox_of_match),
> +	},

This uses tabs and spaces inconsistently for padding. I prefer a single
space on either side of the '=3D' like you've done for the fields of
=2Edriver above.

> diff --git a/include/soc/tegra/xusb.h b/include/soc/tegra/xusb.h
> new file mode 100644
> index 0000000..cfe211d
> --- /dev/null
> +++ b/include/soc/tegra/xusb.h

Perhaps this should really be named xusb-mbox.h?

> @@ -0,0 +1,46 @@
> +/*
> + * Copyright (C) 2014 NVIDIA Corporation
> + * Copyright (C) 2014 Google, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify =
it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + */
> +
> +#ifndef __SOC_TEGRA_XUSB_H__
> +#define __SOC_TEGRA_XUSB_H__
> +
> +/* Two virtual channels: host + phy */
> +#define TEGRA_XUSB_MBOX_NUM_CHANS 2

I don't think this belongs in this public header. Who is going to need
this besides the XUSB mailbox driver?

Thierry

--XvKFcGCOAo53UbWW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUUNC3AAoJEN0jrNd/PrOhAdAQAJy0hXZtYFZHrucZGpNfDyYV
evtZYHavk2E6PGJAu1IUs1UbIdyWB2lhrAN/rFLoXYdmd6Fy9icF3NuDPAxceINV
BNsdenhxd86kU/MCI9vW+r4wNRWnFW3n2Fkhuiu/1Il3VdGN1yu+y7nCojKnbWfG
pGszZnDLI2i/R99xa1KmtCyEr4DJ1gM0g91/96uvA9zBYe0FMiEtD1cSDxLdpbfD
3UYv8/m+O9MjrQQP1f4R5/MhknCG+57bf+m9rbAlhLDfmVjh1mjjc+NQ3yD3ewdV
c+iiD6AWpCR8NJdCqFdynlqsAEM169uafui0TE/8K+bUdC3qct+m3ud8yaYxaqQm
JRdHzjGSHm8aTWX/e10eUMLOxUsfuwsDEKQWZB8F16fiTPO+3dvX4D7pZVJ1BKQI
JtIh5OuLtJFf4s1/3hooAV/0TT+ZRk67ViWE3ZtMxKP3R4WRpGxBQyuE15xNYgxY
miY+YGHa/FjRAKbKKlJl4lf2LTCH5yObZQGKth3kVtMdiwAEH+fV0icj2eQdyZAp
7w4xadqTFaLsPEPYA573U5sZwJivyzeSLyVfeFfQeQ/Qzak2y4Dor1WBtyfqYJm5
3vUHTjGyToaEb/DzS2jfnTw/1T27eCdHCSmY6SyWqbN02ecoiG4CGH/9Gfse4FsK
16hi+ZZoh/4Fh2jqx5KS
=qWJc
-----END PGP SIGNATURE-----

--XvKFcGCOAo53UbWW--
