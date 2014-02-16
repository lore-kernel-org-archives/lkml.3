Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbaBPVZJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 16:25:09 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:51602 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbaBPVZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 16:25:07 -0500
From: vegard.nossum@oracle.com
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Dario Faggioli <raistlin@linux.it>, Juri Lelli <juri.lelli@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched: fix information leak in sys_sched_getattr()
Date: Sun, 16 Feb 2014 22:24:17 +0100
Message-Id: <1392585857-10725-1-git-send-email-vegard.nossum@oracle.com>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@oracle.com>

We're copying the on-stack structure to userspace, but forgot to give
the right number of bytes to copy. This allows the calling process to
obtain up to PAGE_SIZE bytes from the stack (and possibly adjacent
kernel memory).

This fix copies only as much as we actually have on the stack
(attr->size defaults to the size of the struct) and leaves the rest of
the userspace-provided buffer untouched.

Found using kmemcheck + trinity.

Fixes: d50dde5a10f30 ("sched: Add new scheduler syscalls to support an extended scheduling parameters ABI")
Cc: Dario Faggioli <raistlin@linux.it>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 kernel/sched/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b46131e..ac939c3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3786,7 +3786,7 @@ static int sched_read_attr(struct sched_attr __user *uattr,
 		attr->size = usize;
 	}
 
-	ret = copy_to_user(uattr, attr, usize);
+	ret = copy_to_user(uattr, attr, attr->size);
 	if (ret)
 		return -EFAULT;
 
-- 
1.7.10.4

