Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab3C2WXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 18:23:07 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:40961 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757084Ab3C2WXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 18:23:05 -0400
MIME-Version: 1.0
In-Reply-To: <1364444885-19751-3-git-send-email-yinghai@kernel.org>
References: <1364444885-19751-1-git-send-email-yinghai@kernel.org> <1364444885-19751-3-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 29 Mar 2013 16:22:44 -0600
Message-ID: <CAErSpo7+V8vU8x2=MfZw3V7XsXKzs6qrvv8G=MqrEdUKcyvoTw@mail.gmail.com>
Subject: Re: [PATCH 2/2] eisa, PCI: init eisa early before pnp step in
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Whitehead <mwhitehe@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Rafael, just FYI since it involves PNP resources]

On Wed, Mar 27, 2013 at 10:28 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> Mathhew reported kernels fail the pci_eisa probe and are later successful
> with the virtual_eisa_root_init force probe without slot0.
>
> The reason for that is: pnp probing is early than pci_eisa_init get called
> as pci_eisa_init is called via pci_driver.
>
> pnp 00:0f has 0xc80 - 0xc84 reserved.
> [    9.700409] pnp 00:0f: [io  0x0c80-0x0c84]
>
> so eisa_probe will fail from pci_eisa_init
>                                 ==>eisa_root_register
>                                         ==>eisa_probe path.
> as force_probe is not set in pci_eisa_root, it will bail early when
> slot0 is not probed and initialized.
>
> Try to use subsys_initcall_sync instead, and will keep following sequence:
>         pci_subsys_init
>         pci_eisa_init_early
>         pnpacpi_init/isapnp_init

Is this a regression?  This must have worked at one time, but it seems
like we've had pnpacpi_init/isapnp_init/pnpbios_init before PCI
drivers for quite a while.

> After this patch eisa can be initialized properly, and pnp overlapping
> resource will not be reserved.
> [   10.104434] system 00:0f: [io  0x0c80-0x0c84] could not be reserved

I think we should add logging in eisa_request_resources() similar to
what drivers/pnp/system.c does so it's more clear what resources EISA
is using.

> Reported-by: Matthew Whitehead <mwhitehe@redhat.com>
> Tested-by: Matthew Whitehead <mwhitehe@redhat.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: stable@kernel.org
>
> ---
>  drivers/eisa/pci_eisa.c |   41 ++++++++++++++++++++++-------------------
>  1 file changed, 22 insertions(+), 19 deletions(-)
>
> Index: linux-2.6/drivers/eisa/pci_eisa.c
> ===================================================================
> --- linux-2.6.orig/drivers/eisa/pci_eisa.c
> +++ linux-2.6/drivers/eisa/pci_eisa.c
> @@ -19,8 +19,7 @@
>  /* There is only *one* pci_eisa device per machine, right ? */
>  static struct eisa_root_device pci_eisa_root;
>
> -static int __init pci_eisa_init(struct pci_dev *pdev,
> -                               const struct pci_device_id *ent)
> +static int __init pci_eisa_init(struct pci_dev *pdev)
>  {
>         int rc, n = 0;
>         struct resource *bus_res;
> @@ -49,22 +48,26 @@ static int __init pci_eisa_init(struct p
>         return 0;
>  }
>
> -static struct pci_device_id pci_eisa_pci_tbl[] = {
> -       { PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
> -         PCI_CLASS_BRIDGE_EISA << 8, 0xffff00, 0 },
> -       { 0, }
> -};
> -
> -static struct pci_driver __refdata pci_eisa_driver = {
> -       .name           = "pci_eisa",
> -       .id_table       = pci_eisa_pci_tbl,
> -       .probe          = pci_eisa_init,
> -};
> -
> -static int __init pci_eisa_init_module (void)
> +/*
> + * We have to call pci_eisa_init_early() before pnpacpi_init()/isapnp_init().
> + *   Otherwise pnp resource will get enabled early and could prevent eisa
> + *   to be initialized.
> + * Also need to make sure pci_eisa_init_early() is called after
> + * x86/pci_subsys_init().
> + * So need to use subsys_initcall_sync with it.
> + */
> +static int __init pci_eisa_init_early(void)
>  {
> -       return pci_register_driver (&pci_eisa_driver);
> -}
> +       struct pci_dev *dev = NULL;
> +       int ret;
> +
> +       for_each_pci_dev(dev)
> +               if ((dev->class >> 8) == PCI_CLASS_BRIDGE_EISA) {
> +                       ret = pci_eisa_init(dev);
> +                       if (ret)
> +                               return ret;
> +               }
>
> -device_initcall(pci_eisa_init_module);
> -MODULE_DEVICE_TABLE(pci, pci_eisa_pci_tbl);
> +       return 0;
> +}
> +subsys_initcall_sync(pci_eisa_init_early);
