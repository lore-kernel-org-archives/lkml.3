Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaDRIK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 04:10:28 -0400
Received: from smtprelay.synopsys.com ([198.182.60.111]:46933 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaDRIJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 04:09:11 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Peter Zijlstra <peterz@infradead.org>, <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 1/2] ARC: Delete stale barrier.h
Date: Fri, 18 Apr 2014 13:38:34 +0530
Message-ID: <1397808515-8013-2-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397808515-8013-1-git-send-email-vgupta@synopsys.com>
References: <1397808515-8013-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 93ea02bb8435 "arch: Clean up asm/barrier.h implementations" wired
generic barrier.h for ARC, but failed to delete the existing file.

In 3.15, due to rcupdate.h updates, this causes a build breakage on ARC

--------------->8---------------------
  CC      arch/arc/kernel/asm-offsets.s
In file included from include/linux/sched.h:45:0,
                 from arch/arc/kernel/asm-offsets.c:9:
include/linux/rculist.h: In function __list_add_rcu:
include/linux/rculist.h:54:2: error: implicit declaration of function smp_store_release [-Werror=implicit-function-declaration]
  rcu_assign_pointer(list_next_rcu(prev), new);
  ^
--------------->8---------------------

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/barrier.h | 37 -------------------------------------
 1 file changed, 37 deletions(-)
 delete mode 100644 arch/arc/include/asm/barrier.h

diff --git a/arch/arc/include/asm/barrier.h b/arch/arc/include/asm/barrier.h
deleted file mode 100644
index c32245c3d1e9..000000000000
--- a/arch/arc/include/asm/barrier.h
+++ /dev/null
@@ -1,37 +0,0 @@
-/*
- * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef __ASM_BARRIER_H
-#define __ASM_BARRIER_H
-
-#ifndef __ASSEMBLY__
-
-/* TODO-vineetg: Need to see what this does, don't we need sync anywhere */
-#define mb() __asm__ __volatile__ ("" : : : "memory")
-#define rmb() mb()
-#define wmb() mb()
-#define set_mb(var, value)  do { var = value; mb(); } while (0)
-#define set_wmb(var, value) do { var = value; wmb(); } while (0)
-#define read_barrier_depends()  mb()
-
-/* TODO-vineetg verify the correctness of macros here */
-#ifdef CONFIG_SMP
-#define smp_mb()        mb()
-#define smp_rmb()       rmb()
-#define smp_wmb()       wmb()
-#else
-#define smp_mb()        barrier()
-#define smp_rmb()       barrier()
-#define smp_wmb()       barrier()
-#endif
-
-#define smp_read_barrier_depends()      do { } while (0)
-
-#endif
-
-#endif
-- 
1.8.3.2

