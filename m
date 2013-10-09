Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab3JITuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 15:50:01 -0400
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:25493
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751986Ab3JITuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 15:50:00 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1381348191.7979.348.camel@snotra.buserror.net>
Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform device
From: Scott Wood <scottwood@freescale.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Yoder Stuart-B08248 <B08248@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Kim Phillips <kim.phillips@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.motakis@virtualopensystems.com" <a.motakis@virtualopensystems.com>,
        "agraf@suse.de" <agraf@suse.de>,
        Sethi Varun-B16395 <B16395@freescale.com>,
        Bhushan Bharat-R65777 <R65777@freescale.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "santosh.shukla@linaro.org" <santosh.shukla@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date: Wed, 9 Oct 2013 14:49:51 -0500
In-Reply-To: <20131009191652.GA18611@kroah.com>
References: <20131002203735.GA10871@kroah.com>
	 <1380748121.12932.89.camel@snotra.buserror.net>
	 <20131002211631.GA11914@kroah.com>
	 <1380749715.12932.109.camel@snotra.buserror.net>
	 <20131002234009.GA27714@kroah.com>
	 <1380825207.12932.151.camel@snotra.buserror.net>
	 <20131003185434.GA26123@kroah.com>
	 <1380827494.12932.161.camel@snotra.buserror.net>
	 <20131003203226.GB27336@kroah.com>
	 <9F6FE96B71CF29479FF1CDC8046E15036DDA62@039-SN1MPN1-002.039d.mgd.msft.net>
	 <20131009191652.GA18611@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-09 at 12:16 -0700, gregkh@linuxfoundation.org wrote:
> On Wed, Oct 09, 2013 at 07:02:25PM +0000, Yoder Stuart-B08248 wrote:
> > Have been thinking about this issue some more.  As Scott mentioned,
> > 'wildcard' matching for a driver can be fairly done in the platform
> > bus driver.  We could add a new flag to the platform driver struct:
> > 
> > diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> > index 4f8bef3..4d6cf14 100644
> > --- a/drivers/base/platform.c
> > +++ b/drivers/base/platform.c
> > @@ -727,6 +727,10 @@ static int platform_match(struct device *dev, struct device_driver *drv)
> >         struct platform_device *pdev = to_platform_device(dev);
> >         struct platform_driver *pdrv = to_platform_driver(drv);
> > 
> > +       /* the driver matches any device */
> > +       if (pdrv->match_any)
> > +               return 1;
> > +
> >         /* Attempt an OF style match first */
> >         if (of_driver_match_device(dev, drv))
> >                 return 1;
> > 
> > However, the more problematic issue is that a bus driver has no way to 
> > differentiate from an explicit bind request via sysfs and a bind that
> > happened through bus probing.
> 
> That was by design, nice to see I implemented it properly :)
> 
> > I think something like the new flag in the snippet below would enable the platform
> > bus to support platform drivers that only bind on explicit request:
> > 
> > diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> > index 4c289ab..daf6d24 100644
> > --- a/drivers/base/bus.c
> > +++ b/drivers/base/bus.c
> > @@ -201,7 +201,7 @@ static ssize_t bind_store(struct device_driver *drv, const char *buf,
> >         int err = -ENODEV;
> > 
> >         dev = bus_find_device_by_name(bus, NULL, buf);
> > -       if (dev && dev->driver == NULL && driver_match_device(drv, dev)) {
> > +       if (dev && dev->driver == NULL && driver_match_device(drv, dev, 1)) {
> 
> Magic flags are the spawn of your favorite anti-$DIETY.  I'm never going
> to accept that, sorry.
> 
> If you really want to do something "special" for the platform bus, then
> do it only for the platform bus.  But even then, you'll find me arguing
> that you really don't want to do it at all, sorry.

It's not (or shouldn't be) special for the platform bus.  The "don't
bind by default" flag (note that I am *not* referring to the above code
snippet) would be useful for VFIO PCI as well, as it would replace the
hacky and racy usage of new_id.

> I'm still yet to be convinced this is even an issue at all, but maybe
> that's just the jetlag talking...

If this is because you think we should use new_id, we just had a
discussion in this thread about why that's no good.

-Scott



