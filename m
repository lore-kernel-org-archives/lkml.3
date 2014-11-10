Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbaKJSA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:00:26 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:54069 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbaKJSAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:00:25 -0500
Date: Mon, 10 Nov 2014 11:00:16 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com
Subject: Re: [PATCH v6 05/10] tpm: device class for tpm
Message-ID: <20141110180016.GB5296@obsidianresearch.com>
References: <1415623794-6090-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1415623794-6090-6-git-send-email-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415623794-6090-6-git-send-email-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 02:49:49PM +0200, Jarkko Sakkinen wrote:
  
> +static void tpm_dev_release(struct device *dev)
> +{
> +}
> +

These patches are so close to actually fixing many of the use-after-free
problems too :)

>  int tpm_dev_add_device(struct tpm_chip *chip)
>  {
>  	int rc;
>  
> -	chip->vendor.miscdev.fops = &tpm_fops;
> +	chip->dev.class = tpm_class;
> +	chip->dev.release = tpm_dev_release;
> +	chip->dev.parent = chip->pdev;
> +	dev_set_name(&chip->dev, chip->devname);
> +	rc = device_register(&chip->dev);

I think all of this should live in tpm-chip.c

I would also suggest using device_initialize during tpmm_alloc_chip
and device_add + cdev_add during tpm_register. That way the dev member
is always valid and we can immediately use put_device to do the free and
devm just does put_device.

>  void tpm_dev_del_device(struct tpm_chip *chip)
>  {
> -	if (chip->vendor.miscdev.name)
> -		misc_deregister(&chip->vendor.miscdev);
> +	if (get_device(&chip->dev) != NULL) {
> +		cdev_del(&chip->cdev);
> +		device_unregister(&chip->dev);
> +		put_device(&chip->dev);
> +	}

The get/put seems oddly placed - really the caller of del_device must
be holding the ref I don't see that del_device needs it..

Ultimately we want things so that when the ref count goes to 0 then
the chip will be freed - this means that get_device can never fail
since chip->dev will be deallocated memory.

> +struct class *tpm_class;
> +dev_t tpm_devt;

Also makes more sense to me in chip-chip

Jason
