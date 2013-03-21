Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab3CUG4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 02:56:20 -0400
Received: from na3sys010aog102.obsmtp.com ([74.125.245.72]:45749 "HELO
	na3sys010aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756781Ab3CUG4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 02:56:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130321061838.GA28319@redhat.com>
References: <20130321061838.GA28319@redhat.com>
From: Roland Dreier <roland@kernel.org>
Date: Wed, 20 Mar 2013 23:55:54 -0700
X-Google-Sender-Auth: 3S5tTe4kmBEOJrUMde_ql71x9AU
Message-ID: <CAL1RGDUcMj9QVsuQgK+ozw64L6-cGehL7YBUJ1_ckni6TD=Kcg@mail.gmail.com>
Subject: Re: [PATCH] rdma: don't make pages writeable if not requiested
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Michael R. Hines" <mrhines@linux.vnet.ibm.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Yishai Hadas <yishaih@mellanox.com>, Christoph Lameter <cl@linux.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 11:18 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> core/umem.c seems to get the arguments to get_user_pages
> in the reverse order: it sets writeable flag and
> breaks COW for MAP_SHARED if and only if hardware needs to
> write the page.
>
> This breaks memory overcommit for users such as KVM:
> each time we try to register a page to send it to remote, this
> breaks COW.  It seems that for applications that only have
> REMOTE_READ permission, there is no reason to break COW at all.

I proposed a similar (but not exactly the same, see below) patch a
while ago: https://lkml.org/lkml/2012/1/26/7 but read the thread,
especially https://lkml.org/lkml/2012/2/6/265

I think this change will break the case where userspace tries to
register an MR with read-only permission, but intends locally through
the CPU to write to the memory.  If the memory registration is done
while the memory is mapped read-only but has VM_MAYWRITE, then
userspace gets into trouble when COW happens.  In the case you're
describing (although I'm not sure where in KVM we're talking about
using RDMA), what happens if you register memory with only REMOTE_READ
and then COW is triggered because of a local write?  (I'm assuming you
don't want remote access to continue to get the old contents of the
page)

I have to confess that I still haven't had a chance to implement the
proposed FOLL_FOLLOW solution to all of this.

> If the page that is COW has lots of copies, this makes the user process
> quickly exceed the cgroups memory limit.  This makes RDMA mostly useless
> for virtualization, thus the stable tag.

The actual problem description here is a bit too terse for me to
understand.  How do we end up with lots of copies of a COW page?  Why
is RDMA registering the memory any more  special than having everyone
who maps this page actually writing to it and triggering COW?

>                 ret = get_user_pages(current, current->mm, cur_base,
>                                      min_t(unsigned long, npages,
>                                            PAGE_SIZE / sizeof (struct page *)),
> -                                    1, !umem->writable, page_list, vma_list);
> +                                    !umem->writable, 1, page_list, vma_list);

The first two parameters in this line being changed are "write" and "force".

I think if we do change this, then we need to pass umem->writable (as
opposed to !umem->writable) for the "write" parameter.  Not sure
whether "force" makes sense or not.

 - R.
