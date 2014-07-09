Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaGIDiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 23:38:16 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:43129 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbaGIDiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 23:38:13 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v3 1/7] kernel: Add support for restart notifier call chain
Date: Tue,  8 Jul 2014 20:37:57 -0700
Message-Id: <1404877083-6552-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404877083-6552-1-git-send-email-linux@roeck-us.net>
References: <1404877083-6552-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various drivers implement architecture and/or device specific means
to restart (reset) the system. Various mechanisms have been implemented
to support those schemes. The best known mechanism is arm_pm_restart,
which is a function pointer to be set either from platform specific code
or from drivers. Another mechanism is to use hardware watchdogs to issue
a reset; this mechanism is used if there is no other method available
to reset a board or system. Two examples are alim7101_wdt, which currently
uses the reboot notifier to trigger a reset, and moxart_wdt, which registers
the arm_pm_restart function.

The existing mechanisms have a number of drawbacks. Typically only one scheme
to restart the system is supported (at least if arm_pm_restart is used).
At least in theory there can be mutliple means to restart the system, some of
which may be less desirable (for example one mechanism may only reset the CPU,
while another may reset the entire system). Using arm_pm_restart can also be
racy if the function pointer is set from a driver, as the driver may be in
the process of being unloaded when arm_pm_restart is called.
Using the reboot notifier is always racy, as it is unknown if and when
other functions using the reboot notifier have completed execution
by the time the watchdog fires.

To solve the problem, introduce a system restart notifier. This notifier
is expected to be called from the architecture specific machine_restart()
function. Drivers providing system restart functionality (such as the watchdog
drivers mentioned above) are expected to register with this notifier.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v3: Add kernel_restart_notify wrapper function to execute notifier.
    Improve documentation.
    Move restart_notifier_list into kernel/reboot.c and make it static.
v2: No change.

 include/linux/reboot.h |  3 +++
 kernel/reboot.c        | 71 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/include/linux/reboot.h b/include/linux/reboot.h
index 48bf152..120db73 100644
--- a/include/linux/reboot.h
+++ b/include/linux/reboot.h
@@ -38,6 +38,9 @@ extern int reboot_force;
 extern int register_reboot_notifier(struct notifier_block *);
 extern int unregister_reboot_notifier(struct notifier_block *);
 
+extern int register_restart_notifier(struct notifier_block *);
+extern int unregister_restart_notifier(struct notifier_block *);
+extern void kernel_restart_notify(char *cmd);
 
 /*
  * Architecture-specific implementations of sys_reboot commands.
diff --git a/kernel/reboot.c b/kernel/reboot.c
index a3a9e24..7bd6575 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -104,6 +104,77 @@ int unregister_reboot_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL(unregister_reboot_notifier);
 
+/*
+ *	Notifier list for kernel code which wants to be called
+ *	to restart the system.
+ */
+static BLOCKING_NOTIFIER_HEAD(restart_notifier_list);
+
+/**
+ *	register_restart_notifier - Register function to be called to reset
+ *				    the system
+ *	@nb: Info about notifier function to be called
+ *
+ *	Registers a function with the list of functions
+ *	to be called to restart the system.
+ *
+ *	Registered functions will be called from machine_restart as last
+ *	step of the restart sequence (if the architecture specific
+ *	machine_restart function calls kernel_restart_notify - see below
+ *	for details).
+ *	Registered functions are expected to restart the system immediately.
+ *	If more than one function is registered, the notifier priority
+ *	selects which function will be called first.
+ *
+ *	Restart notifiers are expected to be registered from non-architecture
+ *	code, typically from drivers. A typical use case would be a system
+ *	where restart functionality is provided through a watchdog. Multiple
+ *	restart handlers may exist; for example, one restart handler might
+ *	restart the entire system, while another only restarts the CPU.
+ *	In such cases, the restart handler which only restarts part of the
+ *	hardware is expected to register with low priority to ensure that
+ *	it only runs if no other means to restart the system is available.
+ *
+ *	Currently always returns zero, as blocking_notifier_chain_register()
+ *	always returns zero.
+ */
+int register_restart_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&restart_notifier_list, nb);
+}
+EXPORT_SYMBOL(register_restart_notifier);
+
+/**
+ *	unregister_restart_notifier - Unregister previously registered
+ *				      restart notifier
+ *	@nb: Hook to be unregistered
+ *
+ *	Unregisters a previously registered restart notifier function.
+ *
+ *	Returns zero on success, or %-ENOENT on failure.
+ */
+int unregister_restart_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&restart_notifier_list, nb);
+}
+EXPORT_SYMBOL(unregister_restart_notifier);
+
+/**
+ *	kernel_restart_notify - Execute kernel restart handler call chain
+ *
+ *	Calls functions registered with register_restart_notifier.
+ *
+ *	Expected to be called from machine_restart as last step of the restart
+ *	sequence.
+ *
+ *	Restarts the system immediately if a restart notifier function has been
+ *	registered. Otherwise does nothing.
+ */
+void kernel_restart_notify(char *cmd)
+{
+	blocking_notifier_call_chain(&restart_notifier_list, reboot_mode, cmd);
+}
+
 void migrate_to_reboot_cpu(void)
 {
 	/* The boot cpu is always logical cpu 0 */
-- 
1.9.1

