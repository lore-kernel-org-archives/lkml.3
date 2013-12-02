Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab3LBUr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:47:26 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:48186 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab3LBUrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 15:47:20 -0500
Message-ID: <529CF1D5.6010406@linaro.org>
Date: Mon, 02 Dec 2013 12:47:17 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Brecht Machiels <brecht@mos6581.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Heinz Wiesinger <HMWiesinger@gmx.at>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] 41c7f74 rtc: Disable the alarm in the hardware (v2)
References: <20131201220343.2285b12ee1c1e54252dc7dd9@mos6581.org>
In-Reply-To: <20131201220343.2285b12ee1c1e54252dc7dd9@mos6581.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2013 01:03 PM, Brecht Machiels wrote:
> Hi,
>
> I recently installed (Arch x86_64) Linux with the 3.12.1 kernel on a Toshiba Satellite L300 laptop. After shutting down Linux, the laptop will spontaneously boot up after about five minutes. This seems to be consistent. There are no options in the BIOS for en/disabling or configuring the RTC wakeup alarm. After 'shudown --halt' and shutting down the laptop manually (pressing the power button for 3 seconds), it will not spontaneously boot up. I understand Linux is configuring the RTC alarm on shutdown? 
>
> After finding some other reports of similar problems, I have built a custom 3.12.1 kernel after reverting commit 41c7f74 (rtc: Disable the alarm in the hardware (v2)) [1]. This seems to solve the problem for me.
>
> Related discussions and bug reports:
> * http://thread.gmane.org/gmane.linux.kernel/1527538
>   refers to: https://bugzilla.novell.com/show_bug.cgi?id=812592
>              https://bugzilla.novell.com/show_bug.cgi?id=805740
> * http://thread.gmane.org/gmane.linux.kernel/1275165/focus=1388471
>   refers to: http://bugs.debian.org/691902
>
> Both LKML threads seem to have died without any action being taken.
>
> Setting the RTC alarm time way in the future, as suggested in [2] didn't work for me.
>
> Output of dmidecode is attached. Please let me know if any other information could be useful.
>
> [1] https://github.com/torvalds/linux/commit/41c7f74
> [2] https://forums.computers.toshiba-europe.com/forums/thread.jspa?messageID=256816

Ok, sorry about this. I've been hoping we'd get some better insight into
what's actually happening on these strange BIOSes where disabling the
irq seems to cause it to scream (powering the system back on when its
shutdown), in the hopes of having a proper workaround. But despite
Borislav's efforts, he didn't seem to be able to root cause the issue.

So sadly at this point I guess having the dmi based quirk is the only
reasonable approach. The downside is it will end up killing alarm
functionality on the hardware.

Let me know if the following functions for you (I think I've added the
quirk properly for your system, but am not sure).

Borislav, could you double check this patch still works on your hardware
as well?

thanks
-john


>From 7dd7346bf06fbc4df626d7fc7e241d80165a40c4 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <bp@alien8.de>
Date: Sat, 20 Jul 2013 19:00:23 +0200
Subject: [PATCH] rtc-cmos: Add an alarm disable quirk

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

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
[Changed variable name for clarity, added extra dmi entry]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/rtc-cmos.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index f148762..a2325bc 100644
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
@@ -377,6 +377,51 @@ static int cmos_set_alarm(struct device *dev, struct rtc_wkalrm *t)
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
@@ -385,6 +430,9 @@ static int cmos_alarm_irq_enable(struct device *dev, unsigned int enabled)
 	if (!is_valid_irq(cmos->irq))
 		return -EINVAL;
 
+	if (alarm_disable_quirk)
+		return 0;
+
 	spin_lock_irqsave(&rtc_lock, flags);
 
 	if (enabled)
@@ -1157,6 +1205,8 @@ static int __init cmos_init(void)
 			platform_driver_registered = true;
 	}
 
+	dmi_check_system(rtc_quirks);
+
 	if (retval == 0)
 		return 0;
 
-- 
1.8.3.2






