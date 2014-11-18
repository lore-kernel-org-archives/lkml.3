Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaKRDRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 22:17:25 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:64347 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaKRDRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 22:17:24 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-85-546aba31551b
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 1/3] f2fs: avoid unable to restart gc thread in
 remount
Date: Tue, 18 Nov 2014 11:16:01 +0800
Message-id: <006601d002de$20ec59a0$62c50ce0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAC18XmrfPSz0o8QxazhqsewEdvfg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jQV3DXVkhBsdOy1tc29fIZPFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr4/sJj4KX
	XBV31j9kbWC8xNHFyMkhIWAi8W57HyuELSZx4d56ti5GLg4hgemMEsfb5kE5Pxgl+hseMoFU
	sQmoSCzv+A9miwh4SUzaf4IFxGYW8JBo7PgONklYIFhi+YkDYHEWAVWJS91LGLsYOTh4BSwl
	vtyoBQnzCghK/Jh8D6pVS2L9zuNMELa8xOY1b5khDlKQ2HH2NSPEKj2Jm2//QdWLS2w8cotl
	AqPALCSjZiEZNQvJqFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECA7oZ9I7GFc1
	WBxiFOBgVOLhTZyaFSLEmlhWXJl7iFGCg1lJhPdcN1CINyWxsiq1KD++qDQntfgQozQHi5I4
	78FW60AhgfTEktTs1NSC1CKYLBMHp1QDYx/HprMM/EbV+2rv27PG7FjItXs5q9Cv69/YIkrT
	uJdWPFswxb9nWZbk7rWFbGcEnmay16xLfsXxav6Uw3Upv6LzRAI+SS/lrF+y95JXjWIO4761
	iZHOTaq746XZZgrHfF6268DKFa/Xs6zRnXP5t61XZ9icybYOD+v4jL40WVadX3ax653yTyWW
	4oxEQy3mouJEABeaq4pkAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In f2fs_remount, we will stop gc thread and set need_restart_gc as true when new
option is set without BG_GC, then if any error occurred in the following
procedure, we can restore to start the gc thread.
But after that, We will fail to restore gc thread in start_gc_thread as BG_GC is
not set in new option, so we'd better move this condition judgment out of
start_gc_thread to fix this issue.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/gc.c    | 2 --
 fs/f2fs/super.c | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index b197a2f..657683c9 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -96,8 +96,6 @@ int start_gc_thread(struct f2fs_sb_info *sbi)
 	dev_t dev = sbi->sb->s_bdev->bd_dev;
 	int err = 0;
 
-	if (!test_opt(sbi, BG_GC))
-		goto out;
 	gc_th = kmalloc(sizeof(struct f2fs_gc_kthread), GFP_KERNEL);
 	if (!gc_th) {
 		err = -ENOMEM;
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 512ffd8..536d414 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1138,7 +1138,7 @@ try_onemore:
 	 * If filesystem is not mounted as read-only then
 	 * do start the gc_thread.
 	 */
-	if (!f2fs_readonly(sb)) {
+	if (test_opt(sbi, BG_GC) && !f2fs_readonly(sb)) {
 		/* After POR, we can run background GC thread.*/
 		err = start_gc_thread(sbi);
 		if (err)
-- 
2.1.2


