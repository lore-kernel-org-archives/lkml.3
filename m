Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbaA1C3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 21:29:53 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:35758 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbaA1C3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 21:29:51 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-3a-52e7161e65f8
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [f2fs-dev] [PATCH] f2fs: use inode mutex to keep atomicity of
 f2fs_falloc
Date: Tue, 28 Jan 2014 10:29:26 +0800
Message-id: <000101cf1bd0$d1f6be70$75e43b50$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac8aNi3IVLq3MizOTxaaQ1oWhdRJbA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jQV05sedBBmtPaVtc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXFnfnDBJ/aKXz8e
	sTYwbmfrYuTkkBAwkXjbOIcFwhaTuHBvPVCci0NIYDqjxN/+o+wQzg9GidUXVzGBVLEJqEgs
	7/gPZosIKEpseL+BHcRmFsiUmPN6MiuILSwQIvFg+y4gm4ODRUBV4vNaDxCTV8BSYt5/XZAK
	XgFBiR+T77FAdGpJrN95nAnClpfYvOYtM8Q9ChI7zr5mhNikJ9Gw7jpUjbjExiO3WCYwCsxC
	MmoWklGzkIyahaRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgIH4mvYNxVYPFIUYB
	DkYlHt4H3c+ChFgTy4orcw8xSnAwK4nwnp0CFOJNSaysSi3Kjy8qzUktPsQozcGiJM57sNU6
	UEggPbEkNTs1tSC1CCbLxMEp1cDoWH0q/MH2Xwfv8RyJPvpPmP1F7/3T2yv3/PvElt3jED5H
	XObA2rbyCPWWO7PvHu58byvA3/DRbi/DZdXCryeeTQtal66ic/6Hw/ppq/Q4HqR9dzOz4N7o
	/kRjw8Kvlu/2Tj8tXNjdenHjhYgj+e9KV087uXbNZW+rGhVrBg622Me/FcqrvTPKlViKMxIN
	tZiLihMBg3KejV4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously without protection of inode mutex, f2fs_falloc and other data
correlated operations will interfere with each other.
So let's use inode mutex to keep atomicity of f2fs_falloc.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/file.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 85e91ca..ece380f 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -559,6 +559,8 @@ static long f2fs_fallocate(struct file *file, int mode,
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
 		return -EOPNOTSUPP;
 
+	mutex_lock(&inode->i_mutex);
+
 	if (mode & FALLOC_FL_PUNCH_HOLE)
 		ret = punch_hole(inode, offset, len);
 	else
@@ -568,6 +570,9 @@ static long f2fs_fallocate(struct file *file, int mode,
 		inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		mark_inode_dirty(inode);
 	}
+
+	mutex_unlock(&inode->i_mutex);
+
 	trace_f2fs_fallocate(inode, mode, offset, len, ret);
 	return ret;
 }
-- 
1.7.9.5

