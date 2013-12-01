Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab3LAG1q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 01:27:46 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:45414 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3LAG1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 01:27:45 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 03/11] rtc: support DS1302 RTC on ICP DAS LP-8x4x
Date: Sun,  1 Dec 2013 10:26:16 +0400
Message-Id: <1385879185-22455-4-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
---
 arch/arm/configs/lp8x4x_defconfig       |  1 +
 arch/arm/mach-pxa/include/mach/lp8x4x.h |  1 +
 arch/arm/mach-pxa/lp8x4x.c              |  8 ++++
 drivers/rtc/Kconfig                     |  2 +-
 drivers/rtc/rtc-ds1302.c                | 85 +++++++++++++++++++++++++++++++++
 5 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/arch/arm/configs/lp8x4x_defconfig b/arch/arm/configs/lp8x4x_defconfig
index 5cd6d38..27831e4 100644
--- a/arch/arm/configs/lp8x4x_defconfig
+++ b/arch/arm/configs/lp8x4x_defconfig
@@ -1745,6 +1745,7 @@ CONFIG_RTC_INTF_DEV=y
 #
 # CONFIG_RTC_DRV_CMOS is not set
 # CONFIG_RTC_DRV_DS1286 is not set
+CONFIG_RTC_DRV_DS1302=y
 # CONFIG_RTC_DRV_DS1511 is not set
 # CONFIG_RTC_DRV_DS1553 is not set
 # CONFIG_RTC_DRV_DS1742 is not set
diff --git a/arch/arm/mach-pxa/include/mach/lp8x4x.h b/arch/arm/mach-pxa/include/mach/lp8x4x.h
index 8c501fd..d8a1376 100644
--- a/arch/arm/mach-pxa/include/mach/lp8x4x.h
+++ b/arch/arm/mach-pxa/include/mach/lp8x4x.h
@@ -48,6 +48,7 @@
 #define LP8X4X_CLRHILVINT	LP8X4X_P2V(0x17009016)
 #define LP8X4X_ENFALLINT	LP8X4X_P2V(0x17009018)
 #define LP8X4X_CLRFALLINT	LP8X4X_P2V(0x1700901a)
+#define LP8X4X_RWRTC		LP8X4X_P2V(0x1700901c)
 
 /* board specific IRQs */
 
diff --git a/arch/arm/mach-pxa/lp8x4x.c b/arch/arm/mach-pxa/lp8x4x.c
index 0b77e7a..a31b556 100644
--- a/arch/arm/mach-pxa/lp8x4x.c
+++ b/arch/arm/mach-pxa/lp8x4x.c
@@ -386,11 +386,19 @@ static struct platform_device lp8x4x_dm9000_device[2] = {
 	},
 };
 
+static struct platform_device lp8x4x_ds1302_device[] = {
+	{
+		.name           = "rtc-ds1302",
+		.id             = 0,
+	},
+};
+
 static struct platform_device *lp8x4x_devices[] __initdata = {
 	&lp8x4x_flash_device[0],
 	&lp8x4x_flash_device[1],
 	&lp8x4x_dm9000_device[0],
 	&lp8x4x_dm9000_device[1],
+	&lp8x4x_ds1302_device[0],
 };
 
 static struct pxaohci_platform_data lp8x4x_ohci_platform_data = {
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 0077302..59213c0 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -676,7 +676,7 @@ config RTC_DRV_DS1286
 
 config RTC_DRV_DS1302
 	tristate "Dallas DS1302"
-	depends on SH_SECUREEDGE5410
+	depends on SH_SECUREEDGE5410 || MACH_LP8X4X
 	help
 	  If you say yes here you get support for the Dallas DS1302 RTC chips.
 
diff --git a/drivers/rtc/rtc-ds1302.c b/drivers/rtc/rtc-ds1302.c
index 07e8d79..770587b 100644
--- a/drivers/rtc/rtc-ds1302.c
+++ b/drivers/rtc/rtc-ds1302.c
@@ -86,6 +86,91 @@ static inline int ds1302_rxbit(void)
 	return !!(get_dp() & RTC_IODATA);
 }
 
+#elif defined(CONFIG_MACH_LP8X4X)
+
+#include <linux/sched.h>
+#include <linux/hrtimer.h>
+#include <mach/lp8x4x.h>
+
+#define	RTC_CE		0x01
+#define	RTC_CLK		0x02
+#define	RTC_nWE		0x04
+#define	RTC_IODATA	0x08
+
+static unsigned long ds1302_state;
+
+void nsleep(unsigned long nanosec)
+{
+	ktime_t t = ns_to_ktime(nanosec);
+	long state = current->state;
+
+	__set_current_state(TASK_UNINTERRUPTIBLE);
+	schedule_hrtimeout(&t, HRTIMER_MODE_REL);
+	__set_current_state(state);
+}
+
+static inline int ds1302_hw_init(void)
+{
+	return 0;
+}
+
+static inline void ds1302_reset(void)
+{
+	ds1302_state = 0;
+	iowrite8(ds1302_state, LP8X4X_RWRTC);
+	nsleep(4000);
+}
+
+static inline void ds1302_clock(void)
+{
+	nsleep(1000);
+	ds1302_state |= RTC_CLK;
+	iowrite8(ds1302_state, LP8X4X_RWRTC);
+	nsleep(1000);
+	ds1302_state &= ~RTC_CLK;
+	iowrite8(ds1302_state, LP8X4X_RWRTC);
+}
+
+static inline void ds1302_start(void)
+{
+	ds1302_state &= ~RTC_CLK;
+	ds1302_state |= RTC_CE;
+	iowrite8(ds1302_state, LP8X4X_RWRTC);
+	nsleep(3000);
+}
+
+static inline void ds1302_stop(void)
+{
+	ds1302_state &= ~RTC_CE;
+	iowrite8(ds1302_state, LP8X4X_RWRTC);
+}
+
+static inline void ds1302_set_tx(void)
+{
+	ds1302_state &= ~RTC_nWE;
+	iowrite8(ds1302_state, LP8X4X_RWRTC);
+}
+
+static inline void ds1302_set_rx(void)
+{
+	ds1302_state |= RTC_nWE;
+	iowrite8(ds1302_state, LP8X4X_RWRTC);
+}
+
+static inline void ds1302_txbit(int bit)
+{
+	if (bit)
+		ds1302_state |= RTC_IODATA;
+	else
+		ds1302_state &= ~RTC_IODATA;
+	iowrite8(ds1302_state, LP8X4X_RWRTC);
+}
+
+static inline int ds1302_rxbit(void)
+{
+	return ioread8(LP8X4X_RWRTC) & 0x1;
+}
+
 #else
 #error "Add support for your platform"
 #endif
-- 
1.8.4.2

