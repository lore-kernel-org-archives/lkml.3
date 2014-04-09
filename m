Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934312AbaDITMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:12:24 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.200]:8949 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934158AbaDITMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:12:22 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Apr 2014 15:12:22 EDT
X-Env-Sender: Benjamin.Romer@unisys.com
X-Msg-Ref: server-5.tower-45.messagelabs.com!1397070340!33607030!4
X-Originating-IP: [192.61.61.105]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
From: "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
To: *S-Par-Maintainer <SParMaintainer@unisys.com>,
        "jkc@redhat.com" <jkc@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 9 Apr 2014 14:04:50 -0500
Subject: [PATCH] unisys: staging: Check for s-Par firmware before
 initializing s-Par modules
Thread-Topic: [PATCH] unisys: staging: Check for s-Par firmware before
 initializing s-Par modules
Thread-Index: Ac9UJpUAchwoIAQrTwSjwd0TsgpsJw==
Message-ID: <C97001BC43954D438ACB059713BA5CDF92040F0F09@USEA-EXCH7.na.uis.unisys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s39JCYAB021504

This patch adds a function, is_spar_system(), to check that s-Par
firmware is present, and then uses this function at the beginning of
each module to verify that the modules are being run on an s-Par system
before beginning initialization. If the firmware is not detected, the
module will return a failure code.

Checking for s-Par firmware uses the cpuid instruction to verify that
the processor is running with virtualization turned on, and then uses a
second cpuid instruction to check that the hypervisor ID is
"UnisysSpar64".

Additionally, some minor clean-up was done on copyright tags and
unnecessary messages were removed from the visorchipset_main() function.

This patch was tested with KVM to ensure that the modules do not load
when s-Par firmware is not present, and tested with s-Par 4.0.12 to
verify that the modules load correctly when the firmware is present.

Signed-off-by: Benjamin Romer <benjamin.romer@unisys.com>
---
diff --git a/drivers/staging/unisys/include/timskmodutils.h b/drivers/staging/unisys/include/timskmodutils.h
index 2d81d46..cc439d3 100644
--- a/drivers/staging/unisys/include/timskmodutils.h
+++ b/drivers/staging/unisys/include/timskmodutils.h
@@ -1,6 +1,6 @@
 /* timskmodutils.h
  *
- * Copyright ÔøΩ 2010 - 2013 UNISYS CORPORATION
+ * Copyright ¬© 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
@@ -71,5 +71,6 @@
 				  u64 somethings, char *buf, size_t bufsize);
 struct seq_file *visor_seq_file_new_buffer(void *buf, size_t buf_size);
 void visor_seq_file_done_buffer(struct seq_file *m);
+int is_spar_system( void );
 
 #endif
diff --git a/drivers/staging/unisys/uislib/uislib.c b/drivers/staging/unisys/uislib/uislib.c
index 8ea9c46..aa60ccb 100644
--- a/drivers/staging/unisys/uislib/uislib.c
+++ b/drivers/staging/unisys/uislib/uislib.c
@@ -1,6 +1,6 @@
 /* uislib.c
  *
- * Copyright ÔøΩ 2010 - 2013 UNISYS CORPORATION
+ * Copyright ¬© 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
@@ -2276,6 +2276,11 @@
 static int __init
 uislib_mod_init(void)
 {
+	/* check for s-Par support */
+	if( !is_spar_system() ) {
+		printk( "s-Par not detected.\n" );
+		return -EPERM;
+	}
 
 	LOGINF("MONITORAPIS");
 
diff --git a/drivers/staging/unisys/virthba/virthba.c b/drivers/staging/unisys/virthba/virthba.c
index 817b11d..862509d 100644
--- a/drivers/staging/unisys/virthba/virthba.c
+++ b/drivers/staging/unisys/virthba/virthba.c
@@ -1,6 +1,6 @@
 /* virthba.c
  *
- * Copyright ÔøΩ 2010 - 2013 UNISYS CORPORATION
+ * Copyright ¬© 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
@@ -1691,6 +1691,12 @@
 	int error;
 	int i;
 
+	/* check for s-Par support */
+	if( !is_spar_system() ) {
+		printk( "s-Par not detected.\n" );
+		return -EPERM;
+	}
+
 	LOGINF("Entering virthba_mod_init...\n");
 
 	POSTCODE_LINUX_2(VHBA_CREATE_ENTRY_PC, POSTCODE_SEVERITY_INFO);
