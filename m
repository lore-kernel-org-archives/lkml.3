Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab3KYXXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 18:23:10 -0500
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:63109 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752133Ab3KYXXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 18:23:06 -0500
To: mingo@kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org, ralf@linux-mips.org,
        akpm@linux-foundation.org, mpe@ellerman.id.au,
        felipe.contreras@gmail.com, linux-kernel@vger.kernel.org
Message-Id: <1a1674daec27c534df409697025ac568ebcee91e.1385418410.git.jbaron@akamai.com>
In-Reply-To: <cover.1385418410.git.jbaron@akamai.com>
References: <cover.1385418410.git.jbaron@akamai.com>
From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH 1/3 v3] panic: Make panic_timeout configurable
Date: Mon, 25 Nov 2013 23:23:04 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The panic_timeout value can be set via the command line option 'panic=x', or via
/proc/sys/kernel/panic, however that is not sufficient when the panic occurs
before we are able to set up these values. Thus, add a CONFIG_PANIC_TIMEOUT
so that we can set the desired value from the .config.

The default panic_timeout value continues to be 0 - wait forever. Also adds
set_arch_panic_timeout(new_timeout, arch_default_timeout), which is intended
to be used by arches in arch_setup(). The idea being that the new_timeout
is only set if the user hasn't changed from the arch_default_timeout.

Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 include/linux/kernel.h | 9 +++++++++
 kernel/panic.c         | 2 +-
 lib/Kconfig.debug      | 9 +++++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d4e98d1..2ac0277 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -393,6 +393,15 @@ extern int panic_on_oops;
 extern int panic_on_unrecovered_nmi;
 extern int panic_on_io_nmi;
 extern int sysctl_panic_on_stackoverflow;
+/*
+ * Only to be used by arch init code. If the user over-wrote the default
+ * CONFIG_PANIC_TIMEOUT, honor it.
+ */
+static inline void set_arch_panic_timeout(int timeout, int arch_default_timeout)
+{
+	if (panic_timeout == arch_default_timeout)
+		panic_timeout = timeout;
+}
 extern const char *print_tainted(void);
 enum lockdep_ok {
 	LOCKDEP_STILL_OK,
diff --git a/kernel/panic.c b/kernel/panic.c
index c00b4ce..6d63003 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -33,7 +33,7 @@ static int pause_on_oops;
 static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
 
-int panic_timeout;
+int panic_timeout = CONFIG_PANIC_TIMEOUT;
 EXPORT_SYMBOL_GPL(panic_timeout);
 
 ATOMIC_NOTIFIER_HEAD(panic_notifier_list);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index db25707..6982094 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -761,6 +761,15 @@ config PANIC_ON_OOPS_VALUE
 	default 0 if !PANIC_ON_OOPS
 	default 1 if PANIC_ON_OOPS
 
+config PANIC_TIMEOUT
+	int "panic timeout"
+	default 0
+	help
+	  Set the timeout value (in seconds) until a reboot occurs when the
+	  the kernel panics. If n = 0, then we wait forever. A timeout
+	  value n > 0 will wait n seconds before rebooting, while a timeout
+	  value n < 0 will reboot immediately.
+
 config SCHED_DEBUG
 	bool "Collect scheduler debugging info"
 	depends on DEBUG_KERNEL && PROC_FS
-- 
1.8.2

