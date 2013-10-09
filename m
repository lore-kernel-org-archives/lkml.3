Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab3JIT2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 15:28:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53286 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab3JIT2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 15:28:16 -0400
Date: Wed, 9 Oct 2013 12:16:52 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Yoder Stuart-B08248 <B08248@freescale.com>
Cc: Wood Scott-B07421 <B07421@freescale.com>,
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
Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform device
Message-ID: <20131009191652.GA18611@kroah.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9F6FE96B71CF29479FF1CDC8046E15036DDA62@039-SN1MPN1-002.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 07:02:25PM +0000, Yoder Stuart-B08248 wrote:
> Have been thinking about this issue some more.  As Scott mentioned,
> 'wildcard' matching for a driver can be fairly done in the platform
> bus driver.  We could add a new flag to the platform driver struct:
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 4f8bef3..4d6cf14 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -727,6 +727,10 @@ static int platform_match(struct device *dev, struct device_driver *drv)
>         struct platform_device *pdev = to_platform_device(dev);
>         struct platform_driver *pdrv = to_platform_driver(drv);
> 
> +       /* the driver matches any device */
> +       if (pdrv->match_any)
> +               return 1;
> +
>         /* Attempt an OF style match first */
>         if (of_driver_match_device(dev, drv))
>                 return 1;
> 
> However, the more problematic issue is that a bus driver has no way to 
> differentiate from an explicit bind request via sysfs and a bind that
> happened through bus probing.

That was by design, nice to see I implemented it properly :)

> I think something like the new flag in the snippet below would enable the platform
> bus to support platform drivers that only bind on explicit request:
> 
> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> index 4c289ab..daf6d24 100644
> --- a/drivers/base/bus.c
> +++ b/drivers/base/bus.c
> @@ -201,7 +201,7 @@ static ssize_t bind_store(struct device_driver *drv, const char *buf,
>         int err = -ENODEV;
> 
>         dev = bus_find_device_by_name(bus, NULL, buf);
> -       if (dev && dev->driver == NULL && driver_match_device(drv, dev)) {
> +       if (dev && dev->driver == NULL && driver_match_device(drv, dev, 1)) {

Magic flags are the spawn of your favorite anti-$DIETY.  I'm never going
to accept that, sorry.

If you really want to do something "special" for the platform bus, then
do it only for the platform bus.  But even then, you'll find me arguing
that you really don't want to do it at all, sorry.

I'm still yet to be convinced this is even an issue at all, but maybe
that's just the jetlag talking...

greg k-h
