Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbaHHJOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 05:14:08 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:36487 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbaHHJOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 05:14:03 -0400
Message-ID: <53E494CF.7020702@monstr.eu>
Date: Fri, 08 Aug 2014 11:13:51 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Srikanth Thokala <sthokal@xilinx.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Levente Kurusa <levex@linux.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org, anirudh@xilinx.com
Subject: Re: [PATCH v3 2/2] dma: Add Xilinx AXI Direct Memory Access Engine
 driver support
References: <1406549869-24422-1-git-send-email-sthokal@xilinx.com>	<1406549869-24422-2-git-send-email-sthokal@xilinx.com> <CA+mB=1JtbgJufgYc2rTfRam-_eAK-i7AK=y4JhZtxHte1-zsaA@mail.gmail.com>
In-Reply-To: <CA+mB=1JtbgJufgYc2rTfRam-_eAK-i7AK=y4JhZtxHte1-zsaA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="NfvqpjmsNOlnLPKUD5xFgUvLfUKHc7n1t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NfvqpjmsNOlnLPKUD5xFgUvLfUKHc7n1t
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

any update on this one?

Thanks,
Michal

On 08/01/2014 06:59 AM, Srikanth Thokala wrote:
> Hi,
>=20
> Kindly review this patch and please provide your inputs.
>=20
> Thanks
> Srikanth
>=20
> On Mon, Jul 28, 2014 at 5:47 PM, Srikanth Thokala <sthokal@xilinx.com> =
wrote:
>> This is the driver for the AXI Direct Memory Access (AXI DMA)
>> core, which is a soft Xilinx IP core that provides high-
>> bandwidth direct memory access between memory and AXI4-Stream
>> type target peripherals.
>>
>> This module works on Zynq (ARM Based SoC) and Microblaze platforms.
>>
>> Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>
>> ---
>> Changes in v3:
>> - Rebased on 3.16-rc7
>>
>> Changes in v2:
>> - Simplified the logic to set SOP and APP words in prep_slave_sg().
>> - Corrected function description comments to match the return type.
>> - Fixed some minor comments as suggested by Andy, Thanks.
>> ---
>>  drivers/dma/Kconfig             |   13 +
>>  drivers/dma/xilinx/Makefile     |    1 +
>>  drivers/dma/xilinx/xilinx_dma.c | 1225 ++++++++++++++++++++++++++++++=
+++++++++
>>  include/linux/amba/xilinx_dma.h |   17 +
>>  4 files changed, 1256 insertions(+)
>>  create mode 100644 drivers/dma/xilinx/xilinx_dma.c
>>
>> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
>> index 1eca7b9..b8e831e 100644
>> --- a/drivers/dma/Kconfig
>> +++ b/drivers/dma/Kconfig
>> @@ -375,6 +375,19 @@ config XILINX_VDMA
>>           channels, Memory Mapped to Stream (MM2S) and Stream to
>>           Memory Mapped (S2MM) for the data transfers.
>>
>> +config XILINX_DMA
>> +       tristate "Xilinx AXI DMA Engine"
>> +       depends on (ARCH_ZYNQ || MICROBLAZE)
>> +       select DMA_ENGINE
>> +       help
>> +         Enable support for Xilinx AXI DMA Soft IP.
>> +
>> +         This engine provides high-bandwidth direct memory access
>> +         between memory and AXI4-Stream type target peripherals.
>> +         It has two stream interfaces/channels, Memory Mapped to
>> +         Stream (MM2S) and Stream to Memory Mapped (S2MM) for the
>> +         data transfers.
>> +
>>  config DMA_ENGINE
>>         bool
>>
>> diff --git a/drivers/dma/xilinx/Makefile b/drivers/dma/xilinx/Makefile=

