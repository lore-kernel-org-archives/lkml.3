Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab3HSBzN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 21:55:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:40872 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab3HSBzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 21:55:11 -0400
X-IronPort-AV: E=Sophos;i="4.89,909,1367942400"; 
   d="scan'208,223";a="8235889"
Message-ID: <52117A03.4030800@cn.fujitsu.com>
Date: Mon, 19 Aug 2013 09:50:59 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH] f2fs: fix a compound statement label error
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/19 09:53:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/19 09:53:28,
	Serialize complete at 2013/08/19 09:53:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 685b72b66cb8ce019429b1958c91f346b260bc65 Mon Sep 17 00:00:00 2001
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Date: Mon, 19 Aug 2013 09:41:15 +0800
Subject: [PATCH] f2fs: fix a compound statement label error
An error "label at end of compound statement" will occur if CONFIG_F2FS_STAT_FS
disabled.
fs/f2fs/segment.c:556:1: error: label at end of compound statement
So clean up the 'out' label to fix it.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/segment.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 9c45b8e..09af9c7 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -540,12 +540,9 @@ static void allocate_segment_by_default(struct f2fs_sb_info *sbi,
 {
 	struct curseg_info *curseg = CURSEG_I(sbi, type);
 
-	if (force) {
+	if (force)
 		new_curseg(sbi, type, true);
-		goto out;
-	}
-
-	if (type == CURSEG_WARM_NODE)
+	else if (type == CURSEG_WARM_NODE)
 		new_curseg(sbi, type, false);
 	else if (curseg->alloc_type == LFS && is_next_segment_free(sbi, type))
 		new_curseg(sbi, type, false);
@@ -553,7 +550,6 @@ static void allocate_segment_by_default(struct f2fs_sb_info *sbi,
 		change_curseg(sbi, type, true);
 	else
 		new_curseg(sbi, type, false);
-out:
 #ifdef CONFIG_F2FS_STAT_FS
 	sbi->segment_count[curseg->alloc_type]++;
 #endif
-- 
1.7.7

