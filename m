Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbaBUA5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:57:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbaBTXvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:51:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 3.10 35/66] x86, smap: smap_violation() is bogus if CONFIG_X86_SMAP is off
Date: Thu, 20 Feb 2014 15:51:34 -0800
Message-Id: <20140220234910.503604505@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220234909.482516304@linuxfoundation.org>
References: <20140220234909.482516304@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/mm/fault.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -989,6 +989,12 @@ static int fault_in_kernel_space(unsigne
 
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
 
@@ -1091,11 +1097,9 @@ __do_page_fault(struct pt_regs *regs, un
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


