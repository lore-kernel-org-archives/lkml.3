Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab3DLAGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 20:06:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab3DLAGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 20:06:43 -0400
Date: Thu, 11 Apr 2013 20:06:10 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Tejun Heo <tj@kernel.org>
cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>,
        "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: [PATCH v2] make dm and dm-crypt forward cgroup context (was:
 dm-crypt parallelization patches)
In-Reply-To: <20130411200005.GB11956@mtj.dyndns.org>
Message-ID: <Pine.LNX.4.64.1304111943450.29691@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1304091450410.26327@file.rdu.redhat.com>
 <20130409195259.GL6186@mtj.dyndns.org> <Pine.LNX.4.64.1304091624110.19672@file.rdu.redhat.com>
 <20130409210735.GR6320@redhat.com> <Pine.LNX.4.64.1304091710150.24735@file.rdu.redhat.com>
 <20130410192427.GA14911@redhat.com> <Pine.LNX.4.64.1304101938280.24258@file.rdu.redhat.com>
 <20130410235009.GI17641@mtj.dyndns.org> <Pine.LNX.4.64.1304111544050.32536@file.rdu.redhat.com>
 <20130411195203.GA11956@mtj.dyndns.org> <20130411200005.GB11956@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Apr 2013, Tejun Heo wrote:

> On Thu, Apr 11, 2013 at 12:52:03PM -0700, Tejun Heo wrote:
> > If this becomes an actual bottleneck, the right thing to do is making
> > css ref per-cpu.  Please stop messing around with refcounting.
> 
> If you think this kind of hackery is acceptable, you really need to
> re-evaluate your priorities in making engineering decisions.  In
> tightly coupled code, maybe, but you're trying to introduce utterly
> broken error-prone thing as a generic block layer API.  I mean, are
> you for real?
> 
> -- 
> tejun

All that I can tell you is that adding an empty atomic operation 
"cmpxchg(&bio->bi_css->refcnt, bio->bi_css->refcnt, bio->bi_css->refcnt);" 
to bio_clone_context and bio_disassociate_task increases the time to run a 
benchmark from 23 to 40 seconds.

Every single atomic reference in the block layer is measurable.



How did I measure it:

(1) use dm SRCU patches 
(http://people.redhat.com/~mpatocka/patches/kernel/dm-lock-optimization/) 
that replace some atomic accesses in device mapper with SRCU. The patches 
will likely be included in the kernel to improve performance.

(2) use the patch v2 that I posted in this thread

(3) add bio_associate_current(bio) to _dm_request (so that each bio is 
associated with a process even if it is not offloaded to a workqueue)

(4) change bio_clone_context to actually increase reference counts:
static inline void bio_clone_context(struct bio *bio, struct bio *bio_src)
{
#ifdef CONFIG_BLK_CGROUP
        BUG_ON(bio->bi_ioc != NULL);
        if (bio_src->bi_ioc) {
                get_io_context_active(bio_src->bi_ioc);
                bio->bi_ioc = bio_src->bi_ioc;
                if (bio_src->bi_css && css_tryget(bio_src->bi_css)) {
                        bio->bi_css = bio_src->bi_css;
                }
                bio->bi_flags |= 1UL << BIO_DROP_CGROUP_REFCOUNT;
        }
#endif
}

(5) add "cmpxchg(&bio->bi_css->refcnt, bio->bi_css->refcnt, 
bio->bi_css->refcnt)" to bio_clone_context and bio_disassociate_task


Now, measuring:
- create 4GiB ramdisk, fill it with dd so that it is allocated
- create 5 nested device mapper linear targets on it
- run "time fio --rw=randrw --size=1G --bs=512 
	--filename=/dev/mapper/linear5 --direct=1 --name=job1 --name=job2 
	--name=job3 --name=job4 --name=job5 --name=job6 --name=job7 
	--name=job8 --name=job9 --name=job10 --name=job11 --name=job12"
(it was ran on 12-core machine, so there are 12 concurrent jobs)


If I measure kernel (4), the benchmark takes 23 seconds. For kernel (5) it 
takes 40 seconds.

Mikulas