diff --git a/drivers/staging/unisys/virtpci/virtpci.c b/drivers/staging/unisys/virtpci/virtpci.c
index 8e34650..0d06f7e 100644
--- a/drivers/staging/unisys/virtpci/virtpci.c
+++ b/drivers/staging/unisys/virtpci/virtpci.c
@@ -1,6 +1,6 @@
 /* virtpci.c
  *
- * Copyright ÔøΩ 2010 - 2013 UNISYS CORPORATION
+ * Copyright ¬© 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
@@ -21,6 +21,7 @@
 #ifdef CONFIG_MODVERSIONS
 #include <config/modversions.h>
 #endif
+#include "timskmodutils.h"
 #include "uniklog.h"
 #include "diagnostics/appos_subsystems.h"
 #include "uisutils.h"
@@ -1686,6 +1687,11 @@
 {
 	int ret;
 
+	/* check for s-Par support */
+	if( !is_spar_system() ) {
+		printk( "s-Par not detected.\n" );
+		return -EPERM;
+	}
 
 	LOGINF("Module build: Date:%s Time:%s...\n", __DATE__, __TIME__);
 
diff --git a/drivers/staging/unisys/visorchipset/visorchipset_main.c b/drivers/staging/unisys/visorchipset/visorchipset_main.c
index 8252ca1..aa35aa2 100644
--- a/drivers/staging/unisys/visorchipset/visorchipset_main.c
+++ b/drivers/staging/unisys/visorchipset/visorchipset_main.c
@@ -1,6 +1,6 @@
 /* visorchipset_main.c
  *
- * Copyright ÔøΩ 2010 - 2013 UNISYS CORPORATION
+ * Copyright ¬© 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
@@ -2681,18 +2681,13 @@
 	struct proc_dir_entry *toolaction_file;
 	struct proc_dir_entry *bootToTool_file;
 
-	LOGINF("chipset driver version %s loaded", VERSION);
-	/* process module options */
-	POSTCODE_LINUX_2(DRIVER_ENTRY_PC, POSTCODE_SEVERITY_INFO);
+	/* check for s-Par support */
+	if( !is_spar_system() ) {
+		printk( "s-Par not detected.\n" );
+		return -EPERM;
+	}
 
-	LOGINF("option - testvnic=%d", visorchipset_testvnic);
-	LOGINF("option - testvnicclient=%d", visorchipset_testvnicclient);
-	LOGINF("option - testmsg=%d", visorchipset_testmsg);
-	LOGINF("option - testteardown=%d", visorchipset_testteardown);
-	LOGINF("option - major=%d", visorchipset_major);
-	LOGINF("option - serverregwait=%d", visorchipset_serverregwait);
-	LOGINF("option - clientregwait=%d", visorchipset_clientregwait);
-	LOGINF("option - holdchipsetready=%d", visorchipset_holdchipsetready);
+	POSTCODE_LINUX_2(DRIVER_ENTRY_PC, POSTCODE_SEVERITY_INFO);
 
 	memset(&BusDev_Server_Notifiers, 0, sizeof(BusDev_Server_Notifiers));
 	memset(&BusDev_Client_Notifiers, 0, sizeof(BusDev_Client_Notifiers));
diff --git a/drivers/staging/unisys/visorutil/visorkmodutils.c b/drivers/staging/unisys/visorutil/visorkmodutils.c
index a7d1e94..764400f 100644
--- a/drivers/staging/unisys/visorutil/visorkmodutils.c
+++ b/drivers/staging/unisys/visorutil/visorkmodutils.c
@@ -1,6 +1,6 @@
 /* timskmodutils.c
  *
- * Copyright ÔøΩ 2010 - 2013 UNISYS CORPORATION
+ * Copyright ¬© 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
@@ -20,6 +20,21 @@
 
 #define MYDRVNAME "timskmodutils"
 
+/* the s-Par firmware uses the virtualization hardware in the CPU to split up
+ * processors into partitions. The hypervisor ID can be found in the CPUID
+ * hypervisor feature leaf, encoded as a string "UnisysSpar64" across the
+ * returned ebx/ecx/edx registers.
+ */
+int is_spar_system() {
+	unsigned int eax, ebx, ecx, edx;
+
+	cpuid( 0x00000001, &eax, &ebx, &ecx, &edx ); /* check for virtual processor */
+	if( !(ecx & 0x80000000) ) return 0;
+	cpuid( 0x40000000, &eax, &ebx, &ecx, &edx ); /* check for s-Par id */
+	return (ebx == 0x73696e55) && (ecx == 0x70537379)
+			&& (edx == 0x34367261);
+}
+
 /** Callers to interfaces that set __GFP_NORETRY flag below
  *  must check for a NULL (error) result as we are telling the
  *  kernel interface that it is okay to fail.
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
