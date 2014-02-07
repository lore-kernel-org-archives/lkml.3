Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbaBGXQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 18:16:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59950 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaBGXQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 18:16:08 -0500
Date: Fri, 7 Feb 2014 15:17:18 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH V4 1/1] Drivers: hv: Implement the file copy service
Message-ID: <20140207231718.GA16221@kroah.com>
References: <1390355033-16008-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390355033-16008-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 05:43:53PM -0800, K. Y. Srinivasan wrote:
> +/*
> + * Create a char device that can support read/write for passing
> + * the payload.
> + */
> +static struct cdev fcopy_cdev;
> +static struct class *cl;
> +static struct device *sysfs_dev;

Why not just be a misc device, you only want 1 minor number for a char
device:

> +static int fcopy_dev_init(void)
> +{
> +	int result;
> +
> +	result = alloc_chrdev_region(&fcopy_dev, 1, 1, "hv_fcopy");

See, one minor.

> +	if (result < 0) {
> +		pr_err("Cannot get major number\n");
> +		return result;
> +	}
> +
> +	cl = class_create(THIS_MODULE, "chardev");

That's a _really_ generic name, come on, you know better than that.

> +	if (IS_ERR(cl)) {
> +		pr_err("Error creating fcopy class.\n");

Your error string is wrong :(

> +		result = PTR_ERR(cl);
> +		goto err_unregister;
> +	}
> +
> +	sysfs_dev = device_create(cl, NULL, fcopy_dev, "%s", "hv_fcopy");

A device at the root of sysfs?  No, you have a bus to hang devices off
of, use that.  What do you need this device for anyway?

> +	if (IS_ERR(sysfs_dev)) {
> +		pr_err("Device creation failed\n");
> +		result = PTR_ERR(cl);
> +		goto err_destroy_class;
> +	}
> +
> +	cdev_init(&fcopy_cdev, &fcopy_fops);
> +	fcopy_cdev.owner = THIS_MODULE;
> +	fcopy_cdev.ops = &fcopy_fops;
> +
> +	result = cdev_add(&fcopy_cdev, fcopy_dev, 1);

Ah, to get udev to pay attention to the char device, no, just use a misc
device, should make this whole code a lot simpler and more "obvious" as
to what you want/need.

> +	if (result) {
> +		pr_err("Cannot cdev_add\n");
> +		goto err_destroy_device;
> +	}
> +	return result;
> +
> +err_destroy_device:
> +	device_destroy(cl, fcopy_dev);
> +err_destroy_class:
> +	class_destroy(cl);
> +err_unregister:
> +	unregister_chrdev_region(fcopy_dev, 1);
> +	return result;


Ugh, I hate the cdev interface, one of these days I'll fix it up, it's
so unwieldy...

> +static void fcopy_dev_deinit(void)
> +{
> +	/*
> +	 * first kill the daemon.
> +	 */
> +	if (dtp != NULL)
> +		send_sig(SIGKILL, dtp, 0);

We kill userspace daemon's from the kernel?  That's a recipe for
disaster...

Why?  What does it matter here if the daemon keeps running, it should
fail gracefully if the character device is removed, right?  If not, that
needs to be fixed anyway.

thanks,

greg k-h

