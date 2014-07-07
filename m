Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbaGGBk1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 21:40:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:34026 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbaGGBkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 21:40:25 -0400
X-AuditID: cbfee61a-f79e46d00000134f-be-53b9fa8632bd
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH] f2fs: avoid to access NULL pointer in
 issue_flush_thread
Date: Mon, 07 Jul 2014 09:39:32 +0800
Message-id: <006001cf9984$6b07f490$4117ddb0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+YSfUFH7Ib7OS6QX624KR9Ac9hbw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jAd22XzuDDRZvsbK4tq+RyeLJ+lnM
	FpcWuVvs2XuSxeLyrjlsDqwem1Z1snnsXvCZyaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	Diw4xlbwm7tizbeZ7A2MU7m6GDk5JARMJOYc38cGYYtJXLi3Hsjm4hASWMQosbP7FhOE84NR
	YvecFiaQKjYBFYnlHf/BbBEBL4lJ+0+wgNjMApkS95pmMIPYwgKhEqevXWEEsVkEVCX6Gi+D
	2bwClhI7psxigbAFJX5MvgfVqyWxfudxJghbXmLzmrfMEBcpSOw4+5oRYpeexK9d01ghasQl
	Nh65xTKBUWAWklGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEh/cz
	qR2MKxssDjEKcDAq8fAeWLUzWIg1say4MvcQowQHs5II7xk3oBBvSmJlVWpRfnxRaU5q8SFG
	aQ4WJXHeA63WgUIC6YklqdmpqQWpRTBZJg5OqQbGCX6MZUFbrk4wTj5ZbFP6jTVS/tv/SXY3
	t06Le26x7SOnaJWCf/jvNvWKi3pZT1//ichcG1zC1iTBuTVuJmfDSYVFnV7vWwxa5iT4Xypm
	0XJsypmhKXD4u4ZT4tRb7vKLBTL1+OYGmy+0s1iQzmgVd3/eybzHZ4798YwI9Tmsr7Phd4R9
	3l0lluKMREMt5qLiRABTrfNhawIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=75861

Denis 2014-05-10 11:28:59 UTC reported:
"F2FS-fs (mmcblk0p28): mounting..
 Unable to handle kernel NULL pointer dereference at virtual address 00000018
 ...
 [<c0a2f678>] (_raw_spin_lock+0x3c/0x70) from [<c03a0330>] (issue_flush_thread+0x50/0x17c)
 [<c03a0330>] (issue_flush_thread+0x50/0x17c) from [<c01b4064>] (kthread+0x98/0xa4)
 [<c01b4064>] (kthread+0x98/0xa4) from [<c0108060>] (kernel_thread_exit+0x0/0x8)"

This patch assign cmd_control_info in sm_info before issue_flush_thread is being
created, so this make sure that issue flush thread will have no chance to access
invalid info in fcc.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/segment.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index bb5980d..a4f8375 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -272,14 +272,15 @@ int create_flush_cmd_control(struct f2fs_sb_info *sbi)
 		return -ENOMEM;
 	spin_lock_init(&fcc->issue_lock);
 	init_waitqueue_head(&fcc->flush_wait_queue);
+	sbi->sm_info->cmd_control_info = fcc;
 	fcc->f2fs_issue_flush = kthread_run(issue_flush_thread, sbi,
 				"f2fs_flush-%u:%u", MAJOR(dev), MINOR(dev));
 	if (IS_ERR(fcc->f2fs_issue_flush)) {
 		err = PTR_ERR(fcc->f2fs_issue_flush);
 		kfree(fcc);
+		sbi->sm_info->cmd_control_info = NULL;
 		return err;
 	}
-	sbi->sm_info->cmd_control_info = fcc;
 
 	return err;
 }
-- 
2.0.0.257.g75cc6c6


