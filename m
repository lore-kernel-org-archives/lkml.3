Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab3KZOVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 09:21:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58300 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab3KZOVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 09:21:33 -0500
Date: Tue, 26 Nov 2013 06:21:06 -0800
From: tip-bot for Jason Baron <tipbot@zytor.com>
Message-ID: <tip-5800dc3cff87c3a1548382298bb16e1fb4ec7e32@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        jbaron@akamai.com, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        jbaron@akamai.com, akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <1a1674daec27c534df409697025ac568ebcee91e.1385418410.git.jbaron@akamai.com>
References: <1a1674daec27c534df409697025ac568ebcee91e.1385418410.git.jbaron@akamai.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/debug] panic: Make panic_timeout configurable
Git-Commit-ID: 5800dc3cff87c3a1548382298bb16e1fb4ec7e32
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 26 Nov 2013 06:21:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5800dc3cff87c3a1548382298bb16e1fb4ec7e32
Gitweb:     http://git.kernel.org/tip/5800dc3cff87c3a1548382298bb16e1fb4ec7e32
Author:     Jason Baron <jbaron@akamai.com>
AuthorDate: Mon, 25 Nov 2013 23:23:04 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 26 Nov 2013 12:12:26 +0100

panic: Make panic_timeout configurable

The panic_timeout value can be set via the command line option
'panic=x', or via /proc/sys/kernel/panic, however that is not
sufficient when the panic occurs before we are able to set up
these values. Thus, add a CONFIG_PANIC_TIMEOUT so that we can
set the desired value from the .config.

The default panic_timeout value continues to be 0 - wait
forever. Also adds set_arch_panic_timeout(new_timeout,
arch_default_timeout), which is intended to be used by arches in
arch_setup(). The idea being that the new_timeout is only set if
the user hasn't changed from the arch_default_timeout.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Cc: benh@kernel.crashing.org
Cc: paulus@samba.org
Cc: ralf@linux-mips.org
Cc: mpe@ellerman.id.au
Cc: felipe.contreras@gmail.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1a1674daec27c534df409697025ac568ebcee91e.1385418410.git.jbaron@akamai.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
