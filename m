Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbaBUVOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:14:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59027 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851AbaBUVOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:14:34 -0500
Date: Fri, 21 Feb 2014 13:14:08 -0800
From: tip-bot for Markus Metzger <tipbot@zytor.com>
Message-ID: <tip-a3ef2229c94ff70998724cb64b9cb4c77db9e950@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ak@linux.intel.com, markus.t.metzger@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, markus.t.metzger@intel.com, ak@linux.intel.com,
        tglx@linutronix.de
In-Reply-To: <1392425048-5309-1-git-send-email-andi@firstfloor.org>
References: <1392425048-5309-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, nmi: Fix unknown NMI warning
Git-Commit-ID: a3ef2229c94ff70998724cb64b9cb4c77db9e950
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

Commit-ID:  a3ef2229c94ff70998724cb64b9cb4c77db9e950
Gitweb:     http://git.kernel.org/tip/a3ef2229c94ff70998724cb64b9cb4c77db9e950
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 14 Feb 2014 16:44:08 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 22:09:01 +0100

perf, nmi: Fix unknown NMI warning

When using BTS on Core i7-4*, I get the below kernel warning.

$ perf record -c 1 -e branches:u ls
Message from syslogd@labpc1501 at Nov 11 15:49:25 ...
 kernel:[  438.317893] Uhhuh. NMI received for unknown reason 31 on CPU 2.

Message from syslogd@labpc1501 at Nov 11 15:49:25 ...
 kernel:[  438.317920] Do you have a strange power saving mode enabled?

Message from syslogd@labpc1501 at Nov 11 15:49:25 ...
 kernel:[  438.317945] Dazed and confused, but trying to continue

Make intel_pmu_handle_irq() take the full exit path when returning early.

Cc: eranian@google.com
Cc: peterz@infradead.org
Cc: mingo@kernel.org
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1392425048-5309-1-git-send-email-andi@firstfloor.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 0fa4f24..698ae77 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1361,10 +1361,8 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	intel_pmu_disable_all();
 	handled = intel_pmu_drain_bts_buffer();
 	status = intel_pmu_get_status();
-	if (!status) {
-		intel_pmu_enable_all(0);
-		return handled;
-	}
+	if (!status)
+		goto done;
 
 	loops = 0;
 again:
