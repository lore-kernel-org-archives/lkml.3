Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab3KUIsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 03:48:40 -0500
Received: from mail.wi-flare.com ([203.86.34.34]:55198 "EHLO
	mail.innofidei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab3KUIsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 03:48:39 -0500
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Nov 2013 03:48:39 EST
X-Spam-Processed: mail.innofidei.com, Thu, 21 Nov 2013 16:39:44 +0800
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: zhanghonghui@innofidei.com
X-MDRemoteIP: 220.178.102.82
X-Return-Path: zhanghonghui@innofidei.com
X-Envelope-From: zhanghonghui@innofidei.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: Hans Zhang <zhanghonghui@innofidei.com>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: zhouguangming@innofidei.com, Hans Zhang <zhanghonghui@innofidei.com>
Subject: [PATCH] Make the mtdblock read/write skip the bad nand sector
Date: Thu, 21 Nov 2013 16:39:04 +0800
Message-Id: <1385023144-10721-1-git-send-email-zhanghonghui@innofidei.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 When read/write the nandblock device, it will abort writing if
 there's a bad block, it's reasonable to skip the bad block and
 finish the data writing.
 The data reading procedure should also skip the bad block since
 there's no data write to the block.

Signed-off-by: Hans Zhang <zhanghonghui@innofidei.com>
---
 drivers/mtd/mtdblock.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/mtdblock.c b/drivers/mtd/mtdblock.c
index 485ea75..66e3b23 100644
--- a/drivers/mtd/mtdblock.c
+++ b/drivers/mtd/mtdblock.c
@@ -124,6 +124,14 @@ static int write_cached_data (struct mtdblk_dev *mtdblk)
 			"at 0x%lx, size 0x%x\n", mtd->name,
 			mtdblk->cache_offset, mtdblk->cache_size);
 
+retry:
+	if (mtd->block_isbad) {
+		ret = mtd->block_isbad(mtd, mtdblk->cache_offset);
+		if (ret > 0) {
+			mtdblk->cache_offset += mtdblk->cache_size;
+			goto retry;
+		}
+	}
 	ret = erase_write (mtd, mtdblk->cache_offset,
 			   mtdblk->cache_size, mtdblk->cache_data);
 	if (ret)
@@ -163,6 +171,13 @@ static int do_cached_write (struct mtdblk_dev *mtdblk, unsigned long pos,
 			size = len;
 
 		if (size == sect_size) {
+			if (mtd->block_isbad) {
+				ret = mtd->block_isbad(mtd, pos);
+				if (ret > 0) {
+					pos += sect_size;
+					continue;
+				}
+			}
 			/*
 			 * We are covering a whole sector.  Thus there is no
 			 * need to bother with the cache while it may still be
@@ -242,6 +257,13 @@ static int do_cached_read (struct mtdblk_dev *mtdblk, unsigned long pos,
 		    mtdblk->cache_offset == sect_start) {
 			memcpy (buf, mtdblk->cache_data + offset, size);
 		} else {
+			if (mtd->block_isbad) {
+				ret = mtd->block_isbad(mtd, pos);
+				if (ret > 0) {
+					pos += sect_size;
+					continue;
+				}
+			}
 			ret = mtd_read(mtd, pos, size, &retlen, buf);
 			if (ret)
 				return ret;
-- 
1.7.1


“This E-mail and its attachments may contain legally privileged or confidential information from Innofidei Corporation. Any unauthorized copy, use, disclosure or distribution of this information is strictly prohibited. If you are not the intended recipient, please notify the sender immediately by E-mail or telephone and delete this E-mail and all its attachments immediately.
本邮件及其附件内容可能包含创毅公司享有专有法律权利的或者需要保密的信息。严禁任何人未经发件人许可以任何形式复制、使用、披露或者散发此项信息。如果您不是该收件人，请您立即通过邮件或者电话通知发件人并立即删除本邮件及其附件内容.”


