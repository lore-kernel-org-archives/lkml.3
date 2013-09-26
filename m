Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab3IZN0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:26:48 -0400
Received: from dkim2.fusionio.com ([66.114.96.54]:49939 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab3IZN0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:26:41 -0400
X-ASG-Debug-ID: 1380202000-0421b50f503d2b0001-xx1T2L
X-Barracuda-Envelope-From: JBacik@fusionio.com
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
CC: <walken@google.com>, <linux-kernel@vger.kernel.org>, <mingo@kernel.org>,
        <peter@hurleysoftware.com>, <akpm@linux-foundation.org>
Subject: [PATCH 2/2] Btrfs: stop caching thread if extent_commit_sem is contended
Date: Thu, 26 Sep 2013 09:26:36 -0400
X-ASG-Orig-Subj: [PATCH 2/2] Btrfs: stop caching thread if extent_commit_sem is contended
Message-ID: <1380201996-17445-2-git-send-email-jbacik@fusionio.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380201996-17445-1-git-send-email-jbacik@fusionio.com>
References: <1380201996-17445-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas2.int.fusionio.com[10.101.1.41]
X-Barracuda-Start-Time: 1380202000
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_MISMATCH_TO
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.140942
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 BSF_SC0_MISMATCH_TO    Envelope rcpt doesn't match header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index cfb3cf7..cc074c34 100644
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

