Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbaBFPyD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 10:54:03 -0500
Received: from smtp-out-155.synserver.de ([212.40.185.155]:1140 "EHLO
	smtp-out-089.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751175AbaBFPx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 10:53:59 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 30990
Message-ID: <52F3B017.5030100@metafoo.de>
Date: Thu, 06 Feb 2014 16:53:59 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Srikanth Thokala <sthokal@xilinx.com>
CC: Vinod Koul <vinod.koul@intel.com>, dan.j.williams@intel.com,
        michal.simek@xilinx.com, Grant Likely <grant.likely@linaro.org>,
        robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, dmaengine@vger.kernel.org
Subject: Re: [PATCH v2] dma: Add Xilinx AXI Video Direct Memory Access Engine
 driver support
References: <1390409565-4200-1-git-send-email-sthokal@xilinx.com> <1390409565-4200-2-git-send-email-sthokal@xilinx.com> <52E0FC22.8060903@metafoo.de> <CA+mB=1L6yvCwA3mKCwz83LQbXiVau110REV64rYrSzUhGE4ucA@mail.gmail.com> <52E2698B.6070001@metafoo.de> <20140126135933.GD10628@intel.com> <52E54849.2000208@metafoo.de> <CA+mB=1JvnTcyRnuvdnW1BCeiMLSTMrrAbKwVKgwFUmWrVuXzSw@mail.gmail.com> <20140128031324.GH10628@intel.com> <CA+mB=1K8Cqe_c6_ce-fLyphvqcr90mhCjFdZ_d4BV-VkUk-gXw@mail.gmail.com> <CA+mB=1L9XFC8h_qW_-K-cv5sYondL_0NiLr=9XCFxwWRjDHn1Q@mail.gmail.com> <52F26716.3010203@metafoo.de> <CA+mB=1JX5K9Cu=9WGyr_e9tUtVz6ypT9UxhJU9BNJbQA9eaRKA@mail.gmail.com>
In-Reply-To: <CA+mB=1JX5K9Cu=9WGyr_e9tUtVz6ypT9UxhJU9BNJbQA9eaRKA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 02:34 PM, Srikanth Thokala wrote:
> On Wed, Feb 5, 2014 at 10:00 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>> On 02/05/2014 05:25 PM, Srikanth Thokala wrote:
>>>
>>> On Fri, Jan 31, 2014 at 12:21 PM, Srikanth Thokala <sthokal@xilinx.com>
>>> wrote:
>>>>
>>>> Hi Vinod,
>>>>
>>>> On Tue, Jan 28, 2014 at 8:43 AM, Vinod Koul <vinod.koul@intel.com> wrote:
>>>>>
>>>>> On Mon, Jan 27, 2014 at 06:42:36PM +0530, Srikanth Thokala wrote:
>>>>>>
>>>>>> Hi Lars/Vinod,
>>>>>>>>
>>>>>>>> The question here i think would be waht this device supports? Is the
>>>>>>>> hardware
>>>>>>>> capable of doing interleaved transfers, then would make sense.
>>>>>>>
>>>>>>>
>>>>>>> The hardware does 2D transfers. The parameters for a transfer are
>>>>>>> height,
>>>>>>> width and stride. That's only a subset of what interleaved transfers
>>>>>>> can be
>>>>>>> (xt->num_frames must be one for 2d transfers). But if I remember
>>>>>>> correctly
>>>>>>> there has been some discussion on this in the past and the result of
>>>>>>> that
>>>>>>> discussion was that using interleaved transfers for 2D transfers is
>>>>>>> preferred over adding a custom API for 2D transfers.
>>>>>>
>>>>>>
>>>>>> I went through the prep_interleaved_dma API and I see only one
>>>>>> descriptor
>>>>>> is prepared per API call (i.e. per frame).  As our IP supports upto 16
>>>>>> frame
>>>>>> buffers (can be more in future), isn't it less efficient compared to
>>>>>> the
>>>>>> prep_slave_sg where we get a single sg list and can prepare all the
>>>>>> descriptors
>>>>>> (of non-contiguous buffers) in one go?  Correct me, if am wrong and let
>>>>>> me
>>>>>> know your opinions.
>>>>>
>>>>> Well the descriptor maybe one, but that can represent multiple frames,
>>>>> for
>>>>> example 16 as in your case. Can you read up the documentation of how
>>>>> multiple
>>>>> frames are passed. Pls see include/linux/dmaengine.h
>>>>>
>>>>> /**
>>>>>    * Interleaved Transfer Request
>>>>>    * ----------------------------
>>>>>    * A chunk is collection of contiguous bytes to be transfered.
>>>>>    * The gap(in bytes) between two chunks is called inter-chunk-gap(ICG).
>>>>>    * ICGs may or maynot change between chunks.
>>>>>    * A FRAME is the smallest series of contiguous {chunk,icg} pairs,
>>>>>    *  that when repeated an integral number of times, specifies the
>>>>> transfer.
>>>>>    * A transfer template is specification of a Frame, the number of times
>>>>>    *  it is to be repeated and other per-transfer attributes.
>>>>>    *
>>>>>    * Practically, a client driver would have ready a template for each
>>>>>    *  type of transfer it is going to need during its lifetime and
>>>>>    *  set only 'src_start' and 'dst_start' before submitting the
>>>>> requests.
>>>>>    *
>>>>>    *
>>>>>    *  |      Frame-1        |       Frame-2       | ~ |
>>>>> Frame-'numf'  |
>>>>>    *  |====....==.===...=...|====....==.===...=...| ~
>>>>> |====....==.===...=...|
>>>>>    *
>>>>>    *    ==  Chunk size
>>>>>    *    ... ICG
>>>>>    */
>>>>
>>>>
>>>> Yes, it can handle multiple frames specified by 'numf' each of size
>>>> 'frame_size * sgl[0].size'.
>>>> But, I see it only works if all the frames' memory is contiguous and
>>>> in this case we
>>>> can just increment 'src_start' by the total frame size 'numf' number
>>>> of times to fill in
>>>> for each HW descriptor (each frame is one HW descriptor).  So, there
>>>> is no issue when the
>>>> memory is contiguous.  If the frames are non contiguous, we have to
>>>> call this API for each
>>>> frame (hence for each descriptor), as the src_start for each frame is
>>>> different.  Is it correct?
>>>>
>>>> FYI: This hardware has an inbuilt Scatter-Gather engine.
>>>>
>>>
>>> Ping?
>>
>>
>> If you want to submit multiple frames at once I think you should look at how
>> the current dmaengine API can be extended to allow that. And also provide an
>> explanation on how this is superior over submitting them one by one.
>
>
> Sure.  I would start with explaning the current implementation of this driver.
>
> Using prep_slave_sg(), we can define multiple segments in a
> async_tx_descriptor where each frame is defined by a segment (a sg
> list entry).  So, the slave device could DMA the data (of multiple
> frames) with a descriptor by calling tx_submit in a transaction i.e.,
>
> prep_slave_sg(16)  -> tx_submit(1) -> interrupt  (16 frames)
>
> Using interleaved_dma(), we could not divide into segments when we
> have scattered memory (for the reasons mentioned in above thread).
> This implies we are restricting the slave device to process frame by
> frame i.e.,
>
> interleaved_dma(1) -> tx_submit(1) -> interrupt -> interleaved_dma(2)
> -> tx_submit (2) -> interrupt -> ........ tx_submit(16) -> interrupt
>

The API allows you to create and submit multiple interleaved descriptors 
before you have to issue them.

interleaved_dma(1) -> tx_submit(1) -> interleaved_dma(2) -> tx_submit(2) -> 
... -> issue_pending() -> interrupt

> This implementation makes the hardware to wait until the next frame is
> submitted.
>
> To overcome this, I feel it would be a good option if we could extend
> interleaved_dma template to modify src_start/dest_start to be a
> pointer to an array of addresses.  Here, number of addresses will be
> defined by numf. The other option would be to include scatterlist in
> the interleaved template. This way we can handle scattered memory
> using this API.

Each "frame" in a interleaved transfer describes a single line in your video 
frame (size = width, icg = stride). numf is the number of lines per video 
frame. So the suggested change does not make that much sense. If you want to 
submit multiple video frames in one batch the best option is in my opinion 
to allow to pass an array of dma_interleaved_template structs instead of a 
single one.

- Lars

>
> Srikanth
>
>>
>> - Lars
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe dmaengine" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

