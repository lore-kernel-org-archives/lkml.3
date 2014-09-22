Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaIVD74 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 23:59:56 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:39035 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbaIVD7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 23:59:55 -0400
Date: Sun, 21 Sep 2014 23:59:52 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] workqueue fixes for v3.17-rc6
Message-ID: <20140922035952.GC23583@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

create_singlethread_workqueue() is the old interface which is kept
around for backward compatibility - each should be reviewed to
determine whether singlethread usage was to save worker threads or for
ordering guarantee and whether it's depended upon by memory reclaim
path.

While adding NUMA support for unbound workqueues during v3.10, I
forgot to update it breaking the singlethread and ordering properties
on NUMA setups.  The breakage was unfortunately rather subtle and went
without being reported until now.

The only missing piece is __WQ_ORDERED flag which makes the unbounded
workqueue use a single backend queue across different NUMA nodes.
It's fixed by making create_singlethread_workqueue() wrap
alloc_ordered_workqueue() so that possible future updates are
inherited automatically.

Thanks.

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.17-fixes

for you to fetch changes up to e09c2c295468476a239d13324ce9042ec4de05eb:

  workqueue: apply __WQ_ORDERED to create_singlethread_workqueue() (2014-09-13 05:13:08 +0900)

----------------------------------------------------------------
Tejun Heo (1):
      workqueue: apply __WQ_ORDERED to create_singlethread_workqueue()

 include/linux/workqueue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index a0cc2e9..b996e6cd 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -419,7 +419,7 @@ __alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
 	alloc_workqueue("%s", WQ_FREEZABLE | WQ_UNBOUND | WQ_MEM_RECLAIM, \
 			1, (name))
 #define create_singlethread_workqueue(name)				\
-	alloc_workqueue("%s", WQ_UNBOUND | WQ_MEM_RECLAIM, 1, (name))
+	alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, name)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
-- 
tejun
