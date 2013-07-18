Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab3GRHjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:39:36 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:52898 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab3GRHje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:39:34 -0400
MIME-Version: 1.0
In-Reply-To: <51E7960C.8050707@samsung.com>
References: <1373880874-9270-1-git-send-email-ricardo.ribalda@gmail.com>
 <51E65577.7010403@samsung.com> <CAPybu_3Je7+0Qh2OdptncnxC12G15Scad+A3yUeF898sVWKo8w@mail.gmail.com>
 <51E69F49.10500@samsung.com> <CAPybu_0b9ADaUFFHuw=tKkVR4fiu9bGNJVgy4MGbuE-zAA9sZQ@mail.gmail.com>
 <51E7960C.8050707@samsung.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Thu, 18 Jul 2013 09:39:14 +0200
Message-ID: <CAPybu_36Pe5+RO+qmUXTQtbESnrJg4hwey1mXXRH4urc9i4GAg@mail.gmail.com>
Subject: Re: [PATCH] videobuf2-dma-sg: Minimize the number of dma segments
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Pawel Osciak <pawel@osciak.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again:

I have started to implemt it, but I think there is more hidden work in
this task as it seems. In order to call dma_map_sg and
max_dma_segment_size I need acess to the struct device, but (correct
me if I am wrong), vb2 is device agnostic. Adding the above
functionality will mean not only updating marvell-ccic and solo6x10,
but updating all the vb2 buffers.

Also after some readings, maybe the sg compactation should not be done
here, but in dma_map_sg. According to the doc:

"""
The implementation is free to merge several consecutive sglist entries
into one (e.g. if DMA mapping is done with PAGE_SIZE granularity, any
consecutive sglist entries can be merged into one provided the first one
ends and the second one starts on a page boundary - in fact this is a huge
advantage for cards which either cannot do scatter-gather or have very
limited number of scatter-gather entries) and returns the actual number
of sg entries it mapped them to. On failure 0 is returned.
"""

So, my proposal would be to alloc with alloc_pages to try to get
memory as coherent as possible, then split the page, set the sg in
PAGE_SIZE lenghts, and then let the dma_map_sg do its magic. if it
doesnt do compactation, fix dma_map_sg, so more driver could take
advantage of it.

I could also of course fix marvell-ccic and solo6x10 to use sg_table.

Does anything of this make sense?


Regards

On Thu, Jul 18, 2013 at 9:15 AM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Hello,
>
>
> On 7/17/2013 4:20 PM, Ricardo Ribalda Delgado wrote:
>>
>> Hello again Marek
>>
>> In my system I am doing the scatter gather compaction on device
>> driver... But I agree that it would be better done on the vb2 layer.
>>
>> For the oversize sglist we could do one of this two things.
>>
>> If we want to have a simple pass processing we have to allocate an
>> structure A for the worts case, work on that structure. then allocate
>> a structure B for the exact size that we need, memcpy A to B, and
>> free(A).
>>
>> Otherwise we need two passes. One to allocate the pages, and another
>> one to allocate the pages and find out the amount of sg, and another
>> to greate the sg structure.
>>
>> What do you prefer?
>
>
> I would prefer two passes approach. In the first pass you just fill the
> buf->pages array with order 0 entries and count the total number of memory
> chunks (adding support for max dma segment size at this point should be
> quite easy). In the second pass you just allocate the scatter list and
> fill it with previously allocated pages.
>
> I have also the following changes on my TODO list for vb2-dma-sg:
> - remove custom vb2_dma_sg_desc structure and replace it with common
> sg_table structure
> - move mapping of the scatter list from device driver to vb2-dma-sg module
> to simplify driver code and unify memory management across devices (so the
> driver just gets correctly mapped scatter list and only reads dma addresses
> of each memory chunk, no longer needs to track buffer state/ownership).
> The correct flow is to call dma_map_sg() at buffer allocation,
> dma_unmap_sg() at free and dma_sync_for_{device,cpu} in prepare/finish
> callbacks. The only problem here is the need to convert all existing users
> of vb2-dma-sg (marvell-ccic and solo6x10) to the new interface.
>
> However I have completely no time atm to do any of the above changes. Would
> You like to take any of the above tasks while playing with vb2-dma-sg?
>
>
> Best regards
> --
> Marek Szyprowski
> Samsung R&D Institute Poland
>
>



-- 
Ricardo Ribalda
