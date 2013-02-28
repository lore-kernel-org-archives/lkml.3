Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab3B1ADo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 19:03:44 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63384 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab3B1ADn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 19:03:43 -0500
MIME-Version: 1.0
In-Reply-To: <1361191939-21260-7-git-send-email-Varun.Sethi@freescale.com>
References: <1361191939-21260-1-git-send-email-Varun.Sethi@freescale.com>
	<1361191939-21260-7-git-send-email-Varun.Sethi@freescale.com>
Date: Wed, 27 Feb 2013 18:03:41 -0600
Message-ID: <CALRxmdD6PTVvk2PpcPPEqh74E-=qTivmS7Gr8Mxeobd2Jgso0A@mail.gmail.com>
Subject: Re: [PATCH 6/6 v8] iommu/fsl: Freescale PAMU driver and IOMMU API implementation.
From: Stuart Yoder <b08248@gmail.com>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: iommu@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Scott Wood <scottwood@freescale.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stuart Yoder <stuart.yoder@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some more comments...

On Mon, Feb 18, 2013 at 6:52 AM, Varun Sethi <Varun.Sethi@freescale.com> wrote:
> +/* Handling access violations */
> +#define make64(high, low) (((u64)(high) << 32) | (low))
> +
> +struct pamu_isr_data {
> +       void __iomem *pamu_reg_base;    /* Base address of PAMU regs*/
> +       unsigned int count;             /* The number of PAMUs */
> +};
> +
> +static struct paace *ppaact;
> +static struct paace *spaact;
> +static struct ome *omt;
> +
> +/* maximum subwindows permitted per liodn */
> +unsigned int max_subwindow_count;
> +/* Number of SPAACT entries */
> +unsigned long max_subwins;

I don't like that these variables are not static... and they are
referenced directly
from code in fsl_pamu_domain.c.  It would be better if fsl_pamu_domain.c
called an accessor function-- like pamu_get_max_subwins.

> +/* Pool for fspi allocation */
> +struct gen_pool *spaace_pool;

spaace_pool should be static?

I'm wondering if you should change pamu_isr_data into a more
general struct analagous to struct intel_iommu.   You could
put in there the max # of subwins, etc.   You could then
provide an accessor to get at that data.

[cut]
> +/**
> + * pamu_get_fspi_and_allocate() - Allocates fspi index and reserves subwindows
> + *                                required for primary PAACE in the secondary
> + *                                PAACE table.
> + * @subwin_cnt: Number of subwindows to be reserved.
> + *
> + * A PPAACE entry may have a number of associated subwindows. A subwindow
> + * corresponds to a SPAACE entry in the SPAACT table. Each PAACE entry stores
> + * the index (fspi) of the first SPAACE entry in the SPAACT table. This
> + * function returns the index of the first SPAACE entry. The remaining
> + * SPAACE entries are reserved contiguously from that index.
> + *
> + * Returns a valid fspi index in the range of 0 - max_subwins on success.
> + * If no SPAACE entry is available or the allocator can not reserve the required
> + * number of contiguous entries function returns ULONG_MAX indicating a failure.
> + *
> +*/
> +static unsigned long pamu_get_fspi_and_allocate(u32 subwin_cnt)
> +{
> +       unsigned long spaace_addr;
> +
> +       spaace_addr = gen_pool_alloc(spaace_pool, subwin_cnt * sizeof(struct paace));
> +       if (!spaace_addr)
> +               return ULONG_MAX;
> +
> +       return (spaace_addr - (unsigned long)spaact) / (sizeof(struct paace));
> +}

In order to keep things symmetric (with the free function) can we just
call the above
function:

   pamu_alloc_subwins()

