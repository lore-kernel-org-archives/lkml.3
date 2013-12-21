Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab3LUKCN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 05:02:13 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:49368 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3LUKCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 05:02:11 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-91-52b567218e98
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [f2fs-dev] [PATCH 1/3] f2fs: check filename length in recover_dentry
Date: Sat, 21 Dec 2013 18:01:24 +0800
Message-id: <000001cefe33$b62a0f40$227e2dc0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7+M5UIUgHNrpBpS7i590M+yA7imA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jAV3F9K1BBg/eCVtc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlTFxaQ9bwRXuit5F
	Ng2M2zm7GDk5JARMJH7/3cYIYYtJXLi3nq2LkYtDSGARo8SsVTeYIZwfjBJrtp1mAaliE1CR
	WN7xnwnEFhFQlNjwfgM7iM0skCkx5/VkVhBbWMBXYt2prWA1LAKqEhMO7gDr5RWwlLh0bCkT
	hC0o8WPyPRaIXi2J9TuPM0HY8hKb17xlhrhIQWLH2deMELv0JKbNWsUKUSMusfHILZYJjAKz
	kIyahWTULCSjZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOJCfSe9gXNVgcYhR
	gINRiYdXInJLkBBrYllxZe4hRgkOZiUR3o+hW4OEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5s
	tQ4UEkhPLEnNTk0tSC2CyTJxcEo1MNp8/hRpqpr9zDxC+dpGw10RH+vWlBU9OLGefbKhusrV
	fkGtu5fTnhb4xTJPvTvnwBNte58nlYbes717dJ/42T+c/OrXjb1zpvPO9opXy9upJsdTw8+m
	dfnJ/ey2s5ckdXc/VJJ9tCd9wZc906u5Ld/NqT94R3DGtbUbzU3kF9o+3vB1zrWd872VWIoz
	Eg21mIuKEwG7SvEjYAIAAA==
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

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/dir.c      |    3 ---
 fs/f2fs/recovery.c |    5 +++++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 0cc26ba..3f3b661 100644
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
index a3f4542..fdd175b 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -62,6 +62,11 @@ static int recover_dentry(struct page *ipage, struct inode *inode)
 
 	name.len = le32_to_cpu(raw_inode->i_namelen);
 	name.name = raw_inode->i_name;
+
+	if (unlikely(name.len > F2FS_NAME_LEN)) {
+		err = -ENAMETOOLONG;
+		goto out;
+	}
 retry:
 	de = f2fs_find_entry(dir, &name, &page);
 	if (de && inode->i_ino == le32_to_cpu(de->ino))
-- 
1.7.9.5

