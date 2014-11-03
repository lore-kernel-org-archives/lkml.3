Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239AbaKCFlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 00:41:11 -0500
Received: from mga03.intel.com ([134.134.136.65]:60801 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbaKCFlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 00:41:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,305,1413270000"; 
   d="scan'208";a="630116971"
Date: Mon, 3 Nov 2014 07:41:01 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com
Subject: Re: [PATCH v5 7/7] tpm: create TPM 2.0 devices using own device class
Message-ID: <20141103054101.GA4795@intel.com>
References: <1414832495-23609-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1414832495-23609-8-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141102213305.GB28519@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141102213305.GB28519@obsidianresearch.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2014 at 02:33:05PM -0700, Jason Gunthorpe wrote:
> On Sat, Nov 01, 2014 at 11:01:35AM +0200, Jarkko Sakkinen wrote:
> > Added own class for TPM devices that is used for TPM 2.0 and onwards.
> > For TPM1 old device structure is kept for backwards compatibility.
> > 
> > Each struct tpm_chip represents a character device that is associated
> > to the tpm device class.
> 
> I think we should hang back on this untill we can answer a few
> questions..
> 
> I certainly thing both TPM1 and TPM2 should create the class, at the
> worst only tpm2 uses it for the chardev?

I used the class 'tpm' only for TPM 2.x because I didn't want to
break the binary compatibility for TPM 1.x anyway. In ideal situtation
both would be character devices inside the class 'tpm' and there would
be sysfs attribute such as 'family' to mark the protocol to be used.

> 
> > @@ -63,7 +65,7 @@ static int tpm_open(struct inode *inode, struct file *file)
> >  	 * by the check of is_open variable, which is protected
> >  	 * by driver_lock. */
> >  	if (test_and_set_bit(0, &chip->is_open)) {
> > -		dev_dbg(chip->dev, "Another process owns this TPM\n");
> > +		dev_dbg(chip->pdev, "Another process owns this TPM\n");
> >  		return -EBUSY;
> 
> I actually think these are mostly wrong, and are part of why I think
> tpm1 should create the class too.
> 
> Except for the probe and remove function everything should log using
> the TPM device name (eg tpm0) and not the platform device name, so all
> of these debug statements should stay chip->dev...

I tend to agree but here applies my previous comment.

> And considering the volume of changes it might be better to leave
> 'dev' as a pointer to the tpm class rather than try and tackle that in
> this giant patch..

Maybe, or maybe I could make the rename a separate patch?

It's fairly mechanical, just a matter of replacing string
"chip->dev" with "chip->pdev".
> 
> > +static void tpm_dev_release(struct device *dev)
> > +{
> > +}
> 
> And all of this is upside down, the devm interm stuff should hold a
> get_device() on the struct device and the kfree should live here.

Agreed but didn't want diverge from TPM1 sequences (yet!).
I think FIXME comment might be appropriate.

> > +	chip->cdev.owner = chip->pdev->driver->owner;
> 
> Is that right? the cdev fops is in this module, not the driver's
> module..

tpm.ko defines the interface but TPM device driver module owns the
character device. I think this is right and similar logic is also
for example rtc_device_register().

> > +	rc = cdev_add(&chip->cdev, chip->dev.devt, 1);
> 
> Can we/should we re-use the misc dev minor number assigned to TPM for
> tpm0?
> 
> To me altering the dev major:minor  a far more visible change than
> moving the 'dev' file in sysfs. udev will handle the latter
> transparently, but the former will break non-udev systems..

I could understand in the context of a misc device but don't really
when TPM 2.0 devices have their own device class. Using a 'tpm' class
would in all cases break non-udev systems because major number is no
longer 10 (misc).

> Jason

/Jarkko
