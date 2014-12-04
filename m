Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaLDWXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 17:23:12 -0500
Received: from mout.gmx.net ([212.227.17.22]:63706 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbaLDWXK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 17:23:10 -0500
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: tpmdd-devel@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH v9 8/8] tpm: TPM 2.0 FIFO Interface
Date: Thu, 4 Dec 2014 23:28:29 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-rc6-dirty; KDE/4.12.5; x86_64; ; )
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        christophe.ricard@gmail.com, josh.triplett@intel.com,
        linux-api@vger.kernel.org, Ashley Lai <ashley@ashleylai.com>,
        linux-kernel@vger.kernel.org, Will Arthur <will.c.arthur@intel.com>,
        jason.gunthorpe@obsidianresearch.com,
        trousers-tech@lists.sourceforge.net
References: <1417672518-4530-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1417672518-4530-9-git-send-email-jarkko.sakkinen@linux.intel.com> <201412042318.33889.PeterHuewe@gmx.de>
In-Reply-To: <201412042318.33889.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201412042328.29578.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:8D8ijMV016hgd3qKTotKXggj4p4DawMoHk5f885NeIW44IvxRK7
 krkC1+HbaTRGE4WUYs+lwDnQvm8ONp39nrbVQSVLl7oyPVRmytrA/B4qphl+f7WMQfNbBVV
 K6nJ/oaJtcmxz5PDtTDlNjhNdGHX//xSQhKucOE9m1z0zNu11OZ4eEYQWwQ0vNpF4tBmNpW
 HnlR4oOAIRX60PFOhol/Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 4. Dezember 2014, 23:18:33 schrieb Peter Hüwe:
