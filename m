Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaKLPDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:03:08 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64791 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbaKLPDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:03:06 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18pdnYAQL25mhIkKbHs6WpI
Date: Wed, 12 Nov 2014 07:02:11 -0800
From: Tony Lindgren <tony@atomide.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Marek Belisko <marek@goldelico.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        bcousson@baylibre.com, linux@arm.linux.org.uk, plagnioj@jcrosoft.com,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        hns@goldelico.com
Subject: Re: [PATCH 4/4] arm: dts: omap3-gta04: Add static configuration for
 devconf1 register
Message-ID: <20141112150210.GC26481@atomide.com>
References: <1415051968-4878-1-git-send-email-marek@goldelico.com>
 <1415051968-4878-5-git-send-email-marek@goldelico.com>
 <5463585D.9070209@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5463585D.9070209@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tomi Valkeinen <tomi.valkeinen@ti.com> [141112 04:56]:
> Hi,
> 
> On 03/11/14 23:59, Marek Belisko wrote:
> > gta04 board need for tvout enabled 2 bits in devconf1 register (tvbypass and acbias).
> > Add single pinmux entry and enable it.
> > 
> > Signed-off-by: Marek Belisko <marek@goldelico.com>
> > ---
> >  arch/arm/boot/dts/omap3-gta04.dtsi | 22 ++++++++++++++++++++++
> >  1 file changed, 22 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
> > index e4d05f0..a456d37 100644
> > --- a/arch/arm/boot/dts/omap3-gta04.dtsi
> > +++ b/arch/arm/boot/dts/omap3-gta04.dtsi
> > @@ -118,6 +118,17 @@
> >  			};
> >  		};
> >  	};
> > +
> > +	/* pinmux for devconf1 */
> > +	control_devconf1: pinmux@480022d8 {
> > +		compatible = "pinctrl-single";
> > +		reg = <0x480022d8 4>;	/* single register */
> > +		#address-cells = <1>;
> > +		#size-cells = <0>;
> > +		pinctrl-single,bit-per-mux;
> > +		pinctrl-single,register-width = <32>;
> > +		pinctrl-single,function-mask = <0xfc0bd5>;
> > +	};
> >  };
> >  
> >  &omap3_pmx_core {
> > @@ -497,3 +508,14 @@
> >  		};
> >  	};
> >  };
> > +
> > +&control_devconf1 {
> > +	pinctrl-name = "default";
> > +	pinctrl-0 = < &tv_acbias_pins>;
> > +
> > +	tv_acbias_pins: pinmux_tv_acbias_pins {
> > +		pinctrl-single,bits = <
> > +			0 0x40800 0x40800
> 
> I think it would be good to have a comment in the .dts above, mentioning
> that TVOUTBYPASS and TVACEN bits are being set.
> 
> > +		>;
> > +	};
> > +};
> > 
> 
> OMAP3630 seems to have CONTROL_AVDAC1 and CONTROL_AVDAC2 registers. Did
> you check if the SoC you use have those? It looks like they need
> configuration also, if the exist.

Those look like AVDAC specific control registers that are not mux
registers. So those should be accessed the existing SCM (System Control
Mmodule) syscon area by the DSS code. For examples, see what
pbias-regulator.c is doing for some other registers in the syscon area.
 
> So, I don't think tvbypass and acbias are really pinmux stuff, but it
> does seem like an easy way to handle the devconf1 register, and I don't
> see any issues with the setting being fixed.

The CONTROL_DEVCONF registers seem to be all related to muxing signals
and configuring ping signal levels. So I think the pinctrl-single is
OK to use with these.
 
> However, devconf1 register seems to have bits for many devices,
> including mcbsp, mmc, and even some "Force MPU writes to be nonposted" bit.

Yes the"Force MPU writes to be nonposted" debug bit is an odd one
there :) But we're not using that luckily anywhere..
 
> And, with a quick grep, I see CONTROL_DEVCONF1 touched in multiple
> places in the kernel. I wonder if adding a pinmux entry for it could
> cause some rather odd problems.

They can all use pinctrl-single no problem.
 
> Tony, any idea about this? How should CONTROL_DEVCONFx registers be
> accessed?

If they are pinctrl related like the CONTROL_DEVCONF registers, then
pincatrl-single is OK. However, for any registers in the SCM that are
not just routing signals, then the syscon mapping should be used. And
we should have a separate driver implementing some standard Linux
generic framework driver. For example a regulator or clock driver.

Anyways, I'll drop this $subject patch for now and set up a new branch
for the .dts changes.

Regards,

Tony
