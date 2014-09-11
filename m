Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbaIKWXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:23:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:8422 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbaIKWXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:23:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="384977748"
Date: Thu, 11 Sep 2014 15:23:40 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: IIO <linux-iio@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Hartmut Knaack <knaack.h@gmx.de>, Fugang Duan <B38611@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Philippe Reynes <tremyfr@yahoo.fr>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH 2/4] mfd/axp2xx: extend axp20x to support axp288 pmic
Message-ID: <20140911152340.44515c8f@ultegra>
In-Reply-To: <20140909133704.GO3804@lukather>
References: <1410215046-31751-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1410215046-31751-3-git-send-email-jacob.jun.pan@linux.intel.com>
	<20140909073747.GI3804@lukather>
	<20140909054517.5bd4e8b6@ultegra>
	<20140909133704.GO3804@lukather>
Organization: OTC
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2014 15:37:04 +0200
Maxime Ripard <maxime.ripard@free-electrons.com> wrote:

> On Tue, Sep 09, 2014 at 05:45:17AM -0700, Jacob Pan wrote:
> > > > -static int axp20x_i2c_probe(struct i2c_client *i2c,
> > > > -			 const struct i2c_device_id *id)
> > > > +static int axp2xx_match_device(struct axp2xx_dev *axp2xx,
> > > > struct device *dev) {
> > > > -	struct axp20x_dev *axp20x;
> > > > +	const struct acpi_device_id *acpi_id;
> > > >  	const struct of_device_id *of_id;
> > > > -	int ret;
> > > >  
> > > > -	axp20x = devm_kzalloc(&i2c->dev, sizeof(*axp20x),
> > > > GFP_KERNEL);
> > > > -	if (!axp20x)
> > > > -		return -ENOMEM;
> > > > +	of_id = of_match_device(axp2xx_of_match, dev);
> > > > +	if (of_id) {
> > > > +		axp2xx->variant = (long) of_id->data;
> > > > +		goto found_match;
> > > > +	}
> > > >  
> > > > -	of_id = of_match_device(axp20x_of_match, &i2c->dev);
> > > > -	if (!of_id) {
> > > > -		dev_err(&i2c->dev, "Unable to setup AXP20X
> > > > data\n");
> > > > +	acpi_id =
> > > > acpi_match_device(dev->driver->acpi_match_table, dev);
> > > > +	if (!acpi_id || !acpi_id->driver_data) {
> > > > +		dev_err(dev, "Unable to setup AXP2XX ACPI
> > > > data\n"); return -ENODEV;
> > > >  	}
> > > > -	axp20x->variant = (long) of_id->data;
> > > > +	axp2xx->variant = (long) acpi_id->driver_data;
> > > 
> > > Shouldn't that be in the if statement above? I guess acpi_id will
> > > be null on a DT-based system.
> > > 
> > I am not sure what you mean. if acpi_id == NULL, then it will return
> > -ENODEV since of_match_device() already found no match. If
> > acpi_id != NULL, then id must contain variant info.
> 
> Hmm, never mind. I read it backward and thought you were still in this
> code path. I guess I need more coffee.
> 
> That goto isn't very intuitive though.
> 
> Maybe something like
> 
> if (of_id) {
>    /* DT case */
> } else if (acpi_id) {
>   /* ACPI case */
> } else {
>   return;
> }
> 
> would be better?
> 
yes, will be in v3.

thanks.
> Maxime
> 

[Jacob Pan]
