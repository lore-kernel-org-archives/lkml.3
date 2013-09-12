Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637Ab3ILDWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 23:22:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:42252 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752080Ab3ILDWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 23:22:49 -0400
X-IronPort-AV: E=Sophos;i="4.90,888,1371052800"; 
   d="scan'208";a="8499497"
Message-ID: <5231325F.3090700@cn.fujitsu.com>
Date: Thu, 12 Sep 2013 11:17:51 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: jaegeuk.kim@samsung.com
CC: =?UTF-8?B?5L+e6LaF?= <chao2.yu@samsung.com>, shu.tan@samsung.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [f2fs-dev][PATCH V2] f2fs: optimize fs_lock for better performance
References: <88.C4.11914.9D4A9225@epcpsbge6.samsung.com> <1378774324.2354.103.camel@kjgkr> <523001B6.3080506@cn.fujitsu.com> <001001ceaf61$a4ea9a90$eebfcfb0$@samsung.com>
In-Reply-To: <001001ceaf61$a4ea9a90$eebfcfb0$@samsung.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/12 11:20:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/12 11:20:19,
	Serialize complete at 2013/09/12 11:20:19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yu Chao <chao2.yu@samsung.com>

There is a performance problem: when all sbi->fs_lock are holded, then
all the following threads may get the same next_lock value from sbi->next_lock_num
in function mutex_lock_op, and wait for the same lock(fs_lock[next_lock]),
it may cause performance reduce.
So we move the sbi->next_lock_num++ before getting lock, this will average the
following threads if all sbi->fs_lock are holded. 

v1-->v2:
	Drop the needless spin_lock as Jaegeuk suggested.

Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Signed-off-by: Yu Chao <chao2.yu@samsung.com>
Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/f2fs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 608f0df..7fd99d8 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -544,15 +544,15 @@ static inline void mutex_unlock_all(struct f2fs_sb_info *sbi)
 
 static inline int mutex_lock_op(struct f2fs_sb_info *sbi)
 {
-	unsigned char next_lock = sbi->next_lock_num % NR_GLOBAL_LOCKS;
+	unsigned char next_lock;
 	int i = 0;
 
 	for (; i < NR_GLOBAL_LOCKS; i++)
 		if (mutex_trylock(&sbi->fs_lock[i]))
 			return i;
 
+	next_lock = sbi->next_lock_num++ % NR_GLOBAL_LOCKS;
 	mutex_lock(&sbi->fs_lock[next_lock]);
-	sbi->next_lock_num++;
 	return next_lock;
 }
 
-- 
1.7.7


