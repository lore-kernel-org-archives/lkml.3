Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbaIARcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 13:32:50 -0400
Received: from www.xora.org.uk ([80.68.91.202]:53158 "EHLO
	xora.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbaIARcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 13:32:47 -0400
Date: Mon, 1 Sep 2014 18:32:45 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Hanjun Guo <hanjun.guo@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [RFC PATCH for Juno 1/2] net: smsc911x add support for probing
 from ACPI
Message-ID: <20140901173245.GM2953@xora-haswell.xora.org.uk>
References: <1409583961-7466-1-git-send-email-hanjun.guo@linaro.org>
 <1409583961-7466-2-git-send-email-hanjun.guo@linaro.org>
 <20140901170447.GF608@arm.com>
 <21764799.KDNDm9XRax@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21764799.KDNDm9XRax@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 07:11:44PM +0200, Arnd Bergmann wrote:
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
> 
This will of course most likely be replaced by _DSD values. I just
hardcoded for now as _DSD is not yet in the kernel and issues around
maintenance of bindings are not solved (unless this happened at KS where
I was not present).

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
> 
if (!acpi_disabled) is the equivalent if I understand you correctly.

But people until this point had expressed a preference for checking
.of_node and ACPI_HANDLE() to this point. This is obviously mutable
though depending on community preference.

Graeme

