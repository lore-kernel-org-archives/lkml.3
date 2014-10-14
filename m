Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370AbaJNOBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:01:16 -0400
Received: from mail-oi0-f43.google.com ([209.85.218.43]:41357 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239AbaJNOAg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:00:36 -0400
MIME-Version: 1.0
In-Reply-To: <543B896E.4030600@codeaurora.org>
References: <1412971678-4457-1-git-send-email-sumit.semwal@linaro.org> <543B896E.4030600@codeaurora.org>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Tue, 14 Oct 2014 19:30:15 +0530
Message-ID: <CAO_48GHp3BS7fqFN9PgxBZYckUxaGw2xXAoVD2x7o4QJFW-8Mg@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC 0/4] dma-buf Constraints-Enabled Allocation helpers
To: Laura Abbott <lauraa@codeaurora.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        linaro-kernel@lists.linaro.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laura,

On 13 October 2014 13:42, Laura Abbott <lauraa@codeaurora.org> wrote:
> On 10/10/2014 1:07 PM, Sumit Semwal wrote:
>>
>> Hi,
>>
>> Why:
>> ====
>>   While sharing buffers using dma-buf, currently there's no mechanism to
>> let
>> devices share their memory access constraints with each other to allow for
>> delayed allocation of backing storage.
>>
>> This RFC attempts to introduce the idea of memory constraints of a device,
>> and how these constraints can be shared and used to help allocate buffers
>> that
>> can satisfy requirements of all devices attached to a particular dma-buf.
>>
>> How:
>> ====
>>   A constraints_mask is added to dma_parms of the device, and at the time
>> of
>> each device attachment to a dma-buf, the dma-buf uses this
>> constraints_mask
>> to calculate the access_mask for the dma-buf.
>>
>> Allocators can be defined for each of these constraints_masks, and then
>> helper
>> functions can be used to allocate the backing storage from the matching
>> allocator satisfying the constraints of all devices interested.
>>
>> A new miscdevice, /dev/cenalloc [1] is created, which acts as the dma-buf
>> exporter to make this transparent to the devices.
>>
>> More details in the patch description of "cenalloc: Constraint-Enabled
>> Allocation helpers for dma-buf".
>>
>>
>> At present, the constraint_mask is only a bitmask, but it should be
>> possible to
>> change it to a struct and adapt the constraint_mask calculation
>> accordingly,
>> based on discussion.
>>
>>
>> Important requirement:
>> ======================
>>   Of course, delayed allocation can only work if all participating devices
>> will wait for other devices to have 'attached' before mapping the buffer
>> for the first time.
>>
>> As of now, users of dma-buf(drm prime, v4l2 etc) call the attach() and
>> then
>> map_attachment() almost immediately after it. This would need to be
>> changed if
>> they were to benefit from constraints.
>>
>>
>> What 'cenalloc' is not:
>> =======================
>> - not 'general' allocator helpers - useful only for constraints-enabled
>>    devices that share buffers with others using dma-buf.
>> - not a replacement for existing allocation mechanisms inside various
>>    subsystems; merely a possible alternative.
>> - no page-migration - it would be very complementary to the delayed
>> allocation
>>     suggested here.
>>
>> TODOs:
>> ======
>> - demonstration test cases
>> - vma helpers for allocators
>> - more sample allocators
>> - userspace ioctl (It should be a simple one, and we have one ready, but
>> wanted
>>     to agree on the kernel side of things first)
>>
>>
>
> I'm interested to see the userspace ioctl. The mask based approach of
> Ion does not scale well to a userspace ABI so I'm curious if cenalloc
> does better.
Apologies for the delay in response.
Since with cenalloc, the decision of 'which pool to allocate from' is
not with the userspace, but is calculated based on the devices that
attach, the userspace ABI should be just a simple xxx_create, which
returns an fd that'd be the dma-buf fd. That will allow easy sharing
with other dma-buf importers via standard dma-buf API.
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
