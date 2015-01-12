Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbbALNFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:05:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbbALNFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:05:09 -0500
Date: Mon, 12 Jan 2015 05:05:07 -0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Abhilash Kesavan <kesavan.abhilash@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        Nicolin Chen <nicoleotsuka@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        robh+dt <robh+dt@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "padma.v@samsung.com" <padma.v@samsung.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "shawn.guo@freescale.com" <shawn.guo@freescale.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Kukjin Kim <kgene@kernel.org>, Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH 1/2] lib: devres: add a helper function for ioremap_wc
Message-ID: <20150112130507.GA21792@kroah.com>
References: <1418266726-12004-1-git-send-email-a.kesavan@samsung.com>
 <CAM4voan_gA=X9nAe4quPWRx5m+uTsK1diBZKBsL36aPYG-q69A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM4voan_gA=X9nAe4quPWRx5m+uTsK1diBZKBsL36aPYG-q69A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 09:00:54AM +0530, Abhilash Kesavan wrote:
> Hi Greg,
> 
> On Thu, Dec 11, 2014 at 8:28 AM, Abhilash Kesavan <a.kesavan@samsung.com> wrote:
> > Implement a resource managed writecombine ioremap function.
> >
> > Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> > ---
> >  Documentation/driver-model/devres.txt |    1 +
> >  include/linux/io.h                    |    2 ++
> >  lib/devres.c                          |   28 ++++++++++++++++++++++++++++
> >  3 files changed, 31 insertions(+)
> >
> > diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
> > index b5ab416..0f80cee 100644
> > --- a/Documentation/driver-model/devres.txt
> > +++ b/Documentation/driver-model/devres.txt
> > @@ -274,6 +274,7 @@ IOMAP
> >    devm_ioport_unmap()
> >    devm_ioremap()
> >    devm_ioremap_nocache()
> > +  devm_ioremap_wc()
> >    devm_ioremap_resource() : checks resource, requests memory region, ioremaps
> >    devm_iounmap()
> >    pcim_iomap()
> > diff --git a/include/linux/io.h b/include/linux/io.h
> > index fa02e55..42b33f0 100644
> > --- a/include/linux/io.h
> > +++ b/include/linux/io.h
> > @@ -64,6 +64,8 @@ void __iomem *devm_ioremap(struct device *dev, resource_size_t offset,
> >                            resource_size_t size);
> >  void __iomem *devm_ioremap_nocache(struct device *dev, resource_size_t offset,
> >                                    resource_size_t size);
> > +void __iomem *devm_ioremap_wc(struct device *dev, resource_size_t offset,
> > +                                  resource_size_t size);
> >  void devm_iounmap(struct device *dev, void __iomem *addr);
> >  int check_signature(const volatile void __iomem *io_addr,
> >                         const unsigned char *signature, int length);
> > diff --git a/lib/devres.c b/lib/devres.c
> > index 0f1dd2e..e8e1738 100644
> > --- a/lib/devres.c
> > +++ b/lib/devres.c
> > @@ -72,6 +72,34 @@ void __iomem *devm_ioremap_nocache(struct device *dev, resource_size_t offset,
> >  EXPORT_SYMBOL(devm_ioremap_nocache);
> >
> >  /**
> > + * devm_ioremap_wc - Managed ioremap_wc()
> > + * @dev: Generic device to remap IO address for
> > + * @offset: BUS offset to map
> > + * @size: Size of map
> > + *
> > + * Managed ioremap_wc().  Map is automatically unmapped on driver detach.
> > + */
> > +void __iomem *devm_ioremap_wc(struct device *dev, resource_size_t offset,
> > +                          resource_size_t size)
> > +{
> > +       void __iomem **ptr, *addr;
> > +
> > +       ptr = devres_alloc(devm_ioremap_release, sizeof(*ptr), GFP_KERNEL);
> > +       if (!ptr)
> > +               return NULL;
> > +
> > +       addr = ioremap_wc(offset, size);
> 
> These two patches were applied yesterday to the char-misc tree, but
> have broken build on m32r and maybe other platforms too which do not
> have ioremap_wc defined. Unfortunately I missed catching this as I
> built the patches only for arm64 and arm32, sorry for the trouble.
> There was a patch posted a while back which added ioremap_wc for m32r
> (https://lkml.org/lkml/2013/6/26/795). I would have to do something
> similar for all the other archs which do not have it or is there some
> other solution ?
> 
> Please drop these patches in the interim so that the build is fixed.

Ok, patches are now dropped.

thanks,

greg k-h
