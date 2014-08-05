Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbaHENev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 09:34:51 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64297 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551AbaHENes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 09:34:48 -0400
X-AuditID: cbfee61a-f79e46d00000134f-98-53e0dd76680d
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
Subject: [PATCH v5 2/5] ARM: EXYNOS: add AFTR mode support to firmware do_idle
 method
Date: Tue, 05 Aug 2014 15:34:23 +0200
Message-id: <1407245666-20016-3-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1407245666-20016-1-git-send-email-b.zolnierkie@samsung.com>
References: <1407245666-20016-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jAd2yuw+CDfZ/sbHYOGM9q8W8z7IW
	vQuuslmcbXrDbvH+0DNmi02Pr7FaXN41h83ic+8RRosZ5/cxWZw5fYnV4uSfXkaL9TNes1hs
	/OrhwOtx59oeNo/NS+o9bv97zOyx5Wo7i0ffllWMHp83yQWwRXHZpKTmZJalFunbJXBltKzd
	z1awR7DibtsdxgbGs3xdjJwcEgImEs1d3cwQtpjEhXvr2boYuTiEBBYxSpzY28MO4XQxSXw7
	s54RpIpNwEpiYvsqMFtEQE2iZ/FWRpAiZoG9zBJLuzexgySEBcIl/vTvZgWxWQRUJc48/Qu2
	glfAQ+LpjQ1MEOsUJbqfTWADsTkFPCUarz0DqxECqtl8ZTfTBEbeBYwMqxhFUwuSC4qT0nMN
	9YoTc4tL89L1kvNzNzGCA/OZ1A7GlQ0WhxgFOBiVeHgF1O4HC7EmlhVX5h5ilOBgVhLhZb/9
	IFiINyWxsiq1KD++qDQntfgQozQHi5I474FW60AhgfTEktTs1NSC1CKYLBMHp1QD48Yk3Sx5
	NsePTfkqPxjNtl1KeXO5Ybq0y84H3BJfXzY3LPV0zz/8dr2bioXSoe9MK9qfdJXGZH1Kk+Nf
	3+P3cM1CQ4fG9P2fp7a4TZnrHsA+a2LIGgXx6xFxf4OzpOY4rtA5/tXNt1rgY50U49Nlh28q
	z07g4cg7Zic/LVK70rPu15GEVN90JZbijERDLeai4kQAx4IkN0gCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some platforms (i.e. EXYNOS ones) more than one idle mode is
available and we need to distinguish them in firmware do_idle method.

Add mode parameter to do_idle firmware method and AFTR mode support
to EXYNOS do_idle implementation.

This change is a preparation for adding secure firmware support to
EXYNOS cpuidle driver.

This patch shouldn't cause any functionality changes (please note
that do_idle firmware method is unused currently).

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/include/asm/firmware.h |  2 +-
 arch/arm/mach-exynos/common.h   |  5 +++++
 arch/arm/mach-exynos/firmware.c | 10 ++++++++--
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/firmware.h b/arch/arm/include/asm/firmware.h
index 5904f59..89aefe1 100644
--- a/arch/arm/include/asm/firmware.h
+++ b/arch/arm/include/asm/firmware.h
@@ -28,7 +28,7 @@ struct firmware_ops {
 	/*
 	 * Enters CPU idle mode
 	 */
-	int (*do_idle)(void);
+	int (*do_idle)(unsigned long mode);
 	/*
 	 * Sets boot address of specified physical CPU
 	 */
diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index c218200..2d830df 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -119,6 +119,11 @@ extern void __iomem *sysram_base_addr;
 extern void __iomem *pmu_base_addr;
 void exynos_sysram_init(void);
 
+enum {
+	FW_DO_IDLE_SLEEP,
+	FW_DO_IDLE_AFTR,
+};
+
 void exynos_firmware_init(void);
 
 extern u32 exynos_get_eint_wake_mask(void);
diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index f5e626d..e57b7c3 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -28,9 +28,15 @@
 #define EXYNOS_BOOT_ADDR	0x8
 #define EXYNOS_BOOT_FLAG	0xc
 
-static int exynos_do_idle(void)
+static int exynos_do_idle(unsigned long mode)
 {
-	exynos_smc(SMC_CMD_SLEEP, 0, 0, 0);
+	switch (mode) {
+	case FW_DO_IDLE_AFTR:
+		exynos_smc(SMC_CMD_CPU0AFTR, 0, 0, 0);
+		break;
+	case FW_DO_IDLE_SLEEP:
+		exynos_smc(SMC_CMD_SLEEP, 0, 0, 0);
+	}
 	return 0;
 }
 
-- 
1.8.2.3

