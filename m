Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbaIXRNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:13:48 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:47724 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328AbaIXRNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:13:46 -0400
Date: Wed, 24 Sep 2014 11:13:38 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, Peter Huewe <peterhuewe@gmx.de>,
        Marcel Selhorst <tpmdd@selhorst.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 12/12] tpm: TPM2 sysfs attributes
Message-ID: <20140924171338.GG8898@obsidianresearch.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1411549562-24242-13-git-send-email-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411549562-24242-13-git-send-email-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 12:06:02PM +0300, Jarkko Sakkinen wrote:
> Added tpm2-sysfs.c that implements sysfs attributes for a TPM2
> device.

You need to document in Documentation every new sysfs that is added.

The existing ones are not documented :(

> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -899,6 +899,7 @@ void tpm_remove_hardware(struct device *dev)
>  
>  	tpm_chip_unregister(chip);
>  
> +
>  	/* write it this way to be explicit (chip->dev == dev) */
>  	put_device(chip->dev);
>  }

Hunk does not belong in this patch

> diff --git a/drivers/char/tpm/tpm2-commands.c b/drivers/char/tpm/tpm2-commands.c
> index a21dfd5..6365087 100644
> +++ b/drivers/char/tpm/tpm2-commands.c
> @@ -195,7 +195,7 @@ ssize_t tpm2_get_tpm_pt(struct device *dev, u32 property_id,  u32* value,
>  	cmd.header.in = tpm2_get_tpm_pt_header;
>  	cmd.params.tpm2_get_tpm_pt_in.cap_id =
>  		cpu_to_be32(TPM2_CAP_TPM_PROPERTIES);
> -	cmd.params.tpm2_get_tpm_pt_in.property_id = property_id;
> +	cmd.params.tpm2_get_tpm_pt_in.property_id = cpu_to_be32(property_id);
>  	cmd.params.tpm2_get_tpm_pt_in.property_cnt = cpu_to_be32(1);

Hunk does not belong in this patch

> +static ssize_t pcrs_show(struct device *dev, struct device_attribute *attr,
> +			 char *buf)
> +{

The pcrs file never conformed to the sysfs rules, if TPM2 is getting a
whole new file set, I wouldn't mind seeing it not include the
non-conformant ones. What do you think?

> +static ssize_t caps_show(struct device *dev, struct device_attribute *attr,
> +			 char *buf)
> +{

Ditto.. The manfacturer number should probably be its own file

> +static ssize_t durations_show(struct device *dev, struct device_attribute *attr,
> +			      char *buf)
> +{
> +	struct tpm_chip *chip = dev_get_drvdata(dev);
> +
> +	if (chip->vendor.duration[TPM_LONG] == 0)
> +		return 0;
> +
> +	return sprintf(buf, "%d %d %d [%s]\n",
> +		       jiffies_to_usecs(chip->vendor.duration[TPM_SHORT]),
> +		       jiffies_to_usecs(chip->vendor.duration[TPM_MEDIUM]),
> +		       jiffies_to_usecs(chip->vendor.duration[TPM_LONG]),
> +		       chip->vendor.duration_adjusted
> +		       ? "adjusted" : "original");
> +}
> +static DEVICE_ATTR_RO(durations);

Seem useless since the durations are constant, drop it?

> +static ssize_t timeouts_show(struct device *dev, struct device_attribute *attr,
> +			     char *buf)
> +{
> +	struct tpm_chip *chip = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%d %d %d %d [%s]\n",
> +		       jiffies_to_usecs(chip->vendor.timeout_a),
> +		       jiffies_to_usecs(chip->vendor.timeout_b),
> +		       jiffies_to_usecs(chip->vendor.timeout_c),
> +		       jiffies_to_usecs(chip->vendor.timeout_d),
> +		       chip->vendor.timeout_adjusted
> +		       ? "adjusted" : "original");
> +}
> +static DEVICE_ATTR_RO(timeouts);

Ditto

> +static ssize_t version_show(struct device *dev, struct device_attribute *attr,
> +			   char *buf)
> +{
> +	char *str = buf;
> +
> +	str += sprintf(str, "2.0\n");
> +
> +	return str - buf;
> +}
> +
> +static DEVICE_ATTR_RO(version);
> +
> +
> +static ssize_t tpm2_show(struct device *dev, struct device_attribute *attr,
> +			 char *buf)
> +{
> +	struct tpm_chip *chip = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%d\n", chip->tpm2);
> +}
> +static DEVICE_ATTR_RO(tpm2);

Two things for the same report? Drop one?

Also, I think some thought is needed for the char interface - some
kind of ioctl to enter TPM2 mode and EINVAL access until that is done?

Finally, this is in the wrong place in sysfs, I suspect it should be
attached to the char device node, not the platform device node? We
should at least investigate this...

> +struct tpm2_permanent {
> +	unsigned int owner_auth_set		: 1;
> +	unsigned int endorsement_auth_set	: 1;
> +	unsigned int lockout_auth_set		: 1;
> +	unsigned int reserved1			: 5;
> +	unsigned int disable_clear		: 1;
> +	unsigned int in_lockout			: 1;
> +	unsigned int tpm_generated_eps		: 1;
> +	unsigned int reserved2			: 21;
> +};
> +
> +struct tpm2_startup_clear {
> +	unsigned int ph_enable			: 1;
> +	unsigned int sh_enable			: 1;
> +	unsigned int eh_enable			: 1;
> +	unsigned int ph_enable_nv		: 1;
> +	unsigned int reserved			: 27;
> +	unsigned int orderly			: 1;
> +};

This idea is not portable, you cannot use bitfields to index bits in a
word like this. Please use constants defined with BIT(xx)

Next posting can you include a github link? Thanks

Jason
