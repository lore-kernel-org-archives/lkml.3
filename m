Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbaAWRfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:35:38 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:62154 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbaAWRfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:35:36 -0500
MIME-Version: 1.0
In-Reply-To: <CAAsK9AFGM+852N-F98p32JSHEpg5ZKv-0wyzFGx9675GBp7gQg@mail.gmail.com>
References: <1390409565-4200-1-git-send-email-sthokal@xilinx.com>
	<1390409565-4200-2-git-send-email-sthokal@xilinx.com>
	<CAAsK9AFGM+852N-F98p32JSHEpg5ZKv-0wyzFGx9675GBp7gQg@mail.gmail.com>
Date: Thu, 23 Jan 2014 23:05:34 +0530
X-Google-Sender-Auth: 4gsW5MOVK_Zs5sqMgqSUdVH9cCc
Message-ID: <CA+mB=1+jHxyx47jnbJuuNOFAK3sfresnyZfQ80zxoJn0kse57A@mail.gmail.com>
Subject: Re: [PATCH v2] dma: Add Xilinx AXI Video Direct Memory Access Engine
 driver support
From: Srikanth Thokala <sthokal@xilinx.com>
To: Levente Kurusa <levex@linux.com>
Cc: Srikanth Thokala <sthokal@xilinx.com>, dan.j.williams@intel.com,
        vinod.koul@intel.com, michal.simek@xilinx.com,
        Grant Likely <grant.likely@linaro.org>, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, dmaengine@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Levente,

On Thu, Jan 23, 2014 at 3:00 AM, Levente Kurusa <levex@linux.com> wrote:
> Hello,
>
> 2014/1/22 Srikanth Thokala <sthokal@xilinx.com>:
>> This is the driver for the AXI Video Direct Memory Access (AXI
>> VDMA) core, which is a soft Xilinx IP core that provides high-
>> bandwidth direct memory access between memory and AXI4-Stream
>> type video target peripherals. The core provides efficient two
>> dimensional DMA operations with independent asynchronous read
>> and write channel operation.
>>
>> This module works on Zynq (ARM Based SoC) and Microblaze platforms.
>>
>> Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>
>> ---
>
> Another two remarks, after you fixed them ( or not :-) )
> you can have my:
>
> Reviewed-by: Levente Kurusa <levex@linux.com>
>
> Oh, and next time please if you post a patch that fixes something I pointed out,
> CC me as I had a hard time finding this patch, thanks. :-)

Sure. Thanks

>
>> NOTE:
>> 1. Created a separate directory 'dma/xilinx' as Xilinx has two more
>>    DMA IPs and we are also planning to upstream these drivers soon.
>> 2. Rebased on v3.13.0-rc8
>>
>> Changes in v2:
>> - Removed DMA Test client module from the patchset as suggested
>>   by Andy Shevchenko
>> - Removed device-id DT property, as suggested by Arnd Bergmann
>> - Properly documented DT bindings as suggested by Arnd Bergmann
>> - Returning with error, if registration of DMA to node fails
>> - Fixed typo errors
>> - Used BIT() macro at applicable places
>> - Added missing header file to the patchset
>> - Changed copyright year to include 2014
>> ---
>>  .../devicetree/bindings/dma/xilinx/xilinx_vdma.txt |   75 +
>>  drivers/dma/Kconfig                                |   14 +
>>  drivers/dma/Makefile                               |    1 +
>>  drivers/dma/xilinx/Makefile                        |    1 +
>>  drivers/dma/xilinx/xilinx_vdma.c                   | 1486 ++++++++++++++++++++
>>  include/linux/amba/xilinx_dma.h                    |   50 +
>>  6 files changed, 1627 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
>>  create mode 100644 drivers/dma/xilinx/Makefile
>>  create mode 100644 drivers/dma/xilinx/xilinx_vdma.c
>>  create mode 100644 include/linux/amba/xilinx_dma.h
>>
>> diff --git a/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt b/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
>> new file mode 100644
>> index 0000000..ab8be1a
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/dma/xilinx/xilinx_vdma.txt
>> @@ -0,0 +1,75 @@
>> +Xilinx AXI VDMA engine, it does transfers between memory and video devices.
>> +It can be configured to have one channel or two channels. If configured
>> +as two channels, one is to transmit to the video device and another is
>> +to receive from the video device.
>> +
>> +Required properties:
>> +- compatible: Should be "xlnx,axi-vdma-1.00.a"
>> +- #dma-cells: Should be <1>, see "dmas" property below
>> +- reg: Should contain VDMA registers location and length.
>> +- xlnx,num-fstores: Should be the number of framebuffers as configured in h/w.
>> +- dma-channel child node: Should have atleast one channel and can have upto
>> +       two channels per device. This node specifies the properties of each
>> +       DMA channel (see child node properties below).
>> +
>> +Optional properties:
>> +- xlnx,include-sg: Tells whether configured for Scatter-mode in
>> +       the hardware.
>> [...]
>> +
>> +/**
>> + * xilinx_vdma_is_running - Check if VDMA channel is running
>> + * @chan: Driver specific VDMA channel
>> + *
>> + * Return: '1' if running, '0' if not.
>> + */
>> +static int xilinx_vdma_is_running(struct xilinx_vdma_chan *chan)
>> +{
>> +       return !(vdma_ctrl_read(chan, XILINX_VDMA_REG_DMASR) &
>> +                XILINX_VDMA_DMASR_HALTED) &&
>> +               (vdma_ctrl_read(chan, XILINX_VDMA_REG_DMACR) &
>> +                XILINX_VDMA_DMACR_RUNSTOP);
>> +}
>> +

