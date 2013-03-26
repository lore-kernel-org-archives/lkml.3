Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab3CZX2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:28:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52675 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab3CZWo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>, Tony Luck <tony.luck@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [ 90/98] efivars: Add module parameter to disable use as a pstore backend
Date: Tue, 26 Mar 2013 15:43:19 -0700
Message-Id: <20130326224251.790934458@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/Kconfig   |    9 +++++++++
 drivers/firmware/efivars.c |    8 +++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

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
@@ -103,6 +103,11 @@ MODULE_VERSION(EFIVARS_VERSION);
  */
 #define GUID_LEN 36
 
+static bool efivars_pstore_disable =
+	IS_ENABLED(EFI_VARS_PSTORE_DEFAULT_DISABLE);
+
+module_param_named(pstore_disable, efivars_pstore_disable, bool, 0644);
+
 /*
  * The maximum size of VariableName + Data = 1024
  * Therefore, it's reasonable to save that much
@@ -1926,7 +1931,8 @@ int register_efivars(struct efivars *efi
 	if (error)
 		unregister_efivars(efivars);
 
-	efivar_pstore_register(efivars);
+	if (!efivars_pstore_disable)
+		efivar_pstore_register(efivars);
 
 	register_filesystem(&efivarfs_type);
 


