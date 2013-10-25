Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab3JYQjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 12:39:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:4813 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab3JYQjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 12:39:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="398637586"
From: "Luck, Tony" <tony.luck@intel.com>
Subject: [PATCH] UEFI, CPER: Move cper.c to a more proper place
To: linux-kernel@vger.kernel.org
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Borislav Petkov <bp@suse.de>, Chen Gong <gong.chen@linux.intel.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Date: Fri, 25 Oct 2013 09:39:01 -0700
Message-Id: <526a9ea52087267b3b@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Chen, Gong" <gong.chen@linux.intel.com>

CPER (Common Platform Error Record - See UEFI spec, appendix N) support
is implemented via cper.c, which is under drivers/acpi/apei. But it is
not APEI specific, nor even ACPI specific. So move it to lib/ as a function
library.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
Chen Gong sent this to me internally for a review before posting
to the list - but I accidentally let the cat out of the bag by
pushing it in a git tree up to kernel.org.  Posting now so we can
have some review. Hopefully some "Acked-by"s ... but I'd also be
happy to hear "No, lib/ isn't the right place it should go in ..."

 drivers/acpi/Kconfig              | 3 ++-
 drivers/acpi/apei/Kconfig         | 1 +
 drivers/acpi/apei/Makefile        | 2 +-
 lib/Kconfig                       | 4 ++++
 lib/Makefile                      | 1 +
 {drivers/acpi/apei => lib}/cper.c | 0
 6 files changed, 9 insertions(+), 2 deletions(-)
 rename {drivers/acpi/apei => lib}/cper.c (100%)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 252f0e818a49..754cc9085ce1 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -374,7 +374,8 @@ source "drivers/acpi/apei/Kconfig"
 
 config ACPI_EXTLOG
 	tristate "Extended Error Log support"
-	depends on X86_MCE && ACPI_APEI
+	depends on X86_MCE
+	select UEFI_CPER
 	default n
 	help
 	  Certain usages such as Predictive Failure Analysis (PFA) require
diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
index f0c1ce95a0ec..3650b2183227 100644
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -2,6 +2,7 @@ config ACPI_APEI
 	bool "ACPI Platform Error Interface (APEI)"
 	select MISC_FILESYSTEMS
 	select PSTORE
+	select UEFI_CPER
 	depends on X86
 	help
 	  APEI allows to report errors (for example from the chipset)
diff --git a/drivers/acpi/apei/Makefile b/drivers/acpi/apei/Makefile
index d1d1bc0a4ee1..5d575a955940 100644
--- a/drivers/acpi/apei/Makefile
+++ b/drivers/acpi/apei/Makefile
@@ -3,4 +3,4 @@ obj-$(CONFIG_ACPI_APEI_GHES)	+= ghes.o
 obj-$(CONFIG_ACPI_APEI_EINJ)	+= einj.o
 obj-$(CONFIG_ACPI_APEI_ERST_DEBUG) += erst-dbg.o
 
-apei-y := apei-base.o hest.o cper.o erst.o
+apei-y := apei-base.o hest.o erst.o
diff --git a/lib/Kconfig b/lib/Kconfig
index b3c8be0da17f..08abb6c9671e 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -42,6 +42,10 @@ config GENERIC_IO
 	boolean
 	default n
 
+config UEFI_CPER
+	bool
+	default n
+
 config STMP_DEVICE
 	bool
 
diff --git a/lib/Makefile b/lib/Makefile
index f3bb2cb98adf..139ae3eba3ad 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -40,6 +40,7 @@ endif
 obj-$(CONFIG_GENERIC_IOMAP) += iomap.o
 obj-$(CONFIG_GENERIC_PCI_IOMAP) += pci_iomap.o
 obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
+obj-$(CONFIG_UEFI_CPER) += cper.o
 obj-$(CONFIG_CHECK_SIGNATURE) += check_signature.o
 obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
diff --git a/drivers/acpi/apei/cper.c b/lib/cper.c
similarity index 100%
rename from drivers/acpi/apei/cper.c
rename to lib/cper.c
-- 
1.8.1.4

