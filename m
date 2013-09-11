Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab3IKE5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:57:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab3IKE4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:51 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=V2jkSEUCXtIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=qrYaVfwdBXIA:10 a=WTJdmG3rAAAA:8 a=bLk-5xynAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=tmtSDGaQAAAA:8 a=bcknSZiNOaeBCE6MWl8A:9 a=nsF78Xlgl7EA:10 a=jmiJ5L-mA5YA:10 a=jEp0ucaQiEUA:10 a=jkObVMfX7fAA:10 a=jeBq3FmKZ4MA:10 a=mzQoJvK5OvAZnhzu:21 a=dHCwh4z3AjBy03St:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042931.317193443@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:31:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Roland Dreier <roland@purestorage.com>,
        David Milburn <dmilburn@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [235/251] sg: Fix user memory corruption when SG_IO is interrupted by a signal
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0235-sg-Fix-user-memory-corruption-when-SG_IO-is-interrup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

[ Upstream commit 35dc248383bbab0a7203fca4d722875bc81ef091 ]

There is a nasty bug in the SCSI SG_IO ioctl that in some circumstances
leads to one process writing data into the address space of some other
random unrelated process if the ioctl is interrupted by a signal.
What happens is the following:

 - A process issues an SG_IO ioctl with direction DXFER_FROM_DEV (ie the
   underlying SCSI command will transfer data from the SCSI device to
   the buffer provided in the ioctl)

 - Before the command finishes, a signal is sent to the process waiting
   in the ioctl.  This will end up waking up the sg_ioctl() code:

		result = wait_event_interruptible(sfp->read_wait,
			(srp_done(sfp, srp) || sdp->detached));

   but neither srp_done() nor sdp->detached is true, so we end up just
   setting srp->orphan and returning to userspace:

		srp->orphan = 1;
		write_unlock_irq(&sfp->rq_list_lock);
		return result;	/* -ERESTARTSYS because signal hit process */

   At this point the original process is done with the ioctl and
   blithely goes ahead handling the signal, reissuing the ioctl, etc.

 - Eventually, the SCSI command issued by the first ioctl finishes and
   ends up in sg_rq_end_io().  At the end of that function, we run through:

	write_lock_irqsave(&sfp->rq_list_lock, iflags);
	if (unlikely(srp->orphan)) {
		if (sfp->keep_orphan)
			srp->sg_io_owned = 0;
		else
			done = 0;
	}
	srp->done = done;
	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);

	if (likely(done)) {
		/* Now wake up any sg_read() that is waiting for this
		 * packet.
		 */
		wake_up_interruptible(&sfp->read_wait);
		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
		kref_put(&sfp->f_ref, sg_remove_sfp);
	} else {
		INIT_WORK(&srp->ew.work, sg_rq_end_io_usercontext);
		schedule_work(&srp->ew.work);
	}

   Since srp->orphan *is* set, we set done to 0 (assuming the
   userspace app has not set keep_orphan via an SG_SET_KEEP_ORPHAN
   ioctl), and therefore we end up scheduling sg_rq_end_io_usercontext()
   to run in a workqueue.

 - In workqueue context we go through sg_rq_end_io_usercontext() ->
   sg_finish_rem_req() -> blk_rq_unmap_user() -> ... ->
   bio_uncopy_user() -> __bio_copy_iov() -> copy_to_user().

   The key point here is that we are doing copy_to_user() on a
   workqueue -- that is, we're on a kernel thread with current->mm
   equal to whatever random previous user process was scheduled before
   this kernel thread.  So we end up copying whatever data the SCSI
   command returned to the virtual address of the buffer passed into
   the original ioctl, but it's quite likely we do this copying into a
   different address space!

As suggested by James Bottomley <James.Bottomley@hansenpartnership.com>,
add a check for current->mm (which is NULL if we're on a kernel thread
without a real userspace address space) in bio_uncopy_user(), and skip
the copy if we're on a kernel thread.

There's no reason that I can think of for any caller of bio_uncopy_user()
to want to do copying on a kernel thread with a random active userspace
address space.

Huge thanks to Costa Sapuntzakis <costa@purestorage.com> for the
original pointer to this bug in the sg code.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Tested-by: David Milburn <dmilburn@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/bio.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 71072ab..6e2a362 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -791,12 +791,22 @@ static int __bio_copy_iov(struct bio *bio, struct bio_vec *iovecs,
 int bio_uncopy_user(struct bio *bio)
 {
 	struct bio_map_data *bmd = bio->bi_private;
-	int ret = 0;
+	struct bio_vec *bvec;
+	int ret = 0, i;
 
-	if (!bio_flagged(bio, BIO_NULL_MAPPED))
-		ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs,
-				     bmd->nr_sgvecs, bio_data_dir(bio) == READ,
-				     0, bmd->is_our_pages);
+	if (!bio_flagged(bio, BIO_NULL_MAPPED)) {
+		/*
+		 * if we're in a workqueue, the request is orphaned, so
+		 * don't copy into a random user address space, just free.
+		 */
+		if (current->mm)
+			ret = __bio_copy_iov(bio, bmd->iovecs, bmd->sgvecs,
+					     bmd->nr_sgvecs, bio_data_dir(bio) == READ,
+					     0, bmd->is_our_pages);
+		else if (bmd->is_our_pages)
+			__bio_for_each_segment(bvec, bio, i, 0)
+				__free_page(bvec->bv_page);
+	}
 	bio_free_map_data(bmd);
 	bio_put(bio);
 	return ret;
-- 
1.7.10.4


