Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668AbaLAWv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:51:27 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:60377 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932577AbaLAWvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:51:25 -0500
MIME-Version: 1.0
In-Reply-To: <1665071.LpcEGj9O01@vostro.rjw.lan>
References: <37310416.jZXoh5nfSC@vostro.rjw.lan> <2582138.zUe2QZynBg@vostro.rjw.lan>
 <1665071.LpcEGj9O01@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 1 Dec 2014 15:51:04 -0700
Message-ID: <CAErSpo7taxQy=TNoe0eJ6oBpJxdmPNZtJ+Cuy8KxFvoWFLHCKA@mail.gmail.com>
Subject: Re: [Update][PATCH 4/4] PCI / PM: Drop CONFIG_PM_RUNTIME from the PCI core
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 3:41 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: PCI / PM: Drop CONFIG_PM_RUNTIME from the PCI core
>
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so quite a few
> #ifdef blocks depending on CONFIG_PM_RUNTIME may now be changed to
> depend on CONFIG_PM.
>
> Replace CONFIG_PM_RUNTIME with CONFIG_PM in the PCI core code.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

I acked this on IRC, and I think Rafael plans to merge this via his
tree, but for the archives:

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>
> Changelog fixup.
>
> ---
>  drivers/pci/pci-driver.c |   20 +++++++-------------
>  drivers/pci/pci-sysfs.c  |    4 ++--
>  drivers/pci/pcie/Kconfig |    2 +-
>  3 files changed, 10 insertions(+), 16 deletions(-)
>
> Index: linux-pm/drivers/pci/pcie/Kconfig
> ===================================================================
> --- linux-pm.orig/drivers/pci/pcie/Kconfig
> +++ linux-pm/drivers/pci/pcie/Kconfig
> @@ -79,4 +79,4 @@ endchoice
>
>  config PCIE_PME
>         def_bool y
> -       depends on PCIEPORTBUS && PM_RUNTIME
> +       depends on PCIEPORTBUS && PM
> Index: linux-pm/drivers/pci/pci-driver.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/pci-driver.c
> +++ linux-pm/drivers/pci/pci-driver.c
> @@ -1104,7 +1104,7 @@ static int pci_pm_restore(struct device
>
>  #endif /* !CONFIG_HIBERNATE_CALLBACKS */
>
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>
>  static int pci_pm_runtime_suspend(struct device *dev)
>  {
> @@ -1200,16 +1200,6 @@ static int pci_pm_runtime_idle(struct de
>         return ret;
>  }
>
> -#else /* !CONFIG_PM_RUNTIME */
> -
> -#define pci_pm_runtime_suspend NULL
> -#define pci_pm_runtime_resume  NULL
> -#define pci_pm_runtime_idle    NULL
> -
> -#endif /* !CONFIG_PM_RUNTIME */
> -
> -#ifdef CONFIG_PM
> -
>  static const struct dev_pm_ops pci_dev_pm_ops = {
>         .prepare = pci_pm_prepare,
>         .suspend = pci_pm_suspend,
> @@ -1231,11 +1221,15 @@ static const struct dev_pm_ops pci_dev_p
>
>  #define PCI_PM_OPS_PTR (&pci_dev_pm_ops)
>
> -#else /* !COMFIG_PM_OPS */
> +#else /* !CONFIG_PM */
> +
> +#define pci_pm_runtime_suspend NULL
> +#define pci_pm_runtime_resume  NULL
> +#define pci_pm_runtime_idle    NULL
>
>  #define PCI_PM_OPS_PTR NULL
>
> -#endif /* !COMFIG_PM_OPS */
> +#endif /* !CONFIG_PM */
>
>  /**
>   * __pci_register_driver - register a new pci driver
> Index: linux-pm/drivers/pci/pci-sysfs.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/pci-sysfs.c
> +++ linux-pm/drivers/pci/pci-sysfs.c
> @@ -385,7 +385,7 @@ static ssize_t dev_bus_rescan_store(stru
>  }
>  static DEVICE_ATTR(rescan, (S_IWUSR|S_IWGRP), NULL, dev_bus_rescan_store);
>
> -#if defined(CONFIG_PM_RUNTIME) && defined(CONFIG_ACPI)
> +#if defined(CONFIG_PM) && defined(CONFIG_ACPI)
>  static ssize_t d3cold_allowed_store(struct device *dev,
>                                     struct device_attribute *attr,
>                                     const char *buf, size_t count)
> @@ -566,7 +566,7 @@ static struct attribute *pci_dev_attrs[]
>         &dev_attr_enable.attr,
>         &dev_attr_broken_parity_status.attr,
>         &dev_attr_msi_bus.attr,
> -#if defined(CONFIG_PM_RUNTIME) && defined(CONFIG_ACPI)
> +#if defined(CONFIG_PM) && defined(CONFIG_ACPI)
>         &dev_attr_d3cold_allowed.attr,
>  #endif
>  #ifdef CONFIG_OF
>
