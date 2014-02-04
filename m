Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933810AbaBDVIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:08:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933787AbaBDVHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:07:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.12 011/133] KVM: x86: limit PIT timer frequency
Date: Tue,  4 Feb 2014 13:06:52 -0800
Message-Id: <20140204210737.339912254@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

commit 9ed96e87c5748de4c2807ef17e81287c7304186c upstream.

Limit PIT timer frequency similarly to the limit applied by
LAPIC timer.

Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/i8254.c |   18 ++++++++++++++++++
 arch/x86/kvm/lapic.c |    3 ---
 arch/x86/kvm/x86.c   |    3 +++
 arch/x86/kvm/x86.h   |    2 ++
 4 files changed, 23 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -37,6 +37,7 @@
 
 #include "irq.h"
 #include "i8254.h"
+#include "x86.h"
 
 #ifndef CONFIG_X86_64
 #define mod_64(x, y) ((x) - (y) * div64_u64(x, y))
@@ -349,6 +350,23 @@ static void create_pit_timer(struct kvm
 	atomic_set(&ps->pending, 0);
 	ps->irq_ack = 1;
 
+	/*
+	 * Do not allow the guest to program periodic timers with small
+	 * interval, since the hrtimers are not throttled by the host
+	 * scheduler.
+	 */
+	if (ps->is_periodic) {
+		s64 min_period = min_timer_period_us * 1000LL;
+
+		if (ps->period < min_period) {
+			pr_info_ratelimited(
+			    "kvm: requested %lld ns "
+			    "i8254 timer period limited to %lld ns\n",
+			    ps->period, min_period);
+			ps->period = min_period;
+		}
+	}
+
 	hrtimer_start(&ps->timer, ktime_add_ns(ktime_get(), interval),
 		      HRTIMER_MODE_ABS);
 }
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -71,9 +71,6 @@
 #define VEC_POS(v) ((v) & (32 - 1))
 #define REG_POS(v) (((v) >> 5) << 4)
 
-static unsigned int min_timer_period_us = 500;
-module_param(min_timer_period_us, uint, S_IRUGO | S_IWUSR);
-
 static inline void apic_set_reg(struct kvm_lapic *apic, int reg_off, u32 val)
 {
 	*((u32 *) (apic->regs + reg_off)) = val;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -94,6 +94,9 @@ EXPORT_SYMBOL_GPL(kvm_x86_ops);
 static bool ignore_msrs = 0;
 module_param(ignore_msrs, bool, S_IRUGO | S_IWUSR);
 
+unsigned int min_timer_period_us = 500;
+module_param(min_timer_period_us, uint, S_IRUGO | S_IWUSR);
+
 bool kvm_has_tsc_control;
 EXPORT_SYMBOL_GPL(kvm_has_tsc_control);
 u32  kvm_max_guest_tsc_khz;
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -124,5 +124,7 @@ int kvm_write_guest_virt_system(struct x
 
 extern u64 host_xcr0;
 
+extern unsigned int min_timer_period_us;
+
 extern struct static_key kvm_no_apic_vcpu;
 #endif


