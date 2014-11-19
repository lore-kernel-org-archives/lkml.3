Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbaKSMSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 07:18:32 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36259 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaKSMSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 07:18:30 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of/address: Don't throw errors on absent
 =?iso-8859-1?Q?ranges=0D?= properties
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rob Herring <robherring2@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1416364351.5704.22.camel@kernel.crashing.org>
References: <1415948303.666.50.camel@kernel.crashing.org>
	<20141118165739.7382AC40966@trevor.secretlab.ca>
	<1416364351.5704.22.camel@kernel.crashing.org>
Date: Wed, 19 Nov 2014 10:31:40 +0000
Message-Id: <20141119103140.2B9F4C40551@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014 13:32:31 +1100
, Benjamin Herrenschmidt <benh@kernel.crashing.org>
 wrote:
> On Tue, 2014-11-18 at 16:57 +0000, Grant Likely wrote:
> > On Fri, 14 Nov 2014 17:58:23 +1100
> > , Benjamin Herrenschmidt <benh@kernel.crashing.org>
> >  wrote:
> > > The core always tries to translate any "reg" property to construct the platform
> > > device names. This results in a pile of "OF: no ranges; cannot translate" errors
> > > in dmesg whenever we expose things like i2c devices that cannot directly translate
> > > to the MMIO space.
> > 
> > I don't have a problem with the change, but it seems to be catching an
> > odd usage of of_device_make_bus_id(). Why is of_device_make_bus_id()
> > being called on i2c devices? Those shouldn't be modelled as
> > platform_devices.
> 
> Sorry, this was my explanation being full of crap. It's my i2c
> _controller_ which is a platform device, and is on the xscom bus which
> isn't directly MMIO translatable.

Okay, that makes more sense, but if xscom is a different bus with
different access methods, then why is it using platform_bus_type? I
would expect it to have it's own bus_type and container for struct
device.

> The patch still stands :)

Indeed, I merged it yesterday. :)

> 
> Cheers,
> Ben.
> 
> > g.
> > 
> > > 
> > > Turn this into a pr_debug instead
> > > 
> > > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > > 
> > > diff --git a/drivers/of/address.c b/drivers/of/address.c
> > > index f0541fd..bf1f79d 100644
> > > --- a/drivers/of/address.c
> > > +++ b/drivers/of/address.c
> > > @@ -444,7 +444,7 @@ static int of_translate_one(struct device_node *parent, struct of_bus *bus,
> > >  	 */
> > >  	ranges = of_get_property(parent, rprop, &rlen);
> > >  	if (ranges == NULL && !of_empty_ranges_quirk()) {
> > > -		pr_err("OF: no ranges; cannot translate\n");
> > > +		pr_debug("OF: no ranges; cannot translate\n");
> > >  		return 1;
> > >  	}
> > >  	if (ranges == NULL || rlen == 0) {
> > > 
> > > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

