Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990Ab3GCOTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:19:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:32843 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab3GCOTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:19:12 -0400
Message-ID: <1372861094.21065.118.camel@cumari.coelho.fi>
Subject: Re: [PATCH v3 2/8] wlcore: set irq_flags in the board files instead
 of hiding behind a quirk
From: Luciano Coelho <coelho@ti.com>
To: <balbi@ti.com>
CC: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>,
        <mturquette@linaro.org>, <mark.rutland@arm.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <nm@ti.com>
Date: Wed, 3 Jul 2013 17:18:14 +0300
In-Reply-To: <20130703141332.GO15056@arwen.pp.htv.fi>
References: <1372860209-3504-1-git-send-email-coelho@ti.com>
	 <1372860209-3504-3-git-send-email-coelho@ti.com>
	 <20130703141332.GO15056@arwen.pp.htv.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-03 at 17:13 +0300, Felipe Balbi wrote:
> Hi,
> 
> On Wed, Jul 03, 2013 at 05:03:23PM +0300, Luciano Coelho wrote:
> > diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
> > index 56a9a4f..953f620 100644
> > --- a/arch/arm/mach-omap2/board-4430sdp.c
> > +++ b/arch/arm/mach-omap2/board-4430sdp.c
> > @@ -703,12 +703,30 @@ static void __init omap4_sdp4430_wifi_init(void)
> >  
> >  	omap4_sdp4430_wifi_mux_init();
> >  	omap4_sdp4430_wlan_data.irq = gpio_to_irq(GPIO_WIFI_IRQ);
> > +
> > +	ret = gpio_request_one(GPIO_WIFI_IRQ, GPIOF_IN, "GPIO_WIFI_IRQ");
> > +	if (ret) {
> > +		pr_err("error requesting wl12xx gpio: %d\n", ret);
> > +		goto out;
> > +	}
> > +
> > +	ret = irq_set_irq_type(gpio_to_irq(GPIO_WIFI_IRQ), IRQ_TYPE_LEVEL_HIGH);
> > +	if (ret) {
> > +		pr_err("error setting wl12xx irq type: %d\n", ret);
> > +		goto free;
> > +	}
> > +
> >  	ret = wl12xx_set_platform_data(&omap4_sdp4430_wlan_data);
> >  	if (ret)
> >  		pr_err("Error setting wl12xx data: %d\n", ret);
> > +
> >  	ret = platform_device_register(&omap_vwlan_device);
> >  	if (ret)
> >  		pr_err("Error registering wl12xx device: %d\n", ret);
> > +out:
> > +	return;
> > +free:
> > +	gpio_free(GPIO_WIFI_IRQ);
> 
> actually, you should leave this GPIO requested in order to use it as
> IRQ.
> 
> ditto for all others

Actually, I don't need to use the GPIO if something goes wrong (ie.
setting the IRQ type or setting the platform data).  Notice that in the
normal cases (ie. without errors), I return before the gpio_free() is
called.

This is not really needed, but it's a bit cleaner and we can probably
release some resources.

--
Luca.

