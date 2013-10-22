Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab3JVV3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 17:29:39 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:40580 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab3JVV3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 17:29:37 -0400
MIME-Version: 1.0
In-Reply-To: <20131022210828.31348.41879.stgit@viggo.jf.intel.com>
References: <1382117733-16720-12-git-send-email-b.zolnierkie@samsung.com>
	<20131022210828.31348.41879.stgit@viggo.jf.intel.com>
Date: Tue, 22 Oct 2013 14:29:36 -0700
Message-ID: <CAPcyv4iWE=fETyu6zNuyy=RBKZ1-wSks5RjLqH3xfZmMwro5rA@mail.gmail.com>
Subject: Re: [PATCH v2 11/13] NTB: convert to dmaengine_unmap_data
From: Dan Williams <dan.j.williams@intel.com>
To: dmaengine@vger.kernel.org
Cc: Dave Jiang <dave.jiang@intel.com>, b.zolnierkie@samsung.com,
        Vinod Koul <vinod.koul@intel.com>, t.figa@samsung.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kyungmin.park@samsung.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jon Mason <jon.mason@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 6:06 PM, Jon Mason <jon.mason@intel.com> wrote:
> On Fri, Oct 18, 2013 at 07:35:31PM +0200, Bartlomiej Zolnierkiewicz wrote:
>> Use the generic unmap object to unmap dma buffers.
>>
>> As NTB can be compiled without DMA_ENGINE support add
>
> Seems like the stubs should be added outside of this patch.

I think they are ok here as this is the only driver that uses them.
The alternative is a new api patch without a user.

> Also, the
> comment implies that NTB could not be compiled without DMA_ENGINE
> support before, which it could be.

Hmm, I read it as "since NTB *can* be compiled without dmaengine here
are some stubs".

>
>> stub functions to <linux/dmaengine.h> for dma_set_unmap(),
>> dmaengine_get_unmap_data() and dmaengine_unmap_put().
>>
>> Cc: Dan Williams <djbw@fb.com>
>> Cc: Vinod Koul <vinod.koul@intel.com>
>> Cc: Tomasz Figa <t.figa@samsung.com>
>> Cc: Dave Jiang <dave.jiang@intel.com>
>> Cc: Jon Mason <jon.mason@intel.com>
>> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/ntb/ntb_transport.c | 63 +++++++++++++++++++++++++++++++++------------
>>  include/linux/dmaengine.h   | 15 +++++++++++
>>  2 files changed, 61 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
>> index 12a9e83..fc6bbf1 100644
>> --- a/drivers/ntb/ntb_transport.c
>> +++ b/drivers/ntb/ntb_transport.c
>> @@ -1034,7 +1034,7 @@ static void ntb_async_rx(struct ntb_queue_entry *entry, void *offset,
>>       struct dma_chan *chan = qp->dma_chan;
>>       struct dma_device *device;
>>       size_t pay_off, buff_off;
>> -     dma_addr_t src, dest;
>> +     struct dmaengine_unmap_data *unmap;
>>       dma_cookie_t cookie;
>>       void *buf = entry->buf;
>>       unsigned long flags;
>> @@ -1054,27 +1054,41 @@ static void ntb_async_rx(struct ntb_queue_entry *entry, void *offset,
>>       if (!is_dma_copy_aligned(device, pay_off, buff_off, len))
>>               goto err1;
>>
>> -     dest = dma_map_single(device->dev, buf, len, DMA_FROM_DEVICE);
>> -     if (dma_mapping_error(device->dev, dest))
>> +     unmap = dmaengine_get_unmap_data(device->dev, 2, GFP_NOIO);
>> +     if (!unmap)
>>               goto err1;
>>
>> -     src = dma_map_single(device->dev, offset, len, DMA_TO_DEVICE);
>> -     if (dma_mapping_error(device->dev, src))
>> +     unmap->addr[0] = dma_map_page(device->dev, virt_to_page(offset),
>> +                                   pay_off, len, DMA_TO_DEVICE);
>> +     if (dma_mapping_error(device->dev, unmap->addr[0]))
>>               goto err2;
>>
>> -     flags = DMA_COMPL_DEST_UNMAP_SINGLE | DMA_COMPL_SRC_UNMAP_SINGLE |
>> +     unmap->to_cnt = 1;
>> +
>> +     unmap->addr[1] = dma_map_page(device->dev, virt_to_page(buf),
>> +                                   buff_off, len, DMA_FROM_DEVICE);
>> +     if (dma_mapping_error(device->dev, unmap->addr[1]))
>> +             goto err2;
>> +
>> +     unmap->from_cnt = 1;
>> +
>> +     flags = DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP |
>>               DMA_PREP_INTERRUPT;
>> -     txd = device->device_prep_dma_memcpy(chan, dest, src, len, flags);
>> +     txd = device->device_prep_dma_memcpy(chan, unmap->addr[1],
>> +                                          unmap->addr[0], len, flags);
>
> I must say, as a user I dislike this interface much less than the
> previous.  Can we abstract all of this away in a helper function
> that simply takes the src, dest, and len, then maps and calls
> device_prep_dma_memcpy?  The driver does not keep track of the
> dmaengine_unmap_data, so the helper function could simply return an
> error if something isn't happy.  Thoughts?

Well, that's almost dma_async_memcpy_pg_to_pg, except NTB wants it's
own callback.  We could add a new helper that does
dma_async_memcpy_pg_to_pg() with callback, but I want to do a larger
reorganization of dmaengine to try to kill off the need to specify the
callback after ->prep().  Can we go with as is for now and cleanup
later?  The same is happening to the other clients in this patchset
(async_tx, dmatest, net_dma) in terms of picking up unmap
responsibility from the drivers.  It looks "worse" for each client at
this stage, but the overall effect is:

   34 files changed, 538 insertions(+), 1157 deletions(-)

--
Dan
