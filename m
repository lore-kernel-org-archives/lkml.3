Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbaAHKxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:53:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63229 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaAHKxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:53:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jingchang Lu <jingchang.lu@freescale.com>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCHv8 2/2] dma: Add Freescale eDMA engine driver support
Date: Wed, 08 Jan 2014 11:53:43 +0100
Message-ID: <5890639.zaOC7MRE09@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <5e626cf3587f4a0eb325dd7032b8b60a@BL2PR03MB467.namprd03.prod.outlook.com>
References: <1388645544-5596-1-git-send-email-b35083@freescale.com> <1388645544-5596-3-git-send-email-b35083@freescale.com> <5e626cf3587f4a0eb325dd7032b8b60a@BL2PR03MB467.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:2O55ZDKU7lg8IehisGeGuQwCauB1TysiJfAXaBLpYFB
 T6YuHuw55VOuopU+hikZTXu8AjEoGn9sePDNj1rpUUxTDu26d+
 zbbNVIhhvpIBKtuykV+GzzCSHqz+mdLHIIW5L46/uBtEJyEpIO
 xdfwdNlzk7lLb19HwbopkcmV9VXsDWs/xewEMbkxptMGwWbWAu
 e0+YGYnd2GY3BLJRZ3XcvFDNiD2+RGojpVZQ1N0dm6F2VjR0pm
 A9yuVXtjwuHXVwyqr7S9ltmvd3/O7oZnBYa2Rc1xS91pGyOCzV
 WgdX2Ctc3gckWTgIDra5EsD+06hUmKppIkHVHhU/hADfX0JD+d
 IC4ByD8d5b7ILF9ndU5E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 January 2014 10:24:38 Jingchang Lu wrote:

> > +- clocks : Phandle of the DMA channel group block clock of the eDMA
> > module
> > +- clock-names : The channel group block clock names

Turn these around and first define the required names, then state
that 'clocks' should contain none clock specifier for each clock
name.

> > +sai2: sai@40031000 {
> > +	compatible = "fsl,vf610-sai";
> > +	reg = <0x40031000 0x1000>;
> > +	interrupts = <0 86 0x04>;
> > +	clocks = <&clks VF610_CLK_SAI2>;
> > +	clock-names = "sai";
> > +	dma-names = "tx", "rx";
> > +	dmas = <&edma0 VF610_EDMA_DMAMUX0 VF610_EDMA0_MUX0_SAI2_TX>,
> > +		<&edma0 VF610_EDMA_DMAMUX0 VF610_EDMA0_MUX0_SAI2_RX>;
> > +	status = "disabled";
> > +};

It seems wrong to have macros defined like VF610_EDMA0_MUX0_SAI2_TX,
in particular in the example. These should just be literal numbers.

It's ok to have macros for the VF610_EDMA_DMAMUX0, but I suspect
that the possible values are just '0' and '1', which means a literal
would be just as easy here.

> > +struct fsl_edma_hw_tcd {
> > +	u32	saddr;
> > +	u16	soff;
> > +	u16	attr;
> > +	u32	nbytes;
> > +	u32	slast;
> > +	u32	daddr;
> > +	u16	doff;
> > +	u16	citer;
> > +	u32	dlast_sga;
> > +	u16	csr;
> > +	u16	biter;
> > +} __packed;

The structure is packed already, and marking it __packed
will just mean that the compiler can't access the members
atomically. Please remove the __packed keyword.

> > +/* bytes swapping according to eDMA controller's endian */
> > +#define EDMA_SWAP16(e, v)	(__force u16)(e->big_endian ?
> > cpu_to_be16(v) : cpu_to_le16(v))
> > +#define EDMA_SWAP32(e, v)	(__force u32)(e->big_endian ?
> > cpu_to_be32(v) : cpu_to_le32(v))

Maybe use inline functions for these?

> > +/*
> > + * copying of ARM read{b,w,l) and write{b,w,l) macro definations
> > + * except for doing default swap of cpu_to_le32, the bytes swap
> > + * is done depending on eDMA controller's endian defination,
> > + * which may be big-endian or little-endian.
> > + */
> > +static inline u16 edma_readw(void __iomem *addr)
> > +{
> > +	u16 __v = (__force u16) __raw_readw(addr);
> > +
> > +	__iormb();
> > +	return __v;
> > +}

The comment doesn't seem to match the implementation: You don't
actually do swaps here at all, which means this will fail when
your kernel is running in big-endian mode. Just use the regular
readw() etc, or use ioread16/ioread16be depending on the flag,
and get rid of your EDMA_SWAP macros.

No need to come up with your own scheme when the problem has
been solved already elsewhere.

> > +static irqreturn_t fsl_edma_irq_handler(int irq, void *dev_id)
> > +{
> > +	if (fsl_edma_tx_handler(irq, dev_id) == IRQ_HANDLED)
> > +		return IRQ_HANDLED;
> > +
> > +	return fsl_edma_err_handler(irq, dev_id);
> > +}

Does this do the right thing if both completion and error are
signalled at the same time? It seems you'd miss the error interrupt.

> > +static bool fsl_edma_filter_fn(struct dma_chan *chan, void *mux)
> > +{
> > +	 return (chan->chan_id / DMAMUX_NR) == (u32)mux;
> > +}
> > +
> > +static struct dma_chan *fsl_edma_xlate(struct of_phandle_args *dma_spec,
> > +		struct of_dma *ofdma)
> > +{
> > +	struct dma_chan *chan;
> > +	dma_cap_mask_t mask;
> > +
> > +	if (dma_spec->args_count != 2)
> > +		return NULL;
> > +
> > +	dma_cap_zero(mask);
> > +	dma_cap_set(DMA_SLAVE, mask);
> > +	dma_cap_set(DMA_CYCLIC, mask);
> > +	chan = dma_request_channel(mask, fsl_edma_filter_fn, (void
> > *)dma_spec->args[0]);
> > +	if (chan)
> > +		fsl_edma_chan_mux(to_fsl_edma_chan(chan), dma_spec->args[1],
> > true);
> > +	return chan;
> > +}

Please remove the filter function now and use dma_get_slave_chan
with the correct channel as an argument. No need to walk all
available channels in the system and introduce bugs by not
ignoring other dma engines.

	Arnd
