Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab3FROYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:24:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45550 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764Ab3FROYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:24:45 -0400
Date: Tue, 18 Jun 2013 16:24:43 +0200
From: Pavel Machek <pavel@denx.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Detlev Zundel <dzu@denx.de>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        trivial <trivial@kernel.org>
Subject: Re: [PATCH] fix UIO with device tree but no assigned interrupt
Message-ID: <20130618142442.GA17361@amd.pavel.ucw.cz>
References: <20130617134957.GA15602@amd.pavel.ucw.cz>
 <CACxGe6sO6Tes8en905cyJwP69w82PHjwKV9+XxxXhAPMRyGYkA@mail.gmail.com>
 <20130618125235.GA15122@amd.pavel.ucw.cz>
 <CACxGe6tLPfJ3KS6+4aO8s8emq8=ajuc+gmBtaEDqd60m4_vx6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6tLPfJ3KS6+4aO8s8emq8=ajuc+gmBtaEDqd60m4_vx6w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > If device is initialized from device tree, but has no interrupt
> > assigned, uio will still try to request and interrupt old way, fails,
> > and fails registration.
> >
> > This is wrong; don't try initializing irq using platform data if
> > device tree is available.
> >
> > Simplified code based on suggestion by Grant Likely.
> >
> > Fixed memory leak in "irq can not be registered" error path.
> >
> > Signed-off-by: Pavel Machek <pavel@denx.de>
> > Reported-by: Detlev Zundel <dzu@denx.de>

> > @@ -146,14 +138,15 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
> >         priv->flags = 0; /* interrupt is enabled to begin with */
> >         priv->pdev = pdev;
> >
> > -       if (!uioinfo->irq) {
> > -               ret = platform_get_irq(pdev, 0);
> > -               if (ret < 0) {
> > -                       dev_err(&pdev->dev, "failed to get IRQ\n");
> > -                       goto bad0;
> > -               }
> > -               uioinfo->irq = ret;
> > +       ret = platform_get_irq(pdev, 0);
> > +       uioinfo->irq = ret;
> > +       if (ret == -ENXIO && pdev->dev.of_node)
> > +               uioinfo->irq = UIO_IRQ_NONE;
> 
> This short-circuits the platform data use case where uioinfo->irq is
> already set. The if (!uioinfo->irq) test is still needed. The original
> code looks like it already handles it correctly for both the
> platform_data and DT use cases because in the DT case the uioinfo
> structure is zeroed by kzalloc().

Ok, fixed, thanks!

> As an aside, switching to devm_kzalloc() would simplify the unwind
>   path.

Well, lets leave that for another day...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