[...]

>> +       /* Retrieve the channel properties from the device tree */
>> +       has_dre = of_property_read_bool(node, "xlnx,include-dre");
>> +
>> +       chan->genlock = of_property_read_bool(node, "xlnx,genlock-mode");
>> +
>> +       err = of_property_read_u32(node, "xlnx,datawidth", &value);
>> +       if (!err) {
>> +               u32 width = value >> 3; /* Convert bits to bytes */
>> +
>> +               /* If data width is greater than 8 bytes, DRE is not in hw */
>> +               if (width > 8)
>> +                       has_dre = false;
>> +
>> +               if (!has_dre)
>> +                       xdev->common.copy_align = fls(width - 1);
>> +       } else {
>> +               dev_err(xdev->dev, "missing xlnx,datawidth property\n");
>> +               return err;
>> +       }
>
> Can you please convert this to:
> if (err) {
>  dev_err(...);
>  return err;
> }
>
> That way we can avoid the else clause.

Ok. I will fix it in v3.

>> +
>> +       if (of_device_is_compatible(node, "xlnx,axi-vdma-mm2s-channel")) {
>> +               chan->direction = DMA_MEM_TO_DEV;
>> +               chan->id = 0;
>> +
>> +               chan->ctrl_offset = XILINX_VDMA_MM2S_CTRL_OFFSET;
>> +               chan->desc_offset = XILINX_VDMA_MM2S_DESC_OFFSET;
>> +
>> +               if (xdev->flush_on_fsync == XILINX_VDMA_FLUSH_BOTH ||
>> +                   xdev->flush_on_fsync == XILINX_VDMA_FLUSH_MM2S)
>> +                       chan->flush_on_fsync = true;
>> +       } else if (of_device_is_compatible(node,
>> +                                           "xlnx,axi-vdma-s2mm-channel")) {
>> +               chan->direction = DMA_DEV_TO_MEM;
>> +               chan->id = 1;
>> +
>> +               chan->ctrl_offset = XILINX_VDMA_S2MM_CTRL_OFFSET;
>> +               chan->desc_offset = XILINX_VDMA_S2MM_DESC_OFFSET;
>> +
>> +               if (xdev->flush_on_fsync == XILINX_VDMA_FLUSH_BOTH ||
>> +                   xdev->flush_on_fsync == XILINX_VDMA_FLUSH_S2MM)
>> +                       chan->flush_on_fsync = true;
>> +       } else {
>> +               dev_err(xdev->dev, "Invalid channel compatible node\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       /* Request the interrupt */
>> +       chan->irq = irq_of_parse_and_map(node, 0);
>> +       err = devm_request_irq(xdev->dev, chan->irq, xilinx_vdma_irq_handler,
>> +                              IRQF_SHARED, "xilinx-vdma-controller", chan);
>> +       if (err) {
>> +               dev_err(xdev->dev, "unable to request IRQ\n");
>
> It might be worth to also tell the IRQ number that failed
> to register.

Ok.

>
>> +               return err;
>> +       }
>> +
>> +       /* Initialize the DMA channel and add it to the DMA engine channels
>> +        * list.
>> +        */
>> +       chan->common.device = &xdev->common;
>> +
>> +       list_add_tail(&chan->common.device_node, &xdev->common.channels);

[...]

>> +       err = of_property_read_u32(node, "xlnx,num-fstores", &num_frames);
>> +       if (err < 0) {
>> +               dev_err(xdev->dev, "missing xlnx,num-fstores property\n");
>> +               return err;
>> +       }
>> +
>> +       of_property_read_u32(node, "xlnx,flush-fsync", &xdev->flush_on_fsync);
>
> Error check?

Sure, with a warning message as it is optional DT property.  I will
fix it in v3.

Srikanth

[...]
>> --
>
> --
> Regards,
> Levente Kurusa
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
