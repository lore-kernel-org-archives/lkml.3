Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab3K0TIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 14:08:38 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58434 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757666Ab3K0TI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 14:08:27 -0500
From: Felipe Balbi <balbi@ti.com>
To: <sameo@linux.intel.com>
CC: <lee.jones@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 09/13] mfd: menelaus: pass menelaus_chip pointer to get/set voltage
Date: Wed, 27 Nov 2013 13:06:53 -0600
Message-ID: <1385579217-20127-10-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.4.GIT
In-Reply-To: <1385579217-20127-1-git-send-email-balbi@ti.com>
References: <1385579217-20127-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

those functions are static and can easily receive
a menelaus_chip pointer argument.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/menelaus.c | 50 +++++++++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 23 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index 8672d86..13d1cb0 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -463,10 +463,9 @@ struct menelaus_vtg_value {
 	u16 val;
 };
 
-static int menelaus_set_voltage(const struct menelaus_vtg *vtg, int mV,
-				int vtg_val, int mode)
+static int menelaus_set_voltage(struct menelaus_chip *m,
+		const struct menelaus_vtg *vtg, int mV, int vtg_val, int mode)
 {
-	struct menelaus_chip *m = the_menelaus;
 	struct i2c_client *c = m->client;
 	int val, ret;
 
@@ -498,8 +497,8 @@ out:
 	return ret;
 }
 
