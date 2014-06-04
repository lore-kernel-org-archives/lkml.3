Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbaFDMvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 08:51:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:53052 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbaFDMvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 08:51:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,973,1392192000"; 
   d="scan'208";a="549641912"
Date: Wed, 4 Jun 2014 15:51:41 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, wsa@the-dreams.de,
        grant.likely@linaro.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH 7/7] OF/ACPI/I2C: Add generic match function for the
 aforementioned systems
Message-ID: <20140604125141.GB5214@lahna.fi.intel.com>
References: <1401883796-17841-1-git-send-email-lee.jones@linaro.org>
 <1401883796-17841-8-git-send-email-lee.jones@linaro.org>
 <5769487.6cMQUCkisu@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5769487.6cMQUCkisu@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 02:37:42PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, June 04, 2014 01:09:56 PM Lee Jones wrote:
> > Currently this is a helper function for the I2C subsystem to aid the
> > matching of non-standard compatible strings and devices which use DT
> > and/or ACPI, but do not supply any nodes (see: [1] Method 4).  However,
> > it has been made more generic as it can be used to only make one call
> > for drivers which support any mixture of OF, ACPI and/or I2C matching.
> > 
> > The initial aim is for of_match_device() to be replaced by this call
> > in all I2C device drivers.
> > 
> > [1] Documentation/i2c/instantiating-devices
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Mika, can you please have a look at this, please?

I don't see any fundamental problems with this wrt. ACPI.

That said, I find it kind of weird to have generic function that then
has knowledge of how different buses do their matching.

I would rather see something like firmware_device_match(dev) that goes
and matches from DT/ACPI and leave bus specific match to happen internal
to that bus.

> 
> 
> > ---
> >  include/linux/match.h | 40 ++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 40 insertions(+)
> >  create mode 100644 include/linux/match.h
> > 
> > diff --git a/include/linux/match.h b/include/linux/match.h
> > new file mode 100644
> > index 0000000..20a08e2
> > --- /dev/null
> > +++ b/include/linux/match.h
> > @@ -0,0 +1,40 @@
> > +#include <linux/of.h>
> > +#include <linux/acpi.h>
> > +#include <linux/i2c.h>
> > +
> > +static void *device_match(struct device *dev)
> > +{
> > +	struct device_driver *driver = dev->driver;
> > +
> > +	if (!driver)
> > +		return NULL;
> > +
> > +	/* Attempt an OF style match */
> > +	if (IS_ENABLED(CONFIG_OF)) {
> > +		const struct of_device_id *of_match =
> > +			i2c_of_match_device(driver->of_match_table, dev);
> > +		if (of_match)
> > +			return (void *)of_match;
> > +	}
> > +
> > +	/* Then ACPI style match */
> > +	if (IS_ENABLED(CONFIG_ACPI)) {
> > +		const struct acpi_device_id *acpi_match	=
> > +			acpi_match_device(driver->acpi_match_table, dev);
> > +		if (acpi_match)
> > +			return (void *)acpi_match;
> > +	}
> > +
> > +	/* Finally an I2C match */
> > +	if (IS_ENABLED(CONFIG_I2C)) {
> > +		struct i2c_client *client = i2c_verify_client(dev);
> > +		struct i2c_driver *i2c_drv = to_i2c_driver(driver);
> > +		struct i2c_device_id *i2c_match;
> > +
> > +		i2c_match = i2c_match_id(i2c_drv->id_table, client);
> > +		if (i2c_match)
> > +			return (void *)i2c_match;
> > +	}
> > +
> > +	return NULL;
> > +}
> > 
> 
> -- 
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
