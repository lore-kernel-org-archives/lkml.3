Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab3EDIXO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 04:23:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52733 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab3EDIXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 04:23:12 -0400
Date: Sat, 4 May 2013 01:22:57 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-v0x9ky3ahzr6nm3c6ilwrili@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, stable@kernel.org, ak@linux.intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, stable@kernel.org, ak@linux.intel.com,
        tglx@linutronix.de
In-Reply-To: <20130503121256.230745028@chello.nl>
References: <20130503121256.230745028@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/intel/lbr:
  Demand proper privileges for PERF_SAMPLE_BRANCH_KERNEL
Git-Commit-ID: 0f5c78b5f33ce940034743e5f9485fc81ad75b0f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f5c78b5f33ce940034743e5f9485fc81ad75b0f
Gitweb:     http://git.kernel.org/tip/0f5c78b5f33ce940034743e5f9485fc81ad75b0f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 3 May 2013 14:11:25 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 4 May 2013 08:37:48 +0200

perf/x86/intel/lbr: Demand proper privileges for PERF_SAMPLE_BRANCH_KERNEL

We should always have proper privileges when requesting kernel
data.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: eranian@google.com
Link: http://lkml.kernel.org/r/20130503121256.230745028@chello.nl
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/n/tip-v0x9ky3ahzr6nm3c6ilwrili@git.kernel.org
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index de341d4..0e92871 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -318,8 +318,11 @@ static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
 	if (br_type & PERF_SAMPLE_BRANCH_USER)
 		mask |= X86_BR_USER;
 
-	if (br_type & PERF_SAMPLE_BRANCH_KERNEL)
+	if (br_type & PERF_SAMPLE_BRANCH_KERNEL) {
+		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		mask |= X86_BR_KERNEL;
+	}
 
 	/* we ignore BRANCH_HV here */
 
