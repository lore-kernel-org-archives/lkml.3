Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbaE1Inu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:43:50 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:41451 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245AbaE1Ins (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:43:48 -0400
Date: Wed, 28 May 2014 01:43:44 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 01/27] mtd: nand: introduce function to fix a common bug
 in most nand-drivers not showing a device in sysfs
Message-ID: <20140528084344.GB4285@norris-Latitude-E6410>
References: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
 <1401142372-14148-2-git-send-email-holler@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401142372-14148-2-git-send-email-holler@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 12:12:26AM +0200, Alexander Holler wrote:
> --- a/include/linux/mtd/mtd.h
> +++ b/include/linux/mtd/mtd.h
> @@ -23,7 +23,7 @@
>  #include <linux/types.h>
>  #include <linux/uio.h>
>  #include <linux/notifier.h>
> -#include <linux/device.h>
> +#include <linux/platform_device.h>
>  
>  #include <mtd/mtd-abi.h>
>  
> @@ -366,6 +366,15 @@ static inline int mtd_can_have_bb(const struct mtd_info *mtd)
>  struct mtd_partition;
>  struct mtd_part_parser_data;
>  
> +static inline void mtd_setup_common_members(struct mtd_info *mtd, void *priv,
> +						struct platform_device *pdev)

Thanks for the diligence on catching these issues, but I'm not sure this
helper function is fully the correct approach here.

> +{
> +	mtd->priv	= priv;

I don't think you should hide this one here. It will be quite obvious if
a driver didn't stash its private data but tries to access it later. Are
there any drivers that missed this?

> +	mtd->owner	= pdev->dev.driver->owner;
> +	mtd->dev.parent	= &pdev->dev;
> +	mtd->name	= pdev->dev.driver->name;

I think this is a little dangerous. You're potentially clobbering the
name that a driver already chose here. And why did you pick to use the
driver name? This gives non-unique names if there is more than one
device instantiated for a driver. That's why some drivers already use
the device name, not the driver name:

	mtd->name = dev_name(&pev->dev);

And in fact, if any drivers are missing mtd->name, perhaps it's best to
just modify the MTD registration to give them a default:

	if (!mtd->name)
		mtd->name = dev_name(&pdev->dev);

> +}

BTW, nothing in this function actually makes sense to require a
platform_device, does it? And it's possible to have non-platform drivers
that want to do basic MTD initialization. So (if we still keep this
helper function at all), I'd recommend just a 'struct device *dev'
parameter.

> +
>  extern int mtd_device_parse_register(struct mtd_info *mtd,
>  				     const char * const *part_probe_types,
>  				     struct mtd_part_parser_data *parser_data,

How about we rethink the "helper" approach, and instead just do
validation in the core code? This would cover most of the important
parts of your helper, I think:

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index d201feeb3ca6..39ba5812a5a3 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -397,6 +397,11 @@ int add_mtd_device(struct mtd_info *mtd)
 	if (device_register(&mtd->dev) != 0)
 		goto fail_added;
 
+	if (mtd->dev.parent)
+		mtd->owner = mtd->dev.parent->driver->owner;
+	else
+		WARN_ON(1);
+
 	if (MTD_DEVT(i))
 		device_create(&mtd_class, mtd->dev.parent,
 			      MTD_DEVT(i) + 1,
diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index 1ca9aec141ff..9869bbef50cf 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -370,7 +370,6 @@ static struct mtd_part *allocate_partition(struct mtd_info *master,
 	slave->mtd.subpage_sft = master->subpage_sft;
 
 	slave->mtd.name = name;
-	slave->mtd.owner = master->owner;
 	slave->mtd.backing_dev_info = master->backing_dev_info;
 
 	/* NOTE:  we don't arrange MTDs as a tree; it'd be error-prone

--
Brian
