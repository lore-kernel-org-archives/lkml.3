Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab3G2PpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:45:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:24380 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab3G2PpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:45:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,770,1367996400"; 
   d="scan'208";a="378371077"
Date: Mon, 29 Jul 2013 20:35:52 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: djbw@fb.com, linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH] dma: add driver for R-Car HPB-DMAC
Message-ID: <20130729150552.GM29095@intel.com>
References: <201306300015.50713.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306300015.50713.sergei.shtylyov@cogentembedded.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 30, 2013 at 12:15:50AM +0400, Sergei Shtylyov wrote:
> +config RCAR_HPB_DMAE
> +	tristate "Renesas R-Car HPB DMAC support"
> +	depends on SH_DMAE_BASE
you should select DMA stuff here
> +	help

> +#define DSAR0		0x00
> +#define DDAR0		0x04
> +#define DTCR0		0x08
> +#define DSAR1		0x0C
> +#define DDAR1		0x10
> +#define DTCR1		0x14
> +#define DSASR		0x18
> +#define DDASR		0x1C
> +#define DTCSR		0x20
> +#define DPTR		0x24
> +#define DCR		0x28
> +#define DCMDR		0x2C
> +#define DSTPR		0x30
> +#define DSTSR		0x34
> +#define DDBGR		0x38
> +#define DDBGR2		0x3C
> +#define HPB_CHAN(n)	(0x40 * (n))
Pls namespace this aptly

> +
> +/* DMA command register (DCMDR) bits */
> +#define DCMDR_BDOUT	BIT(7)
> +#define DCMDR_DQSPD	BIT(6)
> +#define DCMDR_DQSPC	BIT(5)
> +#define DCMDR_DMSPD	BIT(4)
> +#define DCMDR_DMSPC	BIT(3)
> +#define DCMDR_DQEND	BIT(2)
> +#define DCMDR_DNXT	BIT(1)
> +#define DCMDR_DMEN	BIT(0)
ditto

> +
> +/* DMA forced stop register (DSTPR) bits */
> +#define	DSTPR_DMSTP	BIT(0)
> +
> +/* DMA status register (DSTSR) bits */
> +#define	DSTSR_DMSTS	BIT(0)
> +
> +/* DMA common registers */
> +#define DTIMR		0x00
> +#define DINTSR0		0x0C
> +#define DINTSR1		0x10
> +#define DINTCR0		0x14
> +#define DINTCR1		0x18
> +#define DINTMR0		0x1C
> +#define DINTMR1		0x20
> +#define DACTSR0		0x24
> +#define DACTSR1		0x28
> +#define HSRSTR(n)	(0x40 + (n) * 4)
here too

> +static void ch_reg_write(struct hpb_dmae_chan *hpb_dc, u32 data, u32 reg)
> +{
> +	__raw_writel(data, hpb_dc->base + reg);
> +}
> +
> +static u32 ch_reg_read(struct hpb_dmae_chan *hpb_dc, u32 reg)
> +{
> +	return __raw_readl(hpb_dc->base + reg);
> +}
You dont need barrier?

> +static void dcmdr_write(struct hpb_dmae_device *hpbdev, u32 data)
> +{
> +	__raw_writel(data, hpbdev->chan_reg + DCMDR);
> +}
> +
> +static void hsrstr_write(struct hpb_dmae_device *hpbdev, u32 ch)
> +{
> +	__raw_writel(0x1, hpbdev->comm_reg + HSRSTR(ch));
> +}
why do you need reads for specfic registers? And why isn't this using above
helpers?


