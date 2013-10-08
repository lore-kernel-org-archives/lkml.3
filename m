Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab3JHBGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 21:06:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab3JHBGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 21:06:19 -0400
Message-Id: <20131008010552.779616517@amt.cnet>
User-Agent: quilt/0.60-1
Date: Mon, 07 Oct 2013 22:05:17 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: kvm@vger.kernel.org
Cc: dzickus@redhat.com, pbonzini@redhat.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch 2/3] pvclock: detect watchdog reset at pvclock read
References: <20131008010515.516032211@amt.cnet>
Content-Disposition: inline; filename=02-kvmclock-touch-watchdog-on-kvmclock-read
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement reset of kernel watchdogs at pvclock read time. This avoids
adding special code to every watchdog.

This is possible for watchdogs which measure time based on sched_clock() or 
ktime_get() variants.

Suggested by Don Zickus.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

Index: kvm/arch/x86/kernel/kvmclock.c
===================================================================
--- kvm.orig/arch/x86/kernel/kvmclock.c
+++ kvm/arch/x86/kernel/kvmclock.c
@@ -139,6 +139,7 @@ bool kvm_check_and_clear_guest_paused(vo
 	src = &hv_clock[cpu].pvti;
 	if ((src->flags & PVCLOCK_GUEST_STOPPED) != 0) {
 		src->flags &= ~PVCLOCK_GUEST_STOPPED;
+		pvclock_touch_watchdogs();
 		ret = true;
 	}
 
Index: kvm/arch/x86/kernel/pvclock.c
===================================================================
--- kvm.orig/arch/x86/kernel/pvclock.c
+++ kvm/arch/x86/kernel/pvclock.c
@@ -21,6 +21,7 @@
 #include <linux/sched.h>
 #include <linux/gfp.h>
 #include <linux/bootmem.h>
+#include <linux/hung_task.h>
 #include <asm/fixmap.h>
 #include <asm/pvclock.h>
 
@@ -43,6 +44,14 @@ unsigned long pvclock_tsc_khz(struct pvc
 	return pv_tsc_khz;
 }
 
+void pvclock_touch_watchdogs(void)
+{
+	touch_softlockup_watchdog_sync();
+	clocksource_touch_watchdog();
+	rcu_cpu_stall_reset();
+	reset_hung_task_detector();
+}
+
 static atomic64_t last_value = ATOMIC64_INIT(0);
 
 void pvclock_resume(void)
@@ -74,6 +83,11 @@ cycle_t pvclock_clocksource_read(struct
 		version = __pvclock_read_cycles(src, &ret, &flags);
 	} while ((src->version & 1) || version != src->version);
 
+	if (unlikely((flags & PVCLOCK_GUEST_STOPPED) != 0)) {
+		src->flags &= ~PVCLOCK_GUEST_STOPPED;
+		pvclock_touch_watchdogs();
+	}
+
 	if ((valid_flags & PVCLOCK_TSC_STABLE_BIT) &&
 		(flags & PVCLOCK_TSC_STABLE_BIT))
 		return ret;
Index: kvm/arch/x86/include/asm/pvclock.h
===================================================================
--- kvm.orig/arch/x86/include/asm/pvclock.h
+++ kvm/arch/x86/include/asm/pvclock.h
@@ -14,6 +14,8 @@ void pvclock_read_wallclock(struct pvclo
 			    struct timespec *ts);
 void pvclock_resume(void);
 
+void pvclock_touch_watchdogs(void);
+
 /*
  * Scale a 64-bit delta by scaling and multiplying by a 32-bit fraction,
  * yielding a 64-bit result.


