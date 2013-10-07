Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab3JGAOQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 20:14:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919Ab3JGAOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 20:14:14 -0400
Date: Sun, 6 Oct 2013 20:14:10 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH 16/22] dm: Refactor for new bio cloning/splitting
Message-ID: <20131007001410.GA14264@redhat.com>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com>
 <1375912471-5106-17-git-send-email-kmo@daterainc.com>
 <20130928045909.GA19745@redhat.com>
 <20131003031738.GA27418@kmo-pixel>
 <20131003032320.GA15322@redhat.com>
 <20131003214525.GA12183@kmo-pixel>
 <20131003225009.GA24173@redhat.com>
 <20131004170732.GA30728@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004170732.GA30728@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04 2013 at  1:07pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:
 
> With your latest fix I was able to create a thin device and format with
> XFS.  Unfortunately, when I tried to run the thinp-test-suite the very
> first BasicTests test (test_dd_benchmark) fails -- need to look closer
> but it would seem to me the thinp saved bio_endio path isn't happy.  We
> likely need an appropriately placed atomic_inc(&bio->bi_remaining); like
> you did in dm-cache-target.c
> 
> ------------[ cut here ]------------
> kernel BUG at fs/bio.c:1722!
...
> Call Trace:
>  [<ffffffffa05f2ef9>] process_prepared_mapping+0x79/0x150 [dm_thin_pool]
>  [<ffffffffa05f2ba7>] process_prepared+0x87/0xa0 [dm_thin_pool]
>  [<ffffffffa05f58f3>] do_worker+0x33/0x60 [dm_thin_pool]
>  [<ffffffff81067862>] process_one_work+0x182/0x3b0
>  [<ffffffff81068c80>] worker_thread+0x120/0x3a0
>  [<ffffffff81068b60>] ? manage_workers+0x160/0x160
>  [<ffffffff8106eace>] kthread+0xce/0xe0
>  [<ffffffff8106ea00>] ? kthread_freezable_should_stop+0x70/0x70
>  [<ffffffff8152b1ac>] ret_from_fork+0x7c/0xb0
>  [<ffffffff8106ea00>] ? kthread_freezable_should_stop+0x70/0x70
> Code: 1f 84 00 00 00 00 00 48 8b 57 10 83 e2 01 0f 44 f1 eb cd 0f 1f 40 00 48 8b 7f 50 48 85 ff 74 dd 8b 57 44 48 8d 47 44 85 d2 7f ac <0f> 0b eb fe 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 66 66 66 90 
> RIP  [<ffffffff811b1464>] bio_endio+0x74/0x80
>  RSP <ffff88032c5e7d48>
> ---[ end trace acb5a7d638591b7b ]---

Please fold this fix into your for-jens branch, thanks.  (Could be that
by the time Jens takes your immutable biovec changes we'll need to
rebase but at least it won't slip through the cracks).

---
 drivers/md/dm-thin.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index a654024..1abb4a2 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -611,8 +611,10 @@ static void cell_defer_no_holder(struct thin_c *tc, struct dm_bio_prison_cell *c
 
 static void process_prepared_mapping_fail(struct dm_thin_new_mapping *m)
 {
-	if (m->bio)
+	if (m->bio) {
 		m->bio->bi_end_io = m->saved_bi_end_io;
+		atomic_inc(&m->bio->bi_remaining);
+	}
 	cell_error(m->tc->pool, m->cell);
 	list_del(&m->list);
 	mempool_free(m, m->tc->pool->mapping_pool);
@@ -626,8 +628,10 @@ static void process_prepared_mapping(struct dm_thin_new_mapping *m)
 	int r;
 
 	bio = m->bio;
-	if (bio)
+	if (bio) {
 		bio->bi_end_io = m->saved_bi_end_io;
+		atomic_inc(&bio->bi_remaining);
+	}
 
 	if (m->err) {
 		cell_error(pool, m->cell);
