Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289Ab3DCWi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 18:38:27 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:38324 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759246Ab3DCWiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 18:38:24 -0400
MIME-Version: 1.0
In-Reply-To: <2699206.HmPyNvCpNR@vostro.rjw.lan>
References: <2282655.IicBMMa6jN@vostro.rjw.lan> <1396732.fV788D0xgr@vostro.rjw.lan>
 <2699206.HmPyNvCpNR@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 3 Apr 2013 16:38:03 -0600
Message-ID: <CAErSpo4DLswMWVRXUhXx6VcVk27YXpqjbNsnTF4jGv7eunv5hg@mail.gmail.com>
Subject: Re: [Update][PATCH] PCI / ACPI: Always resume devices on ACPI wakeup notifications
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 3:07 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: PCI / ACPI: Always resume devices on ACPI wakeup notifications
>
> It turns out that the _Lxx control methods provided by some BIOSes
> clear the PME Status bit of PCI devices they handle, which means that
> pci_acpi_wake_dev() cannot really use that bit to check whether or
> not the device has signalled wakeup.
>
> One symptom of the problem is, for example, that when an affected PCI
> USB controller is runtime-suspended, then plugging in a new USB device
> into one of the controller's ports will not wake up the controller,
> which should happen.
>
> For this reason, make pci_acpi_wake_dev() always attempt to resume
> the device it is called for regardless of the device's PME Status bit
> value (that bit still has to be cleared if set at this point,
> though).
>
> Reported-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Acked-by: Matthew Garrett <mjg59@srcf.ucam.org>
> Cc: 3.7+ <stable@vger.kernel.org>
> ---
>
> The changelog in this version is slightly better than in the previous one, IMHO.

I applied this to for-linus for v3.9.  Thanks!

> ---
>  drivers/pci/pci-acpi.c |   15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>
> Index: linux-pm/drivers/pci/pci-acpi.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/pci-acpi.c
> +++ linux-pm/drivers/pci/pci-acpi.c
> @@ -53,14 +53,15 @@ static void pci_acpi_wake_dev(acpi_handl
>                 return;
>         }
>
> -       if (!pci_dev->pm_cap || !pci_dev->pme_support
> -            || pci_check_pme_status(pci_dev)) {
> -               if (pci_dev->pme_poll)
> -                       pci_dev->pme_poll = false;
> +       /* Clear PME Status if set. */
> +       if (pci_dev->pme_support)
> +               pci_check_pme_status(pci_dev);
>
> -               pci_wakeup_event(pci_dev);
> -               pm_runtime_resume(&pci_dev->dev);
> -       }
> +       if (pci_dev->pme_poll)
> +               pci_dev->pme_poll = false;
> +
> +       pci_wakeup_event(pci_dev);
> +       pm_runtime_resume(&pci_dev->dev);
>
>         if (pci_dev->subordinate)
>                 pci_pme_wakeup_bus(pci_dev->subordinate);
>
