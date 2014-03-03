Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbaCCTO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:14:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55980 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbaCCS5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:57:31 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 62/67] x86, smap: smap_violation() is bogus if CONFIG_X86_SMAP is off
Date: Mon,  3 Mar 2014 10:55:50 -0800
Message-Id: <1393872955-28810-63-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit 4640c7ee9b8953237d05a61ea3ea93981d1bc961 upstream.

If CONFIG_X86_SMAP is disabled, smap_violation() tests for conditions
which are incorrect (as the AC flag doesn't matter), causing spurious
faults.

The dynamic disabling of SMAP (nosmap on the command line) is fine
because it disables X86_FEATURE_SMAP, therefore causing the
static_cpu_has() to return false.

Found by Fengguang Wu's test system.

[ v3: move all predicates into smap_violation() ]
[ v2: use IS_ENABLED() instead of #ifdef ]

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Link: http://lkml.kernel.org/r/20140213124550.GA30497@localhost
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/mm/fault.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 4f7d793..c3462d3 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -995,6 +995,12 @@ static int fault_in_kernel_space(unsigned long address)
 
 static inline bool smap_violation(int error_code, struct pt_regs *regs)
 {
+	if (!IS_ENABLED(CONFIG_X86_SMAP))
+		return false;
+
+	if (!static_cpu_has(X86_FEATURE_SMAP))
+		return false;
+
 	if (error_code & PF_USER)
 		return false;
 
@@ -1097,11 +1103,9 @@ __do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	if (unlikely(error_code & PF_RSVD))
 		pgtable_bad(regs, error_code, address);
 
-	if (static_cpu_has(X86_FEATURE_SMAP)) {
-		if (unlikely(smap_violation(error_code, regs))) {
-			bad_area_nosemaphore(regs, error_code, address);
-			return;
-		}
+	if (unlikely(smap_violation(error_code, regs))) {
+		bad_area_nosemaphore(regs, error_code, address);
+		return;
 	}
 
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
-- 
1.8.3.2

