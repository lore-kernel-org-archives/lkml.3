Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbaDORiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:38:11 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:59735 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaDORiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:38:03 -0400
Date: Tue, 15 Apr 2014 11:37:58 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
        Daniel J Blueman <daniel@quora.org>, linux-pci@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v2 12/14] pci: Suspend/resume support for appel
 thunderbolt
Message-ID: <20140415173758.GG16058@google.com>
References: <1397175901-4023-1-git-send-email-andreas.noever@gmail.com>
 <1397175901-4023-13-git-send-email-andreas.noever@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397175901-4023-13-git-send-email-andreas.noever@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Rafael]

On Fri, Apr 11, 2014 at 02:24:59AM +0200, Andreas Noever wrote:
> This patch makes changes to the pcieport driver to support thunderbolt
> suspend/resume on apple systems. We need to perform two different
> actions during suspend and resume:
> 
> The whole controller has to be powered down before suspend. If this is
> not done then the NHI device will be gone after resume if a thunderbolt
> device was plugged in while suspending. The controller represents itself
> as multiple PCI devices/bridges. To power it down we hook into the
> upstream bridge of the controller and call the magic ACPI methods. Power
> will be restored automatically during resume (by the firmware
> presumably).
> 
> During resume we have to wait for the NHI do reestablish all pci
> tunnels. Since there is no parent-child relationship between the NHI
> and the bridges we have to explicitly wait for them using
> device_pm_wait_for_dev. We do this in the resume_noirq phase of the
> downstream bridges of the controller (which lead into the thunderbolt
> tunnels).
> 
> Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
> ---
>  drivers/pci/pcie/portdrv_pci.c | 117 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 117 insertions(+)
> 
> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
> index 0d8fdc4..6d33666 100644
> --- a/drivers/pci/pcie/portdrv_pci.c
> +++ b/drivers/pci/pcie/portdrv_pci.c
> @@ -17,6 +17,9 @@
>  #include <linux/aer.h>
>  #include <linux/dmi.h>
>  #include <linux/pci-aspm.h>
> +#include <linux/delay.h>
> +#include <linux/dmi.h>
> +#include <linux/acpi.h>
>  
>  #include "portdrv.h"
>  #include "aer/aerdrv.h"
> @@ -79,6 +82,114 @@ static int pcie_portdrv_restore_config(struct pci_dev *dev)
>  }
>  
>  #ifdef CONFIG_PM
> +
> +#if defined(CONFIG_THUNDERBOLT) || defined(CONFIG_THUNDERBOLT_MODULE)
> +
> +bool is_thunderbolt(struct pci_dev *pdev)
> +{
> +	if (!dmi_match(DMI_PRODUCT_NAME, "MacBookPro10,1"))
> +		return false;
> +	return pdev->vendor == PCI_VENDOR_ID_INTEL && pdev->device == 0x1547;
> +}
> +
> +static void shutdown_thunderbolt_controller(struct pci_dev *pdev)
> +{
> +	/*
> +	 * The thunderbolt controller consists of a pcie switch with downstream
> +	 * bridges leading to the NHI (native host interface) and to the tunnel
> +	 * pci bridges.
> +	 *
> +	 * Without the following quirk the NHI will not resume if a tb device was
> +	 * plugged in before suspend.
> +	 *
> +	 * This quirk cuts power to the whole chip. Therefore we have to apply it
> +	 * during suspend_noirq of the upstream bridge.
> +	 *
> +	 * Power is automagically restored before resume. No action is needed.
> +	 */
> +	acpi_handle bridge, SXIO, SXFP, SXLV;
> +	if (!is_thunderbolt(pdev))
> +		return;
> +	if (pci_pcie_type(pdev) != PCI_EXP_TYPE_UPSTREAM)
> +		return;
> +	bridge = ACPI_HANDLE(&pdev->dev);
> +	if (!bridge)
> +		return;
> +	/*
> +	 * TB bridges in external devices might have the same device id as those
> +	 * on the host, but they will not have the associated ACPI methods. This
> +	 * implicitly checks that we are at the right bridge.
> +	 */
> +	if (ACPI_FAILURE(acpi_get_handle(bridge, "DSB0.NHI0.SXIO", &SXIO))
> +		|| ACPI_FAILURE(acpi_get_handle(bridge, "DSB0.NHI0.SXFP", &SXFP))
> +		|| ACPI_FAILURE(acpi_get_handle(bridge, "DSB0.NHI0.SXLV", &SXLV)))
> +		return;

Hmm, this is pretty ugly because the ACPI names are up to the BIOS writer
so we can't really rely on them.

You could put this sort of thing in a quirk, but I wouldn't be happy
about putting it in a generic place like this.  Same with the magic
sequence below.

Maybe a quirk that sets function pointers that we could call here?

> +	dev_info(&pdev->dev, "cutting power to thunderbolt controller...\n");
> +
> +	/* save registers manually, the pci core won't be able to do later */
> +	pci_save_state(pdev);
> +	pci_prepare_to_sleep(pdev);
> +
> +	/* magic sequence */
> +	acpi_execute_simple_method(SXIO, NULL, 1);
> +	acpi_execute_simple_method(SXFP, NULL, 0);
> +	msleep(300);
> +	acpi_execute_simple_method(SXLV, NULL, 0);
> +	acpi_execute_simple_method(SXIO, NULL, 0);
> +	acpi_execute_simple_method(SXLV, NULL, 0);
> +}
> +
> +static void wait_for_thunderbolt_controller(struct pci_dev *pdev)
> +{
> +	struct pci_dev *sibling = NULL;
> +	struct pci_dev *nhi = NULL;
> +	/*
> +	 * During suspend the thunderbolt controller is reset and all pci
> +	 * tunnels are lost. The NHI driver will try to reestablish all tunnels
> +	 * during resume. We have to manually wait for the NHI since there is
> +	 * no parent child relationship between the NHI and the tunneled
> +	 * bridges.
> +	 */
> +	if (!is_thunderbolt(pdev))
> +		return;
> +	if (pci_pcie_type(pdev) != PCI_EXP_TYPE_DOWNSTREAM)
> +		return;
> +	/*
> +	 * Find the NHI and confirm that we are a bridge on the tb host
> +	 * controller and not on a tb endpoint.
> +	 */
> +	sibling = pci_get_slot(pdev->bus, 0x0);
> +	if (sibling == pdev)
> +		goto out; /* we are the downstream bridge to the NHI */
> +	if (!sibling || !sibling->subordinate)
> +		goto out;
> +	nhi = pci_get_slot(sibling->subordinate, 0x0);
> +	if (!nhi)
> +		goto out;
> +	if (nhi->vendor != PCI_VENDOR_ID_INTEL || nhi->device != 0x1547
> +			|| nhi->subsystem_vendor != 0x2222
> +			|| nhi->subsystem_device != 0x1111)
> +		goto out;
> +	dev_info(&pdev->dev, "wating for thunderbolt to reestablish pci tunnels...\n");
> +	device_pm_wait_for_dev(&pdev->dev, &nhi->dev);
> +out:
> +	pci_dev_put(sibling);
> +	pci_dev_put(nhi);
> +}
> +
> +#else
> +
> +static void shutdown_thunderbolt_controller(struct pci_dev *pdev) { }
> +static void wait_for_thunderbolt_controller(struct pci_dev *pdev) { }
> +
> +#endif
> +
> +int pcie_port_suspend_noirq(struct device *dev)
> +{
> +	shutdown_thunderbolt_controller(to_pci_dev(dev));
> +	return 0;
> +}
> +
>  static int pcie_port_resume_noirq(struct device *dev)
>  {
>  	struct pci_dev *pdev = to_pci_dev(dev);
> @@ -90,6 +201,9 @@ static int pcie_port_resume_noirq(struct device *dev)
>  	 */
>  	if (pci_pcie_type(pdev) == PCI_EXP_TYPE_ROOT_PORT)
>  		pcie_clear_root_pme_status(pdev);
> +
> +	wait_for_thunderbolt_controller(pdev);
> +
>  	return 0;
>  }
>  
> @@ -171,7 +285,10 @@ static const struct dev_pm_ops pcie_portdrv_pm_ops = {
>  	.thaw		= pcie_port_device_resume,
>  	.poweroff	= pcie_port_device_suspend,
>  	.restore	= pcie_port_device_resume,
> +	.suspend_noirq  = pcie_port_suspend_noirq,
>  	.resume_noirq	= pcie_port_resume_noirq,
> +	.poweroff_noirq = pcie_port_suspend_noirq,
> +	.restore_noirq  = pcie_port_resume_noirq,
>  	.runtime_suspend = pcie_port_runtime_suspend,
>  	.runtime_resume = pcie_port_runtime_resume,
>  	.runtime_idle	= pcie_port_runtime_idle,
> -- 
> 1.9.2
> 
