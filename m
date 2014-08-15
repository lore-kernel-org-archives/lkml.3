Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaHOFlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 01:41:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:64215 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbaHOFlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 01:41:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,867,1400050800"; 
   d="scan'208";a="558888827"
From: Lan Tianyu <tianyu.lan@intel.com>
To: wsa@the-dreams.de, mika.westerberg@linux.intel.com,
        torvalds@linux-foundation.org
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2] I2C: Rework kernel config I2C_ACPI
Date: Fri, 15 Aug 2014 13:38:59 +0800
Message-Id: <1408081139-6292-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20140814093743.GB2824@katana>
References: <20140814093743.GB2824@katana>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit da3c6647(I2C/ACPI: Clean up I2C ACPI code and Add CONFIG_I2C_ACPI
config) adds a new kernel config I2C_ACPI and make I2C core built in
when the config is selected. This is wrong because distributions
etc generally compile I2C as a module and the commit broken that.
This patch is to rename I2C_ACPI to ACPI_I2C_OPREGION. New config
only controls ACPI I2C operation region code and depends on I2C=y.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/i2c/Kconfig    | 20 +++++++-------------
 drivers/i2c/Makefile   |  2 +-
 drivers/i2c/i2c-acpi.c |  2 ++
 include/linux/i2c.h    | 12 ++++++++----
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
index 3e3b680..f0937e5 100644
--- a/drivers/i2c/Kconfig
+++ b/drivers/i2c/Kconfig
@@ -2,9 +2,7 @@
 # I2C subsystem configuration
 #
 
-menu "I2C support"
-
-config I2C
+menuconfig I2C
 	tristate "I2C support"
 	select RT_MUTEXES
 	---help---
@@ -23,17 +21,14 @@ config I2C
 	  This I2C support can also be built as a module.  If so, the module
 	  will be called i2c-core.
 
-config I2C_ACPI
-	bool "I2C ACPI support"
-	select I2C
-	depends on ACPI
+config ACPI_I2C_OPREGION
+	bool "ACPI I2C Operation region support"
+	depends on I2C=y && ACPI
 	default y
 	help
-	  Say Y here if you want to enable ACPI I2C support. This includes support
-	  for automatic enumeration of I2C slave devices and support for ACPI I2C
-	  Operation Regions. Operation Regions allow firmware (BIOS) code to
-	  access I2C slave devices, such as smart batteries through an I2C host
-	  controller driver.
+	  Say Y here if you want to enable ACPI I2C operation region support.
+	  Operation Regions allow firmware (BIOS) code to access I2C slave devices,
+	  such as smart batteries through an I2C host controller driver.
 
 if I2C
 
@@ -139,4 +134,3 @@ config I2C_DEBUG_BUS
 
 endif # I2C
 
-endmenu
diff --git a/drivers/i2c/Makefile b/drivers/i2c/Makefile
index a1f590c..e0228b2 100644
--- a/drivers/i2c/Makefile
+++ b/drivers/i2c/Makefile
@@ -3,7 +3,7 @@
 #
 
 i2ccore-y := i2c-core.o
-i2ccore-$(CONFIG_I2C_ACPI)	+= i2c-acpi.o
+i2ccore-$(CONFIG_ACPI)	 	+= i2c-acpi.o
 
 obj-$(CONFIG_I2C_BOARDINFO)	+= i2c-boardinfo.o
 obj-$(CONFIG_I2C)		+= i2ccore.o
diff --git a/drivers/i2c/i2c-acpi.c b/drivers/i2c/i2c-acpi.c
index e8b6196..0dbc18c 100644
--- a/drivers/i2c/i2c-acpi.c
+++ b/drivers/i2c/i2c-acpi.c
@@ -126,6 +126,7 @@ void acpi_i2c_register_devices(struct i2c_adapter *adap)
 		dev_warn(&adap->dev, "failed to enumerate I2C slaves\n");
 }
 
+#ifdef CONFIG_ACPI_I2C_OPREGION
 static int acpi_gsb_i2c_read_bytes(struct i2c_client *client,
 		u8 cmd, u8 *data, u8 data_len)
 {
@@ -360,3 +361,4 @@ void acpi_i2c_remove_space_handler(struct i2c_adapter *adapter)
 
 	acpi_bus_detach_private_data(handle);
 }
+#endif
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index ea50766..a95efeb 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -577,16 +577,20 @@ static inline struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node
 }
 #endif /* CONFIG_OF */
 
-#ifdef CONFIG_I2C_ACPI
-int acpi_i2c_install_space_handler(struct i2c_adapter *adapter);
-void acpi_i2c_remove_space_handler(struct i2c_adapter *adapter);
+#ifdef CONFIG_ACPI
 void acpi_i2c_register_devices(struct i2c_adapter *adap);
 #else
 static inline void acpi_i2c_register_devices(struct i2c_adapter *adap) { }
+#endif /* CONFIG_ACPI */
+
+#ifdef CONFIG_ACPI_I2C_OPREGION
+int acpi_i2c_install_space_handler(struct i2c_adapter *adapter);
+void acpi_i2c_remove_space_handler(struct i2c_adapter *adapter);
+#else
 static inline void acpi_i2c_remove_space_handler(struct i2c_adapter *adapter)
 { }
 static inline int acpi_i2c_install_space_handler(struct i2c_adapter *adapter)
 { return 0; }
-#endif
+#endif /* CONFIG_ACPI_I2C_OPREGION */
 
 #endif /* _LINUX_I2C_H */
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

