Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaBTJxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 04:53:11 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:56474 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaBTJxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 04:53:05 -0500
MIME-Version: 1.0
In-Reply-To: <CA+mB=1LK+aVbvh741+PMnpj_mwZRvJZzR5Fh=hf72UWQvxUiVQ@mail.gmail.com>
References: <1392465619-27614-1-git-send-email-sthokal@xilinx.com>
	<1392465619-27614-2-git-send-email-sthokal@xilinx.com>
	<CAJe_Zhc_GNNSDWNFuk+cMHEqxfSCJB_ey=Bf+SwJK-nS=u9ceg@mail.gmail.com>
	<CA+mB=1KdZZpTmpA0Xp_c4mhgFbjRZ6urYrCwdvoTCmcugQMDUA@mail.gmail.com>
	<CAJe_ZhdOmu3k9gbPdQzPteyzwsMA8OzWHdhHnXudbF=X7JMhVQ@mail.gmail.com>
	<CA+mB=1K43MDZj0Rx3q=ETQMaFsG1j7TXsH6v-7a26JdtqTJkbw@mail.gmail.com>
	<CAJe_ZhfedP7Paf3Zq9chL0WUeLJrsy_DJL05sSbfqnfTtji=HQ@mail.gmail.com>
	<CA+mB=1LK+aVbvh741+PMnpj_mwZRvJZzR5Fh=hf72UWQvxUiVQ@mail.gmail.com>
Date: Thu, 20 Feb 2014 15:23:03 +0530
Message-ID: <CAJe_ZheGP-9f659tOdCHEMrbh73MDi7VjoieFhdQbvjVwiEbJQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] dma: Support multiple interleaved frames with
 non-contiguous memory
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Srikanth Thokala <sthokal@xilinx.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Levente Kurusa <levex@linux.com>, Lars-Peter Clausen <lars@metafoo.de>,
        lkml <linux-kernel@vger.kernel.org>, dmaengine@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 February 2014 14:54, Srikanth Thokala <sthokal@xilinx.com> wrote:
> On Wed, Feb 19, 2014 at 12:33 AM, Jassi Brar <jaswinder.singh@linaro.org> wrote:
>> On 18 February 2014 23:16, Srikanth Thokala <sthokal@xilinx.com> wrote:
>>> On Tue, Feb 18, 2014 at 10:20 PM, Jassi Brar <jaswinder.singh@linaro.org> wrote:
>>>> On 18 February 2014 16:58, Srikanth Thokala <sthokal@xilinx.com> wrote:
>>>>> On Mon, Feb 17, 2014 at 3:27 PM, Jassi Brar <jaswinder.singh@linaro.org> wrote:
>>>>>> On 15 February 2014 17:30, Srikanth Thokala <sthokal@xilinx.com> wrote:
>>>>>>> The current implementation of interleaved DMA API support multiple
>>>>>>> frames only when the memory is contiguous by incrementing src_start/
>>>>>>> dst_start members of interleaved template.
>>>>>>>
>>>>>>> But, when the memory is non-contiguous it will restrict slave device
>>>>>>> to not submit multiple frames in a batch.  This patch handles this
>>>>>>> issue by allowing the slave device to send array of interleaved dma
>>>>>>> templates each having a different memory location.
>>>>>>>
>>>>>> How fragmented could be memory in your case? Is it inefficient to
>>>>>> submit separate transfers for each segment/frame?
>>>>>> It will help if you could give a typical example (chunk size and gap
>>>>>> in bytes) of what you worry about.
>>>>>
>>>>> With scatter-gather engine feature in the hardware, submitting separate
>>>>> transfers for each frame look inefficient. As an example, our DMA engine
>>>>> supports up to 16 video frames, with each frame (a typical video frame
>>>>> size) being contiguous in memory but frames are scattered into different
>>>>> locations. We could not definitely submit frame by frame as it would be
>>>>> software overhead (HW interrupting for each frame) resulting in video lags.
>>>>>
>>>> IIUIC, it is 30fps and one dma interrupt per frame ... it doesn't seem
>>>> inefficient at all. Even poor-latency audio would generate a higher
>>>> interrupt-rate. So the "inefficiency concern" doesn't seem valid to
>>>> me.
>>>>
>>>> Not to mean we shouldn't strive to reduce the interrupt-rate further.
>>>> Another option is to emulate the ring-buffer scheme of ALSA.... which
>>>> should be possible since for a session of video playback the frame
>>>> buffers' locations wouldn't change.
>>>>
>>>> Yet another option is to use the full potential of the
>>>> interleaved-xfer api as such. It seems you confuse a 'video frame'
>>>> with the interleaved-xfer api's 'frame'. They are different.
>>>>
>>>> Assuming your one video frame is F bytes long and Gk is the gap in
>>>> bytes between end of frame [k] and start of frame [k+1] and  Gi != Gj
>>>> for i!=j
>>>> In the context of interleaved-xfer api, you have just 1 Frame of 16
>>>> chunks. Each chunk is Fbytes and the inter-chunk-gap(ICG) is Gk  where
>>>> 0<=k<15
>>>> So for your use-case .....
>>>>   dma_interleaved_template.numf = 1   /* just 1 frame */
>>>>   dma_interleaved_template.frame_size = 16  /* containing 16 chunks */
>>>>    ...... //other parameters
>>>>
>>>> You have 3 options to choose from and all should work just as fine.
>>>> Otherwise please state your problem in real numbers (video-frames'
>>>> size, count & gap in bytes).
>>>
>>> Initially I interpreted interleaved template the same.  But, Lars corrected me
>>> in the subsequent discussion and let me put it here briefly,
>>>
>>> In the interleaved template, each frame represents a line of size denoted by
>>> chunk.size and the stride by icg.  'numf' represent number of frames i.e.
>>> number of lines.
>>>
>>> In video frame context,
>>> chunk.size -> hsize
>>> chunk.icg -> stride
>>> numf -> vsize
>>> and frame_size is always 1 as it will have only one chunk in a line.
>>>
>> But you said in your last post
>>   "with each frame (a typical video frame size) being contiguous in memory"
>>  ... which is not true from what you write above. Anyways, my first 2
>> suggestions still hold.
>
> Yes, each video frame is contiguous and they can be scattered.
>
I assume by contiguous frame you mean as in framebuffer?  Which is an
array of bytes.
If yes, then you should do as I suggest first,  frame_size=16  and numf=1.

If no, then it seems you are already doing the right thing.... the
ring-buffer scheme. Please share some stats how the current api is
causing you overhead because that is a very common case (many
controllers support LLI) and you have 467ms (@30fps with 16-frames
ring-buffer) to queue in before you see any frame drop.

Regards,
Jassi
