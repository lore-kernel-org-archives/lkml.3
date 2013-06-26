Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab3FZBF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 21:05:28 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:40489 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3FZBF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 21:05:26 -0400
Date: Tue, 25 Jun 2013 18:05:21 -0700
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: lizefan@huawei.com, LKML <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, trinity@vger.kernel.org
Subject: [PATCH cgroup/for-3.11] cgroup: grab cgroup_mutex in
 drop_parsed_module_refcounts()
Message-ID: <20130626010521.GE30407@mtj.dyndns.org>
References: <51C9D17B.5090208@oracle.com>
 <20130626010454.GD30407@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626010454.GD30407@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This isn't strictly necessary as all subsystems specified in
@subsys_mask are guaranteed to be pinned; however, it does spuriously
trigger lockdep warning.  Let's grab cgroup_mutex around it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1325,11 +1325,11 @@ static void drop_parsed_module_refcounts
 	struct cgroup_subsys *ss;
 	int i;
 
-	for_each_subsys(ss, i) {
-		if (!(subsys_mask & (1UL << i)))
-			continue;
-		module_put(cgroup_subsys[i]->module);
-	}
+	mutex_lock(&cgroup_mutex);
+	for_each_subsys(ss, i)
+		if (subsys_mask & (1UL << i))
+			module_put(cgroup_subsys[i]->module);
+	mutex_unlock(&cgroup_mutex);
 }
 
 static int cgroup_remount(struct super_block *sb, int *flags, char *data)
