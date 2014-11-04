Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbaKDLrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:47:53 -0500
Received: from mga03.intel.com ([134.134.136.65]:58648 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbaKDLru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:47:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,312,1413270000"; 
   d="scan'208";a="631069202"
Message-ID: <1415101654.4115.22.camel@linux.intel.com>
Subject: Re: [PATCH v5 7/7] tpm: create TPM 2.0 devices using own device
 class
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com
Date: Tue, 04 Nov 2014 13:47:34 +0200
In-Reply-To: <20141103213826.GG8303@obsidianresearch.com>
References: <1414832495-23609-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	 <1414832495-23609-8-git-send-email-jarkko.sakkinen@linux.intel.com>
	 <20141102213305.GB28519@obsidianresearch.com>
	 <20141103054101.GA4795@intel.com>
	 <20141103213826.GG8303@obsidianresearch.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 14:38 -0700, Jason Gunthorpe wrote:
> On Mon, Nov 03, 2014 at 07:41:01AM +0200, Jarkko Sakkinen wrote:
> 
> > I used the class 'tpm' only for TPM 2.x because I didn't want to
> > break the binary compatibility for TPM 1.x anyway. In ideal situtation
> > both would be character devices inside the class 'tpm' and there would
> > be sysfs attribute such as 'family' to mark the protocol to be used.
> 
> You can create the class without moving away from miscdev...
> 
> Not having the device creates way to much difference that has to be
> supported, way too messy.

I have to admit that I'm not quite following here but I assume that
you restated this below in more verbose way and this is basically the
same argument :)

> > > And considering the volume of changes it might be better to leave
> > > 'dev' as a pointer to the tpm class rather than try and tackle that in
> > > this giant patch..
> > 
> > Maybe, or maybe I could make the rename a separate patch?
> 
> Pointer then rename?
> 
> > It's fairly mechanical, just a matter of replacing string
> > "chip->dev" with "chip->pdev".
> 
> Not everyone should be replaced :|

I think the current variable name "dev" is miss-leading. The
use of "pdev" would document better the appropriate use for that
field (i.e. for the most cases DON'T use it).

> > > > +	chip->cdev.owner = chip->pdev->driver->owner;
> > > 
> > > Is that right? the cdev fops is in this module, not the driver's
> > > module..
> > 
> > tpm.ko defines the interface but TPM device driver module owns the
> > character device. I think this is right and similar logic is also
> > for example rtc_device_register().
> 
> Hmm, yes, I see that in rtc_dev_prepare - but I don't have time to
> figure out why that might be :)
> 
> On the surface, it doesn't seem to make sense: The cdev layer never
> calls into a function that goes to the chip module - all functions go
> to the fops in tpm.ko, and tmp.ko is (eventually) responsible for
> ensuring that ops never points to an unloaded module.
> 
> So why should it care what the driver module is??

Fully agreed, I think you got a point here. I think it makes sense
as a guideline to kind of "centralize" robustness to tpm.ko and
leave as little responsibility as possible to device drivers.

> > I could understand in the context of a misc device but don't really
> > when TPM 2.0 devices have their own device class. Using a 'tpm' class
> > would in all cases break non-udev systems because major number is no
> > longer 10 (misc).
> 
> I'm just saying it would be nice to force the major/minor to misc.tpm
> for tmp0.
> 
> No idea if that is OK or not.

I think that would be a mess. The way things are done in this v5
patch set is actually quite coherent and it does not break backwards
compatibility because the "proper" device hierarchy is only used for
TPM 2.0 devices.

I think the improvement for v6 would be to add a sysctl attribute
to disable legacy device hierarchy and sysfs attributes. If that
attribute is unset, the old misc hierarchy would be used for any
TPM version and TPM 1.0 devices would use existing sysfs attributes.

If the flag is set, then the new proper device hierarchy would be
used for any TPM device and we would have also chance to redefine
sysfs attributes.

This would add some legacy clutter to the stack but would be a
piss-off-free and non-ABI-breaking solution.

> Jason

PS. I feel that drivers/char/tpm is a like a desolated town. How 
many of the people currently marked as maintainers are actually
participating to the subsystem development let alone driving it?

This subsystem is increasingly important to us given that major
software platforms like Chrome OS make extensive use of it and
I've heard that even bug fixes have taken some times over a year
to get through. Does not look good at all.

/Jarkko


