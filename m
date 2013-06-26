Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab3FZLrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 07:47:21 -0400
Received: from mail.abilis.ch ([195.70.19.74]:17035 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958Ab3FZLrT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:47:19 -0400
Date: Wed, 26 Jun 2013 13:46:54 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 1/4] Make non-linear GPIO ranges accesible from gpiolib
Message-ID: <20130626114654.GB7095@ab42.lan>
References: <20130618092516.GC18663@ab42.lan>
 <1371547751-13873-1-git-send-email-christian.ruppert@abilis.com>
 <51C23060.50807@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <51C23060.50807@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 04:27:44PM -0600, Stephen Warren wrote:
> On 06/18/2013 03:29 AM, Christian Ruppert wrote:
> > This patch adds the infrastructure required to register non-linear gpio
> > ranges through gpiolib and the standard GPIO device tree bindings.
> 
> I review this in case we decide to go with it anyway.
> 
> > diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
> 
> > +In addition, named groups of pins can be mapped to pin groups of a given
> > +pin controller:
> > +
> > +	gpio_pio_g: gpio-controller@1480 {
> > +		#gpio-cells = <2>;
> > +		compatible = "fsl,qe-pario-bank-e", "fsl,qe-pario-bank";
> > +		reg = <0x1480 0x18>;
> > +		gpio-controller;
> > +		gpio-ranges = <&pinctrl1 0 0 0>, <&pinctrl2 3 0 0>;
> > +		gpio-ranges-group-names = "foo", "bar";
> > +	};
> > +
> > +where,
> > +   &pinctrl1 and &pinctrl2 is the phandle to the pinctrl DT node.
> > +
> > +   The following value specifies the base GPIO offset of the pin range with
> > +   respect to the GPIO controller's base. The remaining two values must be
> > +   0 to indicate that a named pin group should be used for the respective
> > +   range. The number of pins in the range is the number of pins in the pin
> > +   group.
> 
> It'd be good to re-write this section in a similar style to the cleanup
> patches that I sent for the existing gpio-ranges documentation. That
> makes the format description more of a raw syntax than English text.

can you please point me to some place where I can find those patches on
the web?

> > +   gpio-ranges-group-names defines the name of each pingroup of the
> > +   respective pin controller.
> > +
> > +The pinctrl node must have a "#gpio-#gpio-range-cells" property set to three
> > +to define the number of arguments to pass with the phandle.
> 
> There's some mistake in the property name there. I'd assert we should
> remove those two lines anyway, and use the new OF parsing code I posted
> when cleaning up gpio-ranges.
> 
> > diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
> 
> > +		if (pinspec.args[2]) {
> > +			/* npins != 0: linear range */
> > +			ret = gpiochip_add_pin_range(chip,
> > +					pinctrl_dev_get_devname(pctldev),
> > +					pinspec.args[0],
> > +					pinspec.args[1],
> > +					pinspec.args[2]);
> > +			if (ret)
> > +				break;
> > +		} else {
> 
> I think here we should validate !pinspec.args[1], to ensure that value
> doesn't get set to anything wonky.
> 

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
