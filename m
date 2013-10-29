Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab3J2Wqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 18:46:38 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:34079 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab3J2Wqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 18:46:37 -0400
MIME-Version: 1.0
In-Reply-To: <20131023032406.12410.77485.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20131023032140.12410.43295.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20131023032406.12410.77485.stgit@bhelgaas-glaptop.roam.corp.google.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 29 Oct 2013 16:46:16 -0600
Message-ID: <CAErSpo7vYV2CCFFVZiuVRDZ_bHVtL3ANuY=j2-JEVUA-PQm8NA@mail.gmail.com>
Subject: Re: [PATCH 1/2] frv/PCI: Remove pcibios_last_bus
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-am33-list@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 9:24 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> pcibios_last_bus was apparently copied from x86.  On FR-V, it is
> statically initialized to -1 and never changed unless the user boots
> with "pci=lastbus=<X>".  I doubt that option is used on FR-V, so this
> patch removes all the code related to pcibios_last_bus.
>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Applied to my pci/misc branch for v3.13.  Let me know if anybody objects.

> ---
>  arch/frv/mb93090-mb00/pci-frv.h |    1 -
>  arch/frv/mb93090-mb00/pci-vdk.c |   36 ------------------------------------
>  2 files changed, 37 deletions(-)
>
> diff --git a/arch/frv/mb93090-mb00/pci-frv.h b/arch/frv/mb93090-mb00/pci-frv.h
> index 76c4e73..a7e487fe 100644
> --- a/arch/frv/mb93090-mb00/pci-frv.h
> +++ b/arch/frv/mb93090-mb00/pci-frv.h
> @@ -30,7 +30,6 @@ void pcibios_resource_survey(void);
>
>  /* pci-vdk.c */
>
> -extern int __nongpreldata pcibios_last_bus;
>  extern struct pci_ops *__nongpreldata pci_root_ops;
>
>  /* pci-irq.c */
> diff --git a/arch/frv/mb93090-mb00/pci-vdk.c b/arch/frv/mb93090-mb00/pci-vdk.c
> index deb6784..efa5d65 100644
> --- a/arch/frv/mb93090-mb00/pci-vdk.c
> +++ b/arch/frv/mb93090-mb00/pci-vdk.c
> @@ -25,7 +25,6 @@
>
>  unsigned int __nongpreldata pci_probe = 1;
>
> -int  __nongpreldata pcibios_last_bus = -1;
>  struct pci_ops *__nongpreldata pci_root_ops;
>
>  /*
> @@ -220,37 +219,6 @@ static struct pci_ops * __init pci_check_direct(void)
>  }
>
>  /*
> - * Discover remaining PCI buses in case there are peer host bridges.
> - * We use the number of last PCI bus provided by the PCI BIOS.
> - */
> -static void __init pcibios_fixup_peer_bridges(void)
> -{
> -       struct pci_bus bus;
> -       struct pci_dev dev;
> -       int n;
> -       u16 l;
> -
> -       if (pcibios_last_bus <= 0 || pcibios_last_bus >= 0xff)
> -               return;
> -       printk("PCI: Peer bridge fixup\n");
> -       for (n=0; n <= pcibios_last_bus; n++) {
> -               if (pci_find_bus(0, n))
> -                       continue;
> -               bus.number = n;
> -               bus.ops = pci_root_ops;
> -               dev.bus = &bus;
> -               for(dev.devfn=0; dev.devfn<256; dev.devfn += 8)
> -                       if (!pci_read_config_word(&dev, PCI_VENDOR_ID, &l) &&
> -                           l != 0x0000 && l != 0xffff) {
> -                               printk("Found device at %02x:%02x [%04x]\n", n, dev.devfn, l);
> -                               printk("PCI: Discovered peer bus %02x\n", n);
> -                               pci_scan_bus(n, pci_root_ops, NULL);
> -                               break;
> -                       }
> -       }
> -}
> -
> -/*
>   * Exceptions for specific devices. Usually work-arounds for fatal design flaws.
>   */
>
> @@ -418,7 +386,6 @@ int __init pcibios_init(void)
>         pci_scan_root_bus(NULL, 0, pci_root_ops, NULL, &resources);
>
>         pcibios_irq_init();
> -       pcibios_fixup_peer_bridges();
>         pcibios_fixup_irqs();
>         pcibios_resource_survey();
>
> @@ -432,9 +399,6 @@ char * __init pcibios_setup(char *str)
>         if (!strcmp(str, "off")) {
>                 pci_probe = 0;
>                 return NULL;
> -       } else if (!strncmp(str, "lastbus=", 8)) {
> -               pcibios_last_bus = simple_strtol(str+8, NULL, 0);
> -               return NULL;
>         }
>         return str;
>  }
>
