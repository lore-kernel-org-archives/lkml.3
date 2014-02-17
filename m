Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaBQJe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:34:57 -0500
Received: from smtp-out-223.synserver.de ([212.40.185.223]:1110 "EHLO
	smtp-out-011.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751435AbaBQJez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:34:55 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 23274
Message-ID: <5301D7CD.5000405@metafoo.de>
Date: Mon, 17 Feb 2014 10:35:09 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Srikanth Thokala <sthokal@xilinx.com>
CC: Vinod Koul <vinod.koul@intel.com>, dan.j.williams@intel.com,
        michal.simek@xilinx.com, Grant Likely <grant.likely@linaro.org>,
        robh+dt@kernel.org, Levente Kurusa <levex@linux.com>,
        andriy.shevchenko@linux.jf.intel.com, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 1/3] dma: Support multiple interleaved frames with
 non-contiguous memory
References: <1392465619-27614-1-git-send-email-sthokal@xilinx.com> <1392465619-27614-2-git-send-email-sthokal@xilinx.com> <20140217084316.GY10628@intel.com> <CA+mB=1K4_RpgfpWCfLy=PYOCzPThNf0Z6oSEK5Vrjh=W_YabhQ@mail.gmail.com>
In-Reply-To: <CA+mB=1K4_RpgfpWCfLy=PYOCzPThNf0Z6oSEK5Vrjh=W_YabhQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 10:29 AM, Srikanth Thokala wrote:
> On Mon, Feb 17, 2014 at 2:13 PM, Vinod Koul <vinod.koul@intel.com> wrote:
>> On Sat, Feb 15, 2014 at 05:30:17PM +0530, Srikanth Thokala wrote:
>>> The current implementation of interleaved DMA API support multiple
>>> frames only when the memory is contiguous by incrementing src_start/
>>> dst_start members of interleaved template.
>>>
>>> But, when the memory is non-contiguous it will restrict slave device
>>> to not submit multiple frames in a batch.  This patch handles this
>>> issue by allowing the slave device to send array of interleaved dma
>>> templates each having a different memory location.
>> This seems to be missing the numbers of templates you are sending, wouldnt this
>> require sending ARRAY_SiZE too?
>>
>> And why send double pointer?
>
> Array size is not required, when we pass the double pointer.  The last
> element would be
> pointed to NULL and we could get the number of templates from this condition.
> Here is an example snippet,
>
> In slave device driver,
>
>          struct dma_interleaved_template **xts;
>
>          xts = kcalloc(frm_cnt+1, sizeof(struct
> dma_interleaved_template *), GFP_KERNEL);
>          /* Error check for xts */
>          for (i = 0; i < frm_cnt; i++) {
>                  xts[i] = kmalloc(sizeof(struct
> dma_interleaved_template), GFP_KERNEL);
>                  /* Error check for xts[i] */
>          }
>          xts[i] = NULL;
>
> In DMA engine driver,  we could get the number of frames by,
>
>          for (; xts[frmno] != NULL; frmno++);
>
> I felt this way is simpler than adding an extra argument to the API.
> Please let me know
> your opinion and suggest me a better way.

I think Vinod's suggestion of passing in an array of interleaved_templates 
and the size of the array is better than what you are currently doing.

Btw. you also need to update the current implementations and users of the 
API accordingly.

