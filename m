Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaHTAqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 20:46:12 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:61901 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaHTAqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 20:46:05 -0400
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
Subject: [PATCH v7 04/11] arm: Support restart through restart handler call chain
Date: Tue, 19 Aug 2014 17:45:31 -0700
Message-Id: <1408495538-27480-5-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408495538-27480-1-git-send-email-linux@roeck-us.net>
References: <1408495538-27480-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel core now supports a restart handler call chain for system
restart functions.

With this change, the arm_pm_restart callback is now optional, so
drop its initialization and check if it is set before calling it.
Only call the kernel restart handler if arm_pm_restart is not set.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Heiko Stuebner <heiko@sntech.de>
---
v7: Dropped null_restart and made arm_pm_restart truly optional.
v6: No change.
v5: Renamed restart function to do_kernel_restart
v4: No change.
v3: Use wrapper function to execute notifier call chain.
v2: Only call notifier call chain if arm_pm_restart is not set.
    Do not include linux/watchdog.h.

 arch/arm/kernel/process.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 81ef686..ea279f7 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -114,17 +114,13 @@ void soft_restart(unsigned long addr)
 	BUG();
 }
 
-static void null_restart(enum reboot_mode reboot_mode, const char *cmd)
-{
-}
-
 /*
  * Function pointers to optional machine specific functions
  */
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
-void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd) = null_restart;
+void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
 EXPORT_SYMBOL_GPL(arm_pm_restart);
 
 /*
@@ -230,7 +226,10 @@ void machine_restart(char *cmd)
 	local_irq_disable();
 	smp_send_stop();
 
-	arm_pm_restart(reboot_mode, cmd);
+	if (arm_pm_restart)
+		arm_pm_restart(reboot_mode, cmd);
+	else
+		do_kernel_restart(cmd);
 
 	/* Give a grace period for failure to restart of 1s */
 	mdelay(1000);
-- 
1.9.1

