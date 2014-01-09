Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaAIMUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:20:00 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:62364 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaAIMTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:19:51 -0500
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
Date: Thu, 09 Jan 2014 13:19:13 +0100
Message-ID: <3667418.IelkNxAYvi@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <dde6cf78c07b40f29ac711fc27fe903c@BL2PR03MB467.namprd03.prod.outlook.com>
References: <1388645544-5596-1-git-send-email-b35083@freescale.com> <201401091142.35226.arnd@arndb.de> <dde6cf78c07b40f29ac711fc27fe903c@BL2PR03MB467.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:fwGYpAqfoFIaqZwsRJBJY9HquW8Ivx8HG/Bd/LjlXAc
 Z+zia8nATMZ2jTDsI5lT9sx3jhGqdUvbiioVnX3yt/xjFlYI8M
 RHxXpRseutuK84f8Kgzb6AGTnaJGEwG8BPoBhL9VqOCvpa2d63
 aFFwjT4SqmhsNwmwisW87wqc7Hg5e07X5fJi9+02t5NP/z7Gkj
 0VCaICc8Vg1RdoG/AJAA1Aor7R6IWAx0PeaQOxtv2YcoFUA1ZP
 j7AAzoxkfEabx//lrBpIlXg3uMUK6uKho4giZlzhUoMT2EiELw
 ARfl0iYL8ZDWmC51dUvKV5g3I0Ulb76H8Rrwd9x0eukSfPEaMB
 ORdmWTOi2dI08HjoFeM8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 January 2014 11:44:46 Jingchang Lu wrote:
> > 
> > On Thursday 09 January 2014, Jingchang Lu wrote:
> > > > > > +sai2: sai@40031000 {
> > > > > > +	compatible = "fsl,vf610-sai";
> > > > > > +	reg = <0x40031000 0x1000>;
> > > > > > +	interrupts = <0 86 0x04>;
> > > > > > +	clocks = <&clks VF610_CLK_SAI2>;
> > > > > > +	clock-names = "sai";
> > > > > > +	dma-names = "tx", "rx";
> > > > > > +	dmas = <&edma0 VF610_EDMA_DMAMUX0 VF610_EDMA0_MUX0_SAI2_TX>,
> > > > > > +		<&edma0 VF610_EDMA_DMAMUX0 VF610_EDMA0_MUX0_SAI2_RX>;
> > > > > > +	status = "disabled";
> > > > > > +};
> > > >
> > > > It seems wrong to have macros defined like VF610_EDMA0_MUX0_SAI2_TX,
> > > > in particular in the example. These should just be literal numbers.
> > > [Lu Jingchang-b35083]
> > > This eDMA engineer requires two specifiers, one is a mux group id, the
> > other is a request source id.
> > > The VF610_EDMA0_MUX0_SAI2_TX is sai's tx dma request source id, it is
> > defined as a literal number.
> > > There are totally more than 100 request source id, I have them macros
> > defined to make it referenced
> > > easily and clearly, just like some clock binding done.
> > > The macros are defined in include/dt-bindings/dma/vf610-edma.h.
> > 
> > The clock bindings are special because the macros there tend to be made
> > up for controllers that just have a bunch of clocks at random register
> > locations.
> > 
> > This is not the case for DMA bindings (or some of the more regular clock
> > controllers), so there is absolutely no reason to define those macros
> > in a header file, it just adds artificial dependencies between the
> > driver, SoC support and the binding.
> > 
> > If the numbers are the same as the ones provided in the data sheet,
> > just use the numbers and remove the macros.
>
> Yes, the request source id is defined in the data sheet.
> each eDMA controller has two muxes, some SoCs have two eDMA controllers
> while others have only one. The 1st eDMA's muxes are named mux0 and mux1,
> while the 2nd eDMA controller's muxes are named MUX2 and MUX3 in the datasheet,
> and I index them in each eDMA controller from 0 in the driver to handle them commonly.

Right. I don't object to the use of the macros for the muxes, that seems
fine and appropriate given your description.

> I defines the macro tending to give the info from the macro name, such as
> for the VF610_EDMA0_MUX0_SAI2_TX request source, implying the eDMA engine id 0,
> and the mux id should be 0. While VF610_EDMA1_MUX1_FTM0_CH0 implying eDMA engine id 1,
> mux 1. The request sources are shared between the two eDMA controller but need the user
> to select one manually when reference.

Note that the dma binding allows you to actually specify both engines
in this case. A slave device can have

	dma-names = "rx", "rx", "tx", "tx";
	dmas = <&edma0 0 12> <&edma1 0 12> <&edma0 0 13> <&edma1 0 13>;

