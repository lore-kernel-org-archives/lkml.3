Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150Ab3GRPtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 11:49:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59268 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759124Ab3GRPtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 11:49:47 -0400
Date: Thu, 18 Jul 2013 08:49:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: kyungmin.park@samsung.com, balbi@ti.com, jg1.han@samsung.com,
        s.nawrocki@samsung.com, kgene.kim@samsung.com, grant.likely@linaro.org,
        tony@atomide.com, arnd@arndb.de, swarren@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, akpm@linux-foundation.org,
        balajitk@ti.com, george.cherian@ti.com, nsekhar@ti.com
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
Message-ID: <20130718154954.GA31961@kroah.com>
References: <1374129984-765-1-git-send-email-kishon@ti.com>
 <1374129984-765-2-git-send-email-kishon@ti.com>
 <20130718072004.GA16720@kroah.com>
 <51E7AE88.3050007@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E7AE88.3050007@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 02:29:52PM +0530, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Thursday 18 July 2013 12:50 PM, Greg KH wrote:
> > On Thu, Jul 18, 2013 at 12:16:10PM +0530, Kishon Vijay Abraham I wrote:
> >> +struct phy_provider *__of_phy_provider_register(struct device *dev,
> >> +	struct module *owner, struct phy * (*of_xlate)(struct device *dev,
> >> +	struct of_phandle_args *args));
> >> +struct phy_provider *__devm_of_phy_provider_register(struct device *dev,
> >> +	struct module *owner, struct phy * (*of_xlate)(struct device *dev,
> >> +	struct of_phandle_args *args))
> >> +
> >> +__of_phy_provider_register and __devm_of_phy_provider_register can be used to
> >> +register the phy_provider and it takes device, owner and of_xlate as
> >> +arguments. For the dt boot case, all PHY providers should use one of the above
> >> +2 APIs to register the PHY provider.
> > 
> > Why do you have __ for the prefix of a public function?  Is that really
> > the way that OF handles this type of thing?
> 
> I have a macro of_phy_provider_register/devm_of_phy_provider_register that
> calls these functions and should be used by the PHY drivers. Probably I should
> make a mention of it in the Documentation.

Yes, mention those as you never want to be calling __* functions
directly, right?

> >> +	ret = dev_set_name(&phy->dev, "%s.%d", dev_name(dev), id);
> > 
> > Your naming is odd, no "phy" anywhere in it?  You rely on the sender to
> > never send a duplicate name.id pair?  Why not create your own ids based
> > on the number of phys in the system, like almost all other classes and
> > subsystems do?
> 
> hmm.. some PHY drivers use the id they provide to perform some of their
> internal operation as in [1] (This is used only if a single PHY provider
> implements multiple PHYS). Probably I'll add an option like PLATFORM_DEVID_AUTO
> to give the PHY drivers an option to use auto id.
> 
> [1] ->
> http://archive.arm.linux.org.uk/lurker/message/20130628.134308.4a8f7668.ca.html

No, who cares about the id?  No one outside of the phy core ever should,
because you pass back the only pointer that they really do care about,
if they need to do anything with the device.  Use that, and then you can
rip out all of the "search for a phy by a string" logic, as that's not
needed either.  Just stick to the pointer, it's easier, and safer that
way.

> >> +static inline int phy_pm_runtime_get(struct phy *phy)
> >> +{
> >> +	if (WARN(IS_ERR(phy), "Invalid PHY reference\n"))
> >> +		return -EINVAL;
> > 
> > Why would phy ever not be valid and a error pointer?  And why dump the
> > stack if that happens, that seems really extreme.
> 
> hmm.. there might be cases where the same controller in one soc needs PHY
> control and in some other soc does not need PHY control. In such cases, we
> might get error pointer here.
> I'll change WARN to dev_err.

I still don't understand.  You have control over the code that calls
these functions, just ensure that they pass in a valid pointer, it's
that simple.  Or am I missing something?

thanks,

greg k-h
