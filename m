Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaAIKmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 05:42:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:60009 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbaAIKmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 05:42:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jingchang Lu <jingchang.lu@freescale.com>
Subject: Re: [PATCHv8 2/2] dma: Add Freescale eDMA engine driver support
Date: Thu, 9 Jan 2014 11:42:34 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
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
References: <1388645544-5596-1-git-send-email-b35083@freescale.com> <5890639.zaOC7MRE09@wuerfel> <4efd24a1219547cbbf0ce8ec66d762e5@BL2PR03MB467.namprd03.prod.outlook.com>
In-Reply-To: <4efd24a1219547cbbf0ce8ec66d762e5@BL2PR03MB467.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201401091142.35226.arnd@arndb.de>
X-Provags-ID: V02:K0:gAvoB1lgIt9ZzkqEONFDhyMEAXzEdhTn3cEQnnQTuTa
 vrnnfB0iEAvkrcu+ZKv7qU3hiso24qdEnpNKc8BFGrpIGzwIWO
 IcHeD2qxkj01WEDoOWxNG+KdCqw4I0rCuaPFdMgg0IQBZDMnti
 qL8ZeoL0GJ8/Fo0UqaFP82KqLjFHWun0F4EYkkzfX+BjxkoFLa
 K60kbQFxWT1G5wTsN5sfJ1+bn+triFPwdVmrcgbBNYLF72JqOU
 oApqvRZ/cFdM6ugUqrDzUQbOprP4zxjKtlIovmW9BHXlbIlPsO
 Fpya2IMhvdwqAKRmY78FQY0MQIqsBHhMd8NSYZaPtTM6U51s7E
 bBulR/3ToE8U4P4rtGmQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 January 2014, Jingchang Lu wrote:
> > > > +sai2: sai@40031000 {
> > > > +	compatible = "fsl,vf610-sai";
> > > > +	reg = <0x40031000 0x1000>;
> > > > +	interrupts = <0 86 0x04>;
> > > > +	clocks = <&clks VF610_CLK_SAI2>;
> > > > +	clock-names = "sai";
> > > > +	dma-names = "tx", "rx";
> > > > +	dmas = <&edma0 VF610_EDMA_DMAMUX0 VF610_EDMA0_MUX0_SAI2_TX>,
> > > > +		<&edma0 VF610_EDMA_DMAMUX0 VF610_EDMA0_MUX0_SAI2_RX>;
> > > > +	status = "disabled";
> > > > +};
> > 
> > It seems wrong to have macros defined like VF610_EDMA0_MUX0_SAI2_TX,
> > in particular in the example. These should just be literal numbers.
> [Lu Jingchang-b35083] 
> This eDMA engineer requires two specifiers, one is a mux group id, the other is a request source id.
> The VF610_EDMA0_MUX0_SAI2_TX is sai's tx dma request source id, it is defined as a literal number.
> There are totally more than 100 request source id, I have them macros defined to make it referenced
> easily and clearly, just like some clock binding done.
> The macros are defined in include/dt-bindings/dma/vf610-edma.h.

The clock bindings are special because the macros there tend to be made
up for controllers that just have a bunch of clocks at random register
locations.

This is not the case for DMA bindings (or some of the more regular clock
controllers), so there is absolutely no reason to define those macros
in a header file, it just adds artificial dependencies between the
driver, SoC support and the binding.

If the numbers are the same as the ones provided in the data sheet,
just use the numbers and remove the macros.

> > > > +/*
> > > > + * copying of ARM read{b,w,l) and write{b,w,l) macro definations
> > > > + * except for doing default swap of cpu_to_le32, the bytes swap
> > > > + * is done depending on eDMA controller's endian defination,
> > > > + * which may be big-endian or little-endian.
> > > > + */
> > > > +static inline u16 edma_readw(void __iomem *addr)
> > > > +{
> > > > +	u16 __v = (__force u16) __raw_readw(addr);
> > > > +
> > > > +	__iormb();
> > > > +	return __v;
> > > > +}
> > 
> > The comment doesn't seem to match the implementation: You don't
> > actually do swaps here at all, which means this will fail when
> > your kernel is running in big-endian mode. Just use the regular
> > readw() etc, or use ioread16/ioread16be depending on the flag,
> > and get rid of your EDMA_SWAP macros.
> > 
> > No need to come up with your own scheme when the problem has
> > been solved already elsewhere.
> The working scenario for this device is, the cpu running in little-endian mode,
> While the eDMA module running in little- or big-endian mode. This device is currently
> running on ARM architecture only, and I notice that ARM's little-endian readl/writel
> treats all value as little-endian. This is not matching our scenario here. So I removed
> the default cpu_to_le32() in the readl(), and put it in EDMA_SWAP32() to satisfy the
> required.

