Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab3H1Xbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 19:31:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61139 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab3H1Xbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 19:31:44 -0400
Date: Wed, 28 Aug 2013 16:31:23 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Tejun Heo <tj@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cgroup: fix rmdir EBUSY regression in 3.11
Message-ID: <alpine.LNX.2.00.1308281624430.1266@eggly.anvils>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.11-rc we are seeing cgroup directories left behind when they should
have been removed.  Here's a trivial reproducer:

cd /sys/fs/cgroup/memory
mkdir parent parent/child; rmdir parent/child parent
rmdir: failed to remove `parent': Device or resource busy

It's because cgroup_destroy_locked() (step 1 of destruction) leaves
cgroup on parent's children list, letting cgroup_offline_fn() (step 2 of
destruction) remove it; but step 2 is run by work queue, which may not
yet have removed the children when parent destruction checks the list.

Fix that by checking through a non-empty list of children: if every one
of them has already been marked CGRP_DEAD, then it's safe to proceed:
those children are invisible to userspace, and should not obstruct rmdir.

(I didn't see any reason to keep the cgrp->children checks under the
unrelated css_set_lock, so moved them out.)

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 kernel/cgroup.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- 3.11-rc7/kernel/cgroup.c	2013-08-11 23:38:33.096579188 -0700
+++ linux/kernel/cgroup.c	2013-08-28 15:44:06.952564071 -0700
@@ -4490,8 +4490,23 @@ static int cgroup_destroy_locked(struct
 	 * @cgrp from being removed while __put_css_set() is in progress.
 	 */
 	read_lock(&css_set_lock);
-	empty = list_empty(&cgrp->cset_links) && list_empty(&cgrp->children);
+	empty = list_empty(&cgrp->cset_links);
 	read_unlock(&css_set_lock);
+
+	if (empty && !list_empty(&cgrp->children)) {
+		struct cgroup *child;
+		/*
+		 * We need "rmdir parent/child parent" to succeed,
+		 * but our children may not have reached step 2 yet.
+		 */
+		rcu_read_lock();
+		list_for_each_entry_rcu(child, &cgrp->children, sibling) {
+			empty = cgroup_is_dead(child);
+			if (!empty)
+				break;
+		}
+		rcu_read_unlock();
+	}
 	if (!empty)
 		return -EBUSY;
 
