Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaBZOVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 09:21:25 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60428 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaBZOVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 09:21:22 -0500
MIME-Version: 1.0
In-Reply-To: <CAJe_ZhfSknzwMUo3nu14Hz5sr_hA6KojB=u4BvyT3byh5ViwXA@mail.gmail.com>
References: <1392465619-27614-1-git-send-email-sthokal@xilinx.com>
	<1392465619-27614-2-git-send-email-sthokal@xilinx.com>
	<CAJe_Zhc_GNNSDWNFuk+cMHEqxfSCJB_ey=Bf+SwJK-nS=u9ceg@mail.gmail.com>
	<CA+mB=1KdZZpTmpA0Xp_c4mhgFbjRZ6urYrCwdvoTCmcugQMDUA@mail.gmail.com>
	<CAJe_ZhdOmu3k9gbPdQzPteyzwsMA8OzWHdhHnXudbF=X7JMhVQ@mail.gmail.com>
	<CA+mB=1K43MDZj0Rx3q=ETQMaFsG1j7TXsH6v-7a26JdtqTJkbw@mail.gmail.com>
	<CAJe_ZhfedP7Paf3Zq9chL0WUeLJrsy_DJL05sSbfqnfTtji=HQ@mail.gmail.com>
	<CA+mB=1LK+aVbvh741+PMnpj_mwZRvJZzR5Fh=hf72UWQvxUiVQ@mail.gmail.com>
	<CAJe_ZheGP-9f659tOdCHEMrbh73MDi7VjoieFhdQbvjVwiEbJQ@mail.gmail.com>
	<CA+mB=1KqP=KgNZ_hYGbhin5TqokA+nCRPAA4Qa2R_2OWwv4yVw@mail.gmail.com>
	<CAJe_ZhfSknzwMUo3nu14Hz5sr_hA6KojB=u4BvyT3byh5ViwXA@mail.gmail.com>
Date: Wed, 26 Feb 2014 19:51:20 +0530
X-Google-Sender-Auth: X69PNBEUpog0vfwwdz8ucGrH2-Q
Message-ID: <CA+mB=1KHuZb14zrb8K9Hs4qQMmYdWEuHpAnwE0FMYOQYv=g5-w@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] dma: Support multiple interleaved frames with
 non-contiguous memory
From: Srikanth Thokala <sthokal@xilinx.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Srikanth Thokala <sthokal@xilinx.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
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

