Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab3FMEFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 00:05:14 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:60486 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab3FMEFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 00:05:10 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        koverstreet@google.com, linux-kernel@vger.kernel.org,
        cl@linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/11] cgroup: use kzalloc() instead of kmalloc()
Date: Wed, 12 Jun 2013 21:04:51 -0700
Message-Id: <1371096298-24402-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371096298-24402-1-git-send-email-tj@kernel.org>
References: <1371096298-24402-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no point in using kmalloc() instead of the clearing variant
for trivial stuff.  We can live dangerously elsewhere.  Use kzalloc()
instead and drop 0 inits.

While at it, do trivial code reorganization in cgroup_file_open().

This patch doesn't introduce any functional changes.

v2: I was caught in the very distant past where list_del() didn't
    poison and the initial version converted list_del()s to
    list_del_init()s too.  Li and Kent took me out of the stasis
    chamber.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Kent Overstreet <koverstreet@google.com>
---
 kernel/cgroup.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0b5cd0e..e308ee7 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -597,7 +597,7 @@ static int allocate_cgrp_cset_links(int count, struct list_head *tmp_links)
 	INIT_LIST_HEAD(tmp_links);
 
 	for (i = 0; i < count; i++) {
-		link = kmalloc(sizeof(*link), GFP_KERNEL);
+		link = kzalloc(sizeof(*link), GFP_KERNEL);
 		if (!link) {
 			free_cgrp_cset_links(tmp_links);
 			return -ENOMEM;
@@ -658,7 +658,7 @@ static struct css_set *find_css_set(struct css_set *old_cset,
 	if (cset)
 		return cset;
 
-	cset = kmalloc(sizeof(*cset), GFP_KERNEL);
+	cset = kzalloc(sizeof(*cset), GFP_KERNEL);
 	if (!cset)
 		return NULL;
 
@@ -2478,10 +2478,12 @@ static int cgroup_file_open(struct inode *inode, struct file *file)
 	cft = __d_cft(file->f_dentry);
 
 	if (cft->read_map || cft->read_seq_string) {
-		struct cgroup_seqfile_state *state =
-			kzalloc(sizeof(*state), GFP_USER);
+		struct cgroup_seqfile_state *state;
+
+		state = kzalloc(sizeof(*state), GFP_USER);
 		if (!state)
 			return -ENOMEM;
+
 		state->cft = cft;
 		state->cgroup = __d_cgrp(file->f_dentry->d_parent);
 		file->f_op = &cgroup_seqfile_operations;
@@ -3514,7 +3516,7 @@ static struct cgroup_pidlist *cgroup_pidlist_find(struct cgroup *cgrp,
 		}
 	}
 	/* entry not found; create a new one */
-	l = kmalloc(sizeof(struct cgroup_pidlist), GFP_KERNEL);
+	l = kzalloc(sizeof(struct cgroup_pidlist), GFP_KERNEL);
 	if (!l) {
 		mutex_unlock(&cgrp->pidlist_mutex);
 		return l;
@@ -3523,8 +3525,6 @@ static struct cgroup_pidlist *cgroup_pidlist_find(struct cgroup *cgrp,
 	down_write(&l->mutex);
 	l->key.type = type;
 	l->key.ns = get_pid_ns(ns);
-	l->use_count = 0; /* don't increment here */
-	l->list = NULL;
 	l->owner = cgrp;
 	list_add(&l->links, &cgrp->pidlists);
 	mutex_unlock(&cgrp->pidlist_mutex);
-- 
1.8.2.1

