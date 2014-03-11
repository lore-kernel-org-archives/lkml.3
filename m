Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbaCKK2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:28:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:10416 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471AbaCKK2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:28:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,629,1389772800"; 
   d="scan'208";a="496071096"
Date: Tue, 11 Mar 2014 15:53:57 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Sandeep Nair <sandeep_n@ti.com>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] dma: Add Keystone Packet DMA Engine driver
Message-ID: <20140311102357.GR1976@intel.com>
References: <1393628200-12317-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393628200-12317-1-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 05:56:40PM -0500, Santosh Shilimkar wrote:
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
Pls use subsystem appropriate name so here would have been dmaengine: ...

So i am still missing stuff like prepare calls, irq, descriptor management to
call this a dmaengine driver.

I guess you need to explain a bit more why the data movement is handled by some
other driver and not by this one

few more comments inline

> 
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
Can you pls separate the binding to separate patch and also this needs ack from DT
folks

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
this might get confusing, perhaps a better name could be given?

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
why is this required, do you want to use __packed__ to ensure right size?

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
why second check?
> +		if (cfg->u.tx.filt_pswords)
> +			v |= DMA_TX_FILT_PSWORDS;
> +		if (cfg->u.tx.filt_einfo)
> +			v |= DMA_TX_FILT_EINFO;
> +		writel_relaxed(v, &chan->reg_chan->mode);
> +		writel_relaxed(DMA_ENABLE, &chan->reg_chan->control);
> +	}
no else for DMA_DEV_TO_MEM?
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
> +		dev_err(chan_dev(chan), "bad direction\n");
> +		return -EINVAL;
> +	}
is_slave_direction() pls

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
direction is deprecated...
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
??

> +	return ret;
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
Supporting status is okay but not issue_pending. This breaks use of dmaengine
API. What we expect is that user will do channel allocation, prepare a
descriptor, then submit it. Submit doesnt start the transaction, this call does!
So we need implementation here!

> +
> +static ssize_t keystone_dma_show_chan_num(struct device *dev,
> +			     struct device_attribute *attr, char *buf)
> +{
> +	struct dma_chan *achan = dev_to_dma_chan(dev);
> +	struct keystone_dma_chan *chan = from_achan(achan);
> +
> +	return scnprintf(buf, PAGE_SIZE, "%u\n", chan->channel);
> +}
???

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
okay why do we need these?

-- 
~Vinod
