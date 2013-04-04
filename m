Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765219Ab3DDWSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 18:18:25 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:49798 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765163Ab3DDWSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 18:18:21 -0400
MIME-Version: 1.0
In-Reply-To: <1363217302-14383-4-git-send-email-yinghai@kernel.org>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org> <1363217302-14383-4-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 4 Apr 2013 16:18:01 -0600
Message-ID: <CAErSpo4VzBZ=fAzPm1yWEs4+09_D1=rysMf6tGgnqpVEKytSzQ@mail.gmail.com>
Subject: Re: [PATCH v3 03/27] PCI: pci resource iterator
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 5:27 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> From: Ram Pai <linuxram@us.ibm.com>
>
> Currently pci_dev structure holds an array of 17 PCI resources; six base
> BARs, one ROM BAR, four BRIDGE BARs, six sriov BARs.  This is wasteful.
> A bridge device just needs the 4 bridge resources. A non-bridge device
> just needs the six base resources and one ROM resource. The sriov
> resources are needed only if the device has SRIOV capability.
>
> The pci_dev structure needs to be re-organized to avoid unnecessary
> bloating.  However too much code outside the pci-bus driver, assumes the
> internal details of the pci_dev structure, thus making it hard to
> re-organize the datastructure.
>
> As a first step this patch provides generic methods to access the
> resource structure of the pci_dev.
>
> Finally we can re-organize the resource structure in the pci_dev
> structure and correspondingly update the methods.
>
> -v2: Consolidated iterator interface as per Bjorn's suggestion.
> -v3: Add the idx back - Yinghai Lu
> -v7: Change to use bitmap for searching - Yinghai Lu
> -v8: Fix acpiphp module compiling error that is found by
>         Steven Newbury <steve@snewbury.org.uk> - Yinghai Lu
>
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/probe.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pci.h |   24 ++++++++++++++++++++++++
>  2 files changed, 72 insertions(+)
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 1df75f7..ac751a6 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -123,6 +123,54 @@ int pci_dev_resource_idx(struct pci_dev *dev, struct resource *res)
>         return -1;
>  }
>
> +static void __init_res_idx_mask(unsigned long *mask, int flag)
> +{
> +       bitmap_zero(mask, PCI_NUM_RESOURCES);
> +       if (flag & PCI_STD_RES)
> +               bitmap_set(mask, PCI_STD_RESOURCES,
> +                       PCI_STD_RESOURCE_END - PCI_STD_RESOURCES + 1);
> +       if (flag & PCI_ROM_RES)
> +               bitmap_set(mask, PCI_ROM_RESOURCE, 1);
> +#ifdef CONFIG_PCI_IOV
> +       if (flag & PCI_IOV_RES)
> +               bitmap_set(mask, PCI_IOV_RESOURCES,
> +                       PCI_IOV_RESOURCE_END - PCI_IOV_RESOURCES + 1);
> +#endif
> +       if (flag & PCI_BRIDGE_RES)
> +               bitmap_set(mask, PCI_BRIDGE_RESOURCES,
> +                       PCI_BRIDGE_RESOURCE_END - PCI_BRIDGE_RESOURCES + 1);
> +}
> +
> +static DECLARE_BITMAP(res_idx_mask[1 << PCI_RES_BLOCK_NUM], PCI_NUM_RESOURCES);
> +static int __init pci_res_idx_mask_init(void)
> +{
> +       int i;
> +
> +       for (i = 0; i < (1 << PCI_RES_BLOCK_NUM); i++)
> +               __init_res_idx_mask(res_idx_mask[i], i);
> +
> +       return 0;
> +}
> +postcore_initcall(pci_res_idx_mask_init);
> +
> +static inline unsigned long *get_res_idx_mask(int flag)
> +{
> +       return res_idx_mask[flag & ((1 << PCI_RES_BLOCK_NUM) - 1)];
> +}
> +
> +int pci_next_resource_idx(int i, int flag)
> +{
> +       i++;
> +       if (i < PCI_NUM_RESOURCES)
> +               i = find_next_bit(get_res_idx_mask(flag), PCI_NUM_RESOURCES, i);
> +
> +       if (i < PCI_NUM_RESOURCES)
> +               return i;
> +
> +       return -1;
> +}
> +EXPORT_SYMBOL(pci_next_resource_idx);
> +
>  static u64 pci_size(u64 base, u64 maxbase, u64 mask)
>  {
>         u64 size = mask & maxbase;      /* Find the significant bits */
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index aefff8b..127a856 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -341,6 +341,30 @@ struct pci_dev {
>  struct resource *pci_dev_resource_n(struct pci_dev *dev, int n);
>  int pci_dev_resource_idx(struct pci_dev *dev, struct resource *res);
>
> +#define PCI_STD_RES            (1<<0)
> +#define PCI_ROM_RES            (1<<1)
> +#define PCI_IOV_RES            (1<<2)
> +#define PCI_BRIDGE_RES         (1<<3)
> +#define PCI_RES_BLOCK_NUM      4
> +
> +#define PCI_ALL_RES            (PCI_STD_RES | PCI_ROM_RES | PCI_BRIDGE_RES | PCI_IOV_RES)
> +#define PCI_NOSTD_RES          (PCI_ALL_RES & ~PCI_STD_RES)
> +#define PCI_NOIOV_RES          (PCI_ALL_RES & ~PCI_IOV_RES)
> +#define PCI_NOROM_RES          (PCI_ALL_RES & ~PCI_ROM_RES)
> +#define PCI_NOBRIDGE_RES       (PCI_ALL_RES & ~PCI_BRIDGE_RES)
> +#define PCI_STD_ROM_RES                (PCI_STD_RES | PCI_ROM_RES)
> +#define PCI_STD_IOV_RES                (PCI_STD_RES | PCI_IOV_RES)
> +#define PCI_STD_ROM_IOV_RES    (PCI_STD_RES | PCI_ROM_RES | PCI_IOV_RES)
> +
> +int pci_next_resource_idx(int i, int flag);
> +
> +#define for_each_pci_resource(dev, res, i, flag)       \
> +       for (i = pci_next_resource_idx(-1, flag),       \
> +               res = pci_dev_resource_n(dev, i);       \
> +            res;                                       \
> +            i = pci_next_resource_idx(i, flag),        \
> +               res = pci_dev_resource_n(dev, i))
> +
>  static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
>  {
>  #ifdef CONFIG_PCI_IOV

I think this turned out to be a disaster, with all the bitmaps and
helper functions.  Filtering in the bodies of the
for_each_pci_resource() users has *got* to be better.  That probably
requires a wrapper struct around the struct resource.  Or possibly
having a wrapper struct with a "type" or "flags" field would make
filtering in for_each_pci_resources() itself cleaner to implement.

I think it would also help if we got rid of all the "PCI_NO*_RES"
definitions and just had the users explicitly specify what they *do*
want.

Bjorn