On Mon, Feb 24, 2014 at 7:39 AM, Jassi Brar <jaswinder.singh@linaro.org> wrote:
> On 21 February 2014 23:37, Srikanth Thokala <sthokal@xilinx.com> wrote:
>> On Thu, Feb 20, 2014 at 3:23 PM, Jassi Brar <jaswinder.singh@linaro.org>
>> wrote:
>>> On 20 February 2014 14:54, Srikanth Thokala <sthokal@xilinx.com> wrote:
>>>> On Wed, Feb 19, 2014 at 12:33 AM, Jassi Brar <jaswinder.singh@linaro.org>
>>>> wrote:
>>>>> On 18 February 2014 23:16, Srikanth Thokala <sthokal@xilinx.com> wrote:
>>>>>> On Tue, Feb 18, 2014 at 10:20 PM, Jassi Brar
>>>>>> <jaswinder.singh@linaro.org> wrote:
>>>>>>> On 18 February 2014 16:58, Srikanth Thokala <sthokal@xilinx.com>
>>>>>>> wrote:
>>>>>>>> On Mon, Feb 17, 2014 at 3:27 PM, Jassi Brar
>>>>>>>> <jaswinder.singh@linaro.org> wrote:
>>>>>>>>> On 15 February 2014 17:30, Srikanth Thokala <sthokal@xilinx.com>
>>>>>>>>> wrote:
>>>>>>>>>> The current implementation of interleaved DMA API support multiple
>>>>>>>>>> frames only when the memory is contiguous by incrementing
>>>>>>>>>> src_start/
>>>>>>>>>> dst_start members of interleaved template.
>>>>>>>>>>
>>>>>>>>>> But, when the memory is non-contiguous it will restrict slave
>>>>>>>>>> device
>>>>>>>>>> to not submit multiple frames in a batch.  This patch handles this
>>>>>>>>>> issue by allowing the slave device to send array of interleaved dma
>>>>>>>>>> templates each having a different memory location.
>>>>>>>>>>
>>>>>>>>> How fragmented could be memory in your case? Is it inefficient to
>>>>>>>>> submit separate transfers for each segment/frame?
>>>>>>>>> It will help if you could give a typical example (chunk size and gap
>>>>>>>>> in bytes) of what you worry about.
>>>>>>>>
>>>>>>>> With scatter-gather engine feature in the hardware, submitting
>>>>>>>> separate
>>>>>>>> transfers for each frame look inefficient. As an example, our DMA
>>>>>>>> engine
>>>>>>>> supports up to 16 video frames, with each frame (a typical video
>>>>>>>> frame
>>>>>>>> size) being contiguous in memory but frames are scattered into
>>>>>>>> different
>>>>>>>> locations. We could not definitely submit frame by frame as it would
>>>>>>>> be
>>>>>>>> software overhead (HW interrupting for each frame) resulting in video
>>>>>>>> lags.
>>>>>>>>
>>>>>>> IIUIC, it is 30fps and one dma interrupt per frame ... it doesn't seem
>>>>>>> inefficient at all. Even poor-latency audio would generate a higher
>>>>>>> interrupt-rate. So the "inefficiency concern" doesn't seem valid to
>>>>>>> me.
>>>>>>>
>>>>>>> Not to mean we shouldn't strive to reduce the interrupt-rate further.
>>>>>>> Another option is to emulate the ring-buffer scheme of ALSA.... which
>>>>>>> should be possible since for a session of video playback the frame
>>>>>>> buffers' locations wouldn't change.
>>>>>>>
>>>>>>> Yet another option is to use the full potential of the
>>>>>>> interleaved-xfer api as such. It seems you confuse a 'video frame'
>>>>>>> with the interleaved-xfer api's 'frame'. They are different.
>>>>>>>
>>>>>>> Assuming your one video frame is F bytes long and Gk is the gap in
>>>>>>> bytes between end of frame [k] and start of frame [k+1] and  Gi != Gj
>>>>>>> for i!=j
>>>>>>> In the context of interleaved-xfer api, you have just 1 Frame of 16
>>>>>>> chunks. Each chunk is Fbytes and the inter-chunk-gap(ICG) is Gk  where
>>>>>>> 0<=k<15
>>>>>>> So for your use-case .....
>>>>>>>   dma_interleaved_template.numf = 1   /* just 1 frame */
>>>>>>>   dma_interleaved_template.frame_size = 16  /* containing 16 chunks */
>>>>>>>    ...... //other parameters
>>>>>>>
>>>>>>> You have 3 options to choose from and all should work just as fine.
>>>>>>> Otherwise please state your problem in real numbers (video-frames'
>>>>>>> size, count & gap in bytes).
>>>>>>
>>>>>> Initially I interpreted interleaved template the same.  But, Lars
>>>>>> corrected me
>>>>>> in the subsequent discussion and let me put it here briefly,
>>>>>>
>>>>>> In the interleaved template, each frame represents a line of size
>>>>>> denoted by
>>>>>> chunk.size and the stride by icg.  'numf' represent number of frames
>>>>>> i.e.
>>>>>> number of lines.
>>>>>>
>>>>>> In video frame context,
>>>>>> chunk.size -> hsize
>>>>>> chunk.icg -> stride
>>>>>> numf -> vsize
>>>>>> and frame_size is always 1 as it will have only one chunk in a line.
>>>>>>
>>>>> But you said in your last post
>>>>>   "with each frame (a typical video frame size) being contiguous in
>>>>> memory"
>>>>>  ... which is not true from what you write above. Anyways, my first 2
>>>>> suggestions still hold.
>>>>
>>>> Yes, each video frame is contiguous and they can be scattered.
>>>>
>>> I assume by contiguous frame you mean as in framebuffer?  Which is an
>>> array of bytes.
>>> If yes, then you should do as I suggest first,  frame_size=16  and numf=1.
>>
>> I think am confusing you.  I would like to explain with an example.  Lets
>> say
>> each video frame is 4k size starting at address 0x10004000 (-0x10005000) and
>> other frame at 0x20002000 (-0x20003000), and so on.
>>
> As I said plz dont confuse video frame with DMA frame.... in video
> frame the stride is constant(zero or not) whereas in DMA context the
> stride must be zero for the frame to be called contiguous.
>
>> So, the frames are
>> scattered in memory and as the template doesnt allow multiple src_start/
>> dst_start we could not use single template to fill the HW descriptors (of
>> frames).  So, I feel your suggestion might not work if the frames are
>> scattered.
>> Also, how could we get 'vsize' value in your approach?
>>
> The client driver(video driver) should know the frame parameters.
> Practically you'll have to populate 16 transfer templates (frame
> attributes and locations won't change for a session) and submit to be
> transferred _cyclically_.
>
>>  More importantly,
>> we are overriding the semantics of interleaved template members.
>>
> Not at all. Interleaved-dma isn't meant for only constant stride/icg
> transfers. Rather it's for identical frames with random strides.
>
>>
>>>
>>> If no, then it seems you are already doing the right thing.... the
>>> ring-buffer scheme. Please share some stats how the current api is
>>> causing you overhead because that is a very common case (many
>>> controllers support LLI) and you have 467ms (@30fps with 16-frames
>>> ring-buffer) to queue in before you see any frame drop.
>>
>> As I mentioned earlier in the thread, our hardware has a SG engine where by
>> we could send multiple frames in a batch.  Using the original implementation
>> of interleaved API, we have three options to transfer.
>>
>> One is to send frame by frame to the hardware.  We get a async_tx desc for
>> each frame and then we submit it to hardware triggering it to transfer this
>> BD.
>> We queue the next descriptor on the pending queue and whenever there is
>> a completion interrupt we submit the next BD on this queue to hardware. In
>> this implementation we are not efficiently using the SG engine in the
>> hardware
>> as we transferring frame by frame even HW allows us to transfer multiple
>> frames.
>>
> Sending one frame at a time will likely cause jitters. That shouldn't be done.
>
>> The second option is to queue all the BDs until the maximum frames that HW
>> is
>> capable to transfer in a batch and then submit to SG engine in the HW.  With
>> this approach I feel there will be additional software overhead to track the
>> number
>> of maximum transfers and few additional cycles to release the cookie of each
>> desc.
>> Here, each desc represents a frame.
>>
> APIs are written for the gcd of h/w. We should optimize only for
> majority and here isn't even anything gained after changing the api.
> What you want to 'optimize' has been there since ever. Nobody
> considers that overhead. BTW you don't even want to spend a few 'extra
> cycles' but what about every other platform that doesn't support this
> and will have to scan for such transfer requests?
>
>> The last option is the current implementation of the driver along with this
>> change in
>> API.  It will allow us to send array of interleaved templates wherein we
>> could allocate
>> a single async desc which will handle multiple frames (or segments) and just
>> submit
>> this desc to HW.  Then we program the current to first frame, tail to last
>> frame and
>> HW will complete this transfer.  Here, each desc represents multiple frames.
>>
>> My point here is the driver should use hardware resources efficiently and I
>> feel the
>> driver will be inefficient if we dont use them.
>>
> I am afraid you are getting carried away by the 'awesomeness' of your
> hardware. RingBuffers/Cyclic transfers  are meant for cases just like
> yours.
> Consider the following ... if you queue 16 frames and don't care to
> track before all are transmitted, you'll have very high latency. Video
> seeks will take unacceptably long and give the impression of a slow
> system. Whereas if you get callbacks for each frame rendered, you
> could updates frames from the next one thereby having very quick
> response time.

Not at all, at least in our hardware, when we submit transfers it is most
likely to be completed. There are few errors, but mostly are recoverable
and it doesnt stop the transfer unless there is a critical error which needs
a reset to the whole system.  So, at least in my use case there will be
no latency.  I am not saying hardware is great, but it is the IP implementation.

Regarding this API change, I had earlier explained my use case in my
v2 thread.
Lars and Vinod came up with this resolution to allow array of
interleaved templates.
I also feel this is reasonable change for the subsystem.

Lars/Vinod, could you also comment on this thread for an early resolution?
Based on everyone's opinion I can take a call for my v4 patch.

Thanks
Srikanth

>
> Anyways there are already ways to achieve what you want (however a bad
> idea that might be). So I am not convinced the change to api is any
> useful (your hardware won't run any more efficiently with the change).
>
> Regards,
> Jassi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
