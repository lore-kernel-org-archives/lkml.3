Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbbAFT3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:29:53 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:38606 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620AbbAFT3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:29:50 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org,
        hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com,
        lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
        mhocko@suse.cz, Tejun Heo <tj@kernel.org>
Subject: [PATCH 15/16] writeback: add @gfp to wb_init()
Date: Tue,  6 Jan 2015 14:29:16 -0500
Message-Id: <1420572557-11572-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420572557-11572-1-git-send-email-tj@kernel.org>
References: <1420572557-11572-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wb_init() currently always uses GFP_KERNEL but the planned cgroup
writeback support needs using other allocation masks.  Add @gfp to
wb_init().

This patch doesn't introduce any behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 mm/backing-dev.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index a98a957..1c9b70e 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -342,7 +342,8 @@ void wb_wakeup_delayed(struct bdi_writeback *wb)
  */
 #define INIT_BW		(100 << (20 - PAGE_SHIFT))
 
-static int wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
+static int wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi,
+		   gfp_t gfp)
 {
 	int i, err;
 
@@ -365,12 +366,12 @@ static int wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi)
 	INIT_LIST_HEAD(&wb->work_list);
 	INIT_DELAYED_WORK(&wb->dwork, wb_workfn);
 
-	err = fprop_local_init_percpu(&wb->completions, GFP_KERNEL);
+	err = fprop_local_init_percpu(&wb->completions, gfp);
 	if (err)
 		return err;
 
 	for (i = 0; i < NR_WB_STAT_ITEMS; i++) {
-		err = percpu_counter_init(&wb->stat[i], 0, GFP_KERNEL);
+		err = percpu_counter_init(&wb->stat[i], 0, gfp);
 		if (err) {
 			while (--i)
 				percpu_counter_destroy(&wb->stat[i]);
@@ -450,7 +451,7 @@ int bdi_init(struct backing_dev_info *bdi)
 	bdi->max_prop_frac = FPROP_FRAC_BASE;
 	INIT_LIST_HEAD(&bdi->bdi_list);
 
-	err = wb_init(&bdi->wb, bdi);
+	err = wb_init(&bdi->wb, bdi, GFP_KERNEL);
 	if (err)
 		return err;
 
-- 
2.1.0

