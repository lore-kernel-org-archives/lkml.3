Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059Ab3GCOUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:20:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61964 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933036Ab3GCOUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:20:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christian Ruppert <christian.ruppert@abilis.com>, vincent.stehle@freescale
Subject: Re: [PATCH v10] i2c-designware: make SDA hold time configurable
Date: Wed, 3 Jul 2013 16:20:03 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Wolfram Sang <wsa@the-dreams.de>, Rob Herring <robherring2@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
References: <20130625163902.GA2973@katana> <201307031343.11647.arnd@arndb.de> <20130703132905.GC3929@ab42.lan>
In-Reply-To: <20130703132905.GC3929@ab42.lan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307031620.03785.arnd@arndb.de>
X-Provags-ID: V02:K0:OsK41M+2tQroFToP4MGzFKpiLMUrdimsbWuxX0LPei1
 PIFI/2CULUiY+hu9psCXqd5MtPZDNau7VPsMGSP1/vBIbKv3LX
 XQ3vfTf1A69pItQ1FCnpgok+LnHZU67PECzYlLvDVUb808e2YX
 qgvr7+/jbb363rb6RqWFp+TRIAk+b/ufTAyHvw99ru0l7E8VNy
 7l0oB0/yiTAjE5UKECqyUqoqb2IZaeH7msQvkuaAJf8nO1bbZO
 BUK+7gN5QZSTplrVqhlZZBBzPeB/7nIiJ4XO/oPu+EAvkTCQrI
 xZAwP/pXcw3Fw0g0wYyH5wtqNCCooKy0k3E/zicf3iod5sTxp4
 TbtZc+B745ZZYLOsvqPE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 July 2013, Christian Ruppert wrote:
> On Wed, Jul 03, 2013 at 01:43:11PM +0200, Arnd Bergmann wrote:
> > On Wednesday 26 June 2013, Wolfram Sang wrote:
> > >   On Wed, Jun 26, 2013 at 10:55:06AM +0200, Christian Ruppert wrote:
> > > > This patch makes the SDA hold time configurable through device tree.
> > > > 
> > > > Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> > > > Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>
> > > 
> > > Applied to for-next, thanks for keeping at it and providing lots of
> > > useful information. Much appreciated!
> > 
> > Sorry, but I got a regression that I didn't find reported elsewhere
> > so far, even though it breaks a lot of the ARM defconfig builds:
> > 
> > drivers/built-in.o: In function `dw_i2c_probe':
> > /git/arm-soc/drivers/i2c/busses/i2c-designware-platdrv.c:125: undefined reference to `__udivdi3'
> > 
> > I suspect you want something like the change below.
> 
> This looks similar to a patch Vincent Stehle submitted yesterday, see
> https://lkml.org/lkml/2013/7/2/145

Thanks for the link. Actually his patch looks wrong to me, because

 dev->sda_hold_time = div_u64((u64)ic_clk * ht + 500000, 1000000); 

assigns the division remainder to sda_hold_time, not the quotient.


	Arnd

> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > 
> > diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
> > index def79b5..57e3a07 100644
> > --- a/drivers/i2c/busses/i2c-designware-platdrv.c
> > +++ b/drivers/i2c/busses/i2c-designware-platdrv.c
> > @@ -119,10 +119,13 @@ static int dw_i2c_probe(struct platform_device *pdev)
> >  	if (pdev->dev.of_node) {
> >  		u32 ht = 0;
> >  		u32 ic_clk = dev->get_clk_rate_khz(dev);
> > +		u64 hold_time;
> >  
> >  		of_property_read_u32(pdev->dev.of_node,
> >  					"i2c-sda-hold-time-ns", &ht);
> > -		dev->sda_hold_time = ((u64)ic_clk * ht + 500000) / 1000000;
> > +		hold_time = (u64)ic_clk * ht + 500000;
> > +		do_div(hold_time, 1000000);
> > +		dev->sda_hold_time = hold_time;
> >  	}
> >  
> >  	dev->functionality =
