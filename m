Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaJPQEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 12:04:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:54482 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbaJPQEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 12:04:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="401325072"
Date: Thu, 16 Oct 2014 18:03:58 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Greg KH <greg@kroah.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, josh.triplett@intel.com,
        christophe.ricard@gmail.com, will.c.arthur@intel.com,
        monty.wiseman@intel.com
Subject: Re: [PATCH v3 4/6] tpm: TPM 2.0 sysfs attributes
Message-ID: <20141016160358.GB12979@intel.com>
References: <1413372916-12091-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1413372916-12091-5-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141016093146.GA25070@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016093146.GA25070@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 11:31:46AM +0200, Greg KH wrote:
> On Wed, Oct 15, 2014 at 01:35:14PM +0200, Jarkko Sakkinen wrote:
> > +int tpm2_sysfs_add_device(struct tpm_chip *chip)
> > +{
> > +	struct pcr_bank *pcr_bank;
> > +	struct kobject *pcrs_kobj;
> > +	struct device *dev = chip->dev;
> > +	int rc;
> > +
> > +	rc = sysfs_create_group(&chip->vendor.miscdev.this_device->kobj,
> > +				&tpm_dev_group);
> > +	if (rc) {
> > +		dev_err(dev, "failed to create sysfs attributes, %d\n", rc);
> > +		return rc;
> > +	}
> 
> You just raced and created sysfs files _after_ userspace saw that your
> device was enabled.

Here the options are limited because misc_register already spawns
KOBJ_ADD. Not much to do unless we would wipe the current use of 
misc driver completely.

> 
> > +	pcrs_kobj = kobject_create_and_add("pcrs",
> > +					   &chip->vendor.miscdev.this_device->kobj);
> 
> Ick, no no no no.  Never create a kobject under a 'struct device'.  You
> just lost all libudev support for any attribute you created under here,
> not good at all.  Use a "real" device if you really want a sub-device,
> not a kobject.

Ack, will rework this.

> thanks,
> 
> greg k-h

/Jarkko
