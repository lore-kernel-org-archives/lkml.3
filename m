Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbaD2GE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 02:04:29 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:65306 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbaD2GE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 02:04:28 -0400
X-AuditID: cbfee61b-b7f766d00000646c-62-535f40eaf897
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 3/3 v3] f2fs: fix to truncate inline data in inode
 page when setattr
Date: Tue, 29 Apr 2014 14:03:40 +0800
Message-id: <001801cf6370$e0553040$a0ff90c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9jcMTJktBElrsyTQul9s322rP4Fw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jQd1XDvHBBn/OWlpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlTFj6kLmgh7hisMt
	f9gaGK/xdzFyckgImEi8mjmVFcIWk7hwbz1bFyMXh5DAdEaJHcu/Qzk/GCUuHF3LBlLFJqAi
	sbzjPxOILSKgKLHh/QZ2EJtZIFPiXtMMZhBbWCBBornzKVANBweLgKrExD4LkDCvgKVE747F
	zBC2oMSPyfdYIFq1JNbvPM4EYctLbF7zlhniIAWJHWdfM0Ks0pM4tPg9I0SNuMTGI7dYJjAK
	zEIyahaSUbOQjJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOBAfia9g3FVg8Uh
	RgEORiUe3o6YuGAh1sSy4srcQ4wSHMxKIrz5VvHBQrwpiZVVqUX58UWlOanFhxilOViUxHkP
	tloHCgmkJ5akZqemFqQWwWSZODilGhi1ps4ofB8r7OyyVHLLNAWHDVZ+JY/uly8473K6yG9L
	3erN8yu/VDIFffD4waJS5K+pFxIvrmV+4P65iMd/nr0sdd4qP5nDr9bot7CxLqOE+brT/uJb
	9A9wt3ne8Fmn7NAZ5yFsftbeqnFi46c5JXu12o2WV60yu3r46bkbnmEONxPXb7lyhU+JpTgj
	0VCLuag4EQB6ANzCYAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous we do not truncate inline data in inode page when setattr, so following
case could still read the inline data which has already truncated:

1.write inline data
2.ftruncate size to 0
3.ftruncate size to max inline data size
4.read from offset 0

This patch introduces truncate_inline_data() to fix this problem.

change log from v1:
 o fix a bug and do not truncate first page data after truncate inline data.
change log from v2:
 o wait to writeback for inode page if it was already submitted.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/f2fs.h   |    1 +
 fs/f2fs/file.c   |    3 +++
 fs/f2fs/inline.c |   19 +++++++++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 2b67679..676a2c6 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1410,5 +1410,6 @@ bool f2fs_may_inline(struct inode *);
 int f2fs_read_inline_data(struct inode *, struct page *);
 int f2fs_convert_inline_data(struct inode *, pgoff_t);
 int f2fs_write_inline_data(struct inode *, struct page *, unsigned int);
+void truncate_inline_data(struct inode *, u64);
 int recover_inline_data(struct inode *, struct page *);
 #endif
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index b9f4fbf..d97e5c4 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -369,6 +369,9 @@ static void truncate_partial_data_page(struct inode *inode, u64 from)
 	unsigned offset = from & (PAGE_CACHE_SIZE - 1);
 	struct page *page;
 
+	if (f2fs_has_inline_data(inode))
+		return truncate_inline_data(inode, from);
+
 	if (!offset)
 		return;
 
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 3258c7c..6a13997 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -176,6 +176,25 @@ int f2fs_write_inline_data(struct inode *inode,
 	return 0;
 }
 
+void truncate_inline_data(struct inode *inode, u64 from)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct page *ipage;
+
+	if (from >= MAX_INLINE_DATA)
+		return;
+
+	ipage = get_node_page(sbi, inode->i_ino);
+	if (IS_ERR(ipage))
+		return;
+
+	f2fs_wait_on_page_writeback(ipage, NODE);
+	zero_user_segment(ipage, INLINE_DATA_OFFSET + from,
+				INLINE_DATA_OFFSET + MAX_INLINE_DATA);
+	set_page_dirty(ipage);
+	f2fs_put_page(ipage, 1);
+}
+
 int recover_inline_data(struct inode *inode, struct page *npage)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-- 
1.7.9.5