>> index 3c4e9f2..6224a49 100644
>> --- a/drivers/dma/xilinx/Makefile
>> +++ b/drivers/dma/xilinx/Makefile
>> @@ -1 +1,2 @@
>>  obj-$(CONFIG_XILINX_VDMA) +=3D xilinx_vdma.o
>> +obj-$(CONFIG_XILINX_DMA) +=3D xilinx_dma.o
>> diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xili=
nx_dma.c
>> new file mode 100644
>> index 0000000..0500773
>> --- /dev/null
>> +++ b/drivers/dma/xilinx/xilinx_dma.c
>> @@ -0,0 +1,1225 @@
>> +/*
>> + * DMA driver for Xilinx DMA Engine
>> + *
>> + * Copyright (C) 2010 - 2014 Xilinx, Inc. All rights reserved.
>> + *
>> + * Based on the Freescale DMA driver.
>> + *
>> + * Description:
>> + *  The AXI DMA, is a soft IP, which provides high-bandwidth Direct M=
emory
>> + *  Access between memory and AXI4-Stream-type target peripherals. It=
 can be
>> + *  configured to have one channel or two channels and if configured =
as two
>> + *  channels, one is to transmit data from memory to a device and ano=
ther is
>> + *  to receive from a device.
>> + *
>> + * This program is free software: you can redistribute it and/or modi=
fy
>> + * it under the terms of the GNU General Public License as published =
by
>> + * the Free Software Foundation, either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +
>> +#include <linux/amba/xilinx_dma.h>
>> +#include <linux/bitops.h>
>> +#include <linux/init.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/io.h>
>> +#include <linux/module.h>
>> +#include <linux/of_address.h>
>> +#include <linux/of_dma.h>
>> +#include <linux/of_irq.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/slab.h>
>> +
>> +#include "../dmaengine.h"
>> +
>> +/* Register Offsets */
>> +#define XILINX_DMA_REG_CONTROL         0x00
>> +#define XILINX_DMA_REG_STATUS          0x04
>> +#define XILINX_DMA_REG_CURDESC         0x08
>> +#define XILINX_DMA_REG_TAILDESC                0x10
>> +#define XILINX_DMA_REG_SRCADDR         0x18
>> +#define XILINX_DMA_REG_DSTADDR         0x20
>> +#define XILINX_DMA_REG_BTT             0x28
>> +
>> +/* Channel/Descriptor Offsets */
>> +#define XILINX_DMA_MM2S_CTRL_OFFSET    0x00
>> +#define XILINX_DMA_S2MM_CTRL_OFFSET    0x30
>> +
>> +/* General register bits definitions */
>> +#define XILINX_DMA_CR_RUNSTOP_MASK     BIT(0)
>> +#define XILINX_DMA_CR_RESET_MASK       BIT(2)
>> +
>> +#define XILINX_DMA_CR_DELAY_SHIFT      24
>> +#define XILINX_DMA_CR_COALESCE_SHIFT   16
>> +
>> +#define XILINX_DMA_CR_DELAY_MAX                GENMASK(7, 0)
>> +#define XILINX_DMA_CR_COALESCE_MAX     GENMASK(7, 0)
>> +
>> +#define XILINX_DMA_SR_HALTED_MASK      BIT(0)
>> +#define XILINX_DMA_SR_IDLE_MASK                BIT(1)
>> +
>> +#define XILINX_DMA_XR_IRQ_IOC_MASK     BIT(12)
>> +#define XILINX_DMA_XR_IRQ_DELAY_MASK   BIT(13)
>> +#define XILINX_DMA_XR_IRQ_ERROR_MASK   BIT(14)
>> +#define XILINX_DMA_XR_IRQ_ALL_MASK     GENMASK(14, 12)
>> +
>> +/* BD definitions */
>> +#define XILINX_DMA_BD_STS_ALL_MASK     GENMASK(31, 28)
>> +#define XILINX_DMA_BD_SOP              BIT(27)
>> +#define XILINX_DMA_BD_EOP              BIT(26)
>> +
>> +/* Hw specific definitions */
>> +#define XILINX_DMA_MAX_CHANS_PER_DEVICE        0x2
>> +#define XILINX_DMA_MAX_TRANS_LEN       GENMASK(22, 0)
>> +
>> +/* Delay loop counter to prevent hardware failure */
>> +#define XILINX_DMA_LOOP_COUNT          1000000
>> +
>> +/* Maximum number of Descriptors */
>> +#define XILINX_DMA_NUM_DESCS           64
>> +
>> +/**
>> + * struct xilinx_dma_desc_hw - Hardware Descriptor
>> + * @next_desc: Next Descriptor Pointer @0x00
>> + * @pad1: Reserved @0x04
>> + * @buf_addr: Buffer address @0x08
>> + * @pad2: Reserved @0x0C
>> + * @pad3: Reserved @0x10
>> + * @pad4: Reserved @0x14
>> + * @control: Control field @0x18
>> + * @status: Status field @0x1C
>> + * @app: APP Fields @0x20 - 0x30
>> + */
>> +struct xilinx_dma_desc_hw {
>> +       u32 next_desc;
>> +       u32 pad1;
>> +       u32 buf_addr;
>> +       u32 pad2;
>> +       u32 pad3;
>> +       u32 pad4;
>> +       u32 control;
>> +       u32 status;
>> +       u32 app[XILINX_DMA_NUM_APP_WORDS];
>> +} __aligned(64);
>> +
>> +/**
>> + * struct xilinx_dma_tx_segment - Descriptor segment
>> + * @hw: Hardware descriptor
>> + * @node: Node in the descriptor segments list
>> + * @phys: Physical address of segment
>> + */
>> +struct xilinx_dma_tx_segment {
>> +       struct xilinx_dma_desc_hw hw;
>> +       struct list_head node;
>> +       dma_addr_t phys;
>> +} __aligned(64);
>> +
>> +/**
>> + * struct xilinx_dma_tx_descriptor - Per Transaction structure
>> + * @async_tx: Async transaction descriptor
>> + * @segments: TX segments list
>> + * @node: Node in the channel descriptors list
>> + */
>> +struct xilinx_dma_tx_descriptor {
>> +       struct dma_async_tx_descriptor async_tx;
>> +       struct list_head segments;
>> +       struct list_head node;
>> +};
>> +
>> +/**
>> + * struct xilinx_dma_chan - Driver specific DMA channel structure
>> + * @xdev: Driver specific device structure
>> + * @ctrl_offset: Control registers offset
>> + * @lock: Descriptor operation lock
>> + * @pending_list: Descriptors waiting
>> + * @active_desc: Active descriptor
>> + * @allocated_desc: Allocated descriptor
>> + * @done_list: Complete descriptors
>> + * @free_seg_list: Free descriptors
>> + * @common: DMA common channel
>> + * @seg_v: Statically allocated segments base
>> + * @seg_p: Physical allocated segments base
>> + * @dev: The dma device
>> + * @irq: Channel IRQ
>> + * @id: Channel ID
>> + * @direction: Transfer direction
>> + * @has_sg: Support scatter transfers
>> + * @err: Channel has errors
>> + * @tasklet: Cleanup work after irq
>> + * @residue: Residue
>> + */
>> +struct xilinx_dma_chan {
>> +       struct xilinx_dma_device *xdev;
>> +       u32 ctrl_offset;
>> +       spinlock_t lock;
>> +       struct list_head pending_list;
>> +       struct xilinx_dma_tx_descriptor *active_desc;
>> +       struct xilinx_dma_tx_descriptor *allocated_desc;
>> +       struct list_head done_list;
>> +       struct list_head free_seg_list;
>> +       struct dma_chan common;
>> +       struct xilinx_dma_tx_segment *seg_v;
>> +       dma_addr_t seg_p;
>> +       struct device *dev;
>> +       int irq;
>> +       int id;
>> +       enum dma_transfer_direction direction;
>> +       bool has_sg;
>> +       int err;
>> +       struct tasklet_struct tasklet;
>> +       u32 residue;
>> +};
>> +
>> +/**
>> + * struct xilinx_dma_device - DMA device structure
>> + * @regs: I/O mapped base address
>> + * @dev: Device Structure
>> + * @common: DMA device structure
>> + * @chan: Driver specific DMA channel
>> + * @has_sg: Specifies whether Scatter-Gather is present or not
>> + */
>> +struct xilinx_dma_device {
>> +       void __iomem *regs;
>> +       struct device *dev;
>> +       struct dma_device common;
>> +       struct xilinx_dma_chan *chan[XILINX_DMA_MAX_CHANS_PER_DEVICE];=

>> +       bool has_sg;
>> +};
>> +
>> +/* Macros */
>> +#define to_xilinx_chan(chan) \
>> +       container_of(chan, struct xilinx_dma_chan, common)
>> +#define to_dma_tx_descriptor(tx) \
>> +       container_of(tx, struct xilinx_dma_tx_descriptor, async_tx)
>> +
>> +/* IO accessors */
>> +static inline u32 dma_read(struct xilinx_dma_chan *chan, u32 reg)
>> +{
>> +       return ioread32(chan->xdev->regs + reg);
>> +}
>> +
>> +static inline void dma_write(struct xilinx_dma_chan *chan, u32 reg, u=
32 value)
>> +{
>> +       iowrite32(value, chan->xdev->regs + reg);
>> +}
>> +
>> +static inline u32 dma_ctrl_read(struct xilinx_dma_chan *chan, u32 reg=
)
>> +{
>> +       return dma_read(chan, chan->ctrl_offset + reg);
>> +}
>> +
>> +static inline void dma_ctrl_write(struct xilinx_dma_chan *chan, u32 r=
eg,
>> +                                 u32 value)
>> +{
>> +       dma_write(chan, chan->ctrl_offset + reg, value);
>> +}
>> +
>> +static inline void dma_ctrl_clr(struct xilinx_dma_chan *chan, u32 reg=
, u32 clr)
>> +{
>> +       dma_ctrl_write(chan, reg, dma_ctrl_read(chan, reg) & ~clr);
>> +}
>> +
>> +static inline void dma_ctrl_set(struct xilinx_dma_chan *chan, u32 reg=
, u32 set)
>> +{
>> +       dma_ctrl_write(chan, reg, dma_ctrl_read(chan, reg) | set);
>> +}
>> +
>> +/* ------------------------------------------------------------------=
-----------
>> + * Descriptors and segments alloc and free
>> + */
>> +
>> +/**
>> + * xilinx_dma_alloc_tx_segment - Allocate transaction segment
>> + * @chan: Driver specific dma channel
>> + *
>> + * Return: The allocated segment on success and NULL on failure.
>> + */
>> +static struct xilinx_dma_tx_segment *
>> +xilinx_dma_alloc_tx_segment(struct xilinx_dma_chan *chan)
>> +{
>> +       struct xilinx_dma_tx_segment *segment =3D NULL;
>> +       unsigned long flags;
>> +
>> +       spin_lock_irqsave(&chan->lock, flags);
>> +       if (!list_empty(&chan->free_seg_list)) {
>> +               segment =3D list_first_entry(&chan->free_seg_list,
>> +                                          struct xilinx_dma_tx_segmen=
t,
>> +                                          node);
>> +               list_del(&segment->node);
>> +       }
>> +       spin_unlock_irqrestore(&chan->lock, flags);
>> +
>> +       return segment;
>> +}
>> +
>> +/**
>> + * xilinx_dma_clean_hw_desc - Clean hardware descriptor
>> + * @hw: HW descriptor to clean
>> + */
>> +static void xilinx_dma_clean_hw_desc(struct xilinx_dma_desc_hw *hw)
>> +{
>> +       u32 next_desc =3D hw->next_desc;
>> +
>> +       memset(hw, 0, sizeof(struct xilinx_dma_desc_hw));
>> +
>> +       hw->next_desc =3D next_desc;
>> +}
>> +
>> +/**
>> + * xilinx_dma_free_tx_segment - Free transaction segment
>> + * @chan: Driver specific dma channel
>> + * @segment: dma transaction segment
>> + */
>> +static void xilinx_dma_free_tx_segment(struct xilinx_dma_chan *chan,
>> +                                      struct xilinx_dma_tx_segment *s=
egment)
>> +{
>> +       xilinx_dma_clean_hw_desc(&segment->hw);
>> +
>> +       list_add_tail(&segment->node, &chan->free_seg_list);
>> +}
>> +
>> +/**
>> + * xilinx_dma_tx_descriptor - Allocate transaction descriptor
>> + * @chan: Driver specific dma channel
>> + *
>> + * Return: The allocated descriptor on success and NULL on failure.
>> + */
>> +static struct xilinx_dma_tx_descriptor *
>> +xilinx_dma_alloc_tx_descriptor(struct xilinx_dma_chan *chan)
>> +{
>> +       struct xilinx_dma_tx_descriptor *desc;
>> +       unsigned long flags;
>> +
>> +       if (chan->allocated_desc)
>> +               return chan->allocated_desc;
>> +
>> +       desc =3D kzalloc(sizeof(*desc), GFP_KERNEL);
>> +       if (!desc)
>> +               return NULL;
>> +
>> +       spin_lock_irqsave(&chan->lock, flags);
>> +       chan->allocated_desc =3D desc;
>> +       spin_unlock_irqrestore(&chan->lock, flags);
>> +
>> +       INIT_LIST_HEAD(&desc->segments);
>> +
>> +       return desc;
>> +}
>> +
>> +/**
>> + * xilinx_dma_free_tx_descriptor - Free transaction descriptor
>> + * @chan: Driver specific dma channel
>> + * @desc: dma transaction descriptor
>> + */
>> +static void
>> +xilinx_dma_free_tx_descriptor(struct xilinx_dma_chan *chan,
>> +                             struct xilinx_dma_tx_descriptor *desc)
>> +{
>> +       struct xilinx_dma_tx_segment *segment, *next;
>> +
>> +       if (!desc)
>> +               return;
>> +
>> +       list_for_each_entry_safe(segment, next, &desc->segments, node)=
 {
>> +               list_del(&segment->node);
>> +               xilinx_dma_free_tx_segment(chan, segment);
>> +       }
>> +
>> +       kfree(desc);
>> +}
>> +
>> +/**
>> + * xilinx_dma_free_desc_list - Free descriptors list
>> + * @chan: Driver specific dma channel
>> + * @list: List to parse and delete the descriptor
>> + */
>> +static void xilinx_dma_free_desc_list(struct xilinx_dma_chan *chan,
>> +                                     struct list_head *list)
>> +{
>> +       struct xilinx_dma_tx_descriptor *desc, *next;
>> +
>> +       list_for_each_entry_safe(desc, next, list, node) {
>> +               list_del(&desc->node);
>> +               xilinx_dma_free_tx_descriptor(chan, desc);
>> +       }
>> +}
>> +
>> +/**
>> + * xilinx_dma_free_descriptors - Free channel descriptors
>> + * @chan: Driver specific dma channel
>> + */
>> +static void xilinx_dma_free_descriptors(struct xilinx_dma_chan *chan)=

