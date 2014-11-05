Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbaKEHGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 02:06:44 -0500
Received: from mga14.intel.com ([192.55.52.115]:13156 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbaKEHGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 02:06:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="411665400"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Robert Moore <robert.moore@intel.com>, Corey Minyard <minyard@acm.org>,
        devel@acpica.org, openipmi-developer@lists.sourceforge.net
Subject: [PATCH] ACPI/OSL: Add IRQ handler flushing support in the OSL.
Date: Wed,  5 Nov 2014 15:06:13 +0800
Message-Id: <454129232241014e949861cc07a7f3ff6c80bd52.1415156960.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible that a GPE handler or a fixed event handler still accessed
after removing the handlers by invoking acpi_remove_gpe_handler() or
acpi_remove_fixed_event_handler(), this possibility can crash OPSM after a
module removal. In the Linux kernel, though all other GPE drivers are not
modules, since the IPMI_SI (ipmi_si_intf.c) can be compiled as a module, we
still need to consider a solution for this issue when the driver switches
to ACPI_GPE_RAW_HANDLER mode in order to invoke GPE APIs.

ACPICA expects acpi_os_wait_events_complete() to be invoked after GPE
disabling so that OSPM can ensure all running GPE handlers have exitted.
But currently acpi_os_wait_events_complete() can only flush _Lxx/_Exx
evaluation work queue and this philosophy cannot work for drivers that have
installed a dedicated GPE handler.

The only way to protect a callback is to perform some state holders
(reference count, state machine) before invoking the callback. Then this
issue can only be fixed by the following means:
1. Flush GPE in ACPICA before invoking the GPE handler. But currently,
   there is no such implementation in acpi_ev_gpe_dispatch().
2. Flush GPE in ACPICA OSL before invoking the SCI handler. But currently,
   there is no such implementation in acpi_irq().
3. Flush IRQ in OSPM IRQ layer before invoking the IRQ handler. In Linus
   kernel, this can be done by synchronize_irq().
4. Flush scheduling in OSPM vector entry layer before invoking the vector.
   In Linux, this can be done by synchronize_sched().

Since ACPICA expects the GPE handlers to be flushed by the ACPICA OSL or
the GPE drivers. If it is implemented by the GPE driver, we should see
synchronize_irq()/synchronize_sched() invoked in such drivers. If it is
implemented by the ACPICA OSL, ACPICA currently provides
acpi_os_wait_events_complete() hook to achieve this. After the following
commit:
  Commit: 69c841b6dd8313c9a673246cc0e2535174272cab
  Author: Lv Zheng <lv.zheng@intel.com>
  Subject: ACPICA: Update use of acpi_os_wait_events_complete interface.
The OSL acpi_os_wait_events_complete() is invoked after a GPE handler is
removed from acpi_remove_gpe_handler() or a fixed event handler is removed
from acpi_remove_fixed_event_handler(). Thus it is possible to implement
GPE handler flushing using this ACPICA OSL now. So the solution 1 is
currently not taken into account.

By examining the IPMI_SI driver, we noticed that the IPMI_SI driver:
1. Uses free_irq() to flush non GPE based IRQ handlers, in free_irq(),
   synchronize_irq() is invoked, and
2. Uses acpi_remove_gpe_handler() to flush GPE based IRQ handlers, for such
   IRQ handlers, there is no synchronize_irq() invoked.
Since there isn't synchronize_sched() implemented for this driver, from the
driver's perspective, acpi_remove_gpe_handler() should have properly
flushed the GPE handlers for it. Since the driver doesn't invoke
synchronize_irq(), the solution 3 is not what the drivers expect.

This patch implements solution 2. But since given the fact that the GPE is
managed inside of ACPICA, and implementing the GPE flushing requires to
implement the whole GPE management code again in the OSL, instead of
flushing GPE, this patch flushes IRQ in acpi_os_wait_events_complete(). The
flushing could last longer than expected as though the target GPE/fixed
event that is removed can be fastly flushed, other GPEs/fix events can still
be issued during the flushing period.

This patch fixes this issue by invoking synchronize_hardirq() in
acpi_os_wait_events_complete(). The reason why we don't invoke
synchronize_irq() is: currently ACPICA is not threaded IRQ capable and the
only difference between synchronize_irq() and synchronize_hardirq() is
synchronize_irq() also flushes threaded IRQ handlers. Thus using
synchronize_hardirq() can help to reduce the overall synchronization time
for the current ACPICA implementation.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Corey Minyard <minyard@acm.org>
Cc: linux-acpi@vger.kernel.org
Cc: devel@acpica.org
Cc: openipmi-developer@lists.sourceforge.net
---
 drivers/acpi/osl.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 9964f70..2524196 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -1188,6 +1188,12 @@ EXPORT_SYMBOL(acpi_os_execute);
 
 void acpi_os_wait_events_complete(void)
 {
+	/*
+	 * Make sure the GPE handler or the fixed event handler is not used
+	 * on another CPU after removal.
+	 */
+	if (acpi_irq_handler)
+		synchronize_hardirq(acpi_gbl_FADT.sci_interrupt);
 	flush_workqueue(kacpid_wq);
 	flush_workqueue(kacpi_notify_wq);
 }
-- 
1.7.10

