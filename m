Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab3BGNOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 08:14:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757566Ab3BGNOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 08:14:40 -0500
Message-ID: <5113A8B0.5080104@redhat.com>
Date: Thu, 07 Feb 2013 14:14:24 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        asias@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [RFC PATCH 0/8] virtio: new API for addition of buffers, scatterlist
 changes
References: <1360239752-2470-1-git-send-email-pbonzini@redhat.com> <20130207130912.GA20875@redhat.com>
In-Reply-To: <20130207130912.GA20875@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/02/2013 14:09, Michael S. Tsirkin ha scritto:
>> One major difference between virtqueue_add_buf and virtqueue_add_sg
>> is that the latter uses scatterlist iterators, which follow chained
>> scatterlist structs and stop at ending markers.  In order to avoid code
>> duplication, and use the new API from virtqueue_add_buf (patch 8), we need
>> to change all existing callers of virtqueue_add_buf to provide well-formed
>> scatterlists.  This is what patches 2-7 do.  For virtio-blk it is easiest
>> to just switch to the new API, just like for virtio-scsi.  For virtio-net
>> the ending marker must be reset after calling virtqueue_add_buf, in
>> preparation for the next usage of the scatterlist.  Other drivers are
>> safe already.
> 
> What are the changes as compared to the previous version?
> How about some comments made on the previous version?
> See e.g.
> https://patchwork.kernel.org/patch/1891541/

Two changes: 1) added virtqueue_add_sg_single; 2) reimplemented
virtqueue_add_buf in terms of the new API, which requires virtio-blk and
virtio-net changes.

The virtio-blk and virtio-net changes are based on some ideas in the
patch Rusty posted, but virtio-net is a bit simpler and virtio-blk was
redone from scratch.

> Generally we have code for direct and indirect which is already
> painful. We do not want 4 more variants of this code.

Yes, indeed, the other main difference is that I'm now reimplementing
virtqueue_add_buf using the new functions.  So:

- we previously had 2 variants (direct/indirect)

- v1 had 4 variants (direct/indirect x add_buf/add_sg)

- v2 has 4 variants (direct/indirect x add_sg/add_sg_single)

>> This is an RFC for two reasons.  First, because I haven't done enough
>> testing yet (especially with all the variations on receiving that
>> virtio-net has).  Second, because I still have two struct vring_desc *
>> fields in virtqueue API, which is a layering violation.  I'm not really
>> sure how important that is and how to fix that---except by making the
>> fields void*.
> 
> Hide the whole structure as part of vring struct, the problem will go
> away.

Yes, that's the other possibility.  Will do for the next submission.

Paolo

>> Paolo
>> Paolo Bonzini (8):
>>   virtio: add functions for piecewise addition of buffers
>>   virtio-blk: reorganize virtblk_add_req
>>   virtio-blk: use virtqueue_start_buf on bio path
>>   virtio-blk: use virtqueue_start_buf on req path
>>   scatterlist: introduce sg_unmark_end
>>   virtio-net: unmark scatterlist ending after virtqueue_add_buf
>>   virtio-scsi: use virtqueue_start_buf
>>   virtio: reimplement virtqueue_add_buf using new functions
>>
>>  block/blk-integrity.c        |    2 +-
>>  block/blk-merge.c            |    2 +-
>>  drivers/block/virtio_blk.c   |  165 +++++++++--------
>>  drivers/net/virtio_net.c     |   21 ++-
>>  drivers/scsi/virtio_scsi.c   |  103 +++++------
>>  drivers/virtio/virtio_ring.c |  417 +++++++++++++++++++++++++++---------------
>>  include/linux/scatterlist.h  |   16 ++
>>  include/linux/virtio.h       |   25 +++
>>  8 files changed, 460 insertions(+), 291 deletions(-)

