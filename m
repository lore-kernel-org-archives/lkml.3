Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3JLAnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 20:43:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508Ab3JLAnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 20:43:49 -0400
Message-Id: <20131012004216.971202555@amt.cnet>
User-Agent: quilt/0.60-1
Date: Fri, 11 Oct 2013 21:39:25 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: kvm@vger.kernel.org
Cc: dzickus@redhat.com, pbonzini@redhat.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch 1/2] pvclock: detect watchdog reset at pvclock read
References: <20131012003924.092908362@amt.cnet>
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
@@ -43,6 +43,13 @@ unsigned long pvclock_tsc_khz(struct pvc
 	return pv_tsc_khz;
 }
 
+void pvclock_touch_watchdogs(void)
+{
+	touch_softlockup_watchdog_sync();
+	clocksource_touch_watchdog();
+	rcu_cpu_stall_reset();
+}
+
 static atomic64_t last_value = ATOMIC64_INIT(0);
 
 void pvclock_resume(void)
@@ -74,6 +81,11 @@ cycle_t pvclock_clocksource_read(struct
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


