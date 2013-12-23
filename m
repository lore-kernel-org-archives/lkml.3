Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab3LWDNZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 22:13:25 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:64424 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756497Ab3LWDNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 22:13:23 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-f3-52b7aa52b66e
From: Chao Yu <chao2.yu@samsung.com>
To: "'???'" <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [f2fs-dev] [PATCH 1/3 V2] f2fs: check filename length in recover_dentry
Date: Mon, 23 Dec 2013 11:12:21 +0800
Message-id: <002201ceff8c$efbd2da0$cf3788e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7/ixxdhhgR9BhkScWIWCa+1Y0yoQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t9jAd2gVduDDH6857W4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK2PW7uOsBTN4Kjae
	mcHSwPiKs4uRk0NCwERi8t3DTBC2mMSFe+vZuhi5OIQEFjFKPNp+EMr5wSjRMWUOK0gVm4CK
	xPKO/2AdIgLKEqs62tlAbGaBTIk5ryeD1QgLBEj8X/8QLM4ioCpxb91SFhCbV8BSYu2ez6wQ
	tqDEj8n3WCB6tSTW7zzOBGHLS2xe85YZ4iIFiR1nXzNC7NKTmNw2iRWiRlxi45FbLBMYBWYh
	GTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwKD+T3sG4qsHiEKMA
	B6MSDy9Hy/YgIdbEsuLK3EOMEhzMSiK80T+2BQnxpiRWVqUW5ccXleakFh9ilOZgURLnPdhq
	HSgkkJ5YkpqdmlqQWgSTZeLglGpgZC6xOlV+Rub2gVqWoNaem17Pgsrdsvb/eTjV/Fu8FXPO
	mo7WXc3isgxBFc8+TfAtP3fJtvfYnOyIOn4n671nAhxE7i5WfFn9POB6mGPKJg6z4+fmmJqF
	zHXo2VSmcaE6Zs60Iyd3bvo4o1TltCZD2abCUmtR1scl/A/7P+7OdDvsOedTuJG/EktxRqKh
	FnNRcSIAeZ+7tmECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current flow, we will get Null return value of f2fs_find_entry in
recover_dentry when name.len is bigger than F2FS_NAME_LEN, and then we
still add this inode into its dir entry.
To avoid this situation, we must check filename length before we use it.

Another point is that we could remove the code of checking filename length
In f2fs_find_entry, because f2fs_lookup will be called previously to ensure of
validity of filename length.

V2:
 o add WARN_ON() as Jaegeuk Kim suggested.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/dir.c      |    3 ---
 fs/f2fs/recovery.c |    6 ++++++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 07ad850..f0b4630 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -190,9 +190,6 @@ struct f2fs_dir_entry *f2fs_find_entry(struct inode *dir,
 	unsigned int max_depth;
 	unsigned int level;
 
-	if (unlikely(namelen > F2FS_NAME_LEN))
-		return NULL;
-
 	if (npages == 0)
 		return NULL;
 
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index a3f4542..4d411a2 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -62,6 +62,12 @@ static int recover_dentry(struct page *ipage, struct inode *inode)
 
 	name.len = le32_to_cpu(raw_inode->i_namelen);
 	name.name = raw_inode->i_name;
+
+	if (unlikely(name.len > F2FS_NAME_LEN)) {
+		WARN_ON(1);
+		err = -ENAMETOOLONG;
+		goto out;
+	}
 retry:
 	de = f2fs_find_entry(dir, &name, &page);
 	if (de && inode->i_ino == le32_to_cpu(de->ino))
-- 
1.7.9.5

