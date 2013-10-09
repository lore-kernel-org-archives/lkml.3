Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab3JITXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 15:23:21 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:30449
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751821Ab3JITXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 15:23:20 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1381346507.7979.334.camel@snotra.buserror.net>
Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform device
From: Scott Wood <scottwood@freescale.com>
To: Yoder Stuart-B08248 <B08248@freescale.com>
CC: Wood Scott-B07421 <B07421@freescale.com>,
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
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Wed, 9 Oct 2013 14:21:47 -0500
In-Reply-To: <9F6FE96B71CF29479FF1CDC8046E15036DDA62@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1380738758.12932.43.camel@snotra.buserror.net>
	 <20131002184330.GC5108@cbox> <20131002203735.GA10871@kroah.com>
	 <1380748121.12932.89.camel@snotra.buserror.net>
	 <20131002211631.GA11914@kroah.com>
	 <1380749715.12932.109.camel@snotra.buserror.net>
	 <20131002234009.GA27714@kroah.com>
	 <1380825207.12932.151.camel@snotra.buserror.net>
	 <20131003185434.GA26123@kroah.com>
	 <1380827494.12932.161.camel@snotra.buserror.net>
	 <20131003203226.GB27336@kroah.com>
	 <9F6FE96B71CF29479FF1CDC8046E15036DDA62@039-SN1MPN1-002.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-09 at 14:02 -0500, Yoder Stuart-B08248 wrote:
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

Again, I think the wildcard match should be orthogonal to "don't bind by
default" as far as the mechanism goes.

There's already a "bool suppress_bind_attrs" to prevent sysfs
bind/unbind.  I suggested a similar flag to mean the oppsosite -- bind
*only* through sysfs.  Greg KH was skeptical and wanted to see a patch
before any further discussion.

> diff --git a/drivers/base/base.h b/drivers/base/base.h
> index 2cbc677..7a15ef3 100644
> --- a/drivers/base/base.h
> +++ b/drivers/base/base.h
> @@ -114,9 +114,9 @@ extern void driver_detach(struct device_driver *drv);
>  extern int driver_probe_device(struct device_driver *drv, struct device *dev);
>  extern void driver_deferred_probe_del(struct device *dev);
>  static inline int driver_match_device(struct device_driver *drv,
> -                                     struct device *dev)
> +                                     struct device *dev, int explicit_bind)
>  {
> -       return drv->bus->match ? drv->bus->match(dev, drv) : 1;
> +       return drv->bus->match ? drv->bus->match(dev, drv, explicit_bind) : 1;
>  }
> 
> Of, course the above change would need to be propagated to the different
> bus drivers that implement the 'match' function.

...which would not be a problem with my approach, because you could
handle it in the callers of driver_match_device().

-Scott



