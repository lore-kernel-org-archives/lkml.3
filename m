Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbaIQMAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 08:00:52 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:58245 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbaIQMAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 08:00:50 -0400
Date: Wed, 17 Sep 2014 14:00:34 +0200
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Ming Lei <tom.leiming@gmail.com>, rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        KVM list <kvm@vger.kernel.org>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org >> Linux Kernel Mailing List" 
	<linux-kernel@vger.kernel.org>
Subject: Re: blk-mq crash under KVM in multiqueue block code (with
 virtio-blk and ext4)
Message-ID: <20140917140034.10125d00@thinkpad-w530>
In-Reply-To: <54193F4F.9060508@de.ibm.com>
References: <541178D6.6010303@de.ibm.com>
	<CACVXFVO7Oo9GeagPhejngfoeySxOP4EqWz_GN6kYv2956-Wtxg@mail.gmail.com>
	<541352ED.7030800@de.ibm.com>
	<54193F4F.9060508@de.ibm.com>
Organization: IBM Deutschland
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091712-1948-0000-0000-000001273E14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>> Does anyone have an idea?
> >>> The request itself is completely filled with cc
> >>
> >> That is very weird, the 'rq' is got from hctx->tags,  and rq should be
> >> valid, and rq->q shouldn't have been changed even though it was
> >> double free or double allocation.
> >>
> >>> I am currently asking myself if blk_mq_map_request should protect against softirq here but I cant say for sure,as I have never looked into that code before.
> >>
> >> No, it needn't the protection.
> >>
> >> Thanks,
> >>
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe kvm" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 

Digging through the code, I think I found a possible cause:

tags->rqs[..] is not initialized with zeroes (via alloc_pages_node in
blk-mq.c:blk_mq_init_rq_map()).

When a request is created:

1. __blk_mq_alloc_request() gets a free tag (thus e.g. removing it from
bitmap_tags)

2. __blk_mq_alloc_request() initializes is via blk_mq_rq_ctx_init(). The struct
is filled with life and rq->q is set.


When blk_mq_hw_ctx_check_timeout() is called:

1. blk_mq_tag_busy_iter() is used to call blk_mq_timeout_check() on all busy
tags.

2. This is done by collecting all free tags using bt_for_each_free() and
handing them to blk_mq_timeout_check(). This uses bitmap_tags.

3. blk_mq_timeout_check() calls  blk_mq_tag_to_rq() to get the rq.


Could we have a race between

- getting the tag (turning it busy) and initializing it and
- detecting a tag to be busy and trying to access it?


I haven't looked at the details yet. If so, we might either do some locking
(if there is existing infrastructure), or somehow mark a request as not being
initialized prior to accessing the data.

