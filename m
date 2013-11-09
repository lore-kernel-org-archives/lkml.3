Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab3KIRvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 12:51:17 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:59747 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab3KIRvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 12:51:15 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>, Fenghua Yu <fenghua.yu@intel.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 1/3] hwmon: (coretemp) Use PCI host bridge ID to identify CPU if necessary
Date: Sat,  9 Nov 2013 09:51:07 -0800
Message-Id: <1384019469-18666-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atom S12x0 CPUs are identified by the CPU host bridge ID. Add an override
table based on PCI IDs as well as code to detect it.

PCI access functions can now be called with PCI disabled, so unlike previous
attempts to use PCI IDs, the code no longer depends on it. If PCI is disabled,
the CPU will not be identified correctly. Since it is unlikely that anything
will work in this case, this is an acceptable limitation.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/coretemp.c |   33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 78be661..5c8ab25 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -36,6 +36,7 @@
 #include <linux/cpu.h>
 #include <linux/smp.h>
 #include <linux/moduleparam.h>
+#include <linux/pci.h>
 #include <asm/msr.h>
 #include <asm/processor.h>
 #include <asm/cpu_device_id.h>
@@ -190,6 +191,17 @@ static ssize_t show_temp(struct device *dev,
 	return tdata->valid ? sprintf(buf, "%d\n", tdata->temp) : -EAGAIN;
 }
 
+struct tjmax_pci {
+	unsigned int device;
+	int tjmax;
+};
+
+static const struct tjmax_pci tjmax_pci_table[] __cpuinitconst = {
+	{ 0x0c72, 102000 },	/* Atom S1240 (Centerton) */
+	{ 0x0c73, 95000 },	/* Atom S1220 (Centerton) */
+	{ 0x0c75, 95000 },	/* Atom S1260 (Centerton) */
+};
+
 struct tjmax {
 	char const *id;
 	int tjmax;
@@ -222,8 +234,11 @@ static const struct tjmax_model tjmax_model_table[] = {
 				 * is undetectable by software
 				 */
 	{ 0x27, ANY, 90000 },	/* Atom Medfield (Z2460) */
-	{ 0x35, ANY, 90000 },	/* Atom Clover Trail/Cloverview (Z2760) */
-	{ 0x36, ANY, 100000 },	/* Atom Cedar Trail/Cedarview (N2xxx, D2xxx) */
+	{ 0x35, ANY, 90000 },	/* Atom Clover Trail/Cloverview (Z27x0) */
+	{ 0x36, ANY, 100000 },	/* Atom Cedar Trail/Cedarview (N2xxx, D2xxx)
+				 * Also matches S12x0 (stepping 9), covered by
+				 * PCI table
+				 */
 };
 
 static int adjust_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *dev)
@@ -236,8 +251,20 @@ static int adjust_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *dev)
 	int err;
 	u32 eax, edx;
 	int i;
+	struct pci_dev *host_bridge = pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));
+
+	/*
+	 * Explicit tjmax table entries override heuristics.
+	 * First try PCI host bridge IDs, followed by model ID strings
+	 * and model/stepping information.
+	 */
+	if (host_bridge && host_bridge->vendor == PCI_VENDOR_ID_INTEL) {
+		for (i = 0; i < ARRAY_SIZE(tjmax_pci_table); i++) {
+			if (host_bridge->device == tjmax_pci_table[i].device)
+				return tjmax_pci_table[i].tjmax;
+		}
+	}
 
-	/* explicit tjmax table entries override heuristics */
 	for (i = 0; i < ARRAY_SIZE(tjmax_table); i++) {
 		if (strstr(c->x86_model_id, tjmax_table[i].id))
 			return tjmax_table[i].tjmax;
-- 
1.7.9.7

