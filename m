Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab3LPOci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 09:32:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:52698 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab3LPOcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 09:32:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,495,1384329600"; 
   d="scan'208";a="445018046"
Date: Mon, 16 Dec 2013 16:32:27 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 2/5] phy: add support for indexed lookup
Message-ID: <20131216143227.GA22944@xps8300>
References: <1386601737-8735-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1386601737-8735-3-git-send-email-heikki.krogerus@linux.intel.com>
 <52AEDDE2.8060406@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AEDDE2.8060406@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On Mon, Dec 16, 2013 at 04:32:58PM +0530, Kishon Vijay Abraham I wrote:
> On Monday 09 December 2013 08:38 PM, Heikki Krogerus wrote:
> > Removes the need for the consumer drivers requesting the
> > phys to provide name for the phy. This should ease the use
> > of the framework considerable when using only one phy, which
> > is usually the case when except with USB, but it can also
> > be useful with multiple phys.
> 
> If index has to be used with multiple PHYs, the controller should be aware of
> the order in which it is populated in dt data. That's not good.

The Idea is not to replace the name based lookup. Just to provide
possibility for index based lookup.

With ACPI, if we get the device entries for PHYs, the order will be
fixed and we will not have any other reference to the phys. In case
of USB, the first one should always be USB2 PHY and the second the
USB3 PHY.