> Hi Jarkko,
> 
> Am Donnerstag, 4. Dezember 2014, 06:55:18 schrieb Jarkko Sakkinen:
> > From: Will Arthur <will.c.arthur@intel.com>
> > 
> > Detect TPM 2.0 by using the extended STS (STS3) register. For TPM 2.0,
> > instead of calling tpm_get_timeouts(), assign duration and timeout
> > values defined in the TPM 2.0 PTP specification.
> > 
> > Signed-off-by: Will Arthur <will.c.arthur@intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> > 
> >  drivers/char/tpm/tpm_tis.c | 80
> > 
> > ++++++++++++++++++++++++++++++++++++++-------- 1 file changed, 67
> > insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> > index 89e1abb..71cbb2d 100644
> > --- a/drivers/char/tpm/tpm_tis.c
> > +++ b/drivers/char/tpm/tpm_tis.c
> > @@ -1,5 +1,6 @@
> > 
> >  /*
> >  
> >   * Copyright (C) 2005, 2006 IBM Corporation
> > 
> > + * Copyright (C) 2014 Intel Corporation
> > 
> >   *
> >   * Authors:
> >   * Leendert van Doorn <leendert@watson.ibm.com>
> > 
> > @@ -44,6 +45,10 @@ enum tis_status {
> > 
> >  	TPM_STS_DATA_EXPECT = 0x08,
> >  
> >  };
> > 
> > +enum tis_status3 {
> > +	TPM_STS3_TPM2_FAM = 0x04,
> > +};
> > +
> > 
> >  enum tis_int_flags {
> >  
> >  	TPM_GLOBAL_INT_ENABLE = 0x80000000,
> >  	TPM_INTF_BURST_COUNT_STATIC = 0x100,
> > 
> > @@ -70,6 +75,7 @@ enum tis_defaults {
> > 
> >  #define	TPM_INT_STATUS(l)		(0x0010 | ((l) << 12))
> >  #define	TPM_INTF_CAPS(l)		(0x0014 | ((l) << 12))
> >  #define	TPM_STS(l)			(0x0018 | ((l) << 12))
> > 
> > +#define	TPM_STS3(l)			(0x001b | ((l) << 12))
> > 
> >  #define	TPM_DATA_FIFO(l)		(0x0024 | ((l) << 12))
> >  
> >  #define	TPM_DID_VID(l)			(0x0F00 | ((l) << 12))
> > 
> > @@ -363,6 +369,7 @@ static int tpm_tis_send_main(struct tpm_chip *chip,
> > u8 *buf, size_t len) {
> > 
> >  	int rc;
> >  	u32 ordinal;
> > 
> > +	unsigned long dur;
> > 
> >  	rc = tpm_tis_send_data(chip, buf, len);
> >  	if (rc < 0)
> > 
> > @@ -374,9 +381,14 @@ static int tpm_tis_send_main(struct tpm_chip *chip,
> > u8 *buf, size_t len)
> > 
> >  	if (chip->vendor.irq) {
> >  	
> >  		ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
> > 
> > +
> > +		if (chip->flags & TPM_CHIP_FLAG_TPM2)
> > +			dur = tpm2_calc_ordinal_duration(chip, ordinal);
> > +		else
> > +			dur = tpm_calc_ordinal_duration(chip, ordinal);
> > +
> > 
> >  		if (wait_for_tpm_stat
> > 
> > -		    (chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID,
> > -		     tpm_calc_ordinal_duration(chip, ordinal),
> > +		    (chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID, dur,
> > 
> >  		     &chip->vendor.read_queue, false) < 0) {
> >  			
> >  			rc = -ETIME;
> >  			goto out_err;
> > 
> > @@ -588,6 +600,7 @@ static int tpm_tis_init(struct device *dev,
> > acpi_handle acpi_dev_handle, int rc, i, irq_s, irq_e, probe;
> > 
> >  	struct tpm_chip *chip;
> >  	struct priv_data *priv;
> > 
> > +	u8 sts3;
> > 
> >  	priv = devm_kzalloc(dev, sizeof(struct priv_data), GFP_KERNEL);
> >  	if (priv == NULL)
> > 
> > @@ -604,11 +617,28 @@ static int tpm_tis_init(struct device *dev,
> > acpi_handle acpi_dev_handle, if (!chip->vendor.iobase)
> > 
> >  		return -EIO;
> > 
> > +	sts3 = ioread8(chip->vendor.iobase + TPM_STS3(1));
> > +	if ((sts3 & TPM_STS3_TPM2_FAM) == TPM_STS3_TPM2_FAM)
> > +		chip->flags = TPM_CHIP_FLAG_TPM2;
> > +
> > 
> >  	/* Default timeouts */
> > 
> > -	chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> > -	chip->vendor.timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
> > -	chip->vendor.timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> > -	chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> > +	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> > +		chip->vendor.timeout_a = usecs_to_jiffies(TPM2_TIMEOUT_A);
> > +		chip->vendor.timeout_b = usecs_to_jiffies(TPM2_TIMEOUT_B);
> > +		chip->vendor.timeout_c = usecs_to_jiffies(TPM2_TIMEOUT_C);
> > +		chip->vendor.timeout_d = usecs_to_jiffies(TPM2_TIMEOUT_D);
> > +		chip->vendor.duration[TPM_SHORT] =
> > +			usecs_to_jiffies(TPM2_DURATION_SHORT);
> > +		chip->vendor.duration[TPM_MEDIUM] =
> > +			usecs_to_jiffies(TPM2_DURATION_MEDIUM);
> > +		chip->vendor.duration[TPM_LONG] =
> > +			usecs_to_jiffies(TPM2_DURATION_LONG);
> > +	} else {
> > +		chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> > +		chip->vendor.timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
> > +		chip->vendor.timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> > +		chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
> > +	}
> > 
> >  	if (wait_startup(chip, 0) != 0) {
> >  	
> >  		rc = -ENODEV;
> > 
> > @@ -623,8 +653,8 @@ static int tpm_tis_init(struct device *dev,
> > acpi_handle acpi_dev_handle, vendor = ioread32(chip->vendor.iobase +
> > TPM_DID_VID(0));
> > 
> >  	chip->vendor.manufacturer_id = vendor;
> > 
> > -	dev_info(dev,
> > -		 "1.2 TPM (device-id 0x%X, rev-id %d)\n",
> > +	dev_info(dev, "%s TPM (device-id 0x%X, rev-id %d)\n",
> > +		 (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2",
> > 
> >  		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
> 
> When loading tpm_tis force=1 with my tpm1.2 chip on a machine without bios
> integration, it fets detected as a TPM2.0 chip :/
> 
> sudo rmmod tpm_tis
> # modprobe tpm_tis force=1
> modprobe: ERROR: could not insert 'tpm_tis': No such device
> # dmesg
> [  263.903828] tpm_tis tpm_tis: 2.0 TPM (device-id 0xB, rev-id 16)
> [  263.948049] tpm_tis tpm_tis: A TPM error (10) occurred continue selftest
> [  263.948120] tpm_tis tpm_tis: TPM self test failed
> 
> 
> sts3 is reported as 0xff from my TPM1.2
> 


Hmm,
my TPM2.0 chip also reports sts3 as 0xff (when loading with force=1 on a 
machine without bios integration)

[  307.095344] sts3 ff
[  307.095366] tpm_tis tpm_tis: 2.0 TPM (device-id 0x1A, rev-id 16)
[  307.140047] tpm_tis tpm_tis: A TPM error (256) occurred continue selftest
[  307.140056] tpm_tis tpm_tis: TPM self test failed




Peter
