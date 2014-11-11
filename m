Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbaKKIXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:23:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:47878 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbaKKIVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:21:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,359,1413270000"; 
   d="scan'208";a="630006860"
Date: Tue, 11 Nov 2014 10:20:48 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com
Subject: Re: [PATCH v6 05/10] tpm: device class for tpm
Message-ID: <20141111082048.GB7088@intel.com>
References: <1415623794-6090-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1415623794-6090-6-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141110180016.GB5296@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110180016.GB5296@obsidianresearch.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 11:00:16AM -0700, Jason Gunthorpe wrote:
> On Mon, Nov 10, 2014 at 02:49:49PM +0200, Jarkko Sakkinen wrote:
>   
> > +static void tpm_dev_release(struct device *dev)
> > +{
> > +}
> > +
> 
> These patches are so close to actually fixing many of the use-after-free
> problems too :)

Excellent!

> >  int tpm_dev_add_device(struct tpm_chip *chip)
> >  {
> >  	int rc;
> >  
> > -	chip->vendor.miscdev.fops = &tpm_fops;
> > +	chip->dev.class = tpm_class;
> > +	chip->dev.release = tpm_dev_release;
> > +	chip->dev.parent = chip->pdev;
> > +	dev_set_name(&chip->dev, chip->devname);
> > +	rc = device_register(&chip->dev);
> 
> I think all of this should live in tpm-chip.c
> 
> I would also suggest using device_initialize during tpmm_alloc_chip
> and device_add + cdev_add during tpm_register. That way the dev member
> is always valid and we can immediately use put_device to do the free and
> devm just does put_device.

Right. Makes sense. I'll do this change.

> >  void tpm_dev_del_device(struct tpm_chip *chip)
> >  {
> > -	if (chip->vendor.miscdev.name)
> > -		misc_deregister(&chip->vendor.miscdev);
> > +	if (get_device(&chip->dev) != NULL) {
> > +		cdev_del(&chip->cdev);
> > +		device_unregister(&chip->dev);
> > +		put_device(&chip->dev);
> > +	}
> 
> The get/put seems oddly placed - really the caller of del_device must
> be holding the ref I don't see that del_device needs it..

I checked from the source code and what you say is corrrect.

> Ultimately we want things so that when the ref count goes to 0 then
> the chip will be freed - this means that get_device can never fail
> since chip->dev will be deallocated memory.

This is again something that I acknowledge but did not want to bake into
patch set.

> > +struct class *tpm_class;
> > +dev_t tpm_devt;
> 
> Also makes more sense to me in chip-chip

Ack.

> Jason

/Jarkko
