Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab3AYK4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:56:54 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:56453 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597Ab3AYK4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:56:48 -0500
From: Guo Chao <yan@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] loopdev: ignore negative offset when calculate loop device size
Date: Fri, 25 Jan 2013 18:56:22 +0800
Message-Id: <1359111382-12654-8-git-send-email-yan@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359111382-12654-1-git-send-email-yan@linux.vnet.ibm.com>
References: <1359111382-12654-1-git-send-email-yan@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012510-4790-0000-0000-000006A21546
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Negative offset may cause loop device size larger than backing file
size.

 $ fallocate -l 1M a
 $ losetup --offset 0xffffffffffff0000 /dev/loop0 a
 $ blockdev --getsize64 /dev/loop0
 1114112
 $ ls -l a
 -rw-r--r-- 1 root root 1048576 Jan 23 12:46 a
 $ cat /dev/loop0
 cat: /dev/loop0: Input/output error

It makes no sense to do that. Only apply offset when it's positive.

Fix a typo in the comment by the way.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 drivers/block/loop.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 9190a82..7a235db 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -162,12 +162,13 @@ static struct loop_func_table *xfer_funcs[MAX_LO_CRYPT] = {
 
 static loff_t get_size(loff_t offset, loff_t sizelimit, struct file *file)
 {
-	loff_t size, loopsize;
+	loff_t loopsize;
 
 	/* Compute loopsize in bytes */
-	size = i_size_read(file->f_mapping->host);
-	loopsize = size - offset;
-	/* offset is beyond i_size, wierd but possible */
+	loopsize = i_size_read(file->f_mapping->host);
+	if (offset > 0)
+		loopsize -= offset;
+	/* offset is beyond i_size, weird but possible */
 	if (loopsize < 0)
 		return 0;
 
-- 
1.7.9.5

