Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab3L0WdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 17:33:11 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:46837
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754840Ab3L0Wc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 17:32:59 -0500
X-IronPort-AV: E=Sophos;i="4.95,563,1384297200"; 
   d="scan'208";a="42493465"
Date: Fri, 27 Dec 2013 23:32:56 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Andrew Morton <akpm@linux-foundation.org>
cc: Julia Lawall <julia.lawall@lip6.fr>, a.zummo@towertech.it,
        grant.likely@linaro.org, robh+dt@kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: question about drivers/rtc/rtc-cmos.c
In-Reply-To: <20131227142255.c6b1b7e92a8430f1bebd15af@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1312272332280.2018@localhost6.localdomain6>
References: <alpine.DEB.2.02.1312252028170.2020@localhost6.localdomain6> <20131227142255.c6b1b7e92a8430f1bebd15af@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Dec 2013, Andrew Morton wrote:

> On Wed, 25 Dec 2013 20:32:12 +0100 (CET) Julia Lawall <julia.lawall@lip6.fr> wrote:
> 
> > The function cmos_do_probe contains the code:
> > 
> > 		if (is_hpet_enabled()) {
> >                         int err;
> > 
> >                         rtc_cmos_int_handler = hpet_rtc_interrupt;
> > 			err = hpet_register_irq_handler(cmos_interrupt);
> >                         if (err != 0) {
> >                                 dev_warn(dev, "hpet_register_irq_handler "
> >                                                 " failed in rtc_init().");
> >                                 goto cleanup1;
> >                         }
> >                 }
> > 
> > Is it intentional that the error code returned by 
> > hpet_register_irq_handler is put ina local variable that will not be seen 
> > at label cleanup1?  The return value is retval, which is 0 at this point.
> 
> No, I'd say that's a bug.  How does this look?

That is what I was going to propose.

julia


> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: drivers/rtc/rtc-cmos.c: propagate hpet_register_irq_handler() failure
> 
> If hpet_register_irq_handler() fails, cmos_do_probe() will incorrectly
> return 0.
> 
> Reported-by: Julia Lawall <julia.lawall@lip6.fr>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/rtc/rtc-cmos.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff -puN drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure drivers/rtc/rtc-cmos.c
> --- a/drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure
> +++ a/drivers/rtc/rtc-cmos.c
> @@ -708,11 +708,9 @@ cmos_do_probe(struct device *dev, struct
>  		irq_handler_t rtc_cmos_int_handler;
>  
>  		if (is_hpet_enabled()) {
> -			int err;
> -
>  			rtc_cmos_int_handler = hpet_rtc_interrupt;
> -			err = hpet_register_irq_handler(cmos_interrupt);
> -			if (err != 0) {
> +			retval = hpet_register_irq_handler(cmos_interrupt);
> +			if (retval) {
>  				dev_warn(dev, "hpet_register_irq_handler "
>  						" failed in rtc_init().");
>  				goto cleanup1;
> _
> 
> 
