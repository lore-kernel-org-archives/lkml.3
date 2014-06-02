Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbaFBMgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 08:36:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44562 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434AbaFBMgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:36:17 -0400
X-AuditID: cbfee61b-b7fbb6d000001be3-2f-538c6fbf3072
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v2 2/7] ARM: EXYNOS: add support for firmware-assisted c15resume
Date: Mon, 02 Jun 2014 14:35:38 +0200
Message-id: <1401712543-14281-3-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1401712543-14281-1-git-send-email-b.zolnierkie@samsung.com>
References: <1401712543-14281-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jQd39+T3BBre+WlpsnLGe1WLeZ1mL
	3gVX2SzONr1ht3h/6BmzxabH11gtLu+aw2bxufcIo8WM8/uYLM6cvsRqcfJPL6PF+hmvWSw2
	fvVw4PW4c20Pm8fmJfUet/89ZvbYcrWdxaNvyypGj8+b5ALYorhsUlJzMstSi/TtErgyljy6
	yF4wn7fiyYWXrA2MfdxdjJwcEgImEp+3rWeEsMUkLtxbz9bFyMUhJDCdUaLv+l9GCKeLSeLN
	jIlgVWwCVhIT21eB2SICahI9i7eCFTEL7GWWWNq9iR0kISwQIHH8WBOYzSKgKrF+1iQmEJtX
	wENifccCqHWKEt3PJrCB2JwCnhIr7z1kBbGFgGr2vdrFNIGRdwEjwypG0dSC5ILipPRcI73i
	xNzi0rx0veT83E2M4MB8Jr2DcVWDxSFGAQ5GJR7eH+o9wUKsiWXFlbmHGCU4mJVEeJdaAIV4
	UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1DhQSSE8sSc1OTS1ILYLJMnFwSjUwbj1y3ch5j4Yc
	7/3SBfKWkfP5HnFx/eow+Zyf8fCS5Lx9pyet7b9588KLoxt9b7d1CW7yzhA8mt/i+e+tq8o/
	1dv7mqfF8Wr1FEhN1HYz042/POFV2i+TQ2U3bP5N+yR8sfnWhE+V0T7Bs0/vMssoyjustfbi
	Kq56nUYWn9pT62zWzVfysH8hrsRSnJFoqMVcVJwIAJrpZsVIAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

This change is a preparation for adding secure firmware support to
EXYNOS cpuidle driver.

This patch shouldn't cause any functionality changes.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
[bzolnier: splitted out from bigger patch]
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 arch/arm/include/asm/firmware.h | 4 ++++
 arch/arm/mach-exynos/firmware.c | 8 ++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm/include/asm/firmware.h b/arch/arm/include/asm/firmware.h
index c72ec47..70883c7 100644
--- a/arch/arm/include/asm/firmware.h
+++ b/arch/arm/include/asm/firmware.h
@@ -41,6 +41,10 @@ struct firmware_ops {
 	 * Initializes L2 cache
 	 */
 	int (*l2x0_init)(void);
+	/*
+	 * Restores coprocessor 15 registers
+	 */
+	int (*c15resume)(u32 *regs);
 };
 
 /* Global pointer for current firmware_ops structure, can't be NULL. */
diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index eb91d23..195b65c 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -64,10 +64,18 @@ static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
 	return 0;
 }
 
+static int exynos_c15resume(u32 *regs)
+{
+	exynos_smc(SMC_CMD_C15RESUME, regs[0], regs[1], 0);
+
+	return 0;
+}
+
 static const struct firmware_ops exynos_firmware_ops = {
 	.do_idle		= exynos_do_idle,
 	.set_cpu_boot_addr	= exynos_set_cpu_boot_addr,
 	.cpu_boot		= exynos_cpu_boot,
+	.c15resume	= exynos_c15resume,
 };
 
 void __init exynos_firmware_init(void)
-- 
1.8.2.3

