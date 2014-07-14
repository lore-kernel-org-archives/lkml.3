Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbaGNPpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:45:23 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:46804 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114AbaGNPoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:44:25 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/6] cgroup: initialize cgrp_dfl_root_inhibit_ss_mask from !->dfl_files test
Date: Mon, 14 Jul 2014 11:44:08 -0400
Message-Id: <1405352648-4279-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405352648-4279-1-git-send-email-tj@kernel.org>
References: <1405352648-4279-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgrp_dfl_root_inhibit_ss_mask determines which subsystems are not
supported on the default hierarchy and is currently initialized
statically and just includes the debug subsystem.  Now that there's
cgroup_subsys->dfl_files, we can easily tell which subsystems support
the default hierarchy or not.

Let's initialize cgrp_dfl_root_inhibit_ss_mask by testing whether
cgroup_subsys->dfl_files is NULL.  After all, subsystems with NULL
->dfl_files aren't useable on the default hierarchy anyway.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f41d164..f2a6795 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -156,11 +156,7 @@ static bool cgrp_dfl_root_visible;
 static bool cgroup_legacy_files_on_dfl;
 
 /* some controllers are not supported in the default hierarchy */
-static const unsigned int cgrp_dfl_root_inhibit_ss_mask = 0
-#ifdef CONFIG_CGROUP_DEBUG
-	| (1 << debug_cgrp_id)
-#endif
-	;
+static unsigned int cgrp_dfl_root_inhibit_ss_mask;
 
 /* The list of hierarchy roots */
 
@@ -4939,6 +4935,9 @@ int __init cgroup_init(void)
 		if (cgroup_legacy_files_on_dfl && !ss->dfl_cftypes)
 			ss->dfl_cftypes = ss->legacy_cftypes;
 
+		if (!ss->dfl_cftypes)
+			cgrp_dfl_root_inhibit_ss_mask |= 1 << ss->id;
+
 		if (ss->dfl_cftypes == ss->legacy_cftypes) {
 			WARN_ON(cgroup_add_cftypes(ss, ss->dfl_cftypes));
 		} else {
-- 
1.9.3

