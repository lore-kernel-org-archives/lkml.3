Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaIOEOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 00:14:10 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:48614 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaIOEOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 00:14:07 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH for Juno 1/2] net: smsc911x add support for probing
 from ACPI
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Hanjun Guo <hanjun.guo@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>
In-Reply-To: <21764799.KDNDm9XRax@wuerfel>
References: <1409583961-7466-1-git-send-email-hanjun.guo@linaro.org>
	<1409583961-7466-2-git-send-email-hanjun.guo@linaro.org>
	<20140901170447.GF608@arm.com> <21764799.KDNDm9XRax@wuerfel>
Date: Sun, 14 Sep 2014 21:14:04 -0700
Message-Id: <20140915041404.A72CCC40A02@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Sep 2014 19:11:44 +0200, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 01 September 2014 18:04:47 Catalin Marinas wrote:
> > On Mon, Sep 01, 2014 at 04:06:00PM +0100, Hanjun Guo wrote:
> > > +#ifdef CONFIG_ACPI
> > > +/* Configure some sensible defaults for ACPI mode */
> > > +static int smsc911x_probe_config_acpi(struct smsc911x_platform_config *config,
> > > +                                 acpi_handle *ahandle)
> > > +{
> > > +     if (!ahandle)
> > > +             return -ENOSYS;
> > > +
> > > +     config->phy_interface = PHY_INTERFACE_MODE_MII;
> > > +
> > > +     config->flags |= SMSC911X_USE_32BIT;
> > > +
> > > +     config->irq_polarity = SMSC911X_IRQ_POLARITY_ACTIVE_HIGH;
> > > +
> > > +     config->irq_type = SMSC911X_IRQ_TYPE_PUSH_PULL;
> > > +
> > > +     return 0;
> > > +}
> > > +#else
> > 
> > I don't like this and it shows issues we have with ACPI on certain ARM
> > platforms. You hard-code these values to match the Juno platform. What
> > if we get another SoC which has different configuration here? For DT, we
> > have the smsc911x_probe_config_dt() which reads the relevant information
> > from DT. I think this kind of configuration would be more suitable as
> > _DSD properties and sharing the similar names with DT (but we go back to
> > the question about who's in charge of the _DSD properties).
> 
> Good point, I totally missed that.
> 
> There is of course the possibility to set those values based on the
> acpi_device_id, but that is exactly the part that _DSD is trying to
> avoid.

These are merely defaults. DSD parsing, when implemented, would be
override these default values.

> 
> > >  static int smsc911x_drv_probe(struct platform_device *pdev)
> > >  {
> > >       struct device_node *np = pdev->dev.of_node;
> > > +     acpi_handle *ahandle = ACPI_HANDLE(&pdev->dev);
> > >       struct net_device *dev;
> > >       struct smsc911x_data *pdata;
> > >       struct smsc911x_platform_config *config = dev_get_platdata(&pdev->dev);
> > > @@ -2436,6 +2464,9 @@ static int smsc911x_drv_probe(struct platform_device *pdev)
> > >       }
> > >  
> > >       retval = smsc911x_probe_config_dt(&pdata->config, np);
> > > +     if (retval)
> > > +             retval = smsc911x_probe_config_acpi(&pdata->config, ahandle);
> > > +
> > 
> > In most of the ACPI patches so far we check for ACPI first with DT as a
> > fall-back if ACPI is not enabled. This changes here.
> 
> Does this really make a difference?

Nope. Only one of DT or ACPI will be matched.

> 
> > I would prefer
> > something which probes only ACPI if the ACPI is enabled (run-time, not
> > config) otherwise DT only. E.g.
> 
> (example missing?)
> 
> I think we should have the equivalent of of_have_populated_dt(), to
> check whether acpi is being used to boot, and have that new function
> be hardcoded to zero in case of !IS_ENABLED(CONFIG_ACPI).

The code already accounts for it. If ACPI isn't enabled, or isn't
populated, then the ACPI_HANDLE macro will return NULL and the
smsc911x_probe_config_acpi() function will fail.

g.
