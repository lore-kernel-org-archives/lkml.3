Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab3FDXaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:30:09 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:57316 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab3FDXaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 19:30:05 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.03.1306041911170.1686@linux.vnet.ibm.com>
References: <alpine.LFD.2.03.1306041911170.1686@linux.vnet.ibm.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 4 Jun 2013 17:29:44 -0600
Message-ID: <CAErSpo41t6QDHJwoZcwp5pH7kzuLPb8xboHc3W6YixDad2BotA@mail.gmail.com>
Subject: Re: [PATCH] pci: add pcibios_release_device
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 4, 2013 at 11:18 AM, Sebastian Ott
<sebott@linux.vnet.ibm.com> wrote:
> Hello Bjorn,
>
> part of your feedback to the PCI support on s390 was to put some smarts in
> the config space accessors and let the pci core do the scanning of pci
> functions.
> To get there I had to implement pcibios_add_device on s390 to do some arch
> specific device initialization. During removal of the pci function I would
> like to undo these steps. Would it be possible to have a couterpart of
> pcibios_add_device - like the patch below:
>
>
> pci: add pcibios_release_device
>
> Platforms may want to provide architecture-specific functionality when
> a pci device is released. Add a pcibios_release_device() call that
> architectures can override to do so.
>
> Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>

Applied to pci/misc for v3.11.  Thanks!

> ---
>  drivers/pci/pci.c   |   10 ++++++++++
>  drivers/pci/probe.c |    1 +
>  include/linux/pci.h |    1 +
>  3 files changed, 12 insertions(+)
>
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1335,6 +1335,16 @@ int __weak pcibios_add_device (struct pc
>  }
>
>  /**
> + * pcibios_release_device - provide arch specific hooks when releasing device dev
> + * @dev: the PCI device being released
> + *
> + * Permits the platform to provide architecture specific functionality when
> + * devices are released. This is the default implementation. Architecture
> + * implementations can override this.
> + */
> +void __weak pcibios_release_device(struct pci_dev *dev) {}
> +
> +/**
>   * pcibios_disable_device - disable arch specific PCI resources for device dev
>   * @dev: the PCI device to disable
>   *
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1132,6 +1132,7 @@ static void pci_release_dev(struct devic
>         pci_dev = to_pci_dev(dev);
>         pci_release_capabilities(pci_dev);
>         pci_release_of_node(pci_dev);
> +       pcibios_release_device(pci_dev);
>         kfree(pci_dev);
>  }
>
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1643,6 +1643,7 @@ void pcibios_set_master(struct pci_dev *
>  int pcibios_set_pcie_reset_state(struct pci_dev *dev,
>                                  enum pcie_reset_state state);
>  int pcibios_add_device(struct pci_dev *dev);
> +void pcibios_release_device(struct pci_dev *dev);
>
>  #ifdef CONFIG_PCI_MMCONFIG
>  void __init pci_mmcfg_early_init(void);
>
