Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab3KNHbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 02:31:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:41047 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087Ab3KNHbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 02:31:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="408592340"
Message-ID: <528479A9.9020802@intel.com>
Date: Thu, 14 Nov 2013 15:20:09 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH 2/2] ACPI / bind: Use (put|get)_device() on ACPI device
 objects too
References: <3268437.YsusHvklcv@vostro.rjw.lan> <1803808.ghCmmaO2Cj@vostro.rjw.lan> <9712243.It8gvaRCs0@vostro.rjw.lan>
In-Reply-To: <9712243.It8gvaRCs0@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年11月14日 07:26, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> When associating a "physical" device with an ACPI device object
> acpi_bind_one() only uses get_device() to increment the reference
> counter of the former, but there is no reason not to do that with
> the latter too.  Among other things, that may help to avoid
> use-after-free when an ACPI device object is freed without calling
> acpi_unbind_one() for all "physical" devices associated with it
> (that only can happen in buggy code, but then it's better if the
> kernel doesn't crash as a result of a bug).
> 
> For this reason, modify acpi_bind_one() to apply get_device() to
> the ACPI device object too and update acpi_unbind_one() to drop
> that reference using put_device() as appropriate.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/glue.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> Index: linux-pm/drivers/acpi/glue.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/glue.c
> +++ linux-pm/drivers/acpi/glue.c
> @@ -217,6 +217,7 @@ int acpi_bind_one(struct device *dev, ac
>  	if (!acpi_dev)
>  		return -EINVAL;
>  
> +	get_device(&acpi_dev->dev);
>  	get_device(dev);
>  	physical_node = kzalloc(sizeof(*physical_node), GFP_KERNEL);
>  	if (!physical_node) {
> @@ -243,6 +244,7 @@ int acpi_bind_one(struct device *dev, ac
>  				goto err;
>  
>  			put_device(dev);
> +			put_device(&acpi_dev->dev);
>  			return 0;
>  		}
>  		if (pn->node_id == node_id) {
> @@ -282,6 +284,7 @@ int acpi_bind_one(struct device *dev, ac
>   err:
>  	ACPI_COMPANION_SET(dev, NULL);
>  	put_device(dev);
> +	put_device(&acpi_dev->dev);
>  	return retval;
>  }
>  EXPORT_SYMBOL_GPL(acpi_bind_one);
> @@ -307,8 +310,9 @@ int acpi_unbind_one(struct device *dev)
>  			sysfs_remove_link(&acpi_dev->dev.kobj, physnode_name);
>  			sysfs_remove_link(&dev->kobj, "firmware_node");
>  			ACPI_COMPANION_SET(dev, NULL);
> -			/* acpi_bind_one() increase refcnt by one. */
> +			/* Drop references taken by acpi_bind_one(). */
>  			put_device(dev);
> +			put_device(&acpi_dev->dev);
>  			kfree(entry);
>  			break;
>  		}
> 

Reviewed-by: Lan Tianyu <tianyu.lan@intel.com>

-- 
Best regards
Tianyu Lan