> +/* Release the subwindows reserved for a particular LIODN */
> +void pamu_free_subwins(int liodn)
> +{
> +       struct paace *ppaace;
> +       u32 subwin_cnt, size;
> +
> +       ppaace = pamu_get_ppaace(liodn);
> +       if (!ppaace) {
> +               pr_err("Invalid liodn entry\n");
> +               return;
> +       }
> +
> +       if (get_bf(ppaace->addr_bitfields, PPAACE_AF_MW)) {
> +               subwin_cnt = 1UL << (get_bf(ppaace->impl_attr, PAACE_IA_WCE) + 1);
> +               size = (subwin_cnt - 1) * sizeof(struct paace);
> +               gen_pool_free(spaace_pool, (unsigned long)&spaact[ppaace->fspi], size);
> +               set_bf(ppaace->addr_bitfields, PPAACE_AF_MW, 0);
> +       }
> +}

[cut]

> +/**
> + * get_stash_id - Returns stash destination id corresponding to a
> + *                cache type and vcpu.
> + * @stash_dest_hint: L1, L2 or L3
> + * @vcpu: vpcu target for a particular cache type.
> + *
> + * Returs stash on success or ~(u32)0 on failure.
> + *
> + */
> +u32 get_stash_id(u32 stash_dest_hint, u32 vcpu)
> +{

The stash dest is really not a hint, right?  It's the requested stash
destination.  So maybe just drop 'hint' from the name.

The CPU here is really a physical CPU number and has nothing to do
with vcpus I think.  vcpu implies the index is inside a virtual machine...but
this API is generic and may or may not be used with KVM.

> +
> +/*
> + * Get the maximum number of PAACT table entries
> + * and subwindows supported by PAMU
> + */
> +static void get_pamu_cap_values(unsigned long pamu_reg_base)
> +{
> +       u32 pc_val;
> +
> +       pc_val = in_be32((u32 *)(pamu_reg_base + PAMU_PC3));
> +       /* Maximum number of subwindows per liodn */
> +       max_subwindow_count = 1 << (1 + PAMU_PC3_MWCE(pc_val));
> +       /* Total number of SPACCT entries */
> +       max_subwins = PAACE_NUMBER_ENTRIES * max_subwindow_count;
> +}

If you follow the suggestion at the top of this file, this function
would become something like--  init_pamu_capabilities().   And then
create an accessor function to access max subwins, etc.

Also, BTW, I don't see any support for the DOMAIN_ATTR_WINDOWS
attribute in your patch.  Was that coming in a later patch?

[cut

> +static int __init fsl_pamu_probe(struct platform_device *pdev)
> +{
> +       void __iomem *pamu_regs = NULL;
> +       struct ccsr_guts __iomem *guts_regs = NULL;
> +       u32 pamubypenr, pamu_counter;
> +       unsigned long pamu_reg_off;
> +       unsigned long pamu_reg_base;
> +       struct pamu_isr_data *data;
> +       struct device_node *guts_node;
> +       u64 size;
> +       struct page *p;
> +       int ret = 0;
> +       int irq;
> +       phys_addr_t ppaact_phys;
> +       phys_addr_t spaact_phys;
> +       phys_addr_t omt_phys;
> +       size_t mem_size = 0;
> +       unsigned int order = 0;
> +       u32 csd_port_id = 0;
> +       unsigned i;
> +       /*
> +        * enumerate all PAMUs and allocate and setup PAMU tables
> +        * for each of them,
> +        * NOTE : All PAMUs share the same LIODN tables.
> +        */
> +
> +       pamu_regs = of_iomap(pdev->dev.of_node, 0);
> +       if (!pamu_regs) {
> +               dev_err(&pdev->dev, "ioremap of PAMU node failed\n");
> +               return -ENOMEM;

Any reason not to be consistent with the other error handling-- set ret and
goto error"?

> +       }
> +       of_get_address(pdev->dev.of_node, 0, &size, NULL);
> +
> +       irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
> +       if (irq == NO_IRQ) {
> +               dev_warn(&pdev->dev, "no interrupts listed in PAMU node\n");
> +               goto error;
> +       }
> +
> +       data = kzalloc(sizeof(struct pamu_isr_data), GFP_KERNEL);
> +       if (!data) {
> +               iounmap(pamu_regs);
> +               return -ENOMEM;

Any reason not to be consistent with the other error handling-- set ret and
goto error"?


Stuart
