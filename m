Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbbAPIn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 03:43:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59833 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbbAPInX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 03:43:23 -0500
Date: Fri, 16 Jan 2015 00:42:52 -0800
From: tip-bot for Kan Liang <tipbot@zytor.com>
Message-ID: <tip-33636732dcd7cc738a5913bb730d663c6b03c8fb@git.kernel.org>
Cc: kan.liang@intel.com, torvalds@linux-foundation.org, acme@kernel.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
        peterz@infradead.org, mingo@kernel.org
Reply-To: kan.liang@intel.com, hpa@zytor.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, acme@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, mingo@kernel.org
In-Reply-To: <1421084541-31639-1-git-send-email-kan.liang@intel.com>
References: <1421084541-31639-1-git-send-email-kan.liang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/intel: Fix bug for "cycles:p" and "
 cycles:pp" on SLM
Git-Commit-ID: 33636732dcd7cc738a5913bb730d663c6b03c8fb
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

Commit-ID:  33636732dcd7cc738a5913bb730d663c6b03c8fb
Gitweb:     http://git.kernel.org/tip/33636732dcd7cc738a5913bb730d663c6b03c8fb
Author:     Kan Liang <kan.liang@intel.com>
AuthorDate: Mon, 12 Jan 2015 17:42:21 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 16 Jan 2015 09:06:59 +0100

perf/x86/intel: Fix bug for "cycles:p" and "cycles:pp" on SLM

cycles:p and cycles:pp do not work on SLM since commit:

   86a04461a99f ("perf/x86: Revamp PEBS event selection")

UOPS_RETIRED.ALL is not a PEBS capable event, so it should not be used
to count cycle number.

Actually SLM calls intel_pebs_aliases_core2() which uses INST_RETIRED.ANY_P
to count the number of cycles. It's a PEBS capable event. But inv and
cmask must be set to count cycles.

Considering SLM allows all events as PEBS with no flags, only
INST_RETIRED.ANY_P, inv=1, cmask=16 needs to handled specially.

Signed-off-by: Kan Liang <kan.liang@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1421084541-31639-1-git-send-email-kan.liang@intel.com
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 3c895d4..0739833 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -568,8 +568,8 @@ struct event_constraint intel_atom_pebs_event_constraints[] = {
 };
 
 struct event_constraint intel_slm_pebs_event_constraints[] = {
-	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
-	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
+	/* INST_RETIRED.ANY_P, inv=1, cmask=16 (cycles:p). */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0x108000c0, 0x1),
 	/* Allow all events as PEBS with no flags */
 	INTEL_ALL_EVENT_CONSTRAINT(0, 0x1),
 	EVENT_CONSTRAINT_END
