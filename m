Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaIXTDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:03:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:5685 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbaIXTDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:03:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,590,1406617200"; 
   d="scan'208";a="608014662"
Date: Wed, 24 Sep 2014 22:02:34 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, Peter Huewe <peterhuewe@gmx.de>,
        Marcel Selhorst <tpmdd@selhorst.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 12/12] tpm: TPM2 sysfs attributes
Message-ID: <20140924190234.GB6801@intel.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1411549562-24242-13-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20140924171338.GG8898@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924171338.GG8898@obsidianresearch.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 11:13:38AM -0600, Jason Gunthorpe wrote:
> On Wed, Sep 24, 2014 at 12:06:02PM +0300, Jarkko Sakkinen wrote:
> > Added tpm2-sysfs.c that implements sysfs attributes for a TPM2
> > device.
> 
> You need to document in Documentation every new sysfs that is added.
> 
> The existing ones are not documented :(

This came up in Peters reply (you probably saw that).

https://www.kernel.org/doc/Documentation/ABI/stable/sysfs-class-tpm

> > +++ b/drivers/char/tpm/tpm-interface.c
> > @@ -899,6 +899,7 @@ void tpm_remove_hardware(struct device *dev)
> >  
> >  	tpm_chip_unregister(chip);
> >  
> > +
> >  	/* write it this way to be explicit (chip->dev == dev) */
> >  	put_device(chip->dev);
> >  }
> 
> Hunk does not belong in this patch

Ack (thanks).

> > diff --git a/drivers/char/tpm/tpm2-commands.c b/drivers/char/tpm/tpm2-commands.c
> > index a21dfd5..6365087 100644
> > +++ b/drivers/char/tpm/tpm2-commands.c
> > @@ -195,7 +195,7 @@ ssize_t tpm2_get_tpm_pt(struct device *dev, u32 property_id,  u32* value,
> >  	cmd.header.in = tpm2_get_tpm_pt_header;
> >  	cmd.params.tpm2_get_tpm_pt_in.cap_id =
> >  		cpu_to_be32(TPM2_CAP_TPM_PROPERTIES);
> > -	cmd.params.tpm2_get_tpm_pt_in.property_id = property_id;
> > +	cmd.params.tpm2_get_tpm_pt_in.property_id = cpu_to_be32(property_id);
> >  	cmd.params.tpm2_get_tpm_pt_in.property_cnt = cpu_to_be32(1);
> 
> Hunk does not belong in this patch

Ack (thanks).

> > +static ssize_t pcrs_show(struct device *dev, struct device_attribute *attr,
> > +			 char *buf)
> > +{
> 
> The pcrs file never conformed to the sysfs rules, if TPM2 is getting a
> whole new file set, I wouldn't mind seeing it not include the
> non-conformant ones. What do you think?

I think that it's better to put extra focus on these sysfs attributes in
first patch set because it's user space visible. What's wrong in the
current pcrs file?

> > +static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
> > +			 char *buf)
> > +{
> 
> Ditto.. The manfacturer number should probably be its own file

Maybe here would make sense to have three files:

- manufacturer
- firmware_1
- firmware_2

More or less following the name of the TPM properties in the
specification.

> > +static ssize_t durations_show(struct device *dev, struct device_attribute *attr,
> > +			      char *buf)
> > +{
> > +	struct tpm_chip *chip = dev_get_drvdata(dev);
> > +
> > +	if (chip->vendor.duration[TPM_LONG] == 0)
> > +		return 0;
> > +
> > +	return sprintf(buf, "%d %d %d [%s]\n",
> > +		       jiffies_to_usecs(chip->vendor.duration[TPM_SHORT]),
> > +		       jiffies_to_usecs(chip->vendor.duration[TPM_MEDIUM]),
> > +		       jiffies_to_usecs(chip->vendor.duration[TPM_LONG]),
> > +		       chip->vendor.duration_adjusted
> > +		       ? "adjusted" : "original");
> > +}
> > +static DEVICE_ATTR_RO(durations);
> 
> Seem useless since the durations are constant, drop it?
> 
> > +static ssize_t timeouts_show(struct device *dev, struct device_attribute *attr,
> > +			     char *buf)
> > +{
> > +	struct tpm_chip *chip = dev_get_drvdata(dev);
> > +
> > +	return sprintf(buf, "%d %d %d %d [%s]\n",
> > +		       jiffies_to_usecs(chip->vendor.timeout_a),
> > +		       jiffies_to_usecs(chip->vendor.timeout_b),
> > +		       jiffies_to_usecs(chip->vendor.timeout_c),
> > +		       jiffies_to_usecs(chip->vendor.timeout_d),
> > +		       chip->vendor.timeout_adjusted
> > +		       ? "adjusted" : "original");
> > +}
> > +static DEVICE_ATTR_RO(timeouts);
> 
> Ditto
> 
> > +static ssize_t version_show(struct device *dev, struct device_attribute *attr,
> > +			   char *buf)
> > +{
> > +	char *str = buf;
> > +
> > +	str += sprintf(str, "2.0\n");
> > +
> > +	return str - buf;
> > +}
> > +
> > +static DEVICE_ATTR_RO(version);
> > +
> > +
> > +static ssize_t tpm2_show(struct device *dev, struct device_attribute *attr,
> > +			 char *buf)
> > +{
> > +	struct tpm_chip *chip = dev_get_drvdata(dev);
> > +
> > +	return sprintf(buf, "%d\n", chip->tpm2);
> > +}
> > +static DEVICE_ATTR_RO(tpm2);
> 
> Two things for the same report? Drop one?
> 
> Also, I think some thought is needed for the char interface - some
> kind of ioctl to enter TPM2 mode and EINVAL access until that is done?
> 
> Finally, this is in the wrong place in sysfs, I suspect it should be
> attached to the char device node, not the platform device node? We
> should at least investigate this...

This was forgotten. Should not be here at all. Instead we have the
variable 'version' to state specification family and level.

I did not fully understand the comment about tpm2 flag. Why driver
cannot set it when it initializes the device like with this based
on value of the STS3?

> > +struct tpm2_permanent {
> > +	unsigned int owner_auth_set		: 1;
> > +	unsigned int endorsement_auth_set	: 1;
> > +	unsigned int lockout_auth_set		: 1;
> > +	unsigned int reserved1			: 5;
> > +	unsigned int disable_clear		: 1;
> > +	unsigned int in_lockout			: 1;
> > +	unsigned int tpm_generated_eps		: 1;
> > +	unsigned int reserved2			: 21;
> > +};
> > +
> > +struct tpm2_startup_clear {
> > +	unsigned int ph_enable			: 1;
> > +	unsigned int sh_enable			: 1;
> > +	unsigned int eh_enable			: 1;
> > +	unsigned int ph_enable_nv		: 1;
> > +	unsigned int reserved			: 27;
> > +	unsigned int orderly			: 1;
> > +};
> 
> This idea is not portable, you cannot use bitfields to index bits in a
> word like this. Please use constants defined with BIT(xx)

Thanks, I'll change this.

> Next posting can you include a github link? Thanks

Yup sure. I do everything for v2 in tpm2-v1 by adding fixes on top of 
these patches. When things look good there I'll create a new branch
tpm2-v2 and prepare the next patch set.

> Jason

/Jarkko
