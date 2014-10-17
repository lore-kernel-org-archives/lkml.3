Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbaJQOwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 10:52:10 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:18695 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751939AbaJQOwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 10:52:07 -0400
Date: Fri, 17 Oct 2014 07:51:59 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Jeffrey Hugo <jhugo@codeaurora.org>
CC: Kumar Gala <galak@codeaurora.org>, Andy Gross <agross@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Suman Anna <s-anna@ti.com>
Subject: Re: [RFC 4/7] soc: qcom: Add Shared Memory Manager driver
Message-ID: <20141017145158.GB28882@sonymobile.com>
References: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1412037291-16880-5-git-send-email-bjorn.andersson@sonymobile.com>
 <5435AD8E.2000109@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5435AD8E.2000109@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 08 Oct 14:33 PDT 2014, Jeffrey Hugo wrote:

> Here in my initial detailed pass.  I still have some "issues" that I
> want to clarify on my end, but I think I have plenty of comments to
> start with.
> 

Thanks Jeff!

> On 9/29/2014 6:34 PM, Bjorn Andersson wrote:
> > The Shared Memory Manager driver implements an interface for allocating
> > and accessing items in the memory area shared among all of the
> > processors in a Qualcomm platform.
> >
> > Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> > ---
> >
> > In later platforms this is extended to support "secure smem", I do
> > unfortunately not have any devices that I could test this with so I have only
> > implemented the "insecure" version for now.
> >
> > I was thinking about implementing an of_xlate as this would make sense for many
> > things. It is however not feasible for SMD, that would require us to list 257
> > items.
> >
> > It would make sense to enhance this with a method of keeping track of currently
> > consumed items, both to take care of "mutual exclusion" between consumers as
> > well as knowing when it's safe to remove the device and/or unload the driver.
> 
> By "mutual exclusion" I assume you mean that two different entities are
> using the same smem id.  Such a usecase is outside the purview of this
> driver, and is essentially unsupported.  Any such usecases would need to
> be handled by the client.  In short, smem items support one direct client.
> 

Good, I figured that that was the case.

So either we ignore the problem (just hand out pointers to drivers that want
them) or we enforce unique ownership. In the latter case we would have to have
a model for "releasing" items, e.g. when a consumer is removed. I can't think
of any practical case when this would actually matter.

> I'm not sure it makes sense to unload the driver.  I understand this is
> a qcom specific driver, but it is critical to our devices.  Any
> situation I can think of in which this driver would be unloaded, would
> ultimately result in a reboot of the device.
> 

In the case when you compile all parts of this series as modules you could
unload them, but I agree that it makes little sense. But either I need to
handle it or prevent it I guess.

[..]
> > diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
> > index 7bd2c94..9e6bc56 100644
> > --- a/drivers/soc/qcom/Kconfig
> > +++ b/drivers/soc/qcom/Kconfig
> > @@ -9,3 +9,11 @@ config QCOM_GSBI
> >             functions for connecting the underlying serial UART, SPI, and I2C
> >             devices to the output pins.
> >
> > +config QCOM_SMEM
> > +     tristate "Qualcomm Shared Memory Interface"
> > +     depends on ARCH_QCOM
> > +     help
> > +       Say y here to enable support for the Qualcomm Shared Memory Manager.
> > +       The driver provides an interface to items in a heap shared among all
> > +       processors in a Qualcomm platform and is used for exchanging
> > +       information as well as a fifo based communication mechanism (SMD).
> 
> I don't think the reference to SMD is appropriate here.  SMD is one of
> many clients that make use of SMEM.
> 

Ok

