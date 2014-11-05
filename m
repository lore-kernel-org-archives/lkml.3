Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbaKEJej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:34:39 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55331 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaKEJee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:34:34 -0500
Date: Wed, 5 Nov 2014 01:34:30 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Frans Klaver <fransklaver@gmail.com>
Cc: Alexander Holler <holler@ahsoftware.de>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 01/27] mtd: nand: introduce function to fix a common bug
 in most nand-drivers not showing a device in sysfs
Message-ID: <20141105093430.GH22361@norris-Latitude-E6410>
References: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
 <1401142372-14148-2-git-send-email-holler@ahsoftware.de>
 <20140528084344.GB4285@norris-Latitude-E6410>
 <20141102210353.GA9968@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141102210353.GA9968@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2014 at 10:03:53PM +0100, Frans Klaver wrote:
> On Wed, May 28, 2014 at 01:43:44AM -0700, Brian Norris wrote:
> > And in fact, if any drivers are missing mtd->name, perhaps it's best to
> > just modify the MTD registration to give them a default:
> > 
> > 	if (!mtd->name)
> > 		mtd->name = dev_name(&pdev->dev);
> > 
> 
> ...
> 
> > How about we rethink the "helper" approach, and instead just do
> > validation in the core code? This would cover most of the important
> > parts of your helper, I think:
> > 
> > diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
> > index d201feeb3ca6..39ba5812a5a3 100644
> > --- a/drivers/mtd/mtdcore.c
> > +++ b/drivers/mtd/mtdcore.c
> > @@ -397,6 +397,11 @@ int add_mtd_device(struct mtd_info *mtd)
> >  	if (device_register(&mtd->dev) != 0)
> >  		goto fail_added;
> >  
> > +	if (mtd->dev.parent)
> > +		mtd->owner = mtd->dev.parent->driver->owner;
> > +	else
> > +		WARN_ON(1);
> > +
> 
> So I've picked this up now. I do largely agree with the suggested
> approach where the validation and default settings are done in the core
> code. There is a problem with this, though. There are MTD devices that
> call mtd_device_parse_register() in the _init() function (such as the
> maps drivers). These don't have a device ready to be used as parent, and
> they would always be throwing this warning.

Yeah, I came across the same thing. I think gluebi is another example.

> So either not having a parent device is bad, or it isn't. The comment
> suggests it is, the existing code suggests it isn't. So we'll need to
> make a decision about who's right.

I think not having a parent is not really bad. It's helpful for tracking
the device hierarchy in sysfs, but it's not strictly necessary. So we
should probably not do anything drastic like WARN_ON() yet.

> >  	if (MTD_DEVT(i))
> >  		device_create(&mtd_class, mtd->dev.parent,
> >  			      MTD_DEVT(i) + 1,
> > diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
> > index 1ca9aec141ff..9869bbef50cf 100644
> > --- a/drivers/mtd/mtdpart.c
> > +++ b/drivers/mtd/mtdpart.c
> > @@ -370,7 +370,6 @@ static struct mtd_part *allocate_partition(struct mtd_info *master,
> >  	slave->mtd.subpage_sft = master->subpage_sft;
> >  
> >  	slave->mtd.name = name;
> > -	slave->mtd.owner = master->owner;
> 
> What would be the purpose of removing this line? Owner is already set?
> Can we rely on that?

I'm not completely sure why I wrote that, but I think the only call site
for alloc_partition() is in mtd_add_partition(), which calls
add_mtd_device().

Brian
