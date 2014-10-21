Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbaJUE1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:27:46 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:33484 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbaJUENM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:13:12 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, Lee Jones <lee.jones@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        =?UTF-8?q?Philippe=20R=C3=A9tornaz?= <philippe.retornaz@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 01/47] kernel: Add support for poweroff handler call chain
Date: Mon, 20 Oct 2014 21:12:17 -0700
Message-Id: <1413864783-3271-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.5445DD58.00BB,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various drivers implement architecture and/or device specific means to
remove power from the system.  For the most part, those drivers set the
global variable pm_power_off to point to a function within the driver.

This mechanism has a number of drawbacks.  Typically only one scheme
to remove power is supported (at least if pm_power_off is used).
At least in theory there can be multiple means remove power, some of
which may be less desirable. For example, some mechanisms may only
power off the CPU or the CPU card, while another may power off the
entire system.  Others may really just execute a restart sequence
or drop into the ROM monitor. Using pm_power_off can also be racy
if the function pointer is set from a driver built as module, as the
driver may be in the process of being unloaded when pm_power_off is
called. If there are multiple poweroff handlers in the system, removing
a module with such a handler may inadvertently reset the pointer to
pm_power_off to NULL, leaving the system with no means to remove power.

Introduce a system poweroff handler call chain to solve the described
problems.  This call chain is expected to be executed from the
architecture specific machine_power_off() function.  Drivers providing
system poweroff functionality are expected to register with this call chain.
By using the priority field in the notifier block, callers can control
poweroff handler execution sequence and thus ensure that the poweroff
handler with the optimal capabilities to remove power for a given system
is called first.

Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Alexander Graf <agraf@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Heiko Stuebner <heiko@sntech.de>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Philippe Rétornaz <philippe.retornaz@gmail.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2:
- poweroff -> power_off
- Add defines for default priorities
- Use raw notifiers protected by spinlocks instead of atomic notifiers
- Add register_poweroff_handler_simple
- Add devm_register_power_off_handler

 include/linux/pm.h              |  22 ++++
 kernel/power/Makefile           |   1 +
 kernel/power/poweroff_handler.c | 252 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 275 insertions(+)
 create mode 100644 kernel/power/poweroff_handler.c

diff --git a/include/linux/pm.h b/include/linux/pm.h
index 383fd68..7e0cb36 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -34,7 +34,29 @@
 extern void (*pm_power_off)(void);
 extern void (*pm_power_off_prepare)(void);
 
+/*
+ * Callbacks to manage poweroff handlers
+ */
+
+struct notifier_block;
 struct device; /* we have a circular dep with device.h */
+
+int register_power_off_handler(struct notifier_block *);
+int devm_register_power_off_handler(struct device *, struct notifier_block *);
+int register_power_off_handler_simple(void (*function)(void), int priority);
+int unregister_power_off_handler(struct notifier_block *);
+void do_kernel_power_off(void);
+bool have_kernel_power_off(void);
+
+/*
+ * Pre-defined poweroff handler priorities
+ */
+#define POWEROFF_PRIORITY_FALLBACK	0
+#define POWEROFF_PRIORITY_LOW		64
+#define POWEROFF_PRIORITY_DEFAULT	128
+#define POWEROFF_PRIORITY_HIGH		192
+#define POWEROFF_PRIORITY_HIGHEST	255
+
 #ifdef CONFIG_VT_CONSOLE_SLEEP
 extern void pm_vt_switch_required(struct device *dev, bool required);
 extern void pm_vt_switch_unregister(struct device *dev);
diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index 29472bf..4d9f0c7 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -2,6 +2,7 @@
 ccflags-$(CONFIG_PM_DEBUG)	:= -DDEBUG
 
 obj-y				+= qos.o
+obj-y				+= poweroff_handler.o
 obj-$(CONFIG_PM)		+= main.o
 obj-$(CONFIG_VT_CONSOLE_SLEEP)	+= console.o
 obj-$(CONFIG_FREEZER)		+= process.o
