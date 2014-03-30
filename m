Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbaCaAWV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:22:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36300 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752937AbaC3XZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:00 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Borislav Petkov" <bp@suse.de>,
        "Borislav Petkov" <bp@alien8.de>,
        "Brecht Machiels" <brecht@mos6581.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Rabin Vincent" <rabin.vincent@stericsson.com>,
        "John Stultz" <john.stultz@linaro.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.364237028@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 013/200] rtc-cmos: Add an alarm disable quirk
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov <bp@alien8.de>

commit d5a1c7e3fc38d9c7d629e1e47f32f863acbdec3d upstream.

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

Cc: Brecht Machiels <brecht@mos6581.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
[jstultz: Changed variable name for clarity, added extra dmi entry]
Tested-by: Brecht Machiels <brecht@mos6581.org>
Tested-by: Borislav Petkov <bp@suse.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/rtc/rtc-cmos.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

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
@@ -377,6 +377,51 @@ static int cmos_set_alarm(struct device
 	return 0;
 }
 
+/*
+ * Do not disable RTC alarm on shutdown - workaround for b0rked BIOSes.
+ */
+static bool alarm_disable_quirk;
+
+static int __init set_alarm_disable_quirk(const struct dmi_system_id *id)
+{
+	alarm_disable_quirk = true;
+	pr_info("rtc-cmos: BIOS has alarm-disable quirk. ");
+	pr_info("RTC alarms disabled\n");
+	return 0;
+}
+
+static const struct dmi_system_id rtc_quirks[] __initconst = {
+	/* https://bugzilla.novell.com/show_bug.cgi?id=805740 */
+	{
+		.callback = set_alarm_disable_quirk,
+		.ident    = "IBM Truman",
+		.matches  = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "4852570"),
+		},
+	},
+	/* https://bugzilla.novell.com/show_bug.cgi?id=812592 */
+	{
+		.callback = set_alarm_disable_quirk,
+		.ident    = "Gigabyte GA-990XA-UD3",
+		.matches  = {
+			DMI_MATCH(DMI_SYS_VENDOR,
+					"Gigabyte Technology Co., Ltd."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "GA-990XA-UD3"),
+		},
+	},
+	/* http://permalink.gmane.org/gmane.linux.kernel/1604474 */
+	{
+		.callback = set_alarm_disable_quirk,
+		.ident    = "Toshiba Satellite L300",
+		.matches  = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Satellite L300"),
+		},
+	},
+	{}
+};
+
 static int cmos_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
@@ -385,6 +430,9 @@ static int cmos_alarm_irq_enable(struct
 	if (!is_valid_irq(cmos->irq))
 		return -EINVAL;
 
+	if (alarm_disable_quirk)
+		return 0;
+
 	spin_lock_irqsave(&rtc_lock, flags);
 
 	if (enabled)
@@ -1166,6 +1214,8 @@ static int __init cmos_init(void)
 			platform_driver_registered = true;
 	}
 
+	dmi_check_system(rtc_quirks);
+
 	if (retval == 0)
 		return 0;
 

