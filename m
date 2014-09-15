Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbaIOKFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:05:37 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:56574 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbaIOKFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:05:35 -0400
X-AuditID: cbfee61b-f79f86d00000144c-9f-5416b9ee3426
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 4/5] f2fs: fix to clean previous mount option when
 remount_fs
Date: Mon, 15 Sep 2014 18:04:44 +0800
Message-id: <003001cfd0cc$96f9e8e0$c4edbaa0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac/MlAPAtCsg9ZRvTemoOroic2ILlA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jQd13O8VCDPbvlLa4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxqG+NUwF
	79krlrdtZ2tg3MTWxcjJISFgIrH63CRmCFtM4sK99UBxLg4hgemMEsdWf4ByfjBK9C+dDVbF
	JqAisbzjPxOILSLgJTFp/wkWEJtZwEOiseM7K4gtLBApsW/idDCbRUBVYvv9qWD1vAKWEscX
	72GDsAUlfky+B9WrJbF+53EmCFteYvOat1AXKUjsOPuaEWKXnsTJS/1QNeISG4/cYpnAKDAL
	yahZSEbNQjJqFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCg/qZ9A7GVQ0WhxgF
	OBiVeHgL+8RChFgTy4orcw8xSnAwK4nwTt0KFOJNSaysSi3Kjy8qzUktPsQozcGiJM57sNU6
	UEggPbEkNTs1tSC1CCbLxMEp1cBYx6l3rpdpgXvDnb0iRWnFcl6t02WnV38/80bgAtOEI32L
	3KMnPJrTa/GPNUe9avbMuQICNy/3tXxtq7zBto5nt9o1zYmBZ6ImS9Zn9ywM0nsmGbtrjc1h
	Gy41dr1laQzRwipO+gs53gS+dFz1/H+4asUad6V8F0VBOU/NWwdKI9Wmuro/dVZiKc5INNRi
	LipOBAByBTg4ZgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In manual of mount, we descript remount as below:

"mount -o remount,rw /dev/foo /dir
After  this call all old mount options are replaced and arbitrary stuff from
fstab is ignored, except the loop= option which is internally generated and
maintained by the mount command."

Previously f2fs do not clear up old mount options when remount_fs, so we have no
chance of disabling previous option (e.g. flush_merge). Fix it.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 54444bb..90fcbe0 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -616,6 +616,9 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 	org_mount_opt = sbi->mount_opt;
 	active_logs = sbi->active_logs;
 
+	sbi->mount_opt.opt = 0;
+	sbi->active_logs = NR_CURSEG_TYPE;
+
 	/* parse mount options */
 	err = parse_options(sb, data);
 	if (err)
-- 
2.0.1.474.g72c7794


