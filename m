Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab3C0W5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 18:57:00 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:38018 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922Ab3C0W45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 18:56:57 -0400
MIME-Version: 1.0
In-Reply-To: <1363628226-6679-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQXmeb66dc8fET0y99BjqpUXp11c7utiQ5keR1Wf+N9xaA@mail.gmail.com>
 <1363628226-6679-1-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 27 Mar 2013 16:56:37 -0600
Message-ID: <CAErSpo6v0mj9=Q13d=G4hho0mb9XTcsmefzke9fROYmZ7oBWxQ@mail.gmail.com>
Subject: Re: [PATCH] PCI: Remove not needed check in disable aspm link
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 11:37 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> Roman reported ath5k does not work anymore on 3.8.
> Bisected to
> | commit 8c33f51df406e1a1f7fa4e9b244845b7ebd61fa6
> | Author: Taku Izumi <izumi.taku@jp.fujitsu.com>
> | Date:   Tue Oct 30 15:27:13 2012 +0900
> |
> |    PCI/ACPI: Request _OSC control before scanning PCI root bus
> |
> |    This patch moves up the code block to request _OSC control in order to
> |    separate ACPI work and PCI work in acpi_pci_root_add().
>
> It make pci_disable_link_state does not work anymore as acpi_disabled
> is set before pci root bus scanning.
> It will skip that in quirks and pcie_aspm_sanity_check.
>
> We could revert to old logic, but that will make booting path and hotplug
> path with different aspm_disabled again.
>
> Acctually we don't need to check aspm_disabled in disable link, as
> we already have protection about link state following.
>
> https://bugzilla.kernel.org/show_bug.cgi?id=55211
> http://article.gmane.org/gmane.linux.kernel.pci/20640
>
> Need it for 3.8 stable.
>
> Reported-by: Roman Yepishev <roman.yepishev@gmail.com>
> Bisected-by: Roman Yepishev <roman.yepishev@gmail.com>
> Tested-by: Roman Yepishev <roman.yepishev@gmail.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
> Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> Cc: stable@kernel.org
>
> ---
>  drivers/pci/pcie/aspm.c |   21 ++++-----------------
>  1 file changed, 4 insertions(+), 17 deletions(-)
>
> Index: linux-2.6/drivers/pci/pcie/aspm.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pcie/aspm.c
> +++ linux-2.6/drivers/pci/pcie/aspm.c
> @@ -493,15 +493,6 @@ static int pcie_aspm_sanity_check(struct
>                         return -EINVAL;
>
>                 /*
> -                * If ASPM is disabled then we're not going to change
> -                * the BIOS state. It's safe to continue even if it's a
> -                * pre-1.1 device
> -                */
> -
> -               if (aspm_disabled)
> -                       continue;
> -
> -               /*
>                  * Disable ASPM for pre-1.1 PCIe device, we follow MS to use
>                  * RBER bit to determine if a function is 1.1 version device
>                  */
> @@ -718,15 +709,11 @@ void pcie_aspm_powersave_config_link(str
>   * pci_disable_link_state - disable pci device's link state, so the link will
>   * never enter specific states
>   */
> -static void __pci_disable_link_state(struct pci_dev *pdev, int state, bool sem,
> -                                    bool force)
> +static void __pci_disable_link_state(struct pci_dev *pdev, int state, bool sem)
>  {
>         struct pci_dev *parent = pdev->bus->self;
>         struct pcie_link_state *link;
>
> -       if (aspm_disabled && !force)
> -               return;
> -
>         if (!pci_is_pcie(pdev))
>                 return;
>
> @@ -757,13 +744,13 @@ static void __pci_disable_link_state(str
>
>  void pci_disable_link_state_locked(struct pci_dev *pdev, int state)
>  {
> -       __pci_disable_link_state(pdev, state, false, false);
> +       __pci_disable_link_state(pdev, state, false);
>  }
>  EXPORT_SYMBOL(pci_disable_link_state_locked);
>
>  void pci_disable_link_state(struct pci_dev *pdev, int state)
>  {
> -       __pci_disable_link_state(pdev, state, true, false);
> +       __pci_disable_link_state(pdev, state, true);
>  }
>  EXPORT_SYMBOL(pci_disable_link_state);
>
> @@ -781,7 +768,7 @@ void pcie_clear_aspm(struct pci_bus *bus
>                 __pci_disable_link_state(child, PCIE_LINK_STATE_L0S |
>                                          PCIE_LINK_STATE_L1 |
>                                          PCIE_LINK_STATE_CLKPM,
> -                                        false, true);
> +                                        false);
>         }
>  }
>

This might fix the problem, but the code is still a mess.  In
acpi_pci_root_add(), why do we have the following?

    acpi_pci_root_add

      acpi_pci_osc_support
      if (flags != base_flags)
        pcie_no_aspm
      if (...)
        acpi_pci_osc_control_set
        if (ACPI_SUCCESS)
          is_osc_granted = true

      pci_acpi_scan_root

      if (is_osc_granted)
        if (acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_ASPM)
          pcie_clear_aspm
      else
        pcie_no_aspm

Why can't we set all the ASPM flags *first*, before calling
pci_acpi_scan_root()?  That way we could just do the correct ASPM
setup as we discover devices during enumeration, rather than trying to
fix things up afterwards.  I suspect pcie_clear_aspm() is broken
anyway, because it looks like it only touches one level of the
hierarchy, without recursively descending it.

But Taku went to some trouble in 8c33f51d to introduce is_osc_granted
to remember this until after pci_acpi_scan_root(), so presumably
there's some reason for this.  Do you remember why, Taku?

Bjorn
