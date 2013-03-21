Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865Ab3CUJdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 05:33:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756713Ab3CUJdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 05:33:41 -0400
Date: Thu, 21 Mar 2013 11:32:31 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Roland Dreier <roland@kernel.org>
Cc: "Michael R. Hines" <mrhines@linux.vnet.ibm.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Yishai Hadas <yishaih@mellanox.com>, Christoph Lameter <cl@linux.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
Subject: Re: [PATCH] rdma: don't make pages writeable if not requiested
Message-ID: <20130321093230.GF28328@redhat.com>
References: <20130321061838.GA28319@redhat.com>
 <CAL1RGDUcMj9QVsuQgK+ozw64L6-cGehL7YBUJ1_ckni6TD=Kcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL1RGDUcMj9QVsuQgK+ozw64L6-cGehL7YBUJ1_ckni6TD=Kcg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 11:55:54PM -0700, Roland Dreier wrote:
> On Wed, Mar 20, 2013 at 11:18 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> > core/umem.c seems to get the arguments to get_user_pages
> > in the reverse order: it sets writeable flag and
> > breaks COW for MAP_SHARED if and only if hardware needs to
> > write the page.
> >
> > This breaks memory overcommit for users such as KVM:
> > each time we try to register a page to send it to remote, this
> > breaks COW.  It seems that for applications that only have
> > REMOTE_READ permission, there is no reason to break COW at all.
> 
> I proposed a similar (but not exactly the same, see below) patch a
> while ago: https://lkml.org/lkml/2012/1/26/7 but read the thread,
> especially https://lkml.org/lkml/2012/2/6/265
> 
> I think this change will break the case where userspace tries to
> register an MR with read-only permission, but intends locally through
> the CPU to write to the memory.  If the memory registration is done
> while the memory is mapped read-only but has VM_MAYWRITE, then
> userspace gets into trouble when COW happens.  In the case you're
> describing (although I'm not sure where in KVM we're talking about
> using RDMA), what happens if you register memory with only REMOTE_READ
> and then COW is triggered because of a local write?  (I'm assuming you
> don't want remote access to continue to get the old contents of the
> page)

I read that, and the above. It looks like everyone was doing tricks
like "register page, then modify it, then let remote read it"
and for some reason assumed it's ok to write into page locally from CPU
even if LOCAL_WRITE is not set.  I don't see why don't applications set
LOCAL_WRITE if they are going to write to memory locally, but assuming
they don't, we can't just break them.

So what we need is a new "no I really do not intend to write into this
memory" flag that avoids doing tricks in the kernel and treats the
page normally, just pins it so hardware can read it.


> I have to confess that I still haven't had a chance to implement the
> proposed FOLL_FOLLOW solution to all of this.

See a much easier to implement proposal at the bottom.

> > If the page that is COW has lots of copies, this makes the user process
> > quickly exceed the cgroups memory limit.  This makes RDMA mostly useless
> > for virtualization, thus the stable tag.
> 
> The actual problem description here is a bit too terse for me to
> understand.  How do we end up with lots of copies of a COW page?

Reading the links above, rdma breaks COW intentionally.

Imagine a page with lots of instances in the process page map.
For example a zero page, but not only that: we rely on KSM heavily
to deduplicate pages for multiple VMs.
There are gigabytes of these in each of the multiple VMs
running on a host.

What we are using RDMA for is VM migration so we careful not to change
this memory: when we do allow memory to change we are careful
to track what was changed, reregister and resend the data.

But at the moment, each time we register a virtual address referencing
this page, infiniband assumes we might want to change the page so it
does get_user_pages with writeable flag, forcing a copy.
Amount of used RAM explodes.

>  Why
> is RDMA registering the memory any more  special than having everyone
> who maps this page actually writing to it and triggering COW?
> 
> >                 ret = get_user_pages(current, current->mm, cur_base,
> >                                      min_t(unsigned long, npages,
> >                                            PAGE_SIZE / sizeof (struct page *)),
> > -                                    1, !umem->writable, page_list, vma_list);
> > +                                    !umem->writable, 1, page_list, vma_list);
> 
> The first two parameters in this line being changed are "write" and "force".
> 
> I think if we do change this, then we need to pass umem->writable (as
> opposed to !umem->writable) for the "write" parameter.

Ugh. Sure enough. Let's agree on the direction before I respin the
patch though.

> Not sure
> whether "force" makes sense or not.
> 
>  - R.

If you don't force write on read-only mappings you don't, but
it seems harmless for read-only gup. Still, no need to change
what's not broken.

Please comment on the below (completely untested, and needs userspace
patch too, but just to give you the idea)

--->

rdma: add IB_ACCESS_APP_READONLY 

At the moment any attempt to register memory for RDMA breaks
COW, which hurts hosts overcomitted for memory.
But if the application knows it won't write into the MR after
registration, we can save (sometimes a lot of) memory
by telling the kernel not to bother breaking COW for us.

If the application does change memory registered with this flag, it can
re-register afterwards, and resend the data on the wire.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

---

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 5929598..635b57a 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -152,7 +152,9 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 		ret = get_user_pages(current, current->mm, cur_base,
 				     min_t(unsigned long, npages,
 					   PAGE_SIZE / sizeof (struct page *)),
-				     !umem->writable, 1, page_list, vma_list);
+				     umem->writable ||
+				     !(access & IB_ACCESS_APP_READONLY),
+				     !umem->writable, page_list, vma_list);
 
 		if (ret < 0)
 			goto out;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 98cc4b2..3a3ba1b 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -871,7 +871,8 @@ enum ib_access_flags {
 	IB_ACCESS_REMOTE_READ	= (1<<2),
 	IB_ACCESS_REMOTE_ATOMIC	= (1<<3),
 	IB_ACCESS_MW_BIND	= (1<<4),
-	IB_ZERO_BASED		= (1<<5)
+	IB_ZERO_BASED		= (1<<5),
+	IB_ACCESS_APP_READONLY	= (1<<6) /* User promises not to change the data */
 };
 
 struct ib_phys_buf {

-- 
MST
