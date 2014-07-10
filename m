Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaGJPDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 11:03:40 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:36532 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaGJPDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 11:03:39 -0400
Date: Thu, 10 Jul 2014 11:03:36 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] workqueue fixes for v3.16-rc4 (this one is really for wq)
Message-ID: <20140710150336.GE6609@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Two workqueue fixes.  Both are one liners.  One fixes missing uevent
for workqueue files on sysfs.  The other one fixes missing zeroing of
NUMA cpu masks which can lead to oopses among other things.

Thanks.

The following changes since commit ebe06187bf2aec10d537ce4595e416035367d703:

  epoll: fix use-after-free in eventpoll_release_file (2014-06-16 17:21:59 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.16-fixes

for you to fetch changes up to 5a6024f1604eef119cf3a6fa413fe0261a81a8f3:

  workqueue: zero cpumask of wq_numa_possible_cpumask on init (2014-07-07 09:56:48 -0400)

----------------------------------------------------------------
Maxime Bizon (1):
      workqueue: fix dev_set_uevent_suppress() imbalance

Yasuaki Ishimatsu (1):
      workqueue: zero cpumask of wq_numa_possible_cpumask on init

 kernel/workqueue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6203d29..35974ac 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3284,6 +3284,7 @@ int workqueue_sysfs_register(struct workqueue_struct *wq)
 		}
 	}
 
+	dev_set_uevent_suppress(&wq_dev->dev, false);
 	kobject_uevent(&wq_dev->dev.kobj, KOBJ_ADD);
 	return 0;
 }
@@ -4879,7 +4880,7 @@ static void __init wq_numa_init(void)
 	BUG_ON(!tbl);
 
 	for_each_node(node)
-		BUG_ON(!alloc_cpumask_var_node(&tbl[node], GFP_KERNEL,
+		BUG_ON(!zalloc_cpumask_var_node(&tbl[node], GFP_KERNEL,
 				node_online(node) ? node : NUMA_NO_NODE));
 
 	for_each_possible_cpu(cpu) {
