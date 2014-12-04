Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbaLDWjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 17:39:12 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:32163 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933241AbaLDWiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 17:38:55 -0500
X-IronPort-AV: E=Sophos;i="5.07,518,1413270000"; 
   d="scan'208";a="52319341"
Message-ID: <5480E27A.8080004@broadcom.com>
Date: Thu, 4 Dec 2014 14:38:50 -0800
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>, Ray Jui <rjui@broadcom.com>,
        Corneliu Doban <cdoban@broadcom.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] mtd: nand: added nand_shutdown
References: <sbranden@broadcom.com> <1416511085-3930-1-git-send-email-sbranden@broadcom.com> <20141126091015.GR3212@norris-Latitude-E6410>
In-Reply-To: <20141126091015.GR3212@norris-Latitude-E6410>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Brian,

I just sent out a new patch with your changes incorporated.

Thanks,
  Scott


On 14-11-26 01:10 AM, Brian Norris wrote:
> On Thu, Nov 20, 2014 at 11:18:05AM -0800, Scott Branden wrote:
>> Add nand_shutdown to wait for current nand operations to finish and prevent
>> further operations by changing the nand flash state to FL_SHUTDOWN.
>>
>> This is addressing a problem observed during reboot tests using UBIFS
>> root file system: NAND erase operations that are in progress during
>> system reboot/shutdown are causing partial erased blocks. Although UBI should
>> be able to detect and recover from this error, this change will avoid
>> the creation of partial erased blocks on reboot in the middle of a NAND erase
>> operation.
> [...]
>> diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
>> index e4d451e..80e4367 100644
>> --- a/include/linux/mtd/nand.h
>> +++ b/include/linux/mtd/nand.h
>> @@ -48,6 +48,13 @@ extern int nand_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len);
>>   /* unlocks specified locked blocks */
>>   extern int nand_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len);
>>
>> +/*
>> + * Internal helper for board drivers which need to make sure that the current
>> + * nand operation is finished and further operations are prevented before
>> + * rebooting the system.
>> + */
>> +extern int nand_shutdown(struct mtd_info *mtd);
>
> I don't think we should push this out to the board drivers. And I
> definitely don't want to merge this function without any user. It'd turn
> out like our useless nand_lock() and nand_unlock() functions.
>
>> +
>>   /* The maximum number of NAND chips in an array */
>>   #define NAND_MAX_CHIPS		8
>>
>
> So, to do this right, I think maybe we should add an (optional)
> reboot_notifier field to struct mtd_info, and use it to register a
> system reboot notifier on behalf of the lower layers. We can do the
> registration in mtd_device_parse_register(), I think, and any
> unregistration in mtd_device_unregister().
>
> With this approach, we can actually move the cfi_cmdset_000{1,2}.c
> reboot notifiers over to the same common code. They just will have to
> fill out their mtd->reboot_notifier field.
>
> How about the following two untested patches?
>
> From: Brian Norris <computersforpeace@gmail.com>
>
> cfi_cmdset_000{1,2}.c already implement their own reboot notifiers, and
> we're going to add one for NAND. Let's put the boilerplate in one place.
>
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> ---
>   drivers/mtd/mtdcore.c   | 20 ++++++++++++++++++++
>   include/linux/mtd/mtd.h |  1 +
>   2 files changed, 21 insertions(+)
>
> diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
> index 4c611871d7e6..b80d44f9751d 100644
> --- a/drivers/mtd/mtdcore.c
> +++ b/drivers/mtd/mtdcore.c
> @@ -37,6 +37,7 @@
>   #include <linux/backing-dev.h>
>   #include <linux/gfp.h>
>   #include <linux/slab.h>
> +#include <linux/reboot.h>
>
>   #include <linux/mtd/mtd.h>
>   #include <linux/mtd/partitions.h>
> @@ -365,6 +366,17 @@ static struct device_type mtd_devtype = {
>   	.release	= mtd_release,
>   };
>
> +static int mtd_reboot_notifier(struct notifier_block *n, unsigned long state,
> +			       void *cmd)
> +{
> +       struct mtd_info *mtd;
> +
> +       mtd = container_of(n, struct mtd_info, reboot_notifier);
> +       mtd->_reboot(mtd);
> +
> +       return NOTIFY_DONE;
> +}
> +
>   /**
>    *	add_mtd_device - register an MTD device
>    *	@mtd: pointer to new MTD device info structure
> @@ -565,6 +577,11 @@ int mtd_device_parse_register(struct mtd_info *mtd, const char * const *types,
>   			err = -ENODEV;
>   	}
>
> +	if (mtd->_reboot) {
> +		mtd->reboot_notifier.notifier_call = mtd_reboot_notifier;
> +		register_reboot_notifier(&mtd->reboot_notifier);
> +	}
> +
>   	return err;
>   }
>   EXPORT_SYMBOL_GPL(mtd_device_parse_register);
> @@ -579,6 +596,9 @@ int mtd_device_unregister(struct mtd_info *master)
>   {
>   	int err;
>
> +	if (master->_reboot)
> +		unregister_reboot_notifier(&master->reboot_notifier);
> +
>   	err = del_mtd_partitions(master);
>   	if (err)
>   		return err;
> diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
> index 031ff3a9a0bd..c06f5373d870 100644
> --- a/include/linux/mtd/mtd.h
> +++ b/include/linux/mtd/mtd.h
> @@ -227,6 +227,7 @@ struct mtd_info {
>   	int (*_block_markbad) (struct mtd_info *mtd, loff_t ofs);
>   	int (*_suspend) (struct mtd_info *mtd);
>   	void (*_resume) (struct mtd_info *mtd);
> +	void (*_reboot) (struct mtd_info *mtd);
>   	/*
>   	 * If the driver is something smart, like UBI, it may need to maintain
>   	 * its own reference counting. The below functions are only for driver.
>

