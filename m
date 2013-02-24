Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab3BXPpX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 10:45:23 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:22112
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757495Ab3BXPpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 10:45:22 -0500
X-IronPort-AV: E=Sophos;i="4.84,728,1355094000"; 
   d="scan'208";a="3282033"
Date: Sun, 24 Feb 2013 16:45:18 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: =?ISO-8859-15?Q?Heiko_St=FCbner?= <heiko@sntech.de>
cc: Julia Lawall <julia.lawall@lip6.fr>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, ben-linux@fluff.org,
        kgene.kim@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: question about arch/arm/mach-s3c24xx/irq.c
In-Reply-To: <201302241611.13028.heiko@sntech.de>
Message-ID: <alpine.DEB.2.02.1302241644540.1943@hadrien>
References: <alpine.DEB.2.02.1302241241440.1943@hadrien> <20130224123849.GH17833@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1302241437360.1943@hadrien> <201302241611.13028.heiko@sntech.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1105248376-1361720719=:1943"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1105248376-1361720719=:1943
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Sun, 24 Feb 2013, Heiko Stübner wrote:

> Am Sonntag, 24. Februar 2013, 14:39:45 schrieb Julia Lawall:
> > [Adding the person who introduced the code]
> >
> > On Sun, 24 Feb 2013, Russell King - ARM Linux wrote:
> > > On Sun, Feb 24, 2013 at 12:45:11PM +0100, Julia Lawall wrote:
> > > > The function s3c24xx_irq_map in arch/arm/mach-s3c24xx/irq.c contains
> > > > the
> > > >
> > > > code:
> > > >                 parent_irq_data =
> > > >                 &parent_intc->irqs[irq_data->parent_irq];
> > > >
> > > > 		if (!irq_data) {
> > > >
> > > >                         pr_err("irq-s3c24xx: no irq data found for
> > > >                         hwirq %lu\n",
> > > >
> > > >                                hw);
> > > >
> > > >                         goto err;
> > > >
> > > > 		}
> > > >
> > > > At this point irq_data has already been tested, so the null test on
> > > > irq_data does not look correct.  But I wonder if parent_irq_data could
> > > > ever be null here?
> > >
> > > That would be really obscure - because that would require parent_intc to
> > > be a "negative" pointer (to counter-act the indexing by
> > > irq_data->parent_irq).  So it looks to me like the above is redundant.
> >
> > Even at its original definition irq_data seems unlikely to be NULL:
> >
> >         struct s3c_irq_intc *intc = h->host_data;
> > 	struct s3c_irq_data *irq_data = &intc->irqs[hw];
> > 	...
> > 	if (!irq_data) {
> >                 pr_err("irq-s3c24xx: no irq data found for hwirq %lu\n",
> > hw); return -EINVAL;
> >         }
> >
> > That is, it could be an invalid value, but whether it actually hits 0
> > would seem to depend on the value hw?
> >
> > Heiko, is NULL really a possibility?
>
> The test you quoted is of course wrong ... it would need to test
> parent_irq_data. But you're also right that the test is not necessary at all.
>
> All the s3c_irq_data arrays used always contain 32 entries to reach all bits
> of the register (which is used differently on each SoC). So if we have found
> the parent_intc at all, it should contain a 32 entries array of irq_data
> structs, so no need to test for the existence of the individual array element.
>
>
> And now that I look at it, I also see another glitch. The code tests for
> parent_irq != 0, which of course won't work if the parent_irq is the 0-hwirq
> of the parent controller.
> The only SoC using such a mapping is the s3c2412 [0], which explains why I
> haven't been bitten by this myself.

Do you want to make all the fixes?

julia
--8323329-1105248376-1361720719=:1943--
