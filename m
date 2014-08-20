Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaHTAq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 20:46:28 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35489 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbaHTAqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 20:46:22 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Russell King <linux@arm.linux.org.uk>, Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v7 09/11] watchdog: s3c2410: add restart handler
Date: Tue, 19 Aug 2014 17:45:36 -0700
Message-Id: <1408495538-27480-10-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408495538-27480-1-git-send-email-linux@roeck-us.net>
References: <1408495538-27480-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Stübner <heiko@sntech.de>

On a lot of Samsung systems the watchdog is responsible for restarting the
system and until now this code was contained in plat-samsung/watchdog-reset.c.

With the introduction of the restart handlers, this code can now move into
driver itself, removing the need for arch-specific code.

Tested on a S3C2442 based GTA02

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v7: Added patch to series.

 drivers/watchdog/s3c2410_wdt.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 7c6ccd0..2955aef 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -41,6 +41,8 @@
 #include <linux/of.h>
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
+#include <linux/reboot.h>
+#include <linux/delay.h>
 
 #define S3C2410_WTCON		0x00
 #define S3C2410_WTDAT		0x04
@@ -128,6 +130,7 @@ struct s3c2410_wdt {
 	unsigned long		wtdat_save;
 	struct watchdog_device	wdt_device;
 	struct notifier_block	freq_transition;
+	struct notifier_block	restart_handler;
 	struct s3c2410_wdt_variant *drv_data;
 	struct regmap *pmureg;
 };
@@ -438,6 +441,31 @@ static inline void s3c2410wdt_cpufreq_deregister(struct s3c2410_wdt *wdt)
 }
 #endif
 
+static int s3c2410wdt_restart(struct notifier_block *this,
+			      unsigned long mode, void *cmd)
+{
+	struct s3c2410_wdt *wdt = container_of(this, struct s3c2410_wdt,
+					       restart_handler);
+	void __iomem *wdt_base = wdt->reg_base;
+
+	/* disable watchdog, to be safe  */
+	writel(0, wdt_base + S3C2410_WTCON);
+
+	/* put initial values into count and data */
+	writel(0x80, wdt_base + S3C2410_WTCNT);
+	writel(0x80, wdt_base + S3C2410_WTDAT);
+
+	/* set the watchdog to go and reset... */
+	writel(S3C2410_WTCON_ENABLE | S3C2410_WTCON_DIV16 |
+		S3C2410_WTCON_RSTEN | S3C2410_WTCON_PRESCALE(0x20),
+		wdt_base + S3C2410_WTCON);
+
+	/* wait for reset to assert... */
+	mdelay(500);
+
+	return NOTIFY_DONE;
+}
+
 static inline unsigned int s3c2410wdt_get_bootstatus(struct s3c2410_wdt *wdt)
 {
 	unsigned int rst_stat;
@@ -592,6 +620,12 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, wdt);
 
+	wdt->restart_handler.notifier_call = s3c2410wdt_restart;
+	wdt->restart_handler.priority = 128;
+	ret = register_restart_handler(&wdt->restart_handler);
+	if (ret)
+		pr_err("cannot register restart handler, %d\n", ret);
+
 	/* print out a statement of readiness */
 
 	wtcon = readl(wdt->reg_base + S3C2410_WTCON);
@@ -621,6 +655,8 @@ static int s3c2410wdt_remove(struct platform_device *dev)
 	int ret;
 	struct s3c2410_wdt *wdt = platform_get_drvdata(dev);
 
+	unregister_restart_handler(&wdt->restart_handler);
+
 	ret = s3c2410wdt_mask_and_disable_reset(wdt, true);
 	if (ret < 0)
 		return ret;
-- 
1.9.1

