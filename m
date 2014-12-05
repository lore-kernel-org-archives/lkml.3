Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaLEOOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 09:14:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:5794 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbaLEOOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 09:14:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="425528292"
Date: Fri, 5 Dec 2014 16:13:03 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org,
        trousers-tech@lists.sourceforge.net,
        Will Arthur <will.c.arthur@intel.com>
Subject: Re: [PATCH v9 6/8] tpm: TPM 2.0 baseline support
Message-ID: <20141205141303.GF6993@intel.com>
References: <1417672518-4530-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1417672518-4530-7-git-send-email-jarkko.sakkinen@linux.intel.com>
 <201412050017.40668.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201412050017.40668.PeterHuewe@gmx.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey

is it cool if I prepare a separate set of fixes for all issues
in v9? I do not see any problem that could not be fixed without
major structural changes.

/Jarkko

On Fri, Dec 05, 2014 at 12:17:40AM +0100, Peter Hüwe wrote:
> Am Donnerstag, 4. Dezember 2014, 06:55:16 schrieb Jarkko Sakkinen:
> > TPM 2.0 devices are separated by adding a field 'flags' to struct
> > tpm_chip and defining a flag TPM_CHIP_FLAG_TPM2 for tagging them.
> > 
> > This patch adds the following internal functions:
> > 
> > - tpm2_get_random()
> > - tpm2_get_tpm_pt()
> > - tpm2_pcr_extend()
> > - tpm2_pcr_read()
> > - tpm2_startup()
> > 
> > Additionally, the following exported functions are implemented for
> > implementing TPM 2.0 device drivers:
> > 
> > - tpm2_do_selftest()
> > - tpm2_calc_ordinal_durations()
> > - tpm2_gen_interrupt()
> > 
> > The existing functions that are exported for the use for existing
> > subsystems have been changed to check the flags field in struct
> > tpm_chip and use appropriate TPM 2.0 counterpart if
> > TPM_CHIP_FLAG_TPM2 is est.
> > 
> > The code for tpm2_calc_ordinal_duration() and tpm2_startup() were
> > originally written by Will Arthur.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Signed-off-by: Will Arthur <will.c.arthur@intel.com>
> > ---
> >  drivers/char/tpm/Makefile        |   2 +-
> >  drivers/char/tpm/tpm-chip.c      |  27 +-
> >  drivers/char/tpm/tpm-interface.c |  24 +-
> >  drivers/char/tpm/tpm.h           |  61 +++++
> >  drivers/char/tpm/tpm2-cmd.c      | 542
> > +++++++++++++++++++++++++++++++++++++++ 5 files changed, 641
> > insertions(+), 15 deletions(-)
> >  create mode 100644 drivers/char/tpm/tpm2-cmd.c
> > 
> > diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
> > index c715596..88848ed 100644
> > --- a/drivers/char/tpm/Makefile
> > +++ b/drivers/char/tpm/Makefile
> > @@ -2,7 +2,7 @@
> >  # Makefile for the kernel tpm device drivers.
> >  #
> >  obj-$(CONFIG_TCG_TPM) += tpm.o
> > -tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o
> > +tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o
> >  tpm-$(CONFIG_ACPI) += tpm_ppi.o
> > 
> >  ifdef CONFIG_ACPI
> > diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> > index 7741e28..3f3f2de 100644
> > --- a/drivers/char/tpm/tpm-chip.c
> > +++ b/drivers/char/tpm/tpm-chip.c
> > @@ -195,15 +195,18 @@ int tpm_chip_register(struct tpm_chip *chip)
> >  	if (rc)
> >  		return rc;
> > 
> > -	rc = tpm_sysfs_add_device(chip);
> > -	if (rc)
> > -		goto del_misc;
> > +	/* Populate sysfs for TPM1 devices. */
> > +	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
> > +		rc = tpm_sysfs_add_device(chip);
> > +		if (rc)
> > +			goto del_misc;
> > 
> > -	rc = tpm_add_ppi(chip);
> > -	if (rc)
> > -		goto del_sysfs;
> > +		rc = tpm_add_ppi(chip);
> > +		if (rc)
> > +			goto del_sysfs;
> > 
> > -	chip->bios_dir = tpm_bios_log_setup(chip->devname);
> > +		chip->bios_dir = tpm_bios_log_setup(chip->devname);
> > +	}
> > 
> >  	/* Make the chip available. */
> >  	spin_lock(&driver_lock);
> > @@ -236,10 +239,12 @@ void tpm_chip_unregister(struct tpm_chip *chip)
> >  	spin_unlock(&driver_lock);
> >  	synchronize_rcu();
> > 
> > -	if (chip->bios_dir)
> > -		tpm_bios_log_teardown(chip->bios_dir);
> > -	tpm_remove_ppi(chip);
> > -	tpm_sysfs_del_device(chip);
> > +	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
> > +		if (chip->bios_dir)
> > +			tpm_bios_log_teardown(chip->bios_dir);
> > +		tpm_remove_ppi(chip);
> > +		tpm_sysfs_del_device(chip);
> > +	}
> > 
> >  	tpm_dev_del_device(chip);
> >  }
> > diff --git a/drivers/char/tpm/tpm-interface.c
> > b/drivers/char/tpm/tpm-interface.c index b6f6b17..8a14887 100644
> > --- a/drivers/char/tpm/tpm-interface.c
> > +++ b/drivers/char/tpm/tpm-interface.c
> > @@ -360,7 +360,10 @@ ssize_t tpm_transmit(struct tpm_chip *chip, const char
> > *buf, if (chip->vendor.irq)
> >  		goto out_recv;
> > 
> > -	stop = jiffies + tpm_calc_ordinal_duration(chip, ordinal);
> > +	if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > +		stop = jiffies + tpm2_calc_ordinal_duration(chip, ordinal);
> > +	else
> > +		stop = jiffies + tpm_calc_ordinal_duration(chip, ordinal);
> >  	do {
> >  		u8 status = chip->ops->status(chip);
> >  		if ((status & chip->ops->req_complete_mask) ==
> > @@ -483,7 +486,7 @@ static const struct tpm_input_header tpm_startup_header
> > = { static int tpm_startup(struct tpm_chip *chip, __be16 startup_type) {
> >  	struct tpm_cmd_t start_cmd;
> > -	start_cmd.header.in = tpm_startup_header;
> > +
> WHY?!? This renders tpm_startup useless.
> 
> So NACK for this part.
> >  	start_cmd.params.startup_in.startup_type = startup_type;
> >  	return tpm_transmit_cmd(chip, &start_cmd, TPM_INTERNAL_RESULT_SIZE,
> >  				"attempting to start the TPM");
> 
> I'll get you an TPM1.2 :)
> 
> Thanks
> Peter
