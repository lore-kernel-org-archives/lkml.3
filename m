Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab3GCNaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 09:30:20 -0400
Received: from mail.abilis.ch ([195.70.19.74]:26391 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab3GCNaS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 09:30:18 -0400
Date: Wed, 3 Jul 2013 15:29:06 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Wolfram Sang <wsa@the-dreams.de>, Rob Herring <robherring2@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH v10] i2c-designware: make SDA hold time configurable
Message-ID: <20130703132905.GC3929@ab42.lan>
References: <20130625163902.GA2973@katana>
 <1372236906-6933-1-git-send-email-christian.ruppert@abilis.com>
 <20130626140713.GB3119@katana>
 <201307031343.11647.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <201307031343.11647.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 01:43:11PM +0200, Arnd Bergmann wrote:
> On Wednesday 26 June 2013, Wolfram Sang wrote:
> >   On Wed, Jun 26, 2013 at 10:55:06AM +0200, Christian Ruppert wrote:
> > > This patch makes the SDA hold time configurable through device tree.
> > > 
> > > Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> > > Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>
> > 
> > Applied to for-next, thanks for keeping at it and providing lots of
> > useful information. Much appreciated!
> 
> Sorry, but I got a regression that I didn't find reported elsewhere
> so far, even though it breaks a lot of the ARM defconfig builds:
> 
> drivers/built-in.o: In function `dw_i2c_probe':
> /git/arm-soc/drivers/i2c/busses/i2c-designware-platdrv.c:125: undefined reference to `__udivdi3'
> 
> I suspect you want something like the change below.

This looks similar to a patch Vincent Stehle submitted yesterday, see
https://lkml.org/lkml/2013/7/2/145

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
> index def79b5..57e3a07 100644
> --- a/drivers/i2c/busses/i2c-designware-platdrv.c
> +++ b/drivers/i2c/busses/i2c-designware-platdrv.c
> @@ -119,10 +119,13 @@ static int dw_i2c_probe(struct platform_device *pdev)
>  	if (pdev->dev.of_node) {
>  		u32 ht = 0;
>  		u32 ic_clk = dev->get_clk_rate_khz(dev);
> +		u64 hold_time;
>  
>  		of_property_read_u32(pdev->dev.of_node,
>  					"i2c-sda-hold-time-ns", &ht);
> -		dev->sda_hold_time = ((u64)ic_clk * ht + 500000) / 1000000;
> +		hold_time = (u64)ic_clk * ht + 500000;
> +		do_div(hold_time, 1000000);
> +		dev->sda_hold_time = hold_time;
>  	}
>  
>  	dev->functionality =

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
