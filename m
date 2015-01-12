Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbbALUVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:21:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbbALUVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:21:05 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [patch] cfq-iosched: fix incorrect filing of rt async cfqq
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 12 Jan 2015 15:21:01 -0500
Message-ID: <x494mrvu4wi.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If you can manage to submit an async write as the first async I/O from
the context of a process with realtime scheduling priority, then a
cfq_queue is allocated, but filed into the wrong async_cfqq bucket.  It
ends up in the best effort array, but actually has realtime I/O
scheduling priority set in cfqq->ioprio.

The reason is that cfq_get_queue assumes the default scheduling class and
priority when there is no information present (i.e. when the async cfqq
is created):

static struct cfq_queue *
cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
	      struct bio *bio, gfp_t gfp_mask)
{
	const int ioprio_class = IOPRIO_PRIO_CLASS(cic->ioprio);
	const int ioprio = IOPRIO_PRIO_DATA(cic->ioprio);

cic->ioprio starts out as 0, which is "invalid".  So, class of 0
(IOPRIO_CLASS_NONE) is passed to cfq_async_queue_prio like so:

		async_cfqq = cfq_async_queue_prio(cfqd, ioprio_class, ioprio);

static struct cfq_queue **
cfq_async_queue_prio(struct cfq_data *cfqd, int ioprio_class, int ioprio)
{
        switch (ioprio_class) {
        case IOPRIO_CLASS_RT:
                return &cfqd->async_cfqq[0][ioprio];
        case IOPRIO_CLASS_NONE:
                ioprio = IOPRIO_NORM;
                /* fall through */
        case IOPRIO_CLASS_BE:
                return &cfqd->async_cfqq[1][ioprio];
        case IOPRIO_CLASS_IDLE:
                return &cfqd->async_idle_cfqq;
        default:
                BUG();
        }
}

Here, instead of returning a class mapped from the process' scheduling
priority, we get back the bucket associated with IOPRIO_CLASS_BE.

Now, there is no queue allocated there yet, so we create it:

		cfqq = cfq_find_alloc_queue(cfqd, is_sync, cic, bio, gfp_mask);

That function ends up doing this:

			cfq_init_cfqq(cfqd, cfqq, current->pid, is_sync);
			cfq_init_prio_data(cfqq, cic);

cfq_init_cfqq marks the priority as having changed.  Then, cfq_init_prio
data does this:

	ioprio_class = IOPRIO_PRIO_CLASS(cic->ioprio);
	switch (ioprio_class) {
	default:
		printk(KERN_ERR "cfq: bad prio %x\n", ioprio_class);
	case IOPRIO_CLASS_NONE:
		/*
		 * no prio set, inherit CPU scheduling settings
		 */
		cfqq->ioprio = task_nice_ioprio(tsk);
		cfqq->ioprio_class = task_nice_ioclass(tsk);
		break;

So we basically have two code paths that treat IOPRIO_CLASS_NONE
differently, which results in an RT async cfqq filed into a best effort
bucket.

Attached is a patch which fixes the problem.  I'm not sure how to make
it cleaner.  Suggestions would be welcome.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 6f2751d..b9abdca 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3656,12 +3656,17 @@ static struct cfq_queue *
 cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 	      struct bio *bio, gfp_t gfp_mask)
 {
-	const int ioprio_class = IOPRIO_PRIO_CLASS(cic->ioprio);
-	const int ioprio = IOPRIO_PRIO_DATA(cic->ioprio);
+	int ioprio_class = IOPRIO_PRIO_CLASS(cic->ioprio);
+	int ioprio = IOPRIO_PRIO_DATA(cic->ioprio);
 	struct cfq_queue **async_cfqq = NULL;
 	struct cfq_queue *cfqq = NULL;
 
 	if (!is_sync) {
+		if (!ioprio_valid(cic->ioprio)) {
+			struct task_struct *tsk = current;
+			ioprio = task_nice_ioprio(tsk);
+			ioprio_class = task_nice_ioclass(tsk);
+		}
 		async_cfqq = cfq_async_queue_prio(cfqd, ioprio_class, ioprio);
 		cfqq = *async_cfqq;
 	}
