Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab3ARRgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 12:36:13 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:33939 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab3ARRgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 12:36:09 -0500
MIME-Version: 1.0
In-Reply-To: <1358525267-14268-8-git-send-email-jiang.liu@huawei.com>
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com> <1358525267-14268-8-git-send-email-jiang.liu@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 18 Jan 2013 10:35:46 -0700
Message-ID: <CAErSpo6E0SrY8_JOU6pmrCt9opfKe_jJ6b0E0daNAbpX5KtFuQ@mail.gmail.com>
Subject: Re: [RFC PATCH v5 7/8] PCI/PCIe: add "pci=nopciehp" to disable PCIe
 native hotplug
To: Jiang Liu <liuj97@gmail.com>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>, Jiang Liu <jiang.liu@huawei.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 9:07 AM, Jiang Liu <liuj97@gmail.com> wrote:
> If user specifies "pci=nopciehp" on kernel boot command line, OSPM
> won't claim PCIe native hotplug service from firmware and no PCIe
> port devices will be created for PCIe native hotplug service.

Why do we need this option?

If I understand correctly, there are machines where it *looks* like we
should use pciehp, but pciehp doesn't work because we don't get the
interrupts we expect.  On those machines, we have to use acpiphp
instead.  It seems like many Dell XPS laptops have this issue with
ExpressCard slots, e.g.,
https://bugzilla.kernel.org/show_bug.cgi?id=40802 .

If you want "pci=nopciehp" as a way for users to deal with this
problem by forcing the use of acpiphp, I object.  Windows manages to
make these slots work without having users do anything special, so we
should be able to do it, too.

> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> ---
>  Documentation/kernel-parameters.txt |    2 ++
>  drivers/acpi/pci_root.c             |    3 ++-
>  drivers/pci/pci.c                   |    2 ++
>  drivers/pci/pcie/portdrv_core.c     |    5 +++--
>  drivers/pci/pcie/portdrv_pci.c      |    3 +++
>  include/linux/pci.h                 |    9 +++++++++
>  6 files changed, 21 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 9776f06..28dd0ad 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2106,6 +2106,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>                 noaer           [PCIE] If the PCIEAER kernel config parameter is
>                                 enabled, this kernel boot option can be used to
>                                 disable the use of PCIE advanced error reporting.
> +               nopciehp        [PCIE] this kernel boot option can be used to
> +                               disable PCIe native hotplug.
>                 nodomains       [PCI] Disable support for multiple PCI
>                                 root domains (aka PCI segments, in ACPI-speak).
>                 nommconf        [X86] Disable use of MMCONFIG for PCI
> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> index c6200ff..c37eedb 100644
> --- a/drivers/acpi/pci_root.c
> +++ b/drivers/acpi/pci_root.c
> @@ -551,8 +551,9 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
>         if (!pcie_ports_disabled
>             && (flags & ACPI_PCIE_REQ_SUPPORT) == ACPI_PCIE_REQ_SUPPORT) {
>                 flags = OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL
> -                       | OSC_PCI_EXPRESS_NATIVE_HP_CONTROL
>                         | OSC_PCI_EXPRESS_PME_CONTROL;
> +               if (!pcie_native_hotplug_disabled)
> +                       flags |= OSC_PCI_EXPRESS_NATIVE_HP_CONTROL;
>
>                 if (pci_aer_available()) {
>                         if (aer_acpi_firmware_first())
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 2f8f4c6..34b2c83 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -3869,6 +3869,8 @@ static int __init pci_setup(char *str)
>                                 pci_no_msi();
>                         } else if (!strcmp(str, "noaer")) {
>                                 pci_no_aer();
> +                       } else if (!strcmp(str, "nopciehp")) {
> +                               pcie_no_native_hotplug();
>                         } else if (!strncmp(str, "realloc=", 8)) {
>                                 pci_realloc_get_opt(str + 8);
>                         } else if (!strncmp(str, "realloc", 7)) {
> diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
> index ed129b4..e7e1679 100644
> --- a/drivers/pci/pcie/portdrv_core.c
> +++ b/drivers/pci/pcie/portdrv_core.c
> @@ -263,8 +263,9 @@ static int get_port_device_capability(struct pci_dev *dev)
>
>         err = pcie_port_platform_notify(dev, &cap_mask);
>         if (!pcie_ports_auto) {
> -               cap_mask = PCIE_PORT_SERVICE_PME | PCIE_PORT_SERVICE_HP
> -                               | PCIE_PORT_SERVICE_VC;
> +               cap_mask = PCIE_PORT_SERVICE_PME | PCIE_PORT_SERVICE_VC;
> +               if (!pcie_native_hotplug_disabled)
> +                       cap_mask |= PCIE_PORT_SERVICE_HP;
>                 if (pci_aer_available())
>                         cap_mask |= PCIE_PORT_SERVICE_AER;
>         } else if (err) {
> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
> index 0761d90..018cee0 100644
> --- a/drivers/pci/pcie/portdrv_pci.c
> +++ b/drivers/pci/pcie/portdrv_pci.c
> @@ -40,6 +40,9 @@ bool pcie_ports_disabled;
>   */
>  bool pcie_ports_auto = true;
>
> +/* If set, the PCIe native hotplug will not be used. */
> +bool pcie_native_hotplug_disabled;
> +
>  static int __init pcie_port_setup(char *str)
>  {
>         if (!strncmp(str, "compat", 6)) {
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 12e5447..715e17b 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1138,9 +1138,18 @@ extern int pci_msi_enabled(void);
>  #ifdef CONFIG_PCIEPORTBUS
>  extern bool pcie_ports_disabled;
>  extern bool pcie_ports_auto;
> +extern bool pcie_native_hotplug_disabled;
> +
> +static inline void pcie_no_native_hotplug(void)
> +{
> +       pcie_native_hotplug_disabled = true;
> +}
>  #else
>  #define pcie_ports_disabled    true
>  #define pcie_ports_auto                false
> +#define pcie_native_hotplug_disabled   true
> +
> +static inline void pcie_no_native_hotplug(void) { }
>  #endif
>
>  #ifndef CONFIG_PCIEASPM
> --
> 1.7.9.5
>
