Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab3ATXha (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 18:37:30 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:47844 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab3ATXh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 18:37:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [RFC PATCH v5 8/8] PCI/PCIe: only claim PME from firmware when CONFIG_PCIE_PME is enabled
Date: Mon, 21 Jan 2013 00:43:27 +0100
Message-ID: <2580359.lck5YacT35@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1358525267-14268-9-git-send-email-jiang.liu@huawei.com>
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com> <1358525267-14268-9-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 19, 2013 12:07:46 AM Jiang Liu wrote:
> If CONFIG_PCIE_PME is not defined, system should avoid claiming PME from
> firmware so firmware could still manage PME events for those devices.
> Also don't create PCIe port device for PME service if CONFIG_PCIE_PME
> is not defined.

No, this isn't correct.

We know from experience that it is in fact necessary to request control of
either all PCIe native features or none of them.  Anything else leads to
very "interesting" failure modes on some systems.

I think we should just remove CONFIG_PCIE_PME instead.

Thanks,
Rafael


> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> ---
>  drivers/acpi/pci_root.c         |    5 +++--
>  drivers/pci/pcie/portdrv_core.c |    4 +++-
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> index c37eedb..7f7e464 100644
> --- a/drivers/acpi/pci_root.c
> +++ b/drivers/acpi/pci_root.c
> @@ -550,8 +550,9 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
>  
>  	if (!pcie_ports_disabled
>  	    && (flags & ACPI_PCIE_REQ_SUPPORT) == ACPI_PCIE_REQ_SUPPORT) {
> -		flags = OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL
> -			| OSC_PCI_EXPRESS_PME_CONTROL;
> +		flags = OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL;
> +		if (IS_ENABLED(CONFIG_PCIE_PME))
> +			flags |= OSC_PCI_EXPRESS_PME_CONTROL;
>  		if (!pcie_native_hotplug_disabled)
>  			flags |= OSC_PCI_EXPRESS_NATIVE_HP_CONTROL;
>  
> diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
> index e7e1679..7e6546f 100644
> --- a/drivers/pci/pcie/portdrv_core.c
> +++ b/drivers/pci/pcie/portdrv_core.c
> @@ -263,7 +263,9 @@ static int get_port_device_capability(struct pci_dev *dev)
>  
>  	err = pcie_port_platform_notify(dev, &cap_mask);
>  	if (!pcie_ports_auto) {
> -		cap_mask = PCIE_PORT_SERVICE_PME | PCIE_PORT_SERVICE_VC;
> +		cap_mask = PCIE_PORT_SERVICE_VC;
> +		if (IS_ENABLED(CONFIG_PCIE_PME))
> +			cap_mask |= PCIE_PORT_SERVICE_PME;
>  		if (!pcie_native_hotplug_disabled)
>  			cap_mask |= PCIE_PORT_SERVICE_HP;
>  		if (pci_aer_available())
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
