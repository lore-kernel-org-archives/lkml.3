Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab3I3Ia5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 04:30:57 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:35893 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab3I3Iay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 04:30:54 -0400
Date: Mon, 30 Sep 2013 11:29:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dominik Paulus <dominik.paulus@fau.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anthony Foiani <anthony.foiani@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@i4.cs.fau.de, Kurt Kanzenbach <ly80toro@cip.cs.fau.de>,
        linux-kernel@vger.kernel.org, tobias.polzer@fau.de,
        Ilija Hadzic <ihadzic@research.bell-labs.com>
Subject: Re: [PATCHv3  02/16] staging: usbip: Add kernel support for client
 ACLs
Message-ID: <20130930082942.GH6192@mwanda>
References: <20130925233638.GA21396@kroah.com>
 <1380390173-3746-1-git-send-email-dominik.paulus@fau.de>
 <1380390173-3746-2-git-send-email-dominik.paulus@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380390173-3746-2-git-send-email-dominik.paulus@fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main thing is that there is an IS_ERR vs NULL check.  The rest is
just style nits.

On Sat, Sep 28, 2013 at 07:42:39PM +0200, Dominik Paulus wrote:
> +static ssize_t store_acl(struct device *dev, struct device_attribute *attr,
> +			const char *buf, size_t count)
> +{
> +	struct stub_device *sdev = dev_get_drvdata(dev);
> +	int retval = 0;
> +
> +	if (!sdev)
> +		return -ENODEV;

Can this even happen?  If not, don't check for impossible conditions it
is sloppy.

> +
> +	if (count >= PAGE_SIZE)
> +		/* Prevent storing oversized ACLs in kernel memory */
> +		return -EINVAL;
> +

Put parenthesis around multi-line indents.  But in this case just delete
the obvious comment.

> +	/* Store ACL */

Delete obvious comment.

> +	spin_lock_irq(&sdev->ip_lock);
> +	kfree(sdev->acls);
> +	sdev->acls = kstrdup(buf, GFP_KERNEL);

kstrdup() returns a NULL on error not an error pointer.  Configure vim
to use cscope and run make cscope.

> +	if (IS_ERR(sdev->acls)) {
> +		retval = PTR_ERR(sdev->acls);
> +		sdev->acls = NULL;
> +	} else {
> +		retval = strlen(sdev->acls);
> +	}
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

Don't initialize things if you don't use the value.  (It stops GCC from
warning about uninitialized variables properly).

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
> @@ -157,9 +213,13 @@ static int stub_add_files(struct device *dev)
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

I wasn't able to figure out what the "ip" part of "err_ip" meant...

Really these are all poor label names.  They are based on the goto
location instead of the label location.

> @@ -173,6 +233,7 @@ static void stub_remove_files(struct device *dev)
>  	device_remove_file(dev, &dev_attr_usbip_status);
>  	device_remove_file(dev, &dev_attr_usbip_sockfd);
>  	device_remove_file(dev, &dev_attr_usbip_debug);
> +	device_remove_file(dev, &dev_attr_usbip_acl);
>  }
>  
>  static void stub_shutdown_connection(struct usbip_device *ud)
> @@ -306,12 +367,14 @@ static struct stub_device *stub_device_alloc(struct usb_device *udev,
>  	sdev->ud.status		= SDEV_ST_AVAILABLE;
>  	spin_lock_init(&sdev->ud.lock);
>  	sdev->ud.tcp_socket	= NULL;
> +	sdev->acls = NULL;

This isn't really needed because we allocated sdev with kzalloc().


>  
>  	INIT_LIST_HEAD(&sdev->priv_init);
>  	INIT_LIST_HEAD(&sdev->priv_tx);
>  	INIT_LIST_HEAD(&sdev->priv_free);
>  	INIT_LIST_HEAD(&sdev->unlink_free);
>  	INIT_LIST_HEAD(&sdev->unlink_tx);
> +	spin_lock_init(&sdev->ip_lock);
>  	spin_lock_init(&sdev->priv_lock);
>  
>  	init_waitqueue_head(&sdev->tx_waitq);
> @@ -511,6 +574,9 @@ static void stub_disconnect(struct usb_interface *interface)
>  	usb_put_dev(sdev->udev);
>  	usb_put_intf(interface);
>  
> +	/* free ACL list */
> +	kfree(sdev->acls);
> +
>  	/* free sdev */
>  	busid_priv->sdev = NULL;
>  	stub_device_free(sdev);
> -- 
> 1.8.4
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
