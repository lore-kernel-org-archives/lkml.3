Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab3ITMwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 08:52:30 -0400
Received: from relay.parallels.com ([195.214.232.42]:52526 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab3ITMw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 08:52:29 -0400
Subject: [PATCH] writeback: fix delayed sync(2)
To: linux-mm@kvack.org
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: tj@kernel.org, akpm@linux-foundation.org, fengguang.wu@intel.com,
        jack@suse.cz, linux-kernel@vger.kernel.org
Date: Fri, 20 Sep 2013 16:52:26 +0400
Message-ID: <20130920125029.17356.66782.stgit@dhcp-10-30-17-2.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem statement: if sync(2) races with bdi_wakeup_thread_delayed
(which is called when the first inode for a bdi is marked dirty), it's
possible that sync will be delayed for long (5 secs if dirty_writeback_interval
is set to default value).

How it works: sync schedules bdi work for immediate processing by calling
mod_delayed_work with 'delay' equal to 0. Bdi work is queued to pool->worklist
and wake_up_worker(pool) is called, but before worker gets the work from
the list, __mark_inode_dirty intervenes calling bdi_wakeup_thread_delayed
who calls mod_delayed_work with 'timeout' equal to dirty_writeback_interval
multiplied by 10. mod_delayed_work dives into try_to_grab_pending who
successfully steals the work from the worklist. Then it's re-queued with that
new delay. Until the timeout is lapsed, sync(2) sits on wait_for_completion in
sync_inodes_sb.

The patch uses queue_delayed_work for __mark_inode_dirty. This should be safe
because even if queue_delayed_work returns false (if the work is already on
a queue), bdi_writeback_workfn will re-schedule itself by looking at
wb->b_dirty.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 mm/backing-dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index ce682f7..3fde024 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -294,7 +294,7 @@ void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi)
 	unsigned long timeout;
 
 	timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
-	mod_delayed_work(bdi_wq, &bdi->wb.dwork, timeout);
+	queue_delayed_work(bdi_wq, &bdi->wb.dwork, timeout);
 }
 
 /*

