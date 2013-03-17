Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab3CQPtX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 11:49:23 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:38009
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756168Ab3CQPtV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 11:49:21 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VS-9(zz98dI9371I542I1432I179dNzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ahbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [PATCH 5/5 v9] iommu/fsl: Freescale PAMU driver and iommu
	implementation.
Thread-Topic: [PATCH 5/5 v9] iommu/fsl: Freescale PAMU driver and iommu
	implementation.
Thread-Index: AQHOIPFflZob5FM8S0WFENDPcCrxJZiqCEJg
Date: Sun, 17 Mar 2013 15:48:12 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D40ABB4@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1363200580-11623-1-git-send-email-Varun.Sethi@freescale.com>
 <0080B56D-8417-41B9-8341-665457D04DE6@kernel.crashing.org>
In-Reply-To: <0080B56D-8417-41B9-8341-665457D04DE6@kernel.crashing.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.249.193]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: iommu-bounces@lists.linux-foundation.org [mailto:iommu-
> bounces@lists.linux-foundation.org] On Behalf Of Kumar Gala
> Sent: Friday, March 15, 2013 1:50 AM
> To: Sethi Varun-B16395
> Cc: benh@kernel.crashing.org; linux-kernel@vger.kernel.org; Yoder Stuart-
> B08248; iommu@lists.linux-foundation.org; Wood Scott-B07421; linuxppc-
> dev@lists.ozlabs.org
> Subject: Re: [PATCH 5/5 v9] iommu/fsl: Freescale PAMU driver and iommu
> implementation.
> 
> 
> On Mar 13, 2013, at 1:49 PM, Varun Sethi wrote:
> 
> > +/*
> > + * Table of SVRs and the corresponding PORT_ID values.
> > + *
> > + * All future CoreNet-enabled SOCs will have this erratum fixed, so
> > +this table
> > + * should never need to be updated.  SVRs are guaranteed to be
> > +unique, so
> > + * there is no worry that a future SOC will inadvertently have one of
> > +these
> > + * values.
> > + */
> 
> Maybe add to the comment about what port_id represents
> 
[Sethi Varun-B16395] ok.
> > +static const struct {
> > +	u32 svr;
> > +	u32 port_id;
> > +} port_id_map[] = {
> > +	{0x82100010, 0xFF000000},	/* P2040 1.0 */
> > +	{0x82100011, 0xFF000000},	/* P2040 1.1 */
> > +	{0x82100110, 0xFF000000},	/* P2041 1.0 */
> > +	{0x82100111, 0xFF000000},	/* P2041 1.1 */
> > +	{0x82110310, 0xFF000000},	/* P3041 1.0 */
> > +	{0x82110311, 0xFF000000},	/* P3041 1.1 */
> > +	{0x82010020, 0xFFF80000},	/* P4040 2.0 */
> > +	{0x82000020, 0xFFF80000},	/* P4080 2.0 */
> > +	{0x82210010, 0xFC000000},       /* P5010 1.0 */
> > +	{0x82210020, 0xFC000000},       /* P5010 2.0 */
> > +	{0x82200010, 0xFC000000},	/* P5020 1.0 */
> > +	{0x82050010, 0xFF800000},	/* P5021 1.0 */
> > +	{0x82040010, 0xFF800000},	/* P5040 1.0 */
> > +};
> > +
> > +#define SVR_SECURITY	0x80000	/* The Security (E) bit */
> > +
> > +static int __init fsl_pamu_probe(struct platform_device *pdev) {
> > +	void __iomem *pamu_regs = NULL;
> > +	struct ccsr_guts __iomem *guts_regs = NULL;
> > +	u32 pamubypenr, pamu_counter;
> > +	unsigned long pamu_reg_off;
> > +	unsigned long pamu_reg_base;
> > +	struct pamu_isr_data *data;
> > +	struct device_node *guts_node;
> > +	u64 size;
> > +	struct page *p;
> > +	int ret = 0;
> > +	int irq;
> > +	phys_addr_t ppaact_phys;
> > +	phys_addr_t spaact_phys;
> > +	phys_addr_t omt_phys;
> > +	size_t mem_size = 0;
> > +	unsigned int order = 0;
> > +	u32 csd_port_id = 0;
> > +	unsigned i;
> > +	/*
> > +	 * enumerate all PAMUs and allocate and setup PAMU tables
> > +	 * for each of them,
> > +	 * NOTE : All PAMUs share the same LIODN tables.
> > +	 */
> > +
> > +	pamu_regs = of_iomap(pdev->dev.of_node, 0);
> > +	if (!pamu_regs) {
> > +		dev_err(&pdev->dev, "ioremap of PAMU node failed\n");
> > +		return -ENOMEM;
> > +	}
> > +	of_get_address(pdev->dev.of_node, 0, &size, NULL);
> > +
> > +	irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
> > +	if (irq == NO_IRQ) {
> > +		dev_warn(&pdev->dev, "no interrupts listed in PAMU node\n");
> > +		goto error;
> > +	}
> > +
> > +	data = kzalloc(sizeof(struct pamu_isr_data), GFP_KERNEL);
> > +	if (!data) {
> > +		iounmap(pamu_regs);
> > +		return -ENOMEM;
> > +	}
> > +	data->pamu_reg_base = pamu_regs;
> > +	data->count = size / PAMU_OFFSET;
> > +
> > +	/* The ISR needs access to the regs, so we won't iounmap them */
> > +	ret = request_irq(irq, pamu_av_isr, 0, "pamu", data);
> > +	if (ret < 0) {
> > +		dev_err(&pdev->dev, "error %i installing ISR for irq %i\n",
> > +			ret, irq);
> > +		goto error;
> > +	}
> > +
> > +	guts_node = of_find_compatible_node(NULL, NULL,
> > +			"fsl,qoriq-device-config-1.0");
> 
> This doesn't work for T4 or B4 device trees.
> 
[Sethi Varun-B16395]hmm.... I need to use the dcfg space for this.

> > +	if (!guts_node) {
> > +		dev_err(&pdev->dev, "could not find GUTS node %s\n",
> > +			pdev->dev.of_node->full_name);
> > +		ret = -ENODEV;
> > +		goto error;
> > +	}
> > +
> > +	guts_regs = of_iomap(guts_node, 0);
> > +	of_node_put(guts_node);
> > +	if (!guts_regs) {
> > +		dev_err(&pdev->dev, "ioremap of GUTS node failed\n");
> > +		ret = -ENODEV;
> > +		goto error;
> > +	}
> > +
> > +	/* read in the PAMU capability registers */
> > +	get_pamu_cap_values((unsigned long)pamu_regs);
> > +	/*
> > +	 * To simplify the allocation of a coherency domain, we allocate
> the
> > +	 * PAACT and the OMT in the same memory buffer.  Unfortunately,
> this
> > +	 * wastes more memory compared to allocating the buffers
> separately.
> > +	 */
> > +	/* Determine how much memory we need */
> > +	mem_size = (PAGE_SIZE << get_order(PAACT_SIZE)) +
> > +		(PAGE_SIZE << get_order(SPAACT_SIZE)) +
> > +		(PAGE_SIZE << get_order(OMT_SIZE));
> > +	order = get_order(mem_size);
> > +
> > +	p = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
> > +	if (!p) {
> > +		dev_err(&pdev->dev, "unable to allocate PAACT/SPAACT/OMT
> block\n");
> > +		ret = -ENOMEM;
> > +		goto error;
> > +	}
> > +
> > +	ppaact = page_address(p);
> > +	ppaact_phys = page_to_phys(p);
> > +
> > +	/* Make sure the memory is naturally aligned */
> > +	if (ppaact_phys & ((PAGE_SIZE << order) - 1)) {
> > +		dev_err(&pdev->dev, "PAACT/OMT block is unaligned\n");
> > +		ret = -ENOMEM;
> > +		goto error;
> > +	}
> > +
> > +	spaact = (void *)ppaact + (PAGE_SIZE << get_order(PAACT_SIZE));
> > +	omt = (void *)spaact + (PAGE_SIZE << get_order(SPAACT_SIZE));
> > +
> > +	dev_dbg(&pdev->dev, "ppaact virt=%p phys=0x%llx\n", ppaact,
> > +		(unsigned long long) ppaact_phys);
> > +
> > +	/* Check to see if we need to implement the work-around on this SOC
> > +*/
> > +
> > +	/* Determine the Port ID for our coherence subdomain */
> > +	for (i = 0; i < ARRAY_SIZE(port_id_map); i++) {
> > +		if (port_id_map[i].svr == (mfspr(SPRN_SVR) & ~SVR_SECURITY))
> {
> > +			csd_port_id = port_id_map[i].port_id;
> > +			dev_dbg(&pdev->dev, "found matching SVR %08x\n",
> > +				port_id_map[i].svr);
> > +			break;
> > +		}
> > +	}
> > +
> > +	if (csd_port_id) {
> > +		dev_dbg(&pdev->dev, "creating coherency subdomain at address
> "
> > +			"0x%llx, size %zu, port id 0x%08x", ppaact_phys,
> > +			mem_size, csd_port_id);
> > +
> > +		ret = create_csd(ppaact_phys, mem_size, csd_port_id);
> > +		if (ret) {
> > +			dev_err(&pdev->dev, "could not create coherence "
> > +				"subdomain\n");
> > +			return ret;
> > +		}
> > +	}
> > +
> > +	spaact_phys = virt_to_phys(spaact);
> > +	omt_phys = virt_to_phys(omt);
> > +
> > +	spaace_pool = gen_pool_create(ilog2(sizeof(struct paace)), -1);
> > +	if (!spaace_pool) {
> > +		ret = -ENOMEM;
> > +		dev_err(&pdev->dev, "PAMU : failed to allocate spaace gen
> pool\n");
> > +		goto error;
> > +	}
> > +
> > +	ret = gen_pool_add(spaace_pool, (unsigned long)spaact, SPAACT_SIZE,
> -1);
> > +	if (ret)
> > +		goto error_genpool;
> > +
> > +	pamubypenr = in_be32(&guts_regs->pamubypenr);
> > +
> > +	for (pamu_reg_off = 0, pamu_counter = 0x80000000; pamu_reg_off <
> size;
> > +	     pamu_reg_off += PAMU_OFFSET, pamu_counter >>= 1) {
> > +
> > +		pamu_reg_base = (unsigned long) pamu_regs + pamu_reg_off;
> > +		setup_one_pamu(pamu_reg_base, pamu_reg_off, ppaact_phys,
> > +				 spaact_phys, omt_phys);
> > +		/* Disable PAMU bypass for this PAMU */
> > +		pamubypenr &= ~pamu_counter;
> > +	}
> > +
> > +	setup_omt(omt);
> > +
> > +	/* Enable all relevant PAMU(s) */
> > +	out_be32(&guts_regs->pamubypenr, pamubypenr);
> > +
> > +	iounmap(guts_regs);
> > +
> > +	/* Enable DMA for the LIODNs in the device tree*/
> > +
> > +	setup_liodns();
> > +
> > +	return 0;
> > +
> > +error_genpool:
> > +	gen_pool_destroy(spaace_pool);
> > +
> > +error:
> > +	if (irq != NO_IRQ)
> > +		free_irq(irq, 0);
> 
> Should be:
> 
> free_irq(irq, data);
> 
[Sethi Varun-B16395] Yes.
> > +
> > +	if (pamu_regs)
> > +		iounmap(pamu_regs);
> > +
> > +	if (guts_regs)
> > +		iounmap(guts_regs);
> > +
> > +	if (ppaact)
> > +		free_pages((unsigned long)ppaact, order);
> > +
> > +	ppaact = NULL;
> > +
> 
> you alloc data, shouldn't you free it ?
> 
[Sethi Varun-B16395] Yes.

-Varun

