Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936206Ab3DIUcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:32:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933489Ab3DIUcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:32:50 -0400
Date: Tue, 9 Apr 2013 16:32:28 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Tejun Heo <tj@kernel.org>
cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>
Subject: Re: dm-crypt parallelization patches
In-Reply-To: <20130409195259.GL6186@mtj.dyndns.org>
Message-ID: <Pine.LNX.4.64.1304091624110.19672@file.rdu.redhat.com>
References: <20130328185327.GF14088@htj.dyndns.org> <20130328193343.GA15969@redhat.com>
 <20130328194443.GG14088@htj.dyndns.org> <20130328203808.GC15969@redhat.com>
 <20130328204522.GA25501@mtj.dyndns.org> <Pine.LNX.4.64.1304091242350.10025@file.rdu.redhat.com>
 <20130409175753.GA6186@mtj.dyndns.org> <Pine.LNX.4.64.1304091402150.10025@file.rdu.redhat.com>
 <20130409181031.GC6186@mtj.dyndns.org> <Pine.LNX.4.64.1304091450410.26327@file.rdu.redhat.com>
 <20130409195259.GL6186@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 9 Apr 2013, Tejun Heo wrote:

> On Tue, Apr 09, 2013 at 03:42:16PM -0400, Mikulas Patocka wrote:
> > If I drop ifdefs, it doesn't compile (because other cgroup stuff it 
> > missing).
> > 
> > So I enabled bio cgroups.
> > 
> > bio_associate_current can't be used, because by the time we allocate the 
> > outgoing write bio, we are no longer in the process that submitted the 
> > original bio.
> 
> Oh, I suppose it'd need some massaging to selectively turn off the
> cgroup part.
> 
> > Anyway, I tried to reproduce in dm-crypt what bio_associate_current does - 
> 
> and we probably need to change that to bio_associate_task().

Generally, we shouldn't associate bios with "current" task in device 
mapper targets. For example suppose that we have two stacked dm-crypt 
targets:

In the "current" process pointer in lower dm-crypt target's request 
function always points to the workqueue of the upper dm-crypt target that 
submits the bios. So if we associate the bio with "current" in the lower 
target, we are associating it with a preallocated workqueue and we already 
lost the information who submitted it.

You should associate a bio with a task when you create the bio and "md" 
and "dm" midlayers should just forward this association to lower layer 
bios.

> > in the submitting process I record "ioc" and "css" fields in "dm_crypt_io" 
> > structure and set these fields on all outgoing bios. It has no effect on 
> > performance, it is as bad as if I hadn't done it.
> 
> A good way to verify that the tagging is correct would be configuring
> io limits in block cgroup and see whether the limits are correctly
> applied when going through dm-crypt (please test with direct-io or
> reads, writeback is horribly broken, sorry).working correctly, maybe
> plugging is the overriding factor?
> 
> Thanks.

It doesn't work because device mapper on the underlying layers ignores 
bi_ioc and bi_css.

If I make device mapper forward bi_ioc and bi_css to outgoing bios, it 
improves performance (from 2:30 to 1:30), but it is still far from 
perfect.

Mikulas

---

dm: forward cgroup context

This patch makes dm forward associated cgroup context to cloned bios.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |    9 +++++++++
 fs/bio.c        |    2 ++
 2 files changed, 11 insertions(+)

Index: linux-3.8.6-fast/drivers/md/dm.c
===================================================================
--- linux-3.8.6-fast.orig/drivers/md/dm.c	2013-04-09 22:00:36.000000000 +0200
+++ linux-3.8.6-fast/drivers/md/dm.c	2013-04-09 22:19:40.000000000 +0200
@@ -453,6 +453,10 @@ static void free_io(struct mapped_device
 
 static void free_tio(struct mapped_device *md, struct dm_target_io *tio)
 {
+#ifdef CONFIG_BLK_CGROUP
+	tio->clone.bi_ioc = NULL;
+	tio->clone.bi_css = NULL;
+#endif
 	bio_put(&tio->clone);
 }
 
@@ -1124,6 +1128,11 @@ static struct dm_target_io *alloc_tio(st
 	clone = bio_alloc_bioset(GFP_NOIO, nr_iovecs, ci->md->bs);
 	tio = container_of(clone, struct dm_target_io, clone);
 
+#ifdef CONFIG_BLK_CGROUP
+	tio->clone.bi_ioc = ci->bio->bi_ioc;
+	tio->clone.bi_css = ci->bio->bi_css;
+#endif
+
 	tio->io = ci->io;
 	tio->ti = ti;
 	memset(&tio->info, 0, sizeof(tio->info));
