Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbaEFLvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:51:11 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:37311 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaEFLuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:50:52 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/4] cgroup: use release_agent_path_lock in cgroup_release_agent_show()
Date: Tue,  6 May 2014 07:50:44 -0400
Message-Id: <1399377044-29873-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399377044-29873-1-git-send-email-tj@kernel.org>
References: <1399377044-29873-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

release_path is now protected by release_agent_path_lock to allow
accessing it without grabbing cgroup_mutex; however,
cgroup_release_agent_show() was still grabbing cgroup_mutex.  Let's
convert it to release_agent_path_lock so that we don't have to worry
about this one for the planned locking updates.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3ced79a..57c2021 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2373,11 +2373,10 @@ static int cgroup_release_agent_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
 
-	if (!cgroup_lock_live_group(cgrp))
-		return -ENODEV;
+	spin_lock(&release_agent_path_lock);
 	seq_puts(seq, cgrp->root->release_agent_path);
+	spin_unlock(&release_agent_path_lock);
 	seq_putc(seq, '\n');
-	mutex_unlock(&cgroup_mutex);
 	return 0;
 }
 
-- 
1.9.0

