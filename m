Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaCGKwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:52:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:23066 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbaCGKwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:52:23 -0500
X-IronPort-AV: E=Sophos;i="4.97,607,1389715200"; 
   d="scan'208";a="9660337"
Message-ID: <5319A2DB.8040705@cn.fujitsu.com>
Date: Fri, 07 Mar 2014 18:43:39 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] f2fs: add a wait queue to avoid unnecessary, build_free_nid
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/07 18:49:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/07 18:49:45,
	Serialize complete at 2014/03/07 18:49:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, when we try to alloc free nid while the build free nid
is going, the allocer will be run into the flow that waiting for
"nm_i->build_lock", see following:
	/* We should not use stale free nids created by build_free_nids */
---->	if (nm_i->fcnt && !on_build_free_nids(nm_i)) {
		f2fs_bug_on(list_empty(&nm_i->free_nid_list));
		list_for_each(this, &nm_i->free_nid_list) {
			i = list_entry(this, struct free_nid, list);
			if (i->state == NID_NEW)
				break;
		}

		f2fs_bug_on(i->state != NID_NEW);
		*nid = i->nid;
		i->state = NID_ALLOC;
		nm_i->fcnt--;
		spin_unlock(&nm_i->free_nid_list_lock);
		return true;
	}
	spin_unlock(&nm_i->free_nid_list_lock);

	/* Let's scan nat pages and its caches to get free nids */
---->	mutex_lock(&nm_i->build_lock);
	build_free_nids(sbi);
	mutex_unlock(&nm_i->build_lock);
and this will cause another unnecessary building free nid if the current
building free nid job is done.
So here we introduce a wait_queue to avoid this issue.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/f2fs.h |    1 +
 fs/f2fs/node.c |   10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index f845e92..7ae193e 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -256,6 +256,7 @@ struct f2fs_nm_info {
 	spinlock_t free_nid_list_lock;	/* protect free nid list */
 	unsigned int fcnt;		/* the number of free node id */
 	struct mutex build_lock;	/* lock for build free nids */
+	wait_queue_head_t build_wq;	/* wait queue for build free nids */
 
 	/* for checkpoint */
 	char *nat_bitmap;		/* NAT bitmap pointer */
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 4b7861d..ab44711 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1422,7 +1422,13 @@ retry:
 	spin_lock(&nm_i->free_nid_list_lock);
 
 	/* We should not use stale free nids created by build_free_nids */
-	if (nm_i->fcnt && !on_build_free_nids(nm_i)) {
+	if (on_build_free_nids(nm_i)) {
+		spin_unlock(&nm_i->free_nid_list_lock);
+		wait_event(nm_i->build_wq, !on_build_free_nids(nm_i));
+		goto retry;
+	}
+
+	if (nm_i->fcnt) {
 		f2fs_bug_on(list_empty(&nm_i->free_nid_list));
 		list_for_each(this, &nm_i->free_nid_list) {
 			i = list_entry(this, struct free_nid, list);
@@ -1443,6 +1449,7 @@ retry:
 	mutex_lock(&nm_i->build_lock);
 	build_free_nids(sbi);
 	mutex_unlock(&nm_i->build_lock);
+	wake_up_all(&nm_i->build_wq);
 	goto retry;
 }
 
@@ -1813,6 +1820,7 @@ static int init_node_manager(struct f2fs_sb_info *sbi)
 	INIT_LIST_HEAD(&nm_i->dirty_nat_entries);
 
 	mutex_init(&nm_i->build_lock);
+	init_waitqueue_head(&nm_i->build_wq);
 	spin_lock_init(&nm_i->free_nid_list_lock);
 	rwlock_init(&nm_i->nat_tree_lock);
 
-- 
1.7.7