> > diff --git a/drivers/soc/qcom/Makefile b/drivers/soc/qcom/Makefile
> > index 4389012..b1f7b18 100644
> > --- a/drivers/soc/qcom/Makefile
> > +++ b/drivers/soc/qcom/Makefile
> > @@ -1 +1,2 @@
> >   obj-$(CONFIG_QCOM_GSBI)     +=      qcom_gsbi.o
> > +obj-$(CONFIG_QCOM_SMEM) +=   qcom_smem.o
> > diff --git a/drivers/soc/qcom/qcom_smem.c b/drivers/soc/qcom/qcom_smem.c
> > new file mode 100644
> > index 0000000..9766c86
> > --- /dev/null
> > +++ b/drivers/soc/qcom/qcom_smem.c
> 
> I see there appears to be a very small ammount of precidence (one other
> file), but it seems pointlessly redundant to prefix "qcom_" to the file
> when it exists in a "qcom" directory.  What is the other point of view
> that I am missing?
> 

I don't know where in the tree this driver should be, but your point is very
much valid.

> > @@ -0,0 +1,328 @@
> > +/*
> > + * Copyright (c) 2014, Sony Mobile Communications AB.
> > + * Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 and
> > + * only version 2 as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/io.h>
> > +#include <linux/slab.h>
> > +#include <linux/of.h>
> > +#include <linux/hwspinlock.h>
> > +#include <linux/soc/qcom/qcom_smem.h>
> 
> Alphabetized please.
> 

Ok

[..]

> > +
> > +/**
> > + * struct smem_entry - entry to reference smem items on the heap
> > + * @allocated:       boolean to indicate if this entry is used
> > + * @offset:  offset to the allocated space
> > + * @size:    size of the allocated space, 8 byte aligned
> > + * @aux_base:        base address for the memory region used by this unit, or 0 for
> > + *           the default region. bits 0,1 are reserved
> > + */
> > +struct smem_entry {
> > +     u32 allocated;
> > +     u32 offset;
> > +     u32 size;
> > +     u32 aux_base; /* bits 1:0 reserved */
> 
> Inline comment appears redundant since its addressed in the comment
> block above
> 

Oops, thanks

> > +};
> > +
> > +/**
> > + * struct smem_header - header found in beginning of primary smem region
> > + * @proc_comm:               proc_comm communication interface (legacy)
> > + * @version:         array of versions for the various subsystems
> > + * @smem_initialized:        boolean to indicate that smem is initialized
> > + * @free_offset:     index of the first unallocated byte in smem
> > + * @available:               number of bytes available for allocation
> > + * @unused:          reserved field
> > + * toc:                      array of references to smem entries
> 
> "@toc"?
> 

Indeed, thanks

> > + */
> > +struct smem_header {
> > +     struct smem_proc_comm proc_comm[4];
> > +     u32 version[32];
> > +     u32 smem_initialized;
> > +     u32 free_offset;
> > +     u32 available;
> > +     u32 unused;
> 
> I see that you inlined the smem_heap_info struct.  That is slightly
> problematic since we have some uses of that structure, and without it,
> accessing id 1 becomes complicated.  I would prefer you reintroduce it.
> 

I need to look into the code to better understand what you're referring to, but
I can reinstate it.

> > +     struct smem_entry toc[SMEM_MAX_ITEMS];
> > +};
> > +
> > +/**
> > +  * struct smem_area - memory region used for smem heap
> 
> smem_region?
> 

Of course

> > +  * @aux_base:       physical base address of the region, used for entry lookup
> > +  * @virt_base:      virtual address of the mapping
> > +  */
> > +struct smem_region {
> > +     u32 aux_base;
> > +     void __iomem *virt_base;
> > +};
> > +
> > +/**
> > +  * struct qcom_smem - control struct for the smem driver
> > +  * @dev:            device pointer
> > +  * @hwlock:         hwspinlock to be held during heap operations
> > +  * @num_regions:    number of entires in the regions array
> > +  * @regions:                array of memory regions, region 0 contains smem_header
> > +  */
> > +struct qcom_smem {
> > +     struct device *dev;
> > +
> > +     struct hwspinlock *hwlock;
> > +
> > +     unsigned num_regions;
> > +     struct smem_region regions[0];
> > +};
> > +
> > +/* Pointer to the one and only smem handle */
> > +static struct qcom_smem *smem_handle;
> > +
> > +/**
> > + * of_get_qcom_smem - retrieve a smem handle from a phandle
> 
> "of_get_qcom_smem()"?
> 

Ok

> > + * @client_node: of_node of the client
> > + *
> > + * Resolve the phandle in the property "qcom,smem" of @client_node and use this
> > + * to retrieve an smem handle.
> > + */
> > +struct qcom_smem *of_get_qcom_smem(struct device_node *client_node)
> > +{
> > +     struct device_node *node;
> > +
> > +     node = of_parse_phandle(client_node, "qcom,smem", 0);
> > +     if (!node)
> > +             return ERR_PTR(-EINVAL);
> > +
> > +     of_node_put(node);
> > +
> > +     if (!smem_handle)
> > +             return ERR_PTR(-EPROBE_DEFER);
> > +     else if (smem_handle->dev->of_node != node)
> > +             return ERR_PTR(-EINVAL);
> > +
> > +     return smem_handle;
> > +}
> > +EXPORT_SYMBOL(of_get_qcom_smem);
> 
> Why?  I understand what this does in a technical sense, but I don't
> understand the reasoning behind it.  This forces every entity that is a
> client of smem to have some kind of existance in DT, when for a lot of
> them, they won't have a need or justification to be in DT other than to
> have a phandle to smem.
> 

