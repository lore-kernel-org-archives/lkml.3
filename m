Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab3KLWJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 17:09:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:4632 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756792Ab3KLWJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 17:09:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="434167697"
From: David Cohen <david.a.cohen@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH 3/3] x86: intel-mid: allow sfi_device() to be used by modules
Date: Tue, 12 Nov 2013 14:13:40 -0800
Message-Id: <1384294420-9124-4-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1384294420-9124-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1384294420-9124-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements support for sfi_device() to be called from
driver modules. This is useful to bring SFI support to out-of-tree
modules.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 arch/x86/include/asm/intel-mid.h  | 13 +++++++++
 arch/x86/platform/intel-mid/sfi.c | 59 ++++++++++++++++++++++++++++++---------
 2 files changed, 59 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/intel-mid.h b/arch/x86/include/asm/intel-mid.h
index 971cbb1abab3..92b6dc333197 100644
--- a/arch/x86/include/asm/intel-mid.h
+++ b/arch/x86/include/asm/intel-mid.h
@@ -11,6 +11,7 @@
 #ifndef _ASM_X86_INTEL_MID_H
 #define _ASM_X86_INTEL_MID_H
 
+#include <linux/module.h>
 #include <linux/sfi.h>
 #include <linux/platform_device.h>
 
