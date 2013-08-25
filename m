Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab3HYAOF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 20:14:05 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:50169 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941Ab3HYAOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 20:14:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, mark.rutland@arm.com,
        pawel.moll@arm.com, galak@codeaurora.org, rob.herring@calxeda.com
Subject: Re: [PATCH v2 3/3] gpio: pcf857x: Add OF support
Date: Sun, 25 Aug 2013 02:15:18 +0200
Message-ID: <11480687.DR76avTJMu@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <2417846.CRj8QejgZy@flatron>
References: <1376953494-9684-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1688346.YLZnUtEaXr@avalon> <2417846.CRj8QejgZy@flatron>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On Saturday 24 August 2013 16:13:11 Tomasz Figa wrote:
> On Saturday 24 of August 2013 02:54:07 Laurent Pinchart wrote:
> > On Saturday 24 August 2013 02:41:59 Tomasz Figa wrote:
> > > On Tuesday 20 of August 2013 01:04:54 Laurent Pinchart wrote:
> > > > Add DT bindings for the pcf857x-compatible chips and parse the
> > > > device tree node in the driver.
> > > > 
> > > > Signed-off-by: Laurent Pinchart
> > > > <laurent.pinchart+renesas@ideasonboard.com> ---
> > > > 
> > > >  .../devicetree/bindings/gpio/gpio-pcf857x.txt      | 71 +++++++++++++
> > > >  drivers/gpio/gpio-pcf857x.c                        | 57 ++++++++++---
> > > >  2 files changed, 119 insertions(+), 9 deletions(-)
> > > >  create mode 100644

[snip]

> > > > diff --git a/drivers/gpio/gpio-pcf857x.c
> > > > b/drivers/gpio/gpio-pcf857x.c
> > > > index 070e81f..50a90f1 100644
> > > > --- a/drivers/gpio/gpio-pcf857x.c
> > > > +++ b/drivers/gpio/gpio-pcf857x.c
> > 
> > [snip]
> > 
> > > > @@ -50,6 +52,27 @@ static const struct i2c_device_id pcf857x_id[] =
> > > > {
> > > > 
> > > >  };
> > > >  MODULE_DEVICE_TABLE(i2c, pcf857x_id);
> > > > 
> > > > +#ifdef CONFIG_OF
> > > > +static const struct of_device_id pcf857x_of_table[] = {
> > > > +	{ .compatible = "nxp,pcf8574", .data = (void *)8 },
> > > > +	{ .compatible = "nxp,pcf8574a", .data = (void *)8 },
> > > > +	{ .compatible = "nxp,pca8574", .data = (void *)8 },
> > > > +	{ .compatible = "nxp,pca9670", .data = (void *)8 },
> > > > +	{ .compatible = "nxp,pca9672", .data = (void *)8 },
> > > > +	{ .compatible = "nxp,pca9674", .data = (void *)8 },
> > > > +	{ .compatible = "nxp,pcf8575", .data = (void *)16 },
> > > > +	{ .compatible = "nxp,pca8575", .data = (void *)16 },
> > > > +	{ .compatible = "nxp,pca9671", .data = (void *)16 },
> > > > +	{ .compatible = "nxp,pca9673", .data = (void *)16 },
> > > > +	{ .compatible = "nxp,pca9675", .data = (void *)16 },
> > > > +	{ .compatible = "maxim,max7328", .data = (void *)8 },
> > > > +	{ .compatible = "maxim,max7329", .data = (void *)8 },
> > > > +	{ .compatible = "ti,tca9554", .data = (void *)8 },
> > > > +	{ }
> > > > +};
> > > > +MODULE_DEVICE_TABLE(of, pcf857x_of_table);
> > > > +#endif
> > > > +
> > > > 
> > > >  /*
> > > >   * The pcf857x, pca857x, and pca967x chips only expose one read and
> > > >   * one write register.  Writing a "one" bit (to match the reset
> > > > @@ -257,14 +280,29 @@ fail:
> > > >  static int pcf857x_probe(struct i2c_client *client,
> > > >  			 const struct i2c_device_id *id)
> > > >  {
> > > > -	struct pcf857x_platform_data	*pdata;
> > > > +	struct pcf857x_platform_data	*pdata = client->dev.platform_data;
> > > > +	struct device_node		*np = client->dev.of_node;
 > > >  	struct pcf857x			*gpio;
> > > > +	unsigned int			n_latch = 0;
> > > > +	unsigned int			ngpio;
> > > >  	int				status;
> > > > 
> > > > -	pdata = client->dev.platform_data;
> > > > -	if (!pdata) {
> > > > +#ifdef CONFIG_OF
> > > > +	if (np) {
> > > 
> > > Wouldn't if (IS_ENABLED(CONFIG_OF) && np) be sufficient here, without
> > > the #ifdef? You would have to move the match table out of the #ifdef
> > > in this case, though...
> > 
> > That's the exact reason why I've used #ifdef CONFIG_OF here, I didn't
> > want to add the overhead of the pcf857x_of_table when CONFIG_OF isn't
> > defined.
> 
> I'm not sure if I remember correctly, but I think there was something said
> in one of discussions some time ago, that we should be moving away from
> ifdef'ing such things, in favour of just having them compiled
> unconditionally.

There seems to be a general consensus to favor if (IS_ENABLED(CONFIG_OF)) 
instead of #ifdef CONFIG_OF when possible. I'm not sure what the opinion is 
regarding using conditional compilation to avoid compiling unnecessary data 
tables in. I would vote for using it (there's no need to bloat the kernel 
unnecessarily on non-OF platforms), but I'll conform to whatever is decided to 
be best.

> [Adding DT maintainers on Cc for more opinions.]

I'll resubmit the patch with the DT bindings documentation fixed, and will 
submit yet another version if I need to remove the #ifdef.

-- 
Regards,

Laurent Pinchart

