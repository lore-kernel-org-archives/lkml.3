Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbaBFMDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 07:03:53 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36833 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaBFMDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 07:03:51 -0500
Date: Thu, 6 Feb 2014 12:03:36 +0000
From: Mark Brown <broonie@kernel.org>
To: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Guenter Roeck <linux@roeck-us.net>
Message-ID: <20140206120336.GL32298@sirena.org.uk>
References: <cover.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
 <6d76ae40cd435eaae0323f3e806515130b06a376.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
 <20140205183642.GH32298@sirena.org.uk>
 <2E89032DDAA8B9408CB92943514A03376B7E1669@SW-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYjDATHXTWnytHRU"
Content-Disposition: inline
In-Reply-To: <2E89032DDAA8B9408CB92943514A03376B7E1669@SW-EX-MBX02.diasemi.com>
X-Cookie: Take it easy, we're in a hurry.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/8] regulator: da9055: Add DT support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYjDATHXTWnytHRU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 06, 2014 at 11:31:13AM +0000, Opensource [Adam Thomson] wrote:
> On Wed, Feb 05, 2014 at 18:37:21PM +0000, Mark Brown wrote:

> > > +	for_each_child_of_node(nproot, np) {
> > > +		if (!of_node_cmp(np->name,
> > > +				 regulator->info->reg_desc.name)) {
> > > +			config->init_data = of_get_regulator_init_data(
> > > +				&pdev->dev, np);
> > > +			config->of_node = np;
> > > +			break;
> > > +		}
> > > +	}

> > I think you're looking for of_regulator_match() here.

> Used another driver as an example for this, but if there's a better method
> then I'm happy to use it. Will have a look.

That's probably an older driver - the code was factored out at some
point but lots of drivers don't get much love.

> > >  	/* Only LDO 5 and 6 has got the over current interrupt */
> > >  	if (pdev->id == DA9055_ID_LDO5 || pdev->id ==  DA9055_ID_LDO6) {
> > > -		irq = platform_get_irq_byname(pdev, "REGULATOR");
> > > -		irq = regmap_irq_get_virq(da9055->irq_data, irq);
> > > +		irq = regmap_irq_get_virq(da9055->irq_data,
> > > +					  DA9055_IRQ_REGULATOR);

> > This seems like a bit of a step backwards - what happened in the MFD
> > (and why didn't it update the users to avoid breaking bisection)?

> I tested this on target, when doing tests for devicetree. What was happening was
> that platform_get_irq_byname() was returning the VIRQ number already (368 in one
> test case where onkey was being probed) rather than the local IRQ number for the
> device (the resource information seemed to have been updated with the VIRQ
> number instead of the local IRQ number). So when that was passed to
> regmap_irq_get_virq() it would then return an incorrect IRQ number (0 in the
> same scenario, when I enabled DEBUG in irqdomain.c, I would see the message
> "error: hwirq 0x170 is too large for da9055_irq"). That incorrect irq was then
> being passed to devm_request_threaded_irq() which subsequently failed. This is
> why I made the change. Is it preferrable to use platform_get_irq_byname()
> instead of regmap_irq_get_virq() as using them both doesn't seem to work, unless
> I'm missing something fundamental here.

What's happening here is that the MFD framework has done the lookup for
you when passing the interrupt resource through - you should just use
platform_get_irq_byname() and save a little code in the driver.  If it's
behaving differently on DT and non-DT systems it seems better to figure
out why and then make it consistent.

--zYjDATHXTWnytHRU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS83oVAAoJELSic+t+oim9WRQP/0zUlvuSpXXtgvzF3nSoH074
3d9FnNNc5KXvfw3RLc++shACLtasITb3yaTjGauUwlBmowWil/Xhi05xqloy4BPt
YQHnthNAK16qYdCDcykyBkQhG3GYtS3ATfOYPlEy9fB5uvNi37RkIjT76HCHu35/
JMF39IvGxf5Jq0BikPc9s3BRn180OQwcV9BkecMeMa9zuN+VR+1/x+5snUAo7Owv
XgMfEQsk5qJCzH9Q1Ura4myQt7EpMt8jOe6keDyAIu0CnBgohKSAhTVn6FSVE7JT
Cr/bgJi9wnpcTgUKh4tSNChzKaCqeapJV90CTRzYDJloilFSzLFqKDvxZIGliU/C
NgAhwDzEIvzwVdEOgCGy22LBVj5hw13amSgR7fO3DmqaP0VLJ5+BqVYaN/WOzUph
tBKmcz2VYTHqvKI6DeOW3XU0APa2CWenf74dh6MlBs/53DIaJqxAXs6i8GBYcHRy
lvtDSzMoY1WkdLGS9XPFL/hadkHr7iVQQX1YTCyPOhP3cLOJ9kWGpKqD9f4+d8Q9
Kx5e4ww8MGtWvekgQPqtxg1KZ8Nmqc7JKst9nvKU7W9+XWN/fUAcwOLBoVyScqCr
w8YwxKxMR6mdA7swEkN/RZlCYCY+m2PVVIkYjIYmCw768CTiY++QGtc29eoYeTEX
rGZaS+Px0NmEl0ioPR4i
=o/z5
-----END PGP SIGNATURE-----

--zYjDATHXTWnytHRU--