By modelling this as a device, with a "proper" life cycle we get around many of
the quirks related to clients accessing the api before this driver is
initialized.

> Smem is a special memory allocator.  I don't recall seeing a DT hook for
> kmalloc/dma_alloc_coherent/alloc_skb/etc so I'm not seeing why we have
> one here.
> 

The problem with smem is that it has dependencies to another device
(hwspinlock), so we have to have some sort of life cycle management (e.g. probe
deferral).

> All this does is get the clients the qcom_smem handle so that they can
> pass it back to smem for alloc and get, but there doesn't seem to be a
> need for it.  The handle is a singleton which this driver already has a
> reference to, so giving it out to the clients and having them hand it
> back seems Rube Goldberg-esq.  It also gives the clients the ability to
> screw with the handle, which I would prefer they never even touch since
> they have no business doing.  You don't even sanity check the handle
> when it gets passed in.  What happens when a client screws up and passes
> in NULL or a random pointer?
> 

I guess there will never be more than one smem instance, so you're right in
that it feels a little bit strange to have to explicitly get a handle to smem.

This api is defined to only take sane pointers, this is the kernel. If you pass
a random pointer I guess you get random behavior.

> The only positive thing about this that I see is it centralizes
> EPROBE_DEFER, but only for well behaved clients.  It doesn't appear that
> it would be too difficult to have that functionality in the simplified
> API you've presented.
> 

I don't see much reason to support anything but "well behaved clients".

Moving the probe defer to get/alloc would in my eyes force clients to implement
strange logic to do late deferal of operations.