diff --git a/kernel/power/poweroff_handler.c b/kernel/power/poweroff_handler.c
new file mode 100644
index 0000000..aeb4736
--- /dev/null
+++ b/kernel/power/poweroff_handler.c
@@ -0,0 +1,252 @@
+/*
+ * linux/kernel/power/poweroff_handler.c - Poweroff handling functions
+ *
+ * Copyright (c) 2014 Guenter Roeck
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#define pr_fmt(fmt)	"poweroff: " fmt
+
+#include <linux/ctype.h>
+#include <linux/device.h>
+#include <linux/export.h>
+#include <linux/kallsyms.h>
+#include <linux/notifier.h>
+#include <linux/pm.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+
+/*
+ *	Notifier list for kernel code which wants to be called
+ *	to power off the system.
+ */
+static RAW_NOTIFIER_HEAD(power_off_handler_list);
+static DEFINE_SPINLOCK(power_off_handler_lock);
+
+/*
+ * Internal function to register poweroff notifier.
+ * Must be called with poweroff spinlock acquired.
+ */
+static int _register_power_off_handler(struct notifier_block *nb)
+{
+	return raw_notifier_chain_register(&power_off_handler_list, nb);
+}
+
+/**
+ *	register_power_off_handler - Register function to be called to power off
+ *				     the system
+ *	@nb: Info about handler function to be called
+ *	@nb->priority:	Handler priority. Handlers should follow the
+ *			following guidelines for setting priorities.
+ *			0:	Poweroff handler of last resort,
+ *				with limited poweroff capabilities,
+ *				such as poweroff handlers which
+ *				do not really power off the system
+ *				but loop forever or stop the CPU.
+ *			128:	Default poweroff handler; use if no other
+ *				poweroff handler is expected to be available,
+ *				and/or if poweroff functionality is
+ *				sufficient to power off the entire system
+ *			255:	Highest priority poweroff handler, will
+ *				preempt all other poweroff handlers
+ *
+ *	Registers a function with code to be called to power off the
+ *	system.
+ *
+ *	Registered functions will be called from machine_power_off as last
+ *	step of the poweroff sequence. Registered functions are expected
+ *	to power off the system immediately. If more than one function is
+ *	registered, the poweroff handler priority selects which function
+ *	will be called first.
+ *
+ *	Poweroff handlers may be registered from architecture code or from
+ *	drivers. A typical use case would be a system where power off
+ *	functionality is provided through a multi-function chip or through
+ *	a programmable power controller. Multiple poweroff handlers may exist;
+ *	for example, one poweroff handler might power off the entire system,
+ *	while another only powers off the CPU card. In such cases, the
+ *	poweroff handler which only powers off part of the hardware is
+ *	expected to register with low priority to ensure that it only
+ *	runs if no other means to power off the system are available.
+ *
+ *	Currently always returns zero, as raw_notifier_chain_register()
+ *	always returns zero.
+ */
+int register_power_off_handler(struct notifier_block *nb)
+{
+	int ret;
+
+	spin_lock(&power_off_handler_lock);
+	ret = _register_power_off_handler(nb);
+	spin_unlock(&power_off_handler_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(register_power_off_handler);
+
+/**
+ *	unregister_power_off_handler - Unregister previously registered
+ *				       poweroff handler
+ *	@nb: Hook to be unregistered
+ *
+ *	Unregisters a previously registered poweroff handler function.
+ *
+ *	Returns zero on success, or %-ENOENT on failure.
+ */
+int unregister_power_off_handler(struct notifier_block *nb)
+{
+	int ret;
+
+	spin_lock(&power_off_handler_lock);
+	ret = raw_notifier_chain_unregister(&power_off_handler_list, nb);
+	spin_unlock(&power_off_handler_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(unregister_power_off_handler);
+
+struct _power_off_handler_data {
+	void (*handler)(void);
+	struct notifier_block poweroff_nb;
+};
+
+static int _power_off_handler(struct notifier_block *this,
+			      unsigned long _unused1, void *_unused2)
+{
+	struct _power_off_handler_data *poh =
+		container_of(this, struct _power_off_handler_data, poweroff_nb);
+
+	poh->handler();
+
+	return NOTIFY_DONE;
+}
+
+static struct _power_off_handler_data power_off_handler_data;
+
+/**
+ *	register_power_off_handler_simple - Register function to be called
+ *					    to power off the system
+ *	@handler:	Function to be called to power off the system
+ *	@priority:	Handler priority. For priority guidelines see
+ *			register_power_off_handler.
+ *
+ *	This is a simplified version of register_power_off_handler. It does
+ *	not take a notifier as argument, but a function pointer. The function
+ *	registers a poweroff handler with specified priority. Poweroff
+ *	handlers registered with this function can not be unregistered,
+ *	and only a single poweroff handler can be installed using it.
+ *
+ *	This function must not be called from modules and is therefore
+ *	not exported.
+ *
+ *	Returns -EBUSY if a poweroff handler has already been registered
+ *	using register_power_off_handler_simple. Otherwise returns zero,
+ *	since raw_notifier_chain_register() currently always returns zero.
+ */
+int register_power_off_handler_simple(void (*handler)(void), int priority)
+{
+	int ret;
+
+	spin_lock(&power_off_handler_lock);
+
+	if (power_off_handler_data.handler) {
+		pr_warn("Poweroff function already registered (%ps), cannot register %ps",
+			power_off_handler_data.handler, handler);
+		ret = -EBUSY;
+		goto abort;
+	}
+
+	power_off_handler_data.handler = handler;
+	power_off_handler_data.poweroff_nb.notifier_call = _power_off_handler;
+	power_off_handler_data.poweroff_nb.priority = priority;
+
+	ret = _register_power_off_handler(&power_off_handler_data.poweroff_nb);
+abort:
+	spin_unlock(&power_off_handler_lock);
+	return ret;
+}
+
+/* Device managed poweroff handler registration */
+
+static void devm_poweroff_release(struct device *dev, void *res)
+{
+	struct notifier_block *nb = *(struct notifier_block **)res;
+
+	unregister_power_off_handler(nb);
+}
+
+/**
+ *	devm_register_power_off_handler - Register function to be called
+ *					  to power off the system
+ *	@dev:		The device registering the poweroff handler.
+ *	@handler:	Function to be called to power off the system
+ *	@priority:	Handler priority. For priority guidelines see
+ *			register_power_off_handler.
+ *
+ *	This is the device managed version of register_power_off_handler.
+ *
+ *	Returns -EINVAL if dev is NULL. Returns -ENOMEM if the system is out
+ *	of memory. Otherwise returns zero, since raw_notifier_chain_register()
+ *	currently always returns zero.
+ */
+int devm_register_power_off_handler(struct device *dev,
+				    struct notifier_block *nb)
+{
+	struct notifier_block **ptr;
+	int ret;
+
+	if (!dev)
+		return -EINVAL;
+
+	ptr = devres_alloc(devm_poweroff_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return -ENOMEM;
+
+	spin_lock(&power_off_handler_lock);
+	ret = _register_power_off_handler(nb);
+	spin_unlock(&power_off_handler_lock);
+	if (ret)
+		goto error;
+
+	*ptr = nb;
+	devres_add(dev, ptr);
+	return 0;
+error:
+	devres_free(ptr);
+	return ret;
+}
+EXPORT_SYMBOL(devm_register_power_off_handler);
+
+/**
+ *	do_kernel_power_off - Execute kernel poweroff handler call chain
+ *
+ *	Calls functions registered with register_power_off_handler.
+ *
+ *	Expected to be called from machine_power_off as last step of
+ *	the poweroff sequence.
+ *
+ *	Powers off the system immediately if a poweroff handler function
+ *	has been registered. Otherwise does nothing.
+ */
+void do_kernel_power_off(void)
+{
+	spin_lock(&power_off_handler_lock);
+	raw_notifier_call_chain(&power_off_handler_list, 0, NULL);
+	spin_unlock(&power_off_handler_lock);
+}
+
+/**
+ * have_kernel_power_off() - Check if kernel poweroff handler is available
+ *
+ * Returns true is a kernel poweroff handler is available, false otherwise.
+ */
+bool have_kernel_power_off(void)
+{
+	return pm_power_off != NULL || power_off_handler_list.head != NULL;
+}
+EXPORT_SYMBOL(have_kernel_power_off);
-- 
1.9.1

