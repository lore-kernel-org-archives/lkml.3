Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbaHIBua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 21:50:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:57392 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaHIBu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 21:50:29 -0400
X-AuditID: cbfee61b-f79f86d00000144c-e1-53e57e63ae51
From: Chao Yu <chao2.yu@samsung.com>
To: jack@suse.cz
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] udf: avoid unneeded up_write when fail to add entry in
 ->symlink
Date: Sat, 09 Aug 2014 09:49:31 +0800
Message-id: <00bd01cfb374$4b397a30$e1ac6e90$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+zclpAfPYI4+1xTqGoOkQ5rFBsiQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t9jQd3kuqfBBpe3GFjMnt7MZHF51xw2
	ByaPMwuOsHt83iQXwBTFZZOSmpNZllqkb5fAlXFt3wrmghnsFe0/6xoYv7F2MXJySAiYSGxu
	e88OYYtJXLi3nq2LkYtDSGA6o8SPs6ehnB+MEotmfmAGqWITUJFY3vGfCcQWERCQeHvsJxuI
	zSygIPHr3iawqcICwRLb5/xkBLFZBFQlNt58CxbnFbCUWLtmKyOELSjxY/I9FoheLYnN25pY
	IWx5ic1r3jJDXKQgsePsa0aIXXoSN6buZIeoEZfYeOQWywRGgVlIRs1CMmoWklGzkLQsYGRZ
	xSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcrM+kdzCuarA4xCjAwajEw7vC5mmwEGtiWXFl
	7iFGCQ5mJRHehZVAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHW60DhQTSE0tSs1NTC1KLYLJM
	HJxSDYz+/PWdC29ca1qr1XQ58+6D7bPfSXDfFTy8eeuXVc9/XG5evmv5Egc9YzP1A+fT1hZ9
	2n120hTvdW3xVot2snvGrvuer3g/+sB8A23N0v+vVEOiy+w2rEnaYvPhSrEQw7veqoYHJ3db
	Fur2s5o+Lzss4580uevdxrysNvuF9wMUtR+e+HCySHu+EktxRqKhFnNRcSIA07Ve41ICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have released the ->i_data_sem before invoking udf_add_entry(),
so in following error path, we should not release this lock again.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/udf/namei.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 9737cba..83a0600 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1014,7 +1014,7 @@ static int udf_symlink(struct inode *dir, struct dentry *dentry,
 
 	fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err);
 	if (!fi)
-		goto out_no_entry;
+		goto out_fail;
 	cfi.icb.extLength = cpu_to_le32(sb->s_blocksize);
 	cfi.icb.extLocation = cpu_to_lelb(iinfo->i_location);
 	if (UDF_SB(inode->i_sb)->s_lvid_bh) {
@@ -1036,6 +1036,7 @@ out:
 
 out_no_entry:
 	up_write(&iinfo->i_data_sem);
+out_fail:
 	inode_dec_link_count(inode);
 	iput(inode);
 	goto out;
-- 
2.0.1.474.g72c7794


