Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab3CYB3r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:29:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33960 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755978Ab3CYBP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:56 -0400
Message-Id: <20130325010531.685645488@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:39 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Seth Forshee <seth.forshee@canonical.com>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>, Tony Luck <tony.luck@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [ 075/104] efivars: Add module parameter to disable use as a pstore backend
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seth Forshee <seth.forshee@canonical.com>

commit ec0971ba5372a4dfa753f232449d23a8fd98490e upstream.

We know that with some firmware implementations writing too much data to
UEFI variables can lead to bricking machines. Recent changes attempt to
address this issue, but for some it may still be prudent to avoid
writing large amounts of data until the solution has been proven on a
wide variety of hardware.

Crash dumps or other data from pstore can potentially be a large data
source. Add a pstore_module parameter to efivars to allow disabling its
use as a backend for pstore. Also add a config option,
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE, to allow setting the default
value of this paramter to true (i.e. disabled by default).

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -62,6 +62,15 @@ config EFI_VARS_PSTORE
 	  will allow writing console messages, crash dumps, or anything
 	  else supported by pstore to EFI variables.
 
+config EFI_VARS_PSTORE_DEFAULT_DISABLE
+	bool "Disable using efivars as a pstore backend by default"
+	depends on EFI_VARS_PSTORE
+	default n
+	help
+	  Saying Y here will disable the use of efivars as a storage
+	  backend for pstore by default. This setting can be overridden
+	  using the efivars module's pstore_disable parameter.
+
 config EFI_PCDP
 	bool "Console device selection via EFI PCDP or HCDP table"
 	depends on ACPI && EFI && IA64
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -92,6 +92,11 @@ MODULE_VERSION(EFIVARS_VERSION);
 
 #define DUMP_NAME_LEN 52
 
+static bool efivars_pstore_disable =
+	IS_ENABLED(EFI_VARS_PSTORE_DEFAULT_DISABLE);
+
+module_param_named(pstore_disable, efivars_pstore_disable, bool, 0644);
+
 /*
  * The maximum size of VariableName + Data = 1024
  * Therefore, it's reasonable to save that much
@@ -1257,7 +1262,8 @@ int register_efivars(struct efivars *efi
 	if (error)
 		unregister_efivars(efivars);
 
-	efivar_pstore_register(efivars);
+	if (!efivars_pstore_disable)
+		efivar_pstore_register(efivars);
 
 out:
 	kfree(variable_name);


