Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab3HTCEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:04:39 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43474 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3HTCEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:04:35 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC 02/17] ARM: call clk_of_init from time_init
Date: Tue, 20 Aug 2013 04:04:16 +0200
Message-Id: <1376964271-22715-3-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most DT ARM machs require common clock providers initialized before timers.
Currently, arch/arm machs use .init_time to call clk_of_init right before
clocksource_of_init. This prevents to remove that hook and use the default
hook instead. clk_of_init now checks for multiple calls to it, so add
the call to ARM arch time_init by default.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Mike Turquette <mturquette@linaro.org> 
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org 
Cc: linux-kernel@vger.kernel.org 
---
 arch/arm/kernel/time.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index 98aee32..94b51b8 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -22,6 +22,7 @@
 #include <linux/errno.h>
 #include <linux/profile.h>
 #include <linux/timer.h>
+#include <linux/clk-provider.h>
 #include <linux/clocksource.h>
 #include <linux/irq.h>
 #include <linux/sched_clock.h>
@@ -116,6 +117,9 @@ int __init register_persistent_clock(clock_access_fn read_boot,
 
 void __init time_init(void)
 {
+	/* initalize common clocks before timers */
+	of_clk_init(NULL);
+
 	if (machine_desc->init_time)
 		machine_desc->init_time();
 	else
-- 
1.7.10.4

