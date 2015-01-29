Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906AbbA2BuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:50:17 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59281 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754082AbbA2BuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:50:15 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] ACPI / cpuidle: Drop unnecessary calls from acpi_idle_do_entry()
Date: Thu, 29 Jan 2015 03:13:01 +0100
Message-ID: <1891290.rcp9NuuoxH@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since the cpuidle core calls stop_critical_timings() and
start_critical_timings() around the execution of ->enter callbacks,
acpi_idle_do_entry() doesn't need to do that (and really shouldn't).

Also using "inline" on it is pointless and the kerneldoc entry does
not reflect the actual situation any more.

Fix all of the above.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/processor_idle.c |    7 ++-----
 drivers/cpuidle/cpuidle.c     |    7 ++++---
 2 files changed, 6 insertions(+), 8 deletions(-)

Index: linux-pm/drivers/acpi/processor_idle.c
===================================================================
--- linux-pm.orig/drivers/acpi/processor_idle.c
+++ linux-pm/drivers/acpi/processor_idle.c
@@ -681,15 +681,13 @@ static int acpi_idle_bm_check(void)
 }
 
 /**
- * acpi_idle_do_entry - a helper function that does C2 and C3 type entry
+ * acpi_idle_do_entry - enter idle state using the appropriate method
  * @cx: cstate data
  *
  * Caller disables interrupt before call and enables interrupt after return.
  */
-static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
+static void acpi_idle_do_entry(struct acpi_processor_cx *cx)
 {
-	/* Don't trace irqs off for idle */
-	stop_critical_timings();
 	if (cx->entry_method == ACPI_CSTATE_FFH) {
 		/* Call into architectural FFH based C-state */
 		acpi_processor_ffh_cstate_enter(cx);
@@ -703,7 +701,6 @@ static inline void acpi_idle_do_entry(st
 		   gets asserted in time to freeze execution properly. */
 		inl(acpi_gbl_FADT.xpm_timer_block.address);
 	}
-	start_critical_timings();
 }
 
 /**

