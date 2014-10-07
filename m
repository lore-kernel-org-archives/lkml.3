Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbaJGRxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 13:53:39 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:37383 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402AbaJGRxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:53:38 -0400
Date: Tue, 7 Oct 2014 11:53:26 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>, linux-api@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH v2 3/7] tpm: clean up tpm_tis driver
 life-cycle
Message-ID: <20141007175326.GB10432@obsidianresearch.com>
References: <1412701277-27794-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1412701277-27794-4-git-send-email-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412701277-27794-4-git-send-email-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 08:01:13PM +0300, Jarkko Sakkinen wrote:

> +	chip = tpm_chip_alloc(dev, &tpm_tis);
> +	if (!chip)
>  		return -ENODEV;

Needs to use ERR_PTR
  
> +	rc = tpm_chip_register(chip);
> +	if (rc)
> +		return -ENODEV;

Wrong ordering, this needs to be last in the probe function

Return rc not -ENODEV
  
> +static void tpm_tis_chip_remove(struct tpm_chip *chip)
> +{
> +	iowrite32(~TPM_GLOBAL_INT_ENABLE &
> +		  ioread32(chip->vendor.iobase +
> +			   TPM_INT_ENABLE(chip->vendor.
> +					  locality)),
> +		  chip->vendor.iobase +
> +		  TPM_INT_ENABLE(chip->vendor.locality));
> +	release_locality(chip, chip->vendor.locality, 1);
> +	if (chip->vendor.irq)
> +		free_irq(chip->vendor.irq, chip);
> +
> +	tpm_chip_unregister(chip);
> +}

Wrong ordering, tpm_chip_unregister needs to be first

> +	chip = dev_get_drvdata(&pdev->dev);
> +	tpm_tis_chip_remove(chip);
>  	platform_device_unregister(pdev);

I'm under the impression devm does not work outside a device driver
context, so adding devm breaks force mode in this driver. Do you see
differently?

AFAIK the two options are to fix force mode so that it attaches the
dummy platform driver (that is what it is for after all) or remove
force mode.

Jason
