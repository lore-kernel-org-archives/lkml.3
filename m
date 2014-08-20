Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbaHTArh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 20:47:37 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:46869 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaHTAq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 20:46:26 -0400
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
Subject: [PATCH v7 10/11] clk: samsung: register restart handlers for s3c2412 and s3c2443
Date: Tue, 19 Aug 2014 17:45:37 -0700
Message-Id: <1408495538-27480-11-git-send-email-linux@roeck-us.net>
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

S3C2412, S3C2443 and their derivatives contain a special software-reset
register in their system-controller.

Therefore register a restart handler for those.

Tested on a s3c2416-based board, s3c2412 compile-tested.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v7: Added patch to series.

 drivers/clk/samsung/clk-s3c2412.c | 29 +++++++++++++++++++++++++++++
 drivers/clk/samsung/clk-s3c2443.c | 19 +++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/drivers/clk/samsung/clk-s3c2412.c b/drivers/clk/samsung/clk-s3c2412.c
index 34af09f..2ceedaf 100644
--- a/drivers/clk/samsung/clk-s3c2412.c
+++ b/drivers/clk/samsung/clk-s3c2412.c
@@ -14,6 +14,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/syscore_ops.h>
+#include <linux/reboot.h>
 
 #include <dt-bindings/clock/s3c2412.h>
 
@@ -26,6 +27,7 @@
 #define CLKCON		0x0c
 #define CLKDIVN		0x14
 #define CLKSRC		0x1c
+#define SWRST		0x30
 
 /* list of PLLs to be registered */
 enum s3c2412_plls {
@@ -204,6 +206,28 @@ struct samsung_clock_alias s3c2412_aliases[] __initdata = {
 	ALIAS(MSYSCLK, NULL, "fclk"),
 };
 
+static int s3c2412_restart(struct notifier_block *this,
+			   unsigned long mode, void *cmd)
+{
+	/* errata "Watch-dog/Software Reset Problem" specifies that
+	 * this reset must be done with the SYSCLK sourced from
+	 * EXTCLK instead of FOUT to avoid a glitch in the reset
+	 * mechanism.
+	 *
+	 * See the watchdog section of the S3C2412 manual for more
+	 * information on this fix.
+	 */
+
+	__raw_writel(0x00, reg_base + CLKSRC);
+	__raw_writel(0x533C2412, reg_base + SWRST);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block s3c2412_restart_handler = {
+	.notifier_call = s3c2412_restart,
+	.priority = 129,
+};
+
 /*
  * fixed rate clocks generated outside the soc
  * Only necessary until the devicetree-move is complete
@@ -233,6 +257,7 @@ void __init s3c2412_common_clk_init(struct device_node *np, unsigned long xti_f,
 				    unsigned long ext_f, void __iomem *base)
 {
 	struct samsung_clk_provider *ctx;
+	int ret;
 	reg_base = base;
 
 	if (np) {
@@ -267,6 +292,10 @@ void __init s3c2412_common_clk_init(struct device_node *np, unsigned long xti_f,
 	s3c2412_clk_sleep_init();
 
 	samsung_clk_of_add_provider(np, ctx);
+
+	ret = register_restart_handler(&s3c2412_restart_handler);
+	if (ret)
+		pr_warn("cannot register restart handler, %d\n", ret);
 }
 
 static void __init s3c2412_clk_init(struct device_node *np)
diff --git a/drivers/clk/samsung/clk-s3c2443.c b/drivers/clk/samsung/clk-s3c2443.c
index c92f853..0c3c182 100644
--- a/drivers/clk/samsung/clk-s3c2443.c
+++ b/drivers/clk/samsung/clk-s3c2443.c
@@ -14,6 +14,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/syscore_ops.h>
+#include <linux/reboot.h>
 
 #include <dt-bindings/clock/s3c2443.h>
 
@@ -33,6 +34,7 @@
 #define HCLKCON		0x30
 #define PCLKCON		0x34
 #define SCLKCON		0x38
+#define SWRST		0x44
 
 /* the soc types */
 enum supported_socs {
@@ -354,6 +356,18 @@ struct samsung_clock_alias s3c2450_aliases[] __initdata = {
 	ALIAS(PCLK_I2C1, "s3c2410-i2c.1", "i2c"),
 };
 
+static int s3c2443_restart(struct notifier_block *this,
+			   unsigned long mode, void *cmd)
+{
+	__raw_writel(0x533c2443, reg_base + SWRST);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block s3c2443_restart_handler = {
+	.notifier_call = s3c2443_restart,
+	.priority = 129,
+};
+
 /*
  * fixed rate clocks generated outside the soc
  * Only necessary until the devicetree-move is complete
@@ -378,6 +392,7 @@ void __init s3c2443_common_clk_init(struct device_node *np, unsigned long xti_f,
 				    void __iomem *base)
 {
 	struct samsung_clk_provider *ctx;
+	int ret;
 	reg_base = base;
 
 	if (np) {
@@ -447,6 +462,10 @@ void __init s3c2443_common_clk_init(struct device_node *np, unsigned long xti_f,
 	s3c2443_clk_sleep_init();
 
 	samsung_clk_of_add_provider(np, ctx);
+
+	ret = register_restart_handler(&s3c2443_restart_handler);
+	if (ret)
+		pr_warn("cannot register restart handler, %d\n", ret);
 }
 
 static void __init s3c2416_clk_init(struct device_node *np)
-- 
1.9.1

