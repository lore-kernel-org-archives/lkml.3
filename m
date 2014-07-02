Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaGBFYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 01:24:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:55341 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaGBFYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 01:24:42 -0400
X-AuditID: cbfee61b-f79f86d00000144c-37-53b397988934
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 1/2] f2fs: check name_len of dir entry to prevent
 from deadloop
Date: Wed, 02 Jul 2014 13:23:47 +0800
Message-id: <000001cf95b5$eac71ad0$c0555070$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+VriJ8XHHR/WfMQ/GqSqcyDbufmQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jAd0Z0zcHG0zdK2pxbV8jk8WT9bOY
	LS4tcrfYs/cki8XlXXPYHFg9Nq3qZPPYveAzk0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	PJr1ha2ghaPiw4KbTA2MG9i6GDk5JARMJLYteAZli0lcuLceyObiEBJYxChxee4mVgjnB6PE
	9+MrWECq2ARUJJZ3/GcCsUUEvCQm7T8BFmcWyJS41zSDGcQWFoiWePf+HiuIzSKgKrH08Fyw
	el4BS4kpt9cyQtiCEj8m34Pq1ZJYv/M4E4QtL7F5zVtmiIsUJHacfc0IsUtPovvhRmaIGnGJ
	jUdusUxgFJiFZNQsJKNmIRk1C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjB4f1M
	egfjqgaLQ4wCHIxKPLwRdzcFC7EmlhVX5h5ilOBgVhLhjefZHCzEm5JYWZValB9fVJqTWnyI
	UZqDRUmc92CrdaCQQHpiSWp2ampBahFMlomDU6qBUejiaic7HY1dH3deivi3v+SXI3NRVUbz
	2g+x8zZ12krXr52/9DQL926diTaXS3nVGl6t1T8tF3e1KKdAhJNhk/WHq5Xdn62PhHXHVzxz
	M/Tfs9duSdN7+8pjTu0MWxJE6u85PAvb4bfRVTtGcYbW9Il3Bdb2Fn8r/RsQl7j4Vegefj+F
	gzbzlFiKMxINtZiLihMBtTxOBWsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We assume that modification of some special application could result in zeroed
name_len, or it is consciously made by somebody. We will deadloop in
find_in_block when name_len of dir entry is zero.

This patch is added for preventing deadloop in above scenario.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/dir.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index be8c7af..4316ec5 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -121,6 +121,16 @@ static struct f2fs_dir_entry *find_in_block(struct page *dentry_page,
 			}
 		}
 
+		/* check name_len to prevent from deadloop here */
+		if (unlikely(de->name_len == 0)) {
+			struct inode *inode = dentry_page->mapping->host;
+
+			f2fs_msg(inode->i_sb, KERN_ERR,
+				"zero-length dir entry, ino = %lu, name = %s",
+				(unsigned long)inode->i_ino, name->name);
+			break;
+		}
+
 		bit_start = bit_pos
 				+ GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
 	}
-- 
1.7.9.5