-static int menelaus_get_vtg_value(int vtg, const struct menelaus_vtg_value *tbl,
-				  int n)
+static int menelaus_get_vtg_value(struct menelaus_chip *m,
+		int vtg, const struct menelaus_vtg_value *tbl, int n)
 {
 	int i;
 
@@ -546,7 +545,7 @@ int menelaus_set_vcore_sw(unsigned int mV)
 	struct i2c_client *c = m->client;
 	int val, ret;
 
-	val = menelaus_get_vtg_value(mV, vcore_values,
+	val = menelaus_get_vtg_value(m, mV, vcore_values,
 				     ARRAY_SIZE(vcore_values));
 	if (val < 0)
 		return -EINVAL;
@@ -570,11 +569,11 @@ int menelaus_set_vcore_hw(unsigned int roof_mV, unsigned int floor_mV)
 	struct i2c_client *c = m->client;
 	int fval, rval, val, ret;
 
-	rval = menelaus_get_vtg_value(roof_mV, vcore_values,
+	rval = menelaus_get_vtg_value(m, roof_mV, vcore_values,
 				      ARRAY_SIZE(vcore_values));
 	if (rval < 0)
 		return -EINVAL;
-	fval = menelaus_get_vtg_value(floor_mV, vcore_values,
+	fval = menelaus_get_vtg_value(m, floor_mV, vcore_values,
 				      ARRAY_SIZE(vcore_values));
 	if (fval < 0)
 		return -EINVAL;
@@ -619,15 +618,16 @@ static const struct menelaus_vtg_value vmem_values[] = {
 
 int menelaus_set_vmem(unsigned int mV)
 {
+	struct menelaus_chip *m = the_menelaus;
 	int val;
 
 	if (mV == 0)
-		return menelaus_set_voltage(&vmem_vtg, 0, 0, 0);
+		return menelaus_set_voltage(m, &vmem_vtg, 0, 0, 0);
 
-	val = menelaus_get_vtg_value(mV, vmem_values, ARRAY_SIZE(vmem_values));
+	val = menelaus_get_vtg_value(m, mV, vmem_values, ARRAY_SIZE(vmem_values));
 	if (val < 0)
 		return -EINVAL;
-	return menelaus_set_voltage(&vmem_vtg, mV, val, 0x02);
+	return menelaus_set_voltage(m, &vmem_vtg, mV, val, 0x02);
 }
 EXPORT_SYMBOL(menelaus_set_vmem);
 
@@ -648,15 +648,16 @@ static const struct menelaus_vtg_value vio_values[] = {
 
 int menelaus_set_vio(unsigned int mV)
 {
+	struct menelaus_chip *m = the_menelaus;
 	int val;
 
 	if (mV == 0)
-		return menelaus_set_voltage(&vio_vtg, 0, 0, 0);
+		return menelaus_set_voltage(m, &vio_vtg, 0, 0, 0);
 
-	val = menelaus_get_vtg_value(mV, vio_values, ARRAY_SIZE(vio_values));
+	val = menelaus_get_vtg_value(m, mV, vio_values, ARRAY_SIZE(vio_values));
 	if (val < 0)
 		return -EINVAL;
-	return menelaus_set_voltage(&vio_vtg, mV, val, 0x02);
+	return menelaus_set_voltage(m, &vio_vtg, mV, val, 0x02);
 }
 EXPORT_SYMBOL(menelaus_set_vio);
 
@@ -689,6 +690,7 @@ static const struct menelaus_vtg vdcdc3_vtg = {
 
 int menelaus_set_vdcdc(int dcdc, unsigned int mV)
 {
+	struct menelaus_chip *m = the_menelaus;
 	const struct menelaus_vtg *vtg;
 	int val;
 
@@ -700,13 +702,13 @@ int menelaus_set_vdcdc(int dcdc, unsigned int mV)
 		vtg = &vdcdc3_vtg;
 
 	if (mV == 0)
-		return menelaus_set_voltage(vtg, 0, 0, 0);
+		return menelaus_set_voltage(m, vtg, 0, 0, 0);
 
-	val = menelaus_get_vtg_value(mV, vdcdc_values,
+	val = menelaus_get_vtg_value(m, mV, vdcdc_values,
 				     ARRAY_SIZE(vdcdc_values));
 	if (val < 0)
 		return -EINVAL;
-	return menelaus_set_voltage(vtg, mV, val, 0x03);
+	return menelaus_set_voltage(m, vtg, mV, val, 0x03);
 }
 
 static const struct menelaus_vtg_value vmmc_values[] = {
@@ -726,15 +728,16 @@ static const struct menelaus_vtg vmmc_vtg = {
 
 int menelaus_set_vmmc(unsigned int mV)
 {
+	struct menelaus_chip *m = the_menelaus;
 	int val;
 
 	if (mV == 0)
-		return menelaus_set_voltage(&vmmc_vtg, 0, 0, 0);
+		return menelaus_set_voltage(m, &vmmc_vtg, 0, 0, 0);
 
-	val = menelaus_get_vtg_value(mV, vmmc_values, ARRAY_SIZE(vmmc_values));
+	val = menelaus_get_vtg_value(m, mV, vmmc_values, ARRAY_SIZE(vmmc_values));
 	if (val < 0)
 		return -EINVAL;
-	return menelaus_set_voltage(&vmmc_vtg, mV, val, 0x02);
+	return menelaus_set_voltage(m, &vmmc_vtg, mV, val, 0x02);
 }
 EXPORT_SYMBOL(menelaus_set_vmmc);
 
@@ -756,15 +759,16 @@ static const struct menelaus_vtg vaux_vtg = {
 
 int menelaus_set_vaux(unsigned int mV)
 {
+	struct menelaus_chip *m = the_menelaus;
 	int val;
 
 	if (mV == 0)
-		return menelaus_set_voltage(&vaux_vtg, 0, 0, 0);
+		return menelaus_set_voltage(m, &vaux_vtg, 0, 0, 0);
 
-	val = menelaus_get_vtg_value(mV, vaux_values, ARRAY_SIZE(vaux_values));
+	val = menelaus_get_vtg_value(m, mV, vaux_values, ARRAY_SIZE(vaux_values));
 	if (val < 0)
 		return -EINVAL;
-	return menelaus_set_voltage(&vaux_vtg, mV, val, 0x02);
+	return menelaus_set_voltage(m, &vaux_vtg, mV, val, 0x02);
 }
 EXPORT_SYMBOL(menelaus_set_vaux);
 
-- 
1.8.4.GIT

