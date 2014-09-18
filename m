Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbaIRCNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 22:13:14 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:49709 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983AbaIRCNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 22:13:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140917210954.6e622fb5@thinkpad-w530>
References: <541178D6.6010303@de.ibm.com>
	<CACVXFVO7Oo9GeagPhejngfoeySxOP4EqWz_GN6kYv2956-Wtxg@mail.gmail.com>
	<541352ED.7030800@de.ibm.com>
	<54193F4F.9060508@de.ibm.com>
	<20140917140034.10125d00@thinkpad-w530>
	<20140917215226.426f6ce7@tom-ThinkPad-T410>
	<54199923.9010201@kernel.dk>
	<CACVXFVPh3SSp3V7hHJaPnp-koyh7n7hqf+Ugv9CMg2gO_8MwXg@mail.gmail.com>
	<20140917210954.6e622fb5@thinkpad-w530>
Date: Thu, 18 Sep 2014 10:13:12 +0800
Message-ID: <CACVXFVNivj3Y-gzto2tQAenR4fwQDUTYob703ZogUjNcz7=V5w@mail.gmail.com>
Subject: Re: blk-mq crash under KVM in multiqueue block code (with virtio-blk
 and ext4)
From: Ming Lei <tom.leiming@gmail.com>
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, KVM list <kvm@vger.kernel.org>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org >> Linux Kernel Mailing List" 
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 3:09 AM, David Hildenbrand
<dahi@linux.vnet.ibm.com> wrote:
>> On Wed, Sep 17, 2014 at 10:22 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> >
>> > Another way would be to ensure that the timeout handler doesn't touch hw_ctx
>> > or tag_sets that aren't fully initialized yet. But I think this is
>> > safer/cleaner.
>>
>> That may not be easy or enough to check if hw_ctx/tag_sets are
>> fully initialized if you mean all requests have been used one time.
>>
>> On Wed, Sep 17, 2014 at 10:11 PM, David Hildenbrand
>> > I was playing with a simple patch that just sets cmd_flags and action_flags to
>>
>> What is action_flags?
>
> atomic_flags, sorry :)
>
> Otherwise e.g. REQ_ATOM_STARTED could already be set due to the randomness. I
> am not sure if this is really necessary, or if it is completely shielded by the
> tag-handling code, but seemed to be clean for me to do it (and I remember it
> not being set within blk_mq_rq_ctx_init).

You are right, both cmd_flags and atomic_flags should be cleared
in blk_mq_init_rq_map().

>
>>
>> > 0. That should already be sufficient to hinder blk_mq_tag_to_rq and the calling
>> > method to do the wrong thing.
>>
>> Yes, clearing rq->cmd_flags should be enough.
>>
>> And looks better to move rq initialization to __blk_mq_free_request()
>> too, otherwise timeout still may see old cmd_flags and rq->q before
>> rq's new initialization.
>
> Yes, __blk_mq_free_request() should also reset at least rq->cmd_flags, and I
> think we can remove the initialization from  __blk_mq_alloc_request().
>
> David
>
>>
>>
>> Thanks,
>



-- 
Ming Lei
