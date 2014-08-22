Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbaHVM6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:58:41 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:54625 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026AbaHVM6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:58:39 -0400
Date: Fri, 22 Aug 2014 15:58:27 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] partition-generic: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Message-ID: <20140822125827.GA19302@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The uses of "rcu_assign_pointer()" are NULLing out the pointers.
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
 block/partition-generic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/partition-generic.c b/block/partition-generic.c
index 789cdea..f1ef057 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -249,8 +249,8 @@ void delete_partition(struct gendisk *disk, int partno)
 	if (!part)
 		return;
 
-	rcu_assign_pointer(ptbl->part[partno], NULL);
-	rcu_assign_pointer(ptbl->last_lookup, NULL);
+	RCU_INIT_POINTER(ptbl->part[partno], NULL);
+	RCU_INIT_POINTER(ptbl->last_lookup, NULL);
 	kobject_put(part->holder_dir);
 	device_del(part_to_dev(part));
 	blk_free_devt(part_devt(part));
-- 
1.9.1

