Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaHTApu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 20:45:50 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:65196 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaHTApr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 20:45:47 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Russell King <linux@arm.linux.org.uk>, Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v7 00/11] kernel: Add support for restart handler call chain
Date: Tue, 19 Aug 2014 17:45:27 -0700
Message-Id: <1408495538-27480-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
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
the arm_pm_restart function. Several other restart drivers for arm, all
directly calling arm_pm_restart, are in the process of being integrated
into the kernel. All those drivers would benefit from the new API.

The existing mechanisms have a number of drawbacks. Typically only one scheme
to restart the system is supported (at least if arm_pm_restart is used).
At least in theory there can be multiple means to restart the system, some of
which may be less desirable (for example one mechanism may only reset the CPU,
while another may reset the entire system). Using arm_pm_restart can also be
racy if the function pointer is set from a driver, as the driver may be in
the process of being unloaded when arm_pm_restart is called.
Using the reboot notifier is always racy, as it is unknown if and when
other functions using the reboot notifier have completed execution
by the time the watchdog fires.

Introduce a system restart handler call chain to solve the described problems.
This call chain is expected to be executed from the architecture specific
machine_restart() function. Drivers providing system restart functionality
(such as the watchdog drivers mentioned above) are expected to register
with this call chain. By using the priority field in the notifier block,
callers can control restart handler execution sequence and thus ensure that
the restart handler with the optimal restart capabilities for a given system
is called first.

Since the first revision of this patchset, a number of separate patch
submissions have been made which either depend on it or could make use of it.

http://www.spinics.net/linux/lists/arm-kernel/msg344796.html
	registers three notifiers.
https://lkml.org/lkml/2014/7/8/962
	would benefit from it.

Patch 1 of this series implements the restart handler function. Patches 2 and 3
implement calling the restart handler chain from arm and arm64 restart code.

Patch 4 modifies the restart-poweroff driver to no longer call arm_pm_restart
directly but machine_restart. This is done to avoid calling arm_pm_restart
from more than one place. The change makes the driver architecture independent,
so it would be possible to drop the arm dependency from its Kconfig entry.

Patch 5 and 6 convert existing restart handlers in the watchdog subsystem
to use the restart handler. Patch 7 unexports arm_pm_restart to ensure
that no one gets the idea to implement a restart handler as module.

The entire patch series, including additional patches depending on it,
is available from
https://git.kernel.org/cgit/linux/kernel/git/groeck/linux-staging.git/
in branch 'restart-staging'.

---
v7: Rebased to v3.17-rc1
    Dropped null_restart from arm code to make arm_pm_restart truly optional
    Reordered series. power/restart must be patched to not use arm_pm_restart
    prior to making arm_pm_restart optional.
    Added all pending patches to series
v6: Use atomic notifier call chain 
    Rebased series to v3.16
v5: Rebased series to v3.16-rc5
    Function renames:
    register_restart_notifier -> register_restart_handler
    unregister_restart_notifier -> unregister_restart_handler
    kernel_restart_notify -> do_kernel_restart
v4: Document restart notifier priorities
    Select 128 as default priority for newly introduced notifiers
    Fix checkpatch warning (line too long) in moxart patch
v3: Drop RFC.
    Add kernel_restart_notify wrapper function to execute notifier
    Improve documentation.
    Move restart_notifier_list into kernel/reboot.c and make it static.
v2: Add patch 4.
    Only call blocking notifier call chain if arm_pm_restart was not set.
