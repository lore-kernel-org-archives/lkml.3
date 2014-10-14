Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380AbaJNOMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:12:21 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:38508 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145AbaJNOMU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:12:20 -0400
MIME-Version: 1.0
In-Reply-To: <543B8ED2.4000207@codeaurora.org>
References: <1412971678-4457-1-git-send-email-sumit.semwal@linaro.org>
 <1412971678-4457-3-git-send-email-sumit.semwal@linaro.org> <543B8ED2.4000207@codeaurora.org>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Tue, 14 Oct 2014 19:41:59 +0530
Message-ID: <CAO_48GHeiVXB1RimJrgQ9SaTdf39FcKb6W+DJx8gpqUndZbDvQ@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC 2/4] cenalloc: Constraint-Enabled Allocation
 helpers for dma-buf
To: Laura Abbott <lauraa@codeaurora.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linaro-kernel@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laura,


On 13 October 2014 14:05, Laura Abbott <lauraa@codeaurora.org> wrote:
> On 10/10/2014 1:07 PM, Sumit Semwal wrote:
>>
>> Devices sharing buffers using dma-buf could benefit from sharing their
>> constraints via struct device, and dma-buf framework would manage the
>> common constraints for all attached devices per buffer.
>>
>> With that information, we could have a 'generic' allocator helper in
>> the form of a central dma-buf exporter, which can create dma-bufs, and
>> allocate backing storage at the time of first call to
>> dma_buf_map_attachment.
>>
>> This allocation would utilise the constraint-mask by matching it to
>> the right allocator from a pool of allocators, and then allocating
>> buffer backing storage from this allocator.
>>
>> The pool of allocators could be platform-dependent, allowing for
>> platforms to hide the specifics of these allocators from the devices
>> that access the dma-buf buffers.
>>
>> A sample sequence could be:
>> - get handle to cenalloc_device,
>> - create a dmabuf using cenalloc_buffer_create;
>> - use this dmabuf to attach each device, which has its constraints
>>     set in the constraints mask (dev->dma_params->access_constraints_mask)
>>    - at each dma_buf_attach() call, dma-buf will check to see if the
>> constraint
>>      mask for the device requesting attachment is compatible with the
>> constraints
>>      of devices already attached to the dma-buf; returns an error if it
>> isn't.
>> - after all devices have attached, the first call to
>> dma_buf_map_attachment()
>>    will allocate the backing storage for the buffer.
>> - follow the dma-buf api for map / unmap etc usage.
>> - detach all attachments,
>> - call cenalloc_buffer_free to free the buffer if refcount reaches zero;
>>
>> ** IMPORTANT**
>> This mechanism of delayed allocation based on constraint-enablement will
>> work
>> *ONLY IF* the first map_attachment() call is made AFTER all attach() calls
>> are
>> done.
>>
>
> My first instinct is 'I wonder which drivers will call map_attachment at
> the wrong time and screw things up'. Are there any plans for
> synchronization and/or debugging output to catch drivers violating this
> requirement?

Well, of course you're right - at the moment, no mechanism to do so.
That will certainly be the next step - we could discuss it sometime
this week at LPC to see what makes better sense.
>
> [...]
>>
>> +int cenalloc_phys(struct dma_buf *dmabuf,
>> +            phys_addr_t *addr, size_t *len)
>> +{
>> +       struct cenalloc_buffer *buffer;
>> +       int ret;
>> +
>> +       if (is_cenalloc_buffer(dmabuf))
>> +               buffer = (struct cenalloc_buffer *)dmabuf->priv;
>> +       else
>> +               return -EINVAL;
>> +
>> +       if (!buffer->allocator->ops->phys) {
>> +               pr_err("%s: cenalloc_phys is not implemented by this
>> allocator.\n",
>> +                      __func__);
>> +               return -ENODEV;
>> +       }
>> +       mutex_lock(&buffer->lock);
>> +       ret = buffer->allocator->ops->phys(buffer->allocator, buffer,
>> addr,
>> +                                               len);
>> +       mutex_lock(&buffer->lock);
>> +       return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(cenalloc_phys);
>> +
>
>
> The .phys operation makes it difficult to have drivers which can
> handle both contiguous and non contiguous memory (too much special
> casing). Any chance we could drop this API and just have drivers
> treat an sg_table with 1 entry as contiguous memory?
I am not sure I understand how having a .phys makes it more difficult
- and also, for cases where you're sharing buffers between CPU and a
co-processor like DSP, my understanding is that we'd need an
equivalent of a phys address.

>
> Thanks,
> Laura
>
> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation



-- 
Thanks and regards,

Sumit Semwal
Kernel Team Lead - Linaro Mobile Group
Linaro.org │ Open source software for ARM SoCs
