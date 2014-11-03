Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaKCVik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:38:40 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:53061 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbaKCVij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:38:39 -0500
Date: Mon, 3 Nov 2014 14:38:26 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com
Subject: Re: [PATCH v5 7/7] tpm: create TPM 2.0 devices using own device class
Message-ID: <20141103213826.GG8303@obsidianresearch.com>
References: <1414832495-23609-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1414832495-23609-8-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141102213305.GB28519@obsidianresearch.com>
 <20141103054101.GA4795@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141103054101.GA4795@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 07:41:01AM +0200, Jarkko Sakkinen wrote:

> I used the class 'tpm' only for TPM 2.x because I didn't want to
> break the binary compatibility for TPM 1.x anyway. In ideal situtation
> both would be character devices inside the class 'tpm' and there would
> be sysfs attribute such as 'family' to mark the protocol to be used.

You can create the class without moving away from miscdev...

Not having the device creates way to much difference that has to be
supported, way too messy.

> > And considering the volume of changes it might be better to leave
> > 'dev' as a pointer to the tpm class rather than try and tackle that in
> > this giant patch..
> 
> Maybe, or maybe I could make the rename a separate patch?

Pointer then rename?

> It's fairly mechanical, just a matter of replacing string
> "chip->dev" with "chip->pdev".

Not everyone should be replaced :|

> > > +	chip->cdev.owner = chip->pdev->driver->owner;
> > 
> > Is that right? the cdev fops is in this module, not the driver's
> > module..
> 
> tpm.ko defines the interface but TPM device driver module owns the
> character device. I think this is right and similar logic is also
> for example rtc_device_register().

Hmm, yes, I see that in rtc_dev_prepare - but I don't have time to
figure out why that might be :)

On the surface, it doesn't seem to make sense: The cdev layer never
calls into a function that goes to the chip module - all functions go
to the fops in tpm.ko, and tmp.ko is (eventually) responsible for
ensuring that ops never points to an unloaded module.

So why should it care what the driver module is??

> I could understand in the context of a misc device but don't really
> when TPM 2.0 devices have their own device class. Using a 'tpm' class
> would in all cases break non-udev systems because major number is no
> longer 10 (misc).

I'm just saying it would be nice to force the major/minor to misc.tpm
for tmp0.

No idea if that is OK or not.

Jason
