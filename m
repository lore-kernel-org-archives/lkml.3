Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbaHHJUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 05:20:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45099 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136AbaHHJUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 05:20:01 -0400
Date: Fri, 8 Aug 2014 02:19:21 -0700
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-7c7f1547b627092737493f0781780af85cc9b1a4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, dave@sr71.net,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        dave.hansen@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, dave@sr71.net,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        dave.hansen@linux.intel.com
In-Reply-To: <20140807175841.5C92D878@viggo.jf.intel.com>
References: <20140807175841.5C92D878@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mm: Fix RCU splat from new TLB tracepoints
Git-Commit-ID: 7c7f1547b627092737493f0781780af85cc9b1a4
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

Commit-ID:  7c7f1547b627092737493f0781780af85cc9b1a4
Gitweb:     http://git.kernel.org/tip/7c7f1547b627092737493f0781780af85cc9b1a4
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Thu, 7 Aug 2014 10:58:41 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 8 Aug 2014 10:35:00 +0200

x86/mm: Fix RCU splat from new TLB tracepoints

Dave Jones reported seeing a bug from one of my TLB tracepoints:

        http://lkml.kernel.org/r/20140806181801.GA4605@redhat.com

According to Paul McKenney, the right way to fix this is adding
an _rcuidle suffix to the tracepoint.

        http://lkml.kernel.org/r/20140807065055.GA5821@linux.vnet.ibm.com

This patch does just that.

Reported-by: Dave Jones <davej@redhat.com>,
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Dave Hansen <dave@sr71.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140807175841.5C92D878@viggo.jf.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/tlb.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 1fe3398..98b7976 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -49,7 +49,13 @@ void leave_mm(int cpu)
 	if (cpumask_test_cpu(cpu, mm_cpumask(active_mm))) {
 		cpumask_clear_cpu(cpu, mm_cpumask(active_mm));
 		load_cr3(swapper_pg_dir);
-		trace_tlb_flush(TLB_FLUSH_ON_TASK_SWITCH, TLB_FLUSH_ALL);
+		/*
+		 * This gets called in the idle path where RCU
+		 * functions differently.  Tracing normally
+		 * uses RCU, so we have to call the tracepoint
+		 * specially here.
+		 */
+		trace_tlb_flush_rcuidle(TLB_FLUSH_ON_TASK_SWITCH, TLB_FLUSH_ALL);
 	}
 }
 EXPORT_SYMBOL_GPL(leave_mm);
