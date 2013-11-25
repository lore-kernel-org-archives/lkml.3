Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab3KYXMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 18:12:55 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:53769 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3KYXMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 18:12:53 -0500
Date: Mon, 25 Nov 2013 16:12:48 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Veaceslav Falico <vfalico@redhat.com>
Cc: linux-pci@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, yinghai@kernel.org, Knut_Petersen@t-online.de,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 1/3] msi: free msi_desc entry only after we've
 released the kobject
Message-ID: <20131125231248.GB4034@google.com>
References: <1383042632-7102-1-git-send-email-vfalico@redhat.com>
 <1383042632-7102-2-git-send-email-vfalico@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383042632-7102-2-git-send-email-vfalico@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 11:30:30AM +0100, Veaceslav Falico wrote:
> Currently, we first do kobject_put(&entry->kobj) and the kfree(entry),
> however kobject_put() doesn't guarantee us that it was the last reference
> and that the kobj isn't used currently by someone else, so after we
> kfree(entry) with the struct kobject - other users will begin using the
> freed memory, instead of the actual kobject.
> 
> Fix this by using the kobject->release callback, which is called last when
> the kobject is indeed not used and is cleaned up - it's msi_kobj_release(),
> which can do the kfree(entry) safely (kobject_put/cleanup doesn't use the
> kobj itself after ->release() was called, so we're safe).
> 
> In case we've failed to create the sysfs directories - just kfree()
> it - cause we don't have the kobjects attached.
> 
> Also, remove the same functionality from populate_msi_sysfs(), cause on
> failure we anyway call free_msi_irqs(), which will take care of all the
> kobjects properly.
> 
> And add the forgotten pci_dev_put(pdev) in case of failure to register the
> kobject in populate_msi_sysfs().
> 
> CC: Bjorn Helgaas <bhelgaas@google.com>
> CC: Neil Horman <nhorman@tuxdriver.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: linux-pci@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> Signed-off-by: Veaceslav Falico <vfalico@redhat.com>

I'm still hoping that Greg (or somebody else; Greg already posted the bulk
of the work) will finish up the conversion to attributes, and that Neil
will confirm that works with no changes to irqbalance.  So I'm going to
drop these patches for now.  Poke me if we need to revive them.

Bjorn

> ---
>  drivers/pci/msi.c | 31 ++++++++++++-------------------
>  1 file changed, 12 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index d5f90d6..5d70f49 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -374,19 +374,22 @@ static void free_msi_irqs(struct pci_dev *dev)
>  				iounmap(entry->mask_base);
>  		}
>  
> +		list_del(&entry->list);
> +
>  		/*
>  		 * Its possible that we get into this path
>  		 * When populate_msi_sysfs fails, which means the entries
>  		 * were not registered with sysfs.  In that case don't
> -		 * unregister them.
> +		 * unregister them, and just free. Otherwise the
> +		 * kobject->release will take care of freeing the entry via
> +		 * msi_kobj_release().
>  		 */
>  		if (entry->kobj.parent) {
>  			kobject_del(&entry->kobj);
>  			kobject_put(&entry->kobj);
> +		} else {
> +			kfree(entry);
>  		}
> -
> -		list_del(&entry->list);
> -		kfree(entry);
>  	}
>  }
>  
> @@ -509,6 +512,7 @@ static void msi_kobj_release(struct kobject *kobj)
>  	struct msi_desc *entry = to_msi_desc(kobj);
>  
>  	pci_dev_put(entry->dev);
> +	kfree(entry);
>  }
>  
>  static struct kobj_type msi_irq_ktype = {
> @@ -522,7 +526,6 @@ static int populate_msi_sysfs(struct pci_dev *pdev)
>  	struct msi_desc *entry;
>  	struct kobject *kobj;
>  	int ret;
> -	int count = 0;
>  
>  	pdev->msi_kset = kset_create_and_add("msi_irqs", NULL, &pdev->dev.kobj);
>  	if (!pdev->msi_kset)
> @@ -534,23 +537,13 @@ static int populate_msi_sysfs(struct pci_dev *pdev)
>  		pci_dev_get(pdev);
>  		ret = kobject_init_and_add(kobj, &msi_irq_ktype, NULL,
>  				     "%u", entry->irq);
> -		if (ret)
> -			goto out_unroll;
> -
> -		count++;
> +		if (ret) {
> +			pci_dev_put(pdev);
> +			return ret;
> +		}
>  	}
>  
>  	return 0;
> -
> -out_unroll:
> -	list_for_each_entry(entry, &pdev->msi_list, list) {
> -		if (!count)
> -			break;
> -		kobject_del(&entry->kobj);
> -		kobject_put(&entry->kobj);
> -		count--;
> -	}
> -	return ret;
>  }
>  
>  /**
> -- 
> 1.8.4
> 
