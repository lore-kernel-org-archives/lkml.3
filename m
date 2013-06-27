Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab3F0JCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:02:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45993 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab3F0JCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:02:04 -0400
Date: Thu, 27 Jun 2013 02:01:21 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-983433b5812c5cf33a9008fa38c6f9b407fedb76@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1371824448-7306-2-git-send-email-eranian@google.com>
References: <1371824448-7306-2-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Disable PEBS-LL in intel_pmu_pebs_disable()
Git-Commit-ID: 983433b5812c5cf33a9008fa38c6f9b407fedb76
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 27 Jun 2013 02:01:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  983433b5812c5cf33a9008fa38c6f9b407fedb76
Gitweb:     http://git.kernel.org/tip/983433b5812c5cf33a9008fa38c6f9b407fedb76
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Fri, 21 Jun 2013 16:20:41 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 26 Jun 2013 21:58:51 +0200

perf/x86: Disable PEBS-LL in intel_pmu_pebs_disable()

Make sure intel_pmu_pebs_disable() and intel_pmu_pebs_enable()
are symmetrical w.r.t. PEBS-LL and precise store.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1371824448-7306-2-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index ed3e553..3065c57 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -653,6 +653,12 @@ void intel_pmu_pebs_disable(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 
 	cpuc->pebs_enabled &= ~(1ULL << hwc->idx);
+
+	if (event->hw.constraint->flags & PERF_X86_EVENT_PEBS_LDLAT)
+		cpuc->pebs_enabled &= ~(1ULL << (hwc->idx + 32));
+	else if (event->hw.constraint->flags & PERF_X86_EVENT_PEBS_ST)
+		cpuc->pebs_enabled &= ~(1ULL << 63);
+
 	if (cpuc->enabled)
 		wrmsrl(MSR_IA32_PEBS_ENABLE, cpuc->pebs_enabled);
 
