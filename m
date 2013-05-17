Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3EQXn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 19:43:56 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:59458 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab3EQXny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 19:43:54 -0400
MIME-Version: 1.0
In-Reply-To: <F7B8FD780A346D46A0042F5C63B06AE785E3B2@SHSMSX102.ccr.corp.intel.com>
References: <F7B8FD780A346D46A0042F5C63B06AE785E3B2@SHSMSX102.ccr.corp.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 17 May 2013 17:43:33 -0600
Message-ID: <CAErSpo7+AbHi_TwxwHTJunpFb=CMhwMdCni6+NjbhdA=35XhvA@mail.gmail.com>
Subject: Re: Subject : [ PATCH ] pci-reset-error_state-to-pci_channel_io_normal-at-report_slot_reset
To: "Zhang, LongX" <longx.zhang@intel.com>
Cc: "linasvepstas@gmail.com" <linasvepstas@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        "Joseph.Liu@Emulex.Com" <Joseph.Liu@emulex.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Rafael because he knows about dev->state_saved]

Sorry, I'm not very familiar with AER, so please excuse some naive
questions below.

On Fri, Apr 26, 2013 at 12:28 AM, Zhang, LongX <longx.zhang@intel.com> wrote:
> From: Zhang Long <longx.zhang@intel.com>
>
> Specific pci device drivers might have many functions to call
> pci_channel_offline to check device states. When slot_reset happens,
> drivers' slot_reset callback might call such functions and eventually
> abort the reset.

Where does this happen?  I looked at all the references to
dev->error_state and all the callers of pci_channel_offline(), and I
didn't see any in .slot_reset() methods.

(There are *assignments* to dev->error_state in qlcnic_attach_func(),
qlge_io_slot_reset(), and qla2xxx_pci_slot_reset().  You might be able
to remove those assignments after this patch, but this patch wouldn't
really change anything for those paths.)

> The patch resets pdev->error_state to pci_channel_io_normal at
> the begining of report_slot_reset.

> Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
> Signed-off-by: Zhang Long <longx.zhang@intel.com>
> ---
>  drivers/pci/pcie/aer/aerdrv_core.c |    1 +
>  drivers/pci/pcie/portdrv_pci.c     |   12 +++++-------
>  2 files changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
> index 564d97f..c61fd44 100644
> --- a/drivers/pci/pcie/aer/aerdrv_core.c
> +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> @@ -286,6 +286,7 @@ static int report_slot_reset(struct pci_dev *dev, void *data)
>         result_data = (struct aer_broadcast_data *) data;
>
>         device_lock(&dev->dev);
> +       dev->error_state = pci_channel_io_normal;

The device's error_state might be pci_channel_io_frozen when we get
here.  We haven't touched anything in the hardware yet.  What makes
the device unfrozen now?  Did anything actually change as far as the
hardware device is concerned?

I agree it looks like report_slot_reset() should be made more like
eeh_report_reset().  I'm just wondering if the error_state should be
changed *after* calling the .slot_reset() method instead of before.

>         if (!dev->driver ||
>                 !dev->driver->err_handler ||
>                 !dev->driver->err_handler->slot_reset)
> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
> index ed4d094..7abefd9 100644
> --- a/drivers/pci/pcie/portdrv_pci.c
> +++ b/drivers/pci/pcie/portdrv_pci.c
> @@ -332,13 +332,11 @@ static pci_ers_result_t pcie_portdrv_slot_reset(struct pci_dev *dev)
>         pci_ers_result_t status = PCI_ERS_RESULT_RECOVERED;
>         int retval;
>
> -       /* If fatal, restore cfg space for possible link reset at upstream */
> -       if (dev->error_state == pci_channel_io_frozen) {
> -               dev->state_saved = true;
> -               pci_restore_state(dev);
> -               pcie_portdrv_restore_config(dev);
> -               pci_enable_pcie_error_reporting(dev);
> -       }

Previously we only restored state for the pci_channel_io_frozen state,
i.e., when handling an AER_FATAL error.  Now we restore it always.
Why?

> +       /* restore cfg space for possible link reset at upstream */
> +       dev->state_saved = true;

"dev->state_saved == true" means that the dev->saved_config_space
contains valid data.  Why do we know that's the case here?  I see that
pcie_portdrv_probe() calls pci_save_state() when we first claim the
port, and I guess we're assuming the state saved then is still valid.
But why do we need to actually set dev->state_saved here?  Shouldn't
it be already set to true anyway?

> +       pci_restore_state(dev);
> +       pcie_portdrv_restore_config(dev);
> +       pci_enable_pcie_error_reporting(dev);
>
>         /* get true return value from &status */
>         retval = device_for_each_child(&dev->dev, &status, slot_reset_iter);
> --
> 1.7.4.1
>
>
>
