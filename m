Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbaHVMq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:46:56 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:62625 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217AbaHVMqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:46:54 -0400
Date: Fri, 22 Aug 2014 15:46:46 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] blk-ioc: Replace rcu_assign_pointer() with RCU_INIT_POINTER()
Message-ID: <20140822124646.GA18990@ada>
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
 block/blk-ioc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 1a27f45..c024a77 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -69,7 +69,7 @@ static void ioc_destroy_icq(struct io_cq *icq)
 	 * will.  Hint assignment itself can race safely.
 	 */
 	if (rcu_access_pointer(ioc->icq_hint) == icq)
-		rcu_assign_pointer(ioc->icq_hint, NULL);
+		RCU_INIT_POINTER(ioc->icq_hint, NULL);
 
 	ioc_exit_icq(icq);
 
-- 
1.9.1

