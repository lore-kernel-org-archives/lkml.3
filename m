Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaIUAxY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 20:53:24 -0400
Received: from imap.hinterhof.net ([80.69.43.37]:48671 "EHLO
	imap.hinterhof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaIUAxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 20:53:22 -0400
Date: Sun, 21 Sep 2014 02:44:33 +0200
From: Max Vozeler <max@hinterhof.net>
To: Maximilian Eschenbacher <maximilian@eschenbacher.email>
Cc: linux-kernel@vger.kernel.org, valentina.manea.m@gmail.com,
        shuah.kh@samsung.com, gregkh@linuxfoundation.org,
        Dominik Paulus <dominik.paulus@fau.de>,
        Fjodor Schelichow <fjodor.schelichow@hotmail.com>,
        Johannes Stadlinger <johannes.stadlinger@fau.de>,
        Kurt Kanzenbach <ly80toro@cip.cs.fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>
Subject: Re: [PATCH 03/18] usbip: Add kernel support for client ACLs
Message-ID: <20140921004433.GA12922@x201t.vpn.hinterhof.net>
References: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
 <1410910735-27929-4-git-send-email-maximilian@eschenbacher.email>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410910735-27929-4-git-send-email-maximilian@eschenbacher.email>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 16, 2014 at 11:38:40PM +0000, Maximilian Eschenbacher wrote:
> From: Dominik Paulus <dominik.paulus@fau.de>
> 
> This patch adds the possibility to stored ACLs for allowed clients for
> each stub device in sysfs. It adds a new sysfs entry called "usbip_acl"
> for each stub device, containing a list of CIDR masks of allowed
> clients. This file will be used by usbip and usbipd to store the ACL.

Is there a need to involve the kernel here, couldn't usbip and usbipd
apply the ACLs during connection setup in userspace?

> Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
> Signed-off-by: Fjodor Schelichow <fjodor.schelichow@hotmail.com>
> Signed-off-by: Johannes Stadlinger <johannes.stadlinger@fau.de>
> Signed-off-by: Kurt Kanzenbach <ly80toro@cip.cs.fau.de>
> Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
> Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
> ---
>  drivers/usb/usbip/stub.h     |  5 ++++
>  drivers/usb/usbip/stub_dev.c | 60 +++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 64 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/usbip/stub.h b/drivers/usb/usbip/stub.h
> index 266e2b0..b2d3d55 100644
> --- a/drivers/usb/usbip/stub.h
> +++ b/drivers/usb/usbip/stub.h
> @@ -60,6 +60,11 @@ struct stub_device {
>  	struct list_head unlink_free;
>  
>  	wait_queue_head_t tx_waitq;
> +
> +	/* list of allowed IP addrs */
> +	char *acls;
> +	/* for locking list operations */
> +	spinlock_t ip_lock;

Perhaps name this 'acl_lock' to make more obvious what it covers?

>  };
>  
>  /* private data into urb->priv */
> diff --git a/drivers/usb/usbip/stub_dev.c b/drivers/usb/usbip/stub_dev.c
> index fac20e0..e6624f1 100644
> --- a/drivers/usb/usbip/stub_dev.c
> +++ b/drivers/usb/usbip/stub_dev.c
> @@ -119,6 +119,55 @@ err:
>  }
>  static DEVICE_ATTR(usbip_sockfd, S_IWUSR, NULL, store_sockfd);
>  
> +/*
> + * This function replaces the current ACL list
> + */
> +static ssize_t store_acl(struct device *dev, struct device_attribute *attr,
> +			const char *buf, size_t count)
> +{
> +	struct stub_device *sdev = dev_get_drvdata(dev);
> +	int retval;
> +
> +	if (count >= PAGE_SIZE)
> +		return -EINVAL;
> +
> +	spin_lock_irq(&sdev->ip_lock);
> +	kfree(sdev->acls);
> +	sdev->acls = kstrdup(buf, GFP_KERNEL);
> +	if (!sdev->acls)
> +		retval = -ENOMEM;
> +	else
> +		retval = strlen(sdev->acls);
> +	spin_unlock_irq(&sdev->ip_lock);
> +
> +	return retval;
> +}
> +
> +/*
> + * This functions prints all allowed IP addrs for this dev
> + */
> +static ssize_t show_acl(struct device *dev, struct device_attribute *attr,
> +		       char *buf)
> +{
> +	struct stub_device *sdev = dev_get_drvdata(dev);
> +	int retval = 0;
> +
> +	if (!sdev)
> +		return -ENODEV;
> +
> +	spin_lock_irq(&sdev->ip_lock);
> +	if (sdev->acls == NULL) {
> +		retval = 0;
> +	} else {
> +		strcpy(buf, sdev->acls);
> +		retval = strlen(buf);
> +	}
> +	spin_unlock_irq(&sdev->ip_lock);
> +
> +	return retval;
> +}
> +static DEVICE_ATTR(usbip_acl, S_IWUSR | S_IRUGO, show_acl, store_acl);
> +
>  static int stub_add_files(struct device *dev)
>  {
>  	int err = 0;
> @@ -134,9 +183,13 @@ static int stub_add_files(struct device *dev)
>  	err = device_create_file(dev, &dev_attr_usbip_debug);
>  	if (err)
>  		goto err_debug;
> +	err = device_create_file(dev, &dev_attr_usbip_acl);
> +	if (err)
> +		goto err_ip;
>  
>  	return 0;
> -
> +err_ip:
> +	device_remove_file(dev, &dev_attr_usbip_debug);
>  err_debug:
>  	device_remove_file(dev, &dev_attr_usbip_sockfd);
>  err_sockfd:
> @@ -150,6 +203,7 @@ static void stub_remove_files(struct device *dev)
>  	device_remove_file(dev, &dev_attr_usbip_status);
>  	device_remove_file(dev, &dev_attr_usbip_sockfd);
>  	device_remove_file(dev, &dev_attr_usbip_debug);
> +	device_remove_file(dev, &dev_attr_usbip_acl);
>  }
>  
>  static void stub_shutdown_connection(struct usbip_device *ud)
> @@ -287,6 +341,7 @@ static struct stub_device *stub_device_alloc(struct usb_device *udev)
>  	INIT_LIST_HEAD(&sdev->priv_free);
>  	INIT_LIST_HEAD(&sdev->unlink_free);
>  	INIT_LIST_HEAD(&sdev->unlink_tx);
> +	spin_lock_init(&sdev->ip_lock);
>  	spin_lock_init(&sdev->priv_lock);
>  
>  	init_waitqueue_head(&sdev->tx_waitq);
> @@ -453,6 +508,9 @@ static void stub_disconnect(struct usb_device *udev)
>  
>  	usb_put_dev(sdev->udev);
>  
> +	/* free ACL list */
> +	kfree(sdev->acls);
> +
>  	/* free sdev */
>  	busid_priv->sdev = NULL;
>  	stub_device_free(sdev);

Otherwise looks good to me.

	Max
