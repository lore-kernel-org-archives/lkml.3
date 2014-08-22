Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbaHVN5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:57:30 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:39803 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122AbaHVN52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:57:28 -0400
Date: Fri, 22 Aug 2014 16:57:19 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: viro@zeniv.linux.org.uk, bcrl@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] fs: aio: Replace rcu_assign_pointer() with RCU_INIT_POINTER()
Message-ID: <20140822135719.GA31395@ada>
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
 fs/aio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index 4f078c0..81f7f3f 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -802,7 +802,7 @@ void exit_aio(struct mm_struct *mm)
 		do {
 			if (!table || i >= table->nr) {
 				rcu_read_unlock();
-				rcu_assign_pointer(mm->ioctx_table, NULL);
+				RCU_INIT_POINTER(mm->ioctx_table, NULL);
 				if (table)
 					kfree(table);
 				return;
-- 
1.9.1

