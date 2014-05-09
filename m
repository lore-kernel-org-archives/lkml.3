Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbaEITf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 15:35:27 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:53963 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400AbaEITc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 15:32:59 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/7] cgroup: fix offlining child waiting in cgroup_subtree_control_write()
Date: Fri,  9 May 2014 15:32:49 -0400
Message-Id: <1399663975-315-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399663975-315-1-git-send-email-tj@kernel.org>
References: <1399663975-315-1-git-send-email-tj@kernel.org>
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
index 9db1a96..95fc66b 100644
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

