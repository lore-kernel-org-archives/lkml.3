Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257AbaEXHzI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 03:55:08 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:31124
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114AbaEXHzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 03:55:07 -0400
X-IronPort-AV: E=Sophos;i="4.98,900,1392159600"; 
   d="scan'208";a="63624828"
Date: Sat, 24 May 2014 09:55:03 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Sam Ravnborg <sam@ravnborg.org>
cc: Himangi Saraogi <himangi774@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] sbus: Introduce the use of the managed version of
 kzalloc
In-Reply-To: <20140523201703.GA17295@ravnborg.org>
Message-ID: <alpine.DEB.2.02.1405240954240.2012@localhost6.localdomain6>
References: <20140522203536.GA16457@himangi-Dell> <20140523201703.GA17295@ravnborg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2014, Sam Ravnborg wrote:

> Hi Himangi.
> 
> On Fri, May 23, 2014 at 02:05:36AM +0530, Himangi Saraogi wrote:
> > This patch moves data allocated using kzalloc to managed data allocated
> > using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
> > functions. The header file is added to make the devm function explicitly
> > available. Also, unnecessary assignment statements and labels are
> > removed.
> > 
> > ---
> > Not compile tested due to incompatible architecture.
> I can confirm that i builds.
> 
> 
> > 
> > To send to: "David S. Miller" <davem@davemloft.net>,sparclinux@vger.kernel.org,linux-kernel@vger.kernel.org
> > 
> >  drivers/sbus/char/display7seg.c | 23 ++++++++---------------
> >  1 file changed, 8 insertions(+), 15 deletions(-)
> > 
> > diff --git a/drivers/sbus/char/display7seg.c b/drivers/sbus/char/display7seg.c
> > index 7c71e7b..367b64d 100644
> > --- a/drivers/sbus/char/display7seg.c
> > +++ b/drivers/sbus/char/display7seg.c
> > @@ -20,6 +20,7 @@
> >  #include <asm/io.h>
> >  
> >  #include <asm/display7seg.h>
> > +#include <linux/device.h>
> >  
> >  #define D7S_MINOR	193
> >  #define DRIVER_NAME	"d7s"
> > @@ -173,22 +174,21 @@ static struct miscdevice d7s_miscdev = {
> >  static int d7s_probe(struct platform_device *op)
> >  {
> >  	struct device_node *opts;
> > -	int err = -EINVAL;
> > +	int err;
> >  	struct d7s *p;
> >  	u8 regs;
> >  
> >  	if (d7s_device)
> > -		goto out;
> > +		return -EINVAL;
> >  
> > -	p = kzalloc(sizeof(*p), GFP_KERNEL);
> > -	err = -ENOMEM;
> > +	p = devm_kzalloc(&op->dev, sizeof(*p), GFP_KERNEL);
> >  	if (!p)
> > -		goto out;
> > +		return -ENOMEM;
> >  
> >  	p->regs = of_ioremap(&op->resource[0], 0, sizeof(u8), "d7s");
> >  	if (!p->regs) {
> >  		printk(KERN_ERR PFX "Cannot map chip registers\n");
> > -		goto out_free;
> > +		return -ENOMEM;
> 
> Can you please explain how it can be correct to return "-ENOMEM",
> when we fail to map the chip registers.
> Before your patch this resulted in "-EINVAL" - so this is a change in behaviour.

I don't see it.  It looks to me that it returned ENOMEM, due to the 
assignment after the kzalloc.

julia

> >  	}
> >  
> >  	err = misc_register(&d7s_miscdev);
> > @@ -222,17 +222,11 @@ static int d7s_probe(struct platform_device *op)
> >  
> >  	dev_set_drvdata(&op->dev, p);
> >  	d7s_device = p;
> > -	err = 0;
> > -
> > -out:
> > -	return err;
> > +	return 0;
> >  
> >  out_iounmap:
> >  	of_iounmap(&op->resource[0], p->regs, sizeof(u8));
> > -
> > -out_free:
> > -	kfree(p);
> > -	goto out;
> > +	return err;
> >  }
> It is not am improvement IMO that you replace the nice goto
> based error handling with random return points in the code.
> 
> 	Sam
> 
