Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab3HBWjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 18:39:44 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:33081 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab3HBWjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 18:39:43 -0400
Message-ID: <1375483118.10300.113.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI: Do not fail acpi_bind_one() if device is already
 bound correctly
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 02 Aug 2013 16:38:38 -0600
In-Reply-To: <1888947.F5IBMfDKlY@vostro.rjw.lan>
References: <1888947.F5IBMfDKlY@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 00:33 +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Modify acpi_bind_one() so that it doesn't fail if the device
> represented by its first argument has already been bound to the
> given ACPI handle (second argument), because that is not a good
> enough reason for returning an error code.

While it seems reasonable to allow such case, I do not think we will hit
this case under the normal scenarios.  So, I do not think we need to
make this change now unless it actually solves Yasuaki's issue (which I
am guessing not).

Thanks,
-Toshi


> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/glue.c |   15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> Index: linux-pm/drivers/acpi/glue.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/glue.c
> +++ linux-pm/drivers/acpi/glue.c
> @@ -143,7 +143,10 @@ int acpi_bind_one(struct device *dev, ac
>  	list_for_each_entry(pn, &acpi_dev->physical_node_list, node)
>  		if (pn->dev == dev) {
>  			dev_warn(dev, "Already associated with ACPI node\n");
> -			goto err_free;
> +			if (ACPI_HANDLE(dev) == handle)
> +				retval = 0;
> +
> +			goto out_free;
>  		}
>  
>  	/* allocate physical node id according to physical_node_id_bitmap */
> @@ -152,7 +155,7 @@ int acpi_bind_one(struct device *dev, ac
>  		ACPI_MAX_PHYSICAL_NODE);
>  	if (physical_node->node_id >= ACPI_MAX_PHYSICAL_NODE) {
>  		retval = -ENOSPC;
> -		goto err_free;
> +		goto out_free;
>  	}
>  
>  	set_bit(physical_node->node_id, acpi_dev->physical_node_id_bitmap);
> @@ -185,10 +188,14 @@ int acpi_bind_one(struct device *dev, ac
>  	put_device(dev);
>  	return retval;
>  
> - err_free:
> + out_free:
>  	mutex_unlock(&acpi_dev->physical_node_lock);
>  	kfree(physical_node);
> -	goto err;
> +	if (retval)
> +		goto err;
> +
> +	put_device(dev);
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(acpi_bind_one);
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


