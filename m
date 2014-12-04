Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276AbaLDU2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 15:28:52 -0500
Received: from mout.gmx.net ([212.227.17.21]:56765 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933256AbaLDU2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 15:28:50 -0500
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v9 3/8] tpm: fix raciness of PPI interface lookup
Date: Thu, 4 Dec 2014 21:34:15 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-rc6-dirty; KDE/4.12.5; x86_64; ; )
Cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org,
        trousers-tech@lists.sourceforge.net
References: <1417672518-4530-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1417672518-4530-4-git-send-email-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <1417672518-4530-4-git-send-email-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201412042134.15776.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:zSX2g2+PlbdkGGvbgzrp7zFdV3lc13Viduh2fx1c0TC0b9Zq8Dj
 K6ljfrc9sxS7O/fBOB2x6FTxq5TOPttW2RnVFg42wbqJK2Wi7awJKlTM69XkMlFf9gLQGD/
 o6vQxK0S3WHAwpI1pF/NrqayBtuor1Hz4xYnWTI7LCt2LaPLWop8/byAyan/G9dLDaekmrY
 ZhY1Fjxww1SvnvlQVLndQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 4. Dezember 2014, 06:55:13 schrieb Jarkko Sakkinen:
> Traversal of the ACPI device tree was not done right. PPI interface
> should be looked up only from the ACPI device that is the platform
> device for the TPM. This could cause problems with systems with
> two TPM chips such as 4th gen Intel systems.
> 
> In addition, added the missing license and copyright platter to
> the tpm_ppi.c.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

:(

> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -580,8 +580,9 @@ static void tpm_tis_remove(struct tpm_chip *chip)
>  	release_locality(chip, chip->vendor.locality, 1);
>  }
> 
> -static int tpm_tis_init(struct device *dev, resource_size_t start,
> -			resource_size_t len, unsigned int irq)
> +static int tpm_tis_init(struct device *dev, acpi_handle acpi_dev_handle,
> +			resource_size_t start, resource_size_t len,
> +			unsigned int irq)
>  {
>  	u32 vendor, intfcaps, intmask;
>  	int rc, i, irq_s, irq_e, probe;
> @@ -597,6 +598,7 @@ static int tpm_tis_init(struct device *dev,
> resource_size_t start, return PTR_ERR(chip);
> 
>  	chip->vendor.priv = priv;
> +	chip->acpi_dev_handle = acpi_dev_handle;
> 
>  	chip->vendor.iobase = devm_ioremap(dev, start, len);
>  	if (!chip->vendor.iobase)
> @@ -827,6 +829,7 @@ static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
>  {
>  	resource_size_t start, len;
>  	unsigned int irq = 0;
> +	acpi_handle acpi_dev_handle = NULL;
> 
>  	start = pnp_mem_start(pnp_dev, 0);
>  	len = pnp_mem_len(pnp_dev, 0);
> @@ -839,7 +842,10 @@ static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
>  	if (is_itpm(pnp_dev))
>  		itpm = true;
> 
> -	return tpm_tis_init(&pnp_dev->dev, start, len, irq);
> +	if (pnp_acpi_device(pnp_dev))
> +		acpi_dev_handle = pnp_acpi_device(pnp_dev)->handle;
> +
> +	return tpm_tis_init(&pnp_dev->dev, acpi_dev_handle, start, len, irq);
>  }

With CONFIG_ACPI not set I get a build error :(

  CC [M]  drivers/char/tpm/tpm_tis.o
drivers/char/tpm/tpm_tis.c: In function 'tpm_tis_init':
drivers/char/tpm/tpm_tis.c:614:6: error: 'struct tpm_chip' has no member named 
'acpi_dev_handle'
scripts/Makefile.build:263: recipe for target 'drivers/char/tpm/tpm_tis.o' 
failed
make[3]: *** [drivers/char/tpm/tpm_tis.o] Error 1
scripts/Makefile.build:404: recipe for target 'drivers/char/tpm' failed
make[2]: *** [drivers/char/tpm] Error 2
scripts/Makefile.build:404: recipe for target 'drivers/char' failed
make[1]: *** [drivers/char] Error 2
Makefile:929: recipe for target 'drivers' failed
make: *** [drivers] Error 2


Please fix.
Peter
