Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422952Ab3FUA53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:57:29 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:49410 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965866Ab3FUA51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:57:27 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Andrew Shewmaker <agshew@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Namjae Jeon <linkinjeon@gmail.com>, Jan Kara <jack@suse.cz>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v6 2/6] mm/writeback: Don't check force_wait to handle bdi->work_list
Date: Fri, 21 Jun 2013 08:57:09 +0800
Message-Id: <1371776233-9364-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1371776233-9364-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1371776233-9364-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062100-9574-0000-0000-0000086371F4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 839a8e86("writeback: replace custom worker pool implementation
with unbound workqueue"), bdi_writeback_workfn runs off bdi_writeback->dwork,
on each execution, it processes bdi->work_list and reschedules if there are
more things to do instead of flush any work that race with us existing. It is
unecessary to check force_wait in wb_do_writeback since it is always 0 after
the mentioned commit. This patch remove the force_wait in wb_do_writeback.

Reviewed-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 fs/fs-writeback.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index f892dec..e15aa97 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -959,7 +959,7 @@ static long wb_check_old_data_flush(struct bdi_writeback *wb)
 /*
  * Retrieve work items and do the writeback they describe
  */
-static long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
+static long wb_do_writeback(struct bdi_writeback *wb)
 {
 	struct backing_dev_info *bdi = wb->bdi;
 	struct wb_writeback_work *work;
@@ -967,12 +967,6 @@ static long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
 
 	set_bit(BDI_writeback_running, &wb->bdi->state);
 	while ((work = get_next_work_item(bdi)) != NULL) {
-		/*
-		 * Override sync mode, in case we must wait for completion
-		 * because this thread is exiting now.
-		 */
-		if (force_wait)
-			work->sync_mode = WB_SYNC_ALL;
 
 		trace_writeback_exec(bdi, work);
 
@@ -1021,7 +1015,7 @@ void bdi_writeback_workfn(struct work_struct *work)
 		 * rescuer as work_list needs to be drained.
 		 */
 		do {
-			pages_written = wb_do_writeback(wb, 0);
+			pages_written = wb_do_writeback(wb);
 			trace_writeback_pages_written(pages_written);
 		} while (!list_empty(&bdi->work_list));
 	} else {
-- 
1.7.5.4

