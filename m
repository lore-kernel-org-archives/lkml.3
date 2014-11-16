Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807AbaKPAVw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 19:21:52 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:44868 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433AbaKPATs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 19:19:48 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, jfraser@broadcom.com, dtor@chromium.org,
        tglx@linutronix.de, jason@lakedaemon.net, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 18/22] MIPS: Create a helper function for DT setup
Date: Sat, 15 Nov 2014 16:17:42 -0800
Message-Id: <1416097066-20452-19-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416097066-20452-1-git-send-email-cernekee@gmail.com>
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of platforms register two buses and call of_platform_populate().
Move this into a common function to reduce duplication.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/include/asm/prom.h |  1 +
 arch/mips/kernel/prom.c      | 18 ++++++++++++++++++
 arch/mips/lantiq/prom.c      | 11 +----------
 arch/mips/ralink/of.c        | 14 ++------------
 4 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/mips/include/asm/prom.h b/arch/mips/include/asm/prom.h
index a9494c0..eaa2627 100644
--- a/arch/mips/include/asm/prom.h
+++ b/arch/mips/include/asm/prom.h
@@ -22,6 +22,7 @@ extern void device_tree_init(void);
 struct boot_param_header;
 
 extern void __dt_setup_arch(void *bph);
+extern int __dt_register_buses(const char *bus0, const char *bus1);
 
 #define dt_setup_arch(sym)						\
 ({									\
diff --git a/arch/mips/kernel/prom.c b/arch/mips/kernel/prom.c
index 5d39bb8..452d435 100644
--- a/arch/mips/kernel/prom.c
+++ b/arch/mips/kernel/prom.c
@@ -16,6 +16,7 @@
 #include <linux/debugfs.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
+#include <linux/of_platform.h>
 
 #include <asm/page.h>
 #include <asm/prom.h>
@@ -54,4 +55,21 @@ void __init __dt_setup_arch(void *bph)
 
 	mips_set_machine_name(of_flat_dt_get_machine_name());
 }
+
+int __init __dt_register_buses(const char *bus0, const char *bus1)
+{
+	static struct of_device_id of_ids[3];
+
+	if (!of_have_populated_dt())
+		panic("device tree not present");
+
+	strlcpy(of_ids[0].compatible, bus0, sizeof(of_ids[0].compatible));
+	strlcpy(of_ids[1].compatible, bus1, sizeof(of_ids[1].compatible));
+
+	if (of_platform_populate(NULL, of_ids, NULL, NULL))
+		panic("failed to populate DT");
+
+	return 0;
+}
+
 #endif
diff --git a/arch/mips/lantiq/prom.c b/arch/mips/lantiq/prom.c
index 7447d32..758970e 100644
--- a/arch/mips/lantiq/prom.c
+++ b/arch/mips/lantiq/prom.c
@@ -97,16 +97,7 @@ void __init prom_init(void)
 
 int __init plat_of_setup(void)
 {
-	static struct of_device_id of_ids[3];
-
-	if (!of_have_populated_dt())
-		panic("device tree not present");
-
-	strlcpy(of_ids[0].compatible, soc_info.compatible,
-		sizeof(of_ids[0].compatible));
-	strncpy(of_ids[1].compatible, "simple-bus",
-		sizeof(of_ids[1].compatible));
-	return of_platform_populate(NULL, of_ids, NULL, NULL);
+	return __dt_register_buses(soc_info.compatible, "simple-bus");
 }
 
 arch_initcall(plat_of_setup);
diff --git a/arch/mips/ralink/of.c b/arch/mips/ralink/of.c
index 7c4598c..f68115f 100644
--- a/arch/mips/ralink/of.c
+++ b/arch/mips/ralink/of.c
@@ -74,19 +74,9 @@ void __init plat_mem_setup(void)
 
 static int __init plat_of_setup(void)
 {
-	static struct of_device_id of_ids[3];
-	int len = sizeof(of_ids[0].compatible);
+	__dt_register_buses(soc_info.compatible, "palmbus");
 
-	if (!of_have_populated_dt())
-		panic("device tree not present");
-
-	strlcpy(of_ids[0].compatible, soc_info.compatible, len);
-	strlcpy(of_ids[1].compatible, "palmbus", len);
-
-	if (of_platform_populate(NULL, of_ids, NULL, NULL))
-		panic("failed to populate DT");
-
-	/* make sure ithat the reset controller is setup early */
+	/* make sure that the reset controller is setup early */
 	ralink_rst_init();
 
 	return 0;
-- 
2.1.1

