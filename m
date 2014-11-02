Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaKBVD7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 16:03:59 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:54704 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaKBVD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 16:03:57 -0500
Date: Sun, 2 Nov 2014 22:03:53 +0100
From: Frans Klaver <fransklaver@gmail.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Alexander Holler <holler@ahsoftware.de>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 01/27] mtd: nand: introduce function to fix a common bug
 in most nand-drivers not showing a device in sysfs
Message-ID: <20141102210353.GA9968@gmail.com>
References: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
 <1401142372-14148-2-git-send-email-holler@ahsoftware.de>
 <20140528084344.GB4285@norris-Latitude-E6410>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140528084344.GB4285@norris-Latitude-E6410>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 01:43:44AM -0700, Brian Norris wrote:
> And in fact, if any drivers are missing mtd->name, perhaps it's best to
> just modify the MTD registration to give them a default:
> 
> 	if (!mtd->name)
> 		mtd->name = dev_name(&pdev->dev);
> 

...

> How about we rethink the "helper" approach, and instead just do
> validation in the core code? This would cover most of the important
> parts of your helper, I think:
> 
> diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
> index d201feeb3ca6..39ba5812a5a3 100644
> --- a/drivers/mtd/mtdcore.c
> +++ b/drivers/mtd/mtdcore.c
> @@ -397,6 +397,11 @@ int add_mtd_device(struct mtd_info *mtd)
>  	if (device_register(&mtd->dev) != 0)
>  		goto fail_added;
>  
> +	if (mtd->dev.parent)
> +		mtd->owner = mtd->dev.parent->driver->owner;
> +	else
> +		WARN_ON(1);
> +

So I've picked this up now. I do largely agree with the suggested
approach where the validation and default settings are done in the core
code. There is a problem with this, though. There are MTD devices that
call mtd_device_parse_register() in the _init() function (such as the
maps drivers). These don't have a device ready to be used as parent, and
they would always be throwing this warning.

So either not having a parent device is bad, or it isn't. The comment
suggests it is, the existing code suggests it isn't. So we'll need to
make a decision about who's right.

>  	if (MTD_DEVT(i))
>  		device_create(&mtd_class, mtd->dev.parent,
>  			      MTD_DEVT(i) + 1,
> diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
> index 1ca9aec141ff..9869bbef50cf 100644
> --- a/drivers/mtd/mtdpart.c
> +++ b/drivers/mtd/mtdpart.c
> @@ -370,7 +370,6 @@ static struct mtd_part *allocate_partition(struct mtd_info *master,
>  	slave->mtd.subpage_sft = master->subpage_sft;
>  
>  	slave->mtd.name = name;
> -	slave->mtd.owner = master->owner;

What would be the purpose of removing this line? Owner is already set?
Can we rely on that?

Thanks,
Frans
