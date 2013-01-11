Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab3AKRhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 12:37:10 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45767 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab3AKRhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 12:37:08 -0500
Date: Fri, 11 Jan 2013 12:36:52 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Olaf Hering <olaf@aepfle.de>, Jens Axboe <axboe@kernel.dk>,
        xen-devel <xen-devel@lists.xen.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen-blkback: do not leak mode property
Message-ID: <20130111173652.GB26287@phenom.dumpdata.com>
References: <50D2F6FF02000078000B1BC5@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D2F6FF02000078000B1BC5@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 10:31:11AM +0000, Jan Beulich wrote:
> "be->mode" is obtained from xenbus_read(), which does a kmalloc() for
> the message body. The short string is never released, so do it along
> with freeing "be" itself, and make sure the string isn't kept when
> backend_changed() doesn't complete successfully (which made it
> desirable to slightly re-structure that function, so that the error
> cleanup can be done in one place).

applied.
> 
> Reported-by: Olaf Hering <olaf@aepfle.de>
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 
> ---
>  drivers/block/xen-blkback/xenbus.c |   49 ++++++++++++++++++-------------------
>  1 file changed, 24 insertions(+), 25 deletions(-)
> 
> --- 3.7/drivers/block/xen-blkback/xenbus.c
> +++ 3.7-xen-blkback-mode-leak/drivers/block/xen-blkback/xenbus.c
> @@ -366,6 +366,7 @@ static int xen_blkbk_remove(struct xenbu
>  		be->blkif = NULL;
>  	}
>  
> +	kfree(be->mode);
>  	kfree(be);
>  	dev_set_drvdata(&dev->dev, NULL);
>  	return 0;
> @@ -501,6 +502,7 @@ static void backend_changed(struct xenbu
>  		= container_of(watch, struct backend_info, backend_watch);
>  	struct xenbus_device *dev = be->dev;
>  	int cdrom = 0;
> +	unsigned long handle;
>  	char *device_type;
>  
>  	DPRINTK("");
> @@ -520,10 +522,10 @@ static void backend_changed(struct xenbu
>  		return;
>  	}
>  
> -	if ((be->major || be->minor) &&
> -	    ((be->major != major) || (be->minor != minor))) {
> -		pr_warn(DRV_PFX "changing physical device (from %x:%x to %x:%x) not supported.\n",
> -			be->major, be->minor, major, minor);
> +	if (be->major | be->minor) {
> +		if (be->major != major || be->minor != minor)
> +			pr_warn(DRV_PFX "changing physical device (from %x:%x to %x:%x) not supported.\n",
> +				be->major, be->minor, major, minor);
>  		return;
>  	}
>  
> @@ -541,36 +543,33 @@ static void backend_changed(struct xenbu
>  		kfree(device_type);
>  	}
>  
> -	if (be->major == 0 && be->minor == 0) {
> -		/* Front end dir is a number, which is used as the handle. */
> +	/* Front end dir is a number, which is used as the handle. */
> +	err = strict_strtoul(strrchr(dev->otherend, '/') + 1, 0, &handle);
> +	if (err)
> +		return;
>  
> -		char *p = strrchr(dev->otherend, '/') + 1;
> -		long handle;
> -		err = strict_strtoul(p, 0, &handle);
> -		if (err)
> -			return;
> +	be->major = major;
> +	be->minor = minor;
>  
> -		be->major = major;
> -		be->minor = minor;
> -
> -		err = xen_vbd_create(be->blkif, handle, major, minor,
> -				 (NULL == strchr(be->mode, 'w')), cdrom);
> -		if (err) {
> -			be->major = 0;
> -			be->minor = 0;
> -			xenbus_dev_fatal(dev, err, "creating vbd structure");
> -			return;
> -		}
> +	err = xen_vbd_create(be->blkif, handle, major, minor,
> +			     !strchr(be->mode, 'w'), cdrom);
>  
> +	if (err)
> +		xenbus_dev_fatal(dev, err, "creating vbd structure");
> +	else {
>  		err = xenvbd_sysfs_addif(dev);
>  		if (err) {
>  			xen_vbd_free(&be->blkif->vbd);
> -			be->major = 0;
> -			be->minor = 0;
>  			xenbus_dev_fatal(dev, err, "creating sysfs entries");
> -			return;
>  		}
> +	}
>  
> +	if (err) {
> +		kfree(be->mode);
> +		be->mode = NULL;
> +		be->major = 0;
> +		be->minor = 0;
> +	} else {
>  		/* We're potentially connected now */
>  		xen_update_blkif_status(be->blkif);
>  	}
> 
> 
> 

> xen-blkback: do not leak mode property
> 
> "be->mode" is obtained from xenbus_read(), which does a kmalloc() for
> the message body. The short string is never released, so do it along
> with freeing "be" itself, and make sure the string isn't kept when
> backend_changed() doesn't complete successfully (which made it
> desirable to slightly re-structure that function, so that the error
> cleanup can be done in one place).
> 
> Reported-by: Olaf Hering <olaf@aepfle.de>
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 
> ---
>  drivers/block/xen-blkback/xenbus.c |   49 ++++++++++++++++++-------------------
>  1 file changed, 24 insertions(+), 25 deletions(-)
> 
> --- 3.7/drivers/block/xen-blkback/xenbus.c
> +++ 3.7-xen-blkback-mode-leak/drivers/block/xen-blkback/xenbus.c
> @@ -366,6 +366,7 @@ static int xen_blkbk_remove(struct xenbu
>  		be->blkif = NULL;
>  	}
>  
> +	kfree(be->mode);
>  	kfree(be);
>  	dev_set_drvdata(&dev->dev, NULL);
>  	return 0;
> @@ -501,6 +502,7 @@ static void backend_changed(struct xenbu
>  		= container_of(watch, struct backend_info, backend_watch);
>  	struct xenbus_device *dev = be->dev;
>  	int cdrom = 0;
> +	unsigned long handle;
>  	char *device_type;
>  
>  	DPRINTK("");
> @@ -520,10 +522,10 @@ static void backend_changed(struct xenbu
>  		return;
>  	}
>  
> -	if ((be->major || be->minor) &&
> -	    ((be->major != major) || (be->minor != minor))) {
> -		pr_warn(DRV_PFX "changing physical device (from %x:%x to %x:%x) not supported.\n",
> -			be->major, be->minor, major, minor);
> +	if (be->major | be->minor) {
> +		if (be->major != major || be->minor != minor)
> +			pr_warn(DRV_PFX "changing physical device (from %x:%x to %x:%x) not supported.\n",
> +				be->major, be->minor, major, minor);
>  		return;
>  	}
>  
> @@ -541,36 +543,33 @@ static void backend_changed(struct xenbu
>  		kfree(device_type);
>  	}
>  
> -	if (be->major == 0 && be->minor == 0) {
> -		/* Front end dir is a number, which is used as the handle. */
> +	/* Front end dir is a number, which is used as the handle. */
> +	err = strict_strtoul(strrchr(dev->otherend, '/') + 1, 0, &handle);
> +	if (err)
> +		return;
>  
> -		char *p = strrchr(dev->otherend, '/') + 1;
> -		long handle;
> -		err = strict_strtoul(p, 0, &handle);
> -		if (err)
> -			return;
> +	be->major = major;
> +	be->minor = minor;
>  
> -		be->major = major;
> -		be->minor = minor;
> -
> -		err = xen_vbd_create(be->blkif, handle, major, minor,
> -				 (NULL == strchr(be->mode, 'w')), cdrom);
> -		if (err) {
> -			be->major = 0;
> -			be->minor = 0;
> -			xenbus_dev_fatal(dev, err, "creating vbd structure");
> -			return;
> -		}
> +	err = xen_vbd_create(be->blkif, handle, major, minor,
> +			     !strchr(be->mode, 'w'), cdrom);
>  
> +	if (err)
> +		xenbus_dev_fatal(dev, err, "creating vbd structure");
> +	else {
>  		err = xenvbd_sysfs_addif(dev);
>  		if (err) {
>  			xen_vbd_free(&be->blkif->vbd);
> -			be->major = 0;
> -			be->minor = 0;
>  			xenbus_dev_fatal(dev, err, "creating sysfs entries");
> -			return;
>  		}
> +	}
>  
> +	if (err) {
> +		kfree(be->mode);
> +		be->mode = NULL;
> +		be->major = 0;
> +		be->minor = 0;
> +	} else {
>  		/* We're potentially connected now */
>  		xen_update_blkif_status(be->blkif);
>  	}