>
>>
>> --
>> ~Vinod
>>
>>>
>>> Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>
>>> ---
>>>   Documentation/dmaengine.txt              |    2 +-
>>>   drivers/dma/imx-dma.c                    |    3 ++-
>>>   drivers/dma/sirf-dma.c                   |    3 ++-
>>>   drivers/media/platform/m2m-deinterlace.c |    2 +-
>>>   include/linux/dmaengine.h                |    6 +++---
>>>   5 files changed, 9 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/Documentation/dmaengine.txt b/Documentation/dmaengine.txt
>>> index 879b6e3..c642614 100644
>>> --- a/Documentation/dmaengine.txt
>>> +++ b/Documentation/dmaengine.txt
>>> @@ -94,7 +94,7 @@ The slave DMA usage consists of following steps:
>>>                size_t period_len, enum dma_data_direction direction);
>>>
>>>        struct dma_async_tx_descriptor *(*device_prep_interleaved_dma)(
>>> -             struct dma_chan *chan, struct dma_interleaved_template *xt,
>>> +             struct dma_chan *chan, struct dma_interleaved_template **xts,
>>>                unsigned long flags);
>>>
>>>      The peripheral driver is expected to have mapped the scatterlist for
>>> diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
>>> index 6f9ac20..e2c52ce 100644
>>> --- a/drivers/dma/imx-dma.c
>>> +++ b/drivers/dma/imx-dma.c
>>> @@ -954,12 +954,13 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_memcpy(
>>>   }
>>>
>>>   static struct dma_async_tx_descriptor *imxdma_prep_dma_interleaved(
>>> -     struct dma_chan *chan, struct dma_interleaved_template *xt,
>>> +     struct dma_chan *chan, struct dma_interleaved_template **xts,
>>>        unsigned long flags)
>>>   {
>>>        struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
>>>        struct imxdma_engine *imxdma = imxdmac->imxdma;
>>>        struct imxdma_desc *desc;
>>> +     struct dma_interleaved_template *xt = *xts;
>>>
>>>        dev_dbg(imxdma->dev, "%s channel: %d src_start=0x%llx dst_start=0x%llx\n"
>>>                "   src_sgl=%s dst_sgl=%s numf=%zu frame_size=%zu\n", __func__,
>>> diff --git a/drivers/dma/sirf-dma.c b/drivers/dma/sirf-dma.c
>>> index d4d3a31..b6a150b 100644
>>> --- a/drivers/dma/sirf-dma.c
>>> +++ b/drivers/dma/sirf-dma.c
>>> @@ -509,12 +509,13 @@ sirfsoc_dma_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
>>>   }
>>>
>>>   static struct dma_async_tx_descriptor *sirfsoc_dma_prep_interleaved(
>>> -     struct dma_chan *chan, struct dma_interleaved_template *xt,
>>> +     struct dma_chan *chan, struct dma_interleaved_template **xts,
>>>        unsigned long flags)
>>>   {
>>>        struct sirfsoc_dma *sdma = dma_chan_to_sirfsoc_dma(chan);
>>>        struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
>>>        struct sirfsoc_dma_desc *sdesc = NULL;
>>> +     struct dma_interleaved_template *xt = *xts;
>>>        unsigned long iflags;
>>>        int ret;
>>>
>>> diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
>>> index 6bb86b5..468110a 100644
>>> --- a/drivers/media/platform/m2m-deinterlace.c
>>> +++ b/drivers/media/platform/m2m-deinterlace.c
>>> @@ -343,7 +343,7 @@ static void deinterlace_issue_dma(struct deinterlace_ctx *ctx, int op,
>>>        ctx->xt->dst_sgl = true;
>>>        flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
>>>
>>> -     tx = dmadev->device_prep_interleaved_dma(chan, ctx->xt, flags);
>>> +     tx = dmadev->device_prep_interleaved_dma(chan, &ctx->xt, flags);
>>>        if (tx == NULL) {
>>>                v4l2_warn(&pcdev->v4l2_dev, "DMA interleaved prep error\n");
>>>                return;
>>> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
>>> index c5c92d5..2f77a9a 100644
>>> --- a/include/linux/dmaengine.h
>>> +++ b/include/linux/dmaengine.h
>>> @@ -675,7 +675,7 @@ struct dma_device {
>>>                size_t period_len, enum dma_transfer_direction direction,
>>>                unsigned long flags, void *context);
>>>        struct dma_async_tx_descriptor *(*device_prep_interleaved_dma)(
>>> -             struct dma_chan *chan, struct dma_interleaved_template *xt,
>>> +             struct dma_chan *chan, struct dma_interleaved_template **xts,
>>>                unsigned long flags);
>>>        int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
>>>                unsigned long arg);
>>> @@ -752,10 +752,10 @@ static inline struct dma_async_tx_descriptor *dmaengine_prep_dma_cyclic(
>>>   }
>>>
>>>   static inline struct dma_async_tx_descriptor *dmaengine_prep_interleaved_dma(
>>> -             struct dma_chan *chan, struct dma_interleaved_template *xt,
>>> +             struct dma_chan *chan, struct dma_interleaved_template **xts,
>>>                unsigned long flags)
>>>   {
>>> -     return chan->device->device_prep_interleaved_dma(chan, xt, flags);
>>> +     return chan->device->device_prep_interleaved_dma(chan, xts, flags);
>>>   }
>>>
>>>   static inline int dma_get_slave_caps(struct dma_chan *chan, struct dma_slave_caps *caps)
>>> --
>>> 1.7.9.5
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe dmaengine" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> --
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

