Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935931Ab3DITmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:42:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934655Ab3DITmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:42:50 -0400
Date: Tue, 9 Apr 2013 15:42:16 -0400 (EDT)
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
In-Reply-To: <20130409181031.GC6186@mtj.dyndns.org>
Message-ID: <Pine.LNX.4.64.1304091450410.26327@file.rdu.redhat.com>
References: <5151FF82.6090405@gmail.com> <20130326202837.GA5599@redhat.com>
 <20130328185327.GF14088@htj.dyndns.org> <20130328193343.GA15969@redhat.com>
 <20130328194443.GG14088@htj.dyndns.org> <20130328203808.GC15969@redhat.com>
 <20130328204522.GA25501@mtj.dyndns.org> <Pine.LNX.4.64.1304091242350.10025@file.rdu.redhat.com>
 <20130409175753.GA6186@mtj.dyndns.org> <Pine.LNX.4.64.1304091402150.10025@file.rdu.redhat.com>
 <20130409181031.GC6186@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 9 Apr 2013, Tejun Heo wrote:

> Hey,
> 
> On Tue, Apr 09, 2013 at 02:08:06PM -0400, Mikulas Patocka wrote:
> > > Hmmm? Why not just keep the issuing order along with plugging
> > > boundaries?
> > 
> > What do you mean?
> > 
> > I used to have a patch that keeps order of requests as they were 
> > introduced, but sorting the requests according to sector number is a bit 
> > simpler.
> 
> You're still destroying the context information.  Please just keep the
> issuing order along with plugging boundaries.
>
> > > As I wrote before, please use bio_associate_current().  Currently,
> > > dm-crypt is completely messing up all the context information that cfq
> > > depends on to schedule IOs.  Of course, it doesn't perform well.
> > 
> > bio_associate_current() is only valid on a system with cgroups and there 
> > are no cgroups on the kernel where I tested it. It is an empty function:
> > 
> > static inline int bio_associate_current(struct bio *bio) { return -ENOENT; }
> 
> Yeah, because blkcg was the only user.  Please feel free to drop the
> ifdefs.  It covers both iocontext and cgroup association.
> 
> Thanks.

If I drop ifdefs, it doesn't compile (because other cgroup stuff it 
missing).

So I enabled bio cgroups.

bio_associate_current can't be used, because by the time we allocate the 
outgoing write bio, we are no longer in the process that submitted the 
original bio.

Anyway, I tried to reproduce in dm-crypt what bio_associate_current does - 
in the submitting process I record "ioc" and "css" fields in "dm_crypt_io" 
structure and set these fields on all outgoing bios. It has no effect on 
performance, it is as bad as if I hadn't done it.

Mikulas

---
(this is the patch that I used, to be applied after 
dm-crypt-unbound-workqueue.patch)

---
 drivers/md/dm-crypt.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

Index: linux-3.8.6-fast/drivers/md/dm-crypt.c
===================================================================
--- linux-3.8.6-fast.orig/drivers/md/dm-crypt.c	2013-04-09 20:32:41.000000000 +0200
+++ linux-3.8.6-fast/drivers/md/dm-crypt.c	2013-04-09 21:29:12.000000000 +0200
@@ -20,6 +20,7 @@
 #include <linux/backing-dev.h>
 #include <linux/atomic.h>
 #include <linux/scatterlist.h>
+#include <linux/cgroup.h>
 #include <asm/page.h>
 #include <asm/unaligned.h>
 #include <crypto/hash.h>
@@ -60,6 +61,9 @@ struct dm_crypt_io {
 	int error;
 	sector_t sector;
 	struct dm_crypt_io *base_io;
+
+	struct io_context *ioc;
+	struct cgroup_subsys_state *css;
 };
 
 struct dm_crypt_request {
@@ -797,6 +801,14 @@ static struct bio *crypt_alloc_buffer(st
 	if (!clone)
 		return NULL;
 
+	if (unlikely(io->base_io != NULL)) {
+		clone->bi_ioc = io->base_io->ioc;
+		clone->bi_css = io->base_io->css;
+	} else {
+		clone->bi_ioc = io->ioc;
+		clone->bi_css = io->css;
+	}
+
 	clone_init(io, clone);
 	*out_of_pages = 0;
 
@@ -859,6 +871,9 @@ static struct dm_crypt_io *crypt_io_allo
 	io->ctx.req = NULL;
 	atomic_set(&io->io_pending, 0);
 
+	io->ioc = NULL;
+	io->css = NULL;
+
 	return io;
 }
 
@@ -884,6 +899,14 @@ static void crypt_dec_pending(struct dm_
 
 	if (io->ctx.req)
 		mempool_free(io->ctx.req, cc->req_pool);
+
+	if (io->ioc) {
+		put_io_context(io->ioc);
+	}
+	if (io->css) {
+		css_put(io->css);
+	}
+
 	mempool_free(io, cc->io_pool);
 
 	if (likely(!base_io))
@@ -927,6 +950,9 @@ static void crypt_endio(struct bio *clon
 	if (rw == WRITE)
 		crypt_free_buffer_pages(cc, clone);
 
+	clone->bi_ioc = NULL;
+	clone->bi_css = NULL;
+
 	bio_put(clone);
 
 	if (rw == READ && !error) {
@@ -1658,6 +1684,21 @@ static int crypt_map(struct dm_target *t
 
 	io = crypt_io_alloc(cc, bio, dm_target_offset(ti, bio->bi_sector));
 
+	if (current->io_context) {
+		struct io_context *ioc = current->io_context;
+		struct cgroup_subsys_state *css;
+
+		get_io_context_active(ioc);
+		io->ioc = ioc;
+
+		/* associate blkcg if exists */
+		rcu_read_lock();
+		css = task_subsys_state(current, blkio_subsys_id);
+		if (css && css_tryget(css))
+			io->css = css;
+		rcu_read_unlock();
+	}
+
 	if (bio_data_dir(io->base_bio) == READ) {
 		if (kcryptd_io_read(io, GFP_NOWAIT))
 			kcryptd_queue_io(io);
