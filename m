Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaAXNYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 08:24:40 -0500
Received: from smtp-out-210.synserver.de ([212.40.185.210]:1050 "EHLO
	smtp-out-209.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752209AbaAXNYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 08:24:38 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 29342
Message-ID: <52E2698B.6070001@metafoo.de>
Date: Fri, 24 Jan 2014 14:24:27 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Srikanth Thokala <sthokal@xilinx.com>
CC: dan.j.williams@intel.com, vinod.koul@intel.com, michal.simek@xilinx.com,
        Grant Likely <grant.likely@linaro.org>, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, dmaengine@vger.kernel.org
Subject: Re: [PATCH v2] dma: Add Xilinx AXI Video Direct Memory Access Engine
 driver support
References: <1390409565-4200-1-git-send-email-sthokal@xilinx.com> <1390409565-4200-2-git-send-email-sthokal@xilinx.com> <52E0FC22.8060903@metafoo.de> <CA+mB=1L6yvCwA3mKCwz83LQbXiVau110REV64rYrSzUhGE4ucA@mail.gmail.com>
In-Reply-To: <CA+mB=1L6yvCwA3mKCwz83LQbXiVau110REV64rYrSzUhGE4ucA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2014 12:16 PM, Srikanth Thokala wrote:
> Hi Lars,
> 
> On Thu, Jan 23, 2014 at 4:55 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>> On 01/22/2014 05:52 PM, Srikanth Thokala wrote:
>> [...]
>>> +/**
>>> + * xilinx_vdma_device_control - Configure DMA channel of the device
>>> + * @dchan: DMA Channel pointer
>>> + * @cmd: DMA control command
>>> + * @arg: Channel configuration
>>> + *
>>> + * Return: '0' on success and failure value on error
>>> + */
>>> +static int xilinx_vdma_device_control(struct dma_chan *dchan,
>>> +                                   enum dma_ctrl_cmd cmd, unsigned long arg)
>>> +{
>>> +     struct xilinx_vdma_chan *chan = to_xilinx_chan(dchan);
>>> +
>>> +     switch (cmd) {
>>> +     case DMA_TERMINATE_ALL:
>>> +             xilinx_vdma_terminate_all(chan);
>>> +             return 0;
>>> +     case DMA_SLAVE_CONFIG:
>>> +             return xilinx_vdma_slave_config(chan,
>>> +                                     (struct xilinx_vdma_config *)arg);
>>
>> You really shouldn't be overloading the generic API with your own semantics.
>> DMA_SLAVE_CONFIG should take a dma_slave_config and nothing else.
> 
> Ok.  The driver needs few additional configuration from the slave
> device like Vertical
> Size, Horizontal Size,  Stride etc., for the DMA transfers, in that case do you
> suggest me to define a separate dma_ctrl_cmd like the one FSLDMA_EXTERNAL_START
> defined for Freescale drivers?

In my opinion it is not a good idea to have driver implement a generic API,
but at the same time let the driver have custom semantics for those API
calls. It's a bit like having a gpio driver that expects 23 and 42 as the
values passed to gpio_set_value instead of 0 and 1. It completely defeats
the purpose of a generic API, namely that you are able to write generic code
that makes use of the API without having to know about which implementation
API it is talking to. The dmaengine framework provides the
dmaengine_prep_interleaved_dma() function to setup two dimensional
transfers, e.g. take a look at sirf-dma.c or imx-dma.c.

- Lars

