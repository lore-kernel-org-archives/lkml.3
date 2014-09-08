Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbaIHQVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:21:14 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:36668 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbaIHQVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:21:13 -0400
Message-ID: <540DD76F.3030106@redhat.com>
Date: Mon, 08 Sep 2014 18:21:03 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>
CC: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio_blk: merge S/G list entries by default
References: <1410044994-14943-1-git-send-email-hch@lst.de> <20140907114153.GB26569@redhat.com>
In-Reply-To: <20140907114153.GB26569@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/09/2014 13:41, Michael S. Tsirkin ha scritto:
> On Sat, Sep 06, 2014 at 04:09:54PM -0700, Christoph Hellwig wrote:
>> Most virtio setups have a fairly limited number of ring entries available.
> 
> Seems a bit vague: QEMU at least has pretty large queues.
> Which hypervisor do you have in mind?
> This could be a gain everywhere if you manage to make descriptors
> completely linear, so they fit in a single s/g.
> ATM __virtblk_add_req always adds an s/g for the header:
> is there a chance linux can pre-allocate a bit of memory
> in front of the buffer to stick the header in?

Nope, the buffer usually comes directly from the page cache and will be
page aligned.

Paolo

>> Enable S/G entry merging by default to fit into less of them.  This restores
>> the behavior at time of the virtio-blk blk-mq conversion, which was changed
>> by commit "block: add queue flag for disabling SG merging" which made the
>> behavior optional, but didn't update the existing drivers to keep their
>> previous behavior.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> OK so this is an optimization patch right?
> What kind of performance gain is observed with it?
> 
>> ---
>>  drivers/block/virtio_blk.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>> index 0a58140..311b857 100644
>> --- a/drivers/block/virtio_blk.c
>> +++ b/drivers/block/virtio_blk.c
>> @@ -634,7 +634,7 @@ static int virtblk_probe(struct virtio_device *vdev)
>>  	vblk->tag_set.ops = &virtio_mq_ops;
>>  	vblk->tag_set.queue_depth = virtblk_queue_depth;
>>  	vblk->tag_set.numa_node = NUMA_NO_NODE;
>> -	vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
>> +	vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_SG_MERGE;
>>  	vblk->tag_set.cmd_size =
>>  		sizeof(struct virtblk_req) +
>>  		sizeof(struct scatterlist) * sg_elems;
>> -- 
>> 1.9.1

