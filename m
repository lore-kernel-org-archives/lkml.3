Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbaEFLvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:51:35 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:48587 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbaEFLus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:50:48 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] cgroup: fix offlining child waiting in cgroup_subtree_control_write()
Date: Tue,  6 May 2014 07:50:41 -0400
Message-Id: <1399377044-29873-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399377044-29873-1-git-send-email-tj@kernel.org>
References: <1399377044-29873-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_subtree_control_write() waits for offline to complete
child-by-child before enabling a controller; however, it has a couple
bugs.

* It doesn't initialize the wait_queue_t.  This can lead to infinite
  hang on the following schedule() among other things.

* It forgets to pin the child before releasing cgroup_tree_mutex and
  performing schedule().  The child may already be gone by the time it
  wakes up and invokes finish_wait().  Pin the child being waited on.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 07815ef..54fd12d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2594,16 +2594,18 @@ retry:
 			 * cases, wait till it's gone using offline_waitq.
 			 */
 			cgroup_for_each_live_child(child, cgrp) {
-				wait_queue_t wait;
+				DEFINE_WAIT(wait);
 
 				if (!cgroup_css(child, ss))
 					continue;
 
+				cgroup_get(child);
 				prepare_to_wait(&child->offline_waitq, &wait,
 						TASK_UNINTERRUPTIBLE);
 				mutex_unlock(&cgroup_tree_mutex);
 				schedule();
 				finish_wait(&child->offline_waitq, &wait);
+				cgroup_put(child);
 				goto retry;
 			}
 
-- 
1.9.0

