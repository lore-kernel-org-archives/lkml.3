Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbaBMQyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 11:54:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40930 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaBMQyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 11:54:46 -0500
Date: Thu, 13 Feb 2014 08:54:27 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-4640c7ee9b8953237d05a61ea3ea93981d1bc961@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, fengguang.wu@intel.com, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, fengguang.wu@intel.com
In-Reply-To: <20140213124550.GA30497@localhost>
References: <20140213124550.GA30497@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, smap: smap_violation()
  is bogus if CONFIG_X86_SMAP is off
Git-Commit-ID: 4640c7ee9b8953237d05a61ea3ea93981d1bc961
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 13 Feb 2014 08:54:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4640c7ee9b8953237d05a61ea3ea93981d1bc961
Gitweb:     http://git.kernel.org/tip/4640c7ee9b8953237d05a61ea3ea93981d1bc961
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 13 Feb 2014 07:46:04 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Feb 2014 08:40:52 -0800

x86, smap: smap_violation() is bogus if CONFIG_X86_SMAP is off

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
Cc: <stable@vger.kernel.org> # v3.7+
---
 arch/x86/mm/fault.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 9d591c8..6dea040 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1001,6 +1001,12 @@ static int fault_in_kernel_space(unsigned long address)
 
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
 
@@ -1087,11 +1093,9 @@ __do_page_fault(struct pt_regs *regs, unsigned long error_code)
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
 
 	/*
