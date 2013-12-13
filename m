Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab3LMWfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:35:40 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:49417 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab3LMWff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:35:35 -0500
MIME-Version: 1.0
In-Reply-To: <1386949306-30601-1-git-send-email-betty.dall@hp.com>
References: <1386949306-30601-1-git-send-email-betty.dall@hp.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 13 Dec 2013 15:35:15 -0700
Message-ID: <CAErSpo4tswv8PHGOQDviFj6Rc7QMYkWQ5rhMCFmHZFL9jM6oBQ@mail.gmail.com>
Subject: Re: [PATCH] PCI AER: handle pci_cleanup_aer_uncorrect_error_status()
 in firmware first mode
To: Betty Dall <betty.dall@hp.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 8:41 AM, Betty Dall <betty.dall@hp.com> wrote:
> There are three functions exported from aerdrv_core.c that could be
> called when the system is in firmware first mode:
> pci_enable_pcie_error_reporting(), pci_disable_pcie_error_reporting, and
> pci_cleanup_aer_uncorrect_error_status(). The first two functions check if
> we are in firmware first mode and return immediately.
> pci_cleanup_aer_uncorrect_error_status() does not check firmware first
> mode. The problem is that all of these functions should not access the AER
> registers in firmware first mode because the firmware has not granted OS
> control of the AER registers through the _OSC.

This looks like a good fix to me.  If I read aer_acpi_firmware_first()
correctly, we don't even *ask* for control of AER if
ACPI_HEST_FIRMWARE_FIRST appears anywhere in the HEST.  Does that
match your understanding?

> Many drivers call this
> function in their pci_error_handlers in firmware first mode.

Drivers don't have any idea whether their device is in firmware-first
mode, do they?

> The fix is to change pci_cleanup_aer_uncorrect_error_status() to check
> firmware first mode before accessing the AER registers. If it is in firmware
> first mode, return 0. I considered returning -EIO, but decided the status
> has been cleaned up appropriately for firmware first. Returning 0 also avoids
> an error message. Not many places check the return of this function, and the
> ones that do, print an error message and continue such as:
>    err = pci_cleanup_aer_uncorrect_error_status(pdev);
>    if (err) {
>        dev_err(&pdev->dev,
>            "pci_cleanup_aer_uncorrect_error_status failed 0x%0x\n",
>             err); /* non-fatal, continue */
>    }
> That error message is how I found this problem, and it is not applicable
> for the firmware first recovery path.

I'm curious -- did you find this problem because you saw a message
when pci_cleanup_aer_uncorrect_error_status() returned failure?  The
only way it can return failure is if there is no AER capability, and
that should be completely independent of whether we're in
firmware-first mode.

> Signed-off-by: Betty Dall <betty.dall@hp.com>
> ---
>
>  drivers/pci/pcie/aer/aerdrv_core.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
>
> diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
> index b2c8881..1f60408 100644
> --- a/drivers/pci/pcie/aer/aerdrv_core.c
> +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> @@ -62,6 +62,9 @@ int pci_cleanup_aer_uncorrect_error_status(struct pci_dev *dev)
>         int pos;
>         u32 status;
>
> +       if (pcie_aer_get_firmware_first(dev))
> +               return 0;
> +
>         pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
>         if (!pos)
>                 return -EIO;
