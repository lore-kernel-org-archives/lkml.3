Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbaGFXkM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 19:40:12 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:64142 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaGFXip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 19:38:45 -0400
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
        David Woodhouse <dwmw2@infradead.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 3/7] arm: Support restart through restart notifier call chain
Date: Sun,  6 Jul 2014 16:38:16 -0700
Message-Id: <1404689900-27421-4-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404689900-27421-1-git-send-email-linux@roeck-us.net>
References: <1404689900-27421-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel core now supports a notifier call chain for system
restart functions.

With this change, the arm_pm_restart callback is now optional,
so check if it is set before calling it. Only call the notifier
functions if arm_pm_restart is not set.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: Only call notifier call chain if arm_pm_restart is not set
    Do not include linux/watchdog.h

 arch/arm/kernel/process.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 81ef686..5108e45 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -230,7 +230,11 @@ void machine_restart(char *cmd)
 	local_irq_disable();
 	smp_send_stop();
 
-	arm_pm_restart(reboot_mode, cmd);
+	if (arm_pm_restart)
+		arm_pm_restart(reboot_mode, cmd);
+	else
+		blocking_notifier_call_chain(&restart_notifier_list,
+					     reboot_mode, cmd);
 
 	/* Give a grace period for failure to restart of 1s */
 	mdelay(1000);
-- 
1.9.1

