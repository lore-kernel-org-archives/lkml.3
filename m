Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab3HWPvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:51:22 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:54747 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab3HWPvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:51:21 -0400
Date: Fri, 23 Aug 2013 11:51:15 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL RESEND] cgroup fixes for v3.11-rc6
Message-ID: <20130823155115.GF3277@htj.dyndns.org>
References: <20130823154813.GE3277@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130823154813.GE3277@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(forgot to cc lkml, resending, no content change)

Hello, Linus.

A late fix for cgroup.  This fixes a behavior regression visible to
userland which was created by a commit merged during -rc1.  While the
behavior change isn't too likely to be noticeable, the fix is
relatively low risk and we'll need to backport it through -stable
anyway if the bug gets released.

The fix is available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.11-fixes

for you to fetch changes up to 1c09b195d37fa459844036f429a0f378e70c3db6:

  cpuset: fix a regression in validating config change (2013-08-21 08:40:27 -0400)

Thanks.

----------------------------------------------------------------
Li Zefan (1):
      cpuset: fix a regression in validating config change

 kernel/cpuset.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 010a008..ea1966d 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -475,13 +475,17 @@ static int validate_change(const struct cpuset *cur, const struct cpuset *trial)
 
 	/*
 	 * Cpusets with tasks - existing or newly being attached - can't
-	 * have empty cpus_allowed or mems_allowed.
+	 * be changed to have empty cpus_allowed or mems_allowed.
 	 */
 	ret = -ENOSPC;
-	if ((cgroup_task_count(cur->css.cgroup) || cur->attach_in_progress) &&
-	    (cpumask_empty(trial->cpus_allowed) &&
-	     nodes_empty(trial->mems_allowed)))
-		goto out;
+	if ((cgroup_task_count(cur->css.cgroup) || cur->attach_in_progress)) {
+		if (!cpumask_empty(cur->cpus_allowed) &&
+		    cpumask_empty(trial->cpus_allowed))
+			goto out;
+		if (!nodes_empty(cur->mems_allowed) &&
+		    nodes_empty(trial->mems_allowed))
+			goto out;
+	}
 
 	ret = 0;
 out:

--
tejun
