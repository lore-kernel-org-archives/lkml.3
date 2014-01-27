Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbaA0NMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 08:12:40 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:47085 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbaA0NMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 08:12:38 -0500
MIME-Version: 1.0
In-Reply-To: <52E54849.2000208@metafoo.de>
References: <1390409565-4200-1-git-send-email-sthokal@xilinx.com>
	<1390409565-4200-2-git-send-email-sthokal@xilinx.com>
	<52E0FC22.8060903@metafoo.de>
	<CA+mB=1L6yvCwA3mKCwz83LQbXiVau110REV64rYrSzUhGE4ucA@mail.gmail.com>
	<52E2698B.6070001@metafoo.de>
	<20140126135933.GD10628@intel.com>
	<52E54849.2000208@metafoo.de>
Date: Mon, 27 Jan 2014 18:42:36 +0530
X-Google-Sender-Auth: lNHlOM1wvQU8m0kcgso4nYQZwY8
Message-ID: <CA+mB=1JvnTcyRnuvdnW1BCeiMLSTMrrAbKwVKgwFUmWrVuXzSw@mail.gmail.com>
Subject: Re: [PATCH v2] dma: Add Xilinx AXI Video Direct Memory Access Engine
 driver support
From: Srikanth Thokala <sthokal@xilinx.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Vinod Koul <vinod.koul@intel.com>, Srikanth Thokala <sthokal@xilinx.com>,
        dan.j.williams@intel.com, michal.simek@xilinx.com,
        Grant Likely <grant.likely@linaro.org>, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, dmaengine@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars/Vinod,

On Sun, Jan 26, 2014 at 11:09 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 01/26/2014 02:59 PM, Vinod Koul wrote:
>> On Fri, Jan 24, 2014 at 02:24:27PM +0100, Lars-Peter Clausen wrote:
>>> On 01/24/2014 12:16 PM, Srikanth Thokala wrote:
>>>> Hi Lars,
>>>>
>>>> On Thu, Jan 23, 2014 at 4:55 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>>>>> On 01/22/2014 05:52 PM, Srikanth Thokala wrote:
>>>>> [...]
>>>>>> +/**
>>>>>> + * xilinx_vdma_device_control - Configure DMA channel of the device
>>>>>> + * @dchan: DMA Channel pointer
>>>>>> + * @cmd: DMA control command
>>>>>> + * @arg: Channel configuration
>>>>>> + *
>>>>>> + * Return: '0' on success and failure value on error
>>>>>> + */
>>>>>> +static int xilinx_vdma_device_control(struct dma_chan *dchan,
>>>>>> +                                   enum dma_ctrl_cmd cmd, unsigned long arg)
>>>>>> +{
>>>>>> +     struct xilinx_vdma_chan *chan = to_xilinx_chan(dchan);
>>>>>> +
>>>>>> +     switch (cmd) {
>>>>>> +     case DMA_TERMINATE_ALL:
>>>>>> +             xilinx_vdma_terminate_all(chan);
>>>>>> +             return 0;
>>>>>> +     case DMA_SLAVE_CONFIG:
>>>>>> +             return xilinx_vdma_slave_config(chan,
>>>>>> +                                     (struct xilinx_vdma_config *)arg);
>>>>>
>>>>> You really shouldn't be overloading the generic API with your own semantics.
>>>>> DMA_SLAVE_CONFIG should take a dma_slave_config and nothing else.
>>>>
>>>> Ok.  The driver needs few additional configuration from the slave
>>>> device like Vertical
>>>> Size, Horizontal Size,  Stride etc., for the DMA transfers, in that case do you
>>>> suggest me to define a separate dma_ctrl_cmd like the one FSLDMA_EXTERNAL_START
>>>> defined for Freescale drivers?
>>>
>>> In my opinion it is not a good idea to have driver implement a generic API,
>>> but at the same time let the driver have custom semantics for those API
>>> calls. It's a bit like having a gpio driver that expects 23 and 42 as the
>>> values passed to gpio_set_value instead of 0 and 1. It completely defeats
>>> the purpose of a generic API, namely that you are able to write generic code
>>> that makes use of the API without having to know about which implementation
>>> API it is talking to. The dmaengine framework provides the
>>> dmaengine_prep_interleaved_dma() function to setup two dimensional
>>> transfers, e.g. take a look at sirf-dma.c or imx-dma.c.
>>
>> The question here i think would be waht this device supports? Is the hardware
>> capable of doing interleaved transfers, then would make sense.
>
> The hardware does 2D transfers. The parameters for a transfer are height,
> width and stride. That's only a subset of what interleaved transfers can be
> (xt->num_frames must be one for 2d transfers). But if I remember correctly
> there has been some discussion on this in the past and the result of that
> discussion was that using interleaved transfers for 2D transfers is
> preferred over adding a custom API for 2D transfers.

I went through the prep_interleaved_dma API and I see only one descriptor
is prepared per API call (i.e. per frame).  As our IP supports upto 16 frame
buffers (can be more in future), isn't it less efficient compared to the
prep_slave_sg where we get a single sg list and can prepare all the descriptors
(of non-contiguous buffers) in one go?  Correct me, if am wrong and let me
know your opinions.

Srikanth

>
> - Lars
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
