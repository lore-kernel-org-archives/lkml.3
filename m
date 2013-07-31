Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760798Ab3GaVhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 17:37:03 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:33530 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757735Ab3GaVhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 17:37:00 -0400
Message-ID: <51F9837E.3070000@cogentembedded.com>
Date: Thu, 01 Aug 2013 01:37:02 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: djbw@fb.com, linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Max Filippov <max.filippov@cogentembedded.com>
Subject: Re: [PATCH] dma: add driver for R-Car HPB-DMAC
References: <201306300015.50713.sergei.shtylyov@cogentembedded.com> <20130729150552.GM29095@intel.com>
In-Reply-To: <20130729150552.GM29095@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/29/2013 07:05 PM, Vinod Koul wrote:

>> +config RCAR_HPB_DMAE
>> +	tristate "Renesas R-Car HPB DMAC support"
>> +	depends on SH_DMAE_BASE

> you should select DMA stuff here

    CONFIG_DMAENGINE is already selected by CONFIG_SH_DMAE_BASE.

>> +#define DSAR0		0x00
>> +#define DDAR0		0x04
>> +#define DTCR0		0x08
>> +#define DSAR1		0x0C
>> +#define DDAR1		0x10
>> +#define DTCR1		0x14
>> +#define DSASR		0x18
>> +#define DDASR		0x1C
>> +#define DTCSR		0x20
>> +#define DPTR		0x24
>> +#define DCR		0x28
>> +#define DCMDR		0x2C
>> +#define DSTPR		0x30
>> +#define DSTSR		0x34
>> +#define DDBGR		0x38
>> +#define DDBGR2		0x3C
>> +#define HPB_CHAN(n)	(0x40 * (n))

> Pls namespace this aptly

    You mean prefixing with something like 'HPBDMA_'? Not that I like that 
idea, but OK. Note that the SHDMA driver doesn't do it.

>> +/* DMA command register (DCMDR) bits */
>> +#define DCMDR_BDOUT	BIT(7)
>> +#define DCMDR_DQSPD	BIT(6)
>> +#define DCMDR_DQSPC	BIT(5)
>> +#define DCMDR_DMSPD	BIT(4)
>> +#define DCMDR_DMSPC	BIT(3)
>> +#define DCMDR_DQEND	BIT(2)
>> +#define DCMDR_DNXT	BIT(1)
>> +#define DCMDR_DMEN	BIT(0)

> ditto

    They are already kind of name-spaced with the register name. I'm afraid 
the names will grow too long with yet another prefix but if you insist...

>> +static void ch_reg_write(struct hpb_dmae_chan *hpb_dc, u32 data, u32 reg)
>> +{
>> +	__raw_writel(data, hpb_dc->base + reg);
>> +}
>> +
>> +static u32 ch_reg_read(struct hpb_dmae_chan *hpb_dc, u32 reg)
>> +{
>> +	return __raw_readl(hpb_dc->base + reg);
>> +}

> You dont need barrier?

    Where, after a read? Seems to work fine without any barriers...

>> +static void dcmdr_write(struct hpb_dmae_device *hpbdev, u32 data)
>> +{
>> +	__raw_writel(data, hpbdev->chan_reg + DCMDR);
>> +}
>> +
>> +static void hsrstr_write(struct hpb_dmae_device *hpbdev, u32 ch)
>> +{
>> +	__raw_writel(0x1, hpbdev->comm_reg + HSRSTR(ch));
>> +}

> why do you need reads

    You mean writes?

> for specfic registers?

    Can remove those ones probably, although the latter has value written 
predefined.

> And why isn't this using above helpers?

    Because those are for channel registers, and these functions write to the 
common registers.

>> +static u32 dintsr_read(struct hpb_dmae_device *hpbdev, u32 ch)
>> +{
>> +	u32 v;
>> +
>> +	if (ch < 32)
>> +		v = __raw_readl(hpbdev->comm_reg + DINTSR0) >> ch;
>> +	else
>> +		v = __raw_readl(hpbdev->comm_reg + DINTSR1) >> (ch - 32);

> ditto

    I think this case is rather self-explaining.

>> +	return v & 0x1;
>> +}
[...]
>> +static void hpb_dmae_async_reset(struct hpb_dmae_device *hpbdev, u32 data)
>> +{
>> +	u32 rstr;
>> +	int timeout = 10000;	/* 100 ms */
>> +
>> +	spin_lock(&hpbdev->reg_lock);
>> +	rstr = __raw_readl(hpbdev->reset_reg);
>> +	rstr |= data;
>> +	__raw_writel(rstr, hpbdev->reset_reg);
>> +	do {
>> +		rstr = __raw_readl(hpbdev->reset_reg);
>> +		if ((rstr & data) == data)
>> +			break;
>> +		udelay(10);
>> +	} while (timeout--);
>> +
>> +	if (timeout < 0)

> <= perhaps

    No, due to post-decrement we'll never reach this point with 0 on timeout.

>> +		dev_err(hpbdev->shdma_dev.dma_dev.dev,
>> +			"%s timeout\n", __func__);
>> +
>> +	rstr &= ~data;
>> +	__raw_writel(rstr, hpbdev->reset_reg);

> no barriers?

    Seem to work fine without. Max, what can you say?

>> +	spin_unlock(&hpbdev->reg_lock);
>> +}

