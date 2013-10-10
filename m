Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab3JJLw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 07:52:26 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:34931 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab3JJLwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 07:52:24 -0400
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat+gNPrzo0=
X-RZG-CLASS-ID: mo00
Subject: Re: [PATCH] omapdss: Add new panel driver for Topolly td028ttec1 LCD.
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <52568B40.4040802@ti.com>
Date: Thu, 10 Oct 2013 13:52:20 +0200
Cc: Marek Belisko <marek@goldelico.com>, <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <04AC7291-38E4-421B-979C-BF03D52E94BD@goldelico.com>
References: <1381352915-17219-1-git-send-email-marek@goldelico.com> <525662F5.3090600@ti.com> <7FAC77D4-5E1E-4B11-B067-3A8233C69240@goldelico.com> <52568B40.4040802@ti.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

Am 10.10.2013 um 13:10 schrieb Tomi Valkeinen:

> On 10/10/13 12:34, Dr. H. Nikolaus Schaller wrote:
>> Hi Tomi,
>> 
>> Am 10.10.2013 um 10:19 schrieb Tomi Valkeinen:
>> 
>>> Hi,
>>> 
>>> On 10/10/13 00:08, Marek Belisko wrote:
>>>> For communicating with driver is used gpio bitbanging because TD028 does
>>>> not have a standard compliant SPI interface. It is a 3-wire thing with
>>>> direction reversal.
>>> 
>>> Isn't that SPI_3WIRE?
>> 
>> Maybe - but we have no complete datasheet and I don't know an official spec of
>> a 3-wire SPI protocol to compare how 3-wire should work.
> 
> Yep, and I know only what I read on wikipedia a few hours ago =).
> 
>> And I think (but I may be wrong) that SPI_3WIRE is an optional feature of the SoC
>> specific SPI drivers and in my understanding the OMAP has no such driver:
>> 
>> http://lxr.free-electrons.com/source/drivers/spi/spi-omap2-mcspi.c#L874
>> 
>> And spi-bitbang.c hasn't either.
>> 
>> So I would prefer to leave this as an area for optimizations for future work.
>> Maybe we can add some more comments on this.
> 
> Ok. Well, I guess it's not too bad. But it's really not something that
> should be in the panel driver (assuming it's "standard" 3-wire SPI).
> Some SoC could support 3-wire SPI, and then it'd be good to use the SoCs
> hardware for SPI communication. Having bitbanging hardcoded into the
> driver will prevent that.

Yes, I agree and I am willing to help if someone comes up with such a SoC.
At the moment we have connected it to the OMAP3 only.

I.e. I want not to do a lot of work for others who we just guess about that they
might exist...

> 
>>>> +	int cs_gpio;
>>>> +	int scl_gpio;
>>>> +	int din_gpio;
>>>> +	int dout_gpio;
>>> 
>>> Three wires, but four gpios? What am I missing here...
>> 
>> We have wired up the 3-wire SPI interface of the display
>> to 4 wires of the McSPI interface because we initially thought
>> that it could work in 4 wire mode as well.
>> 
>> The next step we did was to port the driver code from the
>> Openmoko Neo1973 U-Boot which used the gpio-bitbang
>> mechanism.
>> 
>> Since it worked and is used only for enabling/disabling the
>> display and for no other purpose we never felt it important
>> to check or modify the code to use SPI.
>> 
>> But you are right - we don't use the din_gpio really since
>> we never read registers from the chip. So 3 gpios could be
>> sufficient.
>> 
>> Or we must handle the case that din_gpio == dout_gpio
>> in panel_probe to avoid duplicate use of the same gpio.
> 
> The panel hardware has three wires, so the panel driver (if it does
> handle the bus by bitbanging) can only refer to three gpios.

Hm. The panle hardware has 3 but the SoC (OMAP3) the driver
is running on has 4.

> So either
> the bus details should be hidden by using the normal spi framework, or
> if the driver does the bitbanging, use the gpios as specified in the
> panel spec. The panel driver cannot contain any board specific stuff.

The bitbang driver shown below can handle either 3 or 4 gpios (except
for initialization).

> 
>>>> +static int jbt_spi_xfer(struct panel_drv_data *data, int wordnum, int bitlen)
>>> 
>>> Hmm, if it's not SPI, maybe it shouldn't be called SPI?
>> 
>> Yes, we can remove the _spi_ in this name.
> 
> Or maybe use "spi3w" or such, just to make it clear it's not plain
> standard spi. Again, presuming it's really 3-wire spi =).
> 
>>>> +static int td028ttec1_panel_probe(struct platform_device *pdev)
>>>> +{
>>>> +	struct panel_drv_data *ddata;
>>>> +	struct omap_dss_device *dssdev;
>>>> +	int r;
>>>> +
>>>> +	ddata = devm_kzalloc(&pdev->dev, sizeof(*ddata), GFP_KERNEL);
>>>> +	if (ddata == NULL)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	platform_set_drvdata(pdev, ddata);
>>>> +
>>>> +	if (dev_get_platdata(&pdev->dev)) {
>>>> +		r = td028ttec1_panel_probe_pdata(pdev);
>>>> +		if (r)
>>>> +			return r;
>>>> +	} else {
>>>> +		return -ENODEV;
>>>> +	}
>>>> +
>>>> +	if (gpio_is_valid(ddata->cs_gpio)) {
>>>> +		r = devm_gpio_request_one(&pdev->dev, ddata->cs_gpio,
>>>> +				GPIOF_OUT_INIT_HIGH, "lcd cs");
>>>> +		if (r)
>>>> +			goto err_gpio;
>>>> +	}
>>>> +
>>>> +	if (gpio_is_valid(ddata->scl_gpio)) {
>>>> +		r = devm_gpio_request_one(&pdev->dev, ddata->scl_gpio,
>>>> +				GPIOF_OUT_INIT_HIGH, "lcd scl");
>>>> +		if (r)
>>>> +			goto err_gpio;
>>>> +	}
>>>> +
>>>> +	if (gpio_is_valid(ddata->dout_gpio)) {
>>>> +		r = devm_gpio_request_one(&pdev->dev, ddata->dout_gpio,
>>>> +				GPIOF_OUT_INIT_LOW, "lcd dout");
>>>> +		if (r)
>>>> +			goto err_gpio;
>>>> +	}
>>>> +
>>>> +	if (gpio_is_valid(ddata->din_gpio)) {
>>>> +		r = devm_gpio_request_one(&pdev->dev, ddata->din_gpio,
>>>> +				GPIOF_IN, "lcd din");
>>>> +		if (r)
>>>> +			goto err_gpio;
>>>> +	}
>>>> +
>>>> +	/* according to data sheet: wait 50ms (Tpos of LCM). However, 50ms
>>>> +	 * seems unreliable with later LCM batches, increasing to 90ms */
>>>> +	mdelay(90);
>>> 
>>> What is this delay for? Usually sleeps/delays should be between two "HW
>>> actions". Here there's nothing below this line that would count as such
>>> an action.
>> 
>> I guess that this delay is intended to power on the display first, then wait some
> 
> I'm not very comfortable with merging a driver, when the driver author
> guesses what parts of the driver do =).

Well, that is the problem with some badly documented chips. We have "inherited"
that from the Openmoko project and I think those guys did have access to some
more precise data sheets but we don't. You can't even find google results for this
strange jbt chip.

It works on all our GTA04 devices for quite a long time (using the old display API).
We just recently upgraded to display-new.

> 
>> time and after that delay enable the DSS clocks and signals and make the
>> controller chip in the panel initialize.
> 
> I don't see the code before the delay doing any power up, it just sets
> the data bus gpios to certain state. Do those gpio initializations power
> up the panel?

No, and they don't need to. The enable_power code is not implemented because
we have no dedicated regulator (but one shared and enabled early in the kernel).

It should be quite straightforward to add it to enable/disable if we need it.

We may want to change this in the next hardware revision, but on the other hand
do not want to postpone upstreaming until we have that, because an upstreamed
driver will help GTA04 users of today.

> 
>> But this of course depends on the order the DSS components are probed
>> and enabled and how power is controlled (we don't interrupt power at all).
>> 
>> I think we can move this delay (sleep) to the beginning of 
>> 
>> td028ttec1_panel_enable() before /* three times command zero */
>> 
>> to make sure that a freshly powered display has enough time to do its
>> internal reset and initializations before registers are programmed.
> 
> The probe function should not enable the panel (well, it can enable the
> panel, but only to read an ID or such and then disable it before exiting
> probe).
> 
> So after probe, the panel should be as dead as possible, power disabled
> etc. All the powering up should happen in enable().

Yes, I agree. And threrefore the safety-delay should indeed be in enable().

BR, Nikolaus

