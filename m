Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbaCKWUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:20:21 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52141 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841AbaCKWUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:20:14 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, rjw@rjwysocki.net,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 1/3] ACPI: Support _OSI("Darwin") correctly
Date: Tue, 11 Mar 2014 18:20:00 -0400
Message-Id: <1394576402-2910-2-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394576402-2910-1-git-send-email-matthew.garrett@nebula.com>
References: <1394576402-2910-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.207.143
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apple hardware queries _OSI("Darwin") in order to determine whether the
system is running OS X, and changes firmware behaviour based on the answer.
The most obvious difference in behaviour is that Thunderbolt hardware is
forcibly powered down unless the system is running OS X. The obvious solution
would be to simply add Darwin to the list of supported _OSI strings, but this
causes problems.

Recent Apple hardware includes two separate methods for checking _OSI
strings. The first will check whether Darwin is supported, and if so will
exit. The second will check whether Darwin is supported, but will then
continue to check for further operating systems. If a further operating
system is found then later firmware code will assume that the OS is not OS X.
This results in the unfortunate situation where the Thunderbolt controller is
available at boot time but remains powered down after suspend.

The easiest way to handle this is to special-case it in the Linux-specific
OSI handling code. If we see Darwin, we should answer true and then disable
all other _OSI vendor strings.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/acpi/acpica/utosi.c |  1 +
 drivers/acpi/osl.c          | 10 ++++++++++
 include/acpi/actypes.h      | 25 +++++++++++++------------
 3 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/acpica/utosi.c b/drivers/acpi/acpica/utosi.c
index 8856bd3..202b4da 100644
--- a/drivers/acpi/acpica/utosi.c
+++ b/drivers/acpi/acpica/utosi.c
@@ -62,6 +62,7 @@ ACPI_MODULE_NAME("utosi")
 static struct acpi_interface_info acpi_default_supported_interfaces[] = {
 	/* Operating System Vendor Strings */
 
+	{"Darwin", NULL, 0, ACPI_OSI_DARWIN},	/* OS X */
 	{"Windows 2000", NULL, 0, ACPI_OSI_WIN_2000},	/* Windows 2000 */
 	{"Windows 2001", NULL, 0, ACPI_OSI_WIN_XP},	/* Windows XP */
 	{"Windows 2001 SP1", NULL, 0, ACPI_OSI_WIN_XP_SP1},	/* Windows XP SP1 */
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index fc1aa79..5bf45c06 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -152,6 +152,16 @@ static u32 acpi_osi_handler(acpi_string interface, u32 supported)
 			osi_linux.dmi ? " via DMI" : "");
 	}
 
+	if (!strcmp("Darwin", interface)) {
+		/*
+		 * Apple firmware will behave poorly if it receives positive
+		 * answers to "Darwin" and any other OS. Respond positively
+		 * to Darwin and then disable all other vendor strings.
+		 */
+		acpi_update_interfaces(ACPI_DISABLE_ALL_VENDOR_STRINGS);
+		supported = ACPI_UINT32_MAX;
+	}
+
 	return supported;
 }
 
diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index 68a3ada..4580c67 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -1210,17 +1210,18 @@ struct acpi_memory_list {
 #define ACPI_ENABLE_ALL_FEATURE_STRINGS     (ACPI_ENABLE_INTERFACES | ACPI_FEATURE_STRINGS)
 #define ACPI_ENABLE_ALL_STRINGS             (ACPI_ENABLE_INTERFACES | ACPI_VENDOR_STRINGS | ACPI_FEATURE_STRINGS)
 
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
+#define ACPI_OSI_DARWIN                 0x01
+#define ACPI_OSI_WIN_2000               0x02
+#define ACPI_OSI_WIN_XP                 0x03
+#define ACPI_OSI_WIN_XP_SP1             0x04
+#define ACPI_OSI_WINSRV_2003            0x05
+#define ACPI_OSI_WIN_XP_SP2             0x06
+#define ACPI_OSI_WINSRV_2003_SP1        0x07
+#define ACPI_OSI_WIN_VISTA              0x08
+#define ACPI_OSI_WINSRV_2008            0x09
+#define ACPI_OSI_WIN_VISTA_SP1          0x0A
+#define ACPI_OSI_WIN_VISTA_SP2          0x0B
+#define ACPI_OSI_WIN_7                  0x0C
+#define ACPI_OSI_WIN_8                  0x0D
 
 #endif				/* __ACTYPES_H__ */
-- 
1.8.5.3

