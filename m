Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934437AbaH0NPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:15:23 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34978 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270AbaH0NPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:15:21 -0400
Date: Wed, 27 Aug 2014 16:15:13 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] block: genhd: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Message-ID: <20140827131513.GA31290@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to RCU_INIT_POINTER()'s block comment 3.a, it can be used if
"3.   The referenced data structure has already been exposed to readers either
at compile time or via rcu_assign_pointer() -and-
 a.   You have not made -any- reader-visible changes to this structure since
then".

This case fulfills the conditions above because between the rcu_dereference()
call and the rcu_assign_pointer() call there is no update of the "part"
variable.
Therefore, this patch makes the replacement.

The following Coccinelle semantic patch was used:
@@
identifier v;
@@

v = rcu_dereference(...);
... when != rcu_dereference(...);
    when != v = ...;
    when != (<+...v...+>)++;
    when != \(memcpy\|memset\)(...);
(
- rcu_assign_pointer
+ RCU_INIT_POINTER
  (..., v);
|
 if(...) {
... when != v = ...;
- rcu_assign_pointer
+ RCU_INIT_POINTER
  (..., v);
... when any
 }
)

Because there are cases where between a “rcu_dereference()” call and a
“rcu_assign_pointer()” call might be updates of the value that interests
us, the Coccinelle semantic patch ignores them and replaces with
"RCU_INIT_POINTER()" only when the update is not happening.

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 block/genhd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index 3aec057..f7e29d8 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -228,7 +228,7 @@ struct hd_struct *disk_map_sector_rcu(struct gendisk *disk, sector_t sector)
 		part = rcu_dereference(ptbl->part[i]);
 
 		if (part && sector_in_part(part, sector)) {
-			rcu_assign_pointer(ptbl->last_lookup, part);
+			RCU_INIT_POINTER(ptbl->last_lookup, part);
 			return part;
 		}
 	}
-- 
1.9.1

