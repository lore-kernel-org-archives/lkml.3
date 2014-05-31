Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaEaSMf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 14:12:35 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:50702 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbaEaSMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 14:12:34 -0400
Message-ID: <538A1B75.5030107@gmail.com>
Date: Sun, 01 Jun 2014 02:12:05 +0800
From: mnipxh <mnipxh@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        yanmin_zhang@linux.intel.com, shuox.liu@intel.com
Subject: [PATCH] fs/buffer.c: grow_buffers: fix the uncorrect check
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When pgoff_t index is 32bit, sector_t block is 64bit, need check if block number is too big.
If block is bigger than (4Gb * PAGE_SIZE), index becomes a wrong value.
Commit e5657933863f43cc6bb76a54d659303dafaa9e58 wants to do this. But it gives an uncorrect check.
I think block != index << sizebits is correct. And it can detect such issue above.

Signed-off-by: xinhui.pan <xinhuix.pan@intel.com>
---
 fs/buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 9ddb9fc..1a674a6 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1081,7 +1081,7 @@ grow_buffers(struct block_device *bdev, sector_t block, int size)
 	 * Check for a block which wants to lie outside our maximum possible
 	 * pagecache index.  (this comparison is done using sector_t types).
 	 */
-	if (unlikely(index != block >> sizebits)) {
+	if (unlikely(block != index << sizebits)) {
 		char b[BDEVNAME_SIZE];
 
 		printk(KERN_ERR "%s: requested out-of-range block %llu for "
-- 
1.9.1
