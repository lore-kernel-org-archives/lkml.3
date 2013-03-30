Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab3C3DBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 23:01:36 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:64367 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757622Ab3C3DBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 23:01:09 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, akpm@linux-foundation.org
Cc: jack@suse.cz, david@fromorbit.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/3] writeback: set worker desc to identify writeback workers in task dumps
Date: Fri, 29 Mar 2013 20:00:47 -0700
Message-Id: <1364612447-6810-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1364612447-6810-1-git-send-email-tj@kernel.org>
References: <1364612447-6810-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Writeback has been recently converted to use workqueue instead of its
private thread pool implementation.  One negative side effect of this
conversion is that there's no easy to tell which backing device a
writeback work item was working on at the time of task dump, be it
sysrq-t, BUG, WARN or whatever, which, according to our writeback
brethren, is important in tracking down issues with a lot of mounted
file systems on a lot of different devices.

This patch restores that information using the new worker description
facility.  bdi_writeback_workfn() calls set_work_desc() to identify
which bdi it's working on.  The description is printed out together
with the worqueue name and worker function as in the following example
dump.

 WARNING: at /work/os/work/fs/fs-writeback.c:1015 bdi_writeback_workfn+0x2b4/0x3c0()
 Modules linked in:
 Pid: 28, comm: kworker/u18:0 Not tainted 3.9.0-rc1-work+ #24 empty empty/S3992
 Workqueue: writeback bdi_writeback_workfn (flush-8:16)
  ffffffff820a3a98 ffff88015b927cb8 ffffffff81c61855 ffff88015b927cf8
  ffffffff8108f500 0000000000000000 ffff88007a171948 ffff88007a1716b0
  ffff88015b49df00 ffff88015b8d3940 0000000000000000 ffff88015b927d08
 Call Trace:
  [<ffffffff81c61855>] dump_stack+0x19/0x1b
  [<ffffffff8108f500>] warn_slowpath_common+0x70/0xa0
  [<ffffffff8108f54a>] warn_slowpath_null+0x1a/0x20
  [<ffffffff81200144>] bdi_writeback_workfn+0x2b4/0x3c0
  [<ffffffff810b4c87>] process_one_work+0x1d7/0x660
  [<ffffffff810b5c72>] worker_thread+0x122/0x380
  [<ffffffff810bdfea>] kthread+0xea/0xf0
  [<ffffffff81c6cedc>] ret_from_fork+0x7c/0xb0

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
---
 fs/fs-writeback.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 8067d37..3be5718 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1009,6 +1009,7 @@ void bdi_writeback_workfn(struct work_struct *work)
 	struct backing_dev_info *bdi = wb->bdi;
 	long pages_written;
 
+	set_worker_desc("flush-%s", dev_name(bdi->dev));
 	current->flags |= PF_SWAPWRITE;
 
 	if (likely(!current_is_workqueue_rescuer() ||
-- 
1.8.1.4

