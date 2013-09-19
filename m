Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab3ISEPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 00:15:46 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:38785 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab3ISEPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 00:15:44 -0400
Date: Wed, 18 Sep 2013 21:15:34 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Huang Shijie <b32955@freescale.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtd: nand: fix memory leak in ONFI extended parameter
 page
Message-ID: <20130919041534.GA31275@brian-ubuntu>
References: <1379381512-2007-1-git-send-email-computersforpeace@gmail.com>
 <5237BAA9.6000606@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5237BAA9.6000606@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 10:12:57AM +0800, Huang Shijie wrote:
> 于 2013年09月17日 09:31, Brian Norris 写道:
> > This fixes a memory leak in the ONFI support code for detecting the
> > required ECC levels from this commit:
> >
> >   commit 6dcbe0cdd83fb5f77be4f44c9e06c535281c375a
> >   Author: Huang Shijie <b32955@freescale.com>
> >   Date:   Wed May 22 10:28:27 2013 +0800
> >
> >       mtd: get the ECC info from the Extended Parameter Page
> >
> > In the success case, we never freed the 'ep' buffer.
> >
> > Also, this fixes an oversight in the same commit where we (harmlessly)
> > freed the NULL pointer.
> >
> > Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> > Cc: Huang Shijie <b32955@freescale.com>
> > ---
> > David, if there are no objections, can you send this to Linus for 3.12?
> >
> > If this doesn't make it into 3.12, then it will be -stable material.
> >
> >  drivers/mtd/nand/nand_base.c | 8 +++-----
> >  1 file changed, 3 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
> > index d4578a1..00022b4 100644
> > --- a/drivers/mtd/nand/nand_base.c
> > +++ b/drivers/mtd/nand/nand_base.c
> > @@ -2869,10 +2869,8 @@ static int nand_flash_detect_ext_param_page(struct mtd_info *mtd,
> >  
> >  	len = le16_to_cpu(p->ext_param_page_length) * 16;
> >  	ep = kmalloc(len, GFP_KERNEL);
> > -	if (!ep) {
> > -		ret = -ENOMEM;
> > -		goto ext_out;
> > -	}
> > +	if (!ep)
> > +		return -ENOMEM;
> >  
> >  	/* Send our own NAND_CMD_PARAM. */
> >  	chip->cmdfunc(mtd, NAND_CMD_PARAM, 0, -1);
> > @@ -2920,7 +2918,7 @@ static int nand_flash_detect_ext_param_page(struct mtd_info *mtd,
> >  	}
> >  
> >  	pr_info("ONFI extended param page detected.\n");
> > -	return 0;
> > +	ret = 0;
> >  
> >  ext_out:
> >  	kfree(ep);
> good catch!
> 
> Acked-by: Huang Shijie <b32955@freescale.com>

OK, pushed to l2-mtd.git. If I don't hear anything from David in a few
days, then I'll see about sending it upstream myself. He had time to
respond to your quad-SPI series but not to the pxa3xx compile failures
in his -rc1 pull request.

Brian
