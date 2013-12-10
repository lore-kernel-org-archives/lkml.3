Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab3LJJKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:10:33 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49282 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab3LJJKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:10:23 -0500
X-AuditID: cbfec7f5-b7fd16d000007299-9c-52a6da7c8233
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Jiri Kosina <trivial@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 2/2] regulator: s5m8767: Fix driver probe fail on BUCK7/8
 regulators
Date: Tue, 10 Dec 2013 10:09:43 +0100
Message-id: <1386666583-3280-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1386666583-3280-1-git-send-email-k.kozlowski@samsung.com>
References: <1386666583-3280-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e/4Vd2aW8uCDN4c0baY+vAJm8XrF4YW
	Z5vesFvc/3qU0eLblQ4mi02Pr7FaXN41h81i7ZG77Banu1ktLq74wmTxfv9lJgduj52z7rJ7
	bFrVyeZx59oeNo95JwM9Ni+p9+jbsorR4/MmuQD2KC6blNSczLLUIn27BK6MTxOnsxW85q2Y
	92YPUwPjee4uRg4OCQETiYZG6S5GTiBTTOLCvfVsXYxcHEICSxklms/dZgdJCAn0MUnMbC8E
	sdkEjCU2L18CViQisIBJ4ti7i6wgDrNAL6PEg3e/GEGqhAXCJH4tbmQH2cAioCpx4okXSJhX
	wE1i4qZ2ZojFChJzJtmAhDkF3CVebO9mhdjlJvHsaA/7BEbeBYwMqxhFU0uTC4qT0nON9IoT
	c4tL89L1kvNzNzFCwvDrDsalx6wOMQpwMCrx8Er8WxokxJpYVlyZe4hRgoNZSYR39cllQUK8
	KYmVValF+fFFpTmpxYcYmTg4pRoYVx63vyr0v+NBq3PIApYPxszNrMu/Sl96kTLRwJinf57w
	i7fPZ9e/2CFnf7puknenu2/B2ujcuwW8vfo+XgUL81Z4bjD/aBzg8KqD/+sdvrUbm35qOG+d
	r7XIZnbWa9uIPb4mCreniEimvGsQrVPc9Xz9IbatvRciDmROllj+SOnZF7sNT7wFlViKMxIN
	tZiLihMBUuicbSECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BUCK7 and BUCK8 were not supported by s5m8767 driver. If they were
configured in DTS then the driver probing would fail with EINVAL:
[    0.288474] VCC_SUB_1.35V: failed to apply 1350000uV constraint
[    0.288671] s5m8767-pmic s5m8767-pmic: regulator init failed for 35
[    0.294931] s5m8767-pmic: probe of s5m8767-pmic failed with error -22

This patch adds support for BUCK7 and BUCK8 regulators using standard
regmap get/set voltage sel functions.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/regulator/s5m8767.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 58eb7a6c45e6..397917611ecd 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -120,8 +120,8 @@ static const struct sec_voltage_desc *reg_voltage_map[] = {
 	[S5M8767_BUCK4] = &buck_voltage_val2,
 	[S5M8767_BUCK5] = &buck_voltage_val1,
 	[S5M8767_BUCK6] = &buck_voltage_val1,
-	[S5M8767_BUCK7] = NULL,
-	[S5M8767_BUCK8] = NULL,
+	[S5M8767_BUCK7] = &buck_voltage_val3,
+	[S5M8767_BUCK8] = &buck_voltage_val3,
 	[S5M8767_BUCK9] = &buck_voltage_val3,
 };
 
@@ -418,9 +418,12 @@ static struct regulator_ops s5m8767_ops = {
 };
 
 static struct regulator_ops s5m8767_buck78_ops = {
+	.list_voltage		= regulator_list_voltage_linear,
 	.is_enabled		= s5m8767_reg_is_enabled,
 	.enable			= s5m8767_reg_enable,
 	.disable		= s5m8767_reg_disable,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 };
 
 #define s5m8767_regulator_desc(_name) {		\
-- 
1.7.9.5