and the requesting a channel from the slave driver will find
the first available one. In theory we could have some load-balancing
as well, but that has not been implemented.

> > You are right, your code is actually correct on all combinations
> > of big-endian and little-endian ARM CPUs. However, I would argue that
> > it's unusual style, and not portable to other architectures (e.g. arm64)
> > because the definition of readl() is highly architecture dependent.
> > It would also be problematic if the arm definition has to change
> > in some form and this driver is overlooked.
> [Lu Jingchang-b35083] 
> Yes, these definitions are highly depending on the arm32 arch. This device is only
> integrated in our arm32 SoCs currently, so I have only considered arm32.
> In arm32, it seems that the ioread32 and readl are the same in arm32,
> I will try your recommendation below to simplify the caller.

Ok, thanks. I generally insist on writing drivers in a portable way
if possible because they can serve as examples to other people, and
hardware often gets reused on other parts. I would expect that it's
possible that freescale eventually creates powerpc or arm64 devices
with the same edma controller, even if you are not currently aware
of any such products.

> > BTW, I noticed that fsl_edma_set_tcd_params() is calling edma_writew()
> > and edma_writel() without an endian-swap, so I assume it is still
> > broken on big-endian CPUs, and likely also on big-endian eDMA engines.
> The values written in fsl_edma_set_tcd_params() are pre-swapped in fill_tcd_params().
> The eDMA support hardware SGs, but the eDMA engine's sg format is required the same as
> the eDMA Controller's endian, so the SGs in memory to be loaded automatically by the eDMA 
> engine also required swapped properly. So they should be swapped specifically here.

Ah, I see now. I had noticed that before but then forgotten about it.

> > > > > > +static bool fsl_edma_filter_fn(struct dma_chan *chan, void *mux)
> > > > > > +{
> > > > > > +	 return (chan->chan_id / DMAMUX_NR) == (u32)mux;
> > > > > > +}
> > > > > > +
> > > > > > +static struct dma_chan *fsl_edma_xlate(struct of_phandle_args
> > > > *dma_spec,
> > > > > > +		struct of_dma *ofdma)
> > > > > > +{
> > > > > > +	struct dma_chan *chan;
> > > > > > +	dma_cap_mask_t mask;
> > > > > > +
> > > > > > +	if (dma_spec->args_count != 2)
> > > > > > +		return NULL;
> > > > > > +
> > > > > > +	dma_cap_zero(mask);
> > > > > > +	dma_cap_set(DMA_SLAVE, mask);
> > > > > > +	dma_cap_set(DMA_CYCLIC, mask);
> > > > > > +	chan = dma_request_channel(mask, fsl_edma_filter_fn, (void
> > > > > > *)dma_spec->args[0]);
> > > > > > +	if (chan)
> > > > > > +		fsl_edma_chan_mux(to_fsl_edma_chan(chan), dma_spec-
> > >args[1],
> > > > > > true);
> > > > > > +	return chan;
> > > > > > +}
> > > >
> > > > Please remove the filter function now and use dma_get_slave_chan
> > > > with the correct channel as an argument. No need to walk all
> > > > available channels in the system and introduce bugs by not
> > > > ignoring other dma engines.
> > >
> > > The dma slave request can only be allocated to channel of particular
> > channels group indicated by
> > > the mux group id specifier. and the second specifier is the request id,
> > not the channel number,
> > > so to use the dma_get_slave_chan, I would find the channel for this
> > request by walking all the
> > > available channels manually.
> > 
> > Ah, I missed that you only check the mux number, not the channel number.
> > 
> > The current version however is buggy because you don't check that you
> > are actually looking at the right eDMA instance, or an eDMA at all,
> > rather
> > than some other random dma engine that may be connected to an external
> > bus.
> > 
> > It is possible to fix that, but I suspect that would involve more
> > complex code than finding an appropriate channel first and then
> > calling dma_get_slave_chan() on that.
> > I would suggest keeping a list of channels per dmamux and walking that
> > list until you find one that succeeds in dma_get_slave_chan().
> The binding in DTS is to the eDMA engine, and the binding indicates the eDMA node
> (by <&edma0 ...>), the dma engine framework would find the proper eDMA engine device
> referenced in dts. This driver only supports dts reference, so I think the dma engine
> framework could guarantee the eDMA instance properly in of_dma_find_controller().

The problem is that dma_request_channel() does not get a reference to the
eDMA node here. It is a generic API function that returns the first
channel out of the global list of dma_chan structure that is unused
and gets a positive return code from the filter function. If you have
two edma instances in the system, you have a 50% chance to get a channel
that belongs to the other instance. 

The dma_get_slave_chan() interface was introduced to avoid this problem.

	Arnd
