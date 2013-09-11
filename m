Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab3IKPW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:22:27 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:34402 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab3IKPWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:22:25 -0400
Date: Wed, 11 Sep 2013 08:22:22 -0700
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com,
        zheng.z.yan@intel.com, dhsharp@google.com
Subject: [PATCH] perf,x86: add constraint for IVB
 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
Message-ID: <20130911152222.GA28761@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The IvyBridge event CYCLE_ACTIVITY:CYCLES_LDM_PENDING can only
be measured on counters 0-3 when HT is off. When HT is on, you
only have counters 0-3.

If you program it on the eight counters for 1s on a 3GHz
IVB laptop running a noploop, you see:

           2 747 527 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
           2 747 527 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
           2 747 527 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
           2 747 527 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
       3 280 563 608 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
       3 280 563 608 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
       3 280 563 608 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
       3 280 563 608 CYCLE_ACTIVITY:CYCLES_LDM_PENDING

Clearly the last 4 values are bogus.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 0abf674..c62d883 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -124,6 +124,7 @@ static struct event_constraint intel_ivb_event_constraints[] __read_mostly =
 	INTEL_UEVENT_CONSTRAINT(0x0148, 0x4), /* L1D_PEND_MISS.PENDING */
 	INTEL_UEVENT_CONSTRAINT(0x0279, 0xf), /* IDQ.EMTPY */
 	INTEL_UEVENT_CONSTRAINT(0x019c, 0xf), /* IDQ_UOPS_NOT_DELIVERED.CORE */
+	INTEL_UEVENT_CONSTRAINT(0x02a3, 0xf), /* CYCLE_ACTIVITY.CYCLES_LDM_PENDING */
 	INTEL_UEVENT_CONSTRAINT(0x04a3, 0xf), /* CYCLE_ACTIVITY.CYCLES_NO_EXECUTE */
 	INTEL_UEVENT_CONSTRAINT(0x05a3, 0xf), /* CYCLE_ACTIVITY.STALLS_L2_PENDING */
 	INTEL_UEVENT_CONSTRAINT(0x06a3, 0xf), /* CYCLE_ACTIVITY.STALLS_LDM_PENDING */
-- 
1.8.4

