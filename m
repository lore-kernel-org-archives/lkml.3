Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbaCSVQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 17:16:41 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:62658 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbaCSVQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 17:16:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140319185423.GA5514@google.com>
References: <20140226192614.10125.68711.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140226193757.10125.81865.stgit@bhelgaas-glaptop.roam.corp.google.com> <20140319185423.GA5514@google.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 19 Mar 2014 15:16:17 -0600
Message-ID: <CAErSpo42K6W8b+7A7dyxUp-rNQttMQY7jcbpgyGv9sctyAqJCA@mail.gmail.com>
Subject: Re: [PATCH 8/9] PCI: Ignore BAR contents when firmware left decoding disabled
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ming Lei <tom.leiming@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Pekka Enberg <penberg@kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 12:54 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc Ming, Rusty, Pekka, Sasha]
> ...
> I plan to replace this patch with the following, which only sets
> IORESOURCE_UNSET when we already have been clearing the bus region start
> address.  (This probably should have been a separate patch to begin with,
> mea culpa.)
>
> This is intended for the v3.15 merge window, so I made the minimal change
> to reduce risk.

I put this patch in my pci/resource branch and re-merged it into my
"next" branch.  This rebased both pci/resource and next, which is
unfortunate, but I think it's the cleanest and least risky way at this
point.

Bjorn

> PCI: Mark 64-bit resource as IORESOURCE_UNSET if we only support 32-bit
>
> From: Bjorn Helgaas <bhelgaas@google.com>
>
> If we don't support 64-bit addresses, i.e., CONFIG_PHYS_ADDR_T_64BIT is not
> set, we can't deal with BARs above 4GB.  In this case we already pretend
> the BAR contained zero; this patch also sets IORESOURCE_UNSET so we can try
> to reallocate it later.
>
> I don't think this is exactly correct: what we care about here are *bus*
> addresses, not CPU addresses, so the tests of sizeof(resource_size_t)
> probably should be on sizeof(dma_addr_t) instead.  But this is what's been
> in -next, so we'll fix that later.
>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> ---
>  drivers/pci/probe.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 6e34498ec9f0..78335efbbb74 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -252,6 +252,7 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
>                         /* Address above 32-bit boundary; disable the BAR */
>                         pci_write_config_dword(dev, pos, 0);
>                         pci_write_config_dword(dev, pos + 4, 0);
> +                       res->flags |= IORESOURCE_UNSET;
>                         region.start = 0;
>                         region.end = sz64;
>                         bar_disabled = true;
