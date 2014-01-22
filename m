Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbaAVVaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 16:30:12 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:47424 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaAVVaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 16:30:09 -0500
MIME-Version: 1.0
In-Reply-To: <1390409565-4200-2-git-send-email-sthokal@xilinx.com>
References: <1390409565-4200-1-git-send-email-sthokal@xilinx.com>
	<1390409565-4200-2-git-send-email-sthokal@xilinx.com>
Date: Wed, 22 Jan 2014 22:30:08 +0100
X-Google-Sender-Auth: nkozEnOn-EEVJCAReQ19F5TPmP0
Message-ID: <CAAsK9AFGM+852N-F98p32JSHEpg5ZKv-0wyzFGx9675GBp7gQg@mail.gmail.com>
Subject: Re: [PATCH v2] dma: Add Xilinx AXI Video Direct Memory Access Engine
 driver support
From: Levente Kurusa <levex@linux.com>
To: Srikanth Thokala <sthokal@xilinx.com>
Cc: dan.j.williams@intel.com, vinod.koul@intel.com, michal.simek@xilinx.com,
        Grant Likely <grant.likely@linaro.org>, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, dmaengine@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2014/1/22 Srikanth Thokala <sthokal@xilinx.com>:
> This is the driver for the AXI Video Direct Memory Access (AXI
> VDMA) core, which is a soft Xilinx IP core that provides high-
> bandwidth direct memory access between memory and AXI4-Stream
> type video target peripherals. The core provides efficient two
> dimensional DMA operations with independent asynchronous read
> and write channel operation.
>
> This module works on Zynq (ARM Based SoC) and Microblaze platforms.
>
> Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>
> ---

Another two remarks, after you fixed them ( or not :-) )
you can have my:

Reviewed-by: Levente Kurusa <levex@linux.com>

Oh, and next time please if you post a patch that fixes something I pointed out,
CC me as I had a hard time finding this patch, thanks. :-)

