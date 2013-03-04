Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab3CDDnr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:43:47 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32880 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756387Ab3CDDnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:43:41 -0500
Message-Id: <20130304033716.068432725@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:33 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Matt Fleming <matt.fleming@intel.com>,
        Walt Nelson Jr <walt0924@gmail.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 086/153] x86, efi: Make "noefi" really disable EFI runtime serivces
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <matt.fleming@intel.com>

commit fb834c7acc5e140cf4f9e86da93a66de8c0514da upstream.

commit 1de63d60cd5b ("efi: Clear EFI_RUNTIME_SERVICES rather than
EFI_BOOT by "noefi" boot parameter") attempted to make "noefi" true to
its documentation and disable EFI runtime services to prevent the
bricking bug described in commit e0094244e41c ("samsung-laptop:
Disable on EFI hardware"). However, it's not possible to clear
EFI_RUNTIME_SERVICES from an early param function because
EFI_RUNTIME_SERVICES is set in efi_init() *after* parse_early_param().

This resulted in "noefi" effectively becoming a no-op and no longer
providing users with a way to disable EFI, which is bad for those
users that have buggy machines.

Reported-by: Walt Nelson Jr <walt0924@gmail.com>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1361392572-25657-1-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
[bwh: Backported to 3.2: efi_runtime_init() is not a separate function,
 so put a whole set of statements in an if (!disable_runtime) block]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -83,9 +83,10 @@ int efi_enabled(int facility)
 }
 EXPORT_SYMBOL(efi_enabled);
 
+static bool disable_runtime = false;
 static int __init setup_noefi(char *arg)
 {
-	clear_bit(EFI_RUNTIME_SERVICES, &x86_efi_facility);
+	disable_runtime = true;
 	return 0;
 }
 early_param("noefi", setup_noefi);
@@ -549,35 +550,37 @@ void __init efi_init(void)
 
 	set_bit(EFI_CONFIG_TABLES, &x86_efi_facility);
 
-	/*
-	 * Check out the runtime services table. We need to map
-	 * the runtime services table so that we can grab the physical
-	 * address of several of the EFI runtime functions, needed to
-	 * set the firmware into virtual mode.
-	 */
-	runtime = early_ioremap((unsigned long)efi.systab->runtime,
-				sizeof(efi_runtime_services_t));
-	if (runtime != NULL) {
-		/*
-		 * We will only need *early* access to the following
-		 * two EFI runtime services before set_virtual_address_map
-		 * is invoked.
-		 */
-		efi_phys.get_time = (efi_get_time_t *)runtime->get_time;
-		efi_phys.set_virtual_address_map =
-			(efi_set_virtual_address_map_t *)
-			runtime->set_virtual_address_map;
+	if (!disable_runtime) {
 		/*
-		 * Make efi_get_time can be called before entering
-		 * virtual mode.
+		 * Check out the runtime services table. We need to map
+		 * the runtime services table so that we can grab the physical
+		 * address of several of the EFI runtime functions, needed to
+		 * set the firmware into virtual mode.
 		 */
-		efi.get_time = phys_efi_get_time;
-
-		set_bit(EFI_RUNTIME_SERVICES, &x86_efi_facility);
-	} else
-		printk(KERN_ERR "Could not map the EFI runtime service "
-		       "table!\n");
-	early_iounmap(runtime, sizeof(efi_runtime_services_t));
+		runtime = early_ioremap((unsigned long)efi.systab->runtime,
+					sizeof(efi_runtime_services_t));
+		if (runtime != NULL) {
+			/*
+			 * We will only need *early* access to the following
+			 * two EFI runtime services before set_virtual_address_map
+			 * is invoked.
+			 */
+			efi_phys.get_time = (efi_get_time_t *)runtime->get_time;
+			efi_phys.set_virtual_address_map =
+				(efi_set_virtual_address_map_t *)
+				runtime->set_virtual_address_map;
+			/*
+			 * Make efi_get_time can be called before entering
+			 * virtual mode.
+			 */
+			efi.get_time = phys_efi_get_time;
+			
+			set_bit(EFI_RUNTIME_SERVICES, &x86_efi_facility);
+		} else
+			printk(KERN_ERR "Could not map the EFI runtime service "
+			       "table!\n");
+		early_iounmap(runtime, sizeof(efi_runtime_services_t));
+	}
 
 	/* Map the EFI memory map */
 	memmap.map = early_ioremap((unsigned long)memmap.phys_map,


