Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbaEPQHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:07:23 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:39994 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757446AbaEPQHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:07:20 -0400
Date: Fri, 16 May 2014 12:07:16 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org
Subject: [PATCH v2 09/14] cgroup: introduce CSS_RELEASED and reduce css
 iteration fallback window
Message-ID: <20140516160716.GC5379@htj.dyndns.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-10-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399671091-23867-10-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 55e2f1d4b69516f899712c04df6635309bf06983 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 16 May 2014 11:40:35 -0400

css iterations allow the caller to drop RCU read lock.  As long as the
caller keeps the current position accessible, it can simply re-grab
RCU read lock later and continue iteration.  This is achieved by using
CGRP_DEAD to detect whether the current positions next pointer is safe
to dereference and if not re-iterate from the beginning to the next
position using ->serial_nr.

CGRP_DEAD is used as the marker to invalidate the next pointer and the
only requirement is that the marker is set before the next sibling
starts its RCU grace period.  Because CGRP_DEAD is set at the end of
cgroup_destroy_locked() but the cgroup is unlinked when the reference
count reaches zero, we currently have a rather large window where this
fallback re-iteration logic can be triggered.

This patch introduces CSS_RELEASED which is set when a css is unlinked
from its sibling list.  This still keeps the re-iteration logic
working while drastically reducing the window of its activation.
While at it, rewrite the comment in css_next_child() to reflect the
new flag and better explain the synchronization.

This will also enable iterating csses directly instead of through
cgroups.

v2: CSS_RELEASED now assigned to 1 << 2 as 1 << 0 is used by
    CSS_NO_REF.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h |  1 +
 kernel/cgroup.c        | 41 ++++++++++++++++++++---------------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index ebe7ce4..5375582e 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -97,6 +97,7 @@ struct cgroup_subsys_state {
 enum {
 	CSS_NO_REF	= (1 << 0), /* no reference counting for this css */
 	CSS_ONLINE	= (1 << 1), /* between ->css_online() and ->css_offline() */
+	CSS_RELEASED	= (1 << 2), /* refcnt reached zero, released */
 };
 
 /**
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index eebae99..7df818b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3108,27 +3108,28 @@ css_next_child(struct cgroup_subsys_state *pos_css,
 	cgroup_assert_mutex_or_rcu_locked();
 
 	/*
-	 * @pos could already have been removed.  Once a cgroup is removed,
-	 * its ->sibling.next is no longer updated when its next sibling
-	 * changes.  As CGRP_DEAD assertion is serialized and happens
-	 * before the cgroup is taken off the ->sibling list, if we see it
-	 * unasserted, it's guaranteed that the next sibling hasn't
-	 * finished its grace period even if it's already removed, and thus
-	 * safe to dereference from this RCU critical section.  If
-	 * ->sibling.next is inaccessible, cgroup_is_dead() is guaranteed
-	 * to be visible as %true here.
+	 * @pos could already have been unlinked from the sibling list.
+	 * Once a cgroup is removed, its ->sibling.next is no longer
+	 * updated when its next sibling changes.  CSS_RELEASED is set when
+	 * @pos is taken off list, at which time its next pointer is valid,
+	 * and, as releases are serialized, the one pointed to by the next
+	 * pointer is guaranteed to not have started release yet.  This
+	 * implies that if we observe !CSS_RELEASED on @pos in this RCU
+	 * critical section, the one pointed to by its next pointer is
+	 * guaranteed to not have finished its RCU grace period even if we
+	 * have dropped rcu_read_lock() inbetween iterations.
 	 *
-	 * If @pos is dead, its next pointer can't be dereferenced;
-	 * however, as each cgroup is given a monotonically increasing
-	 * unique serial number and always appended to the sibling list,
-	 * the next one can be found by walking the parent's children until
-	 * we see a cgroup with higher serial number than @pos's.  While
-	 * this path can be slower, it's taken only when either the current
-	 * cgroup is removed or iteration and removal race.
+	 * If @pos has CSS_RELEASED set, its next pointer can't be
+	 * dereferenced; however, as each css is given a monotonically
+	 * increasing unique serial number and always appended to the
+	 * sibling list, the next one can be found by walking the parent's
+	 * children until the first css with higher serial number than
+	 * @pos's.  While this path can be slower, it happens iff iteration
+	 * races against release and the race window is very small.
 	 */
 	if (!pos) {
 		next = list_entry_rcu(cgrp->self.children.next, struct cgroup, self.sibling);
-	} else if (likely(!cgroup_is_dead(pos))) {
+	} else if (likely(!(pos->self.flags & CSS_RELEASED))) {
 		next = list_entry_rcu(pos->self.sibling.next, struct cgroup, self.sibling);
 	} else {
 		list_for_each_entry_rcu(next, &cgrp->self.children, self.sibling)
@@ -4139,6 +4140,7 @@ static void css_release_work_fn(struct work_struct *work)
 
 	mutex_lock(&cgroup_mutex);
 
+	css->flags |= CSS_RELEASED;
 	list_del_rcu(&css->sibling);
 
 	if (ss) {
@@ -4525,10 +4527,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 
 	/*
 	 * Mark @cgrp dead.  This prevents further task migration and child
-	 * creation by disabling cgroup_lock_live_group().  Note that
-	 * CGRP_DEAD assertion is depended upon by css_next_child() to
-	 * resume iteration after dropping RCU read lock.  See
-	 * css_next_child() for details.
+	 * creation by disabling cgroup_lock_live_group().
 	 */
 	set_bit(CGRP_DEAD, &cgrp->flags);
 
-- 
1.9.0

