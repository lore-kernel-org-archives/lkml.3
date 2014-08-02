Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbaHBUNk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 16:13:40 -0400
Received: from gloria.sntech.de ([95.129.55.99]:42189 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243AbaHBUNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 16:13:38 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5.1 9/7] watchdog: s3c2410: add restart handler
Date: Sat, 02 Aug 2014 21:51:42 +0200
Message-ID: <1701800.eiHDUvPYI3@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <53D9010B.7070700@roeck-us.net>
References: <1405668856-13738-1-git-send-email-linux@roeck-us.net> <53D8FCEA.9020506@roeck-us.net> <53D9010B.7070700@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a lot of Samsung systems the watchdog is responsible for restarting the
system and until now this code was contained in plat-samsung/watchdog-reset.c .

With the introduction of the restart handlers, this code can now move into
driver itself, removing the need for arch-specific code.

Tested on a S3C2442 based GTA02
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
[Guenter Roeck: Update to latest API; do not require static context variable]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Heiko Stuebner <heiko@sntech.de>
---
changes since v5:
- reintroduce the mdelay(500) from the platform code, to make sure the
  watchdog has time to assert, as suggested by Tomasz Figa

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
2.0.1


