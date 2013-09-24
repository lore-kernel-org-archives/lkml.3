Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab3IXIIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:08:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44908 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab3IXIIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:08:51 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-39-52414891beb6
From: Lukasz Majewski <l.majewski@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 3/6] thermal: exynos: Provide initial setting for TMU's test
 MUX address at Exynos4412
Date: Tue, 24 Sep 2013 10:08:19 +0200
Message-id: <1380010102-25817-4-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t9jAd2JHo5BBltOGVs0XA2x2DhjPavF
	/CPnWC3W7P/JZNF59gmzxZtH3BZvHm5mtLi8aw6bxefeI4wWM87vY7K43biCzaJ/YS+TxZOH
	fWwW62e8ZnHg81i85yWTx7ppb5k9+rasYvR4tLiF0eP4je1MHp83yQWwRXHZpKTmZJalFunb
	JXBlNN+ew1gwlb9i7p8zLA2M33i6GDk5JARMJNbvmcsCYYtJXLi3nq2LkYtDSGARo0T75E52
	CKeLSaL52AxGkCo2AT2Jz3efMoEkRASaGCV+HPnGDJJgFjjGLPFllQiILSyQIXFj3xOwOIuA
	qsSbhdPBbF4BN4n/h1axQ6yTl3h6v48NxOYUcJdofzoFbIEQUM3bR1tZJjDyLmBkWMUomlqQ
	XFCclJ5rqFecmFtcmpeul5yfu4kRHKTPpHYwrmywOMQowMGoxMO7w9shSIg1say4MvcQowQH
	s5II7w1bxyAh3pTEyqrUovz4otKc1OJDjNIcLErivAdarQOFBNITS1KzU1MLUotgskwcnFIN
	jKL+xVOmGejfConxU3+VcaD426b/k66/Ct2fxd9wuX7NpPw1Rw0SngUsqhE/GqjTtejQ7l4H
	lod1hXk8CTv1mBWbz3/X69ThyP/jXpPc67LAprv0c27jtJlfDBqmLzDYKbVdusJXbcu6LRcq
	joTqrTP6eVbfYKFVm0zPJYk5yneSZzHKnfexUmIpzkg01GIuKk4EACEv3cZOAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit d0a0ce3e77c795258d47f9163e92d5031d0c5221 ("thermal: exynos: Add
missing definations and code cleanup") has removed setting of test MUX address
value at TMU configuration setting.

This field is not present on Exynos4210 and Exynos5 SoCs. However on Exynos4412
SoC it is required to set this field after reset because without it TMU shows
maximal available temperature, which causes immediate platform shutdown.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      |    3 +++
 drivers/thermal/samsung/exynos_tmu_data.h |    4 ++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index a858cc4..21b89e4 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -317,6 +317,9 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 
 	con = readl(data->base + reg->tmu_ctrl);
 
+	if (pdata->type == SOC_ARCH_EXYNOS4412)
+		con |= (EXYNOS4412_MUX_ADDR_VALUE << EXYNOS4412_MUX_ADDR_SHIFT);
+
 	if (pdata->reference_voltage) {
 		con &= ~(reg->buf_vref_sel_mask << reg->buf_vref_sel_shift);
 		con |= pdata->reference_voltage << reg->buf_vref_sel_shift;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index b130b1e..a1ea19d 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -95,6 +95,10 @@
 
 #define EXYNOS_MAX_TRIGGER_PER_REG	4
 
+/* Exynos4412 specific */
+#define EXYNOS4412_MUX_ADDR_VALUE          6
+#define EXYNOS4412_MUX_ADDR_SHIFT          20
+
 /*exynos5440 specific registers*/
 #define EXYNOS5440_TMU_S0_7_TRIM		0x000
 #define EXYNOS5440_TMU_S0_7_CTRL		0x020
-- 
1.7.10.4

