Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbaHVMwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:52:17 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:51112 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982AbaHVMwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:52:16 -0400
Date: Fri, 22 Aug 2014 15:52:07 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] genhd: Replace rcu_assign_pointer() with RCU_INIT_POINTER()
Message-ID: <20140822125207.GA19101@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of "rcu_assign_pointer()" is NULLing out the pointer.
According to RCU_INIT_POINTER()'s block comment:
"1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
it is better to use it instead of rcu_assign_pointer() because it has a
smaller overhead.

The following Coccinelle semantic patch was used:
@@
@@

- rcu_assign_pointer
+ RCU_INIT_POINTER
  (..., NULL)

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 block/genhd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index 791f419..3aec057 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1045,7 +1045,7 @@ static void disk_replace_part_tbl(struct gendisk *disk,
 	rcu_assign_pointer(disk->part_tbl, new_ptbl);
 
 	if (old_ptbl) {
-		rcu_assign_pointer(old_ptbl->last_lookup, NULL);
+		RCU_INIT_POINTER(old_ptbl->last_lookup, NULL);
 		kfree_rcu(old_ptbl, rcu_head);
 	}
 }
-- 
1.9.1

