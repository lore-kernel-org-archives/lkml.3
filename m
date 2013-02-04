Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab3BDO1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 09:27:49 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57437 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3BDO1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 09:27:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Felipe Balbi <balbi@ti.com>, Matt Porter <mporter@ti.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Chris Ball <cjb@laptop.org>, "Cousson, Benoit" <b-cousson@ti.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to arm/common
Date: Mon, 04 Feb 2013 15:27:09 +0100
Message-ID: <7655522.SvRnLo3eyU@wuerfel>
User-Agent: KMail/4.10 rc3 (Linux/3.8.0-3-generic; KDE/4.9.98; x86_64; ; )
In-Reply-To: <510C58DF.3010103@mvista.com>
References: <1359742975-10421-1-git-send-email-mporter@ti.com> <20130201213003.GW2637@n2100.arm.linux.org.uk> <510C58DF.3010103@mvista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:NVkFPuZmw54Z8zl+H7mfs29YgTOEKxmeQsrimTvavjg
 9meZIO8G592Phj71KFj+q9Gso2Mu9eI/ZZAji6DJZXPYZXEynH
 1UbSR98JqHU6QQLnZNysuDhupAoECDV9JV1Od4mwT9VgnPAOeB
 CvlZch/x3LTSeyb3o8mGmNjpwGb/U06JVj0o8Hu5nc/XxwcAoB
 7OwUj4cpAfDYOfR8NWnVjGyMdmIuOIE9z9VOSGMqnBBfJbIEkZ
 hDYmvplwIjx+tJaFCIsbIlO4SzpabhwqfoQ66Nzoala1yRVp4r
 LnPE5vP4icUHIYJXvC6z++2QjhB0tIfS8Hyc2MBj3XrvmWjMH8
 K3XB+Kchc6Bc9dslrK1c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 February 2013 04:07:59 Sergei Shtylyov wrote:
> On 02-02-2013 1:30, Russell King - ARM Linux wrote:

> >> because it doesn't make sense to support multiple DMA APIs. We can check
> >> from MUSB's registers if it was configured with Inventra DMA support and
> >> based on that we can register MUSB's own DMA Engine to dmaengine API.
> 
> > Hang on.  This is one of the DMA implementations which is closely
> > coupled with the USB and only the USB?  If it is...
> 
> > I thought this had been discussed _extensively_ before.  I thought the
> > resolution on it was:
> > 1. It would not use the DMA engine API.
> > 2. It would not live in arch/arm.
> > 3. It would be placed nearby the USB driver it's associated with.
> 
> > (1) because we don't use APIs just for the hell of it - think.  Do we
> > use the DMA engine API for PCI bus mastering ethernet controllers?  No.
> > Do we use it for PCI bus mastering SCSI controllers?  No.  Because the
> > DMA is integral to the rest of the device.
> 
> > The DMA engine API only makes sense if the DMA engine is a shared
> > system resource.
> 
>     Thanks for such extensive wording in the support of my point. 

Actually there is another problem with the musb driver, which is that
you can only have one DMA controller configured at build time, and
that currently prevents us from building a kernel that supports both
the Inventra and TUSB variants together. With multiplatform coming
up for both ux500 and omap2, we will also have to make a decision
about ux500 vs omap being supported in DMA mode.

I can see two ways out of this: either we extend the musb driver to
have run-time registration of the DMA controller, which duplicates
infrastructure that already exists in the dmaengine API, or we
make the dmaengine back-end for musb the default and require all
platforms to use that if they want to coexist with other platforms
and also use DMA support in musb.

Note that the ux500_dma code in musb already uses dmaengine. It could
probably be extended to support any platform that has a dmaengine
driver for the DMA controller used in MUSB.

	Arnd

