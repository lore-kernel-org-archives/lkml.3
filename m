Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbbAZMZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:25:12 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:10538 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbbAZMZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:25:08 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-fe-54c632212083
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] f2fs: clean up {in,de}create_sleep_time
Date: Mon, 26 Jan 2015 20:24:21 +0800
Message-id: <008801d03963$1d637ff0$582a7fd0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdA5TR1gSfKsuOs9S4GLupJLiI3JiA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jQV1Fo2MhBo8fiFtc29fIZPFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoErY920zywF
	p0Uq2vdcY2xgfCnQxcjJISFgInHv9nd2CFtM4sK99WxdjFwcQgLTGSWmfVnOBOH8YJQ41fqP
	CaSKTUBFYnnHfzBbRMBLYtL+EywgNrOAh0Rjx3dWEFtYwEZi94FjYHEWAVWJB5P3gW3gFbCU
	uLv4MzOELSjxY/I9qF4tifU7jzNB2PISm9e8ZYa4SEFix9nXjBC79CQu3T/ADlEjLrHxyC2W
	CYwCs5CMmoVk1Cwko2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzion0nvYFzV
	YHGIUYCDUYmHV6PxaIgQa2JZcWXuIUYJDmYlEV5H9WMhQrwpiZVVqUX58UWlOanFhxilOViU
	xHmV7NtChATSE0tSs1NTC1KLYLJMHJxSDYyexjeXLF+zppp/jr3C3MdhN47LvogVWr1R7ryU
	U90dZe/22f2rNXQcnmT3vC+RuRx5fvb3kAXy87frfovcJsvhWryy6dgTubJkf7VZ5X8Or3Vj
	YUvT4Np0JnRPotu+OtnvmvsPq37TeBO7dtVFt773DHNOWAVzNQSv+JpnOnnPsp3FZncWsuxT
	YinOSDTUYi4qTgQAb4lnimYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pointer parameter @wait to pass result in {in,de}create_sleep_time for
cleanup.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/gc.c |  8 ++++----
 fs/f2fs/gc.h | 28 ++++++++++++++--------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 67860b6..ba89e27 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -44,7 +44,7 @@ static int gc_thread_func(void *data)
 			break;
 
 		if (sbi->sb->s_writers.frozen >= SB_FREEZE_WRITE) {
-			wait_ms = increase_sleep_time(gc_th, wait_ms);
+			increase_sleep_time(gc_th, &wait_ms);
 			continue;
 		}
 
@@ -65,15 +65,15 @@ static int gc_thread_func(void *data)
 			continue;
 
 		if (!is_idle(sbi)) {
-			wait_ms = increase_sleep_time(gc_th, wait_ms);
+			increase_sleep_time(gc_th, &wait_ms);
 			mutex_unlock(&sbi->gc_mutex);
 			continue;
 		}
 
 		if (has_enough_invalid_blocks(sbi))
-			wait_ms = decrease_sleep_time(gc_th, wait_ms);
+			decrease_sleep_time(gc_th, &wait_ms);
 		else
-			wait_ms = increase_sleep_time(gc_th, wait_ms);
+			increase_sleep_time(gc_th, &wait_ms);
 
 		stat_inc_bggc_count(sbi);
 
diff --git a/fs/f2fs/gc.h b/fs/f2fs/gc.h
index 524543a..d5ff97c 100644
--- a/fs/f2fs/gc.h
+++ b/fs/f2fs/gc.h
@@ -66,26 +66,26 @@ static inline block_t limit_free_user_blocks(struct f2fs_sb_info *sbi)
 	return (long)(reclaimable_user_blocks * LIMIT_FREE_BLOCK) / 100;
 }
 
-static inline long increase_sleep_time(struct f2fs_gc_kthread *gc_th, long wait)
+static inline void increase_sleep_time(struct f2fs_gc_kthread *gc_th,
+								long *wait)
 {
-	if (wait == gc_th->no_gc_sleep_time)
-		return wait;
+	if (*wait == gc_th->no_gc_sleep_time)
+		return;
 
-	wait += gc_th->min_sleep_time;
-	if (wait > gc_th->max_sleep_time)
-		wait = gc_th->max_sleep_time;
-	return wait;
+	*wait += gc_th->min_sleep_time;
+	if (*wait > gc_th->max_sleep_time)
+		*wait = gc_th->max_sleep_time;
 }
 
-static inline long decrease_sleep_time(struct f2fs_gc_kthread *gc_th, long wait)
+static inline void decrease_sleep_time(struct f2fs_gc_kthread *gc_th,
+								long *wait)
 {
-	if (wait == gc_th->no_gc_sleep_time)
-		wait = gc_th->max_sleep_time;
+	if (*wait == gc_th->no_gc_sleep_time)
+		*wait = gc_th->max_sleep_time;
 
-	wait -= gc_th->min_sleep_time;
-	if (wait <= gc_th->min_sleep_time)
-		wait = gc_th->min_sleep_time;
-	return wait;
+	*wait -= gc_th->min_sleep_time;
+	if (*wait <= gc_th->min_sleep_time)
+		*wait = gc_th->min_sleep_time;
 }
 
 static inline bool has_enough_invalid_blocks(struct f2fs_sb_info *sbi)
-- 
2.2.2


