Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3ISUvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 16:51:38 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:63524 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab3ISUvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 16:51:36 -0400
MIME-Version: 1.0
In-Reply-To: <4974289.QhzOmFXm0s@vostro.rjw.lan>
References: <4974289.QhzOmFXm0s@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 19 Sep 2013 14:51:15 -0600
Message-ID: <CAErSpo6ztY=Hd42UUi=KZvN62+9fd4BmyGafLDqfvwp9NxhrYw@mail.gmail.com>
Subject: Re: [PATCH] PCI / ACPI / PM: Clear pme_poll for devices in D3cold on wakeup
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Huang Ying <ying.huang@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "David E. Box" <david.e.box@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 7:38 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> Commit 448bd85 (PCI/PM: add PCIe runtime D3cold support) added a
> piece of code to pci_acpi_wake_dev() causing that function to behave
> in a special way for devices in D3cold (so that their configuration
> registeres are not accessed before those devices are resumed).

s/registeres/registers/

> However, it didn't take the clearing of the pme_poll flag into
> account.  That has to be done for all devices, even if they are in
> D3cold, or pci_pme_list_scan() will not know that wakeup has been
> signaled for the device and will poll its PME Status bit
> unnecessarily.
>
> Fix the problem by moving the clearing of the pme_poll flag in
> pci_acpi_wake_dev() before the code introduced by commit 448bd85.
>
> Reported-and-tested-by: David E. Box <david.e.box@intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> Cc: 3.6+ <stable@vger.kernel.org> # 3.6+
> ---
>  drivers/pci/pci-acpi.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> Index: linux-pm/drivers/pci/pci-acpi.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/pci-acpi.c
> +++ linux-pm/drivers/pci/pci-acpi.c
> @@ -47,6 +47,9 @@ static void pci_acpi_wake_dev(acpi_handl
>         if (event != ACPI_NOTIFY_DEVICE_WAKE || !pci_dev)
>                 return;
>
> +       if (pci_dev->pme_poll)
> +               pci_dev->pme_poll = false;
> +
>         if (pci_dev->current_state == PCI_D3cold) {
>                 pci_wakeup_event(pci_dev);
>                 pm_runtime_resume(&pci_dev->dev);
> @@ -57,9 +60,6 @@ static void pci_acpi_wake_dev(acpi_handl
>         if (pci_dev->pme_support)
>                 pci_check_pme_status(pci_dev);
>
> -       if (pci_dev->pme_poll)
> -               pci_dev->pme_poll = false;
> -
>         pci_wakeup_event(pci_dev);
>         pm_runtime_resume(&pci_dev->dev);
>
>
