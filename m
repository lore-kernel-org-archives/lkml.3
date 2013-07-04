Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab3GDPmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 11:42:35 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55881 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab3GDPme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 11:42:34 -0400
Message-ID: <1372952511.3974.38.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH v2 1/6] misc: sram: fix error path in sram_probe
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 04 Jul 2013 17:41:51 +0200
In-Reply-To: <201307041634.11248.heiko@sntech.de>
References: <201306251046.04873.heiko@sntech.de>
	 <201306251046.38993.heiko@sntech.de>
	 <1372151074.3981.21.camel@pizza.hi.pengutronix.de>
	 <201307041634.11248.heiko@sntech.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

Am Donnerstag, den 04.07.2013, 16:34 +0200 schrieb Heiko Stübner:
> Hi Philipp,
> 
> Am Dienstag, 25. Juni 2013, 11:04:34 schrieb Philipp Zabel:
> > Hi Heiko,
> > 
> > Am Dienstag, den 25.06.2013, 10:46 +0200 schrieb Heiko Stübner:
> > > The pool is created thru devm_gen_pool_create, so the call to
> > > gen_pool_destroy is not necessary.
> > > Instead the sram-clock must be turned off again if it exists.
> > > 
> > > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> > > ---
> > > 
> > >  drivers/misc/sram.c |    3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/misc/sram.c b/drivers/misc/sram.c
> > > index d87cc91..afe66571 100644
> > > --- a/drivers/misc/sram.c
> > > +++ b/drivers/misc/sram.c
> > > @@ -68,7 +68,8 @@ static int sram_probe(struct platform_device *pdev)
> > > 
> > >  	ret = gen_pool_add_virt(sram->pool, (unsigned long)virt_base,
> > >  	
> > >  				res->start, size, -1);
> > >  	
> > >  	if (ret < 0) {
> > > 
> > > -		gen_pool_destroy(sram->pool);
> > 
> > Right, thanks.
> > 
> > > +		if (sram->clk)
> > > +			clk_disable_unprepare(sram->clk);
> > > 
> > >  		return ret;
> > >  	
> > >  	}
> > 
> > In light of the following patch, I'd rather move the
> > clk_prepare_enable() call after gen_pool_add_virt() and its error path.
> 
> I'm not sure, but isn't moving the clock enablement below the pool allocation 
> producing a race condition?

since this is a platform device, and the driver is not allowed to be
compiled as a module, it is probed at the time platform_driver_register
is called from postcore_initcall.
You'd have to go to quite some lengths to make this race by probing your
driver before mmio-sram and then asynchronously trying to allocate
memory from the pool some time later, without having made sure that the
pool exists during probe.

It would be nice to have callbacks from gen_pool_alloc/free to
enable/disable the clock.
For the time being, maybe it's the safest bet to just enable the clock
before, especially if you reorder the loop so there is only one
gen_pool_add_virt and corresponding error path.

> I.e. can the case happen that some other part wants to allocate part of the 
> newly generated pool already, while the subsequent gen_pool_add_virt calls 
> from the following patch are still running? ... And what will happen in this 
> case, when the sram clock is still disabled?

On i.MX6, the system will hang.

regards
Philipp

