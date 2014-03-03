Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbaCCJfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 04:35:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:5769 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbaCCJfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 04:35:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,576,1389772800"; 
   d="scan'208";a="491170219"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Sandeep Nair <sandeep_n@ti.com>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] dma: Add Keystone Packet DMA Engine driver
Thread-Topic: [PATCH] dma: Add Keystone Packet DMA Engine driver
Thread-Index: AQHPNsO6o9ModqlrGUSveR4fLV6RCQ==
Date: Mon, 3 Mar 2014 09:34:08 +0000
Message-ID: <1393839248.28803.116.camel@smile.fi.intel.com>
References: <1393628200-12317-1-git-send-email-santosh.shilimkar@ti.com>
In-Reply-To: <1393628200-12317-1-git-send-email-santosh.shilimkar@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.73]
Content-Type: text/plain; charset="utf-8"
Content-ID: <2887EF369C538B49A9AAA17760825066@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s239a6sC027130

On Fri, 2014-02-28 at 17:56 -0500, Santosh Shilimkar wrote:
> From: Sandeep Nair <sandeep_n@ti.com>
> 
> The Packet DMA driver sets up the dma channels and flows for the
> QMSS(Queue Manager SubSystem) who triggers the actual data movements
> across clients using destination queues. Every client modules like
> NETCP(Network Coprocessor), SRIO(Serial Rapid IO) and CRYPTO
> Engines has its own instance of packet dma hardware. QMSS has also
> an internal packet DMA module which is used as an infrastructure
> DMA with zero copy.
> 
> Patch adds DMAEngine driver for Keystone Packet DMA hardware.
> The specifics on the device tree bindings for Packet DMA can be
> found in:
> 	Documentation/devicetree/bindings/dma/keystone-pktdma.txt
> 
> The driver implements the configuration functions using standard DMAEngine
> apis. The data movement is managed by QMSS device driver.
> 

Few comments below.

> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Sandeep Nair <sandeep_n@ti.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
>  .../devicetree/bindings/dma/keystone-pktdma.txt    |   72 ++
>  drivers/dma/Kconfig                                |    8 +
>  drivers/dma/Makefile                               |    1 +
>  drivers/dma/keystone-pktdma.c                      |  795 ++++++++++++++++++++
>  include/dt-bindings/dma/keystone.h                 |   33 +
>  include/linux/keystone-pktdma.h                    |  168 +++++
>  6 files changed, 1077 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/dma/keystone-pktdma.txt
>  create mode 100644 drivers/dma/keystone-pktdma.c
>  create mode 100644 include/dt-bindings/dma/keystone.h
>  create mode 100644 include/linux/keystone-pktdma.h
> 
> diff --git a/Documentation/devicetree/bindings/dma/keystone-pktdma.txt b/Documentation/devicetree/bindings/dma/keystone-pktdma.txt
> new file mode 100644
> index 0000000..ea061d5
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/keystone-pktdma.txt
> @@ -0,0 +1,72 @@
> +Keystone Packet DMA Controller
> +
> +This document explains the device tree bindings for the packet dma
> +on keystone devices. The the Network coprocessor, Cypto engines
> +and the SRIO on Keystone devices all have their own packet dma modules.
> +Each individual packet dma has a certain number of RX channels,
> +RX flows and TX channels. Each instance of the packet DMA is being
> +initialized through device specific bindings.
> +
> +* DMA controller
> +
> +Required properties:
> + - compatible: Should be "ti,keystone-pktdma"
> + - reg: Should contain register location and length of the following pktdma
> +	register regions. The value for "reg-names" property of the respective
> +	region is specified in parenthesis.
> +	- Global control register region (global).
> +	- Tx DMA channel configuration register region (txchan).
> +	- Rx DMA channel configuration register region (rxchan).
> +	- Tx DMA channel Scheduler configuration register region (txsched).
> +	- Rx DMA flow configuration register region (rxflow).
> + - reg-names: Names for the above regions. The name to be used is specified in
> +	      the above description of "reg" property.
> + - qm-base-address: Base address of the logical queue managers for pktdma.
> + - #dma-cells: Has to be 1. Keystone-pktdma doesn't support anything else.
> +
> +Optional properties:
> + - enable-all: Enable all DMA channels.
> + - loop-back: To loopback Tx streaming I/F to Rx streaming I/F. Used for
> +	      infrastructure transfers.
> + - rx-retry-timeout: Number of pktdma cycles to wait before retry on buffer
> +		     starvation.
> +
> +Example:
> +	netcp-dma: pktdma@2004000 {
> +		compatible = "ti,keystone-pktdma";
> +		reg =	<0x2004000 0x100>,
> +			<0x2004400 0x120>,
> +			<0x2004800 0x300>,
> +			<0x2004c00 0x120>,
> +			<0x2005000 0x400>;
> +		reg-names = "global", "txchan", "rxchan", "txsched",
> +			     "rxflow";
> +		qm-base-address = <0x23a80000 0x23a90000
> +				   0x23aa0000 0x23ab0000>;
> +		#dma-cells = <1>;
> +		/* enable-all; */
> +		rx-retry-timeout = <3500>;
> +		/* loop-back; */
> +	};
> +
> +
> +* DMA client
> +
> +Required properties:
> +- dmas: One DMA request specifier consisting of a phandle to the DMA controller
> +	followed by the integer specifying the channel identifier. The channel
> +	identifier is encoded as follows:
> +	- bits 7-0: Tx DMA channel number or the Rx flow number.
> +	- bits 31-24: Channel type. 0xff for Tx DMA channel & 0xfe for Rx flow.
> +- dma-names: List of string identifiers for the DMA requests.
> +
> +Example:
> +
> +	netcp: netcp@2090000 {
> +		...
> +		dmas =	<&netcpdma KEYSTONE_DMA_RX_FLOW(22)>,
> +			<&netcpdma KEYSTONE_DMA_RX_FLOW(23)>,
> +			<&netcpdma KEYSTONE_DMA_TX_CHAN(8)>;
> +			dma-names = "netrx0", "netrx1", "nettx";
> +		...
> +	};
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 9bed1a2..722b99a 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -350,6 +350,14 @@ config MOXART_DMA
>  	help
>  	  Enable support for the MOXA ART SoC DMA controller.
>  
> +config KEYSTONE_PKTDMA
> +	tristate "TI Keystone Packet DMA support"
> +	depends on ARCH_KEYSTONE
> +	select DMA_ENGINE
> +	help
> +	  Enable support for the Packet DMA engine on Texas Instruments'
> +	  Keystone family of devices.
> +
>  config DMA_ENGINE
>  	bool
>  
> diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
> index a029d0f4..6d69c6d 100644
> --- a/drivers/dma/Makefile
> +++ b/drivers/dma/Makefile
> @@ -44,3 +44,4 @@ obj-$(CONFIG_DMA_JZ4740) += dma-jz4740.o
>  obj-$(CONFIG_TI_CPPI41) += cppi41.o
>  obj-$(CONFIG_K3_DMA) += k3dma.o
>  obj-$(CONFIG_MOXART_DMA) += moxart-dma.o
> +obj-$(CONFIG_KEYSTONE_PKTDMA) += keystone-pktdma.o
> diff --git a/drivers/dma/keystone-pktdma.c b/drivers/dma/keystone-pktdma.c
> new file mode 100644
> index 0000000..b3f77e5
> --- /dev/null
> +++ b/drivers/dma/keystone-pktdma.c
> @@ -0,0 +1,795 @@
> +/*
> + * Copyright (C) 2014 Texas Instruments Incorporated
> + * Authors:	Sandeep Nair <sandeep_n@ti.com>
> + *		Cyril Chemparathy <cyril@ti.com>
> + *		Santosh Shilimkar <santosh.shilimkar@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/io.h>
> +#include <linux/sched.h>
> +#include <linux/module.h>
> +#include <linux/dma-direction.h>
> +#include <linux/dmaengine.h>
> +#include <linux/interrupt.h>
> +#include <linux/of_dma.h>
> +#include <linux/of_address.h>
> +#include <linux/platform_device.h>
> +#include <linux/keystone-pktdma.h>
> +#include <linux/pm_runtime.h>
> +#include <dt-bindings/dma/keystone.h>
> +
> +#define BITS(x)			(BIT(x) - 1)
> +#define REG_MASK		0xffffffff
> +
> +#define DMA_LOOPBACK		BIT(31)
> +#define DMA_ENABLE		BIT(31)
> +#define DMA_TEARDOWN		BIT(30)
> +
> +#define DMA_TX_FILT_PSWORDS	BIT(29)
> +#define DMA_TX_FILT_EINFO	BIT(30)
> +#define DMA_TX_PRIO_SHIFT	0
> +#define DMA_RX_PRIO_SHIFT	16
> +#define DMA_PRIO_MASK		BITS(3)
> +#define DMA_PRIO_DEFAULT	0
> +#define DMA_RX_TIMEOUT_DEFAULT	17500 /* cycles */
> +#define DMA_RX_TIMEOUT_MASK	BITS(16)
> +#define DMA_RX_TIMEOUT_SHIFT	0
> +
> +#define CHAN_HAS_EPIB		BIT(30)
> +#define CHAN_HAS_PSINFO		BIT(29)
> +#define CHAN_ERR_RETRY		BIT(28)
> +#define CHAN_PSINFO_AT_SOP	BIT(25)
> +#define CHAN_SOP_OFF_SHIFT	16
> +#define CHAN_SOP_OFF_MASK	BITS(9)
> +#define DESC_TYPE_SHIFT		26
> +#define DESC_TYPE_MASK		BITS(2)
> +
> +/*
> + * QMGR & QNUM together make up 14 bits with QMGR as the 2 MSb's in the logical
> + * navigator cloud mapping scheme.
> + * using the 14bit physical queue numbers directly maps into this scheme.
> + */
> +#define CHAN_QNUM_MASK		BITS(14)
> +#define DMA_MAX_QMS		4
> +#define DMA_TIMEOUT		1000	/* msecs */
> +
> +struct reg_global {
> +	u32	revision;
> +	u32	perf_control;
> +	u32	emulation_control;
> +	u32	priority_control;
> +	u32	qm_base_address[4];
> +};
> +
> +struct reg_chan {
> +	u32	control;
> +	u32	mode;
> +	u32	__rsvd[6];
> +};
> +
> +struct reg_tx_sched {
> +	u32	prio;
> +};
> +
> +struct reg_rx_flow {
> +	u32	control;
> +	u32	tags;
> +	u32	tag_sel;
> +	u32	fdq_sel[2];
> +	u32	thresh[3];
> +};
> +
> +#define BUILD_CHECK_REGS()						\
> +	do {								\
> +		BUILD_BUG_ON(sizeof(struct reg_global)   != 32);	\
> +		BUILD_BUG_ON(sizeof(struct reg_chan)     != 32);	\
> +		BUILD_BUG_ON(sizeof(struct reg_rx_flow)  != 32);	\
> +		BUILD_BUG_ON(sizeof(struct reg_tx_sched) !=  4);	\
> +	} while (0)
> +
> +enum keystone_chan_state {
> +	/* stable states */
> +	CHAN_STATE_OPENED,
> +	CHAN_STATE_CLOSED,
> +};
> +
> +struct keystone_dma_device {
> +	struct dma_device		engine;
> +	bool				loopback, enable_all;
> +	unsigned			tx_priority, rx_priority, rx_timeout;
> +	unsigned			logical_queue_managers;
> +	unsigned			qm_base_address[DMA_MAX_QMS];
> +	struct reg_global __iomem	*reg_global;
> +	struct reg_chan __iomem		*reg_tx_chan;
> +	struct reg_rx_flow __iomem	*reg_rx_flow;
> +	struct reg_chan __iomem		*reg_rx_chan;
> +	struct reg_tx_sched __iomem	*reg_tx_sched;
> +	unsigned			max_rx_chan, max_tx_chan;
> +	unsigned			max_rx_flow;
> +	atomic_t			in_use;
> +};
> +#define to_dma(dma)	(&(dma)->engine)
> +#define dma_dev(dma)	((dma)->engine.dev)
> +
> +struct keystone_dma_chan {
> +	struct dma_chan			achan;
> +	enum dma_transfer_direction	direction;
> +	atomic_t			state;
> +	struct keystone_dma_device	*dma;
> +
> +	/* registers */
> +	struct reg_chan __iomem		*reg_chan;
> +	struct reg_tx_sched __iomem	*reg_tx_sched;
> +	struct reg_rx_flow __iomem	*reg_rx_flow;
> +
> +	/* configuration stuff */
> +	unsigned			channel, flow;
> +};
> +#define from_achan(ch)	container_of(ch, struct keystone_dma_chan, achan)
> +#define to_achan(ch)	(&(ch)->achan)
> +#define chan_dev(ch)	(&to_achan(ch)->dev->device)
> +#define chan_num(ch)	((ch->direction == DMA_MEM_TO_DEV) ? \
> +			ch->channel : ch->flow)
> +#define chan_vdbg(ch, format, arg...)				\
> +			dev_vdbg(chan_dev(ch), format, ##arg);
> +
> +/**
> + * dev_to_dma_chan - convert a device pointer to the its sysfs container object
> + * @dev - device node
> + */
> +static inline struct dma_chan *dev_to_dma_chan(struct device *dev)
> +{
> +	struct dma_chan_dev *chan_dev;
> +
> +	chan_dev = container_of(dev, typeof(*chan_dev), device);
> +	return chan_dev->chan;
> +}
> +
> +static inline enum keystone_chan_state
> +chan_get_state(struct keystone_dma_chan *chan)
> +{
> +	return atomic_read(&chan->state);
> +}
> +
> +static int chan_start(struct keystone_dma_chan *chan,
> +			struct dma_keystone_cfg *cfg)
> +{
> +	u32 v = 0;
> +
> +	if ((chan->direction == DMA_MEM_TO_DEV) && chan->reg_chan) {
> +		if (cfg->u.tx.filt_pswords)
> +			v |= DMA_TX_FILT_PSWORDS;
> +		if (cfg->u.tx.filt_einfo)
> +			v |= DMA_TX_FILT_EINFO;
> +		writel_relaxed(v, &chan->reg_chan->mode);
> +		writel_relaxed(DMA_ENABLE, &chan->reg_chan->control);
> +	}
> +
> +	if (chan->reg_tx_sched)
> +		writel_relaxed(cfg->u.tx.priority, &chan->reg_tx_sched->prio);
> +
> +	if (chan->reg_rx_flow) {
> +		v = 0;
> +
> +		if (cfg->u.rx.einfo_present)
> +			v |= CHAN_HAS_EPIB;
> +		if (cfg->u.rx.psinfo_present)
> +			v |= CHAN_HAS_PSINFO;
> +		if (cfg->u.rx.err_mode == DMA_RETRY)
> +			v |= CHAN_ERR_RETRY;
> +		v |= (cfg->u.rx.desc_type & DESC_TYPE_MASK) << DESC_TYPE_SHIFT;
> +		if (cfg->u.rx.psinfo_at_sop)
> +			v |= CHAN_PSINFO_AT_SOP;
> +		v |= (cfg->u.rx.sop_offset & CHAN_SOP_OFF_MASK)
> +			<< CHAN_SOP_OFF_SHIFT;
> +		v |= cfg->u.rx.dst_q & CHAN_QNUM_MASK;
> +
> +		writel_relaxed(v, &chan->reg_rx_flow->control);
> +		writel_relaxed(0, &chan->reg_rx_flow->tags);
> +		writel_relaxed(0, &chan->reg_rx_flow->tag_sel);
> +
> +		v =  cfg->u.rx.fdq[0] << 16;
> +		v |=  cfg->u.rx.fdq[1] & CHAN_QNUM_MASK;
> +		writel_relaxed(v, &chan->reg_rx_flow->fdq_sel[0]);
> +
> +		v =  cfg->u.rx.fdq[2] << 16;
> +		v |=  cfg->u.rx.fdq[3] & CHAN_QNUM_MASK;
> +		writel_relaxed(v, &chan->reg_rx_flow->fdq_sel[1]);
> +
> +		writel_relaxed(0, &chan->reg_rx_flow->thresh[0]);
> +		writel_relaxed(0, &chan->reg_rx_flow->thresh[1]);
> +		writel_relaxed(0, &chan->reg_rx_flow->thresh[2]);
> +	}
> +
> +	return 0;
> +}
> +
> +static int chan_teardown(struct keystone_dma_chan *chan)
> +{
> +	unsigned long end, value;
> +
> +	if (!chan->reg_chan)
> +		return 0;
> +
> +	/* indicate teardown */
> +	writel_relaxed(DMA_TEARDOWN, &chan->reg_chan->control);
> +
> +	/* wait for the dma to shut itself down */
> +	end = jiffies + msecs_to_jiffies(DMA_TIMEOUT);
> +	do {
> +		value = readl_relaxed(&chan->reg_chan->control);
> +		if ((value & DMA_ENABLE) == 0)
> +			break;
> +	} while (time_after(end, jiffies));
> +
> +	if (readl_relaxed(&chan->reg_chan->control) & DMA_ENABLE) {
> +		dev_err(chan_dev(chan), "timeout waiting for teardown\n");
> +		return -ETIMEDOUT;
> +	}
> +
> +	return 0;
> +}
> +
> +static void chan_stop(struct keystone_dma_chan *chan)
> +{
> +	if (chan->reg_rx_flow) {
> +		/* first detach fdqs, starve out the flow */
> +		writel_relaxed(0, &chan->reg_rx_flow->fdq_sel[0]);
> +		writel_relaxed(0, &chan->reg_rx_flow->fdq_sel[1]);
> +		writel_relaxed(0, &chan->reg_rx_flow->thresh[0]);
> +		writel_relaxed(0, &chan->reg_rx_flow->thresh[1]);
> +		writel_relaxed(0, &chan->reg_rx_flow->thresh[2]);
> +	}
> +
> +	/* teardown the dma channel */
> +	chan_teardown(chan);
> +
> +	/* then disconnect the completion side */
> +	if (chan->reg_rx_flow) {
> +		writel_relaxed(0, &chan->reg_rx_flow->control);
> +		writel_relaxed(0, &chan->reg_rx_flow->tags);
> +		writel_relaxed(0, &chan->reg_rx_flow->tag_sel);
> +	}
> +	chan_vdbg(chan, "channel stopped\n");
> +}
> +
> +static void keystone_dma_hw_init(struct keystone_dma_device *dma)
> +{
> +	unsigned v;
> +	int i;
> +
> +	v  = dma->loopback ? DMA_LOOPBACK : 0;
> +	writel_relaxed(v, &dma->reg_global->emulation_control);
> +
> +	v = readl_relaxed(&dma->reg_global->perf_control);
> +	v |= ((dma->rx_timeout & DMA_RX_TIMEOUT_MASK) << DMA_RX_TIMEOUT_SHIFT);
> +	writel_relaxed(v, &dma->reg_global->perf_control);
> +
> +	v = ((dma->tx_priority << DMA_TX_PRIO_SHIFT) |
> +	     (dma->rx_priority << DMA_RX_PRIO_SHIFT));
> +
> +	writel_relaxed(v, &dma->reg_global->priority_control);
> +
> +	if (dma->enable_all) {
> +		for (i = 0; i < dma->max_tx_chan; i++) {
> +			writel_relaxed(0, &dma->reg_tx_chan[i].mode);
> +			writel_relaxed(DMA_ENABLE,
> +				       &dma->reg_tx_chan[i].control);
> +		}
> +	}
> +
> +	/* Always enable all Rx channels. Rx paths are managed using flows */
> +	for (i = 0; i < dma->max_rx_chan; i++)
> +		writel_relaxed(DMA_ENABLE, &dma->reg_rx_chan[i].control);
> +
> +	for (i = 0; i < dma->logical_queue_managers; i++)
> +		writel_relaxed(dma->qm_base_address[i],
> +			       &dma->reg_global->qm_base_address[i]);
> +}
> +
> +static void keystone_dma_hw_destroy(struct keystone_dma_device *dma)
> +{
> +	int i;
> +	unsigned v;
> +
> +	v = ~DMA_ENABLE & REG_MASK;
> +
> +	for (i = 0; i < dma->max_rx_chan; i++)
> +		writel_relaxed(v, &dma->reg_rx_chan[i].control);
> +
> +	for (i = 0; i < dma->max_tx_chan; i++)
> +		writel_relaxed(v, &dma->reg_tx_chan[i].control);
> +}
> +
> +static int chan_init(struct dma_chan *achan)
> +{
> +	struct keystone_dma_chan *chan = from_achan(achan);
> +	struct keystone_dma_device *dma = chan->dma;
> +
> +	chan_vdbg(chan, "initializing %s channel\n",
> +		  chan->direction == DMA_MEM_TO_DEV   ? "transmit" :
> +		  chan->direction == DMA_DEV_TO_MEM ? "receive"  :
> +		  "unknown");
> +
> +	if (chan->direction != DMA_MEM_TO_DEV &&
> +	    chan->direction != DMA_DEV_TO_MEM) {

is_slave_direction().

> +		dev_err(chan_dev(chan), "bad direction\n");
> +		return -EINVAL;
> +	}
> +
> +	atomic_set(&chan->state, CHAN_STATE_OPENED);
> +
> +	if (atomic_inc_return(&dma->in_use) <= 1)
> +		keystone_dma_hw_init(dma);
> +
> +	return 0;
> +}
> +
> +static void chan_destroy(struct dma_chan *achan)
> +{
> +	struct keystone_dma_chan *chan = from_achan(achan);
> +	struct keystone_dma_device *dma = chan->dma;
> +
> +	if (chan_get_state(chan) == CHAN_STATE_CLOSED)
> +		return;
> +
> +	chan_vdbg(chan, "destroying channel\n");
> +	chan_stop(chan);
> +	atomic_set(&chan->state, CHAN_STATE_CLOSED);
> +	if (atomic_dec_return(&dma->in_use) <= 0)
> +		keystone_dma_hw_destroy(dma);
> +	chan_vdbg(chan, "channel destroyed\n");
> +}
> +
> +static int chan_keystone_config(struct keystone_dma_chan *chan,
> +		struct dma_keystone_cfg *cfg)
> +{
> +	if (chan_get_state(chan) != CHAN_STATE_OPENED)
> +		return -ENODEV;
> +
> +	if (cfg->sl_cfg.direction != chan->direction)
> +		return -EINVAL;

I think slave_config.direction is kinda deprecated.

> +
> +	return chan_start(chan, cfg);
> +}
> +
> +static int chan_control(struct dma_chan *achan, enum dma_ctrl_cmd cmd,
> +			unsigned long arg)
> +{
> +	struct keystone_dma_chan *chan = from_achan(achan);
> +	struct dma_keystone_cfg *keystone_config;
> +	struct dma_slave_config *dma_cfg;
> +	int ret;
> +
> +	switch (cmd) {
> +	case DMA_SLAVE_CONFIG:
> +		dma_cfg = (struct dma_slave_config *)arg;
> +		keystone_config = keystone_cfg_from_slave_config(dma_cfg);
> +		ret = chan_keystone_config(chan, keystone_config);
> +		break;
> +
> +	default:
> +		ret = -ENOTSUPP;
> +		break;
> +	}
> +	return ret;

You may avoid 'ret' variable at all. Just return value explicitly.

> +}
> +
> +static void __iomem *pktdma_get_regs(
> +		struct keystone_dma_device *dma, const char *name,
> +		resource_size_t *_size)
> +{
> +	struct device *dev = dma_dev(dma);
> +	struct device_node *node = dev->of_node;
> +	resource_size_t size;
> +	struct resource res;
> +	void __iomem *regs;
> +	int i;
> +
> +	i = of_property_match_string(node, "reg-names", name);
> +	if (of_address_to_resource(node, i, &res)) {
> +		dev_err(dev, "could not find %s resource(index %d)\n", name, i);
> +		return NULL;
> +	}
> +	size = resource_size(&res);
> +
> +	regs = of_iomap(node, i);
> +	if (!regs) {
> +		dev_err(dev, "could not map %s resource (index %d)\n", name, i);
> +		return NULL;
> +	}
> +
> +	dev_dbg(dev, "index: %d, res:%s, size:%x, phys:%x, virt:%p\n",
> +		i, name, (unsigned int)size, (unsigned int)res.start, regs);

I think here is better to use %pR to print resource.

> +
> +	if (_size)
> +		*_size = size;
> +
> +	return regs;
> +}
> +
> +static int pktdma_init_rx_chan(struct keystone_dma_chan *chan,
> +				      struct device_node *node,
> +				      u32 flow)
> +{
> +	struct keystone_dma_device *dma = chan->dma;
> +	struct device *dev = dma_dev(chan->dma);
> +
> +	chan->flow = flow;
> +	chan->reg_rx_flow = dma->reg_rx_flow + flow;
> +	dev_dbg(dev, "rx flow(%d) (%p)\n", chan->flow, chan->reg_rx_flow);
> +
> +	return 0;
> +}
> +
> +static int pktdma_init_tx_chan(struct keystone_dma_chan *chan,
> +				struct device_node *node,
> +				u32 channel)
> +{
> +	struct keystone_dma_device *dma = chan->dma;
> +	struct device *dev = dma_dev(chan->dma);
> +
> +	chan->channel = channel;
> +	chan->reg_chan = dma->reg_tx_chan + channel;
> +	chan->reg_tx_sched = dma->reg_tx_sched + channel;
> +	dev_dbg(dev, "tx channel(%d) (%p)\n", chan->channel, chan->reg_chan);
> +
> +	return 0;
> +}
> +
> +static int pktdma_init_chan(struct keystone_dma_device *dma,
> +				struct device_node *node,
> +				enum dma_transfer_direction dir,
> +				unsigned chan_num)
> +{
> +	struct device *dev = dma_dev(dma);
> +	struct keystone_dma_chan *chan;
> +	struct dma_chan *achan;
> +	int ret = -EINVAL;
> +
> +	chan = devm_kzalloc(dev, sizeof(*chan), GFP_KERNEL);
> +	if (!chan)
> +		return -ENOMEM;
> +
> +	achan = to_achan(chan);
> +	achan->device   = &dma->engine;
> +	chan->dma	= dma;
> +	chan->direction	= DMA_NONE;
> +	atomic_set(&chan->state, CHAN_STATE_OPENED);
> +
> +	if (dir == DMA_MEM_TO_DEV) {
> +		chan->direction = dir;
> +		ret = pktdma_init_tx_chan(chan, node, chan_num);
> +	} else if (dir == DMA_DEV_TO_MEM) {
> +		chan->direction = dir;
> +		ret = pktdma_init_rx_chan(chan, node, chan_num);
> +	} else {
> +		dev_err(dev, "channel(%d) direction unknown\n", chan_num);
> +	}

> +
> +	if (ret < 0)
> +		goto fail;
> +
> +	list_add_tail(&to_achan(chan)->device_node, &to_dma(dma)->channels);
> +	return 0;
> +
> +fail:
> +	devm_kfree(dev, chan);
> +	return ret;

Below you skip channels which failed to initialize. Is it real use case?

> +}
> +
> +/* dummy function: feature not supported */
> +static enum dma_status chan_xfer_status(struct dma_chan *achan,
> +				      dma_cookie_t cookie,
> +				      struct dma_tx_state *txstate)
> +{
> +	WARN(1, "xfer status not supported\n");
> +	return DMA_ERROR;
> +}
> +
> +/* dummy function: feature not supported */
> +static void chan_issue_pending(struct dma_chan *chan)
> +{
> +	WARN(1, "issue pending not supported\n");
> +}
> +
> +static ssize_t keystone_dma_show_chan_num(struct device *dev,
> +			     struct device_attribute *attr, char *buf)
> +{
> +	struct dma_chan *achan = dev_to_dma_chan(dev);
> +	struct keystone_dma_chan *chan = from_achan(achan);
> +
> +	return scnprintf(buf, PAGE_SIZE, "%u\n", chan->channel);
> +}
> +
> +static ssize_t keystone_dma_show_flow(struct device *dev,
> +			     struct device_attribute *attr, char *buf)
> +{
> +	struct dma_chan *achan = dev_to_dma_chan(dev);
> +	struct keystone_dma_chan *chan = from_achan(achan);
> +
> +	return scnprintf(buf, PAGE_SIZE, "%u\n", chan->flow);
> +}
> +
> +static DEVICE_ATTR(chan_num, S_IRUSR, keystone_dma_show_chan_num, NULL);
> +static DEVICE_ATTR(rx_flow, S_IRUSR, keystone_dma_show_flow, NULL);
> +
> +static void keystone_dma_destroy_attr(struct keystone_dma_device *dma)
> +{
> +	struct dma_device *engine = to_dma(dma);
> +	struct keystone_dma_chan *chan;
> +	struct dma_chan *achan;
> +	struct device *dev;
> +
> +	list_for_each_entry(achan, &engine->channels, device_node) {
> +		chan = from_achan(achan);
> +		dev = chan_dev(chan);
> +
> +		/* remove sysfs entries */
> +		if (chan->direction == DMA_MEM_TO_DEV)
> +			device_remove_file(dev, &dev_attr_chan_num);
> +		else
> +			device_remove_file(dev, &dev_attr_rx_flow);
> +	}
> +}
> +
> +static int  keystone_dma_setup_attr(struct keystone_dma_device *dma)
> +{
> +	struct dma_device *engine = to_dma(dma);
> +	struct keystone_dma_chan *chan;
> +	struct dma_chan *achan;
> +	struct device *dev;
> +	int status = 0;
> +
> +	list_for_each_entry(achan, &engine->channels, device_node) {
> +		chan = from_achan(achan);
> +		dev = chan_dev(chan);
> +
> +		/* add sysfs entries */
> +		if (chan->direction == DMA_MEM_TO_DEV) {
> +			status = device_create_file(dev, &dev_attr_chan_num);
> +			if (status)
> +				dev_warn(dev,
> +					 "Couldn't create sysfs chan_num\n");
> +		} else {
> +			status = device_create_file(dev, &dev_attr_rx_flow);
> +			if (status)
> +				dev_warn(dev,
> +					 "Couldn't create sysfs rx_flow\n");
> +		}
> +	}
> +	return status;
> +}
> +
> +static struct of_dma_filter_info keystone_dma_info = {
> +	.filter_fn = dma_keystone_filter_fn,
> +};
> +
> +static int keystone_dma_probe(struct platform_device *pdev)
> +{
> +	unsigned max_tx_chan, max_rx_chan, max_rx_flow, max_tx_sched;
> +	struct device_node *node = pdev->dev.of_node;
> +	struct keystone_dma_device *dma;
> +	struct device_node *chan;
> +	int ret, len, num_chan = 0;
> +	struct dma_device *engine;
> +	resource_size_t size;
> +	u32 timeout;
> +	u32 i;
> +
> +	if (!node) {
> +		dev_err(&pdev->dev, "could not find device info\n");
> +		return -EINVAL;
> +	}
> +
> +	dma = devm_kzalloc(&pdev->dev, sizeof(*dma), GFP_KERNEL);
> +	if (!dma) {
> +		dev_err(&pdev->dev, "could not allocate driver mem\n");
> +		return -ENOMEM;
> +	}
> +
> +	engine = to_dma(dma);
> +	engine->dev = &pdev->dev;
> +	platform_set_drvdata(pdev, dma);
> +
> +	pm_runtime_enable(&pdev->dev);
> +	ret = pm_runtime_get_sync(&pdev->dev);
>  +	if (ret < 0) {
> +		dev_err(&pdev->dev, "unable to enable pktdma, err %d\n", ret);
> +		return ret;
> +	}
> +
> +	dma->reg_global	 = pktdma_get_regs(dma, "global", &size);
> +	if (!dma->reg_global)
> +		return -ENODEV;
> +	if (size < sizeof(struct reg_global)) {
> +		dev_err(dma_dev(dma), "bad size %pa for global regs\n", &size);
> +		return -ENODEV;
> +	}
> +
> +	dma->reg_tx_chan = pktdma_get_regs(dma, "txchan", &size);
> +	if (!dma->reg_tx_chan)
> +		return -ENODEV;
> +
> +	max_tx_chan = size / sizeof(struct reg_chan);
> +	dma->reg_rx_chan = pktdma_get_regs(dma, "rxchan", &size);
> +	if (!dma->reg_rx_chan)
> +		return -ENODEV;
> +
> +	max_rx_chan = size / sizeof(struct reg_chan);
> +	dma->reg_tx_sched = pktdma_get_regs(dma, "txsched", &size);
> +	if (!dma->reg_tx_sched)
> +		return -ENODEV;
> +
> +	max_tx_sched = size / sizeof(struct reg_tx_sched);
> +	dma->reg_rx_flow = pktdma_get_regs(dma, "rxflow", &size);
> +	if (!dma->reg_rx_flow)
> +		return -ENODEV;
> +
> +	max_rx_flow = size / sizeof(struct reg_rx_flow);
> +	dma->rx_priority = DMA_PRIO_DEFAULT;
> +	dma->tx_priority = DMA_PRIO_DEFAULT;
> +
> +	dma->enable_all	= (of_get_property(node, "enable-all", NULL) != NULL);
> +	dma->loopback	= (of_get_property(node, "loop-back",  NULL) != NULL);
> +
> +	ret = of_property_read_u32(node, "rx-retry-timeout", &timeout);
> +	if (ret < 0) {
> +		dev_dbg(&pdev->dev, "unspecified rx timeout using value %d\n",
> +			DMA_RX_TIMEOUT_DEFAULT);
> +		timeout = DMA_RX_TIMEOUT_DEFAULT;
> +	}
> +	dma->rx_timeout = timeout;
> +
> +	if (!of_find_property(node, "qm-base-address", &len)) {
> +		dev_err(&pdev->dev, "unspecified qm-base-address\n");
> +		return -ENODEV;
> +	}
> +
> +	dma->logical_queue_managers = len / sizeof(u32);
> +	if (dma->logical_queue_managers > DMA_MAX_QMS) {
> +		dev_warn(&pdev->dev, "too many queue mgrs(>%d) rest ignored\n",

mgrs -> managers ? Since the string too long, put it on separate line,
but don't break.

> +			 dma->logical_queue_managers);
> +		dma->logical_queue_managers = DMA_MAX_QMS;
> +	}
> +
> +	ret = of_property_read_u32_array(node, "qm-base-address",
> +					dma->qm_base_address,
> +					dma->logical_queue_managers);
> +	if (ret) {
> +		dev_err(&pdev->dev, "invalid qm-base-address\n");
> +		return ret;
> +	}
> +
> +	dma->max_rx_chan = max_rx_chan;
> +	dma->max_rx_flow = max_rx_flow;
> +	dma->max_tx_chan = min(max_tx_chan, max_tx_sched);
> +
> +	atomic_set(&dma->in_use, 0);
> +
> +	INIT_LIST_HEAD(&engine->channels);
> +
> +	for (i = 0; i < dma->max_tx_chan; i++) {
> +		if (pktdma_init_chan(dma, chan, DMA_MEM_TO_DEV, i) >= 0)
> +			num_chan++;
> +	}
> +
> +	for (i = 0; i < dma->max_rx_chan; i++) {
> +		if (pktdma_init_chan(dma, chan, DMA_DEV_TO_MEM, i) >= 0)
> +			num_chan++;
> +	}
> +
> +	if (list_empty(&engine->channels)) {
> +		dev_err(dma_dev(dma), "no valid channels\n");
> +		return -ENODEV;
> +	}
> +
> +	dma_cap_set(DMA_SLAVE, engine->cap_mask);
> +	engine->device_alloc_chan_resources = chan_init;
> +	engine->device_free_chan_resources  = chan_destroy;
> +	engine->device_control		    = chan_control;
> +	engine->device_tx_status	    = chan_xfer_status;
> +	engine->device_issue_pending	    = chan_issue_pending;
> +
> +	ret = dma_async_device_register(engine);
> +	if (ret) {
> +		dev_err(&pdev->dev, "unable to register dma engine\n");
> +		return ret;
> +	}
> +
> +	keystone_dma_info.dma_cap = engine->cap_mask;
> +	ret = of_dma_controller_register(node, of_dma_simple_xlate,
> +					&keystone_dma_info);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to register dma controller\n");
> +		dma_async_device_unregister(engine);
> +		return ret;
> +	}
> +
> +	ret = keystone_dma_setup_attr(dma);
> +	if (ret) {
> +		dev_err(&pdev->dev, "unable to setup device attr\n");
> +		return ret;
> +	}
> +
> +	dev_info(dma_dev(dma), "registered %d logical channels, flows %d, tx chans: %d, rx chans: %d%s\n",
> +		 num_chan, dma->max_rx_flow, dma->max_tx_chan,
> +		 dma->max_rx_chan, dma->loopback ? ", loopback" : "");
> +
> +	return 0;
> +}
> +
> +static int keystone_dma_remove(struct platform_device *pdev)
> +{
> +	struct keystone_dma_device *dma = platform_get_drvdata(pdev);
> +	struct dma_device *engine = to_dma(dma);
> +
> +	pm_runtime_put_sync(&pdev->dev);
> +	pm_runtime_disable(&pdev->dev);
> +
> +	keystone_dma_destroy_attr(dma);
> +	dma_async_device_unregister(engine);
> +
> +	return 0;
> +}
> +
> +static struct of_device_id of_match[] = {
> +	{ .compatible = "ti,keystone-pktdma", },
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(of, of_match);
> +
> +static struct platform_driver keystone_dma_driver = {
> +	.probe	= keystone_dma_probe,
> +	.remove	= keystone_dma_remove,
> +	.driver = {
> +		.name		= "keystone-pktdma",
> +		.owner		= THIS_MODULE,
> +		.of_match_table	= of_match,
> +	},
> +};
> +
> +bool dma_keystone_filter_fn(struct dma_chan *chan, void *param)
> +{
> +	if (chan->device->dev->driver == &keystone_dma_driver.driver) {
> +		struct keystone_dma_chan *kdma_chan = from_achan(chan);
> +		unsigned chan_id = *(u32 *)param & KEYSTONE_DMA_CHAN_ID_MASK;
> +		unsigned chan_type = *(u32 *)param >> KEYSTONE_DMA_TYPE_SHIFT;
> +
> +		if (chan_type == KEYSTONE_DMA_TX_CHAN_TYPE &&
> +		    kdma_chan->direction == DMA_MEM_TO_DEV)
> +			return chan_id  == kdma_chan->channel;
> +
> +		if (chan_type == KEYSTONE_DMA_RX_FLOW_TYPE &&
> +		    kdma_chan->direction == DMA_DEV_TO_MEM)
> +			return chan_id  == kdma_chan->flow;
> +	}
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(dma_keystone_filter_fn);
> +
> +static int __init keystone_dma_init(void)
> +{
> +	BUILD_CHECK_REGS();

Could you move this somewhere else and use module_platform_driver()
instead of init/exit?

> +	return platform_driver_register(&keystone_dma_driver);
> +}
> +module_init(keystone_dma_init);
> +
> +static void __exit keystone_dma_exit(void)
> +{
> +	platform_driver_unregister(&keystone_dma_driver);
> +}
> +module_exit(keystone_dma_exit);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("TI Keystone Packet DMA driver");
> diff --git a/include/dt-bindings/dma/keystone.h b/include/dt-bindings/dma/keystone.h
> new file mode 100644
> index 0000000..abe029e
> --- /dev/null
> +++ b/include/dt-bindings/dma/keystone.h
> @@ -0,0 +1,33 @@
> +/*
> + * Copyright (C) 2014 Texas Instruments Incorporated
> + * Authors:	Sandeep Nair <sandeep_n@ti.com>
> + *		Santosh Shilimkar <santosh.shilimkar@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __DT_BINDINGS_KEYSTONE_DMA_H__
> +#define __DT_BINDINGS_KEYSTONE_DMA_H__
> +
> +#define KEYSTONE_DMA_CHAN_ID_MASK	(0xff)
> +#define KEYSTONE_DMA_TYPE_SHIFT		(24)
> +#define KEYSTONE_DMA_TX_CHAN_TYPE	(0xff)
> +#define KEYSTONE_DMA_RX_FLOW_TYPE	(0xfe)
> +
> +#define KEYSTONE_DMA_TX_CHAN(id)	((id & KEYSTONE_DMA_CHAN_ID_MASK) | \
> +					(KEYSTONE_DMA_TX_CHAN_TYPE << \
> +					 KEYSTONE_DMA_TYPE_SHIFT))
> +
> +#define KEYSTONE_DMA_RX_FLOW(id)	((id & KEYSTONE_DMA_CHAN_ID_MASK) | \
> +					(KEYSTONE_DMA_RX_FLOW_TYPE << \
> +					 KEYSTONE_DMA_TYPE_SHIFT))
> +
> +
> +#endif /* __DT_BINDINGS_KEYSTONE_DMA_H_ */
> diff --git a/include/linux/keystone-pktdma.h b/include/linux/keystone-pktdma.h
> new file mode 100644
> index 0000000..e6a66c8
> --- /dev/null
> +++ b/include/linux/keystone-pktdma.h
> @@ -0,0 +1,168 @@
> +/*
> + * Copyright (C) 2014 Texas Instruments Incorporated
> + * Authors:	Sandeep Nair <sandeep_n@ti.com
> + *		Cyril Chemparathy <cyril@ti.com
> +		Santosh Shilimkar <santosh.shilimkar@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __KEYSTONE_PKTDMA_H__
> +#define __KEYSTONE_PKTDMA_H__
> +
> +#include <linux/dmaengine.h>
> +
> +/*
> + * PKTDMA descriptor manipulation macros for host packet descriptor
> + */
> +#define MASK(x)					(BIT(x) - 1)
> +#define DMA_KEYSTONE_DESC_PKT_LEN_MASK		MASK(22)
> +#define DMA_KEYSTONE_DESC_PKT_LEN_SHIFT		0
> +#define DMA_KEYSTONE_DESC_PS_INFO_IN_SOP	BIT(22)
> +#define DMA_KEYSTONE_DESC_PS_INFO_IN_DESC	0
> +#define DMA_KEYSTONE_DESC_TAG_MASK		MASK(8)
> +#define DMA_KEYSTONE_DESC_SAG_HI_SHIFT		24
> +#define DMA_KEYSTONE_DESC_STAG_LO_SHIFT		16
> +#define DMA_KEYSTONE_DESC_DTAG_HI_SHIFT		8
> +#define DMA_KEYSTONE_DESC_DTAG_LO_SHIFT		0
> +#define DMA_KEYSTONE_DESC_HAS_EPIB		BIT(31)
> +#define DMA_KEYSTONE_DESC_NO_EPIB		0
> +#define DMA_KEYSTONE_DESC_PSLEN_SHIFT		24
> +#define DMA_KEYSTONE_DESC_PSLEN_MASK		MASK(6)
> +#define DMA_KEYSTONE_DESC_ERR_FLAG_SHIFT	20
> +#define DMA_KEYSTONE_DESC_ERR_FLAG_MASK		MASK(4)
> +#define DMA_KEYSTONE_DESC_PSFLAG_SHIFT		16
> +#define DMA_KEYSTONE_DESC_PSFLAG_MASK		MASK(4)
> +#define DMA_KEYSTONE_DESC_RETQ_SHIFT		0
> +#define DMA_KEYSTONE_DESC_RETQ_MASK		MASK(14)
> +#define DMA_KEYSTONE_DESC_BUF_LEN_MASK		MASK(22)
> +
> +#define DMA_KEYSTONE_NUM_EPIB_WORDS		4
> +#define DMA_KEYSTONE_NUM_PS_WORDS		16
> +#define DMA_KEYSTONE_FDQ_PER_CHAN		4
> +
> +/* Tx channel scheduling priority */
> +enum dma_keystone_tx_priority {
> +	DMA_PRIO_HIGH	= 0,
> +	DMA_PRIO_MED_H,
> +	DMA_PRIO_MED_L,
> +	DMA_PRIO_LOW
> +};
> +
> +/* Rx channel error handling mode during buffer starvation */
> +enum dma_keystone_rx_err_mode {
> +	DMA_DROP = 0,
> +	DMA_RETRY
> +};
> +
> +/* Rx flow size threshold configuration */
> +enum dma_keystone_rx_thresholds {
> +	DMA_THRESH_NONE		= 0,
> +	DMA_THRESH_0		= 1,
> +	DMA_THRESH_0_1		= 3,
> +	DMA_THRESH_0_1_2	= 7
> +};
> +
> +/* Descriptor type */
> +enum dma_keystone_desc_type {
> +	DMA_DESC_HOST = 0,
> +	DMA_DESC_MONOLITHIC = 2
> +};
> +
> +/**
> + * struct dma_keystone_tx_cfg:	Tx channel configuration
> + * @filt_einfo:			Filter extended packet info
> + * @filt_pswords:		Filter PS words present
> + * @dma_keystone_tx_priority:	Tx channel scheduling priority
> + */
> +struct dma_keystone_tx_cfg {
> +	bool				filt_einfo;
> +	bool				filt_pswords;
> +	enum dma_keystone_tx_priority	priority;
> +};
> +
> +/**
> + * struct dma_keystone_rx_cfg:	Rx flow configuration
> + * @einfo_present:		Extended packet info present
> + * @psinfo_present:		PS words present
> + * @dma_keystone_rx_err_mode:	Error during buffer starvation
> + * @dma_keystone_desc_type:	Host or Monolithic desc
> + * @psinfo_at_sop:		PS word located at start of packet
> + * @sop_offset:			Start of packet offset
> + * @dst_q:			Destination queue for a given flow
> + * @thresh:			Rx flow size threshold
> + * @fdq[]:			Free desc Queue array
> + * @sz_thresh0:			RX packet size threshold 0
> + * @sz_thresh1:			RX packet size threshold 1
> + * @sz_thresh2:			RX packet size threshold 2
> + */
> +struct dma_keystone_rx_cfg {
> +	bool				einfo_present;
> +	bool				psinfo_present;
> +	enum dma_keystone_rx_err_mode	err_mode;
> +	enum dma_keystone_desc_type	desc_type;
> +	bool				psinfo_at_sop;
> +	unsigned int			sop_offset;
> +	unsigned int			dst_q;
> +	enum dma_keystone_rx_thresholds	thresh;
> +	unsigned int			fdq[DMA_KEYSTONE_FDQ_PER_CHAN];
> +	unsigned int			sz_thresh0;
> +	unsigned int			sz_thresh1;
> +	unsigned int			sz_thresh2;
> +};
> +
> +/**
> + * struct dma_keystone_cfg:	Pktdma channel configuration
> + * @sl_cfg:			Slave configuration
> + * @tx:				Tx channel configuration
> + * @rx:				Rx flow configuration
> + */
> +struct dma_keystone_cfg {
> +	struct dma_slave_config		sl_cfg;
> +	union {
> +		struct dma_keystone_tx_cfg	tx;
> +		struct dma_keystone_rx_cfg	rx;
> +	} u;
> +};
> +
> +/**
> + * struct dma_keystone_desc:	Host packet descriptor layout
> + * @desc_info:			Descriptor information like id, type, length
> + * @tag_info:			Flow tag info written in during RX
> + * @packet_info:		Queue Manager, policy, flags etc
> + * @buff_len:			Buffer length in bytes
> + * @buff:			Buffer pointer
> + * @next_desc:			For chaining the descriptors
> + * @orig_len:			length since 'buff_len' can be overwritten
> + * @orig_buff:			buff pointer since 'buff' can be overwritten
> + * @epib:			Extended packet info block
> + * @psdata:			Protocol specific
> + */
> +struct dma_keystone_desc {
> +	u32	desc_info;
> +	u32	tag_info;
> +	u32	packet_info;
> +	u32	buff_len;
> +	u32	buff;
> +	u32	next_desc;
> +	u32	orig_len;
> +	u32	orig_buff;
> +	u32	epib[DMA_KEYSTONE_NUM_EPIB_WORDS];
> +	u32	psdata[DMA_KEYSTONE_NUM_PS_WORDS];
> +	u32	pad[4];
> +} ____cacheline_aligned;
> +
> +#define keystone_cfg_to_slave_config(keystone_cfg) (&keystone_cfg.sl_cfg)
> +#define keystone_cfg_from_slave_config(dma_cfg)	container_of(dma_cfg, \
> +					struct dma_keystone_cfg, sl_cfg)
> +/* Keystone PKTDMA filter function */
> +bool dma_keystone_filter_fn(struct dma_chan *chan, void *param);
> +
> +#endif /* __KEYSTONE_PKTDMA_H__ */


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
