Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423250Ab3CWBbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:31:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:55320 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422839Ab3CWBZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="306338475"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 12/29] x86, tsx: Add a per thread transaction disable count
Date: Fri, 22 Mar 2013 18:25:06 -0700
Message-Id: <1364001923-10796-13-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

For some locks that have a low chance of not aborting it's
best to just disable transactions.

Add a counter to thread_info to allow to disable tranasctions
for the current task.

I originally experimented with more complicated solutions,
like a magic spinlock type to disable with magic type matching,
but that was very intrusive in the locking code.

This setup -- while adding a few more instructions -- is more
flexible and seems to work quite nicely.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/thread_info.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 2cd056e..91bb84e 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -39,6 +39,7 @@ struct thread_info {
 						*/
 	__u8			supervisor_stack[0];
 #endif
+	unsigned		notxn;		/* transactions are disabled */
 	unsigned int		sig_on_uaccess_error:1;
 	unsigned int		uaccess_err:1;	/* uaccess failed */
 };
@@ -279,6 +280,13 @@ static inline bool is_ia32_task(void)
 #endif
 	return false;
 }
+
+#ifdef CONFIG_RTM_LOCKS
+#define txn_disabled() (current_thread_info()->notxn)
+#define disable_txn()  (current_thread_info()->notxn++)
+#define reenable_txn() (current_thread_info()->notxn--)
+#endif
+
 #endif	/* !__ASSEMBLY__ */
 
 #ifndef __ASSEMBLY__
-- 
1.7.7.6

