Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab3EQHqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 03:46:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:56146 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab3EQHqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 03:46:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,690,1363158000"; 
   d="scan'208";a="339112880"
From: Aaron Lu <aaron.lu@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>,
        Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH] blkpm: avoid sleep when holding queue lock
Date: Fri, 17 May 2013 15:47:20 +0800
Message-Id: <1368776840-4877-1-git-send-email-aaron.lu@intel.com>
X-Mailer: git-send-email 1.8.3.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In blk_post_runtime_resume, an autosuspend request will be initiated for
the device. Since we are holding the queue lock, we can't sleep and thus
we should use the async version to initiate an autosuspend, i.e.
pm_request_suspend instead of pm_runtime_suspend, which might sleep.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
I didn't turn on the lock debugging config options while doing test so
this issue didn't show up until recently I have all those lock debugging
options turned on, a warning instantly showed up. While it is correctly
using pm_request_autosuspend in pre-v7 series, and is brought by me
mistakenly, sorry for this.

 block/blk-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 33c33bc..d5745b5 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -3164,7 +3164,7 @@ void blk_post_runtime_resume(struct request_queue *q, int err)
 		q->rpm_status = RPM_ACTIVE;
 		__blk_run_queue(q);
 		pm_runtime_mark_last_busy(q->dev);
-		pm_runtime_autosuspend(q->dev);
+		pm_request_autosuspend(q->dev);
 	} else {
 		q->rpm_status = RPM_SUSPENDED;
 	}
-- 
1.8.3.rc2

