Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934717Ab3DJWCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:02:07 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:33324 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab3DJWCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:02:05 -0400
Message-ID: <1365630585.32127.110.camel@misato.fc.hp.com>
Subject: Re: [PATCH v3 2/3] resource: Add release_mem_region_adjustable()
From: Toshi Kani <toshi.kani@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        linuxram@us.ibm.com, guz.fnst@cn.fujitsu.com, tmac@hp.com,
        isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        tangchen@cn.fujitsu.com, jiang.liu@huawei.com
Date: Wed, 10 Apr 2013 15:49:45 -0600
In-Reply-To: <20130410144412.395bf9f2fb8192920175e30a@linux-foundation.org>
References: <1365614221-685-1-git-send-email-toshi.kani@hp.com>
	 <1365614221-685-3-git-send-email-toshi.kani@hp.com>
	 <20130410144412.395bf9f2fb8192920175e30a@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 14:44 -0700, Andrew Morton wrote:
> On Wed, 10 Apr 2013 11:17:00 -0600 Toshi Kani <toshi.kani@hp.com> wrote:
> 
> > Added release_mem_region_adjustable(), which releases a requested
> > region from a currently busy memory resource.  This interface
> > adjusts the matched memory resource accordingly even if the
> > requested region does not match exactly but still fits into.
> > 
> > This new interface is intended for memory hot-delete.  During
> > bootup, memory resources are inserted from the boot descriptor
> > table, such as EFI Memory Table and e820.  Each memory resource
> > entry usually covers the whole contigous memory range.  Memory
> > hot-delete request, on the other hand, may target to a particular
> > range of memory resource, and its size can be much smaller than
> > the whole contiguous memory.  Since the existing release interfaces
> > like __release_region() require a requested region to be exactly
> > matched to a resource entry, they do not allow a partial resource
> > to be released.
> > 
> > This new interface is restrictive (i.e. release under certain
> > conditions), which is consistent with other release interfaces,
> > __release_region() and __release_resource().  Additional release
> > conditions, such as an overlapping region to a resource entry,
> > can be supported after they are confirmed as valid cases.
> > 
> > There is no change to the existing interfaces since their restriction
> > is valid for I/O resources.
> > 
> > ...
> >
> > +int release_mem_region_adjustable(struct resource *parent,
> > +			resource_size_t start, resource_size_t size)
> > +{
> > +	struct resource **p;
> > +	struct resource *res, *new;
> > +	resource_size_t end;
> > +	int ret = -EINVAL;
> > +
> > +	end = start + size - 1;
> > +	if ((start < parent->start) || (end > parent->end))
> > +		return ret;
> > +
> > +	p = &parent->child;
> > +	write_lock(&resource_lock);
> > +
> > +	while ((res = *p)) {
> > +		if (res->start >= end)
> > +			break;
> > +
> > +		/* look for the next resource if it does not fit into */
> > +		if (res->start > start || res->end < end) {
> > +			p = &res->sibling;
> > +			continue;
> > +		}
> > +
> > +		if (!(res->flags & IORESOURCE_MEM))
> > +			break;
> > +
> > +		if (!(res->flags & IORESOURCE_BUSY)) {
> > +			p = &res->child;
> > +			continue;
> > +		}
> > +
> > +		/* found the target resource; let's adjust accordingly */
> > +		if (res->start == start && res->end == end) {
> > +			/* free the whole entry */
> > +			*p = res->sibling;
> > +			kfree(res);
> > +			ret = 0;
> > +		} else if (res->start == start && res->end != end) {
> > +			/* adjust the start */
> > +			ret = __adjust_resource(res, end + 1,
> > +						res->end - end);
> > +		} else if (res->start != start && res->end == end) {
> > +			/* adjust the end */
> > +			ret = __adjust_resource(res, res->start,
> > +						start - res->start);
> > +		} else {
> > +			/* split into two entries */
> > +			new = kzalloc(sizeof(struct resource), GFP_KERNEL);
> 
> Nope, we can't perform a GFP_KERNEL allocation under write_lock().
> 
> Was this code path runtime tested?  If no, please try
> to find a way to test it.  If yes, please see
> Documentation/SubmitChecklist section 12 and use that in the future.

Yes, I tested all cases.  But I did not test with all the config options
described in the document.  I will make sure to test with the options
next time.  Thanks a lot for the pointer!

> I'll switch it to GFP_ATOMIC.  Which is horridly lame but the
> allocation is small and alternatives are unobvious.

Great!  Again, thanks for the update!
-Toshi

