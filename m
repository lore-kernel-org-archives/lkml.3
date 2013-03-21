Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374Ab3CUIuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 04:50:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932625Ab3CUIur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 04:50:47 -0400
Date: Thu, 21 Mar 2013 10:51:07 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Roland Dreier <roland@kernel.org>
Cc: "Michael R. Hines" <mrhines@linux.vnet.ibm.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Yishai Hadas <yishaih@mellanox.com>, Christoph Lameter <cl@linux.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
Subject: Re: [PATCH] rdma: don't make pages writeable if not requiested
Message-ID: <20130321085107.GE28328@redhat.com>
References: <20130321061838.GA28319@redhat.com>
 <CAL1RGDUcMj9QVsuQgK+ozw64L6-cGehL7YBUJ1_ckni6TD=Kcg@mail.gmail.com>
 <20130321070357.GD28328@redhat.com>
 <CAG4TOxPkhOhGmzeA1K4a0Zw8HxS-QkOr-PCx7mJgA+KkuH3ZiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG4TOxPkhOhGmzeA1K4a0Zw8HxS-QkOr-PCx7mJgA+KkuH3ZiQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 12:15:33AM -0700, Roland Dreier wrote:
> >> I think this change will break the case where userspace tries to
> >> register an MR with read-only permission, but intends locally through
> >> the CPU to write to the memory.
> 
> > Shouldn't it set LOCAL_WRITE then?
> 
> We're talking about the permissions for the register MR operation,
> right?  (That's what the kernel RDMA driver code that does
> get_user_pages() sees)
> 
> In that case, no, I don't see any reason for LOCAL_WRITE, since the
> only RDMA operations that will access this memory are remote reads.

What is the meaning of LOCAL_WRITE then? There are no local
RDMA writes as far as I can see.

> The writing (that triggers COW) is coming from normal process access
> triggering a page fault, etc.  This is a pretty standard way of using
> RDMA... For example, I allocate some memory and register it for RDMA
> read (and pass the R_Key to the remote system) with only REMOTE_READ
> permission.  Then I fill in the memory with the results of some
> computation and the remote system does an RDMA read to get those
> results.
> 
>  - R.

OK then what we need is a new flag saying "I really do not
intend to write into this memory please do not break
COW or do anything else just in case I do".

-- 
MST
