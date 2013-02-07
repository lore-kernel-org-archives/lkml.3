Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421Ab3BGNFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 08:05:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757965Ab3BGNE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 08:04:57 -0500
Date: Thu, 7 Feb 2013 15:09:12 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        asias@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [RFC PATCH 0/8] virtio: new API for addition of buffers,
 scatterlist changes
Message-ID: <20130207130912.GA20875@redhat.com>
References: <1360239752-2470-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360239752-2470-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 01:22:24PM +0100, Paolo Bonzini wrote:
> The virtqueue_add_buf function has two limitations:
> 
> 1) it requires the caller to provide all the buffers in a single call;
> 
> 2) it does not support chained scatterlists: the buffers must be
> provided as an array of struct scatterlist.
> 
> Because of these limitations, virtio-scsi has to copy each request into
> a scatterlist internal to the driver.  It cannot just use the one that
> was prepared by the upper SCSI layers.
> 
> This series adds a different set of APIs for adding a buffer to a
> virtqueue.  The new API lets you pass the buffers piecewise, wrapping
> multiple calls to virtqueue_add_sg between virtqueue_start_buf and
> virtqueue_end_buf.  Letting drivers call virtqueue_add_sg multiple times
> if they already have a scatterlist provided by someone else simplifies the
> code and, for virtio-scsi, it saves the copying and the related locking.
> 
> One major difference between virtqueue_add_buf and virtqueue_add_sg
> is that the latter uses scatterlist iterators, which follow chained
> scatterlist structs and stop at ending markers.  In order to avoid code
> duplication, and use the new API from virtqueue_add_buf (patch 8), we need
> to change all existing callers of virtqueue_add_buf to provide well-formed
> scatterlists.  This is what patches 2-7 do.  For virtio-blk it is easiest
> to just switch to the new API, just like for virtio-scsi.  For virtio-net
> the ending marker must be reset after calling virtqueue_add_buf, in
> preparation for the next usage of the scatterlist.  Other drivers are
> safe already.
> 

What are the changes as compared to the previous version?
How about some comments made on the previous version?
See e.g.
https://patchwork.kernel.org/patch/1891541/

Generally we have code for direct and indirect which is already
painful. We do not want 4 more variants of this code.

> This is an RFC for two reasons.  First, because I haven't done enough
> testing yet (especially with all the variations on receiving that
> virtio-net has).  Second, because I still have two struct vring_desc *
> fields in virtqueue API, which is a layering violation.  I'm not really
> sure how important that is and how to fix that---except by making the
> fields void*.

Hide the whole structure as part of vring struct, the problem will go
away.

> Paolo
> Paolo Bonzini (8):
>   virtio: add functions for piecewise addition of buffers
>   virtio-blk: reorganize virtblk_add_req
>   virtio-blk: use virtqueue_start_buf on bio path
>   virtio-blk: use virtqueue_start_buf on req path
>   scatterlist: introduce sg_unmark_end
>   virtio-net: unmark scatterlist ending after virtqueue_add_buf
>   virtio-scsi: use virtqueue_start_buf
>   virtio: reimplement virtqueue_add_buf using new functions
> 
>  block/blk-integrity.c        |    2 +-
>  block/blk-merge.c            |    2 +-
>  drivers/block/virtio_blk.c   |  165 +++++++++--------
>  drivers/net/virtio_net.c     |   21 ++-
>  drivers/scsi/virtio_scsi.c   |  103 +++++------
>  drivers/virtio/virtio_ring.c |  417 +++++++++++++++++++++++++++---------------
>  include/linux/scatterlist.h  |   16 ++
>  include/linux/virtio.h       |   25 +++
>  8 files changed, 460 insertions(+), 291 deletions(-)
