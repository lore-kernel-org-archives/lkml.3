Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbaLBPZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 10:25:25 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42073 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752533AbaLBPZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 10:25:23 -0500
Date: Tue, 2 Dec 2014 15:25:07 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: "tthayer@opensource.altera.com" <tthayer@opensource.altera.com>
Cc: "bp@alien8.de" <bp@alien8.de>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tthayer.linux@gmail.com" <tthayer.linux@gmail.com>
Subject: Re: [PATCHv5 4/5] edac: altera: Add Altera L2 Cache and OCRAM EDAC
 Support
Message-ID: <20141202152507.GO23671@leverpostej>
References: <1415751263-1830-1-git-send-email-tthayer@opensource.altera.com>
 <1415751263-1830-5-git-send-email-tthayer@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415751263-1830-5-git-send-email-tthayer@opensource.altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> +/* MPU L2 Register Defines */
> +#define ALTR_MPUL2_CONTROL_OFFSET       0x100
> +#define ALTR_MPUL2_CTL_CACHE_EN_MASK    BIT(0)

These are just standard PL310 register definitions, no?

[...]

> +static void *ocram_alloc_mem(size_t size, void **other)
> +{
> +       struct device_node *np;
> +       struct gen_pool *gp;
> +       void *sram_addr;
> +
> +       np = of_find_compatible_node(NULL, NULL, "altr,ocram-edac");
> +       if (!np)
> +               return NULL;

Don't you need to have a corresponding of_node_put?

Is this ever called before the code above has probed? Can't you keep
this information around rather than probing it every time?

> +
> +       gp = of_get_named_gen_pool(np, "iram", 0);
> +       if (!gp)
> +               return NULL;
> +
> +       sram_addr = (void *)gen_pool_alloc(gp, size);
> +       if (!sram_addr)
> +               return NULL;
> +
> +       memset(sram_addr, 0, size);

Is it safe to do a memset to the sram? How is it mapped?

[...]

> +static void *l2_alloc_mem(size_t size, void **other)
> +{
> +       struct device *dev = *other;
> +       void *ptemp = devm_kzalloc(dev, size, GFP_KERNEL);
> +
> +       if (!ptemp)
> +               return NULL;
> +
> +       /* Make sure everything is written out */
> +       wmb();
> +       flush_cache_all();

Doesn't this just flush out _to_ the L2 (and not beyond)? Even then I
don't think that's safe with the MMU enabled.

Why is the flush necessary?

[...]

> +static int altr_l2_dependencies(struct platform_device *pdev,
> +                               void __iomem *base)
> +{
> +       u32 control;
> +       struct regmap *l2_vbase;
> +
> +       control = readl(base) & ALTR_L2_ECC_EN_MASK;
> +       if (!control) {
> +               edac_printk(KERN_ERR, EDAC_DEVICE,
> +                           "L2: No ECC present, or ECC disabled\n");
> +               return -ENODEV;
> +       }
> +
> +       l2_vbase = syscon_regmap_lookup_by_compatible("arm,pl310-cache");
> +       if (IS_ERR(l2_vbase)) {
> +               edac_printk(KERN_ERR, EDAC_DEVICE,
> +                           "L2:regmap for arm,pl310-cache lookup failed.\n");
> +               return -ENODEV;
> +       }

I must NAK any use of the L2 as a syscon device. It's simply not a
register file that was intended to be shared. I appreciate that you only
want to check something very simple, but we should use a higher level
API for that (and we should add one if we do not already have one)

> +
> +       regmap_read(l2_vbase, ALTR_MPUL2_CONTROL_OFFSET, &control);
> +       if (!(control & ALTR_MPUL2_CTL_CACHE_EN_MASK)) {
> +               edac_printk(KERN_ERR, EDAC_DEVICE, "L2: Cache disabled\n");
> +               return -ENODEV;
> +       }
> +
> +       return 0;
> +}
> +
> +const struct edac_device_prv_data l2ecc_data = {
> +       .setup = altr_l2_dependencies,
> +       .ce_clear_mask = 0,
> +       .ue_clear_mask = 0,
> +#ifdef CONFIG_EDAC_DEBUG
> +       .eccmgr_sysfs_attr = altr_l2_sysfs_attributes,
> +       .alloc_mem = l2_alloc_mem,
> +       .free_mem = l2_free_mem,
> +       .ecc_enable_mask = ALTR_L2_ECC_EN_MASK,
> +       .ce_set_mask = (ALTR_L2_ECC_EN_MASK | ALTR_L2_ECC_INJS_MASK),
> +       .ue_set_mask = (ALTR_L2_ECC_EN_MASK | ALTR_L2_ECC_INJD_MASK),
> +       .trig_alloc_sz = ALTR_TRIG_L2C_BYTE_SIZE,
> +#endif
> +};
> +
> +#endif /* #ifdef CONFIG_EDAC_ALTERA_L2C */
> +
>  MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Thor Thayer");
> -MODULE_DESCRIPTION("EDAC Driver for Altera SDRAM Controller");
> +MODULE_DESCRIPTION("EDAC Driver for Altera Memories");
> --
> 1.7.9.5
> 
> 
