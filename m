Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaKKSoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 13:44:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:15367 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbaKKSn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:43:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="414941166"
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        x86@kernel.org
Subject: [PATCH 4/6] x86: Use clwb in clflush_cache_range
Date: Tue, 11 Nov 2014 11:43:14 -0700
Message-Id: <1415731396-19364-5-git-send-email-ross.zwisler@linux.intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415731396-19364-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1415731396-19364-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If clwb is available on the system, use it in clflush_cache_range.
If clwb is not available, fall back to clflushopt if you can.
If clflushopt is not supported, fall all the way back to clflush.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: H Peter Anvin <h.peter.anvin@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: x86@kernel.org
---
 arch/x86/mm/pageattr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 36de293..5229d45 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -126,8 +126,8 @@ within(unsigned long addr, unsigned long start, unsigned long end)
  * @vaddr:	virtual start address
  * @size:	number of bytes to flush
  *
- * clflushopt is an unordered instruction which needs fencing with mfence or
- * sfence to avoid ordering issues.
+ * clflushopt and clwb are unordered instructions which need fencing with
+ * mfence or sfence to avoid ordering issues.
  */
 void clflush_cache_range(void *vaddr, unsigned int size)
 {
@@ -136,11 +136,11 @@ void clflush_cache_range(void *vaddr, unsigned int size)
 	mb();
 
 	for (; vaddr < vend; vaddr += boot_cpu_data.x86_clflush_size)
-		clflushopt(vaddr);
+		clwb(vaddr);
 	/*
 	 * Flush any possible final partial cacheline:
 	 */
-	clflushopt(vend);
+	clwb(vend);
 
 	mb();
 }
-- 
1.9.3

