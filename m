Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbaJGWet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 18:34:49 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:56282 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbaJGWes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 18:34:48 -0400
Date: Tue, 7 Oct 2014 16:34:42 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>, linux-api@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH v2 2/7] tpm: two-phase chip management
 functions
Message-ID: <20141007223442.GA3014@obsidianresearch.com>
References: <1412701277-27794-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1412701277-27794-3-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141007175017.GA10432@obsidianresearch.com>
 <20141007222814.GA7262@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007222814.GA7262@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 01:28:14AM +0300, Jarkko Sakkinen wrote:

> > > @@ -714,15 +709,10 @@ static int tpm_tis_i2c_remove(struct i2c_client *client)
> > >  	struct tpm_chip *chip = tpm_dev.chip;
> > >  	release_locality(chip, chip->vendor.locality, 1);
> > >  
> > > -	/* close file handles */
> > > -	tpm_dev_vendor_release(chip);
> > > -
> > >  	/* remove hardware */
> > >  	tpm_remove_hardware(chip->dev);
> > 
> > Wrong ordering here, tpm_remove_hardware should always be first -
> > drivers should not tear down internal state before calling it, so
> > release_locality should be second.
> > 
> > Noting that since we use devm the kfree will not happen until
> > remove returns, so the chip pointer is still valid.
> 
> Should I fix this ordering? I was thinking to focus putting proper
> patterns in place only in tpm_tis and tpm_crb because they are the
> that I'm able to test easily and then they can work as guideline for
> other drivers.

I think since this patch is already touching this function there is
no reason not to make it be correct (especially since it was noticed)

The rest can wait till we globally replace tpm_remove_hardware with
tpm_unregister - at that time the ordering can be audited and
checked.

Then the drivers will be clean and the core can finally be fixed.

Jason
