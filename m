Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab3GTRAe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 13:00:34 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44970 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442Ab3GTRAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 13:00:32 -0400
Date: Sat, 20 Jul 2013 19:00:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: [PATCH -v2] RTC: Add an alarm disable quirk
Message-ID: <20130720170023.GB13731@pd.tnic>
References: <1374162294-29726-1-git-send-email-bp@alien8.de>
 <51E8194E.1030704@linaro.org>
 <20130718225349.GD15992@pd.tnic>
 <20130719142628.GC19581@pd.tnic>
 <20130719151321.GD19581@pd.tnic>
 <20130719213458.GF19581@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130719213458.GF19581@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

41c7f7424259f ("rtc: Disable the alarm in the hardware (v2)") added the
functionality to disable the RTC wake alarm when shutting down the box.

However, there are at least two b0rked BIOSes we know about:

https://bugzilla.novell.com/show_bug.cgi?id=812592
https://bugzilla.novell.com/show_bug.cgi?id=805740

where, when wakeup alarm is enabled in the BIOS, the machine reboots
automatically right after shutdown, regardless of what wakeup time is
programmed.

Bisecting the issue lead to this patch so disable its functionality with
a DMI quirk only for those boxes.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Rabin Vincent <rabin.vincent@stericsson.com>
---
 drivers/rtc/rtc-cmos.c | 40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index be06d7150de5..906b45c644e1 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -34,11 +34,11 @@
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
 #include <linux/platform_device.h>
-#include <linux/mod_devicetable.h>
 #include <linux/log2.h>
 #include <linux/pm.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/dmi.h>
 
 /* this is for "generic access to PC-style RTC" using CMOS_READ/CMOS_WRITE */
 #include <asm-generic/rtc.h>
@@ -377,6 +377,39 @@ static int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 	return 0;
 }
 
+/*
+ * Do not disable RTC alarm on shutdown - workaround for b0rked BIOSes.
+ */
+static bool disable_alarm = true;
+
+static int __init clear_disable_alarm(const struct dmi_system_id *id)
+{
+	disable_alarm = false;
+	return 0;
+}
+
+static const struct dmi_system_id rtc_quirks[] __initconst = {
+	/* https://bugzilla.novell.com/show_bug.cgi?id=805740 */
+	{
+		.callback = clear_disable_alarm,
+		.ident    = "IBM Truman",
+		.matches  = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "4852570"),
+		},
+	},
+	/* https://bugzilla.novell.com/show_bug.cgi?id=812592 */
+	{
+		.callback = clear_disable_alarm,
+		.ident    = "Gigabyte GA-990XA-UD3",
+		.matches  = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Gigabyte Technology Co., Ltd."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "GA-990XA-UD3"),
+		},
+	},
+	{}
+};
+
 static int cmos_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
@@ -385,6 +418,9 @@ static int cmos_alarm_irq_enable(struct device *dev, unsigned int enabled)
 	if (!is_valid_irq(cmos->irq))
 		return -EINVAL;
 
+	if (!disable_alarm)
+		return 0;
+
 	spin_lock_irqsave(&rtc_lock, flags);
 
 	if (enabled)
@@ -1172,6 +1208,8 @@ static int __init cmos_init(void)
 			platform_driver_registered = true;
 	}
 
+	dmi_check_system(rtc_quirks);
+
 	if (retval == 0)
 		return 0;
 
-- 
1.8.3

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
