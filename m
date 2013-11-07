Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab3KGCP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 21:15:57 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:21886 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab3KGCPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 21:15:55 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-34-527af7da9d1f
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH] f2fs: fix memory leak after kobject init failed in
 fill_super
Date: Thu, 07 Nov 2013 10:14:51 +0800
Message-id: <000001cedb5f$497b8190$dc7284b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7bXRj/7AHcFqG9TyWAia3DvMwubw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jAd1b36uCDGaekLe4vusvk8WlRe4W
	e/aeZLG4vGsOm0XrwvPMDqweuxd8ZvLo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujLYDyxgL
	VnJWnF15ia2BcT97FyMHh4SAicTic2ZdjJxAppjEhXvr2boYuTiEBBYxSpz4OJsdwvnBKHHt
	x152kCo2ARWJ5R3/mUBsEQFFiQ3vN4AVMQvMYJQ4PPcfK0hCWCBa4n5HJxuIzSKgKvHm7Qtm
	EJtXwFJi0cSXTBC2oMSPyfdYQGxmAQ2J/kUb2CBseYnNa94yQ5ykILHj7GtGiGV6Ek/eLWSH
	qBGX2HjkFssERoFZSEbNQjJqFpJRs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kR
	HNTPpHYwrmywOMQowMGoxMM7o6YqSIg1say4MvcQowQHs5II771nQCHelMTKqtSi/Pii0pzU
	4kOM0hwsSuK8B1qtA4UE0hNLUrNTUwtSi2CyTBycUg2MplaPXotVRH+dc/jdwU2Zv2be97z5
	S8mW6d8P5Zb6c4ekDFXTb5tJPv947+mMObILzseEBPh1r2AU+DZlhcHuaef1nofKSbdz23UV
	GAbLvT3iIvX0xr5/nPNdNns5LZnHtWhLqqo7U6/+YfVf2rMDP1RteJpals1/ZnGucDXb26aO
	zVYZT/OtlViKMxINtZiLihMBsLGXZ2YCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we failed to init&add kobject when fill_super, stats info and proc object of f2fs will not be released.
We should free them before we finish fill_super.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/super.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index e42351c..a754d14 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -974,12 +974,12 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 		/* After POR, we can run background GC thread.*/
 		err = start_gc_thread(sbi);
 		if (err)
-			goto fail;
+			goto free_gc;
 	}
 
 	err = f2fs_build_stats(sbi);
 	if (err)
-		goto fail;
+		goto free_gc;
 
 	if (f2fs_proc_root)
 		sbi->s_proc = proc_mkdir(sb->s_id, f2fs_proc_root);
@@ -1005,6 +1005,12 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 
 	return 0;
 fail:
+	if (sbi->s_proc) {
+		remove_proc_entry("segment_info", sbi->s_proc);
+		remove_proc_entry(sb->s_id, f2fs_proc_root);
+	}
+	f2fs_destroy_stats(sbi);
+free_gc:
 	stop_gc_thread(sbi);
 free_root_inode:
 	dput(sb->s_root);
-- 
1.7.9.5