> > This will also reduce noise from the framework when there is
> > no phy by changing warnings to debug messages.
> > 
> > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > ---
> >  drivers/phy/phy-core.c  | 106 ++++++++++++++++++++++++++++++++++--------------
> >  include/linux/phy/phy.h |  14 +++++++
> >  2 files changed, 89 insertions(+), 31 deletions(-)
> > 
> > diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> > index 1102aef..99dc046 100644
> > --- a/drivers/phy/phy-core.c
> > +++ b/drivers/phy/phy-core.c
> > @@ -53,7 +53,8 @@ static int devm_phy_match(struct device *dev, void *res, void *match_data)
> >  	return res == match_data;
> >  }
> >  
> > -static struct phy *phy_lookup(struct device *device, const char *con_id)
> > +static struct phy *phy_lookup(struct device *device, const char *con_id,
> > +			      unsigned int idx)
> >  {
> >  	unsigned int count;
> >  	struct phy *phy;
> > @@ -67,6 +68,10 @@ static struct phy *phy_lookup(struct device *device, const char *con_id)
> >  		count = phy->init_data->num_consumers;
> >  		consumers = phy->init_data->consumers;
> >  		while (count--) {
> > +			/* index must always match exactly */
> > +			if (!con_id)
> > +				if (idx != count)
> > +					continue;
> >  			if (!strcmp(consumers->dev_name, dev_name(device)) &&
> >  					!strcmp(consumers->port, con_id)) {
> >  				class_dev_iter_exit(&iter);
> > @@ -242,7 +247,8 @@ EXPORT_SYMBOL_GPL(phy_power_off);
> >  /**
> >   * of_phy_get() - lookup and obtain a reference to a phy by phandle
> >   * @dev: device that requests this phy
> > - * @index: the index of the phy
> > + * @con_id: name of the phy from device's point of view
> > + * @idx: the index of the phy if name is not used
> >   *
> >   * Returns the phy associated with the given phandle value,
> >   * after getting a refcount to it or -ENODEV if there is no such phy or
> > @@ -250,12 +256,20 @@ EXPORT_SYMBOL_GPL(phy_power_off);
> >   * not yet loaded. This function uses of_xlate call back function provided
> >   * while registering the phy_provider to find the phy instance.
> >   */
> > -static struct phy *of_phy_get(struct device *dev, int index)
> > +static struct phy *of_phy_get(struct device *dev, const char *con_id,
> > +			      unsigned int idx)
> >  {
> >  	int ret;
> >  	struct phy_provider *phy_provider;
> >  	struct phy *phy = NULL;
> >  	struct of_phandle_args args;
> > +	int index;
> > +
> > +	if (!con_id)
> > +		index = idx;
> > +	else
> > +		index = of_property_match_string(dev->of_node, "phy-names",
> > +						 con_id);
> >  
> >  	ret = of_parse_phandle_with_args(dev->of_node, "phys", "#phy-cells",
> >  		index, &args);
> > @@ -348,38 +362,36 @@ struct phy *of_phy_simple_xlate(struct device *dev, struct of_phandle_args
> >  EXPORT_SYMBOL_GPL(of_phy_simple_xlate);
> >  
> >  /**
> > - * phy_get() - lookup and obtain a reference to a phy.
> > + * phy_get_index() - obtain a phy based on index
> 
> NAK. It still takes a 'char' argument and the name is misleading.
> Btw are you replacing phy_get() or adding a new API in addition to phy_get()?

Additional API. The phy_get() would in practice act as a wrapper after
this. It could actually be just a #define macro in the include file.
The function naming I just copied straight from gpiolib.c. I did not
have the imagination for anything fancier.

I would like to be able to use some function like phy_get_index() and
be able to deliver it both the name and the index. With DT you guys
will always be able to use the name (and the string will always
supersede the index if we do it like this), but with ACPI, and possibly
the platform lookup tables, the index can be used...

phy2 = phy_get_index(dev, "usb2-phy", 0);
phy3 = phy_get_index(dev, "usb3-phy", 1);

> >   * @dev: device that requests this phy
> >   * @con_id: name of the phy from device's point of view
> > + * @idx: index of the phy to obtain in the consumer
> >   *
> > - * Returns the phy driver, after getting a refcount to it; or
> > - * -ENODEV if there is no such phy.  The caller is responsible for
> > - * calling phy_put() to release that count.
> > + * This variant of phy_get() allows to access PHYs other than the first
> > + * defined one for functions that define several PHYs.
> >   */
> > -struct phy *phy_get(struct device *dev, const char *con_id)
> > +struct phy *phy_get_index(struct device *dev, const char *con_id,
> > +			  unsigned int idx)
> >  {
> > -	int index = 0;
> >  	struct phy *phy = NULL;
> >  
> > -	if (con_id == NULL) {
> > -		dev_WARN(dev, "missing string\n");
> > -		return ERR_PTR(-EINVAL);
> > +	if (dev->of_node) {
> > +		dev_dbg(dev, "using device tree for PHY lookup\n");
> > +		phy = of_phy_get(dev, con_id, idx);
> >  	}
> >  
> > -	if (dev->of_node) {
> > -		index = of_property_match_string(dev->of_node, "phy-names",
> > -						 con_id);
> > -		phy = of_phy_get(dev, index);
> > -		if (IS_ERR(phy)) {
> > -			dev_err(dev, "unable to find phy\n");
> > -			return phy;
> > -		}
> > -	} else {
> > -		phy = phy_lookup(dev, con_id);
> > -		if (IS_ERR(phy)) {
> > -			dev_err(dev, "unable to find phy\n");
> > -			return phy;
> > -		}
> > +	/**
> > +	 * Either we are not using DT, or their lookup did not return
> > +	 * a result. In that case, use platform lookup as a fallback.
> > +	 */
> 
> In a dt boot, if it has not returned a result how will platform lookup help
> since there wouldn't be be any board file in the case of dt boot (to populate
> PHY consumers). Maybe your later patch will handle that.

This is something that I copy pasted from gpiolib.c. It felt like a
good idea to have possibility to create lookup tables even when the
device has of_node. I don't have strong feelings about this, so we can
drop it if you like.

> > +	if (!phy || IS_ERR(phy)) {
> > +		dev_dbg(dev, "using lookup tables for PHY lookup");
> > +		phy = phy_lookup(dev, con_id, idx);
> > +	}
> > +
> > +	if (IS_ERR(phy)) {
> > +		dev_dbg(dev, "unable to find phy\n");
> > +		return phy;
> >  	}
> >  
> >  	if (!try_module_get(phy->ops->owner))
> > @@ -389,18 +401,20 @@ struct phy *phy_get(struct device *dev, const char *con_id)
> >  
> >  	return phy;
> >  }
> > -EXPORT_SYMBOL_GPL(phy_get);
> > +EXPORT_SYMBOL_GPL(phy_get_index);
> >  
> >  /**
> > - * devm_phy_get() - lookup and obtain a reference to a phy.
> > + * devm_phy_get_index() - obtain a phy based on index
> 
> I don't see the need of these 2 APIs.

My goal is really just to prepare for ACPI with this one. I don't know
if my commit message was not clear enough.

Thanks,

-- 
heikki
