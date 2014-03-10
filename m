Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaCJCAq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 22:00:46 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:56546
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186AbaCJCAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 22:00:43 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -11
X-BigFish: VS-11(zz98dI9371I103dK1432I14e3Mzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25cch25f6h2605h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 10 Mar 2014 10:00:54 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Marek Vasut <marex@denx.de>
CC: Yao Yuan <yao.yuan@freescale.com>, "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] i2c: add DMA support for freescale i2c driver
Message-ID: <20140310020051.GA15218@S2101-09.ap.freescale.net>
References: <1394002352-8380-1-git-send-email-yao.yuan@freescale.com>
 <201403060541.21665.marex@denx.de>
 <50e0997786a0459eb08c9d92813253f9@BL2PR03MB338.namprd03.prod.outlook.com>
 <201403061257.42755.marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201403061257.42755.marex@denx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 12:57:42PM +0100, Marek Vasut wrote:
> On Thursday, March 06, 2014 at 06:02:03 AM, Yao Yuan wrote:
> > On Thu, March 06, 2014 at 12:44:14 PM, Marek Vasut wrote:
> > > On Thursday, March 06, 2014 at 05:36:14 AM, Yao Yuan wrote:
> > > > On Thu, March 06, 2014 at 11:23:50 AM, Marek Vasut wrote:
> > > > > On Wednesday, March 05, 2014 at 07:52:31 AM, Yuan Yao wrote:
> > > > > > Add dma support for i2c. This function depend on DMA driver.
> > > > > > You can turn on it by write both the dmas and dma-name properties
> > > > > > in dts node.
> > > > > > 
> > > > > > Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
> > > > > > ---
> > > > > 
> > > > > [...]
> > > > > 
> > > > > > @@ -601,6 +826,7 @@ static int i2c_imx_probe(struct
> > > > > > platform_device
> > > > > 
> > > > > *pdev)
> > > > > 
> > > > > >  	void __iomem *base;
> > > > > >  	int irq, ret;
> > > > > >  	u32 bitrate;
> > > > > > 
> > > > > > +	u32 phy_addr;
> > > > > > 
> > > > > >  	dev_dbg(&pdev->dev, "<%s>\n", __func__);
> > > > > > 
> > > > > > @@ -611,6 +837,7 @@ static int i2c_imx_probe(struct
> > > > > > platform_device
> > > > > 
> > > > > *pdev)
> > > > > 
> > > > > >  	}
> > > > > >  	
> > > > > >  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > > > > 
> > > > > > +	phy_addr = res->start;
> > > > > 
> > > > > Uh ... Shawn, I really think I am lost here. Don't you need to map
> > > > > this memory before you can use it for DMA ? The DMA mapping function
> > > > > should give you the physical address and is the right way to go
> > > > > about this instead of pulling the address from here, no ?
> > > > > 
> > > > > I might be wrong here, I am rather uncertain, so please help me out.
> > > > > Thanks!
> > > > 
> > > > Hi, Marek, Thanks for your suggestion.
> > > > Here you can review the code in include/linux/ioport.h The
> > > > resource->start describes the entity on the CPU bus as a starting
> > > > physical address. So I thinks it can used for dma directly.
> > > 
> > > This doesn't feel right for some reason. If this is a register area, you
> > > should
> > > ioremap() it. If it's a memory area you do DMA to/from, you need to make
> > > sure you correctly flush/invalidate caches and properly handle the
> > > effects the write buffer might have. But I have a feeling you actually do
> > > DMA to/from register space here ?
> > 
> > Yes, It's a register area. But I don't know why I should ioremap() it? It's
> > a bus address and DMA can use it directly. Is there some problem for my
> > understanding ?
> 
> I am not too sure here, thus I am poking someone who can clearly answer this.

There is already a devm_ioremap_resource() call in the existing code for
CPU to access registers in virtual address.  And my understanding on
Yuan's patch is that he needs the physical address of I2C DATA register
for DMA from/to the controller.

Shawn

