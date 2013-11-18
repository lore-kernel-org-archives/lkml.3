Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab3KRIrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 03:47:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:21343 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab3KRIrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 03:47:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="410419553"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH] kernel/bounds: avoid circular dependencies in generated headers
Date: Mon, 18 Nov 2013 10:47:27 +0200
Message-Id: <1384764447-17832-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<linux/spinlock.h> has havy dependencies on other header files.
It triggers circular dependencies in generated headers on IA64, at
least:

  CC      kernel/bounds.s
In file included from /home/space/kas/git/public/linux/arch/ia64/include/asm/thread_info.h:9:0,
                 from include/linux/thread_info.h:54,
                 from include/asm-generic/preempt.h:4,
                 from arch/ia64/include/generated/asm/preempt.h:1,
                 from include/linux/preempt.h:18,
                 from include/linux/spinlock.h:50,
                 from kernel/bounds.c:14:
/home/space/kas/git/public/linux/arch/ia64/include/asm/asm-offsets.h:1:35: fatal error: generated/asm-offsets.h: No such file or directory
compilation terminated.

Let's replace <linux/spinlock.h> with <linux/spinlock_types.h>, it's
enough to find out size of spinlock_t.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-and-Tested-by: Tony Luck <tony.luck@intel.com>
---
 kernel/bounds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bounds.c b/kernel/bounds.c
index 578782ef6ae1..5253204afdca 100644
--- a/kernel/bounds.c
+++ b/kernel/bounds.c
@@ -11,7 +11,7 @@
 #include <linux/kbuild.h>
 #include <linux/page_cgroup.h>
 #include <linux/log2.h>
-#include <linux/spinlock.h>
+#include <linux/spinlock_types.h>
 
 void foo(void)
 {
-- 
1.8.4.3

