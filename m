Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab3LRVky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:40:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab3LRVNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Olof Johansson <olof@lixom.net>
Subject: [PATCH 3.12 009/118] ARM: highbank: handle soft poweroff and reset key events
Date: Wed, 18 Dec 2013 13:10:46 -0800
Message-Id: <20131218211219.729485755@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-highbank/highbank.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/arch/arm/mach-highbank/highbank.c
+++ b/arch/arm/mach-highbank/highbank.c
@@ -17,12 +17,15 @@
 #include <linux/clkdev.h>
 #include <linux/clocksource.h>
 #include <linux/dma-mapping.h>
+#include <linux/input.h>
 #include <linux/io.h>
 #include <linux/irqchip.h>
+#include <linux/mailbox.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/of_address.h>
+#include <linux/reboot.h>
 #include <linux/amba/bus.h>
 #include <linux/clk-provider.h>
 
@@ -153,6 +156,24 @@ static struct notifier_block highbank_pl
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
@@ -161,6 +182,8 @@ static void __init highbank_init(void)
 	bus_register_notifier(&platform_bus_type, &highbank_platform_nb);
 	bus_register_notifier(&amba_bustype, &highbank_amba_nb);
 
+	pl320_ipc_register_notifier(&hb_keys_nb);
+
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 


