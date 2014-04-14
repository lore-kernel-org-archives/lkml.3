Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbaDNVjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:39:31 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:55093 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbaDNVha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:37:30 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/12] cgroup: update subsystem rebind restrictions
Date: Mon, 14 Apr 2014 17:37:08 -0400
Message-Id: <1397511430-2673-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1397511430-2673-1-git-send-email-tj@kernel.org>
References: <1397511430-2673-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the default root couldn't have any non-root csses attached to
it, rebinding away from it was always allowed; however, the default
hierarchy will soon host the unified hierarchy and have non-root csses
so the rebind restrictions need to be updated accordingly.

Instead of special casing rebinding from the default hierarchy and
then checking whether the source hierarchy has children cgroups, which
implies non-root csses for !dfl hierarchies, simply check whether the
source hierarchy has non-root csses for the subsystem using
css_next_child().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b4cd1fe..888e037 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1051,16 +1051,12 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
 		if (!(ss_mask & (1 << ssid)))
 			continue;
 
-		/* if @ss is on the dummy_root, we can always move it */
-		if (ss->root == &cgrp_dfl_root)
-			continue;
-
-		/* if @ss has non-root cgroups attached to it, can't move */
-		if (!list_empty(&ss->root->cgrp.children))
+		/* if @ss has non-root csses attached to it, can't move */
+		if (css_next_child(NULL, cgroup_css(&ss->root->cgrp, ss)))
 			return -EBUSY;
 
 		/* can't move between two non-dummy roots either */
-		if (dst_root != &cgrp_dfl_root)
+		if (ss->root != &cgrp_dfl_root && dst_root != &cgrp_dfl_root)
 			return -EBUSY;
 	}
 
-- 
1.9.0

