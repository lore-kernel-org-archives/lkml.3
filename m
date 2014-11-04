Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaKDSOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 13:14:47 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:37614 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbaKDSOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:14:44 -0500
Date: Tue, 4 Nov 2014 11:14:33 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com
Subject: Re: [PATCH v5 7/7] tpm: create TPM 2.0 devices using own device class
Message-ID: <20141104181433.GA28387@obsidianresearch.com>
References: <1414832495-23609-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1414832495-23609-8-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141102213305.GB28519@obsidianresearch.com>
 <20141103054101.GA4795@intel.com>
 <20141103213826.GG8303@obsidianresearch.com>
 <1415101654.4115.22.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415101654.4115.22.camel@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 01:47:34PM +0200, Jarkko Sakkinen wrote:

> > > I used the class 'tpm' only for TPM 2.x because I didn't want to
> > > break the binary compatibility for TPM 1.x anyway. In ideal situtation
> > > both would be character devices inside the class 'tpm' and there would
> > > be sysfs attribute such as 'family' to mark the protocol to be used.
> > 
> > You can create the class without moving away from miscdev...
> > 
> > Not having the device creates way to much difference that has to be
> > supported, way too messy.
> 
> I have to admit that I'm not quite following here but I assume that
> you restated this below in more verbose way and this is basically the
> same argument :)

I mean, if we have a patch that does:

struct tpm_chip {
   struct device cdev;  // the class device
   struct device *pdev; // the 'platform' device chip is bound too

   struct device *dev = pdev; // Temporary Compatability
[+ device_register/etc/etc]

Then both cdev and pdev should always be valid. We should not have cdev
be valid for TPM2 and invalid for TPM1, that is just a big mess.

Just this change is perfectly safe, it creates the /sys/class/tpm/tpm0
directory, but doesn't change anything already existing

Then, a patch: go through and replace all uses of chip->dev with &chip->cdev in
90% of cases

Another patch: use chip->pdev for the handfull of the rest, and drop
dev entirely

Then a patch: Drop misc_register entirely, no compat stuff. Explain
clearly the resulting sysfs changes, CC the various people who monitor
the sysfs API, act on any feedback. I'm hoping it is an OK change.
[ If it is not OK then we can talk about using it only for TPM2 or
  whatever ]

> I think the current variable name "dev" is miss-leading. The
> use of "pdev" would document better the appropriate use for that
> field (i.e. for the most cases DON'T use it).

Yes, see above :)

> I think that would be a mess. The way things are done in this v5
> patch set is actually quite coherent and it does not break backwards
> compatibility because the "proper" device hierarchy is only used for
> TPM 2.0 devices.

I mean, just do something like this:

if (chip->id == 0)
   chip->cdev.devt = MKDEV(MISC_MAJOR, TPM_MINOR)
else
   chip->cdev.devt = [.. dynamic alloc_chrddev_region ..]

Very simple, keeps the major/minor for TPM0, moves the 'dev' file to
the new location in sysfs.

I can't find another example of this in the kernel, so I don't know
what the thinking is..

Jason
