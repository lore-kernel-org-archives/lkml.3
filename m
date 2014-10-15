Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbaJOOfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 10:35:01 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:50428 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaJOOe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 10:34:58 -0400
MIME-Version: 1.0
In-Reply-To: <20141015124527.GA20034@leverpostej>
References: <1413374436-14410-1-git-send-email-sthokal@xilinx.com>
	<20141015124527.GA20034@leverpostej>
Date: Wed, 15 Oct 2014 20:04:56 +0530
X-Google-Sender-Auth: y4wEpeve1MRHMvbJKWLrJ-PY3bk
Message-ID: <CA+mB=1Lrf0RPnjDtp+H2HGtzHMhtY2FFQ=GzVaes4Gs9nL89cA@mail.gmail.com>
Subject: Re: [PATCH v4] dma: Add Xilinx AXI Direct Memory Access Engine driver support
From: Srikanth Thokala <sthokal@xilinx.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Srikanth Thokala <sthokal@xilinx.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "michals@xilinx.com" <michals@xilinx.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "anirudh@xilinx.com" <anirudh@xilinx.com>,
        "svemula@xilinx.com" <svemula@xilinx.com>,
        "appanad@xilinx.com" <appanad@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Thanks for reviewing patch.

I should have made a note that the binding patch is applied.  I will
make a note of this and add to next versions.

Thanks
Srikanth

