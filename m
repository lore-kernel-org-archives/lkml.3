Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbaJQRAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 13:00:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618AbaJQRAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 13:00:16 -0400
From: Ulrich Obergfell <uobergfe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: dzickus@redhat.com, uobergfe@redhat.com
Subject: [PATCH v2 9/9] watchdog: introduce the hardlockup_detector_disable() function
Date: Fri, 17 Oct 2014 19:06:28 +0200
Message-Id: <1413565588-4144-10-git-send-email-uobergfe@redhat.com>
In-Reply-To: <1413565588-4144-1-git-send-email-uobergfe@redhat.com>
References: <1413565588-4144-1-git-send-email-uobergfe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have kvm_guest_init() use hardlockup_detector_disable()
instead of watchdog_enable_hardlockup_detector(false).

Remove the watchdog_hardlockup_detector_is_enabled() and
the watchdog_enable_hardlockup_detector() function which
are no longer needed.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
---
 arch/x86/kernel/kvm.c |  2 +-
 include/linux/nmi.h   |  9 ++-------
 kernel/watchdog.c     | 21 ++-------------------
 3 files changed, 5 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 95c3cb1..3bb22bc 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -506,7 +506,7 @@ void __init kvm_guest_init(void)
 	 * can get false positives too easily, for example if the host is
 	 * overcommitted.
 	 */
-	watchdog_enable_hardlockup_detector(false);
+	hardlockup_detector_disable();
 }
 
 static noinline uint32_t __kvm_cpuid_base(void)
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 0426357..3d46fb4 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -25,16 +25,11 @@ static inline void touch_nmi_watchdog(void)
 #endif
 
 #if defined(CONFIG_HARDLOCKUP_DETECTOR)
-extern void watchdog_enable_hardlockup_detector(bool val);
-extern bool watchdog_hardlockup_detector_is_enabled(void);
+extern void hardlockup_detector_disable(void);
 #else
-static inline void watchdog_enable_hardlockup_detector(bool val)
+static inline void hardlockup_detector_disable(void)
 {
 }
-static inline bool watchdog_hardlockup_detector_is_enabled(void)
-{
-	return true;
-}
 #endif
 
 /*
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index f435e37..1d3c589 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -83,8 +83,6 @@ static unsigned long soft_lockup_nmi_warn;
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 static int hardlockup_panic =
 			CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE;
-
-static bool hardlockup_detector_enabled = true;
 /*
  * We may not want to enable hard lockup detection by default in all cases,
  * for example when running the kernel as a guest on a hypervisor. In these
@@ -93,14 +91,9 @@ static bool hardlockup_detector_enabled = true;
  * kernel command line parameters are parsed, because otherwise it is not
  * possible to override this in hardlockup_panic_setup().
  */
-void watchdog_enable_hardlockup_detector(bool val)
-{
-	hardlockup_detector_enabled = val;
-}
-
-bool watchdog_hardlockup_detector_is_enabled(void)
+void hardlockup_detector_disable(void)
 {
-	return hardlockup_detector_enabled;
+	watchdog_enabled &= ~NMI_WATCHDOG_ENABLED;
 }
 
 static int __init hardlockup_panic_setup(char *str)
@@ -524,15 +517,6 @@ static int watchdog_nmi_enable(unsigned int cpu)
 	if (!(watchdog_enabled & NMI_WATCHDOG_ENABLED))
 		goto out;
 
-	/*
-	 * Some kernels need to default hard lockup detection to
-	 * 'disabled', for example a guest on a hypervisor.
-	 */
-	if (!watchdog_hardlockup_detector_is_enabled()) {
-		event = ERR_PTR(-ENOENT);
-		goto handle_err;
-	}
-
 	/* is it already setup and enabled? */
 	if (event && event->state > PERF_EVENT_STATE_OFF)
 		goto out;
@@ -547,7 +531,6 @@ static int watchdog_nmi_enable(unsigned int cpu)
 	/* Try to register using hardware perf events */
 	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback, NULL);
 
-handle_err:
 	/* save cpu0 error for future comparision */
 	if (cpu == 0 && IS_ERR(event))
 		cpu0_err = PTR_ERR(event);
-- 
1.7.11.7

