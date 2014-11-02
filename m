Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaKBVdV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 16:33:21 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:46797 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbaKBVdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 16:33:19 -0500
Date: Sun, 2 Nov 2014 14:33:05 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com
Subject: Re: [PATCH v5 7/7] tpm: create TPM 2.0 devices using own device class
Message-ID: <20141102213305.GB28519@obsidianresearch.com>
References: <1414832495-23609-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1414832495-23609-8-git-send-email-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414832495-23609-8-git-send-email-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 11:01:35AM +0200, Jarkko Sakkinen wrote:
> Added own class for TPM devices that is used for TPM 2.0 and onwards.
> For TPM1 old device structure is kept for backwards compatibility.
> 
> Each struct tpm_chip represents a character device that is associated
> to the tpm device class.

I think we should hang back on this untill we can answer a few
questions..

I certainly thing both TPM1 and TPM2 should create the class, at the
worst only tpm2 uses it for the chardev?

> @@ -63,7 +65,7 @@ static int tpm_open(struct inode *inode, struct file *file)
>  	 * by the check of is_open variable, which is protected
>  	 * by driver_lock. */
>  	if (test_and_set_bit(0, &chip->is_open)) {
> -		dev_dbg(chip->dev, "Another process owns this TPM\n");
> +		dev_dbg(chip->pdev, "Another process owns this TPM\n");
>  		return -EBUSY;

I actually think these are mostly wrong, and are part of why I think
tpm1 should create the class too.

Except for the probe and remove function everything should log using
the TPM device name (eg tpm0) and not the platform device name, so all
of these debug statements should stay chip->dev...

And considering the volume of changes it might be better to leave
'dev' as a pointer to the tpm class rather than try and tackle that in
this giant patch..

> +static void tpm_dev_release(struct device *dev)
> +{
> +}

And all of this is upside down, the devm interm stuff should hold a
get_device() on the struct device and the kfree should live here.

> +	chip->cdev.owner = chip->pdev->driver->owner;

Is that right? the cdev fops is in this module, not the driver's
module..

> +	rc = cdev_add(&chip->cdev, chip->dev.devt, 1);

Can we/should we re-use the misc dev minor number assigned to TPM for
tpm0?

To me altering the dev major:minor  a far more visible change than
moving the 'dev' file in sysfs. udev will handle the latter
transparently, but the former will break non-udev systems..

Jason
