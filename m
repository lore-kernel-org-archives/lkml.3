Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbaIXQuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:50:01 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:42579 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbaIXQt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:49:58 -0400
Date: Wed, 24 Sep 2014 10:49:49 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, Peter Huewe <peterhuewe@gmx.de>,
        Marcel Selhorst <tpmdd@selhorst.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 01/12] tpm: prepare TPM driver for adding TPM2 support
Message-ID: <20140924164949.GC8898@obsidianresearch.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1411549562-24242-2-git-send-email-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411549562-24242-2-git-send-email-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 12:05:51PM +0300, Jarkko Sakkinen wrote:
> * Separated allocation and registeration into two functions:
>   * tpm_chip_alloc()
>   * tpm_chip_register()

Okay, this is a nice start!

I had intended tpm-interface.c to hold these 'chip' functions and the
other cmd related functions to be moved out into tpm-cmds.c (or
tpm1-cmds?), which is more symmetrical with what you are doing with
tpm2-cmds. Does that seem reasonable?

It doesn't make sense to leave some chip related stuff in
tpm-interface mixed with cmd stuff, I'd prefer to see a clean split if
you are going to split them.

> +struct tpm_chip *tpm_chip_alloc(struct device *dev,
> +                               const struct tpm_class_ops *ops)
> +{

I want to see a clear description of what the unwind procedures are
for each step using the new API, and kdoc on all the new API functions
drivers are expected to use.

> +int tpm_chip_register(struct tpm_chip *chip)
> +{
> +	int rc;

All the common startup functions need to be done here too: get
timeouts, self test, etc.

> +	rc = tpm_dev_add_device(chip);
> +	if (rc)
> +		return rc;
> +
> +	rc = tpm_sysfs_add_device(chip);
> +	if (rc)
> +		goto del_misc;
> +
> +	rc = tpm_add_ppi(&chip->dev->kobj);
> +	if (rc)
> +		goto del_sysfs;
> +
> +	if (!chip->tpm2)
> +		chip->bios_dir = tpm_bios_log_setup(chip->devname);

What about failure of tpm_bios_log_setup?

>  /*
>   * Called from tpm_<specific>.c probe function only for devices
>   * the driver has determined it should claim.  Prior to calling
> @@ -1081,61 +1019,19 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
>  				       const struct tpm_class_ops *ops)
>  {
>  	struct tpm_chip *chip;
> +	int rc;
>  
> -	/* Driver specific per-device data */
> -	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
> -
> -	if (chip == NULL)
> +	chip = tpm_chip_alloc(dev, ops);
> +	if (!chip)
>  		return NULL;

I think tpm_chip_alloc should return an ERR_PTR..

> -	mutex_init(&chip->tpm_mutex);
> -	INIT_LIST_HEAD(&chip->list);
> -
> -	chip->ops = ops;
> -	chip->dev_num = find_first_zero_bit(dev_mask, TPM_NUM_DEVICES);
> -
> -	if (chip->dev_num >= TPM_NUM_DEVICES) {
> -		dev_err(dev, "No available tpm device numbers\n");
> -		goto out_free;
> +	rc = tpm_chip_register(chip);
> +	if (rc) {
> +		put_device(chip->dev);
> +		kfree(chip);

No, open coding this is not a good unwind, and this is not correct
anyhow, it looks like it will double free chip...

This is where things got stuck for me too, the unwind is where all the
problems are and I think the solution is to make the alloc paths
completely different between new and old.

We really want tpmm_chip_alloc for the new style path (so drivers have
no unwind) and the old style path .. I don't know what is correct
there, but the safest thing is to stay exactly the same.

Also, please split this patch into moving stuff into tmp1-cmds.c and
then patching to add functionality.

Jason
