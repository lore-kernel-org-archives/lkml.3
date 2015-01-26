Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbbAZMzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:55:18 -0500
Received: from mga14.intel.com ([192.55.52.115]:51905 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456AbbAZMzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:55:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,468,1418112000"; 
   d="scan'208";a="642623974"
Date: Mon, 26 Jan 2015 14:55:03 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Baolu Lu <baolu.lu@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH 8/8] phy: add driver for TI TUSB1210 ULPI PHY
Message-ID: <20150126125503.GB28539@kuha.fi.intel.com>
References: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1422025978-178336-9-git-send-email-heikki.krogerus@linux.intel.com>
 <20150124235811.GA24665@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150124235811.GA24665@psi-dev26.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Sat, Jan 24, 2015 at 03:58:11PM -0800, David Cohen wrote:
> > +static int tusb1210_power_on(struct phy *phy)
> > +{
> > +	struct tusb1210 *tusb = phy_get_drvdata(phy);
> > +
> > +	gpiod_set_value_cansleep(tusb->gpio_reset, 1);
> > +	gpiod_set_value_cansleep(tusb->gpio_cs, 1);
> > +
> > +	/* Restore eye diagram optimisation value */
> > +	ulpi_write(tusb->ulpi, TUSB1210_VENDOR_SPECIFIC2,
> > +		   tusb->eye_diagram_tuning);
> 
> After you power on phy, ulpi bus may not be available right away. In
> intel case, phy power on happens during dwc3 power on. ULPI bus is not
> available until OTG controller and phy are in sync.
> 
> In resume, you can't restore eye diagram from here.

I'm sorry but I don't think I understand? Where do we power on the phy
before dwc3 is powered on? Or is this a Baytrail-CR specific problem?
I can't see any problems with the hardware I have.

In any case, this sounds like purely dwc3 issue and not tusb1210
issue.

> > +static int tusb1210_probe(struct ulpi *ulpi)
> > +{
> > +	struct gpio_desc *gpio;
> > +	struct tusb1210 *tusb;
> > +	int ret;
> > +
> > +	tusb = devm_kzalloc(&ulpi->dev, sizeof(*tusb), GFP_KERNEL);
> > +	if (!tusb)
> > +		return -ENOMEM;
> > +
> > +	gpio = devm_gpiod_get(&ulpi->dev, "reset");
> > +	if (!IS_ERR(gpio)) {
> > +		ret = gpiod_direction_output(gpio, 0);
> > +		if (ret)
> > +			return ret;
> > +		tusb->gpio_reset = gpio;
> > +	}
> 
> You cannot proceed with probe if gpio reset is not available. Different
> from CS, it's a mandatory pin to toggle in order to power on/off phy and
> get it in sync with OTG controller.

Well, let's check -ENOENT and -ENODEV return values separately. The
reset pin is not used on all platforms so getting this gpio is
optional. This is the case even with some Intel's platforms using
TUSB1210.

> > +
> > +	gpio = devm_gpiod_get(&ulpi->dev, "cs");
> > +	if (!IS_ERR(gpio)) {
> > +		ret = gpiod_direction_output(gpio, 0);
> > +		if (ret)
> > +			return ret;
> > +		tusb->gpio_cs = gpio;
> > +	}
> > +
> > +	/* Store initial eye diagram optimisation value */
> > +	ret = ulpi_read(ulpi, TUSB1210_VENDOR_SPECIFIC2);
> 
> It's unclear if ulpi is accessible at this point. You can't read it at
> this point.

We wouldn't have reached this point if ulpi wasn't accessible.
Registering the ulpi interface would have already failed so no driver
would have been probed.


Thanks!

-- 
heikki
