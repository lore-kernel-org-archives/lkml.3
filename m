Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356Ab3GZPxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 11:53:07 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49830 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756785Ab3GZPxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 11:53:04 -0400
Date: Fri, 26 Jul 2013 16:52:57 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "kishon@ti.com" <kishon@ti.com>, Stephen Warren <swarren@nvidia.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH] drivers/rtc/rtc-palmas.c: support for backup battery
 charging
Message-ID: <20130726155257.GB3528@e106331-lin.cambridge.arm.com>
References: <1374755343-32573-1-git-send-email-ldewangan@nvidia.com>
 <51F2985F.60202@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F2985F.60202@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 04:40:15PM +0100, Stephen Warren wrote:
> (CC'ing the new DT binding maintainers and mailing list on this reply,
> hence quoting the whole of the DT binding)

Thanks Stephen.

> 
> On 07/25/2013 06:29 AM, Laxman Dewangan wrote:
> > Palmas series device like TPS65913, TPS80036 supports the backup battery
> > for powering the RTC when no other energy source is available.
> > 
> > The backup battery is optional, connected to the VBACKUP pin, and can be
> > nonrechargeable or rechargeable. The rechargeable battery can be charged
> > from the system supply using the backup battery charger.
> > 
> > Add support for enabling charging of this backup battery.  Also add the DT
> > binding document and the new properties to have this support.
> > 
> > Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> > ---
> >  .../devicetree/bindings/rtc/rtc-palmas.txt         |   28 ++++++++++++++
> >  drivers/rtc/rtc-palmas.c                           |   39 ++++++++++++++++++++
> >  2 files changed, 67 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/rtc/rtc-palmas.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/rtc/rtc-palmas.txt b/Documentation/devicetree/bindings/rtc/rtc-palmas.txt
> > new file mode 100644
> > index 0000000..e4b6910
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/rtc/rtc-palmas.txt
> > @@ -0,0 +1,28 @@
> > +Palmas RTC controller bindings
> > +
> > +Required properties:
> > +- compatible:
> > +  - "ti,palams-rtc" for palma series of the RTC controller
> > +- interrupt-parent: Parent interrupt device, must be handle of palams node.
> > +- interrupts: Interrupt number of RTC submodule on device.
> > +
> > +Optional properties:
> > +- ti,back-bat-chg-enable: The palmas series device like TPS65913 or TPS80036
> > +	supports the battery backup for powering the RTC when main battery is
> > +	removed or in very low power state. This flag will enable the backup
> > +	battery charging.

Perhaps "ti,has-rechargeable-battery" would be better, as this describes
the hardware rather than an intent relating to it.

> > +- ti,back-bat-chg-current: Configure charging current. Device supports the
> > +	charging current as < 100mA or >100mA.

Are either of these values unsafe or unsupported in some configurations?

> 
> Does the HW support just two options; less-than or greater-than 100mA?
> If so, a Boolean property here might be better. The code below certainly
> implies this.
> 
> Given there's only 1 battery, I think "back-" is redundant in the
> property names. Since that shortens the names a bit, I'd suggest
> spelling everything out in full, perhaps:
> 
> battery-charge-enable
> battery-charge-low-current
> 
> Both Boolean.
> 
> > +Example:
> > +	palmas: tps65913@58 {
> > +		:::::::::::
> 
> "..." is probably more common than lots of colons, or you could just
> delete this line.
> 
> > +		palmas_rtc: rtc {
> > +			compatible = "ti,palmas-rtc";
> > +			interrupt-parent = <&palmas>;
> > +			interrupts = <8 0>;
> > +			ti,back-bat-chg-enable;
> > +			ti,back-bat-chg-current = <100>;
> > +		};
> > +		:::::::::::
> > +	};
> 
> > diff --git a/drivers/rtc/rtc-palmas.c b/drivers/rtc/rtc-palmas.c
> 
> > @@ -238,6 +238,19 @@ static int palmas_rtc_probe(struct platform_device *pdev)
> 
> > +		ret = of_property_read_u32(pdev->dev.of_node,
> > +					"ti,back-bat-chg-current", &pval);
> > +		if (!ret)
> > +			bb_charging_current = pval;
> 
> Do you need to validate that pval is one of the legal values?
> 
> > @@ -254,6 +267,32 @@ static int palmas_rtc_probe(struct platform_device *pdev)
> >  	palmas_rtc->dev = &pdev->dev;
> >  	platform_set_drvdata(pdev, palmas_rtc);
> >  
> > +	if (enable_bb_charging) {
> > +		unsigned reg = 0;
> > +
> > +		if (bb_charging_current < 100)
> > +			reg |= PALMAS_BACKUP_BATTERY_CTRL_BBS_BBC_LOW_ICHRG;
> 
> This implies that a Boolean property would be a better representation of HW.
> 

Otherwise, +1 to Stephen's comments.

Thanks,
Mark.
