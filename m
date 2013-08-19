Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159Ab3HSQhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:37:14 -0400
Received: from etezian.org ([198.101.225.253]:41454 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073Ab3HSQhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:37:11 -0400
From: Andi Shyti <andi@etezian.org>
To: josh.h.morris@us.ibm.com, pjk1939@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, andi@etezian.org
Subject: [PATCH v2 1/1] rsxx: core: fix memory leak
Date: Mon, 19 Aug 2013 18:36:36 +0200
Message-Id: <1376930196-21785-2-git-send-email-andi@etezian.org>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1376930196-21785-1-git-send-email-andi@etezian.org>
References: <1376907631-13725-1-git-send-email-andi@etezian.org>
 <1376930196-21785-1-git-send-email-andi@etezian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free 'buf' before returning.

the 'rsxx_cram_write()' function returns twice without freeing
the allocated buffer 'buf' causing a possible memory leak.

This issue has been reported by scan.coverity.com

Signed-off-by: Andi Shyti <andi@etezian.org>
---
 drivers/block/rsxx/core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
index 6e85e21..fa3740b 100644
--- a/drivers/block/rsxx/core.c
+++ b/drivers/block/rsxx/core.c
@@ -224,19 +224,20 @@ static ssize_t rsxx_cram_write(struct file *fp, const char __user *ubuf,
 
 	st = copy_from_user(buf, ubuf, cnt);
 	if (st)
-		return st;
+		goto exit;
 
 	info->f_pos = (u32)*ppos + info->offset;
 
 	st = rsxx_creg_write(card, CREG_ADD_CRAM + info->f_pos, cnt, buf, 1);
 	if (st)
-		return st;
+		goto exit;
 
 	info->offset += cnt;
 
+exit:
 	kfree(buf);
 
-	return cnt;
+	return st ? st : cnt;
 }
 
 static int rsxx_cram_open(struct inode *inode, struct file *file)
-- 
1.8.4.rc2

