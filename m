Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbaJWHYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 03:24:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:65050 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbaJWHYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 03:24:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,774,1406617200"; 
   d="scan'208";a="623792900"
Date: Thu, 23 Oct 2014 10:22:52 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, josh.triplett@intel.com,
        christophe.ricard@gmail.com, jason.gunthorpe@obsidianresearch.com
Subject: Re: [PATCH v1 2/3] tpm: two-phase chip management functions
Message-ID: <20141023072252.GA5188@intel.com>
References: <1413995036-22497-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1413995036-22497-3-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141022171603.GC12775@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022171603.GC12775@obsidianresearch.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 11:16:03AM -0600, Jason Gunthorpe wrote:
> On Wed, Oct 22, 2014 at 07:23:55PM +0300, Jarkko Sakkinen wrote:
> > tpm_register_hardware() and tpm_remove_hardware() are called often
> > before initializing the device. This is wrong order since it could
> > be that main TPM driver needs a fully initialized chip to be able to
> > do its job. For example, now it is impossible to move common startup
> > functions such as tpm_do_selftest() to tpm_register_hardware().
>  
> > Added tpm_chip_alloc() and tpm_chip_register() where tpm_chip_alloc()
> 
> It is called tpmm_chip_alloc() in this version..
> 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> Reviewed-By: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> 
> Looks fine, if you have to spin this again you can incorporate the
> nits.

Thanks for the review! I'll try to incorporate most (if not all of
them). I was going to comment some of the points you made but they
would have mostly been "ACK".

> > +
> > +static DECLARE_BITMAP(dev_mask, TPM_NUM_DEVICES);
> 
> Not for this patch, but while this area of code is being looked at
> this should probably be an IDR/IDA like other subsytems?

Yes, it should use IDR. I'll put this into my backlog but don't 
include into this patch set.

> > +		if (try_module_get(pos->dev->driver->owner)) {
> > +			chip = pos;
> > +			break;
> > +		}
> 
> Not for this patch, this module stuff should be wiped in favor of chip->ops
> locking.

Definitely, horrible stuff, putting into my backlog (kref + mutex
should be a better solution).

> > +static void tpmm_chip_remove(void *data)
> > +{
> > +	struct tpm_chip *chip = (struct tpm_chip *) data;
> > +	dev_dbg(chip->dev, "%s\n", __func__);
> 
> This print is silent in the default compile, right?

Forgotten clutter, removing it, thanks.

> > +	chip->dev_num = find_first_zero_bit(dev_mask, TPM_NUM_DEVICES);
> [..]
> > +	set_bit(chip->dev_num, dev_mask);
> 
> Not for this patch but somehow there is no locking for dev_mask
> here. I guess it should use the driver_lock spinlock?

I'll add it anyway, thanks.

> > +	chip->bios_dir = tpm_bios_log_setup(chip->devname);
> 
> Not for this patch, but tpm_bios_log_setup can return NULL if
> securityfs setup fails.

Easy to fix so I'll just fix it.

> > diff --git a/drivers/char/tpm/tpm_atmel.c b/drivers/char/tpm/tpm_atmel.c
> > index 6069d13..8e2576a 100644
> > +++ b/drivers/char/tpm/tpm_atmel.c
> > @@ -138,11 +138,11 @@ static void atml_plat_remove(void)
> >  	struct tpm_chip *chip = dev_get_drvdata(&pdev->dev);
> >  
> >  	if (chip) {
> > +		tpm_chip_unregister(chip);
> >  		if (chip->vendor.have_region)
> >  			atmel_release_region(chip->vendor.base,
> >  					     chip->vendor.region_size);
> >  		atmel_put_base_addr(chip->vendor.iobase);
> > -		tpm_remove_hardware(chip->dev);
> >  		platform_device_unregister(pdev);
> 
> Missed this before, the Atmel driver is the same as the TIS driver in
> force mode, ie it isn't going through the driver APIs, but instead
> force creating platform devices. Same comment as for TIS - I'm not
> sure devm works properly like this.
> 
> I guess just add the same comment as for TIS?

Yup, makes sense.

> > diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
> > index 472af4b..6f00bc3 100644
> > +++ b/drivers/char/tpm/tpm_i2c_infineon.c
> > @@ -581,10 +581,9 @@ static int tpm_tis_i2c_init(struct device *dev)
> >  	int rc = 0;
> >  	struct tpm_chip *chip;
> >  
> > -	chip = tpm_register_hardware(dev, &tpm_tis_i2c);
> > -	if (!chip) {
> > -		dev_err(dev, "could not register hardware\n");
> > -		rc = -ENODEV;
> > +	chip = tpmm_chip_alloc(dev, &tpm_tis_i2c);
> > +	if (IS_ERR(chip)) {
> > +		rc = PTR_ERR(chip);
> >  		goto out_err;
> 
> Nit: out_err is synonymous with 'return rc;', so all the goto out_err
> in this driver can just return;
> 
> > +	rc = tpm_chip_register(chip);
> > +	if (rc)
> > +		return rc;
> > +	return 0;
> 
> Nit: could just be return tpm_chip_register(chip);
> 
> > @@ -619,10 +619,9 @@ tpm_st33_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
> >  		goto end;
> >  	}
> >  
> > -	chip = tpm_register_hardware(&client->dev, &st_i2c_tpm);
> > -	if (!chip) {
> > -		dev_info(&client->dev, "fail chip\n");
> > -		err = -ENODEV;
> > +	chip = tpmm_chip_alloc(&client->dev, &st_i2c_tpm);
> > +	if (IS_ERR(chip)) {
> > +		err = PTR_ERR(chip);
> >  		goto end;
> >  	}
> 
> Nit: Same comment, 'goto end' can just be 'return rc'
> 
> > -	dev_info(chip->dev, "TPM I2C Initialized\n");
> > +	err = tpm_chip_register(chip);
> > +	if (err)
> > +		goto _irq_set;
> > +
> 
> Nit: Same comment
> 
> >  end:
> >  	pr_info("TPM I2C initialisation fail\n");
> 
> This pr_info should be deleted

Agreed.

> > @@ -573,6 +580,8 @@ static void tpm_inf_pnp_remove(struct pnp_dev *dev)
> >  	struct tpm_chip *chip = pnp_get_drvdata(dev);
> >  
> >  	if (chip) {
> 
> Nit: This if in the remove callback is an anti-pattern and should be
> globally removed. If remove is being called then probe succeeded,
> there is no way for probe to succed and drvdata to be unset.
> 
> >  static void tpm_nsc_remove(struct device *dev)
> >  {
> >  	struct tpm_chip *chip = dev_get_drvdata(dev);
> > -	if ( chip ) {
> > +	if (chip) {
> 
> Same comment
> 
> > @@ -836,7 +831,7 @@ MODULE_PARM_DESC(hid, "Set additional specific HID for this driver to probe");
> >  
> >  static struct platform_driver tis_drv = {
> >  	.driver = {
> > -		.name = "tpm_tis",
> > +		.name		= "tpm_tis",
> >  		.owner		= THIS_MODULE,
> >  		.pm		= &tpm_tis_pm,
> >  	},
> 
> There is no remove method here in this platform_driver, this ties into
> the question if force works or not. The tpm_tis_remove call in the
> cleanup_hardware should be done through the .remove method of this
> driver structure..

I'll try to get this tested.

> Jason

/Jarkko
