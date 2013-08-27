Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab3H0KkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 06:40:04 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38719 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194Ab3H0KkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 06:40:01 -0400
Date: Tue, 27 Aug 2013 11:39:49 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH v2 3/3] gpio: pcf857x: Add OF support
Message-ID: <20130827103949.GF19893@e106331-lin.cambridge.arm.com>
References: <1376953494-9684-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <5465986.lNHQvRvp7j@flatron>
 <1688346.YLZnUtEaXr@avalon>
 <2417846.CRj8QejgZy@flatron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2417846.CRj8QejgZy@flatron>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 24, 2013 at 03:13:11PM +0100, Tomasz Figa wrote:
> On Saturday 24 of August 2013 02:54:07 Laurent Pinchart wrote:
> > Hi Tomasz,
> > 
> > Thank you for the review.
> > 
> > On Saturday 24 August 2013 02:41:59 Tomasz Figa wrote:
> > > On Tuesday 20 of August 2013 01:04:54 Laurent Pinchart wrote:
> > > > Add DT bindings for the pcf857x-compatible chips and parse the
> > > > device
> > > > tree node in the driver.
> > > > 
> > > > Signed-off-by: Laurent Pinchart
> > > > <laurent.pinchart+renesas@ideasonboard.com> ---
> > > > 
> > > >  .../devicetree/bindings/gpio/gpio-pcf857x.txt      | 71
> > > >  +++++++++++++++++ drivers/gpio/gpio-pcf857x.c                     
> > > >    | 57 ++++++++++++++--- 2 files changed, 119 insertions(+), 9
> > > >  deletions(-)
> > > >  
> > > >  create mode 100644
> > > > 
> > > > Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
> > > > 
> > > > diff --git a/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
> > > > b/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt new file
> > > > mode
> > > > 100644
> > > > index 0000000..df94462
> > > > --- /dev/null
> > > > +++ b/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
> > > > @@ -0,0 +1,71 @@
> > 
> > [snip]
> > 
> > > > +  - pins-initial-state: Bitmask that specifies the initial state of
> > > > +    each pin. When a bit is set to zero, the corresponding pin will
> > > > be
> > > > +    initialized to the input (pulled-up) state. When the  bit is
> > > > set to +    one, the pin will be initialized the the low-level
> > > > output state. If +    the property is not specified all pins will
> > > > be initialized to the +    input state.
> > > 
> > > Hmm, do you actually need to know whether those pins are outputs or
> > > inputs before they get used for first time? I believe any driver
> > > using GPIO will call gpio_direction_{in,out}put() before it starts
> > > using the pin, which will initialize the pin to a known state.
> > > 
> > > What I'd suggest is making the driver handle this by having a bit mask
> > > that marks states of pins as defined and flagging all pins as
> > > undefined by default. Then any call to gpio_direction_output() or
> > > _input() would mark it as defined and direction of the pin could be
> > > stored in internal driver structures.
> > 
> > The problem is that all pins are controlled through a single I2C write.
> > Setting the direction of a pin will set the direction of all other pins.
> > I thus need to know what the initial settings are to avoid glitches.

I guess it's not possible to read the initial state from the hardware?

> 
> Oh, that's a funny hardware, isn't it? :)
> 
> Well, I guess it can't be helped then. Sorry for the noise.
> 
> > > > +  The I/O expander can detect input state changes, and thus
> > > > optionally
> > > > +  act as an interrupt controller. When interrupts support is
> > > > desired
> > > 
> > > I don't like this statement. Device tree should represent what the
> > > device allows you to do, not what you want the device to do.
> > > 
> > > My opinion on this is that if the chip supports interrupts then it
> > > should always be an interrupt-controller (unless its interrupt pin is
> > > not wired on the board, but this still conforms to what I wrote
> > > above).
> > 
> > I agree. What about the following text then ?
> > 
> > The I/O expander can detect input state changes, and thus optionally act
> > as an interrupt controller. When the expander interrupt pin is
> > connected all the following properties must be set. For more
> > information please see the interrupt controller device tree bindings
> > documentation available at
> > Documentation/devicetree/bindings/interrupt-controller/interrupts.txt.
> 
> Sounds good.
> 
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
> > > >  
> > > >   * The pcf857x, pca857x, and pca967x chips only expose one read and
> > > >   one
> > > >   * write register.  Writing a "one" bit (to match the reset state)
> > > >   lets
> > > > 
> > > > @@ -257,14 +280,29 @@ fail:
> > > >  static int pcf857x_probe(struct i2c_client *client,
> > > >  
> > > >  			 const struct i2c_device_id *id)
> > > >  
> > > >  {
> > > > 
> > > > -	struct pcf857x_platform_data	*pdata;
> > > > +	struct pcf857x_platform_data	*pdata = client-
> >dev.platform_data;
> > > > +	struct device_node		*np = client->dev.of_node;
> > > > 
> > > >  	struct pcf857x			*gpio;
> > > > 
> > > > +	unsigned int			n_latch = 0;
> > > > +	unsigned int			ngpio;
> > > > 
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

I was also under this impression, but I have no strong feelings either
way.

Thanks,
Mark.
