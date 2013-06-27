Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab3F0HoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:44:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241Ab3F0HoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:44:22 -0400
Date: Thu, 27 Jun 2013 10:45:01 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH] uio: uio_pci_generic: Add support for MSI interrupts
Message-ID: <20130627074501.GC5489@redhat.com>
References: <1372285823-6293-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372285823-6293-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 03:30:23PM -0700, Guenter Roeck wrote:
> Enable support for MSI interrupts if the device supports it.
> Since MSI interrupts are edge triggered, it is no longer necessary to
> disable interrupts in the kernel and re-enable them from user-space.
> Instead, clearing the interrupt condition in the user space application
> automatically re-enables the interrupt.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> An open question is if we can just do this unconditionally
> or if there should be some flag to enable it. A module parameter, maybe ?

NACK

UIO is for devices that don't do memory writes.
Anything that can do writes must be protected by an IOMMU
and/or have a secure kernel driver, not a UIO stub.

MSI is done by memory writes so if userspace
controls the device it can trick it to write
anywhere in memory.


>  Documentation/DocBook/uio-howto.tmpl |   23 ++++++++++++++++++++---
>  drivers/uio/uio_pci_generic.c        |   15 ++++++++++++---
>  2 files changed, 32 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
> index 9561815..69b54e0 100644
> --- a/Documentation/DocBook/uio-howto.tmpl
> +++ b/Documentation/DocBook/uio-howto.tmpl
> @@ -46,6 +46,12 @@ GPL version 2.
>  
>  <revhistory>
>  	<revision>
> +	<revnumber>0.10</revnumber>
> +	<date>2013-06-26</date>
> +	<authorinitials>gr</authorinitials>
> +	<revremark>Added MSI support to uio_pci_generic.</revremark>
> +	</revision>
> +	<revision>
>  	<revnumber>0.9</revnumber>
>  	<date>2009-07-16</date>
>  	<authorinitials>mst</authorinitials>
> @@ -935,15 +941,26 @@ and look in the output for failure reasons
>  <sect1 id="uio_pci_generic_internals">
>  <title>Things to know about uio_pci_generic</title>
>  	<para>
> -Interrupts are handled using the Interrupt Disable bit in the PCI command
> +Interrupts are handled either as MSI interrupts (if the device supports it) or
> +as legacy INTx interrupts.
> +	</para>
> +	<para>
> +uio_pci_generic automatically configures a device to use MSI interrupts
> +if the device supports it. If an MSI interrupt is received, the user space
> +driver is notified. Since MSI interrupts are edge sensitive, the user space
> +driver needs to clear the interrupt condition in the device before blocking
> +and waiting for more interrupts.
> +	</para>
> +	<para>
> +Legacy interrupts are handled using the Interrupt Disable bit in the PCI command
>  register and Interrupt Status bit in the PCI status register.  All devices
>  compliant to PCI 2.3 (circa 2002) and all compliant PCI Express devices should
>  support these bits.  uio_pci_generic detects this support, and won't bind to
>  devices which do not support the Interrupt Disable Bit in the command register.
>  	</para>
>  	<para>
> -On each interrupt, uio_pci_generic sets the Interrupt Disable bit.
> -This prevents the device from generating further interrupts
> +If legacy interrupts are used, uio_pci_generic sets the Interrupt Disable bit on
> +each interrupt. This prevents the device from generating further interrupts
>  until the bit is cleared. The userspace driver should clear this
>  bit before blocking and waiting for more interrupts.
>  	</para>
> diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
> index 14aa10c..3366fdb 100644
> --- a/drivers/uio/uio_pci_generic.c
> +++ b/drivers/uio/uio_pci_generic.c
> @@ -32,6 +32,7 @@
>  struct uio_pci_generic_dev {
>  	struct uio_info info;
>  	struct pci_dev *pdev;
> +	bool have_msi;
>  };
>  
>  static inline struct uio_pci_generic_dev *
> @@ -46,7 +47,7 @@ static irqreturn_t irqhandler(int irq, struct uio_info *info)
>  {
>  	struct uio_pci_generic_dev *gdev = to_uio_pci_generic_dev(info);
>  
> -	if (!pci_check_and_mask_intx(gdev->pdev))
> +	if (!gdev->have_msi && !pci_check_and_mask_intx(gdev->pdev))
>  		return IRQ_NONE;
>  
>  	/* UIO core will signal the user process. */
> @@ -58,6 +59,7 @@ static int probe(struct pci_dev *pdev,
>  {
>  	struct uio_pci_generic_dev *gdev;
>  	int err;
> +	bool have_msi = false;
>  
>  	err = pci_enable_device(pdev);
>  	if (err) {
> @@ -73,7 +75,9 @@ static int probe(struct pci_dev *pdev,
>  		return -ENODEV;
>  	}
>  
> -	if (!pci_intx_mask_supported(pdev)) {
> +	if (!pci_enable_msi(pdev)) {
> +		have_msi = true;
> +	} else if (!pci_intx_mask_supported(pdev)) {
>  		err = -ENODEV;
>  		goto err_verify;
>  	}
> @@ -84,10 +88,11 @@ static int probe(struct pci_dev *pdev,
>  		goto err_alloc;
>  	}
>  
> +	gdev->have_msi = have_msi;
>  	gdev->info.name = "uio_pci_generic";
>  	gdev->info.version = DRIVER_VERSION;
>  	gdev->info.irq = pdev->irq;
> -	gdev->info.irq_flags = IRQF_SHARED;
> +	gdev->info.irq_flags = have_msi ? 0 : IRQF_SHARED;
>  	gdev->info.handler = irqhandler;
>  	gdev->pdev = pdev;
>  
> @@ -99,6 +104,8 @@ static int probe(struct pci_dev *pdev,
>  err_register:
>  	kfree(gdev);
>  err_alloc:
> +	if (have_msi)
> +		pci_disable_msi(pdev);
>  err_verify:
>  	pci_disable_device(pdev);
>  	return err;
> @@ -109,6 +116,8 @@ static void remove(struct pci_dev *pdev)
>  	struct uio_pci_generic_dev *gdev = pci_get_drvdata(pdev);
>  
>  	uio_unregister_device(&gdev->info);
> +	if (gdev->have_msi)
> +		pci_disable_msi(pdev);
>  	pci_disable_device(pdev);
>  	kfree(gdev);
>  }
> -- 
> 1.7.9.5
