Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbaGCPVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:21:21 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:34383 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911AbaGCPVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:21:19 -0400
Date: Thu, 3 Jul 2014 11:21:03 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/5] cgroup: initialize cgrp_dfl_root_inhibit_ss_mask from
 !->dfl_files test
Message-ID: <20140703152103.GF16191@htj.dyndns.org>
References: <1404345055-8196-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404345055-8196-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 29e5e8eac7ade8af5880020c91db9bc1c470596a Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 3 Jul 2014 11:18:31 -0400

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
index bc38c75..a7fce52 100644
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
 
@@ -4818,6 +4814,9 @@ int __init cgroup_init(void)
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

