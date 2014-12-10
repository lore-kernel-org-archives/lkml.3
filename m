Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbaLJNbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:31:39 -0500
Received: from mail-oi0-f51.google.com ([209.85.218.51]:64716 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804AbaLJNbh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:31:37 -0500
MIME-Version: 1.0
In-Reply-To: <20141011185502.GH26941@phenom.ffwll.local>
References: <1412971678-4457-1-git-send-email-sumit.semwal@linaro.org>
 <1412971678-4457-2-git-send-email-sumit.semwal@linaro.org> <20141011185502.GH26941@phenom.ffwll.local>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Wed, 10 Dec 2014 19:01:16 +0530
Message-ID: <CAO_48GH2JmyT-qLyJk=H=rVkds79Gr2MsD3u+1pV48ta78q7OQ@mail.gmail.com>
Subject: Re: [RFC 1/4] dma-buf: Add constraints sharing information
To: Sumit Semwal <sumit.semwal@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, linaro-kernel@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

Thanks a bunch for your review comments! A few comments, post our
discussion at LPC;

On 12 October 2014 at 00:25, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Sat, Oct 11, 2014 at 01:37:55AM +0530, Sumit Semwal wrote:
>> At present, struct device lacks a mechanism of exposing memory
>> access constraints for the device.
>>
>> Consequently, there is also no mechanism to share these constraints
>> while sharing buffers using dma-buf.
>>
>> If we add support for sharing such constraints, we could use that
>> to try to collect requirements of different buffer-sharing devices
>> to allocate buffers from a pool that satisfies requirements of all
>> such devices.
>>
>> This is an attempt to add this support; at the moment, only a bitmask
>> is added, but if post discussion, we realise we need more information,
>> we could always extend the definition of constraint.
>>
>> A new dma-buf op is also added, to allow exporters to interpret or decide
>> on constraint-masks on their own. A default implementation is provided to
>> just AND (&) all the constraint-masks.
>>
>> What constitutes a constraint-mask could be left for interpretation on a
>> per-platform basis, while defining some common masks.
>>
>> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
>> Cc: linux-kernel@vger.kernel.org
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: linux-media@vger.kernel.org
>> Cc: dri-devel@lists.freedesktop.org
>> Cc: linaro-mm-sig@lists.linaro.org
>
> Just a few high-level comments, I'm between conference travel but
> hopefully I can discuss this a bit at plumbers next week.
>
> - I agree that for the insane specific cases we need something opaque like
>   the access constraints mask you propose here. But for the normal case I
>   think the existing dma constraints in dma_params would go a long way,
>   and I think we should look at Rob's RFC from aeons ago to solve those:
>
>   https://lkml.org/lkml/2012/7/19/285
>
>   With this we should be able to cover the allocation constraints of 90%
>   of all cases hopefully.
>
> - I'm not sure whether an opaque bitmask is good enough really, I suspect
>   that we also need various priorities between different allocators. With
>   the option that some allocators are flat-out incompatible.

Your/Rob's idea to figure out the constraints wrt max number of
segments in the sg_list can provide, like you said, maybe 80-90% of
the allocation constraints hopefully. The opaque mask should help for
the remaining 'crazy' cases, so I'll be glad to merge Rob's and my
approach on defining the constraints.

I should think a little bit more about the priority idea that you
propose here (and in another patch), but atm I am unable to see how
that could help solve the finding-out-constraints problem.
>
> - The big bummer imo with ION is that it fully side-steps, but this
>   proposal here also seems to add entirely new allocators. My rough idea

This proposal does borrow this bit from ION, but once we have the
required changes done in the dma api itself, the allocators can just
become shims to the dma api allocators (eg dma_alloc_coherent etc) for
cases where they can be used directly, while leaving provision for any
crazy platform-specific allocators, without the userspace having to
worry about it.

>   was that at allocate/attach time we iterate over all attached devices
>   like in Rob's patch and compute the most constrained allocation
>   requirements. Then we pick the underlying dma api allocator for these
>   constraints. That probably means that we need to open up the dma api a
>   bit. But I guess for a start we could simply try to allocate from the
>   most constrained device. Together with the opaque bits you propose here
>   we could even map additional crazy requirements like that an allocation
>   must come from a specific memory bank (provided by a special-purpose CMA
>   region). That might also mean that requirements are exclusive and no
>   allocation is possible.
>
My idea was a little variation on what you said here - rather than do
compute the most constraint allocation 'after' devices have attached
(and right now, we don't really have a way to know that - but that's
another point), I'd proposed to do the compute on each attach request,
so the requesting drivers can know immediately if the attachment will
not work for the other currently attached devices.

> - I'm not sure we should allow drivers to override the access constraint
>   checks really - the dma_buf interfaces already provide this possibility
>   through the ->attach callback. In there exporters are allowed to reject
>   the attachment for any reason whatsover.
>
This override the access constraint check is again meant only as a
helper, but I could sure drop it.

> - I think we should at least provide a helper implementation to allocate
>   dma-buffers for multiple devices using the dma constraints logic we
>   implement here. I think we should even go as far as providing a default
>   implementation for dma-bufs which uses dma_alloc_coherent and this new
>   dma contstraints computation code internally. This should be good enough

Ok, my idea was to keep the allocation helpers separate from dma-buf
framework - hence the cenalloc idea; if it seems like an extremely
terrible approach to separate out helpers, I could try and do an RFC
based on your idea.

>   for almost all devices, except those that do crazy stuff like swap
>   support of buffer objects (gem/ttm), virtual hardware buffers (vmwgfx)
>   or have other special needs (e.g. non-coherent buffers as speed
>   optimization).
>
Cenalloc type of idea could allow for these special needs I think!

> Cheers, Daniel
>
>> ---
>>  drivers/dma-buf/dma-buf.c | 50 ++++++++++++++++++++++++++++++++++++++++++-----
>>  include/linux/device.h    |  7 ++++++-
>>  include/linux/dma-buf.h   | 14 +++++++++++++
>>  3 files changed, 65 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
>> index f3014c4..33bdb6a 100644
>> --- a/drivers/dma-buf/dma-buf.c
>> +++ b/drivers/dma-buf/dma-buf.c
>> @@ -264,6 +264,30 @@ static inline int is_dma_buf_file(struct file *file)
>>       return file->f_op == &dma_buf_fops;
>>  }
>>
>> +/*
>> + * def_calc_access_constraints - default implementation of constraint checking
>> + */
>> +static int def_calc_access_constraints(struct dma_buf *dmabuf,
>> +             struct dma_buf_attachment *attach)
>> +{
>> +     unsigned long access_mask;
>> +
>> +     access_mask = attach->dev->dma_parms->access_constraints_mask;
>> +
>> +     if (!access_mask) {
>> +             pr_warn("%s dev has no access_constraints_mask; using default\n",
>> +                             dev_name(attach->dev));
>> +              access_mask = DMA_BUF_ALL_MEMORY_ACCESS_MASK;
>> +     }
>> +
>> +     dmabuf->access_constraints_mask &= access_mask;
>> +
>> +     if (!dmabuf->access_constraints_mask)
>> +             return -EINVAL;
>> +
>> +     return 0;
>> +}
>> +
>>  /**
>>   * dma_buf_export_named - Creates a new dma_buf, and associates an anon file
>>   * with this buffer, so it can be exported.
>> @@ -313,6 +337,8 @@ struct dma_buf *dma_buf_export_named(void *priv, const struct dma_buf_ops *ops,
>>       dmabuf->ops = ops;
>>       dmabuf->size = size;
>>       dmabuf->exp_name = exp_name;
>> +     dmabuf->access_constraints_mask = DMA_BUF_ALL_MEMORY_ACCESS_MASK;
>> +
>>       init_waitqueue_head(&dmabuf->poll);
>>       dmabuf->cb_excl.poll = dmabuf->cb_shared.poll = &dmabuf->poll;
>>       dmabuf->cb_excl.active = dmabuf->cb_shared.active = 0;
>> @@ -410,8 +436,10 @@ void dma_buf_put(struct dma_buf *dmabuf)
>>  EXPORT_SYMBOL_GPL(dma_buf_put);
>>
>>  /**
>> - * dma_buf_attach - Add the device to dma_buf's attachments list; optionally,
>> - * calls attach() of dma_buf_ops to allow device-specific attach functionality
>> + * dma_buf_attach - Add the device to dma_buf's attachments list;
>> + *   calculates access_constraints and throws error if constraints aren't
>> + *   satisfied. Optionally, calls attach() of dma_buf_ops to allow
>> + *   device-specific attach functionality.
>>   * @dmabuf:  [in]    buffer to attach device to.
>>   * @dev:     [in]    device to be attached.
>>   *
>> @@ -436,11 +464,20 @@ struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
>>
>>       mutex_lock(&dmabuf->lock);
>>
>> +     if (!dmabuf->ops->calc_access_constraints)
>> +             ret = def_calc_access_constraints(dmabuf, attach);
>> +     else
>> +             ret = dmabuf->ops->calc_access_constraints(dmabuf, attach);
>> +
>> +     if (ret)
>> +             goto err_attach;
>> +
>>       if (dmabuf->ops->attach) {
>>               ret = dmabuf->ops->attach(dmabuf, dev, attach);
>>               if (ret)
>>                       goto err_attach;
>>       }
>> +
>>       list_add(&attach->node, &dmabuf->attachments);
>>
>>       mutex_unlock(&dmabuf->lock);
>> @@ -785,7 +822,7 @@ static int dma_buf_describe(struct seq_file *s)
>>               return ret;
>>
>>       seq_puts(s, "\nDma-buf Objects:\n");
>> -     seq_puts(s, "size\tflags\tmode\tcount\texp_name\n");
>> +     seq_puts(s, "size\tflags\tmode\tcount\tconstraints\texp_name\n");
>>
>>       list_for_each_entry(buf_obj, &db_list.head, list_node) {
>>               ret = mutex_lock_interruptible(&buf_obj->lock);
>> @@ -796,10 +833,11 @@ static int dma_buf_describe(struct seq_file *s)
>>                       continue;
>>               }
>>
>> -             seq_printf(s, "%08zu\t%08x\t%08x\t%08ld\t%s\n",
>> +             seq_printf(s, "%08zu\t%08x\t%08x\t%08ld\t%08lx\t%s\n",
>>                               buf_obj->size,
>>                               buf_obj->file->f_flags, buf_obj->file->f_mode,
>>                               (long)(buf_obj->file->f_count.counter),
>> +                             buf_obj->access_constraints_mask,
>>                               buf_obj->exp_name);
>>
>>               seq_puts(s, "\tAttached Devices:\n");
>> @@ -808,7 +846,9 @@ static int dma_buf_describe(struct seq_file *s)
>>               list_for_each_entry(attach_obj, &buf_obj->attachments, node) {
>>                       seq_puts(s, "\t");
>>
>> -                     seq_printf(s, "%s\n", dev_name(attach_obj->dev));
>> +                     seq_printf(s, "%s\t:%lx\n",
>> +                                     dev_name(attach_obj->dev),
>> +                       attach_obj->dev->dma_parms->access_constraints_mask);
>>                       attach_count++;
>>               }
>>
>> diff --git a/include/linux/device.h b/include/linux/device.h
>> index a608e23..f9aefa2 100644
>> --- a/include/linux/device.h
>> +++ b/include/linux/device.h
>> @@ -647,6 +647,11 @@ struct device_dma_parameters {
>>        */
>>       unsigned int max_segment_size;
>>       unsigned long segment_boundary_mask;
>> +     /*
>> +      * access_constraints_mask: this would be used to share constraints
>> +      * about memories that this device can access.
>> +      */
>> +     unsigned long access_constraints_mask;
>>  };
>>
>>  struct acpi_device;
>> @@ -696,7 +701,7 @@ struct acpi_dev_node {
>>   *           such descriptors.
>>   * @dma_pfn_offset: offset of DMA memory range relatively of RAM
>>   * @dma_parms:       A low level driver may set these to teach IOMMU code about
>> - *           segment limitations.
>> + *           segment limitations, and access constraints.
>>   * @dma_pools:       Dma pools (if dma'ble device).
>>   * @dma_mem: Internal for coherent mem override.
>>   * @cma_area:        Contiguous memory area for dma allocations
>> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
>> index 694e1fe..8429a38 100644
>> --- a/include/linux/dma-buf.h
>> +++ b/include/linux/dma-buf.h
>> @@ -37,6 +37,8 @@ struct device;
>>  struct dma_buf;
>>  struct dma_buf_attachment;
>>
>> +#define DMA_BUF_ALL_MEMORY_ACCESS_MASK ((unsigned long)-1)
>> +
>>  /**
>>   * struct dma_buf_ops - operations possible on struct dma_buf
>>   * @attach: [optional] allows different devices to 'attach' themselves to the
>> @@ -44,6 +46,12 @@ struct dma_buf_attachment;
>>   *       is already allocated and incompatible with the requirements
>>   *       of requesting device.
>>   * @detach: [optional] detach a given device from this buffer.
>> + * @calc_access_constraints(): [optional] will be called at the end of each
>> + *           attach - to calculate and set the constraints for this dma_buf
>> + *           according to this attachment's access_constraint_mask in
>> + *           dev->dma_parms.
>> + *           A default implementation is provided, but exporters are free to
>> + *           provide custom version if needed.
>>   * @map_dma_buf: returns list of scatter pages allocated, increases usecount
>>   *            of the buffer. Requires atleast one attach to be called
>>   *            before. Returned sg list should already be mapped into
>> @@ -77,6 +85,9 @@ struct dma_buf_ops {
>>
>>       void (*detach)(struct dma_buf *, struct dma_buf_attachment *);
>>
>> +     int (*calc_access_constraints)(struct dma_buf *,
>> +                     struct dma_buf_attachment *);
>> +
>>       /* For {map,unmap}_dma_buf below, any specific buffer attributes
>>        * required should get added to device_dma_parameters accessible
>>        * via dev->dma_params.
>> @@ -86,6 +97,7 @@ struct dma_buf_ops {
>>       void (*unmap_dma_buf)(struct dma_buf_attachment *,
>>                                               struct sg_table *,
>>                                               enum dma_data_direction);
>> +
>>       /* TODO: Add try_map_dma_buf version, to return immed with -EBUSY
>>        * if the call would block.
>>        */
>> @@ -116,6 +128,7 @@ struct dma_buf_ops {
>>   * @ops: dma_buf_ops associated with this buffer object.
>>   * @exp_name: name of the exporter; useful for debugging.
>>   * @list_node: node for dma_buf accounting and debugging.
>> + * @access_constraints_mask: mask to share access constraints.
>>   * @priv: exporter specific private data for this buffer object.
>>   * @resv: reservation object linked to this dma-buf
>>   */
>> @@ -130,6 +143,7 @@ struct dma_buf {
>>       void *vmap_ptr;
>>       const char *exp_name;
>>       struct list_head list_node;
>> +     unsigned long access_constraints_mask;
>>       void *priv;
>>       struct reservation_object *resv;
>>
>> --
>> 1.9.1
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch



-- 
Thanks and regards,

Sumit Semwal
Kernel Team Lead - Linaro Mobile Group
Linaro.org │ Open source software for ARM SoCs
