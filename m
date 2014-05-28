Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbaE1Wnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 18:43:45 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:35836 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbaE1Wnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 18:43:43 -0400
Date: Wed, 28 May 2014 16:43:40 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>,
        Greg KH <greg@kroah.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 13/15] pci: Suspend/resume quirks for appel thunderbolt
Message-ID: <20140528224340.GZ11907@google.com>
References: <1401117492-2870-1-git-send-email-andreas.noever@gmail.com>
 <1401117492-2870-14-git-send-email-andreas.noever@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401117492-2870-14-git-send-email-andreas.noever@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 05:18:10PM +0200, Andreas Noever wrote:

Please change subject:

  pci: Suspend/resume quirks for appel thunderbolt

to (note "appel" typo fix):

  PCI: Suspend/resume quirks for Apple thunderbolt

> Add two quirks to support thunderbolt suspend/resume on apple systems.

s/apple/Apple/

> We need to perform two different actions during suspend and resume:
> 
> The whole controller has to be powered down before suspend. If this is
> not done then the NHI device will be gone after resume if a thunderbolt

Please expand "NHI."  I assume it stands for "Native Host Interface."

> device was plugged in while suspending. The controller represents itself

s/while suspending/while suspended/ (I assume)

> as multiple PCI devices/bridges. To power it down we hook into the
> upstream bridge of the controller and call the magic ACPI methods.
> Power will be restored automatically during resume (by the firmware
> presumably).
> 
> During resume we have to wait for the NHI do reestablish all pci

s/do/to/

> tunnels. Since there is no parent-child relationship between the NHI and
> the bridges we have to explicitly wait for them using
> device_pm_wait_for_dev. We do this in the resume_noirq phase of the
> downstream bridges of the controller (which lead into the thunderbolt
> tunnels).
> 
> Signed-off-by: Andreas Noever <andreas.noever@gmail.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Trivial comments below.  Ack applies whether you change them or not.

> ---
>  drivers/pci/quirks.c | 122 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 122 insertions(+)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index af2eba1..e010340 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -2992,6 +2992,128 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_CHELSIO, 0x0030,
>  DECLARE_PCI_FIXUP_HEADER(0x1814, 0x0601, /* Ralink RT2800 802.11n PCI */
>  			 quirk_broken_intx_masking);
>  
> +/* Apple systems with a Cactus Ridge Thunderbolt controller. */
> +static struct dmi_system_id apple_thunderbolt_whitelist[] = {
> +	{
> +		.matches = {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro9"),
> +		},
> +	},
> +	{
> +		.matches = {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro10"),
> +		},
> +	},
> +	{
> +		.matches = {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir5"),
> +		},
> +	},
> +	{
> +		.matches = {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir6"),
> +		},
> +	},
> +	{ }
> +};
> +
> +/*
> + * Apple: Shutdown Cactus Ridge Thunderbolt controller.
> + *
> + * On Apple hardware the Cactus Ridge Thunderbolt controller needs to be
> + * shutdown before suspend. Otherwise the native host interface (NHI) will not
> + * be present after resume if a device was plugged in before suspend.
> + *
> + * The thunderbolt controller consists of a pcie switch with downstream
> + * bridges leading to the NHI and to the tunnel pci bridges.
> + *
> + * This quirk cuts power to the whole chip. Therefore we have to apply it
> + * during suspend_noirq of the upstream bridge.
> + *
> + * Power is automagically restored before resume. No action is needed.
> + */
> +static void quirk_apple_poweroff_thunderbolt(struct pci_dev *dev)
> +{
> +#ifdef CONFIG_ACPI

Why not put the #ifdef around the whole thing, including the entire
function definition and the DECLARE_PCI_FIXUP...?  It doesn't seem useful
to compile a quirk that does nothing.

> +	acpi_handle bridge, SXIO, SXFP, SXLV;

A blank line is conventional here.

> +	if (!dmi_check_system(apple_thunderbolt_whitelist))
> +		return;
> +	if (pci_pcie_type(dev) != PCI_EXP_TYPE_UPSTREAM)
> +		return;
> +	bridge = ACPI_HANDLE(&dev->dev);
> +	if (!bridge)
> +		return;
> +	/*
> +	 * TB bridges in external devices might have the same device id as those
> +	 * on the host, but they will not have the associated ACPI methods. This
> +	 * implicitly checks that we are at the right bridge.
> +	 */
> +	if (ACPI_FAILURE(acpi_get_handle(bridge, "DSB0.NHI0.SXIO", &SXIO))
> +	    || ACPI_FAILURE(acpi_get_handle(bridge, "DSB0.NHI0.SXFP", &SXFP))
> +	    || ACPI_FAILURE(acpi_get_handle(bridge, "DSB0.NHI0.SXLV", &SXLV)))
> +		return;
> +	dev_info(&dev->dev, "quirk: cutting power to thunderbolt controller...\n");
> +
> +	/* magic sequence */
> +	acpi_execute_simple_method(SXIO, NULL, 1);
> +	acpi_execute_simple_method(SXFP, NULL, 0);
> +	msleep(300);
> +	acpi_execute_simple_method(SXLV, NULL, 0);
> +	acpi_execute_simple_method(SXIO, NULL, 0);
> +	acpi_execute_simple_method(SXLV, NULL, 0);
> +#endif
> +}
> +DECLARE_PCI_FIXUP_SUSPEND_LATE(PCI_VENDOR_ID_INTEL, 0x1547,
> +			       quirk_apple_poweroff_thunderbolt);
> +
> +/*
> + * Apple: Wait for the thunderbolt controller to reestablish pci tunnels.
> + *
> + * During suspend the thunderbolt controller is reset and all pci
> + * tunnels are lost. The NHI driver will try to reestablish all tunnels
> + * during resume. We have to manually wait for the NHI since there is
> + * no parent child relationship between the NHI and the tunneled
> + * bridges.
> + */
> +static void quirk_apple_wait_for_thunderbolt(struct pci_dev *dev)
> +{
> +#ifdef CONFIG_ACPI
> +	struct pci_dev *sibling = NULL;
> +	struct pci_dev *nhi = NULL;

Blank line.

> +	if (!dmi_check_system(apple_thunderbolt_whitelist))
> +		return;
> +	if (pci_pcie_type(dev) != PCI_EXP_TYPE_DOWNSTREAM)
> +		return;
> +	/*
> +	 * Find the NHI and confirm that we are a bridge on the tb host
> +	 * controller and not on a tb endpoint.
> +	 */
> +	sibling = pci_get_slot(dev->bus, 0x0);
> +	if (sibling == dev)
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
> +	dev_info(&dev->dev, "quirk: wating for thunderbolt to reestablish pci tunnels...\n");
> +	device_pm_wait_for_dev(&dev->dev, &nhi->dev);
> +out:
> +	pci_dev_put(nhi);
> +	pci_dev_put(sibling);
> +#endif
> +}
> +DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL, 0x1547,
> +			       quirk_apple_wait_for_thunderbolt);
> +
>  static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
>  			  struct pci_fixup *end)
>  {
> -- 
> 1.9.3
> 