You are right, your code is actually correct on all combinations
of big-endian and little-endian ARM CPUs. However, I would argue that
it's unusual style, and not portable to other architectures (e.g. arm64)
because the definition of readl() is highly architecture dependent.
It would also be problematic if the arm definition has to change
in some form and this driver is overlooked.

I would still recommend doing an implementation like

static inline u16 edma_readw(struct fsl_edma_engine *edma, u16 val, unsigned long offset)
{
	if (edma->big_endian)
		iowrite16be(val, edma->membase + offset);
	else
		iowrite16(val, edma->membase + offset);
}


This would simplify the callers that now can replace

        cur_addr = EDMA_SWAP32(fsl_chan->edma, edma_readl(addr + EDMA_TCD_SADDR(ch)));

with 

	cur_addr = edma_readl(fsl_chan->edma, EDMA_TCD_SADDR(ch));

which IMHO is much easier to read. For accessing muxbase, you
don't have to use your own version, because all accesses are
single-byte.

BTW, I noticed that fsl_edma_set_tcd_params() is calling edma_writew()
and edma_writel() without an endian-swap, so I assume it is still
broken on big-endian CPUs, and likely also on big-endian eDMA engines.

> > > > +static irqreturn_t fsl_edma_irq_handler(int irq, void *dev_id)
> > > > +{
> > > > +	if (fsl_edma_tx_handler(irq, dev_id) == IRQ_HANDLED)
> > > > +		return IRQ_HANDLED;
> > > > +
> > > > +	return fsl_edma_err_handler(irq, dev_id);
> > > > +}
> > 
> > Does this do the right thing if both completion and error are
> > signalled at the same time? It seems you'd miss the error interrupt.
> I think the error would occur rarely, so if the transmission irq entered,
> it will return directly after handling. If there is really an error occur,
> the interrupt will be raised again without transmission interrupt flag, then
> the irq handler would execute fsl_edma_err_handler() function.

Ah, so the error interrupt is level triggered? That's ok then.

> > > > +static bool fsl_edma_filter_fn(struct dma_chan *chan, void *mux)
> > > > +{
> > > > +	 return (chan->chan_id / DMAMUX_NR) == (u32)mux;
> > > > +}
> > > > +
> > > > +static struct dma_chan *fsl_edma_xlate(struct of_phandle_args
> > *dma_spec,
> > > > +		struct of_dma *ofdma)
> > > > +{
> > > > +	struct dma_chan *chan;
> > > > +	dma_cap_mask_t mask;
> > > > +
> > > > +	if (dma_spec->args_count != 2)
> > > > +		return NULL;
> > > > +
> > > > +	dma_cap_zero(mask);
> > > > +	dma_cap_set(DMA_SLAVE, mask);
> > > > +	dma_cap_set(DMA_CYCLIC, mask);
> > > > +	chan = dma_request_channel(mask, fsl_edma_filter_fn, (void
> > > > *)dma_spec->args[0]);
> > > > +	if (chan)
> > > > +		fsl_edma_chan_mux(to_fsl_edma_chan(chan), dma_spec->args[1],
> > > > true);
> > > > +	return chan;
> > > > +}
> > 
> > Please remove the filter function now and use dma_get_slave_chan
> > with the correct channel as an argument. No need to walk all
> > available channels in the system and introduce bugs by not
> > ignoring other dma engines.
>
> The dma slave request can only be allocated to channel of particular channels group indicated by
> the mux group id specifier. and the second specifier is the request id, not the channel number,
> so to use the dma_get_slave_chan, I would find the channel for this request by walking all the
> available channels manually.

Ah, I missed that you only check the mux number, not the channel number.

The current version however is buggy because you don't check that you
are actually looking at the right eDMA instance, or an eDMA at all, rather
than some other random dma engine that may be connected to an external
bus.

It is possible to fix that, but I suspect that would involve more
complex code than finding an appropriate channel first and then
calling dma_get_slave_chan() on that.
I would suggest keeping a list of channels per dmamux and walking that
list until you find one that succeeds in dma_get_slave_chan().

	Arnd
