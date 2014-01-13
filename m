Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbaAMRUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:20:05 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42103 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756648AbaAMRUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:20:00 -0500
From: Josef Bacik <jbacik@fb.com>
To: <mingo@kernel.org>, <linux-kernel@vger.kernel.org>, <peterz@infradead.org>
Subject: [PATCH 2/2] Btrfs: stop caching thread if extent_commit_sem is contended
Date: Mon, 13 Jan 2014 12:18:51 -0500
Message-ID: <1389633531-1921-2-git-send-email-jbacik@fb.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1389633531-1921-1-git-send-email-jbacik@fb.com>
References: <1389633531-1921-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-13_02:2014-01-13,2014-01-13,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josef Bacik <jbacik@fusionio.com>

We can starve out the transaction commit with a bunch of caching threads all
running at the same time.  This is because we will only drop the
extent_commit_sem if we need_resched(), which isn't likely to happen since we
will be reading a lot from the disk so have already schedule()'ed plenty.  Alex
observed that he could starve out a transaction commit for up to a minute with
32 caching threads all running at once.  This will allow us to drop the
extent_commit_sem to allow the transaction commit to swap the commit_root out
and then all the cachers will start back up. Here is an explanation provided by
Igno

So, just to fill in what happens in this loop:

                                mutex_unlock(&caching_ctl->mutex);
                                cond_resched();
                                goto again;

where 'again:' takes caching_ctl->mutex and fs_info->extent_commit_sem
again:

        again:
                mutex_lock(&caching_ctl->mutex);
                /* need to make sure the commit_root doesn't disappear */
                down_read(&fs_info->extent_commit_sem);

So, if I'm reading the code correct, there can be a fair amount of
concurrency here: there may be multiple 'caching kthreads' per filesystem
active, while there's one fs_info->extent_commit_sem per filesystem
AFAICS.

So, what happens if there are a lot of CPUs all busy holding the
->extent_commit_sem rwsem read-locked and a writer arrives? They'd all
rush to try to release the fs_info->extent_commit_sem, and they'd block in
the down_read() because there's a writer waiting.

So there's a guarantee of forward progress. This should answer akpm's
concern I think.

Thanks,

Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1c82bea..3d19dcc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -442,7 +442,8 @@ next:
 			if (ret)
 				break;
 
-			if (need_resched()) {
+			if (need_resched() ||
+			    rwsem_is_contended(&fs_info->extent_commit_sem)) {
 				caching_ctl->progress = last;
 				btrfs_release_path(path);
 				up_read(&fs_info->extent_commit_sem);
-- 
1.8.3.1

