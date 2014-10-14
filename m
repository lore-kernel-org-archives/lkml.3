Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457AbaJNODe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:03:34 -0400
Received: from mail-oi0-f46.google.com ([209.85.218.46]:60048 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165AbaJNODb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:03:31 -0400
MIME-Version: 1.0
In-Reply-To: <20141011184030.GG26941@phenom.ffwll.local>
References: <1412971678-4457-1-git-send-email-sumit.semwal@linaro.org>
 <1412971678-4457-3-git-send-email-sumit.semwal@linaro.org>
 <20141010230900.GA5069@kroah.com> <20141011184030.GG26941@phenom.ffwll.local>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Tue, 14 Oct 2014 19:33:10 +0530
Message-ID: <CAO_48GFy4xD+mS_1YBfpQ5Q9eBBjBDz_VxZ+8hXKLwVPARY+ig@mail.gmail.com>
Subject: Re: [RFC 2/4] cenalloc: Constraint-Enabled Allocation helpers for dma-buf
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        linaro-kernel@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, Daniel!

On 12 October 2014 00:10, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Fri, Oct 10, 2014 at 04:09:00PM -0700, Greg Kroah-Hartman wrote:
>> On Sat, Oct 11, 2014 at 01:37:56AM +0530, Sumit Semwal wrote:
>> > Devices sharing buffers using dma-buf could benefit from sharing their
>> > constraints via struct device, and dma-buf framework would manage the
>> > common constraints for all attached devices per buffer.
>> >
>> > With that information, we could have a 'generic' allocator helper in
>> > the form of a central dma-buf exporter, which can create dma-bufs, and
>> > allocate backing storage at the time of first call to
>> > dma_buf_map_attachment.
>> >
>> > This allocation would utilise the constraint-mask by matching it to
>> > the right allocator from a pool of allocators, and then allocating
>> > buffer backing storage from this allocator.
>> >
>> > The pool of allocators could be platform-dependent, allowing for
>> > platforms to hide the specifics of these allocators from the devices
>> > that access the dma-buf buffers.
>> >
>> > A sample sequence could be:
>> > - get handle to cenalloc_device,
>> > - create a dmabuf using cenalloc_buffer_create;
>> > - use this dmabuf to attach each device, which has its constraints
>> >    set in the constraints mask (dev->dma_params->access_constraints_mask)
>> >   - at each dma_buf_attach() call, dma-buf will check to see if the constraint
>> >     mask for the device requesting attachment is compatible with the constraints
>> >     of devices already attached to the dma-buf; returns an error if it isn't.
>> > - after all devices have attached, the first call to dma_buf_map_attachment()
>> >   will allocate the backing storage for the buffer.
>> > - follow the dma-buf api for map / unmap etc usage.
>> > - detach all attachments,
>> > - call cenalloc_buffer_free to free the buffer if refcount reaches zero;
>> >
>> > ** IMPORTANT**
>> > This mechanism of delayed allocation based on constraint-enablement will work
>> > *ONLY IF* the first map_attachment() call is made AFTER all attach() calls are
>> > done.
>> >
>> > Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
>> > Cc: linux-kernel@vger.kernel.org
>> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> > Cc: linux-media@vger.kernel.org
>> > Cc: dri-devel@lists.freedesktop.org
>> > Cc: linaro-mm-sig@lists.linaro.org
>> > ---
>> >  MAINTAINERS                      |   1 +
>> >  drivers/cenalloc/cenalloc.c      | 597 +++++++++++++++++++++++++++++++++++++++
>> >  drivers/cenalloc/cenalloc.h      |  99 +++++++
>> >  drivers/cenalloc/cenalloc_priv.h | 188 ++++++++++++
>> >  4 files changed, 885 insertions(+)
>> >  create mode 100644 drivers/cenalloc/cenalloc.c
>> >  create mode 100644 drivers/cenalloc/cenalloc.h
>> >  create mode 100644 drivers/cenalloc/cenalloc_priv.h
>> >
>> > diff --git a/MAINTAINERS b/MAINTAINERS
>> > index 40d4796..e88ac81 100644
>> > --- a/MAINTAINERS
>> > +++ b/MAINTAINERS
>> > @@ -3039,6 +3039,7 @@ L:    linux-media@vger.kernel.org
>> >  L: dri-devel@lists.freedesktop.org
>> >  L: linaro-mm-sig@lists.linaro.org
>> >  F: drivers/dma-buf/
>> > +F: drivers/cenalloc/
>> >  F: include/linux/dma-buf*
>> >  F: include/linux/reservation.h
>> >  F: include/linux/*fence.h
>> > diff --git a/drivers/cenalloc/cenalloc.c b/drivers/cenalloc/cenalloc.c
>> > new file mode 100644
>> > index 0000000..f278056
>> > --- /dev/null
>> > +++ b/drivers/cenalloc/cenalloc.c
>> > @@ -0,0 +1,597 @@
>> > +/*
>> > + * Allocator helper framework for constraints-aware dma-buf backing storage
>> > + * allocation.
>> > + * This allows constraint-sharing devices to deferred-allocate buffers shared
>> > + * via dma-buf.
>> > + *
>> > + * Copyright(C) 2014 Linaro Limited. All rights reserved.
>> > + * Author: Sumit Semwal <sumit.semwal@linaro.org>
>> > + *
>> > + * Structure for management of clients, buffers etc heavily derived from
>> > + * Android's ION framework.
>>
>> Does that mean we can drop ION after this gets merged?
>
> Yeah, I hope so. Not sure whetether this hope is shared by google android
> people ...
Apologies for the delay in response; was travelling for LPC and so
couldn't respond.

Yes, that is certainly the hope, but this is the first-step RFC which
would need a few more things before ION can be replaced completely.
>
>> /me dreams
>
> I guess we can collectively dream about this next week at plumbers ;-)
> I'll try to squeeze in some light review of Sumit's patches between
> conference travels ...
>
> Cheers, Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch



-- 
Thanks and regards,

Sumit Semwal
Kernel Team Lead - Linaro Mobile Group
Linaro.org │ Open source software for ARM SoCs