> > +
> > +/**
> > + * qcom_smem_alloc - allocate space for a smem item
> 
> "qcom_smem_alloc()"?
> 

Ok

> > + * @smem:    smem handle
> > + * @smem_id: item to be allocated
> > + * @size:    number of bytes to be allocated
> > + *
> > + * Allocate space for a given smem item of size @size, given that the item is
> > + * not yet allocated.
> 
> Return?
> 

That sounds reasonable to document here :)

> > + */
> > +int qcom_smem_alloc(struct qcom_smem *smem, unsigned smem_id, size_t size)
> > +{
> > +     struct smem_header *header = smem->regions[0].virt_base;
> > +     struct smem_entry *entry;
> > +     unsigned long flags;
> > +     int ret;
> > +
> > +     size = ALIGN(size, 8);
> > +
> > +     if (WARN_ON(smem_id >= SMEM_MAX_ITEMS))
> > +             return -EINVAL;
> > +
> > +     ret = hwspin_lock_timeout_irqsave(smem->hwlock,
> > +                                       HWSPINLOCK_TIMEOUT,
> > +                                       &flags);
> > +     if (ret)
> > +             return ret;
> > +
> > +     entry = &header->toc[smem_id];
> > +     if (entry->allocated) {
> > +             ret = -EEXIST;
> > +             goto out;
> > +     }
> > +
> > +     if (WARN_ON(size > header->available)) {
> > +             ret = -ENOMEM;
> > +             goto out;
> > +     }
> > +
> > +     entry->offset = header->free_offset;
> > +     entry->size = size;
> 
> wmb() is needed here.  We need to ensure the remote side sees the offset
> and size before seeing allocated because they may be doing a lookup
> without allocation without the lock.
> 

Ahh of course, thanks!


But if that's specified in the "protocol", then does that mean that we don't
need to lock at all in get() as the order will make sure that an item is not
allocated before it's structure is fully filled in?

> > +     entry->allocated = 1;
> > +
> > +     header->free_offset += size;
> > +     header->available -= size;
> > +
> > +     /* Commit the changes before we release the spin lock */
> > +     wmb();
> > +out:
> > +     hwspin_unlock_irqrestore(smem->hwlock, &flags);
> > +     return ret;
> > +}
> > +EXPORT_SYMBOL(qcom_smem_alloc);
> > +
> 
> qcom_smem_get_free_space() kerneldoc?
> 

Ok

> > +unsigned qcom_smem_get_free_space(struct qcom_smem *smem)
> > +{
> > +     struct smem_header *header = smem->regions[0].virt_base;
> > +
> > +     return header->available;
> > +}
> > +EXPORT_SYMBOL(qcom_smem_get_free_space);
> > +
> > +/**
> > + * qcom_smem_get - resolve ptr of size of a smem item
> 
> "qcom_smem_get()"?
> 

Ok

> > + * @smem:    smem handle
> > + * @smem_id: item id to be resolved
> > + * @ptr:     pointer to be filled out with address of the item
> > + * @size:    pointer to be filled out with size of the item
> > + *
> > + * Looks up pointer and size of a smem item.
> 
> Return?
> 

Ok

> > + */
> > +int qcom_smem_get(struct qcom_smem *smem,
> > +               unsigned smem_id,
> > +               void **ptr,
> > +               size_t *size)
> > +{
[..]
> > diff --git a/include/linux/soc/qcom/qcom_smem.h b/include/linux/soc/qcom/qcom_smem.h
> 
> include/soc/ already exists, why add include/linux/soc?
> 

I have to admit I don't really understand why the tegra stuff is in
include/soc/, will have to do some more investigation.

> > new file mode 100644
> > index 0000000..7c0d3fd
> > --- /dev/null
> > +++ b/include/linux/soc/qcom/qcom_smem.h
> > @@ -0,0 +1,14 @@
> > +#ifndef __QCOM_SMEM_H__
> > +#define __QCOM_SMEM_H__
> > +
> 
> Why are the item definitions missing?
> 

Sorry, I don't understand what you're looking for.

> > +struct device_node;
> > +struct qcom_smem;
> > +
> > +struct qcom_smem *of_get_qcom_smem(struct device_node *node);
> > +
> > +int qcom_smem_alloc(struct qcom_smem *smem, unsigned smem_id, size_t size);
> > +int qcom_smem_get(struct qcom_smem *smem, unsigned item, void **ptr, size_t *size);
> > +
> > +unsigned qcom_smem_get_free_space(struct qcom_smem *smem);
> 
> The above functions should be stubbed out when !CONFIG_QCOM_SMEM, no?
> 

Either that or we just have the clients depend on CONFIG_QCOM_SMEM.

> > +
> > +#endif
> >
> 

Regards,
Bjorn
