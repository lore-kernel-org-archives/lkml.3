Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934530Ab3BTGRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 01:17:53 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:48241 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933841Ab3BTGRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 01:17:51 -0500
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>, David Daney <david.daney@cavium.com>
Subject: [PATCH] MIPS: fix access_ok()
Date: Wed, 20 Feb 2013 14:17:36 +0800
Message-Id: <1361341056-15287-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

Current access_ok() will fail even if the address range is
valid when it reaches to the end of TASK_SIZE.
For exampe: addr = 0xfffffffff0; size = 16;
the real address range it want to access is 0xfffffffff0~0xfffffffff;
but addr + size = 0x10000000000 which we will not and can't access.
In current realization of access_ok(), the high bit will be 1
thus access_ok() indicates the operation is not allowed.

The bug is found in old kerenl(before vdso is realized) in
following typical call trace:
sys_mount()
  copy_mount_options()
    exact_copy_from_user()
When the parameter 'from' for exact_copy_from_user() residents in
the last page of the task's virtual address, such as stack.
But it's still in current kernel.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Daney <david.daney@cavium.com>
---
 arch/mips/include/asm/uaccess.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/uaccess.h b/arch/mips/include/asm/uaccess.h
index 3b92efe..55d4214 100644
--- a/arch/mips/include/asm/uaccess.h
+++ b/arch/mips/include/asm/uaccess.h
@@ -114,8 +114,12 @@ extern u64 __ua_limit;
 	unsigned long __ok;						\
 									\
 	__chk_user_ptr(addr);						\
-	__ok = (signed long)(__mask & (__addr | (__addr + __size) |	\
-		__ua_size(__size)));					\
+	if (likely(size))						\
+		__ok = (signed long)(__mask & (__addr |			\
+				(__addr + __size - 1) |			\
+				__ua_size(__size)));			\
+	else								\
+		__ok = 0;						\
 	__ok == 0;							\
 })
 
-- 
1.7.9.5

