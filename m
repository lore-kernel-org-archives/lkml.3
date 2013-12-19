Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab3LSMS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:18:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45159 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669Ab3LSL64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:58:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rob Herring <rob.herring@calxeda.com>, Olof Johansson <olof@lixom.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 151/208] ARM: highbank: handle soft poweroff and reset key events
Date: Thu, 19 Dec 2013 11:54:09 +0000
Message-Id: <1387454106-19326-152-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <rob.herring@calxeda.com>

commit 3843114856728075d0a80e7151197c19fb3a9e08 upstream.

Graceful reboot and poweroff via IPMI commands to the management
processor don't work. Power and reset keys are events from the
management processor which are generated via IPC messages. Passing
the keys to userspace does not work as neither acpid nor a desktop
environment are present.

This adds a notifier handler for the IPC messages so the kernel can
handle the key events directly and IPMI graceful shutdown will work.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-highbank/highbank.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm/mach-highbank/highbank.c b/arch/arm/mach-highbank/highbank.c
index 8881579..d247cf2 100644
--- a/arch/arm/mach-highbank/highbank.c
+++ b/arch/arm/mach-highbank/highbank.c
@@ -17,15 +17,18 @@
 #include <linux/clkdev.h>
 #include <linux/clocksource.h>
 #include <linux/dma-mapping.h>
+#include <linux/input.h>
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/irqchip.h>
 #include <linux/irqdomain.h>
+#include <linux/mailbox.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/of_address.h>
 #include <linux/smp.h>
+#include <linux/reboot.h>
 #include <linux/amba/bus.h>
 #include <linux/clk-provider.h>
 
@@ -158,6 +161,24 @@ static struct notifier_block highbank_platform_nb = {
 	.notifier_call = highbank_platform_notifier,
 };
 
+static int hb_keys_notifier(struct notifier_block *nb, unsigned long event, void *data)
+{
+	u32 key = *(u32 *)data;
+
+	if (event != 0x1000)
+		return 0;
+
+	if (key == KEY_POWER)
+		orderly_poweroff(false);
+	else if (key == 0xffff)
+		ctrl_alt_del();
+
+	return 0;
+}
+static struct notifier_block hb_keys_nb = {
+	.notifier_call = hb_keys_notifier,
+};
+
 static void __init highbank_init(void)
 {
 	pm_power_off = highbank_power_off;
@@ -166,6 +187,8 @@ static void __init highbank_init(void)
 	bus_register_notifier(&platform_bus_type, &highbank_platform_nb);
 	bus_register_notifier(&amba_bustype, &highbank_amba_nb);
 
+	pl320_ipc_register_notifier(&hb_keys_nb);
+
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
-- 
1.8.3.2

