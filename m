Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab3FFCqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 22:46:36 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:59783 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab3FFCqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 22:46:34 -0400
Date: Wed, 5 Jun 2013 19:46:26 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@openvz.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        devel@openvz.org
Subject: [PATCH cgroup/for-3.11] cgroup: disallow cpuacct if sane_behavior
Message-ID: <20130606024626.GT10693@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuacct causes duplicate accountings on the scheduler and cpu will
provide equivalent stats.  Optimizations for cases where cpu and
cpuacct are co-mounted are being worked on but we want to deprecate it
eventually.  Let's disallow cpuacct if __DEVEL__sane_behavior.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/cgroup.h |    3 +++
 kernel/cgroup.c        |    5 +++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index d0ad379..6c3bbdb 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -280,6 +280,9 @@ enum {
 	 * - memcg: use_hierarchy is on by default and the cgroup file for
 	 *   the flag is not created.
 	 *
+	 * - cpuacct: No longer supported.  cpu will have matching stats.
+	 *   Use those instead.
+	 *
 	 * The followings are planned changes.
 	 *
 	 * - release_agent will be disallowed once replacement notification
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index bc53d50..5c746eb 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1256,6 +1256,11 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 			pr_err("cgroup: sane_behavior: clone_children is not allowed\n");
 			return -EINVAL;
 		}
+
+		if (test_bit(cpuacct_subsys_id, &opts->subsys_mask)) {
+			pr_err("cgroup: sane_behavior: cpuacct is no longer available, use stats from cpu instead\n");
+			return -EINVAL;
+		}
 	}
 
 	/*
