Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbaBKTHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:07:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbaBKTH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:07:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Brecht Machiels <brecht@mos6581.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 3.12 105/107] rtc-cmos: Add an alarm disable quirk
Date: Tue, 11 Feb 2014 11:06:11 -0800
Message-Id: <20140211184751.191427339@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184748.191276235@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-cmos.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++-
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
@@ -1158,6 +1206,8 @@ static int __init cmos_init(void)
 			platform_driver_registered = true;
 	}
 
+	dmi_check_system(rtc_quirks);
+
 	if (retval == 0)
 		return 0;
 


