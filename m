Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762959Ab3DDWAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 18:00:52 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:54791 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760720Ab3DDWAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 18:00:50 -0400
MIME-Version: 1.0
In-Reply-To: <1363217302-14383-3-git-send-email-yinghai@kernel.org>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org> <1363217302-14383-3-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 4 Apr 2013 16:00:30 -0600
Message-ID: <CAErSpo6rmxMrX8EWiaut3wLSCu7LvmstyadEnTRu4Bv5MVyXJw@mail.gmail.com>
Subject: Re: [PATCH v3 02/27] PCI: Add pci_dev_resource_idx() helper
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 5:27 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> Use resource pointer to get index in pci resources array/list.
>
> -v2: export symbol for acpiphp compiling error, found by
>        Steven Newbury <steve@snewbury.org.uk>
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/probe.c |    9 +++++++++
>  include/linux/pci.h |    1 +
>  2 files changed, 10 insertions(+)
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 9cb3eb3..1df75f7 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -114,6 +114,15 @@ struct resource *pci_dev_resource_n(struct pci_dev *dev, int n)
>  }
>  EXPORT_SYMBOL(pci_dev_resource_n);
>
> +int pci_dev_resource_idx(struct pci_dev *dev, struct resource *res)
> +{
> +       if (res >= dev->resource &&
> +           res <= dev->resource + (PCI_NUM_RESOURCES - 1))
> +               return res - dev->resource;
> +
> +       return -1;
> +}

I'm dubious about the whole idea of a resource *index*.  I'd like to
get away from that concept completely.

Some uses of this are just for printing and are obviously unnecessary
(get_res_add_size()).

Other places we pass around the index, e.g.,
reassign_resources_sorted() passes it to pci_assign_resource() and
pci_reassign_resource(), and eventually we just pass the index to
pci_dev_resource_n() to get back what we started with.  I'd rather
just pass around a pointer instead of this half pointer/half index
strategy.

We might need a "struct pci_resource" or something that contains the
type (BAR, IOV, bridge window, etc), a BAR number, etc.  There's
already a "struct pci_resource" in cpqphp, but that's isolated to
cpqphp and could be easily changed if you wanted that name.

It's going to be very confusing to have a "struct pci_dev_resource"
and a "pci_dev_resource_n()" that have nothing to do with each other.

>  static u64 pci_size(u64 base, u64 maxbase, u64 mask)
>  {
>         u64 size = mask & maxbase;      /* Find the significant bits */
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 00d5367..aefff8b 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -339,6 +339,7 @@ struct pci_dev {
>  };
>
>  struct resource *pci_dev_resource_n(struct pci_dev *dev, int n);
> +int pci_dev_resource_idx(struct pci_dev *dev, struct resource *res);
>
>  static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
>  {
> --
> 1.7.10.4
>