> +static u32 dintsr_read(struct hpb_dmae_device *hpbdev, u32 ch)
> +{
> +	u32 v;
> +
> +	if (ch < 32)
> +		v = __raw_readl(hpbdev->comm_reg + DINTSR0) >> ch;
> +	else
> +		v = __raw_readl(hpbdev->comm_reg + DINTSR1) >> (ch - 32);
ditto

> +	return v & 0x1;
> +}
> +
> +static void dintcr_write(struct hpb_dmae_device *hpbdev, u32 ch)
> +{
> +	if (ch < 32)
> +		__raw_writel((0x1 << ch), hpbdev->comm_reg + DINTCR0);
> +	else
> +		__raw_writel((0x1 << (ch - 32)), hpbdev->comm_reg + DINTCR1);
> +}
> +
> +static void asyncmdr_write(struct hpb_dmae_device *hpbdev, u32 data)
> +{
> +	__raw_writel(data, hpbdev->mode_reg);
> +}
> +
> +static u32 asyncmdr_read(struct hpb_dmae_device *hpbdev)
> +{
> +	return __raw_readl(hpbdev->mode_reg);
> +}
> +
> +static void hpb_dmae_enable_int(struct hpb_dmae_device *hpbdev, u32 ch)
> +{
> +	u32 intreg;
> +
> +	spin_lock_irq(&hpbdev->reg_lock);
> +	if (ch < 32) {
> +		intreg = __raw_readl(hpbdev->comm_reg + DINTMR0);
> +		__raw_writel(BIT(ch) | intreg, hpbdev->comm_reg + DINTMR0);
> +	} else {
> +		intreg = __raw_readl(hpbdev->comm_reg + DINTMR1);
> +		__raw_writel(BIT(ch - 32) | intreg, hpbdev->comm_reg + DINTMR1);
> +	}
> +	spin_unlock_irq(&hpbdev->reg_lock);
> +}
> +
> +static void hpb_dmae_async_reset(struct hpb_dmae_device *hpbdev, u32 data)
> +{
> +	u32 rstr;
> +	int timeout = 10000;	/* 100 ms */
> +
> +	spin_lock(&hpbdev->reg_lock);
> +	rstr = __raw_readl(hpbdev->reset_reg);
> +	rstr |= data;
> +	__raw_writel(rstr, hpbdev->reset_reg);
> +	do {
> +		rstr = __raw_readl(hpbdev->reset_reg);
> +		if ((rstr & data) == data)
> +			break;
> +		udelay(10);
> +	} while (timeout--);
> +
> +	if (timeout < 0)
<= perhaps

> +		dev_err(hpbdev->shdma_dev.dma_dev.dev,
> +			"%s timeout\n", __func__);
> +
> +	rstr &= ~data;
> +	__raw_writel(rstr, hpbdev->reset_reg);
no barriers?

> +	spin_unlock(&hpbdev->reg_lock);
> +}
> +
> +static void hpb_dmae_set_async_mode(struct hpb_dmae_device *hpbdev,
> +				    u32 mask, u32 data)
> +{
> +	u32 mode;
> +
> +	spin_lock_irq(&hpbdev->reg_lock);
> +	mode = asyncmdr_read(hpbdev);
> +	mode &= ~mask;
> +	mode |= data;
> +	asyncmdr_write(hpbdev, mode);
> +	spin_unlock_irq(&hpbdev->reg_lock);
> +}
> +
> +static void hpb_dmae_ctl_stop(struct hpb_dmae_device *hpbdev)
> +{
> +	dcmdr_write(hpbdev, DCMDR_DQSPD);
> +}
> +
> +static void hpb_dmae_reset(struct hpb_dmae_device *hpbdev)
> +{
> +	u32 ch;
> +
> +	for (ch = 0; ch < hpbdev->pdata->num_hw_channels; ch++)
> +		hsrstr_write(hpbdev, ch);
> +}
> +
> +static unsigned int calc_xmit_shift(struct hpb_dmae_chan *hpb_chan)
> +{
> +	struct hpb_dmae_device *hpbdev = to_dev(hpb_chan);
> +	struct hpb_dmae_pdata *pdata = hpbdev->pdata;
> +	int width = ch_reg_read(hpb_chan, DCR);
> +	int i;
> +
> +	switch (width & (DCR_SPDS_MASK | DCR_DPDS_MASK)) {
> +	case DCR_SPDS_8BIT | DCR_DPDS_8BIT:
> +	default:
> +		i = XMIT_SZ_8BIT;
> +		break;
this is unconventional, typically default is supposed to be last and is more
readble IMO


> +static bool hpb_dmae_desc_completed(struct shdma_chan *schan,
> +				    struct shdma_desc *sdesc)
> +{
> +	return true;
> +}
always?

> +/* DMA control register (DCR) bits */
> +#define	DCR_DTAMD	(1u << 26)
> +#define	DCR_DTAC	(1u << 25)
> +#define	DCR_DTAU	(1u << 24)
> +#define	DCR_DTAU1	(1u << 23)
> +#define	DCR_SWMD	(1u << 22)
> +#define	DCR_BTMD	(1u << 21)
> +#define	DCR_PKMD	(1u << 20)
> +#define	DCR_CT		(1u << 18)
> +#define	DCR_ACMD	(1u << 17)
> +#define	DCR_DIP		(1u << 16)
> +#define	DCR_SMDL	(1u << 13)
> +#define	DCR_SPDAM	(1u << 12)
> +#define	DCR_SDRMD_MASK	(3u << 10)
> +#define	DCR_SDRMD_MOD	(0u << 10)
> +#define	DCR_SDRMD_AUTO	(1u << 10)
> +#define	DCR_SDRMD_TIMER	(2u << 10)
> +#define	DCR_SPDS_MASK	(3u << 8)
> +#define	DCR_SPDS_8BIT	(0u << 8)
> +#define	DCR_SPDS_16BIT	(1u << 8)
> +#define	DCR_SPDS_32BIT	(2u << 8)
> +#define	DCR_DMDL	(1u << 5)
> +#define	DCR_DPDAM	(1u << 4)
> +#define	DCR_DDRMD_MASK	(3u << 2)
> +#define	DCR_DDRMD_MOD	(0u << 2)
> +#define	DCR_DDRMD_AUTO	(1u << 2)
> +#define	DCR_DDRMD_TIMER	(2u << 2)
> +#define	DCR_DPDS_MASK	(3u << 0)
> +#define	DCR_DPDS_8BIT	(0u << 0)
> +#define	DCR_DPDS_16BIT	(1u << 0)
> +#define	DCR_DPDS_32BIT	(2u << 0)
again need namespace..

> +
> +/* Asynchronous reset register (ASYNCRSTR) bits */
> +#define	ASYNCRSTR_ASRST41	BIT(10)
> +#define	ASYNCRSTR_ASRST40	BIT(9)
> +#define	ASYNCRSTR_ASRST39	BIT(8)
> +#define	ASYNCRSTR_ASRST27	BIT(7)
> +#define	ASYNCRSTR_ASRST26	BIT(6)
> +#define	ASYNCRSTR_ASRST25	BIT(5)
> +#define	ASYNCRSTR_ASRST24	BIT(4)
> +#define	ASYNCRSTR_ASRST23	BIT(3)
> +#define	ASYNCRSTR_ASRST22	BIT(2)
> +#define	ASYNCRSTR_ASRST21	BIT(1)
> +#define	ASYNCRSTR_ASRST20	BIT(0)
ditto...

~Vinod
-- 
