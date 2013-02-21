Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab3BUCf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 21:35:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394Ab3BUCf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 21:35:27 -0500
Date: Wed, 20 Feb 2013 21:35:23 -0500
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 3.9
Message-ID: <20130221023523.GA13371@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull dlm updates from tag:

git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git dlm-3.9

This includes a single patch to avoid excessive and
unnecessary scanning of rsbs to free.  Patch copied below.

Thanks,
Dave


dlm: avoid scanning unchanged toss lists

Keep track of whether a toss list contains any
shrinkable rsbs.  If not, dlm_scand can avoid
scanning the list for rsbs to shrink.  Unnecessary
scanning can otherwise waste a lot of time because
the toss lists can contain a large number of rsbs
that are non-shrinkable (directory records).

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/dlm_internal.h |  3 +++
 fs/dlm/lock.c         | 15 +++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 77c0f70..e7665c3 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -96,10 +96,13 @@ do { \
 }
 
 
+#define DLM_RTF_SHRINK		0x00000001
+
 struct dlm_rsbtable {
 	struct rb_root		keep;
 	struct rb_root		toss;
 	spinlock_t		lock;
+	uint32_t		flags;
 };
 
 
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index a579f30..f750165 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1132,6 +1132,7 @@ static void toss_rsb(struct kref *kref)
 	rb_erase(&r->res_hashnode, &ls->ls_rsbtbl[r->res_bucket].keep);
 	rsb_insert(r, &ls->ls_rsbtbl[r->res_bucket].toss);
 	r->res_toss_time = jiffies;
+	ls->ls_rsbtbl[r->res_bucket].flags |= DLM_RTF_SHRINK;
 	if (r->res_lvbptr) {
 		dlm_free_lvb(r->res_lvbptr);
 		r->res_lvbptr = NULL;
@@ -1659,11 +1660,18 @@ static void shrink_bucket(struct dlm_ls *ls, int b)
 	char *name;
 	int our_nodeid = dlm_our_nodeid();
 	int remote_count = 0;
+	int need_shrink = 0;
 	int i, len, rv;
 
 	memset(&ls->ls_remove_lens, 0, sizeof(int) * DLM_REMOVE_NAMES_MAX);
 
 	spin_lock(&ls->ls_rsbtbl[b].lock);
+
+	if (!(ls->ls_rsbtbl[b].flags & DLM_RTF_SHRINK)) {
+		spin_unlock(&ls->ls_rsbtbl[b].lock);
+		return;
+	}
+
 	for (n = rb_first(&ls->ls_rsbtbl[b].toss); n; n = next) {
 		next = rb_next(n);
 		r = rb_entry(n, struct dlm_rsb, res_hashnode);
@@ -1679,6 +1687,8 @@ static void shrink_bucket(struct dlm_ls *ls, int b)
 			continue;
 		}
 
+		need_shrink = 1;
+
 		if (!time_after_eq(jiffies, r->res_toss_time +
 				   dlm_config.ci_toss_secs * HZ)) {
 			continue;
@@ -1710,6 +1720,11 @@ static void shrink_bucket(struct dlm_ls *ls, int b)
 		rb_erase(&r->res_hashnode, &ls->ls_rsbtbl[b].toss);
 		dlm_free_rsb(r);
 	}
+
+	if (need_shrink)
+		ls->ls_rsbtbl[b].flags |= DLM_RTF_SHRINK;
+	else
+		ls->ls_rsbtbl[b].flags &= ~DLM_RTF_SHRINK;
 	spin_unlock(&ls->ls_rsbtbl[b].lock);
 
 	/*
-- 
1.8.1.rc1.5.g7e0651a

