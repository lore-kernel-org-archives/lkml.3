Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbaDOSQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:16:19 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:52218 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaDOSQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:16:13 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Kevin Hilman <khilman@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Chao Xie <xiechao.mail@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] ARM: pj4: enable iWMMXt only if CONFIG_IWMMXT is set
Date: Tue, 15 Apr 2014 20:16:00 +0200
Message-Id: <1397585763-23482-3-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1397585763-23482-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <20140414151236.75f8816d@skate>
 <1397585763-23482-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes PJ4 coprocessor init to only expose iWMMXt capabilities,
if the corresponding kernel support for iWMMXt is enabled.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Chao Xie <xiechao.mail@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/kernel/pj4-cp0.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/pj4-cp0.c b/arch/arm/kernel/pj4-cp0.c
index fc7208636284..12352cd30ab2 100644
--- a/arch/arm/kernel/pj4-cp0.c
+++ b/arch/arm/kernel/pj4-cp0.c
@@ -45,7 +45,7 @@ static int iwmmxt_do(struct notifier_block *self, unsigned long cmd, void *t)
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block iwmmxt_notifier_block = {
+static struct notifier_block __maybe_unused iwmmxt_notifier_block = {
 	.notifier_call	= iwmmxt_do,
 };
 
@@ -79,17 +79,21 @@ static void __init pj4_cp_access_write(u32 value)
  */
 static int __init pj4_cp0_init(void)
 {
-	u32 cp_access;
+	u32 __maybe_unused cp_access;
 
 	if (!cpu_is_pj4())
 		return 0;
 
+#ifndef CONFIG_IWMMXT
+	pr_info("PJ4 iWMMXt coprocessor detected, but kernel support is missing.\n");
+#else
 	cp_access = pj4_cp_access_read() & ~0xf;
 	pj4_cp_access_write(cp_access);
 
 	printk(KERN_INFO "PJ4 iWMMXt coprocessor enabled.\n");
 	elf_hwcap |= HWCAP_IWMMXT;
 	thread_register_notifier(&iwmmxt_notifier_block);
+#endif
 
 	return 0;
 }
-- 
1.9.1