On Wed, Oct 15, 2014 at 6:15 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> Hi,
>
> On Wed, Oct 15, 2014 at 01:00:36PM +0100, Srikanth Thokala wrote:
>> This is the driver for the AXI Direct Memory Access (AXI DMA)
>> core, which is a soft Xilinx IP core that provides high-
>> bandwidth direct memory access between memory and AXI4-Stream
>> type target peripherals.
>>
>> This module works on Zynq (ARM Based SoC) and Microblaze platforms.
>>
>> Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>
>> ---
>> Changes in v4:
>> - Add direction field to VDMA descriptor structure and removed from
>>   channel structure to avoid duplication.
>> - Check for DMA idle condition before changing the configuration.
>> - Residue is being calculated in complete_descriptor() and is reported
>>   to slave driver.
>>
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
>>  drivers/dma/xilinx/xilinx_dma.c | 1242 +++++++++++++++++++++++++++++++++++++++
>>  include/linux/amba/xilinx_dma.h |   17 +
>>  4 files changed, 1273 insertions(+)
>>  create mode 100644 drivers/dma/xilinx/xilinx_dma.c
>
> [...]
>
>> +static int xilinx_dma_chan_probe(struct xilinx_dma_device *xdev,
>> +                                struct device_node *node)
>> +{
>> +       struct xilinx_dma_chan *chan;
>> +       int err;
>> +       bool has_dre;
>> +       u32 value, width = 0;
>> +
>> +       /* Allocate a channel */
>> +       chan = devm_kzalloc(xdev->dev, sizeof(*chan), GFP_KERNEL);
>> +       if (!chan)
>> +               return -ENOMEM;
>> +
>> +       chan->dev = xdev->dev;
>> +       chan->xdev = xdev;
>> +       chan->has_sg = xdev->has_sg;
>> +
>> +       spin_lock_init(&chan->lock);
>> +       INIT_LIST_HEAD(&chan->pending_list);
>> +       INIT_LIST_HEAD(&chan->done_list);
>> +       INIT_LIST_HEAD(&chan->free_seg_list);
>> +
>> +       /* Get the DT properties */
>> +       has_dre = of_property_read_bool(node, "xlnx,include-dre");
>> +
>> +       err = of_property_read_u32(node, "xlnx,datawidth", &value);
>> +       if (err) {
>> +               dev_err(xdev->dev, "unable to read datawidth property");
>> +               return err;
>> +       }
>> +
>> +       width = value >> 3; /* Convert bits to bytes */
>> +
>> +       /* If data width is greater than 8 bytes, DRE is not in hw */
>> +       if (width > 8)
>> +               has_dre = false;
>> +
>> +       if (!has_dre)
>> +               xdev->common.copy_align = fls(width - 1);
>> +
>> +       if (of_device_is_compatible(node, "xlnx,axi-dma-mm2s-channel")) {
>> +               chan->id = 0;
>> +               chan->ctrl_offset = XILINX_DMA_MM2S_CTRL_OFFSET;
>> +       } else if (of_device_is_compatible(node,
>> +                                          "xlnx,axi-dma-s2mm-channel")) {
>> +               chan->id = 1;
>> +               chan->ctrl_offset = XILINX_DMA_S2MM_CTRL_OFFSET;
>> +       } else {
>> +               dev_err(xdev->dev, "Invalid channel compatible node\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       /* Find the IRQ line, if it exists in the device tree */
>> +       chan->irq = irq_of_parse_and_map(node, 0);
>> +       err = request_irq(chan->irq, xilinx_dma_irq_handler,
>> +                         IRQF_SHARED,
>> +                         "xilinx-dma-controller", chan);
>> +       if (err) {
>> +               dev_err(xdev->dev, "unable to request IRQ %d\n", chan->irq);
>> +               return err;
>> +       }
>> +
>> +       /* Initialize the tasklet */
>> +       tasklet_init(&chan->tasklet, xilinx_dma_do_tasklet,
>> +                    (unsigned long)chan);
>> +
>> +       /*
>> +        * Initialize the DMA channel and add it to the DMA engine channels
>> +        * list.
>> +        */
>> +       chan->common.device = &xdev->common;
>> +
>> +       list_add_tail(&chan->common.device_node, &xdev->common.channels);
>> +       xdev->chan[chan->id] = chan;
>> +
>> +       /* Reset the channel */
>> +       err = xilinx_dma_reset(chan);
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
>> +static struct dma_chan *of_dma_xilinx_xlate(struct of_phandle_args *dma_spec,
>> +                                           struct of_dma *ofdma)
>> +{
>> +       struct xilinx_dma_device *xdev = ofdma->of_dma_data;
>> +       int chan_id = dma_spec->args[0];
>> +
>> +       if (chan_id >= XILINX_DMA_MAX_CHANS_PER_DEVICE)
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
>> +       xdev = devm_kzalloc(&pdev->dev, sizeof(*xdev), GFP_KERNEL);
>> +       if (!xdev)
>> +               return -ENOMEM;
>> +
>> +       xdev->dev = &(pdev->dev);
>> +       INIT_LIST_HEAD(&xdev->common.channels);
>> +
>> +       node = pdev->dev.of_node;
>> +
>> +       /* Map the registers */
>> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +       xdev->regs = devm_ioremap_resource(&pdev->dev, res);
>> +       if (IS_ERR(xdev->regs))
>> +               return PTR_ERR(xdev->regs);
>> +
>> +       /* Check if SG is enabled */
>> +       xdev->has_sg = of_property_read_bool(node, "xlnx,include-sg");
>> +
>> +       /* Axi DMA only do slave transfers */
>> +       dma_cap_set(DMA_SLAVE, xdev->common.cap_mask);
>> +       dma_cap_set(DMA_PRIVATE, xdev->common.cap_mask);
>> +       xdev->common.device_prep_slave_sg = xilinx_dma_prep_slave_sg;
>> +       xdev->common.device_control = xilinx_dma_device_control;
>> +       xdev->common.device_issue_pending = xilinx_dma_issue_pending;
>> +       xdev->common.device_alloc_chan_resources =
>> +               xilinx_dma_alloc_chan_resources;
>> +       xdev->common.device_free_chan_resources =
>> +               xilinx_dma_free_chan_resources;
>> +       xdev->common.device_tx_status = xilinx_dma_tx_status;
>> +       xdev->common.device_slave_caps = xilinx_dma_device_slave_caps;
>> +       xdev->common.dev = &pdev->dev;
>> +
>> +       platform_set_drvdata(pdev, xdev);
>> +
>> +       for_each_child_of_node(node, child) {
>> +               ret = xilinx_dma_chan_probe(xdev, child);
>> +               if (ret) {
>> +                       dev_err(&pdev->dev, "Probing channels failed\n");
>> +                       goto free_chan_resources;
>> +               }
>> +       }
>> +
>> +       dma_async_device_register(&xdev->common);
>> +
>> +       ret = of_dma_controller_register(node, of_dma_xilinx_xlate, xdev);
>> +       if (ret) {
>> +               dev_err(&pdev->dev, "Unable to register DMA to DT\n");
>> +               dma_async_device_unregister(&xdev->common);
>> +               goto free_chan_resources;
>> +       }
>> +
>> +       dev_info(&pdev->dev, "Xilinx AXI DMA Engine driver Probed!!\n");
>> +
>> +       return 0;
>> +
>> +free_chan_resources:
>> +       for (i = 0; i < XILINX_DMA_MAX_CHANS_PER_DEVICE; i++)
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
>> +       struct xilinx_dma_device *xdev = platform_get_drvdata(pdev);
>> +       int i;
>> +
>> +       of_dma_controller_free(pdev->dev.of_node);
>> +       dma_async_device_unregister(&xdev->common);
>> +
>> +       for (i = 0; i < XILINX_DMA_MAX_CHANS_PER_DEVICE; i++)
>> +               if (xdev->chan[i])
>> +                       xilinx_dma_chan_remove(xdev->chan[i]);
>> +
>> +       return 0;
>> +}
>> +
>> +static const struct of_device_id xilinx_dma_of_match[] = {
>> +       { .compatible = "xlnx,axi-dma-1.00.a",},
>> +       {}
>> +};
>> +MODULE_DEVICE_TABLE(of, xilinx_dma_of_match);
>
> This patch has come without the necessary device tree binding document,
> and I was not able to find an existing binding document upstream (I
> searched for "xlnx,axi-dma-1.00.a" and "axi-dma").
>
> The driver expects a non-trivial set of properties, so a binding
> document is essential for users. Additionally, checkpatch.pl should
> scream regarding the undocumented comaptible string.
>
> Please put together a binding document.
>
> Thanks,
> Mark.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
