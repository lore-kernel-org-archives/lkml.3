Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbaF0Nsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 09:48:53 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:49255 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbaF0Nsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 09:48:36 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jmario@redhat.com,
        dzickus@redhat.com, jolsa@redhat.com, acme@redhat.com
Subject: [PATCH v2 2/2] perf/x86: load latency event supports all PEBS counters
Date: Fri, 27 Jun 2014 15:48:03 +0200
Message-Id: <1403876883-3059-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403876883-3059-1-git-send-email-eranian@google.com>
References: <1403876883-3059-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch relaxes the event constraint for the Load
Latency PEBS event on SNB/IVB/HSW. It was limited to
counter 3 only for artificial reasons, i.e., to make
scheduling it easier. This event uses an extra MSR
which has to be shared among all events of a PMU.
In Linux, there is a sophisticated infratstructure
to handle shared regs, and we don't need to constrain
the event to one counter.

The advantage of this patch is that it makes it
possible to combine load latency and precise store
events without multiplexing.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index fdadec0..9dbfc9b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -579,7 +579,7 @@ struct event_constraint intel_westmere_pebs_event_constraints[] = {
 
 struct event_constraint intel_snb_pebs_event_constraints[] = {
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
-	INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
+	INTEL_PLD_CONSTRAINT(0x01cd, 0xf),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
 	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
 	INTEL_PEBS_CONSTRAINT(0xf),	      /* catch all PEBS */
 	EVENT_CONSTRAINT_END
@@ -587,7 +587,7 @@ struct event_constraint intel_snb_pebs_event_constraints[] = {
 
 struct event_constraint intel_ivb_pebs_event_constraints[] = {
         INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
-        INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
+        INTEL_PLD_CONSTRAINT(0x01cd, 0xf),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
 	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
 	INTEL_PEBS_CONSTRAINT(0xf),	      /* catch all PEBS */
         EVENT_CONSTRAINT_END
@@ -596,7 +596,7 @@ struct event_constraint intel_ivb_pebs_event_constraints[] = {
 struct event_constraint intel_hsw_pebs_event_constraints[] = {
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
 	INTEL_PST_HSW_CONSTRAINT(0x01c2, 0xf), /* UOPS_RETIRED.ALL */
-	INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.* */
+	INTEL_PLD_CONSTRAINT(0x01cd, 0xf),    /* MEM_TRANS_RETIRED.* */
 	INTEL_PST_HSW_CONSTRAINT(0x82d0, 0xf), /* MEM_UOPS_RETIRED.ALL_STORES */
 	INTEL_PEBS_CONSTRAINT(0xf),	      /* catch all PEBS */
 	EVENT_CONSTRAINT_END
-- 
1.7.9.5

