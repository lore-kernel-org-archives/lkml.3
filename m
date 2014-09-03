Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbaICGrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 02:47:47 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:52812 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbaICGrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 02:47:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140819170346.GS13288@intel.com>
References: <1406549869-24422-1-git-send-email-sthokal@xilinx.com>
	<1406549869-24422-2-git-send-email-sthokal@xilinx.com>
	<20140819170346.GS13288@intel.com>
Date: Wed, 3 Sep 2014 12:17:43 +0530
X-Google-Sender-Auth: aOlogTsgK1X4DDdclIYAnbIgHkY
Message-ID: <CA+mB=1L14Os=ZdJzj8_+XXa+oq4ZOS_kadQHpKQ2yws2tqGVSQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] dma: Add Xilinx AXI Direct Memory Access Engine
 driver support
From: Srikanth Thokala <sthokal@xilinx.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Srikanth Thokala <sthokal@xilinx.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Levente Kurusa <levex@linux.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org, anirudh@xilinx.com, svemula@xilinx.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

Apologies for the delay.

On Tue, Aug 19, 2014 at 10:33 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Mon, Jul 28, 2014 at 05:47:49PM +0530, Srikanth Thokala wrote:
>> +struct xilinx_dma_chan {
>> +     struct xilinx_dma_device *xdev;
>> +     u32 ctrl_offset;
>> +     spinlock_t lock;
>> +     struct list_head pending_list;
>> +     struct xilinx_dma_tx_descriptor *active_desc;
>> +     struct xilinx_dma_tx_descriptor *allocated_desc;
>> +     struct list_head done_list;
>> +     struct list_head free_seg_list;
>> +     struct dma_chan common;
>> +     struct xilinx_dma_tx_segment *seg_v;
>> +     dma_addr_t seg_p;
>> +     struct device *dev;
>> +     int irq;
>> +     int id;
>> +     enum dma_transfer_direction direction;
> This looks suspect. Why should channel have direction, for a descriptor it
> makes sense though.

The channel only supports transfers in one direction. Either from memory to
peripheral or from peripheral to memory, that's fixed and can't be changed
at runtime.  So, the driver needs to know which direction the channel supports
and hence it can reject transfers with the wrong direction.

>
>> +static enum dma_status xilinx_dma_tx_status(struct dma_chan *dchan,
>> +                                         dma_cookie_t cookie,
>> +                                         struct dma_tx_state *txstate)
>> +{
>> +     struct xilinx_dma_chan *chan = to_xilinx_chan(dchan);
>> +     enum dma_status ret;
>> +     unsigned long flags;
>> +
>> +     ret = dma_cookie_status(dchan, cookie, txstate);
>> +     if (ret != DMA_COMPLETE) {
>> +             spin_lock_irqsave(&chan->lock, flags);
>> +             dma_set_residue(txstate, chan->residue);
>> +             spin_unlock_irqrestore(&chan->lock, flags);
>> +     }
> No residue reporting?

I will fix this, thanks.

>
>> +static int xilinx_dma_device_control(struct dma_chan *dchan,
>> +                                  enum dma_ctrl_cmd cmd, unsigned long arg)
>> +{
>> +     struct xilinx_dma_chan *chan = to_xilinx_chan(dchan);
>> +     unsigned long flags;
>> +
>> +     if (cmd != DMA_TERMINATE_ALL)
>> +             return -ENXIO;
>> +
>> +     /* Halt the DMA engine */
>> +     xilinx_dma_halt(chan);
>> +
>> +     spin_lock_irqsave(&chan->lock, flags);
>> +
>> +     /* Remove and free all of the descriptors in the lists */
>> +     xilinx_dma_free_desc_list(chan, &chan->pending_list);
>> +     xilinx_dma_free_desc_list(chan, &chan->done_list);
>
>> +
>> +     spin_unlock_irqrestore(&chan->lock, flags);
>> +
>> +     return 0;
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
>> +                               struct xilinx_dma_config *cfg)
>> +{
>> +     struct xilinx_dma_chan *chan = to_xilinx_chan(dchan);
>> +     u32 reg = dma_ctrl_read(chan, XILINX_DMA_REG_CONTROL);
>> +
>> +     if (cfg->reset)
>> +             return xilinx_dma_reset(chan);
>> +
>> +     if (cfg->coalesc <= XILINX_DMA_CR_COALESCE_MAX)
>> +             reg |= cfg->coalesc << XILINX_DMA_CR_COALESCE_SHIFT;
>> +
>> +     if (cfg->delay <= XILINX_DMA_CR_DELAY_MAX)
>> +             reg |= cfg->delay << XILINX_DMA_CR_DELAY_SHIFT;
>> +
>> +     dma_ctrl_write(chan, XILINX_DMA_REG_CONTROL, reg);
> You aren't checking if a transaction is already running on this channel.
> Also don't you need other slave parameters, I see you have removed the
> dma_slave_config entirely

All the parameters that are required for this DMA engine are provided by
SG list, so I don't see the need of dma_slave_config.  There are some
specific IP parameters that are not part of dma_slave_config and these
are being set by 'dma_channel_set_config' which is exported to slave
drivers.

Thanks for the reveiw,
Srikanth

>
> --
> ~Vinod
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
