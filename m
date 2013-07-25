Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab3GYSJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:09:22 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:37756 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756844Ab3GYSJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:09:17 -0400
Date: Thu, 25 Jul 2013 12:09:13 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/36] PCI: convert class code to use dev_groups
Message-ID: <20130725180913.GA6088@google.com>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
 <1374703539-9705-15-git-send-email-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374703539-9705-15-git-send-email-gregkh@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 03:05:17PM -0700, Greg Kroah-Hartman wrote:
> The dev_attrs field of struct class is going away soon, dev_groups
> should be used instead.  This converts the PCI class code to use the
> correct field.
> 
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> 
> Bjorn, feel free to take this through your tree, or ACK it and I can take it
> through mine.

Applied to my pci/misc branch for v3.12, thanks!

> 
>  drivers/pci/pci-sysfs.c | 32 +++++++++++++++++++++-----------
>  drivers/pci/pci.h       |  2 +-
>  drivers/pci/probe.c     |  2 +-
>  3 files changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index c0dbe1f6..7128cfdd 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -131,19 +131,19 @@ static ssize_t pci_bus_show_cpuaffinity(struct device *dev,
>  	return ret;
>  }
>  
> -static inline ssize_t pci_bus_show_cpumaskaffinity(struct device *dev,
> -					struct device_attribute *attr,
> -					char *buf)
> +static ssize_t cpuaffinity_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
>  {
>  	return pci_bus_show_cpuaffinity(dev, 0, attr, buf);
>  }
> +static DEVICE_ATTR_RO(cpuaffinity);
>  
> -static inline ssize_t pci_bus_show_cpulistaffinity(struct device *dev,
> -					struct device_attribute *attr,
> -					char *buf)
> +static ssize_t cpulistaffinity_show(struct device *dev,
> +				    struct device_attribute *attr, char *buf)
>  {
>  	return pci_bus_show_cpuaffinity(dev, 1, attr, buf);
>  }
> +static DEVICE_ATTR_RO(cpulistaffinity);
>  
>  /* show resources */
>  static ssize_t
> @@ -379,6 +379,7 @@ dev_bus_rescan_store(struct device *dev, struct device_attribute *attr,
>  	}
>  	return count;
>  }
> +static DEVICE_ATTR(rescan, (S_IWUSR|S_IWGRP), NULL, dev_bus_rescan_store);
>  
>  #if defined(CONFIG_PM_RUNTIME) && defined(CONFIG_ACPI)
>  static ssize_t d3cold_allowed_store(struct device *dev,
> @@ -514,11 +515,20 @@ struct device_attribute pci_dev_attrs[] = {
>  	__ATTR_NULL,
>  };
>  
> -struct device_attribute pcibus_dev_attrs[] = {
> -	__ATTR(rescan, (S_IWUSR|S_IWGRP), NULL, dev_bus_rescan_store),
> -	__ATTR(cpuaffinity, S_IRUGO, pci_bus_show_cpumaskaffinity, NULL),
> -	__ATTR(cpulistaffinity, S_IRUGO, pci_bus_show_cpulistaffinity, NULL),
> -	__ATTR_NULL,
> +static struct attribute *pcibus_attrs[] = {
> +	&dev_attr_rescan.attr,
> +	&dev_attr_cpuaffinity.attr,
> +	&dev_attr_cpulistaffinity.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group pcibus_group = {
> +	.attrs = pcibus_attrs,
> +};
> +
> +const struct attribute_group *pcibus_groups[] = {
> +	&pcibus_group,
> +	NULL,
>  };
>  
>  static ssize_t
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index d1182c4a..816c297f 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -151,7 +151,7 @@ static inline int pci_no_d1d2(struct pci_dev *dev)
>  
>  }
>  extern struct device_attribute pci_dev_attrs[];
> -extern struct device_attribute pcibus_dev_attrs[];
> +extern const struct attribute_group *pcibus_groups[];
>  extern struct device_type pci_dev_type;
>  extern struct bus_attribute pci_bus_attrs[];
>  
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 46ada5c0..cf57fe79 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -96,7 +96,7 @@ static void release_pcibus_dev(struct device *dev)
>  static struct class pcibus_class = {
>  	.name		= "pci_bus",
>  	.dev_release	= &release_pcibus_dev,
> -	.dev_attrs	= pcibus_dev_attrs,
> +	.dev_groups	= pcibus_groups,
>  };
>  
>  static int __init pcibus_class_init(void)
> -- 
> 1.8.3.rc0.20.gb99dd2e
> 
