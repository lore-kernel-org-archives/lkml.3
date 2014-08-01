Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbaHATOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 15:14:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58811 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270AbaHATOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 15:14:06 -0400
Date: Fri, 1 Aug 2014 20:13:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeff Harris <jefftharris@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jeff Harris <jharris@westell.com>
Subject: Re: [PATCH] jffs2: Re-enable write-buffering after filesystem sync
Message-ID: <20140801191340.GN18016@ZenIV.linux.org.uk>
References: <1406909172-7219-1-git-send-email-jharris@westell.com>
 <20140801165607.GM18016@ZenIV.linux.org.uk>
 <CAGMfbUPOMKVkZuZtzoN-w5pTpjHMzYhrdaM2WuBdm7RSMsNYAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGMfbUPOMKVkZuZtzoN-w5pTpjHMzYhrdaM2WuBdm7RSMsNYAw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 01:15:45PM -0400, Jeff Harris wrote:
> On Fri, Aug 1, 2014 at 12:56 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > On Fri, Aug 01, 2014 at 12:06:12PM -0400, Jeff Harris wrote:
> >
> > > +     spin_lock(&c->wbuf_dwork_lock);
> > >       cancel_delayed_work_sync(&c->wbuf_dwork);
> >
> > Umm...  Usually ..._sync in function name is a sign of potential sleeper,
> > and calling those under a spinlock is a bad idea.
> >
> > And looking at the definition of cancel_delayed_work_sync() turns up the
> > following call chain: cancel_delayed_work_sync() -> __cancel_work_timer() ->
> > flush_work() -> wait_for_completion(), which definitely isn't something
> > you should ever do under a spinlock.
> 
> The jffs2_dirty_trigger function calls queue_delayed_work under the spinlock.
> I suppose the flag could be reset after the cancel so the dirty
> trigger would see
> the false value.

Why do we need ->wbuf_queued, anyway?  It's not as if queue_delayed_work()
wouldn't do the right thing - if the sucker already has WORK_STRUCT_PENDING_BIT
set it'll simply do nothing.  And it won't spend much time finding that
out - in fact, it'll be cheaper than what we do right now.

IOW, how about the following (completely untested):

[jffs2] kill wbuf_queued/wbuf_dwork_lock

schedule_delayed_work() happening when the work is already pending is
a cheap no-op.  Don't bother with ->wbuf_queued logics - it's both
broken (cancelling ->wbuf_dwork leaves it set, as spotted by Jeff Harris)
and pointless.  It's cheaper to let schedule_delayed_work() handle that
case.

Reported-by: Jeff Harris <jefftharris@gmail.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---

diff --git a/fs/jffs2/jffs2_fs_sb.h b/fs/jffs2/jffs2_fs_sb.h
index 413ef89..046fee8 100644
--- a/fs/jffs2/jffs2_fs_sb.h
+++ b/fs/jffs2/jffs2_fs_sb.h
@@ -134,8 +134,6 @@ struct jffs2_sb_info {
 	struct rw_semaphore wbuf_sem;	/* Protects the write buffer */
 
 	struct delayed_work wbuf_dwork; /* write-buffer write-out work */
-	int wbuf_queued;                /* non-zero delayed work is queued */
-	spinlock_t wbuf_dwork_lock;     /* protects wbuf_dwork and and wbuf_queued */
 
 	unsigned char *oobbuf;
 	int oobavail; /* How many bytes are available for JFFS2 in OOB */
diff --git a/fs/jffs2/wbuf.c b/fs/jffs2/wbuf.c
index a6597d6..09ed551 100644
--- a/fs/jffs2/wbuf.c
+++ b/fs/jffs2/wbuf.c
@@ -1162,10 +1162,6 @@ static void delayed_wbuf_sync(struct work_struct *work)
 	struct jffs2_sb_info *c = work_to_sb(work);
 	struct super_block *sb = OFNI_BS_2SFFJ(c);
 
-	spin_lock(&c->wbuf_dwork_lock);
-	c->wbuf_queued = 0;
-	spin_unlock(&c->wbuf_dwork_lock);
-
 	if (!(sb->s_flags & MS_RDONLY)) {
 		jffs2_dbg(1, "%s()\n", __func__);
 		jffs2_flush_wbuf_gc(c, 0);
@@ -1180,14 +1176,9 @@ void jffs2_dirty_trigger(struct jffs2_sb_info *c)
 	if (sb->s_flags & MS_RDONLY)
 		return;
 
-	spin_lock(&c->wbuf_dwork_lock);
-	if (!c->wbuf_queued) {
+	delay = msecs_to_jiffies(dirty_writeback_interval * 10);
+	if (queue_delayed_work(system_long_wq, &c->wbuf_dwork, delay))
 		jffs2_dbg(1, "%s()\n", __func__);
-		delay = msecs_to_jiffies(dirty_writeback_interval * 10);
-		queue_delayed_work(system_long_wq, &c->wbuf_dwork, delay);
-		c->wbuf_queued = 1;
-	}
-	spin_unlock(&c->wbuf_dwork_lock);
 }
 
 int jffs2_nand_flash_setup(struct jffs2_sb_info *c)
@@ -1211,7 +1202,6 @@ int jffs2_nand_flash_setup(struct jffs2_sb_info *c)
 
 	/* Initialise write buffer */
 	init_rwsem(&c->wbuf_sem);
-	spin_lock_init(&c->wbuf_dwork_lock);
 	INIT_DELAYED_WORK(&c->wbuf_dwork, delayed_wbuf_sync);
 	c->wbuf_pagesize = c->mtd->writesize;
 	c->wbuf_ofs = 0xFFFFFFFF;
@@ -1251,7 +1241,6 @@ int jffs2_dataflash_setup(struct jffs2_sb_info *c) {
 
 	/* Initialize write buffer */
 	init_rwsem(&c->wbuf_sem);
-	spin_lock_init(&c->wbuf_dwork_lock);
 	INIT_DELAYED_WORK(&c->wbuf_dwork, delayed_wbuf_sync);
 	c->wbuf_pagesize =  c->mtd->erasesize;
 
@@ -1311,7 +1300,6 @@ int jffs2_nor_wbuf_flash_setup(struct jffs2_sb_info *c) {
 
 	/* Initialize write buffer */
 	init_rwsem(&c->wbuf_sem);
-	spin_lock_init(&c->wbuf_dwork_lock);
 	INIT_DELAYED_WORK(&c->wbuf_dwork, delayed_wbuf_sync);
 
 	c->wbuf_pagesize = c->mtd->writesize;
@@ -1346,7 +1334,6 @@ int jffs2_ubivol_setup(struct jffs2_sb_info *c) {
 		return 0;
 
 	init_rwsem(&c->wbuf_sem);
-	spin_lock_init(&c->wbuf_dwork_lock);
 	INIT_DELAYED_WORK(&c->wbuf_dwork, delayed_wbuf_sync);
 
 	c->wbuf_pagesize =  c->mtd->writesize;
