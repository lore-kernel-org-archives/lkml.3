Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbaCHCkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 21:40:24 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:56080 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaCHCkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 21:40:21 -0500
Date: Sat, 8 Mar 2014 02:40:16 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/12] Thunderbolt hotplug support for Apple hardware
 (testers needed)
Message-ID: <20140308024016.GA24685@srcf.ucam.org>
References: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
 <20131202162938.GA11241@srcf.ucam.org>
 <20140304000904.GA6623@srcf.ucam.org>
 <CAMxnaaVEg5ohZwopnDdMfoDseQy4Xoqbm-J3BzOcxDS=HVQN2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMxnaaVEg5ohZwopnDdMfoDseQy4Xoqbm-J3BzOcxDS=HVQN2w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, can you try this one?

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
 
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index c1c4102..8d3178c 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -432,6 +432,17 @@ static void negotiate_os_control(struct acpi_pci_root *root, int *no_aspm,
 	acpi_handle handle = device->handle;
 
 	/*
+	 * Apple always return failure on _OSC calls when _OSI("Darwin") has
+	 * been called successfully. We know the feature set supported by the
+	 * platform, so avoid calling _OSC at all
+	 */
+
+	if (acpi_gbl_osi_data == ACPI_OSI_DARWIN) {
+		root->osc_control_set = ~OSC_PCI_EXPRESS_PME_CONTROL;
+		return;
+	}
+
+	/*
 	 * All supported architectures that use ACPI have support for
 	 * PCI domains, so we indicate this in _OSC support capabilities.
 	 */
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
Matthew Garrett | mjg59@srcf.ucam.org