>> +{
>> +       unsigned long flags;
>> +
>> +       spin_lock_irqsave(&chan->lock, flags);
>> +
>> +       xilinx_dma_free_desc_list(chan, &chan->pending_list);
>> +       xilinx_dma_free_desc_list(chan, &chan->done_list);
>> +
>> +       xilinx_dma_free_tx_descriptor(chan, chan->active_desc);
>> +       chan->active_desc =3D NULL;
>> +
>> +       spin_unlock_irqrestore(&chan->lock, flags);
>> +}
>> +
>> +/**
>> + * xilinx_dma_free_chan_resources - Free channel resources
>> + * @dchan: DMA channel
>> + */
>> +static void xilinx_dma_free_chan_resources(struct dma_chan *dchan)
>> +{
>> +       struct xilinx_dma_chan *chan =3D to_xilinx_chan(dchan);
>> +
>> +       xilinx_dma_free_descriptors(chan);
>> +
>> +       dma_free_coherent(chan->dev,
>> +                         sizeof(*chan->seg_v) * XILINX_DMA_NUM_DESCS,=

>> +                         chan->seg_v, chan->seg_p);
>> +}
>> +
>> +/**
>> + * xilinx_dma_chan_desc_cleanup - Clean channel descriptors
>> + * @chan: Driver specific dma channel
>> + */
>> +static void xilinx_dma_chan_desc_cleanup(struct xilinx_dma_chan *chan=
)
>> +{
>> +       struct xilinx_dma_tx_descriptor *desc, *next;
>> +       unsigned long flags;
>> +
>> +       spin_lock_irqsave(&chan->lock, flags);
>> +
>> +       list_for_each_entry_safe(desc, next, &chan->done_list, node) {=

>> +               dma_async_tx_callback callback;
>> +               void *callback_param;
>> +
>> +               /* Remove from the list of running transactions */
>> +               list_del(&desc->node);
>> +
>> +               /* Run the link descriptor callback function */
>> +               callback =3D desc->async_tx.callback;
>> +               callback_param =3D desc->async_tx.callback_param;
>> +               if (callback) {
>> +                       spin_unlock_irqrestore(&chan->lock, flags);
>> +                       callback(callback_param);
>> +                       spin_lock_irqsave(&chan->lock, flags);
>> +               }
>> +
>> +               /* Run any dependencies, then free the descriptor */
>> +               dma_run_dependencies(&desc->async_tx);
>> +               xilinx_dma_free_tx_descriptor(chan, desc);
>> +       }
>> +
>> +       spin_unlock_irqrestore(&chan->lock, flags);
>> +}
>> +
>> +/**
>> + * xilinx_dma_do_tasklet - Schedule completion tasklet
>> + * @data: Pointer to the Xilinx dma channel structure
>> + */
>> +static void xilinx_dma_do_tasklet(unsigned long data)
>> +{
>> +       struct xilinx_dma_chan *chan =3D (struct xilinx_dma_chan *)dat=
a;
>> +
>> +       xilinx_dma_chan_desc_cleanup(chan);
>> +}
>> +
>> +/**
>> + * xilinx_dma_alloc_chan_resources - Allocate channel resources
>> + * @dchan: DMA channel
>> + *
>> + * Return: '0' on success and failure value on error
>> + */
>> +static int xilinx_dma_alloc_chan_resources(struct dma_chan *dchan)
>> +{
>> +       struct xilinx_dma_chan *chan =3D to_xilinx_chan(dchan);
>> +       int i;
>> +
>> +       /* Allocate the buffer descriptors. */
>> +       chan->seg_v =3D dma_zalloc_coherent(chan->dev,
>> +                                         sizeof(*chan->seg_v) *
>> +                                         XILINX_DMA_NUM_DESCS,
>> +                                         &chan->seg_p, GFP_KERNEL);
>> +       if (!chan->seg_v) {
>> +               dev_err(chan->dev,
>> +                       "unable to allocate channel %d descriptors\n",=

>> +                       chan->id);
>> +               return -ENOMEM;
>> +       }
>> +
>> +       for (i =3D 0; i < XILINX_DMA_NUM_DESCS; i++) {
>> +               chan->seg_v[i].hw.next_desc =3D
>> +                               chan->seg_p + sizeof(*chan->seg_v) *
>> +                               ((i + 1) % XILINX_DMA_NUM_DESCS);
>> +               chan->seg_v[i].phys =3D
>> +                               chan->seg_p + sizeof(*chan->seg_v) * i=
;
>> +               list_add_tail(&chan->seg_v[i].node, &chan->free_seg_li=
st);
>> +       }
>> +
>> +       dma_cookie_init(dchan);
>> +       return 0;
>> +}
>> +
>> +/**
>> + * xilinx_dma_tx_status - Get dma transaction status
>> + * @dchan: DMA channel
>> + * @cookie: Transaction identifier
>> + * @txstate: Transaction state
>> + *
>> + * Return: DMA transaction status
>> + */
>> +static enum dma_status xilinx_dma_tx_status(struct dma_chan *dchan,
>> +                                           dma_cookie_t cookie,
>> +                                           struct dma_tx_state *txsta=
te)
>> +{
>> +       struct xilinx_dma_chan *chan =3D to_xilinx_chan(dchan);
>> +       enum dma_status ret;
>> +       unsigned long flags;
>> +
>> +       ret =3D dma_cookie_status(dchan, cookie, txstate);
>> +       if (ret !=3D DMA_COMPLETE) {
>> +               spin_lock_irqsave(&chan->lock, flags);
>> +               dma_set_residue(txstate, chan->residue);
>> +               spin_unlock_irqrestore(&chan->lock, flags);
>> +       }
>> +
>> +       return ret;
>> +}
>> +
>> +/**
>> + * xilinx_dma_is_running - Check if DMA channel is running
>> + * @chan: Driver specific DMA channel
>> + *
>> + * Return: 'true' if running, 'false' if not.
>> + */
>> +static bool xilinx_dma_is_running(struct xilinx_dma_chan *chan)
>> +{
>> +       return !(dma_ctrl_read(chan, XILINX_DMA_REG_STATUS) &
>> +                XILINX_DMA_SR_HALTED_MASK) &&
>> +               (dma_ctrl_read(chan, XILINX_DMA_REG_CONTROL) &
>> +                XILINX_DMA_CR_RUNSTOP_MASK);
>> +}
>> +
>> +/**
>> + * xilinx_dma_is_idle - Check if DMA channel is idle
>> + * @chan: Driver specific DMA channel
>> + *
>> + * Return: 'true' if idle, 'false' if not.
>> + */
>> +static bool xilinx_dma_is_idle(struct xilinx_dma_chan *chan)
>> +{
>> +       return dma_ctrl_read(chan, XILINX_DMA_REG_STATUS) &
>> +              XILINX_DMA_SR_IDLE_MASK;
>> +}
>> +
>> +/**
>> + * xilinx_dma_halt - Halt DMA channel
>> + * @chan: Driver specific DMA channel
>> + */
>> +static void xilinx_dma_halt(struct xilinx_dma_chan *chan)
>> +{
>> +       int loop =3D XILINX_DMA_LOOP_COUNT;
>> +
>> +       dma_ctrl_clr(chan, XILINX_DMA_REG_CONTROL,
>> +                    XILINX_DMA_CR_RUNSTOP_MASK);
>> +
>> +       /* Wait for the hardware to halt */
>> +       do {
>> +               if (dma_ctrl_read(chan, XILINX_DMA_REG_STATUS) &
>> +                   XILINX_DMA_SR_HALTED_MASK)
>> +                       break;
>> +       } while (loop--);
>> +
>> +       if (!loop) {
>> +               pr_debug("Cannot stop channel %p: %x\n",
>> +                        chan, dma_ctrl_read(chan, XILINX_DMA_REG_STAT=
US));
>> +               chan->err =3D true;
>> +       }
>> +}
>> +
>> +/**
>> + * xilinx_dma_start - Start DMA channel
>> + * @chan: Driver specific DMA channel
>> + */
>> +static void xilinx_dma_start(struct xilinx_dma_chan *chan)
>> +{
>> +       int loop =3D XILINX_DMA_LOOP_COUNT;
>> +
>> +       dma_ctrl_set(chan, XILINX_DMA_REG_CONTROL,
>> +                    XILINX_DMA_CR_RUNSTOP_MASK);
>> +
>> +       /* Wait for the hardware to start */
>> +       do {
>> +               if (!dma_ctrl_read(chan, XILINX_DMA_REG_STATUS) &
>> +                    XILINX_DMA_SR_HALTED_MASK)
>> +                       break;
>> +       } while (loop--);
>> +
>> +       if (!loop) {
>> +               pr_debug("Cannot start channel %p: %x\n",
>> +                        chan, dma_ctrl_read(chan, XILINX_DMA_REG_STAT=
US));
>> +               chan->err =3D true;
>> +       }
>> +}
>> +
>> +/**
>> + * xilinx_dma_start_transfer - Starts DMA transfer
>> + * @chan: Driver specific channel struct pointer
>> + */
>> +static void xilinx_dma_start_transfer(struct xilinx_dma_chan *chan)
>> +{
>> +       struct xilinx_dma_tx_descriptor *desc;
>> +       struct xilinx_dma_tx_segment *head, *tail =3D NULL;
>> +       unsigned long flags;
>> +
>> +       if (chan->err)
>> +               return;
>> +
>> +       spin_lock_irqsave(&chan->lock, flags);
>> +
>> +       /* There's already an active descriptor, bail out. */
>> +       if (chan->active_desc)
>> +               goto out_unlock;
>> +
>> +       if (list_empty(&chan->pending_list))
>> +               goto out_unlock;
>> +
>> +       desc =3D list_first_entry(&chan->pending_list,
>> +                               struct xilinx_dma_tx_descriptor, node)=
;
>> +
>> +       if (chan->has_sg && xilinx_dma_is_running(chan) &&
>> +           !xilinx_dma_is_idle(chan)) {
>> +               tail =3D list_entry(desc->segments.prev,
>> +                                 struct xilinx_dma_tx_segment, node);=

>> +               dma_ctrl_write(chan, XILINX_DMA_REG_TAILDESC, tail->ph=
ys);
>> +               goto out_free_desc;
>> +       }
>> +
>> +       if (chan->has_sg) {
>> +               head =3D list_first_entry(&desc->segments,
>> +                                       struct xilinx_dma_tx_segment, =
node);
>> +               tail =3D list_entry(desc->segments.prev,
>> +                                 struct xilinx_dma_tx_segment, node);=

>> +               dma_ctrl_write(chan, XILINX_DMA_REG_CURDESC, head->phy=
s);
>> +       }
>> +
>> +       xilinx_dma_start(chan);
>> +       if (chan->err)
>> +               goto out_unlock;
>> +
>> +       /* Enable interrupts */
>> +       dma_ctrl_set(chan, XILINX_DMA_REG_CONTROL,
>> +                    XILINX_DMA_XR_IRQ_ALL_MASK);
>> +
>> +       /* Start the transfer */
>> +       if (chan->has_sg) {
>> +               dma_ctrl_write(chan, XILINX_DMA_REG_TAILDESC, tail->ph=
ys);
>> +       } else {
>> +               struct xilinx_dma_tx_segment *segment;
>> +               struct xilinx_dma_desc_hw *hw;
>> +
>> +               segment =3D list_first_entry(&desc->segments,
>> +                                          struct xilinx_dma_tx_segmen=
t, node);
>> +               hw =3D &segment->hw;
>> +
>> +               if (chan->direction =3D=3D DMA_MEM_TO_DEV)
>> +                       dma_ctrl_write(chan, XILINX_DMA_REG_SRCADDR,
>> +                                      hw->buf_addr);
>> +               else
>> +                       dma_ctrl_write(chan, XILINX_DMA_REG_DSTADDR,
>> +                                      hw->buf_addr);
>> +
>> +               /* Start the transfer */
>> +               dma_ctrl_write(chan, XILINX_DMA_REG_BTT,
>> +                              hw->control & XILINX_DMA_MAX_TRANS_LEN)=
;
>> +       }
>> +
>> +out_free_desc:
>> +       list_del(&desc->node);
>> +       chan->active_desc =3D desc;
>> +
>> +out_unlock:
>> +       spin_unlock_irqrestore(&chan->lock, flags);
>> +}
>> +
>> +/**
>> + * xilinx_dma_issue_pending - Issue pending transactions
>> + * @dchan: DMA channel
>> + */
>> +static void xilinx_dma_issue_pending(struct dma_chan *dchan)
>> +{
>> +       struct xilinx_dma_chan *chan =3D to_xilinx_chan(dchan);
>> +
>> +       xilinx_dma_start_transfer(chan);
>> +}
>> +
>> +/**
>> + * xilinx_dma_complete_descriptor - Mark the active descriptor as com=
plete
>> + * @chan : xilinx DMA channel
>> + */
>> +static void xilinx_dma_complete_descriptor(struct xilinx_dma_chan *ch=
an)
>> +{
>> +       struct xilinx_dma_tx_descriptor *desc;
>> +       struct xilinx_dma_tx_segment *segment, *next;
>> +       struct xilinx_dma_desc_hw *hw;
>> +       unsigned long flags;
>> +       u32 residue =3D 0;
>> +
>> +       spin_lock_irqsave(&chan->lock, flags);
>> +
>> +       desc =3D chan->active_desc;
>> +       if (!desc) {
>> +               dev_dbg(chan->dev, "no running descriptors\n");
>> +               goto out_unlock;
>> +       }
>> +
>> +       if (chan->has_sg) {
>> +               list_for_each_entry_safe(segment, next, &desc->segment=
s, node) {
>> +                       hw =3D &segment->hw;
>> +                       residue +=3D (hw->control - hw->status) &
>> +                                  XILINX_DMA_MAX_TRANS_LEN;
>> +               }
>> +       }
>> +
>> +       chan->residue =3D residue;
>> +       dma_cookie_complete(&desc->async_tx);
>> +       list_add_tail(&desc->node, &chan->done_list);
>> +
>> +       chan->active_desc =3D NULL;
>> +
>> +out_unlock:
>> +       spin_unlock_irqrestore(&chan->lock, flags);
>> +}
>> +
>> +/**
>> + * xilinx_dma_reset - Reset DMA channel
>> + * @chan: Driver specific DMA channel
>> + *
>> + * Return: '0' on success and failure value on error
>> + */
>> +static int xilinx_dma_reset(struct xilinx_dma_chan *chan)
>> +{
>> +       int loop =3D XILINX_DMA_LOOP_COUNT;
>> +       u32 tmp;
>> +
>> +       dma_ctrl_set(chan, XILINX_DMA_REG_CONTROL,
>> +                    XILINX_DMA_CR_RESET_MASK);
>> +
>> +       tmp =3D dma_ctrl_read(chan, XILINX_DMA_REG_CONTROL) &
>> +             XILINX_DMA_CR_RESET_MASK;
>> +
>> +       /* Wait for the hardware to finish reset */
>> +       do {
>> +               tmp =3D dma_ctrl_read(chan, XILINX_DMA_REG_CONTROL) &
>> +                     XILINX_DMA_CR_RESET_MASK;
>> +       } while (loop-- && tmp);
>> +
>> +       if (!loop) {
>> +               dev_err(chan->dev, "reset timeout, cr %x, sr %x\n",
>> +                       dma_ctrl_read(chan, XILINX_DMA_REG_CONTROL),
>> +                       dma_ctrl_read(chan, XILINX_DMA_REG_STATUS));
>> +               return -EBUSY;
>> +       }
>> +
>> +       chan->err =3D false;
>> +
>> +       return 0;
>> +}
>> +
>> +/**
>> + * xilinx_dma_irq_handler - DMA Interrupt handler
>> + * @irq: IRQ number
>> + * @data: Pointer to the Xilinx DMA channel structure
>> + *
>> + * Return: IRQ_HANDLED/IRQ_NONE
>> + */
>> +static irqreturn_t xilinx_dma_irq_handler(int irq, void *data)
>> +{
>> +       struct xilinx_dma_chan *chan =3D data;
>> +       u32 status;
>> +
>> +       /* Read the status and ack the interrupts. */
>> +       status =3D dma_ctrl_read(chan, XILINX_DMA_REG_STATUS);
>> +       if (!(status & XILINX_DMA_XR_IRQ_ALL_MASK))
>> +               return IRQ_NONE;
>> +
>> +       dma_ctrl_write(chan, XILINX_DMA_REG_STATUS,
>> +                      status & XILINX_DMA_XR_IRQ_ALL_MASK);
>> +
>> +       if (status & XILINX_DMA_XR_IRQ_ERROR_MASK) {
>> +               dev_err(chan->dev,
>> +                       "Channel %p has errors %x, cdr %x tdr %x\n",
>> +                       chan, dma_ctrl_read(chan, XILINX_DMA_REG_STATU=
S),
>> +                       dma_ctrl_read(chan, XILINX_DMA_REG_CURDESC),
>> +                       dma_ctrl_read(chan, XILINX_DMA_REG_TAILDESC));=

>> +               chan->err =3D true;
>> +       }
>> +
>> +       /*
>> +        * Device takes too long to do the transfer when user requires=

>> +        * responsiveness
>> +        */
>> +       if (status & XILINX_DMA_XR_IRQ_DELAY_MASK)
>> +               dev_dbg(chan->dev, "Inter-packet latency too long\n");=

>> +
>> +       if (status & XILINX_DMA_XR_IRQ_IOC_MASK) {
>> +               xilinx_dma_complete_descriptor(chan);
>> +               xilinx_dma_start_transfer(chan);
>> +       }
>> +
>> +       tasklet_schedule(&chan->tasklet);
>> +       return IRQ_HANDLED;
>> +}
>> +
>> +/**
>> + * xilinx_dma_tx_submit - Submit DMA transaction
>> + * @tx: Async transaction descriptor
>> + *
>> + * Return: cookie value on success and failure value on error
>> + */
>> +static dma_cookie_t xilinx_dma_tx_submit(struct dma_async_tx_descript=
or *tx)
>> +{
>> +       struct xilinx_dma_tx_descriptor *desc =3D to_dma_tx_descriptor=
(tx);
>> +       struct xilinx_dma_chan *chan =3D to_xilinx_chan(tx->chan);
>> +       dma_cookie_t cookie;
>> +       unsigned long flags;
>> +       int err;
>> +
>> +       if (chan->err) {
>> +               /*
>> +                * If reset fails, need to hard reset the system.
>> +                * Channel is no longer functional
>> +                */
>> +               err =3D xilinx_dma_reset(chan);
>> +               if (err < 0)
>> +                       return err;
>> +       }
>> +
>> +       spin_lock_irqsave(&chan->lock, flags);
>> +
>> +       cookie =3D dma_cookie_assign(tx);
>> +
>> +       /* Append the transaction to the pending transactions queue. *=
/
>> +       list_add_tail(&desc->node, &chan->pending_list);
>> +
>> +       /* Free the allocated desc */
>> +       chan->allocated_desc =3D NULL;
>> +
>> +       spin_unlock_irqrestore(&chan->lock, flags);
>> +
>> +       return cookie;
>> +}
>> +
>> +/**
>> + * xilinx_dma_prep_slave_sg - prepare descriptors for a DMA_SLAVE tra=
nsaction
>> + * @dchan: DMA channel
>> + * @sgl: scatterlist to transfer to/from
>> + * @sg_len: number of entries in @scatterlist
>> + * @direction: DMA direction
>> + * @flags: transfer ack flags
>> + * @context: APP words of the descriptor
>> + *
>> + * Return: Async transaction descriptor on success and NULL on failur=
e
>> + */
>> +static struct dma_async_tx_descriptor *xilinx_dma_prep_slave_sg(
>> +       struct dma_chan *dchan, struct scatterlist *sgl, unsigned int =
sg_len,
>> +       enum dma_transfer_direction direction, unsigned long flags,
>> +       void *context)
>> +{
>> +       struct xilinx_dma_chan *chan =3D to_xilinx_chan(dchan);
>> +       struct xilinx_dma_tx_descriptor *desc;
>> +       struct xilinx_dma_tx_segment *segment;
>> +       struct xilinx_dma_desc_hw *hw;
>> +       u32 *app_w =3D (u32 *)context;
>> +       struct scatterlist *sg;
>> +       size_t copy, sg_used;
>> +       int i;
>> +
>> +       if (!is_slave_direction(direction))
>> +               return NULL;
>> +
>> +       if (chan->direction !=3D direction)
>> +               return NULL;
>> +
>> +       /* Allocate a transaction descriptor. */
>> +       desc =3D xilinx_dma_alloc_tx_descriptor(chan);
>> +       if (!desc)
>> +               return NULL;
>> +
>> +       dma_async_tx_descriptor_init(&desc->async_tx, &chan->common);
>> +       desc->async_tx.tx_submit =3D xilinx_dma_tx_submit;
>> +       desc->async_tx.cookie =3D 0;
>> +       async_tx_ack(&desc->async_tx);
>> +
>> +       /* Build transactions using information in the scatter gather =
list */
>> +       for_each_sg(sgl, sg, sg_len, i) {
>> +               sg_used =3D 0;
>> +
>> +               /* Loop until the entire scatterlist entry is used */
>> +               while (sg_used < sg_dma_len(sg)) {
>> +
>> +                       /* Get a free segment */
>> +                       segment =3D xilinx_dma_alloc_tx_segment(chan);=

>> +                       if (!segment)
>> +                               goto error;
>> +
>> +                       /*
>> +                        * Calculate the maximum number of bytes to tr=
ansfer,
>> +                        * making sure it is less than the hw limit
>> +                        */
>> +                       copy =3D min_t(size_t, sg_dma_len(sg) - sg_use=
d,
>> +                                    XILINX_DMA_MAX_TRANS_LEN);
>> +                       hw =3D &segment->hw;
>> +
>> +                       /* Fill in the descriptor */
>> +                       hw->buf_addr =3D sg_dma_address(sg) + sg_used;=

>> +
>> +                       hw->control =3D copy;
>> +
>> +                       if (direction =3D=3D DMA_MEM_TO_DEV) {
>> +                               if (app_w)
>> +                                       memcpy(hw->app, app_w, sizeof(=
u32) *
>> +                                              XILINX_DMA_NUM_APP_WORD=
S);
>> +
>> +                               /*
>> +                                * For the first DMA_MEM_TO_DEV transf=
er,
>> +                                * set SOP
>> +                                */
>> +                               if (!i)
>> +                                       hw->control |=3D XILINX_DMA_BD=
_SOP;
>> +                       }
>> +
>> +                       sg_used +=3D copy;
>> +
>> +                       /*
>> +                        * Insert the segment into the descriptor segm=
ents
>> +                        * list.
>> +                        */
>> +                       list_add_tail(&segment->node, &desc->segments)=
;
>> +               }
>> +       }
>> +
>> +       /* For the last DMA_MEM_TO_DEV transfer, set EOP */
>> +       if (direction =3D=3D DMA_MEM_TO_DEV) {
>> +               segment =3D list_last_entry(&desc->segments,
>> +                                         struct xilinx_dma_tx_segment=
,
>> +                                         node);
>> +               segment->hw.control |=3D XILINX_DMA_BD_EOP;
>> +       }
>> +
>> +       return &desc->async_tx;
>> +
>> +error:
>> +       xilinx_dma_free_tx_descriptor(chan, desc);
>> +       return NULL;
>> +}
>> +
>> +/**
>> + * xilinx_dma_device_control - Configure DMA channel of the device
>> + * @dchan: DMA Channel pointer
>> + * @cmd: DMA control command
>> + * @arg: Channel configuration
>> + *
>> + * Return: '0' on success and failure value on error
>> + */
>> +static int xilinx_dma_device_control(struct dma_chan *dchan,
>> +                                    enum dma_ctrl_cmd cmd, unsigned l=
ong arg)
>> +{
>> +       struct xilinx_dma_chan *chan =3D to_xilinx_chan(dchan);
>> +       unsigned long flags;
>> +
>> +       if (cmd !=3D DMA_TERMINATE_ALL)
>> +               return -ENXIO;
>> +
>> +       /* Halt the DMA engine */
>> +       xilinx_dma_halt(chan);
>> +
>> +       spin_lock_irqsave(&chan->lock, flags);
>> +
>> +       /* Remove and free all of the descriptors in the lists */
>> +       xilinx_dma_free_desc_list(chan, &chan->pending_list);
>> +       xilinx_dma_free_desc_list(chan, &chan->done_list);
>> +
>> +       spin_unlock_irqrestore(&chan->lock, flags);
>> +
>> +       return 0;
>> +}
>> +
>> +/**
>> + * xilinx_dma_channel_set_config - Configure DMA channel
>> + * @dchan: DMA channel
>> + * @cfg: DMA device configuration pointer
>> + *
>> + * Return: '0' on success and failure value on error
>> + */
>> +int xilinx_dma_channel_set_config(struct dma_chan *dchan,
>> +                                 struct xilinx_dma_config *cfg)
>> +{
>> +       struct xilinx_dma_chan *chan =3D to_xilinx_chan(dchan);
>> +       u32 reg =3D dma_ctrl_read(chan, XILINX_DMA_REG_CONTROL);
>> +
>> +       if (cfg->reset)
>> +               return xilinx_dma_reset(chan);
>> +
>> +       if (cfg->coalesc <=3D XILINX_DMA_CR_COALESCE_MAX)
>> +               reg |=3D cfg->coalesc << XILINX_DMA_CR_COALESCE_SHIFT;=

>> +
>> +       if (cfg->delay <=3D XILINX_DMA_CR_DELAY_MAX)
>> +               reg |=3D cfg->delay << XILINX_DMA_CR_DELAY_SHIFT;
>> +
>> +       dma_ctrl_write(chan, XILINX_DMA_REG_CONTROL, reg);
>> +
>> +       return 0;
>> +}
>> +EXPORT_SYMBOL(xilinx_dma_channel_set_config);
>> +
>> +/**
>> + * xilinx_dma_chan_remove - Per Channel remove function
>> + * @chan: Driver specific DMA channel
>> + */
>> +static void xilinx_dma_chan_remove(struct xilinx_dma_chan *chan)
>> +{
>> +       /* Disable interrupts */
>> +       dma_ctrl_clr(chan, XILINX_DMA_REG_CONTROL, XILINX_DMA_XR_IRQ_A=
LL_MASK);
>> +
>> +       if (chan->irq > 0)
>> +               free_irq(chan->irq, chan);
>> +
>> +       tasklet_kill(&chan->tasklet);
>> +
>> +       list_del(&chan->common.device_node);
>> +}
>> +
>> +/**
>> + * xilinx_dma_chan_probe - Per Channel Probing
>> + * It get channel features from the device tree entry and
>> + * initialize special channel handling routines
>> + *
>> + * @xdev: Driver specific device structure
>> + * @node: Device node
>> + *
>> + * Return: '0' on success and failure value on error
>> + */
>> +static int xilinx_dma_chan_probe(struct xilinx_dma_device *xdev,
>> +                                struct device_node *node)
>> +{
>> +       struct xilinx_dma_chan *chan;
>> +       int err;
>> +       bool has_dre;
>> +       u32 value, width =3D 0;
>> +
>> +       /* Allocate a channel */
>> +       chan =3D devm_kzalloc(xdev->dev, sizeof(*chan), GFP_KERNEL);
>> +       if (!chan)
>> +               return -ENOMEM;
>> +
>> +       chan->dev =3D xdev->dev;
>> +       chan->xdev =3D xdev;
>> +       chan->has_sg =3D xdev->has_sg;
>> +
>> +       spin_lock_init(&chan->lock);
>> +       INIT_LIST_HEAD(&chan->pending_list);
>> +       INIT_LIST_HEAD(&chan->done_list);
>> +       INIT_LIST_HEAD(&chan->free_seg_list);
>> +
>> +       /* Get the DT properties */
>> +       has_dre =3D of_property_read_bool(node, "xlnx,include-dre");
>> +
>> +       err =3D of_property_read_u32(node, "xlnx,datawidth", &value);
>> +       if (err) {
>> +               dev_err(xdev->dev, "unable to read datawidth property"=
);
>> +               return err;
>> +       }
>> +
>> +       width =3D value >> 3; /* Convert bits to bytes */
>> +
>> +       /* If data width is greater than 8 bytes, DRE is not in hw */
>> +       if (width > 8)
>> +               has_dre =3D false;
>> +
>> +       if (!has_dre)
>> +               xdev->common.copy_align =3D fls(width - 1);
>> +
>> +       if (of_device_is_compatible(node, "xlnx,axi-dma-mm2s-channel")=
) {
>> +               chan->direction =3D DMA_MEM_TO_DEV;
>> +               chan->id =3D 0;
>> +               chan->ctrl_offset =3D XILINX_DMA_MM2S_CTRL_OFFSET;
>> +       } else if (of_device_is_compatible(node,
>> +                                          "xlnx,axi-dma-s2mm-channel"=
)) {
>> +               chan->direction =3D DMA_DEV_TO_MEM;
>> +               chan->id =3D 1;
>> +               chan->ctrl_offset =3D XILINX_DMA_S2MM_CTRL_OFFSET;
>> +       } else {
>> +               dev_err(xdev->dev, "Invalid channel compatible node\n"=
);
>> +               return -EINVAL;
>> +       }
>> +
>> +       /* Find the IRQ line, if it exists in the device tree */
>> +       chan->irq =3D irq_of_parse_and_map(node, 0);
>> +       err =3D request_irq(chan->irq, xilinx_dma_irq_handler,
>> +                         IRQF_SHARED,
>> +                         "xilinx-dma-controller", chan);
>> +       if (err) {
>> +               dev_err(xdev->dev, "unable to request IRQ %d\n", chan-=
>irq);
>> +               return err;
>> +       }
>> +
>> +       /* Initialize the tasklet */
>> +       tasklet_init(&chan->tasklet, xilinx_dma_do_tasklet,
>> +                    (unsigned long)chan);
>> +
>> +       /*
>> +        * Initialize the DMA channel and add it to the DMA engine cha=
nnels
>> +        * list.
>> +        */
>> +       chan->common.device =3D &xdev->common;
>> +
>> +       list_add_tail(&chan->common.device_node, &xdev->common.channel=
s);
>> +       xdev->chan[chan->id] =3D chan;
>> +
>> +       /* Reset the channel */
>> +       err =3D xilinx_dma_reset(chan);
>> +       if (err) {
>> +               dev_err(xdev->dev, "Reset channel failed\n");
>> +               return err;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +/**
>> + * of_dma_xilinx_xlate - Translation function
>> + * @dma_spec: Pointer to DMA specifier as found in the device tree
>> + * @ofdma: Pointer to DMA controller data
>> + *
>> + * Return: DMA channel pointer on success and NULL on error
>> + */
>> +static struct dma_chan *of_dma_xilinx_xlate(struct of_phandle_args *d=
ma_spec,
>> +                                           struct of_dma *ofdma)
>> +{
>> +       struct xilinx_dma_device *xdev =3D ofdma->of_dma_data;
>> +       int chan_id =3D dma_spec->args[0];
>> +
>> +       if (chan_id >=3D XILINX_DMA_MAX_CHANS_PER_DEVICE)
>> +               return NULL;
>> +
>> +       return dma_get_slave_channel(&xdev->chan[chan_id]->common);
>> +}
>> +
>> +/**
>> + * xilinx_dma_probe - Driver probe function
>> + * @pdev: Pointer to the platform_device structure
>> + *
>> + * Return: '0' on success and failure value on error
>> + */
>> +static int xilinx_dma_probe(struct platform_device *pdev)
>> +{
>> +       struct xilinx_dma_device *xdev;
>> +       struct device_node *child, *node;
>> +       struct resource *res;
>> +       int i, ret;
>> +
>> +       xdev =3D devm_kzalloc(&pdev->dev, sizeof(*xdev), GFP_KERNEL);
>> +       if (!xdev)
>> +               return -ENOMEM;
>> +
>> +       xdev->dev =3D &(pdev->dev);
>> +       INIT_LIST_HEAD(&xdev->common.channels);
>> +
>> +       node =3D pdev->dev.of_node;
>> +
>> +       /* Map the registers */
>> +       res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +       xdev->regs =3D devm_ioremap_resource(&pdev->dev, res);
>> +       if (IS_ERR(xdev->regs))
>> +               return PTR_ERR(xdev->regs);
>> +
>> +       /* Check if SG is enabled */
>> +       xdev->has_sg =3D of_property_read_bool(node, "xlnx,include-sg"=
);
>> +
>> +       /* Axi DMA only do slave transfers */
>> +       dma_cap_set(DMA_SLAVE, xdev->common.cap_mask);
>> +       dma_cap_set(DMA_PRIVATE, xdev->common.cap_mask);
>> +       xdev->common.device_prep_slave_sg =3D xilinx_dma_prep_slave_sg=
;
>> +       xdev->common.device_control =3D xilinx_dma_device_control;
>> +       xdev->common.device_issue_pending =3D xilinx_dma_issue_pending=
;
>> +       xdev->common.device_alloc_chan_resources =3D
>> +               xilinx_dma_alloc_chan_resources;
>> +       xdev->common.device_free_chan_resources =3D
>> +               xilinx_dma_free_chan_resources;
>> +       xdev->common.device_tx_status =3D xilinx_dma_tx_status;
>> +       xdev->common.dev =3D &pdev->dev;
>> +
>> +       platform_set_drvdata(pdev, xdev);
>> +
>> +       for_each_child_of_node(node, child) {
>> +               ret =3D xilinx_dma_chan_probe(xdev, child);
>> +               if (ret) {
>> +                       dev_err(&pdev->dev, "Probing channels failed\n=
");
>> +                       goto free_chan_resources;
>> +               }
>> +       }
>> +
>> +       dma_async_device_register(&xdev->common);
>> +
>> +       ret =3D of_dma_controller_register(node, of_dma_xilinx_xlate, =
xdev);
>> +       if (ret) {
>> +               dev_err(&pdev->dev, "Unable to register DMA to DT\n");=

>> +               dma_async_device_unregister(&xdev->common);
>> +               goto free_chan_resources;
>> +       }
>> +
>> +       dev_info(&pdev->dev, "Xilinx AXI DMA Engine driver Probed!!\n"=
);
>> +
>> +       return 0;
>> +
>> +free_chan_resources:
>> +       for (i =3D 0; i < XILINX_DMA_MAX_CHANS_PER_DEVICE; i++)
>> +               if (xdev->chan[i])
>> +                       xilinx_dma_chan_remove(xdev->chan[i]);
>> +
>> +       return ret;
>> +}
>> +
>> +/**
>> + * xilinx_dma_remove - Driver remove function
>> + * @pdev: Pointer to the platform_device structure
>> + *
>> + * Return: Always '0'
>> + */
>> +static int xilinx_dma_remove(struct platform_device *pdev)
>> +{
>> +       struct xilinx_dma_device *xdev =3D platform_get_drvdata(pdev);=

>> +       int i;
>> +
>> +       of_dma_controller_free(pdev->dev.of_node);
>> +       dma_async_device_unregister(&xdev->common);
>> +
>> +       for (i =3D 0; i < XILINX_DMA_MAX_CHANS_PER_DEVICE; i++)
>> +               if (xdev->chan[i])
>> +                       xilinx_dma_chan_remove(xdev->chan[i]);
>> +
>> +       return 0;
>> +}
>> +
>> +static const struct of_device_id xilinx_dma_of_match[] =3D {
>> +       { .compatible =3D "xlnx,axi-dma-1.00.a",},
>> +       {}
>> +};
>> +MODULE_DEVICE_TABLE(of, xilinx_dma_of_match);
>> +
>> +static struct platform_driver xilinx_dma_driver =3D {
>> +       .driver =3D {
>> +               .name =3D "xilinx-dma",
>> +               .owner =3D THIS_MODULE,
>> +               .of_match_table =3D xilinx_dma_of_match,
>> +       },
>> +       .probe =3D xilinx_dma_probe,
>> +       .remove =3D xilinx_dma_remove,
>> +};
>> +
>> +module_platform_driver(xilinx_dma_driver);
>> +
>> +MODULE_AUTHOR("Xilinx, Inc.");
>> +MODULE_DESCRIPTION("Xilinx DMA driver");
>> +MODULE_LICENSE("GPL v2");
>> diff --git a/include/linux/amba/xilinx_dma.h b/include/linux/amba/xili=
nx_dma.h
>> index 34b98f2..25272d1 100644
>> --- a/include/linux/amba/xilinx_dma.h
>> +++ b/include/linux/amba/xilinx_dma.h
>> @@ -15,6 +15,9 @@
>>  #include <linux/dma-mapping.h>
>>  #include <linux/dmaengine.h>
>>
>> +/* Number of AXI DMA APP Words */
>> +#define XILINX_DMA_NUM_APP_WORDS       5
>> +
>>  /**
>>   * struct xilinx_vdma_config - VDMA Configuration structure
>>   * @frm_dly: Frame delay
>> @@ -41,7 +44,21 @@ struct xilinx_vdma_config {
>>         int ext_fsync;
>>  };
>>
>> +/**
>> + * struct xilinx_dma_config - DMA Configuration structure
>> + * @coalesc: Interrupt coalescing threshold
>> + * @delay: Delay counter
>> + * @reset: Reset Channel
>> + */
>> +struct xilinx_dma_config {
>> +       int coalesc;
>> +       int delay;
>> +       int reset;
>> +};
>> +
>>  int xilinx_vdma_channel_set_config(struct dma_chan *dchan,
>>                                         struct xilinx_vdma_config *cfg=
);
>> +int xilinx_dma_channel_set_config(struct dma_chan *dchan,
>> +                                       struct xilinx_dma_config *cfg)=
;
>>
>>  #endif
>> --
>> 1.7.9.5
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>=20


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--NfvqpjmsNOlnLPKUD5xFgUvLfUKHc7n1t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlPklNUACgkQykllyylKDCE/YgCgnPDI4C3aTcRKGh+oc8avUod/
M9oAnRWK3KjdX51RSRUfeOxOf1IMYS2R
=ThBR
-----END PGP SIGNATURE-----

--NfvqpjmsNOlnLPKUD5xFgUvLfUKHc7n1t--