@@ -21,6 +22,7 @@ extern int __init sfi_parse_mrtc(struct sfi_table_header *table, void *const pri
 extern int __init sfi_parse_mtmr(struct sfi_table_header *table, void *const priv);
 extern int sfi_mrtc_num;
 extern struct sfi_rtc_table_entry sfi_mrtc_array[];
+extern int sfi_parse_one_dev(struct sfi_table_header *table, void *const priv);
 
 /*
  * Here defines the array of devices platform data that IAFW would export
@@ -37,9 +39,20 @@ struct devs_id {
 				struct devs_id *dev);
 };
 
+#ifndef MODULE
 #define sfi_device(i)   \
 	static const struct devs_id *const __intel_mid_sfi_##i##_dev __used \
 	__attribute__((__section__(".x86_intel_mid_dev.init"))) = &i
+#else
+#define sfi_device(i)	\
+	static int __init i##_as_module(void)		\
+	{						\
+		sfi_table_parse(SFI_SIG_DEVS, NULL, NULL, sfi_parse_one_dev, \
+							   (void *const)&i); \
+		return 0;				\
+	}						\
+	module_init(i##_as_module);
+#endif
 
 /*
  * Medfield is the follow-up of Moorestown, it combines two chip solution into
diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
index 2c66024b7067..fb62fad61392 100644
--- a/arch/x86/platform/intel-mid/sfi.c
+++ b/arch/x86/platform/intel-mid/sfi.c
@@ -227,6 +227,7 @@ int get_gpio_by_name(const char *name)
 	}
 	return -EINVAL;
 }
+EXPORT_SYMBOL_GPL(get_gpio_by_name);
 
 void __init intel_scu_device_register(struct platform_device *pdev)
 {
@@ -318,10 +319,10 @@ void intel_scu_devices_destroy(void)
 }
 EXPORT_SYMBOL_GPL(intel_scu_devices_destroy);
 
-static void __init install_irq_resource(struct platform_device *pdev, int irq)
+static void install_irq_resource(struct platform_device *pdev, int irq)
 {
 	/* Single threaded */
-	static struct resource res __initdata = {
+	static struct resource res = {
 		.name = "IRQ",
 		.flags = IORESOURCE_IRQ,
 	};
@@ -329,8 +330,8 @@ static void __init install_irq_resource(struct platform_device *pdev, int irq)
 	platform_device_add_resources(pdev, &res, 1);
 }
 
-static void __init sfi_handle_ipc_dev(struct sfi_device_table_entry *pentry,
-					struct devs_id *dev)
+static void sfi_handle_ipc_dev(struct sfi_device_table_entry *pentry,
+			       struct devs_id *dev)
 {
 	struct platform_device *pdev;
 	void *pdata = NULL;
@@ -353,8 +354,8 @@ static void __init sfi_handle_ipc_dev(struct sfi_device_table_entry *pentry,
 	platform_device_add(pdev);
 }
 
-static void __init sfi_handle_spi_dev(struct sfi_device_table_entry *pentry,
-					struct devs_id *dev)
+static void sfi_handle_spi_dev(struct sfi_device_table_entry *pentry,
+				struct devs_id *dev)
 {
 	struct spi_board_info spi_info;
 	void *pdata = NULL;
@@ -383,8 +384,8 @@ static void __init sfi_handle_spi_dev(struct sfi_device_table_entry *pentry,
 		spi_register_board_info(&spi_info, 1);
 }
 
-static void __init sfi_handle_i2c_dev(struct sfi_device_table_entry *pentry,
-					struct devs_id *dev)
+static void sfi_handle_i2c_dev(struct sfi_device_table_entry *pentry,
+				struct devs_id *dev, int from_module)
 {
 	struct i2c_board_info i2c_info;
 	void *pdata = NULL;
@@ -405,14 +406,20 @@ static void __init sfi_handle_i2c_dev(struct sfi_device_table_entry *pentry,
 
 	if (dev->delay)
 		intel_scu_i2c_device_register(pentry->host_num, &i2c_info);
-	else
+	else if (!from_module)
+		/*
+		 * Despite i2c_register_board_info() is __init, we have a
+		 * false-positive section mismatch here: this function is not
+		 * allowed to be called from non-__init source with
+		 * @from_module == 0.
+		 */
 		i2c_register_board_info(pentry->host_num, &i2c_info, 1);
 }
 
 extern struct devs_id *const __x86_intel_mid_dev_start[],
 		      *const __x86_intel_mid_dev_end[];
 
-static struct devs_id __init *get_device_id(u8 type, char *name)
+static struct devs_id *get_device_id(u8 type, char *name)
 {
 	struct devs_id *const *dev_table;
 
@@ -428,8 +435,9 @@ static struct devs_id __init *get_device_id(u8 type, char *name)
 	return NULL;
 }
 
-static int __init sfi_parse_devs(struct sfi_table_header *table, void *const priv)
+static int __sfi_parse_devs(struct sfi_table_header *table, void *const priv)
 {
+	struct devs_id *const devid = priv;
 	struct sfi_table_simple *sb;
 	struct sfi_device_table_entry *pentry;
 	struct devs_id *dev = NULL;
@@ -480,7 +488,16 @@ static int __init sfi_parse_devs(struct sfi_table_header *table, void *const pri
 			irq = 0; /* No irq */
 		}
 
-		dev = get_device_id(pentry->type, pentry->name);
+		/*
+		 * If @devid is NULL we want to go through the whole static
+		 * dev_ids list by calling get_device_id()
+		 */
+		if (likely(!devid))
+			dev = get_device_id(pentry->type, pentry->name);
+		else if (devid->type == pentry->type &&
+			 !strncmp(devid->name, pentry->name,
+				  sizeof(devid->name)))
+			dev = devid;
 
 		if (!dev)
 			continue;
@@ -496,7 +513,7 @@ static int __init sfi_parse_devs(struct sfi_table_header *table, void *const pri
 				sfi_handle_spi_dev(pentry, dev);
 				break;
 			case SFI_DEV_TYPE_I2C:
-				sfi_handle_i2c_dev(pentry, dev);
+				sfi_handle_i2c_dev(pentry, dev, !!devid);
 				break;
 			case SFI_DEV_TYPE_UART:
 			case SFI_DEV_TYPE_HSI:
@@ -504,10 +521,26 @@ static int __init sfi_parse_devs(struct sfi_table_header *table, void *const pri
 				break;
 			}
 		}
+		if (unlikely(devid))
+			/* We found the one we're looking for */
+			return 0;
 	}
+
 	return 0;
 }
 
+int sfi_parse_one_dev(struct sfi_table_header *table, void *const priv)
+{
+	return priv ? __sfi_parse_devs(table, priv) : -EINVAL;
+}
+EXPORT_SYMBOL_GPL(sfi_parse_one_dev);
+
+static int __init
+sfi_parse_devs(struct sfi_table_header *table, void *const priv)
+{
+	return __sfi_parse_devs(table, NULL);
+}
+
 static int __init intel_mid_platform_init(void)
 {
 	sfi_table_parse(SFI_SIG_GPIO, NULL, NULL, sfi_parse_gpio, NULL);
-- 
1.8.4.2

