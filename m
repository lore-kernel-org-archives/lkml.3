Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbaKROJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:09:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928AbaKROJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:35 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 074/206] kill wbuf_queued/wbuf_dwork_lock
Date: Tue, 18 Nov 2014 15:07:09 +0100
Message-Id: <ca57f7e423849774b8fbc4547c8a7f43b876216b.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 99358a1ca53e8e6ce09423500191396f0e6584d2 upstream.

schedule_delayed_work() happening when the work is already pending is
a cheap no-op.  Don't bother with ->wbuf_queued logics - it's both
broken (cancelling ->wbuf_dwork leaves it set, as spotted by Jeff Harris)
and pointless.  It's cheaper to let schedule_delayed_work() handle that
case.

Reported-by: Jeff Harris <jefftharris@gmail.com>
Tested-by: Jeff Harris <jefftharris@gmail.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/jffs2/jffs2_fs_sb.h |  2 --
 fs/jffs2/wbuf.c        | 17 ++---------------
 2 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/fs/jffs2/jffs2_fs_sb.h b/fs/jffs2/jffs2_fs_sb.h
index 413ef89c2d1b..046fee8b6e9b 100644
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
index a6597d60d76d..09ed55190ee2 100644
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
-- 
2.1.3

