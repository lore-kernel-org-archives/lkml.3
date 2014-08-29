Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaH2GhS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 02:37:18 -0400
Received: from demumfd001.nsn-inter.net ([93.183.12.32]:46538 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaH2GhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 02:37:15 -0400
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Aug 2014 02:37:15 EDT
Date: Fri, 29 Aug 2014 10:41:14 +0300
From: Matti Vaittinen <matti.vaittinen@nsn.com>
To: ext Mark Rutland <mark.rutland@arm.com>
Cc: "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "arno@natisbad.org" <arno@natisbad.org>,
        "jgunthorpe@obsidianresearch.com" <jgunthorpe@obsidianresearch.com>,
        "san@rosetechnology.dk" <san@rosetechnology.dk>,
        "hs@denx.de" <hs@denx.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Sverdlin Alexander <alexander.sverdlin@nsn.com>
Subject: Re: [PATCH] rtc: ds1307: add trickle charger device tree binding
Message-ID: <20140829074058.GO4587@fi-ourus-dhcp00977.emea.nsn-net.net>
References: <20140828124237.GA29102@fi-ourus-dhcp00977.emea.nsn-net.net>
 <20140828125915.GJ14650@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140828125915.GJ14650@leverpostej>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 3541
X-purgate-ID: 151667::1409294196-0000061C-481D718B/0/0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 01:59:15PM +0100, ext Mark Rutland wrote:
> On Thu, Aug 28, 2014 at 01:42:44PM +0100, Matti Vaittinen wrote:
> > Patch adding support for specifying trickle charger setup from device
> > tree. Patch is based on linux-next tree.
> > 
> > 
> > Some DS13XX devices have "trickle chargers". Introduce a device tree binding
> > for specifying the setup and register values.
> > 
> > diff --git a/Documentation/devicetree/bindings/rtc/dallas,ds1339.txt b/Documentation/devicetree/bindings/rtc/dallas,ds1339.txt
> > new file mode 100644
> > index 0000000..9faf40e
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/rtc/dallas,ds1339.txt
> > @@ -0,0 +1,19 @@
> > +* Dallas DS1339		I2C Serial Real-Time Clock
> > +
> > +Required properties:
> > +- compatible: Should contain "dallas,ds1339".
> > +- reg: I2C address for chip
> > +
> > +Optional properties:
> > +- trickle_setup : Used Trickle Charger configuration,
> > +        corresponding to 5 lowest bits in trickle charger register.
> 
> s/_/-/ in property names please.
I'll fix this, thanks.

> Why do we not have a higher-level description?
I can add the meanings for this specific chip in the binding document,
  however I would still keep the raw register value as the dt entry due
  to reasons explained in my previous email.
> 
> > +- trickle_reg   : Trickle charger register address. Defaults to 0x10 for ds1339.
> 
> Is this expected to change? Why does this need to be in the DT?

I was thinking it might be handly as I do not know the details of all
variants of this chip. However I guess it could be left out.

> 
> > +
> > +Example:
> > +	ds1339: rtc@68 {
> > +		compatible = "dallas,ds1339";
> > +        trickle_setup= <0x5>;
> > +		reg = <0x68>;
> > +	};
> > +
> > +
> > diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
> > index f03d5ba..f9b1244 100644
> > --- a/drivers/rtc/rtc-ds1307.c
> > +++ b/drivers/rtc/rtc-ds1307.c
> > @@ -126,9 +126,10 @@ struct chip_desc {
> >  	u16			nvram_offset;
> >  	u16			nvram_size;
> >  	u16			trickle_charger_reg;
> > +	u8		  trickle_charger_setup;
> >  };
> >  
> > -static const struct chip_desc chips[last_ds_type] = {
> > +static struct chip_desc chips[last_ds_type] = {
> >  	[ds_1307] = {
> >  		.nvram_offset	= 8,
> >  		.nvram_size	= 56,
> > @@ -835,13 +836,37 @@ ds1307_nvram_write(struct file *filp, struct kobject *kobj,
> >  
> >  /*----------------------------------------------------------------------*/
> >  
> > +static void trickle_charger_of_init(struct chip_desc *chip,
> > +			struct device_node *node)
> > +{
> > +	int plen = 0;
> > +	const uint32_t *setup;
> > +	const uint32_t *reg;
> > +
> > +	setup = of_get_property(node, "trickle_setup" , &plen);
> > +	if (plen != 4)
> > +		goto out;
> > +	chip->trickle_charger_setup = (u8)*setup;
> 
> This isn't endian-clean, and the casting is unnecessary.
> 
> Use the of_property_read_u32 accessor, with a u32 temporary variable.

I'll fix this, thanks.

> 
> > +	plen = 0;
> > +	reg = of_get_property(node, "trickle_reg" , &plen);
> > +	if (plen == 4)
> > +		chip->trickle_charger_reg = (u16)*reg;
> 
> Likewise.
> 
I'll drop the register address from dt alltogether.


I will fix these issues and prepare a new patch.

Br. Matti Vaittinen


-- 
=============================================

Matti Vaittinen
Senile SW Specialist
FINLAND 

~~ When things go utterly wrong vim users can always type :help! ~~

