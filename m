Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaCGJTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:19:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50905 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752137AbaCGJTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:19:11 -0500
Date: Fri, 7 Mar 2014 09:19:08 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: ks.giri@samsung.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi/s3c64xx: Update DT binding documentation to match
	code
Message-ID: <20140307091908.GJ8570@opensource.wolfsonmicro.com>
References: <1394125539-28062-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20140307024841.GV13126@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140307024841.GV13126@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 10:48:41AM +0800, Mark Brown wrote:
> On Thu, Mar 06, 2014 at 05:05:39PM +0000, Charles Keepax wrote:
> 
> > The following patch added support for spi controllers with a dedicated
> > chip select pin:
> > 
> > commit 3146beec21b64f4551fcf0ac148381d54dc41b1b
> > spi: s3c64xx: Added provision for dedicated cs pin
> > 
> > It updated the device tree binding to require a "cs-gpio" property to be
> > specified on the spi controller node if chip selects will be given as
> > GPIOs per slave, rather than the controller having a dedicated internal
> > chip select pin.
> 
> No, it doesn't - it's saying that if the device has a "cs-gpio" property
> then to use that as the chip select.  It's not a boolean, it's a GPIO
> specifier.  Looking at the code it looks like the intention is to search
> all children for a cs-gpio during the controller probe, it's possible
> that this isn't working correctly.

That is basically part of my question is the current setup doing
what it is intended to? The Samsung binding has controller-data
blocks on each of the slaves that specify the gpio for that
slave.

@@ -1326,7 +1340,11 @@ static int s3c64xx_spi_probe(struct platform_device *pdev)
        sdd->cntrlr_info = sci;
        sdd->pdev = pdev;
        sdd->sfr_start = mem_res->start;
+       sdd->cs_gpio = true;
        if (pdev->dev.of_node) {
+               if (!of_find_property(pdev->dev.of_node, "cs-gpio", NULL))
+                       sdd->cs_gpio = false;

This part of the original patch adds the check, I guess the
mistake could be an assumption that of_find_property will
recursively check all the children, which it won't. This will
just check the controller node itself for a cs-gpio property but
as these are specified within sub-nodes they won't be found.
Hence currently you need to add one at the controller level.

Thanks,
Charles
