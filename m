Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab3KFXaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 18:30:16 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:58457 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab3KFXaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 18:30:12 -0500
Date: Wed, 6 Nov 2013 16:30:09 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: axboe@kernel.dk, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        stephenmcameron@gmail.com, thenzl@redhat.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH] PCI: warn on driver probe return value greater than zero
Message-ID: <20131106233009.GA28117@google.com>
References: <20131101193455.18686.92302.stgit@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101193455.18686.92302.stgit@beardog.cce.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 02:34:55PM -0500, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> Ages ago, drivers could return values greater than zero from
> their probe function and this would be regarded as success.
> Commit f3ec4f87d607f40497 "PCI: change device runtime PM
> settings for probe and remove" slightly altered this in 2010,
> and commit 967577b062417b4e4b8e27b "PCI/PM: Keep runtime PM
> enabled for unbound PCI devices" in late 2012 altered it more
> signficantly, setting pci_dev->driver to NULL if the driver's
> probe function returned a value greater than zero, which would
> for example prevent the driver's remove function from being
> called on rmmod.
> 
> Neither of those changes would necessarily make the driver fail
> in an obvious way though, and so at least a couple drivers (cciss,
> hpsa) fell into this hole since they were returning 1, and this
> situation went unnoticed for quite some time.
> 
> If a driver's probe function returns a value greater than zero,
> issue a warning, but otherwise treat this as success.
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Applied to my pci/misc branch for v3.13, thanks.

Bjorn

> ---
>  drivers/pci/pci-driver.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 98f7b9b..7fbe343 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -264,11 +264,19 @@ static long local_pci_probe(void *_ddi)
>  	pm_runtime_get_sync(dev);
>  	pci_dev->driver = pci_drv;
>  	rc = pci_drv->probe(pci_dev, ddi->id);
> -	if (rc) {
> +	if (!rc)
> +		return rc;
> +	if (rc < 0) {
>  		pci_dev->driver = NULL;
>  		pm_runtime_put_sync(dev);
> +		return rc;
>  	}
> -	return rc;
> +	/*
> +	 * Probe function should return < 0 for failure, 0 for success
> +	 * Treat values > 0 as success, but warn.
> +	 */
> +	dev_warn(dev, "Driver probe function unexpectedly returned %d\n", rc);
> +	return 0;
>  }
>  
>  static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
> 
