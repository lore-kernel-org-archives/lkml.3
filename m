Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaJCM7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:59:01 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:39394 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaJCM66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:58:58 -0400
X-Greylist: delayed 1839 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Oct 2014 08:58:58 EDT
From: Sebastien Buisson <sebastien.buisson@bull.net>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] Increase the buffer-head per-CPU LRU size
Date: Fri,  3 Oct 2014 14:28:10 +0200
Message-Id: <1412339290-32552-1-git-send-email-sebastien.buisson@bull.net>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increase the buffer-head per-CPU LRU size to allow efficient
filesystem operations that access many blocks for each transaction.
For example, creating a file in a large ext4 directory with quota
enabled will access multiple buffer heads and will overflow the LRU
at the default 8-block LRU size:

* parent directory inode table block (ctime, nlinks for subdirs)
* new inode bitmap
* inode table block
* 2 quota blocks
* directory leaf block (not reused, but pollutes one cache entry)
* 2 levels htree blocks (only one is reused, other pollutes cache)
* 2 levels indirect/index blocks (only one is reused)

The buffer-head per-CPU LRU size is raised to 16, as it shows in
metadata performance benchmarks up to 10% gain for create,
4% for lookup and 7% for destroy.

Signed-off-by: Liang Zhen <liang.zhen@intel.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Sebastien Buisson <sebastien.buisson@bull.net>
---
 fs/buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 6024877..a6468f2 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1256,7 +1256,7 @@ static struct buffer_head *__bread_slow(struct buffer_head *bh)
  * a local interrupt disable for that.
  */
 
-#define BH_LRU_SIZE	8
+#define BH_LRU_SIZE	16
 
 struct bh_lru {
 	struct buffer_head *bhs[BH_LRU_SIZE];
-- 
1.7.1

