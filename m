Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbaL3NvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 08:51:19 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:45025 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbaL3NvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 08:51:17 -0500
Date: Tue, 30 Dec 2014 08:51:14 -0500 (EST)
From: Alex Williamson <alex.williamson@redhat.com>
To: Ethan Zhao <ethan.zhao@oracle.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ethan kernel <ethan.kernel@gmail.com>
Message-ID: <1897331044.2487289.1419947474236.JavaMail.zimbra@redhat.com>
In-Reply-To: <1419927707-14462-1-git-send-email-ethan.zhao@oracle.com>
References: <1419927707-14462-1-git-send-email-ethan.zhao@oracle.com>
Subject: Re: [PATCH] PCI: export pci device assignment info as read only via
 sysfs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - GC39 (Linux)/8.0.6_GA_5922)
Thread-Topic: export pci device assignment info as read only via sysfs
Thread-Index: 5kuvSN9OzDZ7eM7eI1ee9igNTaXETA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> This patch exports assignment flag of PCI device via sysfs, so user
> space application could know if PCI device was assigned to guest OS
> or not via interface as following from viewpoint of host device
> management:
> 
>  PCI device was assigned to guest OS
>  $cat /sys/devices/pci0000:00/0000:00:1f.3/assigned
>  1
> 
>  PCI device isn't assigned to guest OS
>  $cat /sys/devices/pci0000:00/0000:00:1f.3/assigned
>  0
> 
> Compiled and tested with v3.18.1
> 
> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
> ---
>  drivers/pci/pci-sysfs.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 2c6643f..0ac3780 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -547,6 +547,15 @@ static ssize_t driver_override_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RW(driver_override);
>  
> +static ssize_t assigned_show(struct device *dev, struct device_attribute
> *attr,
> +			 char *buf)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +
> +	return sprintf(buf, "%d\n", pci_is_dev_assigned(pdev) ? 1 : 0);
> +}
> +static DEVICE_ATTR_RO(assigned);
> +
>  static struct attribute *pci_dev_attrs[] = {
>  	&dev_attr_resource.attr,
>  	&dev_attr_vendor.attr,
> @@ -573,6 +582,7 @@ static struct attribute *pci_dev_attrs[] = {
>  	&dev_attr_devspec.attr,
>  #endif
>  	&dev_attr_driver_override.attr,
> +	&dev_attr_assigned.attr,
>  	NULL,
>  };
>  

NAK.  The assigned attribute of a device is already in contention, it's racy and not universally used.  If we can't even make it a consistent and reliable internal interface, we certainly shouldn't be exposing it to userspace.  Thanks,

Alex
