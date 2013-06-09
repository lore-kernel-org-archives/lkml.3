Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab3FIXCF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 19:02:05 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45797 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab3FIXB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 19:01:59 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-acpi@vger.kernel.org
Cc: seth.forshee@canonical.com, joeyli.kernel@gmail.com,
        daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rjw@sisk.pl,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 2/3] ACPICA: Add interface for getting latest OS version requested via _OSI
Date: Sun,  9 Jun 2013 19:01:38 -0400
Message-Id: <1370818899-8595-3-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers may need to make policy decisions based on the OS that the firmware
believes it's interacting with. ACPI firmware will make a series of _OSI
calls, starting from the oldest OS version they support and ending with the
most recent. Add a function to return the last successful call so that
drivers know what the firmware's expecting.

Based on a patch by Seth Forshee <seth.forshee@canonical.com>

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/acpi/acpica/aclocal.h | 13 -------------
 drivers/acpi/acpica/utxface.c | 19 +++++++++++++++++++
 include/acpi/acpixf.h         | 22 ++++++++++++++++++++++
 3 files changed, 41 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index d5bfbd3..8a2f532 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -948,19 +948,6 @@ struct acpi_bit_register_info {
 
 /* Structs and definitions for _OSI support and I/O port validation */
 
-#define ACPI_OSI_WIN_2000               0x01
-#define ACPI_OSI_WIN_XP                 0x02
-#define ACPI_OSI_WIN_XP_SP1             0x03
-#define ACPI_OSI_WINSRV_2003            0x04
-#define ACPI_OSI_WIN_XP_SP2             0x05
-#define ACPI_OSI_WINSRV_2003_SP1        0x06
-#define ACPI_OSI_WIN_VISTA              0x07
-#define ACPI_OSI_WINSRV_2008            0x08
-#define ACPI_OSI_WIN_VISTA_SP1          0x09
-#define ACPI_OSI_WIN_VISTA_SP2          0x0A
-#define ACPI_OSI_WIN_7                  0x0B
-#define ACPI_OSI_WIN_8                  0x0C
-
 #define ACPI_ALWAYS_ILLEGAL             0x00
 
 struct acpi_interface_info {
diff --git a/drivers/acpi/acpica/utxface.c b/drivers/acpi/acpica/utxface.c
index 6505774..c1638c3 100644
--- a/drivers/acpi/acpica/utxface.c
+++ b/drivers/acpi/acpica/utxface.c
@@ -389,6 +389,25 @@ ACPI_EXPORT_SYMBOL(acpi_install_interface_handler)
 
 /*****************************************************************************
  *
+ * FUNCTION:    acpi_osi_version
+ *
+ * PARAMETERS:  None
+ *
+ * RETURN:      Last OS version requested via _OSI
+ *
+ * DESCRIPTION: Returns the argument to the most recent _OSI query performed
+ *		by the firmware
+ *
+ ****************************************************************************/
+u8 acpi_osi_version(void)
+{
+	return acpi_gbl_osi_data;
+}
+
+ACPI_EXPORT_SYMBOL(acpi_osi_version)
+
+/*****************************************************************************
+ *
  * FUNCTION:    acpi_check_address_range
  *
  * PARAMETERS:  space_id            - Address space ID
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 454881e..41d3ac1 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -82,6 +82,22 @@ extern u8 acpi_gbl_truncate_io_addresses;
 extern u8 acpi_gbl_disable_auto_repair;
 
 /*
+ * Values returned by acpi_osi_version()
+ */
+#define ACPI_OSI_WIN_2000               0x01
+#define ACPI_OSI_WIN_XP                 0x02
+#define ACPI_OSI_WIN_XP_SP1             0x03
+#define ACPI_OSI_WINSRV_2003            0x04
+#define ACPI_OSI_WIN_XP_SP2             0x05
+#define ACPI_OSI_WINSRV_2003_SP1        0x06
+#define ACPI_OSI_WIN_VISTA              0x07
+#define ACPI_OSI_WINSRV_2008            0x08
+#define ACPI_OSI_WIN_VISTA_SP1          0x09
+#define ACPI_OSI_WIN_VISTA_SP2          0x0A
+#define ACPI_OSI_WIN_7                  0x0B
+#define ACPI_OSI_WIN_8                  0x0C
+
+/*
  * Hardware-reduced prototypes. All interfaces that use these macros will
  * be configured out of the ACPICA build if the ACPI_REDUCED_HARDWARE flag
  * is set to TRUE.
@@ -307,6 +323,12 @@ acpi_status acpi_install_notify_handler(acpi_handle device, u32 handler_type,
 					acpi_notify_handler handler,
 					void *context);
 
+#ifdef CONFIG_ACPI
+u8 acpi_osi_version(void);
+#else
+static inline u8 acpi_osi_version(void) { return 0; }
+#endif
+
 acpi_status
 acpi_remove_notify_handler(acpi_handle device,
 			   u32 handler_type, acpi_notify_handler handler);
-- 
1.8.2.1

