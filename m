Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab3ILSFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:05:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37853 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622Ab3ILSEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:04:55 -0400
Date: Thu, 12 Sep 2013 11:04:25 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-4b2c4f1f1b71fe18381f089c501ac21cd2167dfa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1378438661-24765-4-git-send-email-andi@firstfloor.org>
References: <1378438661-24765-4-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel: Add Haswell TSX event aliases
Git-Commit-ID: 4b2c4f1f1b71fe18381f089c501ac21cd2167dfa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 12 Sep 2013 11:04:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4b2c4f1f1b71fe18381f089c501ac21cd2167dfa
Gitweb:     http://git.kernel.org/tip/4b2c4f1f1b71fe18381f089c501ac21cd2167dfa
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Thu, 5 Sep 2013 20:37:40 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 12 Sep 2013 19:13:36 +0200

perf/x86/intel: Add Haswell TSX event aliases

Add TSX event aliases, and export them from the kernel to perf.

These are used by perf stat -T and to allow
more user friendly access to events. The events are designed to
be fairly generic and may also apply to other architectures
implementing HTM.  They all cover common situations that
happens during tuning of transactional code.

For Haswell we have to separate the HLE and RTM events,
as they are separate in the PMU.

This adds the following events:

 tx-start	Count start transaction (used by perf stat -T)
 tx-commit	Count commit of transaction
 tx-abort	Count all aborts
 tx-conflict	Count aborts due to conflict with another CPU.
 tx-capacity	Count capacity aborts (transaction too large)

Then matching el-* events for HLE

 cycles-t	Transactional cycles (used by perf stat -T)
  * also exists on POWER8

 cycles-ct	Transactional cycles commited (used by perf stat -T)
  * according to Michael Ellerman POWER8 has a cycles-transactional-committed,
  * perf stat -T handles both cases

Note for useful abort profiling often precise has to be set,
as Haswell can only report the point inside the transaction
with precise=2.

For some classes of aborts, like conflicts, this is not needed,
as it makes more sense to look at the complete critical section.

This gives a clean set of generalized events to examine transaction
success and aborts. Haswell has additional events for TSX, but those
are more specialized for very specific situations.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1378438661-24765-4-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 57d64b7..dd1d4f3 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2222,7 +2222,34 @@ static __init void intel_nehalem_quirk(void)
 EVENT_ATTR_STR(mem-loads,      mem_ld_hsw,     "event=0xcd,umask=0x1,ldlat=3");
 EVENT_ATTR_STR(mem-stores,     mem_st_hsw,     "event=0xd0,umask=0x82")
 
+/* Haswell special events */
+EVENT_ATTR_STR(tx-start,        tx_start,       "event=0xc9,umask=0x1");
+EVENT_ATTR_STR(tx-commit,       tx_commit,      "event=0xc9,umask=0x2");
+EVENT_ATTR_STR(tx-abort,        tx_abort,	"event=0xc9,umask=0x4");
+EVENT_ATTR_STR(tx-capacity,     tx_capacity,	"event=0x54,umask=0x2");
+EVENT_ATTR_STR(tx-conflict,     tx_conflict,	"event=0x54,umask=0x1");
+EVENT_ATTR_STR(el-start,        el_start,       "event=0xc8,umask=0x1");
+EVENT_ATTR_STR(el-commit,       el_commit,      "event=0xc8,umask=0x2");
+EVENT_ATTR_STR(el-abort,        el_abort,	"event=0xc8,umask=0x4");
+EVENT_ATTR_STR(el-capacity,     el_capacity,    "event=0x54,umask=0x2");
+EVENT_ATTR_STR(el-conflict,     el_conflict,    "event=0x54,umask=0x1");
+EVENT_ATTR_STR(cycles-t,        cycles_t,       "event=0x3c,in_tx=1");
+EVENT_ATTR_STR(cycles-ct,       cycles_ct,
+					"event=0x3c,in_tx=1,in_tx_cp=1");
+
 static struct attribute *hsw_events_attrs[] = {
+	EVENT_PTR(tx_start),
+	EVENT_PTR(tx_commit),
+	EVENT_PTR(tx_abort),
+	EVENT_PTR(tx_capacity),
+	EVENT_PTR(tx_conflict),
+	EVENT_PTR(el_start),
+	EVENT_PTR(el_commit),
+	EVENT_PTR(el_abort),
+	EVENT_PTR(el_capacity),
+	EVENT_PTR(el_conflict),
+	EVENT_PTR(cycles_t),
+	EVENT_PTR(cycles_ct),
 	EVENT_PTR(mem_ld_hsw),
 	EVENT_PTR(mem_st_hsw),
 	NULL
