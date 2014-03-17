Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbaCQIhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 04:37:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26026 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaCQIhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 04:37:45 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-4e-5326b44ea94f
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev] [PATCH 2/2] f2fs: avoid to return incorrect errno of
 read_normal_summaries
Date: Mon, 17 Mar 2014 16:36:24 +0800
Message-id: <000201cf41bc$250d00e0$6f2702a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9BufEUrGpNfFM4S5ekduuv4oAwvg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jQV3/LWrBBsdWsFpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAldG05ClLwWmOivaZ
	vawNjL/Zuhg5OSQETCS+bNkIZYtJXLi3Hsjm4hASmM4ocenlS2YI5wejxPz+bywgVWwCKhLL
	O/4zgdgiAooSG95vYAexmQUyJe41zQBq4OAQFkiQaJmoDRJmEVCVuHPhA1gJr4ClxIzDU9kg
	bEGJH5PvsUC0akms33mcCcKWl9i85i0zxEEKEjvOvmYEGSkioCex53QuRIm4xMYjt1gmMArM
	QjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4DB+Jr2DcVWDxSFG
	AQ5GJR7eCcpqwUKsiWXFlbmHGCU4mJVEeHnXAoV4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1
	DhQSSE8sSc1OTS1ILYLJMnFwSjUw6lz59FPs7+SVthMsC/N65nm9eBWu+nD6YcFZuaaa1rln
	t3XrVKSr9FWf9K4p6uC79pmj5l7rtd6OIyrci+x0bvDHbxAq3hh0IYd765bq2YKHe6Ocls42
	9POSWiJeVzD/Vc/mQ6H/HAxnXZgeenjlv/uS1S+ebYqZ+tx7sWXuI8bTiYeYjigeVmIpzkg0
	1GIuKk4EAKtpTa5fAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should return error number of read_normal_summaries instead of -EINVAL when
read_normal_summaries failed.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/segment.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index b3f8431..6c5a4f0 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1186,6 +1186,7 @@ static int read_normal_summaries(struct f2fs_sb_info *sbi, int type)
 static int restore_curseg_summaries(struct f2fs_sb_info *sbi)
 {
 	int type = CURSEG_HOT_DATA;
+	int err;
 
 	if (is_set_ckpt_flags(F2FS_CKPT(sbi), CP_COMPACT_SUM_FLAG)) {
 		/* restore for compacted data summary */
@@ -1194,9 +1195,12 @@ static int restore_curseg_summaries(struct f2fs_sb_info *sbi)
 		type = CURSEG_HOT_NODE;
 	}
 
-	for (; type <= CURSEG_COLD_NODE; type++)
-		if (read_normal_summaries(sbi, type))
-			return -EINVAL;
+	for (; type <= CURSEG_COLD_NODE; type++) {
+		err = read_normal_summaries(sbi, type);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
-- 
1.7.9.5


