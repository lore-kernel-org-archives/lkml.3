Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbaI2OhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:37:13 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:60218 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaI2OhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:37:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: suravee.suthikulpanit@amd.com
Cc: will.deacon@arm.com, liviu.dudau@arm.com, marc.zyngier@arm.com,
        mark.rutland@arm.com, catalin.marinas@arm.com, jason@lakedaemon.net,
        tglx@linutronix.de, robh+dt@kernel.org, bhelgaas@google.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [RFC 2/4] PCI: generic: Add support for ARM64 and MSI(x)
Date: Mon, 29 Sep 2014 16:36:30 +0200
Message-ID: <8631927.qWHZsjCs8e@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411937610-22125-3-git-send-email-suravee.suthikulpanit@amd.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com> <1411937610-22125-3-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ccYuLVE3tFDeSBHAVt1nu0wYD3leYXOdqSGaVp86b+t
 kgPG7NhxRnYFskpvpCAqfKAVlnhHc8mu0K+5zAq45myWv1mlXr
 EGc80F/Pz7IsOIrqJHKwebPtO62dvHHg26MMcHF5fwU/md0wca
 0zfZFhJ4bwF6s8pc0tpmEYg5P1FHB2B+ycmQlYZP+xxyf9rndq
 4BzEExKWmJaQ2bKbhxbD+xqm9u38vWfroTveneK/D69QRIbf0E
 7nxxNwNnWhlabSMnQKbj6psIqmfIACQzFS1KqdhB38OVrldezv
 re/qx/49xhDlahQJVL88aCpkFwmS19vvMQUff0SYckZjUJ7nF3
 dL5IHf3H+bAr+l7POosE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 September 2014 15:53:28 suravee.suthikulpanit@amd.com wrote:
> +
> +#ifdef CONFIG_ARM64
> +struct pci_bus *gen_scan_root_bus(struct device *parent, int bus,
> +                                      struct pci_ops *ops, void *sysdata,
> +                                      struct list_head *resources)
> +{

I don't see anything ARM64 specific in this, the function only uses
the newly added generic helpers.

>  static int gen_pci_probe(struct platform_device *pdev)
>  {
> @@ -326,6 +385,7 @@ static int gen_pci_probe(struct platform_device *pdev)
>         struct device *dev = &pdev->dev;
>         struct device_node *np = dev->of_node;
>         struct gen_pci *pci = devm_kzalloc(dev, sizeof(*pci), GFP_KERNEL);
> +#ifndef CONFIG_ARM64
>         struct hw_pci hw = {
>                 .nr_controllers = 1,
>                 .private_data   = (void **)&pci,
> @@ -333,6 +393,7 @@ static int gen_pci_probe(struct platform_device *pdev)
>                 .map_irq        = of_irq_parse_and_map_pci,
>                 .ops            = &gen_pci_ops,
>         };
> +#endif
>  

Same here, I'd suggest marking this "#ifdef CONFIG_ARM" instead, as hw_pci
is an arm32 specific data structure.

>         if (!pci)
>                 return -ENOMEM;
> @@ -368,8 +429,24 @@ static int gen_pci_probe(struct platform_device *pdev)
>                 gen_pci_release_of_pci_ranges(pci);
>                 return err;
>         }
> +#ifdef CONFIG_ARM64
>  
> +#ifdef CONFIG_PCI_MSI
> +       pci->msi_parent = of_parse_phandle(np, "msi-parent", 0);
> +       if (!pci->msi_parent) {
> +               dev_err(&pdev->dev, "Failed to allocate msi-parent.\n");
> +               return -EINVAL;
> +       }
> +#endif

We probably want to enable MSI unconditionally on ARM64, so the #ifdef is
not necessary here. However, I don't think that a missing msi-parent should
be a fatal error here: we can still continue without MSI support if this
case.

> +       if (!gen_scan_root_bus(&pdev->dev, pci->cfg.bus_range.start,
> +                              &gen_pci_ops, pci, &pci->resources)) {
> +               dev_err(&pdev->dev, "failed to enable PCIe ports\n");
> +               return -ENODEV;
> +       }
> +#else
>         pci_common_init_dev(dev, &hw);
> +#endif /* CONFIG_ARM64 */
> 

Again, just make the pci_common_init_dev() call #ifdef CONFIG_ARM, and move
the generic case after it, outside of the #ifdef.

	Arnd