> NOTE:
> 1. Created a separate directory 'dma/xilinx' as Xilinx has two more
>    DMA IPs and we are also planning to upstream these drivers soon.
> 2. Rebased on v3.13.0-rc8
>
> Changes in v2:
> - Removed DMA Test client module from the patchset as suggested
>   by Andy Shevchenko
> - Removed device-id DT property, as suggested by Arnd Bergmann
> - Properly documented DT bindings as suggested by Arnd Bergmann
> - Returning with error, if registration of DMA to node fails
> - Fixed typo errors
> - Used BIT() macro at applicable places
> - Added missing header file to the patchset
> - Changed copyright year to include 2014
> ---
>  .../devicetree/bindings/dma/xilinx/xilinx_vdma.txt |   75 +
>  drivers/dma/Kconfig                                |   14 +
>  drivers/dma/Makefile                               |    1 +
>  drivers/dma/xilinx/Makefile                        |    1 +
>  drivers/dma/xilinx/xilinx_vdma.c                   | 1486 ++++++++++++++++++++
>  include/linux/amba/xilinx_dma.h                    |   50 +
>  6 files changed, 1627 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
>  create mode 100644 drivers/dma/xilinx/Makefile
>  create mode 100644 drivers/dma/xilinx/xilinx_vdma.c
>  create mode 100644 include/linux/amba/xilinx_dma.h
>
> diff --git a/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt b/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
> new file mode 100644
> index 0000000..ab8be1a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
> @@ -0,0 +1,75 @@
> +Xilinx AXI VDMA engine, it does transfers between memory and video devices.
> +It can be configured to have one channel or two channels. If configured
> +as two channels, one is to transmit to the video device and another is
> +to receive from the video device.
> +
> +Required properties:
> +- compatible: Should be "xlnx,axi-vdma-1.00.a"
> +- #dma-cells: Should be <1>, see "dmas" property below
> +- reg: Should contain VDMA registers location and length.
> +- xlnx,num-fstores: Should be the number of framebuffers as configured in h/w.
> +- dma-channel child node: Should have atleast one channel and can have upto
> +       two channels per device. This node specifies the properties of each
> +       DMA channel (see child node properties below).
> +
> +Optional properties:
> +- xlnx,include-sg: Tells whether configured for Scatter-mode in
> +       the hardware.
> [...]
> +
> +/**
> + * xilinx_vdma_is_running - Check if VDMA channel is running
> + * @chan: Driver specific VDMA channel
> + *
> + * Return: '1' if running, '0' if not.
> + */
> +static int xilinx_vdma_is_running(struct xilinx_vdma_chan *chan)
> +{
> +       return !(vdma_ctrl_read(chan, XILINX_VDMA_REG_DMASR) &
> +                XILINX_VDMA_DMASR_HALTED) &&
> +               (vdma_ctrl_read(chan, XILINX_VDMA_REG_DMACR) &
> +                XILINX_VDMA_DMACR_RUNSTOP);
> +}
> +
> +/**
> + * xilinx_vdma_is_idle - Check if VDMA channel is idle
> + * @chan: Driver specific VDMA channel
> + *
> + * Return: '1' if idle, '0' if not.
> + */
> +static int xilinx_vdma_is_idle(struct xilinx_vdma_chan *chan)
> +{
> +       return vdma_ctrl_read(chan, XILINX_VDMA_REG_DMASR) &
> +               XILINX_VDMA_DMASR_IDLE;
> +}
> +
> +/**
> + * xilinx_vdma_halt - Halt VDMA channel
> + * @chan: Driver specific VDMA channel
> + */
> +static void xilinx_vdma_halt(struct xilinx_vdma_chan *chan)
> +{
> +       int loop = XILINX_VDMA_LOOP_COUNT + 1;
> +
> +       vdma_ctrl_clr(chan, XILINX_VDMA_REG_DMACR, XILINX_VDMA_DMACR_RUNSTOP);
> +
> +       /* Wait for the hardware to halt */
> +       while (loop--)
> +               if (vdma_ctrl_read(chan, XILINX_VDMA_REG_DMASR) &
> +                   XILINX_VDMA_DMASR_HALTED)
> +                       break;
> +
> +       if (!loop) {
> +               dev_err(chan->dev, "Cannot stop channel %p: %x\n",
> +                       chan, vdma_ctrl_read(chan, XILINX_VDMA_REG_DMASR));
> +               chan->err = true;
> +       }
> +
> +       return;
> +}
> +
> +/**
> + * xilinx_vdma_start - Start VDMA channel
> + * @chan: Driver specific VDMA channel
> + */
> +static void xilinx_vdma_start(struct xilinx_vdma_chan *chan)
> +{
> +       int loop = XILINX_VDMA_LOOP_COUNT + 1;
> +
> +       vdma_ctrl_set(chan, XILINX_VDMA_REG_DMACR, XILINX_VDMA_DMACR_RUNSTOP);
> +
> +       /* Wait for the hardware to start */
> +       while (loop--)
> +               if (!(vdma_ctrl_read(chan, XILINX_VDMA_REG_DMASR) &
> +                     XILINX_VDMA_DMASR_HALTED))
> +                       break;
> +
> +       if (!loop) {
> +               dev_err(chan->dev, "Cannot start channel %p: %x\n",
> +                       chan, vdma_ctrl_read(chan, XILINX_VDMA_REG_DMASR));
> +
> +               chan->err = true;
> +       }
> +
> +       return;
> +}
> +
> +/**
> + * xilinx_vdma_start_transfer - Starts VDMA transfer
> + * @chan: Driver specific channel struct pointer
> + */
> +static void xilinx_vdma_start_transfer(struct xilinx_vdma_chan *chan)
> +{
> +       struct xilinx_vdma_config *config = &chan->config;
> +       struct xilinx_vdma_tx_descriptor *desc;
> +       unsigned long flags;
> +       u32 reg;
> +       struct xilinx_vdma_tx_segment *head, *tail = NULL;
> +
> +       if (chan->err)
> +               return;
> +
> +       spin_lock_irqsave(&chan->lock, flags);
> +
> +       /* There's already an active descriptor, bail out. */
> +       if (chan->active_desc)
> +               goto out_unlock;
> +
> +       if (list_empty(&chan->pending_list))
> +               goto out_unlock;
> +
> +       desc = list_first_entry(&chan->pending_list,
> +                               struct xilinx_vdma_tx_descriptor, node);
> +
> +       /* If it is SG mode and hardware is busy, cannot submit */
> +       if (chan->has_sg && xilinx_vdma_is_running(chan) &&
> +           !xilinx_vdma_is_idle(chan)) {
> +               dev_dbg(chan->dev, "DMA controller still busy\n");
> +               goto out_unlock;
> +       }
> +
> +       if (chan->err)
> +               goto out_unlock;
> +
> +       /*
> +        * If hardware is idle, then all descriptors on the running lists are
> +        * done, start new transfers
> +        */
> +       if (chan->has_sg) {
> +               head = list_first_entry(&desc->segments,
> +                                       struct xilinx_vdma_tx_segment, node);
> +               tail = list_entry(desc->segments.prev,
> +                                 struct xilinx_vdma_tx_segment, node);
> +
> +               vdma_ctrl_write(chan, XILINX_VDMA_REG_CURDESC, head->phys);
> +       }
> +
> +       /* Configure the hardware using info in the config structure */
> +       reg = vdma_ctrl_read(chan, XILINX_VDMA_REG_DMACR);
> +
> +       if (config->frm_cnt_en)
> +               reg |= XILINX_VDMA_DMACR_FRAMECNT_EN;
> +       else
> +               reg &= ~XILINX_VDMA_DMACR_FRAMECNT_EN;
> +
> +       /*
> +        * With SG, start with circular mode, so that BDs can be fetched.
> +        * In direct register mode, if not parking, enable circular mode
> +        */
> +       if (chan->has_sg || !config->park)
> +               reg |= XILINX_VDMA_DMACR_CIRC_EN;
> +
> +       if (config->park)
> +               reg &= ~XILINX_VDMA_DMACR_CIRC_EN;
> +
> +       vdma_ctrl_write(chan, XILINX_VDMA_REG_DMACR, reg);
> +
> +       if (config->park && (config->park_frm >= 0) &&
> +                       (config->park_frm < chan->num_frms)) {
> +               if (chan->direction == DMA_MEM_TO_DEV)
> +                       vdma_write(chan, XILINX_VDMA_REG_PARK_PTR,
> +                               config->park_frm <<
> +                                       XILINX_VDMA_PARK_PTR_RD_REF_SHIFT);
> +               else
> +                       vdma_write(chan, XILINX_VDMA_REG_PARK_PTR,
> +                               config->park_frm <<
> +                                       XILINX_VDMA_PARK_PTR_WR_REF_SHIFT);
> +       }
> +
> +       /* Start the hardware */
> +       xilinx_vdma_start(chan);
> +
> +       if (chan->err)
> +               goto out_unlock;
> +
> +       /* Start the transfer */
> +       if (chan->has_sg) {
> +               vdma_ctrl_write(chan, XILINX_VDMA_REG_TAILDESC, tail->phys);
> +       } else {
> +               struct xilinx_vdma_tx_segment *segment;
> +               int i = 0;
> +
> +               list_for_each_entry(segment, &desc->segments, node)
> +                       vdma_desc_write(chan,
> +                                       XILINX_VDMA_REG_START_ADDRESS(i++),
> +                                       segment->hw.buf_addr);
> +
> +               vdma_desc_write(chan, XILINX_VDMA_REG_HSIZE, config->hsize);
> +               vdma_desc_write(chan, XILINX_VDMA_REG_FRMDLY_STRIDE,
> +                               (config->frm_dly <<
> +                                XILINX_VDMA_FRMDLY_STRIDE_FRMDLY_SHIFT) |
> +                               (config->stride <<
> +                                XILINX_VDMA_FRMDLY_STRIDE_STRIDE_SHIFT));
> +               vdma_desc_write(chan, XILINX_VDMA_REG_VSIZE, config->vsize);
> +       }
> +
> +       list_del(&desc->node);
> +       chan->active_desc = desc;
> +
> +out_unlock:
> +       spin_unlock_irqrestore(&chan->lock, flags);
> +}
> +
> +/**
> + * xilinx_vdma_issue_pending - Issue pending transactions
> + * @dchan: DMA channel
> + */
> +static void xilinx_vdma_issue_pending(struct dma_chan *dchan)
> +{
> +       struct xilinx_vdma_chan *chan = to_xilinx_chan(dchan);
> +
> +       xilinx_vdma_start_transfer(chan);
> +}
> +
> +/**
> + * xilinx_vdma_complete_descriptor - Mark the active descriptor as complete
> + * @chan : xilinx DMA channel
> + *
> + * CONTEXT: hardirq
> + */
> +static void xilinx_vdma_complete_descriptor(struct xilinx_vdma_chan *chan)
> +{
> +       struct xilinx_vdma_tx_descriptor *desc;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&chan->lock, flags);
> +
> +       desc = chan->active_desc;
> +       if (!desc) {
> +               dev_dbg(chan->dev, "no running descriptors\n");
> +               goto out_unlock;
> +       }
> +
> +       list_add_tail(&desc->node, &chan->done_list);
> +
> +       /* Update the completed cookie and reset the active descriptor. */
> +       chan->completed_cookie = desc->async_tx.cookie;
> +       chan->active_desc = NULL;
> +
> +out_unlock:
> +       spin_unlock_irqrestore(&chan->lock, flags);
> +}
> +
> +/**
> + * xilinx_vdma_reset - Reset VDMA channel
> + * @chan: Driver specific VDMA channel
> + *
> + * Return: '0' on success and failure value on error
> + */
> +static int xilinx_vdma_reset(struct xilinx_vdma_chan *chan)
> +{
> +       int loop = XILINX_VDMA_LOOP_COUNT + 1;
> +       u32 tmp;
> +
> +       vdma_ctrl_set(chan, XILINX_VDMA_REG_DMACR, XILINX_VDMA_DMACR_RESET);
> +
> +       tmp = vdma_ctrl_read(chan, XILINX_VDMA_REG_DMACR) &
> +               XILINX_VDMA_DMACR_RESET;
> +
> +       /* Wait for the hardware to finish reset */
> +       while (loop-- && tmp)
> +               tmp = vdma_ctrl_read(chan, XILINX_VDMA_REG_DMACR) &
> +                       XILINX_VDMA_DMACR_RESET;
> +
> +       if (!loop) {
> +               dev_err(chan->dev, "reset timeout, cr %x, sr %x\n",
> +                       vdma_ctrl_read(chan, XILINX_VDMA_REG_DMACR),
> +                       vdma_ctrl_read(chan, XILINX_VDMA_REG_DMASR));
> +               return -ETIMEDOUT;
> +       }
> +
> +       chan->err = false;
> +
> +       return 0;
> +}
> +
> +/**
> + * xilinx_vdma_chan_reset - Reset VDMA channel and enable interrupts
> + * @chan: Driver specific VDMA channel
> + *
> + * Return: '0' on success and failure value on error
> + */
> +static int xilinx_vdma_chan_reset(struct xilinx_vdma_chan *chan)
> +{
> +       int err;
> +
> +       /* Reset VDMA */
> +       err = xilinx_vdma_reset(chan);
> +       if (err)
> +               return err;
> +
> +       /* Enable interrupts */
> +       vdma_ctrl_set(chan, XILINX_VDMA_REG_DMACR,
> +                     XILINX_VDMA_DMAXR_ALL_IRQ_MASK);
> +
> +       return 0;
> +}
> +
> +/**
> + * xilinx_vdma_irq_handler - VDMA Interrupt handler
> + * @irq: IRQ number
> + * @data: Pointer to the Xilinx VDMA channel structure
> + *
> + * Return: IRQ_HANDLED/IRQ_NONE
> + */
> +static irqreturn_t xilinx_vdma_irq_handler(int irq, void *data)
> +{
> +       struct xilinx_vdma_chan *chan = data;
> +       u32 status;
> +
> +       /* Read the status and ack the interrupts. */
> +       status = vdma_ctrl_read(chan, XILINX_VDMA_REG_DMASR);
> +       if (!(status & XILINX_VDMA_DMAXR_ALL_IRQ_MASK))
> +               return IRQ_NONE;
> +
> +       vdma_ctrl_write(chan, XILINX_VDMA_REG_DMASR,
> +                       status & XILINX_VDMA_DMAXR_ALL_IRQ_MASK);
> +
> +       if (status & XILINX_VDMA_DMASR_ERR_IRQ) {
> +               /*
> +                * An error occurred. If C_FLUSH_ON_FSYNC is enabled and the
> +                * error is recoverable, ignore it. Otherwise flag the error.
> +                *
> +                * Only recoverable errors can be cleared in the DMASR register,
> +                * make sure not to write to other error bits to 1.
> +                */
> +               u32 errors = status & XILINX_VDMA_DMASR_ALL_ERR_MASK;
> +               vdma_ctrl_write(chan, XILINX_VDMA_REG_DMASR,
> +                               errors & XILINX_VDMA_DMASR_ERR_RECOVER_MASK);
> +
> +               if (!chan->flush_on_fsync ||
> +                   (errors & ~XILINX_VDMA_DMASR_ERR_RECOVER_MASK)) {
> +                       dev_err(chan->dev,
> +                               "Channel %p has errors %x, cdr %x tdr %x\n",
> +                               chan, errors,
> +                               vdma_ctrl_read(chan, XILINX_VDMA_REG_CURDESC),
> +                               vdma_ctrl_read(chan, XILINX_VDMA_REG_TAILDESC));
> +                       chan->err = true;
> +               }
> +       }
> +
> +       if (status & XILINX_VDMA_DMASR_DLY_CNT_IRQ) {
> +               /*
> +                * Device takes too long to do the transfer when user requires
> +                * responsiveness.
> +                */
> +               dev_dbg(chan->dev, "Inter-packet latency too long\n");
> +       }
> +
> +       if (status & XILINX_VDMA_DMASR_FRM_CNT_IRQ) {
> +               xilinx_vdma_complete_descriptor(chan);
> +               xilinx_vdma_start_transfer(chan);
> +       }
> +
> +       tasklet_schedule(&chan->tasklet);
> +       return IRQ_HANDLED;
> +}
> +
> +/**
> + * xilinx_vdma_tx_submit - Submit DMA transaction
> + * @tx: Async transaction descriptor
> + *
> + * Return: cookie value on success and failure value on error
> + */
> +static dma_cookie_t xilinx_vdma_tx_submit(struct dma_async_tx_descriptor *tx)
> +{
> +       struct xilinx_vdma_tx_descriptor *desc = to_vdma_tx_descriptor(tx);
> +       struct xilinx_vdma_chan *chan = to_xilinx_chan(tx->chan);
> +       struct xilinx_vdma_tx_segment *segment;
> +       dma_cookie_t cookie;
> +       unsigned long flags;
> +       int err;
> +
> +       if (chan->err) {
> +               /*
> +                * If reset fails, need to hard reset the system.
> +                * Channel is no longer functional
> +                */
> +               err = xilinx_vdma_chan_reset(chan);
> +               if (err < 0)
> +                       return err;
> +       }
> +
> +       spin_lock_irqsave(&chan->lock, flags);
> +
> +       /* Assign cookies to all of the segments that make up this transaction.
> +        * Use the cookie of the last segment as the transaction cookie.
> +        */
> +       cookie = chan->cookie;
> +
> +       list_for_each_entry(segment, &desc->segments, node) {
> +               if (cookie < DMA_MAX_COOKIE)
> +                       cookie++;
> +               else
> +                       cookie = DMA_MIN_COOKIE;
> +
> +               segment->cookie = cookie;
> +       }
> +
> +       tx->cookie = cookie;
> +       chan->cookie = cookie;
> +
> +       /* Append the transaction to the pending transactions queue. */
> +       list_add_tail(&desc->node, &chan->pending_list);
> +
> +       spin_unlock_irqrestore(&chan->lock, flags);
> +
> +       return cookie;
> +}
> +
> +/**
> + * xilinx_vdma_prep_slave_sg - prepare a descriptor for a DMA_SLAVE transaction
> + * @dchan: DMA channel
> + * @sgl: scatterlist to transfer to/from
> + * @sg_len: number of entries in @sgl
> + * @dir: DMA direction
> + * @flags: transfer ack flags
> + * @context: unused
> + *
> + * Return: Async transaction descriptor on success and NULL on failure
> + */
> +static struct dma_async_tx_descriptor *
> +xilinx_vdma_prep_slave_sg(struct dma_chan *dchan, struct scatterlist *sgl,
> +                         unsigned int sg_len, enum dma_transfer_direction dir,
> +                         unsigned long flags, void *context)
> +{
> +       struct xilinx_vdma_chan *chan = to_xilinx_chan(dchan);
> +       struct xilinx_vdma_tx_descriptor *desc;
> +       struct xilinx_vdma_tx_segment *segment;
> +       struct xilinx_vdma_tx_segment *prev = NULL;
> +       struct scatterlist *sg;
> +       int i;
> +
> +       if (chan->direction != dir || sg_len == 0)
> +               return NULL;
> +
> +       /* Enforce one sg entry for one frame. */
> +       if (sg_len != chan->num_frms) {
> +               dev_err(chan->dev,
> +               "number of entries %d not the same as num stores %d\n",
> +                       sg_len, chan->num_frms);
> +               return NULL;
> +       }
> +
> +       /* Allocate a transaction descriptor. */
> +       desc = xilinx_vdma_alloc_tx_descriptor(chan);
> +       if (!desc)
> +               return NULL;
> +
> +       dma_async_tx_descriptor_init(&desc->async_tx, &chan->common);
> +       desc->async_tx.tx_submit = xilinx_vdma_tx_submit;
> +       desc->async_tx.cookie = 0;
> +       async_tx_ack(&desc->async_tx);
> +
> +       /* Build the list of transaction segments. */
> +       for_each_sg(sgl, sg, sg_len, i) {
> +               struct xilinx_vdma_desc_hw *hw;
> +
> +               /* Allocate the link descriptor from DMA pool */
> +               segment = xilinx_vdma_alloc_tx_segment(chan);
> +               if (!segment)
> +                       goto error;
> +
> +               /* Fill in the hardware descriptor */
> +               hw = &segment->hw;
> +               hw->buf_addr = sg_dma_address(sg);
> +               hw->vsize = chan->config.vsize;
> +               hw->hsize = chan->config.hsize;
> +               hw->stride = (chan->config.frm_dly <<
> +                             XILINX_VDMA_FRMDLY_STRIDE_FRMDLY_SHIFT) |
> +                            (chan->config.stride <<
> +                             XILINX_VDMA_FRMDLY_STRIDE_STRIDE_SHIFT);
> +               if (prev)
> +                       prev->hw.next_desc = segment->phys;
> +
> +               /* Insert the segment into the descriptor segments list. */
> +               list_add_tail(&segment->node, &desc->segments);
> +
> +               prev = segment;
> +       }
> +
> +       /* Link the last hardware descriptor with the first. */
> +       segment = list_first_entry(&desc->segments,
> +                                  struct xilinx_vdma_tx_segment, node);
> +       prev->hw.next_desc = segment->phys;
> +
> +       return &desc->async_tx;
> +
> +error:
> +       xilinx_vdma_free_tx_descriptor(chan, desc);
> +       return NULL;
> +}
> +
> +/**
> + * xilinx_vdma_terminate_all - Halt the channel and free descriptors
> + * @chan: Driver specific VDMA Channel pointer
> + */
> +static void xilinx_vdma_terminate_all(struct xilinx_vdma_chan *chan)
> +{
> +       /* Halt the DMA engine */
> +       xilinx_vdma_halt(chan);
> +
> +       /* Remove and free all of the descriptors in the lists */
> +       xilinx_vdma_free_descriptors(chan);
> +}
> +
> +/**
> + * xilinx_vdma_slave_config - Configure VDMA channel
> + * Run-time configuration for Axi VDMA, supports:
> + * . halt the channel
> + * . configure interrupt coalescing and inter-packet delay threshold
> + * . start/stop parking
> + * . enable genlock
> + * . set transfer information using config struct
> + *
> + * @chan: Driver specific VDMA Channel pointer
> + * @cfg: Channel configuration pointer
> + *
> + * Return: '0' on success and failure value on error
> + */
> +static int xilinx_vdma_slave_config(struct xilinx_vdma_chan *chan,
> +                                   struct xilinx_vdma_config *cfg)
> +{
> +       u32 dmacr;
> +
> +       if (cfg->reset)
> +               return xilinx_vdma_chan_reset(chan);
> +
> +       dmacr = vdma_ctrl_read(chan, XILINX_VDMA_REG_DMACR);
> +
> +       /* If vsize is -1, it is park-related operations */
> +       if (cfg->vsize == -1) {
> +               if (cfg->park)
> +                       dmacr &= ~XILINX_VDMA_DMACR_CIRC_EN;
> +               else
> +                       dmacr |= XILINX_VDMA_DMACR_CIRC_EN;
> +
> +               vdma_ctrl_write(chan, XILINX_VDMA_REG_DMACR, dmacr);
> +               return 0;
> +       }
> +
> +       /* If hsize is -1, it is interrupt threshold settings */
> +       if (cfg->hsize == -1) {
> +               if (cfg->coalesc <= XILINX_VDMA_DMACR_FRAME_COUNT_MAX) {
> +                       dmacr &= ~XILINX_VDMA_DMACR_FRAME_COUNT_MASK;
> +                       dmacr |= cfg->coalesc <<
> +                                XILINX_VDMA_DMACR_FRAME_COUNT_SHIFT;
> +                       chan->config.coalesc = cfg->coalesc;
> +               }
> +
> +               if (cfg->delay <= XILINX_VDMA_DMACR_DELAY_MAX) {
> +                       dmacr &= ~XILINX_VDMA_DMACR_DELAY_MASK;
> +                       dmacr |= cfg->delay << XILINX_VDMA_DMACR_DELAY_SHIFT;
> +                       chan->config.delay = cfg->delay;
> +               }
> +
> +               vdma_ctrl_write(chan, XILINX_VDMA_REG_DMACR, dmacr);
> +               return 0;
> +       }
> +
> +       /* Transfer information */
> +       chan->config.vsize = cfg->vsize;
> +       chan->config.hsize = cfg->hsize;
> +       chan->config.stride = cfg->stride;
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
> +       return 0;
> +}
> +
> +/**
> + * xilinx_vdma_device_control - Configure DMA channel of the device
> + * @dchan: DMA Channel pointer
> + * @cmd: DMA control command
> + * @arg: Channel configuration
> + *
> + * Return: '0' on success and failure value on error
> + */
> +static int xilinx_vdma_device_control(struct dma_chan *dchan,
> +                                     enum dma_ctrl_cmd cmd, unsigned long arg)
> +{
> +       struct xilinx_vdma_chan *chan = to_xilinx_chan(dchan);
> +
> +       switch (cmd) {
> +       case DMA_TERMINATE_ALL:
> +               xilinx_vdma_terminate_all(chan);
> +               return 0;
> +       case DMA_SLAVE_CONFIG:
> +               return xilinx_vdma_slave_config(chan,
> +                                       (struct xilinx_vdma_config *)arg);
> +       default:
> +               return -ENXIO;
> +       }
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Probe and remove
> + */
> +
> +/**
> + * xilinx_vdma_chan_remove - Per Channel remove function
> + * @chan: Driver specific VDMA channel
> + */
> +static void xilinx_vdma_chan_remove(struct xilinx_vdma_chan *chan)
> +{
> +       /* Disable all interrupts */
> +       vdma_ctrl_clr(chan, XILINX_VDMA_REG_DMACR,
> +                     XILINX_VDMA_DMAXR_ALL_IRQ_MASK);
> +
> +       list_del(&chan->common.device_node);
> +}
> +
> +/**
> + * xilinx_vdma_chan_probe - Per Channel Probing
> + * It get channel features from the device tree entry and
> + * initialize special channel handling routines
> + *
> + * @xdev: Driver specific device structure
> + * @node: Device node
> + *
> + * Return: '0' on success and failure value on error
> + */
> +static int xilinx_vdma_chan_probe(struct xilinx_vdma_device *xdev,
> +                                 struct device_node *node)
> +{
> +       struct xilinx_vdma_chan *chan;
> +       bool has_dre = false;
> +       u32 value;
> +       int err;
> +
> +       /* Allocate and initialize the channel structure */
> +       chan = devm_kzalloc(xdev->dev, sizeof(*chan), GFP_KERNEL);
> +       if (!chan)
> +               return -ENOMEM;
> +
> +       chan->dev = xdev->dev;
> +       chan->xdev = xdev;
> +       chan->has_sg = xdev->has_sg;
> +
> +       spin_lock_init(&chan->lock);
> +       INIT_LIST_HEAD(&chan->pending_list);
> +       INIT_LIST_HEAD(&chan->done_list);
> +
> +       /* Retrieve the channel properties from the device tree */
> +       has_dre = of_property_read_bool(node, "xlnx,include-dre");
> +
> +       chan->genlock = of_property_read_bool(node, "xlnx,genlock-mode");
> +
> +       err = of_property_read_u32(node, "xlnx,datawidth", &value);
> +       if (!err) {
> +               u32 width = value >> 3; /* Convert bits to bytes */
> +
> +               /* If data width is greater than 8 bytes, DRE is not in hw */
> +               if (width > 8)
> +                       has_dre = false;
> +
> +               if (!has_dre)
> +                       xdev->common.copy_align = fls(width - 1);
> +       } else {
> +               dev_err(xdev->dev, "missing xlnx,datawidth property\n");
> +               return err;
> +       }

Can you please convert this to:
if (err) {
 dev_err(...);
 return err;
}

That way we can avoid the else clause.
> +
> +       if (of_device_is_compatible(node, "xlnx,axi-vdma-mm2s-channel")) {
> +               chan->direction = DMA_MEM_TO_DEV;
> +               chan->id = 0;
> +
> +               chan->ctrl_offset = XILINX_VDMA_MM2S_CTRL_OFFSET;
> +               chan->desc_offset = XILINX_VDMA_MM2S_DESC_OFFSET;
> +
> +               if (xdev->flush_on_fsync == XILINX_VDMA_FLUSH_BOTH ||
> +                   xdev->flush_on_fsync == XILINX_VDMA_FLUSH_MM2S)
> +                       chan->flush_on_fsync = true;
> +       } else if (of_device_is_compatible(node,
> +                                           "xlnx,axi-vdma-s2mm-channel")) {
> +               chan->direction = DMA_DEV_TO_MEM;
> +               chan->id = 1;
> +
> +               chan->ctrl_offset = XILINX_VDMA_S2MM_CTRL_OFFSET;
> +               chan->desc_offset = XILINX_VDMA_S2MM_DESC_OFFSET;
> +
> +               if (xdev->flush_on_fsync == XILINX_VDMA_FLUSH_BOTH ||
> +                   xdev->flush_on_fsync == XILINX_VDMA_FLUSH_S2MM)
> +                       chan->flush_on_fsync = true;
> +       } else {
> +               dev_err(xdev->dev, "Invalid channel compatible node\n");
> +               return -EINVAL;
> +       }
> +
> +       /* Request the interrupt */
> +       chan->irq = irq_of_parse_and_map(node, 0);
> +       err = devm_request_irq(xdev->dev, chan->irq, xilinx_vdma_irq_handler,
> +                              IRQF_SHARED, "xilinx-vdma-controller", chan);
> +       if (err) {
> +               dev_err(xdev->dev, "unable to request IRQ\n");

It might be worth to also tell the IRQ number that failed
to register.

> +               return err;
> +       }
> +
> +       /* Initialize the DMA channel and add it to the DMA engine channels
> +        * list.
> +        */
> +       chan->common.device = &xdev->common;
> +
> +       list_add_tail(&chan->common.device_node, &xdev->common.channels);
> +       xdev->chan[chan->id] = chan;
> +
> +       /* Reset the channel */
> +       err = xilinx_vdma_chan_reset(chan);
> +       if (err < 0) {
> +               dev_err(xdev->dev, "Reset channel failed\n");
> +               return err;
> +       }
> +
> +       return 0;
> +}
> +
> +/**
> + * struct of_dma_filter_xilinx_args - Channel filter args
> + * @dev: DMA device structure
> + * @chan_id: Channel id
> + */
> +struct of_dma_filter_xilinx_args {
> +       struct dma_device *dev;
> +       u32 chan_id;
> +};
> +
> +/**
> + * xilinx_vdma_dt_filter - VDMA channel filter function
> + * @chan: DMA channel pointer
> + * @param: Filter match value
> + *
> + * Return: true/false based on the result
> + */
> +static bool xilinx_vdma_dt_filter(struct dma_chan *chan, void *param)
> +{
> +       struct of_dma_filter_xilinx_args *args = param;
> +
> +       return chan->device == args->dev && chan->chan_id == args->chan_id;
> +}
> +
> +/**
> + * of_dma_xilinx_xlate - Translation function
> + * @dma_spec: Pointer to DMA specifier as found in the device tree
> + * @ofdma: Pointer to DMA controller data
> + *
> + * Return: DMA channel pointer on success and NULL on error
> + */
> +static struct dma_chan *of_dma_xilinx_xlate(struct of_phandle_args *dma_spec,
> +                                               struct of_dma *ofdma)
> +{
> +       struct of_dma_filter_xilinx_args args;
> +       dma_cap_mask_t cap;
> +
> +       args.dev = ofdma->of_dma_data;
> +       if (!args.dev)
> +               return NULL;
> +
> +       if (dma_spec->args_count != 1)
> +               return NULL;
> +
> +       dma_cap_zero(cap);
> +       dma_cap_set(DMA_SLAVE, cap);
> +
> +       args.chan_id = dma_spec->args[0];
> +
> +       return dma_request_channel(cap, xilinx_vdma_dt_filter, &args);
> +}
> +
> +/**
> + * xilinx_vdma_probe - Driver probe function
> + * @pdev: Pointer to the platform_device structure
> + *
> + * Return: '0' on success and failure value on error
> + */
> +static int xilinx_vdma_probe(struct platform_device *pdev)
> +{
> +       struct device_node *node = pdev->dev.of_node;
> +       struct xilinx_vdma_device *xdev;
> +       struct device_node *child;
> +       struct resource *io;
> +       u32 num_frames;
> +       int i, err;
> +
> +       dev_info(&pdev->dev, "Probing xilinx axi vdma engine\n");
> +
> +       /* Allocate and initialize the DMA engine structure */
> +       xdev = devm_kzalloc(&pdev->dev, sizeof(*xdev), GFP_KERNEL);
> +       if (!xdev)
> +               return -ENOMEM;
> +
> +       xdev->dev = &pdev->dev;
> +
> +       /* Request and map I/O memory */
> +       io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       xdev->regs = devm_ioremap_resource(&pdev->dev, io);
> +       if (IS_ERR(xdev->regs))
> +               return PTR_ERR(xdev->regs);
> +
> +       /* Retrieve the DMA engine properties from the device tree */
> +       xdev->has_sg = of_property_read_bool(node, "xlnx,include-sg");
> +
> +       err = of_property_read_u32(node, "xlnx,num-fstores", &num_frames);
> +       if (err < 0) {
> +               dev_err(xdev->dev, "missing xlnx,num-fstores property\n");
> +               return err;
> +       }
> +
> +       of_property_read_u32(node, "xlnx,flush-fsync", &xdev->flush_on_fsync);

Error check?
> +
> +       /* Initialize the DMA engine */
> +       xdev->common.dev = &pdev->dev;
> +
> +       INIT_LIST_HEAD(&xdev->common.channels);
> +       dma_cap_set(DMA_SLAVE, xdev->common.cap_mask);
> +       dma_cap_set(DMA_PRIVATE, xdev->common.cap_mask);
> +
> +       xdev->common.device_alloc_chan_resources =
> +                               xilinx_vdma_alloc_chan_resources;
> +       xdev->common.device_free_chan_resources =
> +                               xilinx_vdma_free_chan_resources;
> +       xdev->common.device_prep_slave_sg = xilinx_vdma_prep_slave_sg;
> +       xdev->common.device_control = xilinx_vdma_device_control;
> +       xdev->common.device_tx_status = xilinx_vdma_tx_status;
> +       xdev->common.device_issue_pending = xilinx_vdma_issue_pending;
> +
> +       platform_set_drvdata(pdev, xdev);
> +
> +       /* Initialize the channels */
> +       for_each_child_of_node(node, child) {
> +               err = xilinx_vdma_chan_probe(xdev, child);
> +               if (err < 0)
> +                       goto error;
> +       }
> +
> +       for (i = 0; i < XILINX_VDMA_MAX_CHANS_PER_DEVICE; i++) {
> +               if (xdev->chan[i])
> +                       xdev->chan[i]->num_frms = num_frames;
> +       }
> +
> +       /* Register the DMA engine with the core */
> +       dma_async_device_register(&xdev->common);
> +
> +       err = of_dma_controller_register(node, of_dma_xilinx_xlate,
> +                                        &xdev->common);
> +       if (err < 0) {
> +               dev_err(&pdev->dev, "Unable to register DMA to DT\n");
> +               dma_async_device_unregister(&xdev->common);
> +               goto error;
> +       }
> +
> +       return 0;
> +
> +error:
> +       for (i = 0; i < XILINX_VDMA_MAX_CHANS_PER_DEVICE; i++) {
> +               if (xdev->chan[i])
> +                       xilinx_vdma_chan_remove(xdev->chan[i]);
> +       }
> +
> +       return err;
> +}
> +
> +/**
> + * xilinx_vdma_remove - Driver remove function
> + * @pdev: Pointer to the platform_device structure
> + *
> + * Return: Always '0'
> + */
> +static int xilinx_vdma_remove(struct platform_device *pdev)
> +{
> +       struct xilinx_vdma_device *xdev;
> +       int i;
> +
> +       of_dma_controller_free(pdev->dev.of_node);
> +
> +       xdev = platform_get_drvdata(pdev);
> +       dma_async_device_unregister(&xdev->common);
> +
> +       for (i = 0; i < XILINX_VDMA_MAX_CHANS_PER_DEVICE; i++) {
> +               if (xdev->chan[i])
> +                       xilinx_vdma_chan_remove(xdev->chan[i]);
> +       }
> +
> +       return 0;
> +}
> +
> +static const struct of_device_id xilinx_vdma_of_ids[] = {
> +       { .compatible = "xlnx,axi-vdma-1.00.a",},
> +       {}
> +};
> +
> +static struct platform_driver xilinx_vdma_driver = {
> +       .driver = {
> +               .name = "xilinx-vdma",
> +               .owner = THIS_MODULE,
> +               .of_match_table = xilinx_vdma_of_ids,
> +       },
> +       .probe = xilinx_vdma_probe,
> +       .remove = xilinx_vdma_remove,
> +};
> +
> +module_platform_driver(xilinx_vdma_driver);
> +
> +MODULE_AUTHOR("Xilinx, Inc.");
> +MODULE_DESCRIPTION("Xilinx VDMA driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/amba/xilinx_dma.h b/include/linux/amba/xilinx_dma.h
> new file mode 100644
> index 0000000..48a8c8b
> --- /dev/null
> +++ b/include/linux/amba/xilinx_dma.h
> @@ -0,0 +1,50 @@
> +/*
> + * Xilinx DMA Engine drivers support header file
> + *
> + * Copyright (C) 2010-2014 Xilinx, Inc. All rights reserved.
> + *
> + * This is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#ifndef __DMA_XILINX_DMA_H
> +#define __DMA_XILINX_DMA_H
> +
> +#include <linux/dma-mapping.h>
> +#include <linux/dmaengine.h>
> +
> +/**
> + * struct xilinx_vdma_config - VDMA Configuration structure
> + * @vsize: Vertical size
> + * @hsize: Horizontal size
> + * @stride: Stride
> + * @frm_dly: Frame delay
> + * @gen_lock: Whether in gen-lock mode
> + * @master: Master that it syncs to
> + * @frm_cnt_en: Enable frame count enable
> + * @park: Whether wants to park
> + * @park_frm: Frame to park on
> + * @coalesc: Interrupt coalescing threshold
> + * @delay: Delay counter
> + * @reset: Reset Channel
> + * @ext_fsync: External Frame Sync source
> + */
> +struct xilinx_vdma_config {
> +       int vsize;
> +       int hsize;
> +       int stride;
> +       int frm_dly;
> +       int gen_lock;
> +       int master;
> +       int frm_cnt_en;
> +       int park;
> +       int park_frm;
> +       int coalesc;
> +       int delay;
> +       int reset;
> +       int ext_fsync;
> +};
> +
> +#endif
> --

--
Regards,
Levente Kurusa
