Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbaCaA1F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:27:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36267 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752896AbaC3XZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:00 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Marcelo Tosatti" <mtosatti@redhat.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Jan Kiszka" <jan.kiszka@siemens.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.38176321@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 040/200] KVM: x86: limit PIT timer frequency
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

commit 9ed96e87c5748de4c2807ef17e81287c7304186c upstream.

Limit PIT timer frequency similarly to the limit applied by
LAPIC timer.

Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[bwh: Backported to 3.2:
 - Adjust context
 - s/ps->period/pt->period/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kvm/i8254.c | 18 ++++++++++++++++++
 arch/x86/kvm/lapic.c |  3 ---
 arch/x86/kvm/x86.c   |  3 +++
 arch/x86/kvm/x86.h   |  2 ++
 4 files changed, 23 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -38,6 +38,7 @@
 
 #include "irq.h"
 #include "i8254.h"
+#include "x86.h"
 
 #ifndef CONFIG_X86_64
 #define mod_64(x, y) ((x) - (y) * div64_u64(x, y))
@@ -364,6 +365,23 @@ static void create_pit_timer(struct kvm
 	atomic_set(&pt->pending, 0);
 	ps->irq_ack = 1;
 
+	/*
+	 * Do not allow the guest to program periodic timers with small
+	 * interval, since the hrtimers are not throttled by the host
+	 * scheduler.
+	 */
+	if (ps->is_periodic) {
+		s64 min_period = min_timer_period_us * 1000LL;
+
+		if (pt->period < min_period) {
+			pr_info_ratelimited(
+			    "kvm: requested %lld ns "
+			    "i8254 timer period limited to %lld ns\n",
+			    pt->period, min_period);
+			pt->period = min_period;
+		}
+	}
+
 	hrtimer_start(&pt->timer, ktime_add_ns(ktime_get(), interval),
 		      HRTIMER_MODE_ABS);
 }
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -68,9 +68,6 @@
 #define VEC_POS(v) ((v) & (32 - 1))
 #define REG_POS(v) (((v) >> 5) << 4)
 
-static unsigned int min_timer_period_us = 500;
-module_param(min_timer_period_us, uint, S_IRUGO | S_IWUSR);
-
 static inline u32 apic_get_reg(struct kvm_lapic *apic, int reg_off)
 {
 	return *((u32 *) (apic->regs + reg_off));
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -92,6 +92,9 @@ EXPORT_SYMBOL_GPL(kvm_x86_ops);
 int ignore_msrs = 0;
 module_param_named(ignore_msrs, ignore_msrs, bool, S_IRUGO | S_IWUSR);
 
+unsigned int min_timer_period_us = 500;
+module_param(min_timer_period_us, uint, S_IRUGO | S_IWUSR);
+
 bool kvm_has_tsc_control;
 EXPORT_SYMBOL_GPL(kvm_has_tsc_control);
 u32  kvm_max_guest_tsc_khz;
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -125,4 +125,6 @@ int kvm_write_guest_virt_system(struct x
 	gva_t addr, void *val, unsigned int bytes,
 	struct x86_exception *exception);
 
+extern unsigned int min_timer_period_us;
+
 #endif

