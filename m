Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab3KZIOC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 03:14:02 -0500
Received: from smtp-66.nebula.fi ([83.145.220.66]:45074 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752156Ab3KZIN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 03:13:59 -0500
Date: Tue, 26 Nov 2013 10:13:17 +0200
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        tomi.valkeinen@ti.com, plagnioj@jcrosoft.com
Subject: Re: [PATCH v3] video: add OpenCores VGA/LCD framebuffer driver
Message-ID: <20131126081316.GB2838@chokladfabriken.org>
References: <1385094870-6962-1-git-send-email-stefan.kristiansson@saunalahti.fi>
 <52944976.4060003@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52944976.4060003@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 08:10:46AM +0100, Michal Simek wrote:
> On 11/22/2013 05:34 AM, Stefan Kristiansson wrote:
> > +
> > +	/* Request I/O resource */
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if (!res) {
> > +		dev_err(&pdev->dev, "I/O resource request failed\n");
> > +		return -ENXIO;
> > +	}
> > +	fbdev->regs_phys = res->start;
> > +	fbdev->regs_phys_size = resource_size(res);
> > +	mmio = devm_request_mem_region(&pdev->dev, res->start,
> > +				       resource_size(res), res->name);
> > +	if (!mmio) {
> > +		dev_err(&pdev->dev, "I/O memory space request failed\n");
> > +		return -ENXIO;
> > +	}
> > +	fbdev->regs = devm_ioremap_nocache(&pdev->dev, mmio->start,
> > +					   resource_size(mmio));
> > +	if (!fbdev->regs) {
> > +		dev_err(&pdev->dev, "I/O memory remap request failed\n");
> > +		return -ENXIO;
> > +	}
> 
> 
> This construction seems to me too complicated and can be simpler.
> 
> What about this?
> 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> 	res->flags &= ~IORESOURCE_CACHEABLE;
> 	fbdev->regs = devm_ioremap_resource(&pdev->dev, res);
> 	if (IS_ERR(fbdev->regs))
> 		return PTR_ERR(fbdev->regs);
> 

Yes, that looks better.

Slightly related, I also noticed that I have a release_mem_region even though I
used devm_request_mem_region to request it.
I will fix that as well.

Stefan
