Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbaLWKs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:48:58 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61112 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbaLWKsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:48:54 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-96-54994890befe
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linus.walleij@linaro.org, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com, Mark Rutland <mark.rutland@arm.com>, nm@ti.com,
        khilman@linaro.org
Subject: [PATCH v10 6/8] ARM: EXYNOS: Add .write_sec outer cache callback for
 L2C-310
Date: Tue, 23 Dec 2014 11:48:34 +0100
Message-id: <1419331716-8972-7-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1419331716-8972-1-git-send-email-m.szyprowski@samsung.com>
References: <1419331716-8972-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xa7oTPGaGGDw/L2Pxd9IxdotH8x8z
	W/QuuMpm8fXwCkaLs01v2C22d85gt5jyZzmTxabH11gtLu+aw2Yxe0k/i8WM8/uYLG5f5rU4
	t30Li8XaI3fZLZZev8hk8ebHWSaLU9c/s1ms2vWH0WL/FS8HYY8189YwerQ097B5/P41idHj
	29dJLB6X+3qZPBZ9z/LYOesuu8eda3vYPDYvqfe4cqKJ1aNvyypGj+M3tjN5fN4kF8AbxWWT
	kpqTWZZapG+XwJXx7MB+5oLd4hUfvr1kbGBcJ9zFyMkhIWAicafvMguELSZx4d56ti5GLg4h
	gaWMEjumL2WHcPqYJJq+tTOCVLEJGEp0ve1iA7FFBNwk/q07BNbBLDCNRWLTkfPMXYwcHMIC
	4RLXHjCB1LAIqEpMP/sIzOYVcJdYenEjI8Q2OYn/L1eAxTkFPCROLtoMZgsB1Wx7epBlAiPv
	AkaGVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxghcfFlB+PiY1aHGAU4GJV4eE++nxEixJpY
	VlyZe4hRgoNZSYT3pfjMECHelMTKqtSi/Pii0pzU4kOMTBycUg2MG6RiGLgWWfJp6SzeZsi1
	ua3r9ultOYESHrbTLL5KbLcVlj8xv6moV7aEI72pf8rvc8tn75/7yTHk++FvNn0apqKnHmce
	PTvLdGWO7SXTylfHl7bw54dn7Vlw4Dbjjmf5jb4TWKee7Pv6b9PTBxPc4tMN+f1X7DvKWaux
	vk3kkGPhAg+J62EpSizFGYmGWsxFxYkALqBI32kCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

Exynos4 SoCs equipped with an L2C-310 cache controller and running under
secure firmware require certain registers of aforementioned IP to be
accessed only from secure mode. This means that SMC calls are required
for certain register writes. To handle this, an implementation of
.write_sec and .configure callbacks is provided by this patch.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
[added comment and reworked unconditional call to SMC_CMD_L2X0INVALL]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
---
 arch/arm/mach-exynos/firmware.c | 50 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index 766f57d2f029..dc5ae53aa317 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -17,6 +17,7 @@
 #include <asm/cacheflush.h>
 #include <asm/cputype.h>
 #include <asm/firmware.h>
+#include <asm/hardware/cache-l2x0.h>
 #include <asm/suspend.h>
 
 #include <mach/map.h>
@@ -136,6 +137,43 @@ static const struct firmware_ops exynos_firmware_ops = {
 	.resume			= IS_ENABLED(CONFIG_EXYNOS_CPU_SUSPEND) ? exynos_resume : NULL,
 };
 
+static void exynos_l2_write_sec(unsigned long val, unsigned reg)
+{
+	static int l2cache_enabled;
+
+	switch (reg) {
+	case L2X0_CTRL:
+		if (val & L2X0_CTRL_EN) {
+			/*
+			 * Before the cache can be enabled, due to firmware
+			 * design, SMC_CMD_L2X0INVALL must be called.
+			 */
+			if (!l2cache_enabled) {
+				exynos_smc(SMC_CMD_L2X0INVALL, 0, 0, 0);
+				l2cache_enabled = 1;
+			}
+		} else {
+			l2cache_enabled = 0;
+		}
+		exynos_smc(SMC_CMD_L2X0CTRL, val, 0, 0);
+		break;
+
+	case L2X0_DEBUG_CTRL:
+		exynos_smc(SMC_CMD_L2X0DEBUG, val, 0, 0);
+		break;
+
+	default:
+		WARN_ONCE(1, "%s: ignoring write to reg 0x%x\n", __func__, reg);
+	}
+}
+
+static void exynos_l2_configure(const struct l2x0_regs *regs)
+{
+	exynos_smc(SMC_CMD_L2X0SETUP1, regs->tag_latency, regs->data_latency,
+			regs->prefetch_ctrl);
+	exynos_smc(SMC_CMD_L2X0SETUP2, regs->pwr_ctrl, regs->aux_ctrl, 0);
+}
+
 void __init exynos_firmware_init(void)
 {
 	struct device_node *nd;
@@ -155,4 +193,16 @@ void __init exynos_firmware_init(void)
 	pr_info("Running under secure firmware.\n");
 
 	register_firmware_ops(&exynos_firmware_ops);
+
+	/*
+	 * Exynos 4 SoCs (based on Cortex A9 and equipped with L2C-310),
+	 * running under secure firmware, require certain registers of L2
+	 * cache controller to be written in secure mode. Here .write_sec
+	 * callback is provided to perform necessary SMC calls.
+	 */
+	if (IS_ENABLED(CONFIG_CACHE_L2X0)
+	    && read_cpuid_part() == ARM_CPU_PART_CORTEX_A9) {
+		outer_cache.write_sec = exynos_l2_write_sec;
+		outer_cache.configure = exynos_l2_configure;
+	}
 }
-- 
1.9.2