[...]

>> +static unsigned int calc_xmit_shift(struct hpb_dmae_chan *hpb_chan)
>> +{
>> +	struct hpb_dmae_device *hpbdev = to_dev(hpb_chan);
>> +	struct hpb_dmae_pdata *pdata = hpbdev->pdata;
>> +	int width = ch_reg_read(hpb_chan, DCR);
>> +	int i;
>> +
>> +	switch (width & (DCR_SPDS_MASK | DCR_DPDS_MASK)) {
>> +	case DCR_SPDS_8BIT | DCR_DPDS_8BIT:
>> +	default:
>> +		i = XMIT_SZ_8BIT;
>> +		break;

> this is unconventional, typically default is supposed to be last and is more
> readble IMO

   OK, though arguable.

>> +static bool hpb_dmae_desc_completed(struct shdma_chan *schan,
>> +				    struct shdma_desc *sdesc)
>> +{
>> +	return true;
>> +}

> always?

    I'll have to defer this question to Max.

>> +/* DMA control register (DCR) bits */
>> +#define	DCR_DTAMD	(1u << 26)
>> +#define	DCR_DTAC	(1u << 25)
>> +#define	DCR_DTAU	(1u << 24)
>> +#define	DCR_DTAU1	(1u << 23)
>> +#define	DCR_SWMD	(1u << 22)
>> +#define	DCR_BTMD	(1u << 21)
>> +#define	DCR_PKMD	(1u << 20)
>> +#define	DCR_CT		(1u << 18)
>> +#define	DCR_ACMD	(1u << 17)
>> +#define	DCR_DIP		(1u << 16)
>> +#define	DCR_SMDL	(1u << 13)
>> +#define	DCR_SPDAM	(1u << 12)
>> +#define	DCR_SDRMD_MASK	(3u << 10)
>> +#define	DCR_SDRMD_MOD	(0u << 10)
>> +#define	DCR_SDRMD_AUTO	(1u << 10)
>> +#define	DCR_SDRMD_TIMER	(2u << 10)
>> +#define	DCR_SPDS_MASK	(3u << 8)
>> +#define	DCR_SPDS_8BIT	(0u << 8)
>> +#define	DCR_SPDS_16BIT	(1u << 8)
>> +#define	DCR_SPDS_32BIT	(2u << 8)
>> +#define	DCR_DMDL	(1u << 5)
>> +#define	DCR_DPDAM	(1u << 4)
>> +#define	DCR_DDRMD_MASK	(3u << 2)
>> +#define	DCR_DDRMD_MOD	(0u << 2)
>> +#define	DCR_DDRMD_AUTO	(1u << 2)
>> +#define	DCR_DDRMD_TIMER	(2u << 2)
>> +#define	DCR_DPDS_MASK	(3u << 0)
>> +#define	DCR_DPDS_8BIT	(0u << 0)
>> +#define	DCR_DPDS_16BIT	(1u << 0)
>> +#define	DCR_DPDS_32BIT	(2u << 0)

> again need namespace..

    Again afraid of too long names (and kinda namespaced already) but OK...

>> +
>> +/* Asynchronous reset register (ASYNCRSTR) bits */
>> +#define	ASYNCRSTR_ASRST41	BIT(10)
>> +#define	ASYNCRSTR_ASRST40	BIT(9)
>> +#define	ASYNCRSTR_ASRST39	BIT(8)
>> +#define	ASYNCRSTR_ASRST27	BIT(7)
>> +#define	ASYNCRSTR_ASRST26	BIT(6)
>> +#define	ASYNCRSTR_ASRST25	BIT(5)
>> +#define	ASYNCRSTR_ASRST24	BIT(4)
>> +#define	ASYNCRSTR_ASRST23	BIT(3)
>> +#define	ASYNCRSTR_ASRST22	BIT(2)
>> +#define	ASYNCRSTR_ASRST21	BIT(1)
>> +#define	ASYNCRSTR_ASRST20	BIT(0)

> ditto...

    Perhaps worth parametrizing these...

> ~Vinod

WBR, Sergei

