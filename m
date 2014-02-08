Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbaBHHxG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 02:53:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:16133 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbaBHHw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 02:52:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,805,1384329600"; 
   d="scan'208";a="451781483"
From: Andi Kleen <ak@linux.intel.com>
To: akpm@linux-foundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 10/14] asmlinkage Make __stack_chk_failed and memcmp visible
Date: Sat,  8 Feb 2014 08:52:06 +0100
Message-Id: <1391845930-28580-10-git-send-email-ak@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
References: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In LTO symbols implicitely referenced by the compiler need
to be visible. Earlier these symbols were visible implicitely
from being exported, but we disabled implicit visibility fo
 EXPORTs when modules are disabled to improve code size. So
now these symbols have to be marked visible explicitely.

Do this for __stack_chk_fail (with stack protector)
and memcmp.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/panic.c | 2 +-
 lib/string.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 6d63003..3eb0ffb 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -459,7 +459,7 @@ EXPORT_SYMBOL(warn_slowpath_null);
  * Called when gcc's -fstack-protector feature is used, and
  * gcc detects corruption of the on-stack canary value
  */
-void __stack_chk_fail(void)
+__visible void __stack_chk_fail(void)
 {
 	panic("stack-protector: Kernel stack is corrupted in: %p\n",
 		__builtin_return_address(0));
diff --git a/lib/string.c b/lib/string.c
index e5878de..9b1f906 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -648,7 +648,7 @@ EXPORT_SYMBOL(memmove);
  * @count: The size of the area.
  */
 #undef memcmp
-int memcmp(const void *cs, const void *ct, size_t count)
+__visible int memcmp(const void *cs, const void *ct, size_t count)
 {
 	const unsigned char *su1, *su2;
 	int res = 0;
-- 
1.8.5.2

