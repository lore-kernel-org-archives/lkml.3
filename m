Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaCXG2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 02:28:09 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:54178 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbaCXG2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 02:28:07 -0400
MIME-Version: 1.0
In-Reply-To: <1395083192-3224-3-git-send-email-sthokal@xilinx.com>
References: <1395083192-3224-1-git-send-email-sthokal@xilinx.com>
	<1395083192-3224-3-git-send-email-sthokal@xilinx.com>
Date: Mon, 24 Mar 2014 11:50:49 +0530
Message-ID: <CABb+yY1z1Rr-EyJaeHQDb+thmKZVk5V93avokx6Z_EEuQFHyrw@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] dma: Add Xilinx AXI Video Direct Memory Access
 Engine driver support
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Srikanth Thokala <sthokal@xilinx.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        michal.simek@xilinx.com, Grant Likely <grant.likely@linaro.org>,
        robh+dt@kernel.org, levex@linux.com,
        Lars-Peter Clausen <lars@metafoo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        dmaengine@vger.kernel.org, andriy.shevchenko@linux.intel.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 12:36 AM, Srikanth Thokala <sthokal@xilinx.com> wrote:

> +
> +/**
> + * xilinx_vdma_prep_slave_sg - prepare a descriptor for a DMA_SLAVE transaction

Should be xilinx_vdma_dma_prep_interleaved here.

> +/**
> + * xilinx_vdma_channel_set_config - Configure VDMA channel
> + * Run-time configuration for Axi VDMA, supports:
> + * . halt the channel
> + * . configure interrupt coalescing and inter-packet delay threshold
> + * . start/stop parking
> + * . enable genlock
> + *
> + * @dchan: DMA channel
> + * @cfg: VDMA device configuration pointer
> + *
> + * Return: '0' on success and failure value on error
> + */
> +int xilinx_vdma_channel_set_config(struct dma_chan *dchan,
> +                                       struct xilinx_vdma_config *cfg)
> +{
> +       struct xilinx_vdma_chan *chan = to_xilinx_chan(dchan);
> +       u32 dmacr;
> +
> +       if (cfg->reset)
> +               return xilinx_vdma_chan_reset(chan);
> +
> +       dmacr = vdma_ctrl_read(chan, XILINX_VDMA_REG_DMACR);
> +
> +       chan->config.frm_dly = cfg->frm_dly;
> +       chan->config.park = cfg->park;
> +
> +       /* genlock settings */
> +       chan->config.gen_lock = cfg->gen_lock;
> +       chan->config.master = cfg->master;
> +
> +       if (cfg->gen_lock && chan->genlock) {
> +               dmacr |= XILINX_VDMA_DMACR_GENLOCK_EN;
> +               dmacr |= cfg->master << XILINX_VDMA_DMACR_MASTER_SHIFT;
> +       }
> +
> +       chan->config.frm_cnt_en = cfg->frm_cnt_en;
> +       if (cfg->park)
> +               chan->config.park_frm = cfg->park_frm;
> +       else
> +               chan->config.park_frm = -1;
> +
> +       chan->config.coalesc = cfg->coalesc;
> +       chan->config.delay = cfg->delay;
> +
> +       if (cfg->coalesc <= XILINX_VDMA_DMACR_FRAME_COUNT_MAX) {
> +               dmacr |= cfg->coalesc << XILINX_VDMA_DMACR_FRAME_COUNT_SHIFT;
> +               chan->config.coalesc = cfg->coalesc;
> +       }
> +
> +       if (cfg->delay <= XILINX_VDMA_DMACR_DELAY_MAX) {
> +               dmacr |= cfg->delay << XILINX_VDMA_DMACR_DELAY_SHIFT;
> +               chan->config.delay = cfg->delay;
> +       }
> +
> +       /* FSync Source selection */
> +       dmacr &= ~XILINX_VDMA_DMACR_FSYNCSRC_MASK;
> +       dmacr |= cfg->ext_fsync << XILINX_VDMA_DMACR_FSYNCSRC_SHIFT;
> +
> +       vdma_ctrl_write(chan, XILINX_VDMA_REG_DMACR, dmacr);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(xilinx_vdma_channel_set_config);
> +
Bypassing the DMAEngine api doesn't seem very neat.
Is there currently any client driver that /changes/ this configuration
between channel requests? If no, then simply get the configuration
from DT node and avoid this api.
