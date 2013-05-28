Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934002Ab3E1NBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:01:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50064 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933977Ab3E1NA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:00:57 -0400
Date: Tue, 28 May 2013 06:00:30 -0700
From: tip-bot for Dan Carpenter <tipbot@zytor.com>
Message-ID: <tip-13acac307528c9cd7dd9fa9c577419401527b464@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, tglx@linutronix.de, dan.carpenter@oracle.com
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, jolsa@redhat.com,
        tglx@linutronix.de, dan.carpenter@oracle.com
In-Reply-To: <20130518183452.GA14587@elgon.mountain>
References: <20130518183452.GA14587@elgon.mountain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel:
  Prevent some shift wrapping bugs in the Intel uncore driver
Git-Commit-ID: 13acac307528c9cd7dd9fa9c577419401527b464
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

Commit-ID:  13acac307528c9cd7dd9fa9c577419401527b464
Gitweb:     http://git.kernel.org/tip/13acac307528c9cd7dd9fa9c577419401527b464
Author:     Dan Carpenter <dan.carpenter@oracle.com>
AuthorDate: Sat, 18 May 2013 21:34:52 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 09:13:52 +0200

perf/x86/intel: Prevent some shift wrapping bugs in the Intel uncore driver

We're trying to use 64 bit masks but the shifts wrap so we can't use the
high 32 bits. I've fixed this by changing several types to unsigned
long long.

This is a static checker fix.  The one change which is clearly needed is
"mask = 0xff << (idx * 8);" where the author obviously intended to use
all 64 bits.  The other changes are mostly to silence my static checker.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/20130518183452.GA14587@elgon.mountain
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 4 ++--
 arch/x86/kernel/cpu/perf_event_intel_uncore.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 52441a2..c0e356d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -644,7 +644,7 @@ snbep_pcu_get_constraint(struct intel_uncore_box *box, struct perf_event *event)
 	    (!uncore_box_is_fake(box) && reg1->alloc))
 		return NULL;
 again:
-	mask = 0xff << (idx * 8);
+	mask = 0xffULL << (idx * 8);
 	raw_spin_lock_irqsave(&er->lock, flags);
 	if (!__BITS_VALUE(atomic_read(&er->ref), idx, 8) ||
 	    !((config1 ^ er->config) & mask)) {
@@ -1923,7 +1923,7 @@ static u64 nhmex_mbox_alter_er(struct perf_event *event, int new_idx, bool modif
 {
 	struct hw_perf_event *hwc = &event->hw;
 	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
-	int idx, orig_idx = __BITS_VALUE(reg1->idx, 0, 8);
+	u64 idx, orig_idx = __BITS_VALUE(reg1->idx, 0, 8);
 	u64 config = reg1->config;
 
 	/* get the non-shared control bits and shift them */
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index f952891..47b3d00 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -337,10 +337,10 @@
 		 NHMEX_M_PMON_CTL_SET_FLAG_SEL_MASK)
 
 #define NHMEX_M_PMON_ZDP_CTL_FVC_MASK		(((1 << 11) - 1) | (1 << 23))
-#define NHMEX_M_PMON_ZDP_CTL_FVC_EVENT_MASK(n)	(0x7 << (11 + 3 * (n)))
+#define NHMEX_M_PMON_ZDP_CTL_FVC_EVENT_MASK(n)	(0x7ULL << (11 + 3 * (n)))
 
 #define WSMEX_M_PMON_ZDP_CTL_FVC_MASK		(((1 << 12) - 1) | (1 << 24))
-#define WSMEX_M_PMON_ZDP_CTL_FVC_EVENT_MASK(n)	(0x7 << (12 + 3 * (n)))
+#define WSMEX_M_PMON_ZDP_CTL_FVC_EVENT_MASK(n)	(0x7ULL << (12 + 3 * (n)))
 
 /*
  * use the 9~13 bits to select event If the 7th bit is not set,
