Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbaIOKEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:04:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64375 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaIOKEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:04:21 -0400
X-AuditID: cbfee61a-f79e46d00000134f-f7-5416b9a341a6
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 3/5] f2fs: skip punching hole in special condition
Date: Mon, 15 Sep 2014 18:03:32 +0800
Message-id: <002f01cfd0cc$6a4c3a00$3ee4ae00$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac/MEw4AdHM6AqA0TQS/1qhs8GYjbw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jQd3FO8VCDHrXaFtc29fIZPFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr49mEFewF
	V9gqri9vYWtgXMXaxcjJISFgIvH3238oW0ziwr31bF2MXBxCAtMZJZYfOccC4fxglOh62sEC
	UsUmoCKxvOM/E4gtIuAlMWn/CbA4s4CHRGPHd7BJwgI+EtPmrAOLswioStzfNAXM5hWwlPh9
	bQ4jhC0o8WPyPaheLYn1O48zQdjyEpvXvGWGuEhBYsfZ14wQu/QkWo68ZYeoEZfYeOQWywRG
	gVlIRs1CMmoWklGzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc1M+kdjCubLA4
	xCjAwajEw1vQJxYixJpYVlyZe4hRgoNZSYR36lagEG9KYmVValF+fFFpTmrxIUZpDhYlcd4D
	rdaBQgLpiSWp2ampBalFMFkmDk6pBsa55/yfmYd3yU3pdrFeX6OpY7q0wy9wachnV49vNtfZ
	vosueHQol1ms+kDdBVkJ2dVrv5w5wsieF2eg8pFz18bH8+dEBR9bsP3gx3hTM+ewsv2ivMIf
	N2xInrvF9EnXlj3p+tmxdcktZRL5H591bTFv2iDq/kv+gh13eLNejuebj1NiWfRXOCmxFGck
	GmoxFxUnAgBr78DNZgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now punching hole in directory is not supported in f2fs, so let's limit file
type in punch_hole().

In addition, in punch_hole if offset is exceed file size, we should skip
punching hole.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/file.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 7b34101..ecf94e1 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -645,6 +645,13 @@ static int punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	loff_t off_start, off_end;
 	int ret = 0;
 
+	if (!S_ISREG(inode->i_mode))
+		return -EOPNOTSUPP;
+
+	/* skip punching hole beyond i_size */
+	if (offset >= inode->i_size)
+		return ret;
+
 	ret = f2fs_convert_inline_data(inode, MAX_INLINE_DATA + 1, NULL);
 	if (ret)
 		return ret;
-- 
2.0.1.474.g72c7794


