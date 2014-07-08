Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbaGHRD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 13:03:58 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40100 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752883AbaGHRD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 13:03:57 -0400
Date: Tue, 8 Jul 2014 19:03:53 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Tejun Heo <tj@kernel.org>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, kishon@ti.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH v9 3/7] ata: libahci: allow to use multiple PHYs
Message-ID: <20140708170353.GA16148@kwain>
References: <1404728173-20263-1-git-send-email-antoine.tenart@free-electrons.com>
 <1404728173-20263-4-git-send-email-antoine.tenart@free-electrons.com>
 <20140708134000.GC4979@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140708134000.GC4979@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jul 08, 2014 at 09:40:00AM -0400, Tejun Heo wrote:
> (Cc'ing Hans.)
> 
> On Mon, Jul 07, 2014 at 12:16:09PM +0200, Antoine Ténart wrote:
> > @@ -482,6 +482,13 @@ void ahci_save_initial_config(struct device *dev,
> >  		port_map &= mask_port_map;
> >  	}
> >  
> > +	/*
> > +	 * If port_map was filled automatically when finding port sub-nodes,
> > +	 * make sure we get the right set here.
> > +	 */
> > +	if (hpriv->port_map)
> > +		port_map &= hpriv->port_map;
> > +
> 
> So, hpriv->port is both input and output?  This is messy and can lead
> to confusing failures and there now are multiple ways to modify
> port_map.  If carrying this information through ahci_host_priv is
> necessary, let's remove the direct params and introduce new input
> fields to the struct.

We just use hpriv->port_map to check port_map is valid and describes
available ports there.

hpriv->port_map is filed by the generic ahci_platform_get_resources()
function when using the new bindings and not by the drivers. port_map is
the input from the drivers.

> 
> >  /**
> > + * ahci_platform_enable_phys - Enable PHYs
> > + * @hpriv: host private area to store config values
> > + *
> > + * This function enables all the PHYs found in hpriv->phys, if any.
> > + * If a PHY fails to be enabled, it disables all the PHYs already
> > + * enabled in reverse order and returns an error.
> > + *
> > + * RETURNS:
> > + * 0 on success otherwise a negative error code
> > + */
> > +int ahci_platform_enable_phys(struct ahci_host_priv *hpriv)
> > +{
> > +	int i, rc = 0;
> > +
> > +	for (i = 0; i < hpriv->nphys; i++) {
> > +		rc = phy_init(hpriv->phys[i]);
> > +		if (rc)
> > +			goto disable_phys;
> > +
> > +		rc = phy_power_on(hpriv->phys[i]);
> > +		if (rc) {
> > +			phy_exit(hpriv->phys[i]);
> > +			goto disable_phys;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +
> > +disable_phys:
> > +	while (--i >= 0) {
> > +		phy_power_off(hpriv->phys[i]);
> > +		phy_exit(hpriv->phys[i]);
> > +	}
> > +	return rc;
> > +}
> > +EXPORT_SYMBOL_GPL(ahci_platform_enable_phys);
> 
> Do we need to make hpriv->phys[] dynamically allocated?  We already
> have hpriv->clks[AHCI_MAX_CLKS] and it's unlikely that we're gonna
> need more than several phys per host.  Let's go with a simpler fixed
> array.
> 

Well, a had a review a week ago about in the PHY driver saying I should
avoid using fixed sized arrays... And it was in a driver were we know
the maximum number of PHY available.

I think in this case were the number of PHYs depends on the h/w, we should
use a dynamically allocated array.


Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
