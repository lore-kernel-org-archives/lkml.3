Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab3LSW20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 17:28:26 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:44081 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab3LSW2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 17:28:24 -0500
Date: Thu, 19 Dec 2013 15:28:12 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Neil Horman <nhorman@tuxdriver.com>, Veaceslav Falico <vfalico@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] PCI: export MSI mode using attributes, not kobjects
Message-ID: <20131219222812.GC15201@google.com>
References: <20131219203017.GA1768@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131219203017.GA1768@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 12:30:17PM -0800, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> The PCI MSI sysfs code is a mess with kobjects for things that don't
> really need to be kobjects.  This patch creates attributes dynamically
> for the MSI interrupts instead of using kobjects.
> 
> Note, this removes a directory from the current MSI interrupt sysfs
> code:
> 
> old MSI kobjects:
> pci_device
>    └── msi_irqs
>        └── 40
>            └── mode
> 
> new MSI attributes:
> pci_device
>    └── msi_irqs
>        └── 40
> 
> As there was only one file "mode" with the kobject model, the interrupt
> number is now a file that returns the "mode" of the interrupt (msi vs.
> msix).
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks, I added this to pci/msi for v3.14.

> ---
> v3: attribute creation properly tagged for lockdep.
>     error handling if creation of attributes fails.
> 
> v2: add documentation for sysfs attributes
> 
>  Documentation/ABI/testing/sysfs-bus-pci |   11 --
>  drivers/pci/msi.c                       |  166 +++++++++++++++++---------------
>  include/linux/pci.h                     |    2 
>  3 files changed, 96 insertions(+), 83 deletions(-)
> 
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -70,18 +70,15 @@ Date:		September, 2011
>  Contact:	Neil Horman <nhorman@tuxdriver.com>
>  Description:
>  		The /sys/devices/.../msi_irqs directory contains a variable set
> -		of sub-directories, with each sub-directory being named after a
> -		corresponding msi irq vector allocated to that device.  Each
> -		numbered sub-directory N contains attributes of that irq.
> -		Note that this directory is not created for device drivers which
> -		do not support msi irqs
> +		of files, with each file being named after a corresponding msi
> +		irq vector allocated to that device.
>  
> -What:		/sys/bus/pci/devices/.../msi_irqs/<N>/mode
> +What:		/sys/bus/pci/devices/.../msi_irqs/<N>
>  Date:		September 2011
>  Contact:	Neil Horman <nhorman@tuxdriver.com>
>  Description:
>  		This attribute indicates the mode that the irq vector named by
> -		the parent directory is in (msi vs. msix)
> +		the file is in (msi vs. msix)
>  
>  What:		/sys/bus/pci/devices/.../remove
>  Date:		January 2009
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -363,6 +363,9 @@ void write_msi_msg(unsigned int irq, str
>  static void free_msi_irqs(struct pci_dev *dev)
>  {
>  	struct msi_desc *entry, *tmp;
> +	struct attribute **msi_attrs;
> +	struct device_attribute *dev_attr;
> +	int count = 0;
>  
>  	list_for_each_entry(entry, &dev->msi_list, list) {
>  		int i, nvec;
> @@ -398,6 +401,22 @@ static void free_msi_irqs(struct pci_dev
>  		list_del(&entry->list);
>  		kfree(entry);
>  	}
> +
> +	if (dev->msi_irq_groups) {
> +		sysfs_remove_groups(&dev->dev.kobj, dev->msi_irq_groups);
> +		msi_attrs = dev->msi_irq_groups[0]->attrs;
> +		list_for_each_entry(entry, &dev->msi_list, list) {
> +			dev_attr = container_of(msi_attrs[count],
> +						struct device_attribute, attr);
> +			kfree(dev_attr->attr.name);
> +			kfree(dev_attr);
> +			++count;
> +		}
> +		kfree(msi_attrs);
> +		kfree(dev->msi_irq_groups[0]);
> +		kfree(dev->msi_irq_groups);
> +		dev->msi_irq_groups = NULL;
> +	}
>  }
>  
>  static struct msi_desc *alloc_msi_entry(struct pci_dev *dev)
> @@ -471,94 +490,95 @@ void pci_restore_msi_state(struct pci_de
>  }
>  EXPORT_SYMBOL_GPL(pci_restore_msi_state);
>  
> -
> -#define to_msi_attr(obj) container_of(obj, struct msi_attribute, attr)
> -#define to_msi_desc(obj) container_of(obj, struct msi_desc, kobj)
> -
> -struct msi_attribute {
> -	struct attribute        attr;
> -	ssize_t (*show)(struct msi_desc *entry, struct msi_attribute *attr,
> -			char *buf);
> -	ssize_t (*store)(struct msi_desc *entry, struct msi_attribute *attr,
> -			 const char *buf, size_t count);
> -};
> -
> -static ssize_t show_msi_mode(struct msi_desc *entry, struct msi_attribute *atr,
> +static ssize_t msi_mode_show(struct device *dev, struct device_attribute *attr,
>  			     char *buf)
>  {
> -	return sprintf(buf, "%s\n", entry->msi_attrib.is_msix ? "msix" : "msi");
> -}
> -
> -static ssize_t msi_irq_attr_show(struct kobject *kobj,
> -				 struct attribute *attr, char *buf)
> -{
> -	struct msi_attribute *attribute = to_msi_attr(attr);
> -	struct msi_desc *entry = to_msi_desc(kobj);
> -
> -	if (!attribute->show)
> -		return -EIO;
> -
> -	return attribute->show(entry, attribute, buf);
> -}
> -
> -static const struct sysfs_ops msi_irq_sysfs_ops = {
> -	.show = msi_irq_attr_show,
> -};
> -
> -static struct msi_attribute mode_attribute =
> -	__ATTR(mode, S_IRUGO, show_msi_mode, NULL);
> -
> -
> -static struct attribute *msi_irq_default_attrs[] = {
> -	&mode_attribute.attr,
> -	NULL
> -};
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	struct msi_desc *entry;
> +	unsigned long irq;
> +	int retval;
>  
> -static void msi_kobj_release(struct kobject *kobj)
> -{
> -	struct msi_desc *entry = to_msi_desc(kobj);
> +	retval = kstrtoul(attr->attr.name, 10, &irq);
> +	if (retval)
> +		return retval;
>  
> -	pci_dev_put(entry->dev);
> +	list_for_each_entry(entry, &pdev->msi_list, list) {
> +		if (entry->irq == irq) {
> +			return sprintf(buf, "%s\n",
> +				       entry->msi_attrib.is_msix ? "msix" : "msi");
> +		}
> +	}
> +	return -ENODEV;
>  }
>  
> -static struct kobj_type msi_irq_ktype = {
> -	.release = msi_kobj_release,
> -	.sysfs_ops = &msi_irq_sysfs_ops,
> -	.default_attrs = msi_irq_default_attrs,
> -};
> -
>  static int populate_msi_sysfs(struct pci_dev *pdev)
>  {
> +	struct attribute **msi_attrs;
> +	struct attribute *msi_attr;
> +	struct device_attribute *msi_dev_attr;
> +	struct attribute_group *msi_irq_group;
> +	const struct attribute_group **msi_irq_groups;
>  	struct msi_desc *entry;
> -	struct kobject *kobj;
> -	int ret;
> +	int ret = -ENOMEM;
> +	int num_msi = 0;
>  	int count = 0;
>  
> -	pdev->msi_kset = kset_create_and_add("msi_irqs", NULL, &pdev->dev.kobj);
> -	if (!pdev->msi_kset)
> -		return -ENOMEM;
> +	/* Determine how many msi entries we have */
> +	list_for_each_entry(entry, &pdev->msi_list, list) {
> +		++num_msi;
> +	}
> +	if (!num_msi)
> +		return 0;
>  
> +	/* Dynamically create the MSI attributes for the PCI device */
> +	msi_attrs = kzalloc(sizeof(void *) * (num_msi + 1), GFP_KERNEL);
> +	if (!msi_attrs)
> +		return -ENOMEM;
>  	list_for_each_entry(entry, &pdev->msi_list, list) {
> -		kobj = &entry->kobj;
> -		kobj->kset = pdev->msi_kset;
> -		pci_dev_get(pdev);
> -		ret = kobject_init_and_add(kobj, &msi_irq_ktype, NULL,
> -				     "%u", entry->irq);
> -		if (ret)
> -			goto out_unroll;
> +		char *name = kmalloc(20, GFP_KERNEL);
> +		msi_dev_attr = kzalloc(sizeof(*msi_dev_attr), GFP_KERNEL);
> +		if (!msi_dev_attr)
> +			goto error_attrs;
> +		sprintf(name, "%d", entry->irq);
> +		sysfs_attr_init(&msi_dev_attr->attr);
> +		msi_dev_attr->attr.name = name;
> +		msi_dev_attr->attr.mode = S_IRUGO;
> +		msi_dev_attr->show = msi_mode_show;
> +		msi_attrs[count] = &msi_dev_attr->attr;
> +		++count;
> +	}
> +
> +	msi_irq_group = kzalloc(sizeof(*msi_irq_group), GFP_KERNEL);
> +	if (!msi_irq_group)
> +		goto error_attrs;
> +	msi_irq_group->name = "msi_irqs";
> +	msi_irq_group->attrs = msi_attrs;
> +
> +	msi_irq_groups = kzalloc(sizeof(void *) * 2, GFP_KERNEL);
> +	if (!msi_irq_groups)
> +		goto error_irq_group;
> +	msi_irq_groups[0] = msi_irq_group;
>  
> -		count++;
> -	}
> +	ret = sysfs_create_groups(&pdev->dev.kobj, msi_irq_groups);
> +	if (ret)
> +		goto error_irq_groups;
> +	pdev->msi_irq_groups = msi_irq_groups;
>  
>  	return 0;
>  
> -out_unroll:
> -	list_for_each_entry(entry, &pdev->msi_list, list) {
> -		if (!count)
> -			break;
> -		kobject_del(&entry->kobj);
> -		kobject_put(&entry->kobj);
> -		count--;
> +error_irq_groups:
> +	kfree(msi_irq_groups);
> +error_irq_group:
> +	kfree(msi_irq_group);
> +error_attrs:
> +	count = 0;
> +	msi_attr = msi_attrs[count];
> +	while (msi_attr) {
> +		msi_dev_attr = container_of(msi_attr, struct device_attribute, attr);
> +		kfree(msi_attr->name);
> +		kfree(msi_dev_attr);
> +		++count;
> +		msi_attr = msi_attrs[count];
>  	}
>  	return ret;
>  }
> @@ -925,8 +945,6 @@ void pci_disable_msi(struct pci_dev *dev
>  
>  	pci_msi_shutdown(dev);
>  	free_msi_irqs(dev);
> -	kset_unregister(dev->msi_kset);
> -	dev->msi_kset = NULL;
>  }
>  EXPORT_SYMBOL(pci_disable_msi);
>  
> @@ -1023,8 +1041,6 @@ void pci_disable_msix(struct pci_dev *de
>  
>  	pci_msix_shutdown(dev);
>  	free_msi_irqs(dev);
> -	kset_unregister(dev->msi_kset);
> -	dev->msi_kset = NULL;
>  }
>  EXPORT_SYMBOL(pci_disable_msix);
>  
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -351,7 +351,7 @@ struct pci_dev {
>  	struct bin_attribute *res_attr_wc[DEVICE_COUNT_RESOURCE]; /* sysfs file for WC mapping of resources */
>  #ifdef CONFIG_PCI_MSI
>  	struct list_head msi_list;
> -	struct kset *msi_kset;
> +	const struct attribute_group **msi_irq_groups;
>  #endif
>  	struct pci_vpd *vpd;
>  #ifdef CONFIG_PCI_ATS
