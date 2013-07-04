Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab3GDOea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 10:34:30 -0400
Received: from gloria.sntech.de ([95.129.55.99]:52960 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756202Ab3GDOe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 10:34:29 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH v2 1/6] misc: sram: fix error path in sram_probe
Date: Thu, 4 Jul 2013 16:34:10 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <201306251046.04873.heiko@sntech.de> <201306251046.38993.heiko@sntech.de> <1372151074.3981.21.camel@pizza.hi.pengutronix.de>
In-Reply-To: <1372151074.3981.21.camel@pizza.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201307041634.11248.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

Am Dienstag, 25. Juni 2013, 11:04:34 schrieb Philipp Zabel:
> Hi Heiko,
> 
> Am Dienstag, den 25.06.2013, 10:46 +0200 schrieb Heiko Stübner:
> > The pool is created thru devm_gen_pool_create, so the call to
> > gen_pool_destroy is not necessary.
> > Instead the sram-clock must be turned off again if it exists.
> > 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> > ---
> > 
> >  drivers/misc/sram.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/misc/sram.c b/drivers/misc/sram.c
> > index d87cc91..afe66571 100644
> > --- a/drivers/misc/sram.c
> > +++ b/drivers/misc/sram.c
> > @@ -68,7 +68,8 @@ static int sram_probe(struct platform_device *pdev)
> > 
> >  	ret = gen_pool_add_virt(sram->pool, (unsigned long)virt_base,
> >  	
> >  				res->start, size, -1);
> >  	
> >  	if (ret < 0) {
> > 
> > -		gen_pool_destroy(sram->pool);
> 
> Right, thanks.
> 
> > +		if (sram->clk)
> > +			clk_disable_unprepare(sram->clk);
> > 
> >  		return ret;
> >  	
> >  	}
> 
> In light of the following patch, I'd rather move the
> clk_prepare_enable() call after gen_pool_add_virt() and its error path.

I'm not sure, but isn't moving the clock enablement below the pool allocation 
producing a race condition?

I.e. can the case happen that some other part wants to allocate part of the 
newly generated pool already, while the subsequent gen_pool_add_virt calls 
from the following patch are still running? ... And what will happen in this 
case, when the sram clock is still disabled?


Thanks
Heiko
