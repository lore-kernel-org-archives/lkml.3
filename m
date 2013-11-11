Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3KKXcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 18:32:13 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:35000 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab3KKXcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 18:32:03 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+hmXr21R6cQQSRT1m0MyaF
Date: Mon, 11 Nov 2013 15:31:52 -0800
From: Tony Lindgren <tony@atomide.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org,
        NeilBrown <neilb@suse.de>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Subject: Re: [PATCH 1/3] arm: omap2: Export devconf1 bypass and acbias.
Message-ID: <20131111233152.GR15154@atomide.com>
References: <1381784555-18344-1-git-send-email-marek@goldelico.com>
 <1381784555-18344-2-git-send-email-marek@goldelico.com>
 <20131111164917.GN15154@atomide.com>
 <CAAfyv37LRb_Q=UZVgtKdOAz_r6_qThewAU90W7nrqHdB5fDA_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAfyv37LRb_Q=UZVgtKdOAz_r6_qThewAU90W7nrqHdB5fDA_g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Belisko Marek <marek.belisko@gmail.com> [131111 14:01]:
> Hi Tony,
> 
> On Mon, Nov 11, 2013 at 5:49 PM, Tony Lindgren <tony@atomide.com> wrote:
> > * Marek Belisko <marek@goldelico.com> [131014 14:11]:
> >> devconf1 reg access is localized only in mach-omap2 and we need to export
> >> updating of devconf1 from omapdss venc driver (bypass and acbias bits).
> >> Add simple api call which update only necessary bits.
> > ...
> >
> >> +void update_bypass_acbias(bool bypass, bool acbias)
> >> +{
> >> +#ifdef CONFIG_ARCH_OMAP3
> >> +     int val = omap_ctrl_readl(OMAP343X_CONTROL_DEVCONF1);
> >> +
> >> +     if (bypass)
> >> +             val |= OMAP2_TVOUTBYPASS;
> >> +     else
> >> +             val &= ~OMAP2_TVOUTBYPASS;
> >> +
> >> +     if (acbias)
> >> +             val |= OMAP2_TVACEN;
> >> +     else
> >> +             val &= ~OMAP2_TVACEN;
> >> +
> >> +     omap_ctrl_writel(val, OMAP343X_CONTROL_DEVCONF1);
> >> +#endif
> >
> > If this is truly a pinmux, you could already access this
> > using pinctrl-single,bits device tree driver.
> >
> > But I guess that won't work yet, so it's best to set this
> > up as a separate driver like we've done for the USB PHY
> > registers.
>
> Can you please point me to that driver directly? I cannot see benefit
> of new driver as as it will be only dummy driver
> with export_symbol_gpl of upper function. Can it sit then in dss
> directory or somewhere else? Thanks.

You can take a look at drivers/usb/phy/phy-omap-control.c.

Then there's a device tree using example for control_devconf0 in
Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt.

Looks like CONTROL_DEVCONF1 contains a bunch of misc registers,
and arch/arm/mach-omap2/hsmmc.c seems to be tinkering with it too.

It would be best to set it up as omap-ctrl.c driver under drivers
somewhere with few functions exported for DSS and MMC drivers.

The reason why it should be a separate driver is that the system
control module can live a separate runtime PM life from the
drivers using the CONTROL_DEVCONF register bits.

Regards,

Tony
