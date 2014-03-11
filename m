Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaCKFiv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 01:38:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:12934 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbaCKFiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 01:38:50 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-68-531ea1680b58
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev] [PATCH] f2fs: recover inline xattr data in roll-forward
 process
Date: Tue, 11 Mar 2014 13:37:38 +0800
Message-id: <001401cf3cec$2daf5f10$890e1d30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac8861nrJxY+t67bQ96bYWRVguqZUA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t9jQd2MhXLBBhs3WVpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfHv3ALmguu8FfNu
	PGJpYFzN3cXIySEhYCLRu6uZCcIWk7hwbz1bFyMXh5DAdEaJx/dmMUI4Pxgltp/7ClbFJqAi
	sbzjP5gtIqAoseH9BnYQm1kgU+Je0wxmEFtYIFRi28MbrCA2i4CqxLPl7WD1vAKWEvcuX2aE
	sAUlfky+xwLRqyWxfudxJghbXmLzmrfMEBcpSOw4+5oRYpeexIO1LcwQNeISG4/cYpnAKDAL
	yahZSEbNQjJqFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCQ/mZ9A7GVQ0WhxgF
	OBiVeHhX+MsFC7EmlhVX5h5ilOBgVhLhPW0BFOJNSaysSi3Kjy8qzUktPsQozcGiJM57sNU6
	UEggPbEkNTs1tSC1CCbLxMEp1cC44kbbtpPWWfV7fm77dnXJnme9+eKM298eOG8j/1Sy4pK1
	tePb0he9HmvEVbYl7z3OFb+sWNGQN2RtyNHfvjN36rJPvlLTcjlhup2wRlBBU0Apl/YK+dnV
	SbsfZ3NFtvTd1Nft4L71YfnEw4JB0qr9Zff39CddYuPQbpqlHawreENXwC/3/lklluKMREMt
	5qLiRACv0dP4YQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously we do not recover inline xattr data of inode after power-cut, so
inline xattr data may be lost.
We should recover the data during the roll-forward process.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/node.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index c415cec..e72b258 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1493,6 +1493,37 @@ void recover_node_page(struct f2fs_sb_info *sbi, struct page *page,
 	clear_node_page_dirty(page);
 }
 
+void recover_inline_xattr(struct inode *inode, struct page *page)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	void *src_addr, *dst_addr;
+	size_t inline_size;
+	struct page *ipage;
+	struct f2fs_inode *ri;
+
+	if (!is_inode_flag_set(F2FS_I(inode), FI_INLINE_XATTR))
+		return;
+
+	if (!IS_INODE(page))
+		return;
+
+	ri = F2FS_INODE(page);
+	if (!(ri->i_inline & F2FS_INLINE_XATTR))
+		return;
+
+	ipage = get_node_page(sbi, inode->i_ino);
+	f2fs_bug_on(IS_ERR(ipage));
+
+	dst_addr = inline_xattr_addr(ipage);
+	src_addr = inline_xattr_addr(page);
+	inline_size = inline_xattr_size(inode);
+
+	memcpy(dst_addr, src_addr, inline_size);
+
+	update_inode(inode, ipage);
+	f2fs_put_page(ipage, 1);
+}
+
 bool recover_xattr_data(struct inode *inode, struct page *page, block_t blkaddr)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
@@ -1500,6 +1531,8 @@ bool recover_xattr_data(struct inode *inode, struct page *page, block_t blkaddr)
 	nid_t new_xnid = nid_of_node(page);
 	struct node_info ni;
 
+	recover_inline_xattr(inode, page);
+
 	if (ofs_of_node(page) != XATTR_NODE_OFFSET)
 		return false;
 
-- 
1.7.9.5


