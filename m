Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab3J3TLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:11:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51137 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab3J3TLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:11:50 -0400
Date: Wed, 30 Oct 2013 14:10:34 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: Re: [PATCH v3 05/10] spmi: pmic_arb: add support for interrupt
 handling
Message-ID: <20131030191034.GN20207@joshc.qualcomm.com>
References: <cover.1382985169.git.joshc@codeaurora.org>
 <4acd03d0a436d44faab8c6b62b51c23851d98d8f.1382985169.git.joshc@codeaurora.org>
 <20131030181755.GJ21983@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030181755.GJ21983@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen-

Thanks for all the comments.

On Wed, Oct 30, 2013 at 11:17:55AM -0700, Stephen Boyd wrote:
> On 10/28, Josh Cartwright wrote:
> > @@ -108,12 +111,17 @@ struct spmi_pmic_arb_dev {
> >  	void __iomem		*base;
> >  	void __iomem		*intr;
> >  	void __iomem		*cnfg;
> > +	unsigned int		irq;
> >  	bool			allow_wakeup;
> >  	spinlock_t		lock;
> >  	u8			channel;
> >  	u8			min_apid;
> >  	u8			max_apid;
> >  	u32			mapping_table[SPMI_MAPPING_TABLE_LEN];
> > +	int			bus_nr;
>
> This looks unused.

Indeed, will remove (I think this is a holdout from the split qpnpint
handling that exists in the vendor tree).

> > +	struct irq_domain	*domain;
> > +	struct spmi_controller	*spmic;
> > +	u16			apid_to_ppid[256];
> >  };
> >
> >  static inline u32 pmic_arb_base_read(struct spmi_pmic_arb_dev *dev, u32 offset)
> [...]
> > +
> > +static void pmic_arb_chained_irq(unsigned int irq, struct irq_desc *desc)
> > +{
> > +	struct spmi_pmic_arb_dev *pa = irq_get_handler_data(irq);
> > +	struct irq_chip *chip = irq_get_chip(irq);
> > +	void __iomem *intr = pa->intr;
> > +	int first = pa->min_apid >> 5;
> > +	int last = pa->max_apid >> 5;
> > +	int i, id;
> > +	u8 ee = 0; /*pa->owner;*/
>
> TODO?

Indeed, I removed this for some reason awhile back, but this really
should be put back into place, and the EE should be a required property
in the bindings.

[..]
> > +static int qpnpint_irq_domain_dt_translate(struct irq_domain *d,
> > +					   struct device_node *controller,
> > +					   const u32 *intspec,
> > +					   unsigned int intsize,
> > +					   unsigned long *out_hwirq,
> > +					   unsigned int *out_type)
> > +{
> > +	struct spmi_pmic_arb_dev *pa = d->host_data;
> > +	struct spmi_pmic_arb_irq_spec spec;
> > +	int err;
> > +	u8 apid;
> > +
> > +	dev_dbg(&pa->spmic->dev,
> > +		"intspec[0] 0x%1x intspec[1] 0x%02x intspec[2] 0x%02x\n",
> > +		intspec[0], intspec[1], intspec[2]);
> > +
> > +	if (d->of_node != controller)
> > +		return -EINVAL;
> > +	if (intsize != 4)
> > +		return -EINVAL;
> > +	if (intspec[0] > 0xF || intspec[1] > 0xFF || intspec[2] > 0x7)
> > +		return -EINVAL;
> > +
> > +	spec.slave = intspec[0];
> > +	spec.per   = intspec[1];
> > +	spec.irq   = intspec[2];
> > +
> > +	err = search_mapping_table(pa, &spec, &apid);
> > +	if (err)
> > +		return err;
> > +
> > +	pa->apid_to_ppid[apid] = spec.slave << 8 | spec.per;
> > +
> > +	/* Keep track of {max,min}_apid for bounding search during interrupt */
> > +	if (apid > pa->max_apid)
> > +		pa->max_apid = apid;
> > +	if (apid < pa->min_apid)
> > +		pa->min_apid = apid;
>
> Ah makes sense now why we set this to the opposite values in
> probe.  Please put a comment in patch 4 and maybe move that setup
> in patch 4 to this patch.

Indeed, I'll move it and add a comment at init-time.

> > +
> > +	*out_hwirq = spec.slave << 24
> > +		   | spec.per   << 16
> > +		   | spec.irq   << 8
> > +		   | apid;
> > +	*out_type  = intspec[3] & IRQ_TYPE_SENSE_MASK;
> > +
> > +	dev_dbg(&pa->spmic->dev, "out_hwirq = %lu\n", *out_hwirq);
> > +
> > +	return 0;
> > +}
> > +
> [...]
> >  static int spmi_pmic_arb_probe(struct platform_device *pdev)
> >  {
> >  	struct spmi_pmic_arb_dev *pa;
> >  	struct spmi_controller *ctrl;
> >  	struct resource *res;
> > -	int err, i;
> > +	int err = 0, i;
> >
> >  	ctrl = spmi_controller_alloc(&pdev->dev, sizeof(*pa));
> >  	if (!ctrl)
> >  		return -ENOMEM;
> >
> >  	pa = spmi_controller_get_drvdata(ctrl);
> > +	pa->spmic = ctrl;
> >
> >  	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "core");
> >  	pa->base = devm_ioremap_resource(&ctrl->dev, res);
> > @@ -349,6 +679,12 @@ static int spmi_pmic_arb_probe(struct platform_device *pdev)
> >  		goto err_put_ctrl;
> >  	}
> >
> > +	pa->irq = platform_get_irq(pdev, 0);
> > +	if (pa->irq < 0) {
> > +		err = pa->irq;
> > +		goto err_put_ctrl;
> > +	}
> > +
> >  	for (i = 0; i < ARRAY_SIZE(pa->mapping_table); ++i)
> >  		pa->mapping_table[i] = readl_relaxed(
> >  				pa->cnfg + SPMI_MAPPING_TABLE_REG(i));
> > @@ -364,15 +700,30 @@ static int spmi_pmic_arb_probe(struct platform_device *pdev)
> >  	ctrl->read_cmd = pmic_arb_read_cmd;
> >  	ctrl->write_cmd = pmic_arb_write_cmd;
> >
> > +	dev_dbg(&pdev->dev, "adding irq domain\n");
> > +	pa->domain = irq_domain_add_tree(pdev->dev.of_node,
> > +					 &pmic_arb_irq_domain_ops, pa);
> > +	if (!pa->domain) {
> > +		dev_err(&pdev->dev, "unable to create irq_domain\n");
> > +		goto err_put_ctrl;
>
> Why do we silently ignore the error here? Is the irqchip
> functionality optional? Setting err here should allow us to skip
> intializing err to 0 up at the top of this function.

Nice catch, it wasn't my intent to ignore it.

Thanks again,
   Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
