Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbaIXRGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:06:01 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:35958 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036AbaIXRF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:05:59 -0400
Date: Wed, 24 Sep 2014 11:05:51 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, Peter Huewe <peterhuewe@gmx.de>,
        Marcel Selhorst <tpmdd@selhorst.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 11/12] tpm: Driver for TPM 2.0 CRB Interface
Message-ID: <20140924170551.GF8898@obsidianresearch.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1411549562-24242-12-git-send-email-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411549562-24242-12-git-send-email-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 12:06:01PM +0300, Jarkko Sakkinen wrote:

> +	offset = cca->rsp_pa - priv->cca_pa;
> +	resp = (u8 *) ((unsigned long) cca + offset);
> +	memcpy(buf, resp, 6);
> +	expected = be32_to_cpu(*(__be32 *) (buf + 2));

be32_to_cpup?

> +static void crb_release(void *data)
> +{
> +	struct tpm_chip *chip = (struct tpm_chip *) data;
> +	tpm_remove_hardware(chip->dev);
> +}

Please use a proper remove function on the device driver, not a devm
function like this. 'tpm_remove_hardware' is the wrong name for a new
API, it must be 'tpm_chip_unregister' (ie the undo of 'tpm_chip_register')

> +static int crb_acpi_add(struct acpi_device *device)
> +{
> +	struct tpm_chip *chip;
> +	struct acpi_tpm2 *buf;
> +	struct crb_priv *priv;
> +	struct device *dev = &device->dev;
> +	acpi_status status;
> +	u32 sm;
> +	int rc;
> +
> +	chip = tpm_chip_alloc(dev, &tpm_crb);
> +	if (!chip)
> +		return -ENODEV;

Lets use ERRPTR here

> +	chip->tpm2 = true;
> +
> +	rc = tpm_chip_register(chip);

This is in the wrong place, it needs to be the last call in the probe
function - the driver must be fully operational when register is
called, that is one of the bugs the new interface must be fixing.

> +	rc = tpm_do_selftest(chip);
> +	if (rc) {
> +		rc = -ENODEV;
> +		goto out_err;
> +	}

The common TPM command startup sequence should be in
tpm_chip_register(), so move this into there.

> +	rc = devm_add_action(dev, crb_release, chip);
> +	if (rc)
> +		goto out_err;
> +
> +	return 0;
> +out_err:
> +	tpm_remove_hardware(chip->dev);
> +	return rc;
> +}
> +
> +static struct acpi_device_id crb_device_ids[] = {

const? Not sure

Jason
