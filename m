Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbaA0LG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 06:06:59 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:33526 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaA0LG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 06:06:56 -0500
MIME-Version: 1.0
In-Reply-To: <20140126135933.GD10628@intel.com>
References: <1390409565-4200-1-git-send-email-sthokal@xilinx.com>
	<1390409565-4200-2-git-send-email-sthokal@xilinx.com>
	<52E0FC22.8060903@metafoo.de>
	<CA+mB=1L6yvCwA3mKCwz83LQbXiVau110REV64rYrSzUhGE4ucA@mail.gmail.com>
	<52E2698B.6070001@metafoo.de>
	<20140126135933.GD10628@intel.com>
Date: Mon, 27 Jan 2014 16:36:54 +0530
X-Google-Sender-Auth: -LfJF9M1QiSghwHXLlrH_8oWFhE
Message-ID: <CA+mB=1Jwjn+KSO9yFr=LNVjk3khf0b-LLQamYf+nnSF4bODGPA@mail.gmail.com>
Subject: Re: [PATCH v2] dma: Add Xilinx AXI Video Direct Memory Access Engine
 driver support
From: Srikanth Thokala <sthokal@xilinx.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Srikanth Thokala <sthokal@xilinx.com>, dan.j.williams@intel.com,
        michal.simek@xilinx.com, Grant Likely <grant.likely@linaro.org>,
        robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, dmaengine@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On Sun, Jan 26, 2014 at 7:29 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Fri, Jan 24, 2014 at 02:24:27PM +0100, Lars-Peter Clausen wrote:
>> On 01/24/2014 12:16 PM, Srikanth Thokala wrote:
>> > Hi Lars,
>> >
>> > On Thu, Jan 23, 2014 at 4:55 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>> >> On 01/22/2014 05:52 PM, Srikanth Thokala wrote:
>> >> [...]
>> >>> +/**
>> >>> + * xilinx_vdma_device_control - Configure DMA channel of the device
>> >>> + * @dchan: DMA Channel pointer
>> >>> + * @cmd: DMA control command
>> >>> + * @arg: Channel configuration
>> >>> + *
>> >>> + * Return: '0' on success and failure value on error
>> >>> + */
>> >>> +static int xilinx_vdma_device_control(struct dma_chan *dchan,
>> >>> +                                   enum dma_ctrl_cmd cmd, unsigned long arg)
>> >>> +{
>> >>> +     struct xilinx_vdma_chan *chan = to_xilinx_chan(dchan);
>> >>> +
>> >>> +     switch (cmd) {
>> >>> +     case DMA_TERMINATE_ALL:
>> >>> +             xilinx_vdma_terminate_all(chan);
>> >>> +             return 0;
>> >>> +     case DMA_SLAVE_CONFIG:
>> >>> +             return xilinx_vdma_slave_config(chan,
>> >>> +                                     (struct xilinx_vdma_config *)arg);
>> >>
>> >> You really shouldn't be overloading the generic API with your own semantics.
>> >> DMA_SLAVE_CONFIG should take a dma_slave_config and nothing else.
>> >
>> > Ok.  The driver needs few additional configuration from the slave
>> > device like Vertical
>> > Size, Horizontal Size,  Stride etc., for the DMA transfers, in that case do you
>> > suggest me to define a separate dma_ctrl_cmd like the one FSLDMA_EXTERNAL_START
>> > defined for Freescale drivers?
>>
>> In my opinion it is not a good idea to have driver implement a generic API,
>> but at the same time let the driver have custom semantics for those API
>> calls. It's a bit like having a gpio driver that expects 23 and 42 as the
>> values passed to gpio_set_value instead of 0 and 1. It completely defeats
>> the purpose of a generic API, namely that you are able to write generic code
>> that makes use of the API without having to know about which implementation
>> API it is talking to. The dmaengine framework provides the
>> dmaengine_prep_interleaved_dma() function to setup two dimensional
>> transfers, e.g. take a look at sirf-dma.c or imx-dma.c.
>
> The question here i think would be waht this device supports? Is the hardware
> capable of doing interleaved transfers, then would make sense.
>
> While we do try to get users use dma_slave_config, but there will always be
> someone who have specfic params. If we can generalize then we might want to add
> to the dma_slave_config as well

There are many configuration parameters which are specific to IP and I
would like to
give an overview of some of parameteres here:

1) Park Mode ('cfg->park'): In Park mode, engine will park on frame
referenced by
    'cfg->park_frm', so user will have control on each frame in this mode.

2) Interrupt Coalesce ('cfg->coalesce'):  Used for setting interrupt
threshold. This value
   determines the number of frame buffers to process. To use this feature,
   'cfg->frm_cnt_en' should be set.

3) Frame Synchronization Source ('cfg->ext_fsync'):  Can be an
external/internal frame
    synchronization source. Used to synchronize one channel (MM2S/S2MM) with
    another (S2MM/MM2S) channel.

4) Genlock Synchronization ('cfg->genlock'): Used to avoid mismatch rate between
    master and slave.  In master mode (cfg->master), frames are not dropped and
    slave can drop frames to adjust to master frame rate.

And in future, this Engine being a soft IP, we could expect some more additional
parameters.  Isn't a good idea to have a private member in dma_slave_config for
sharing additional configuration between slave device and dma engine? Or a new
dma_ctrl_cmd like FSLDMA_EXTERNAL_START?

Srikanth

>
> --
> ~Vinod
> --/EX
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
