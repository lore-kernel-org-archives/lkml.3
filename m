Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaGUXng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 19:43:36 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:50123 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbaGUXnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 19:43:35 -0400
Date: Mon, 21 Jul 2014 17:43:30 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: tpmdd-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [tpmdd-devel] [PATCH] Use devm_ioremap_resource to reserve
 resource
Message-ID: <20140721234330.GA6482@obsidianresearch.com>
References: <1405985165-9631-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405985165-9631-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 01:26:05AM +0200, Peter Huewe wrote:
> Unfortunately the tpm_tis driver did never call request_region for its
> adress space - now since we've got devm_ioremap_resource we can simply
> remove all the stuff and do everything in one call.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
>  drivers/char/tpm/tpm_tis.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 2c46734..a79be26 100644
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -534,13 +534,14 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
>  	u32 vendor, intfcaps, intmask;
>  	int rc, i, irq_s, irq_e, probe;
>  	struct tpm_chip *chip;
> +	struct resource res = DEFINE_RES_MEM_NAMED(start, len, "tpm_tis");
>  
>  	if (!(chip = tpm_register_hardware(dev, &tpm_tis)))
>  		return -ENODEV;
>  
> -	chip->vendor.iobase = ioremap(start, len);
> -	if (!chip->vendor.iobase) {
> -		rc = -EIO;
> +	chip->vendor.iobase = devm_ioremap_resource(dev, &res);
> +	if (IS_ERR(chip->vendor.iobase)) {
> +		rc = PTR_ERR(chip->vendor.iobase);
>  		goto out_err;
>  	}
>  
> @@ -727,8 +728,6 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
>  
>  	return 0;
>  out_err:
> -	if (chip->vendor.iobase)
> -		iounmap(chip->vendor.iobase);
>  	tpm_remove_hardware(chip->dev);
>  	return rc;
>  }
> @@ -891,7 +890,6 @@ static void __exit cleanup_tis(void)
>  		release_locality(chip, chip->vendor.locality, 1);
>  		if (chip->vendor.irq)
>  			free_irq(chip->vendor.irq, chip);
> -		iounmap(i->iobase);
>  		list_del(&i->list);
>  	}

Hurm, this makes the ordering truely horrible and opaque. Are you
completely certain that in every case the devm unwide will happen only
after cleanup_tis is called?

Intuitively, I would expect all devices to have been detached and
resources freed prior to the module exit function being called...

I'd be much happier with mixing devm into this driver if it had a
proper driver remove method and the unnecessary tis_chips list was
purged.

Jason
