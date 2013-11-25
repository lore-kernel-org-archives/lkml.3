Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab3KYW4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 17:56:08 -0500
Received: from mail-vb0-f74.google.com ([209.85.212.74]:61575 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab3KYW4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 17:56:05 -0500
From: Doug Anderson <dianders@chromium.org>
To: Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>
Cc: Leela Krishna Amudala <l.krishna@samsung.com>,
        Olof Johansson <olof@lixom.net>, Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] watchdog: s3c2410_wdt: Only register for cpufreq on CPU_FREQ_S3C24XX
Date: Mon, 25 Nov 2013 14:55:37 -0800
Message-Id: <1385420137-32725-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On modern SoCs the watchdog timer is parented on a clock that doesn't
change every time we have a cpufreq change.  That means we don't need
to constantly adjust the watchdog timer, so avoid registering for and
dealing with cpufreq transitions unless we've actually got
CPU_FREQ_S3C24XX defined.

Note that this is more than just an optimization.  The s3c2410
watchdog driver actually pats the watchdog on every CPU frequency
change.  On modern systems these happen many times per second (even in
a system where "nothing" is happening).  That effectively makes any
userspace watchdog program useless (the watchdog is constantly patted
by the kernel).  If we need CPU_FREQ_S3C24XX defined on a
multiplatform kernel we'll need to make sure that kernel supports
common clock and change this to user common clock framework.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/watchdog/s3c2410_wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 7d8fd04..4980f84 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -264,7 +264,7 @@ static irqreturn_t s3c2410wdt_irq(int irqno, void *param)
 	return IRQ_HANDLED;
 }
 
-#ifdef CONFIG_CPU_FREQ
+#ifdef CONFIG_CPU_FREQ_S3C24XX
 
 static int s3c2410wdt_cpufreq_transition(struct notifier_block *nb,
 					  unsigned long val, void *data)
-- 
1.8.4.1

