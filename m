Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935991Ab3BONLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:11:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392Ab3BOMp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:45:27 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC 05/13] ghes_edac: Register at EDAC core the BIOS report
Date: Fri, 15 Feb 2013 10:44:53 -0200
Message-Id: <1af2b7e321b50216b2db96f7798bad5bc0b0d9bc.1360931635.git.mchehab@redhat.com>
In-Reply-To: <cover.1360931635.git.mchehab@redhat.com>
References: <cover.1360931635.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register GHES at EDAC MC core, in order to avoid other
drivers to also handle errors and mangle with error data.

The edac core will warrant that just one driver will be used,
so the first one to register (BIOS first) will be the one that
will be reporting the hardware errors.

For now, the EDAC driver does nothing but to register at the
EDAC core, preventing the hardware-driven mechanism to
interfere with GHES.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/Kconfig     | 23 +++++++++++++++
 drivers/edac/Makefile    |  1 +
 drivers/edac/ghes_edac.c | 75 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 99 insertions(+)
 create mode 100644 drivers/edac/ghes_edac.c

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 6671992..28503ec 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -80,6 +80,29 @@ config EDAC_MM_EDAC
 	  occurred so that a particular failing memory module can be
 	  replaced.  If unsure, select 'Y'.
 
+config EDAC_GHES
+	bool "Output ACPI APEI/GHES BIOS detected errors via EDAC"
+	depends on ACPI_APEI_GHES && (EDAC_MM_EDAC=y)
+	default y
+	help
+	  Not all machines support hardware-driven error report. Some of those
+	  provide a BIOS-driven error report mechanism via ACPI, using the
+	  APEI/GHES driver. By enabling this option, the error reports provided
+	  by GHES are sent to userspace via the EDAC API.
+
+	  When this option is enabled, it will disable the hardware-driven
+	  mechanisms, if a GHES BIOS is detected, entering into the
+	  "Firmware First" mode.
+
+	  It should be noticed that keeping both GHES and a hardware-driven
+	  error mechanism won't work well, as BIOS will race with OS, while
+	  reading the error registers. So, if you want to not use "Firmware
+	  first" GHES error mechanism, you should disable GHES either at
+	  compilation time or by passing "ghes_disable=1" Kernel parameter
+	  at boot time.
+
+	  In doubt, say 'Y'.
+
 config EDAC_AMD64
 	tristate "AMD64 (Opteron, Athlon64) K8, F10h"
 	depends on EDAC_MM_EDAC && AMD_NB && X86_64 && EDAC_DECODE_MCE
diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index 5608a9b..4154ed6 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -16,6 +16,7 @@ ifdef CONFIG_PCI
 edac_core-y	+= edac_pci.o edac_pci_sysfs.o
 endif
 
+obj-$(CONFIG_EDAC_GHES)			+= ghes_edac.o
 obj-$(CONFIG_EDAC_MCE_INJ)		+= mce_amd_inj.o
 
 edac_mce_amd-y				:= mce_amd.o
diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
new file mode 100644
index 0000000..6952bdf
--- /dev/null
+++ b/drivers/edac/ghes_edac.c
@@ -0,0 +1,75 @@
+#include <acpi/ghes.h>
+#include <linux/edac.h>
+#include "edac_core.h"
+
+#define GHES_PFX   "ghes_edac: "
+#define GHES_EDAC_REVISION " Ver: 1.0.0"
+
+void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
+                               struct cper_sec_mem_err *mem_err)
+{
+}
+EXPORT_SYMBOL_GPL(ghes_edac_report_mem_error);
+
+int ghes_edac_register(struct ghes *ghes, struct device *dev)
+{
+	int rc;
+	struct mem_ctl_info *mci;
+	struct edac_mc_layer layers[1];
+	struct csrow_info *csrow;
+	struct dimm_info *dimm;
+
+	layers[0].type = EDAC_MC_LAYER_ALL_MEM;
+	layers[0].size = 1;
+	layers[0].is_virt_csrow = true;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, 0);
+	if (!mci) {
+		pr_info(GHES_PFX "Can't allocate memory for EDAC data\n");
+		return -ENOMEM;
+	}
+
+	mci->pvt_info = ghes;
+	mci->pdev = dev;
+
+	mci->mtype_cap = MEM_FLAG_EMPTY;
+	mci->edac_ctl_cap = EDAC_FLAG_NONE;
+	mci->edac_cap = EDAC_FLAG_NONE;
+	mci->mod_name = "ghes_edac.c";
+	mci->mod_ver = GHES_EDAC_REVISION;
+	mci->ctl_name = "ghes_edac";
+	mci->dev_name = "ghes";
+
+	csrow = mci->csrows[0];
+	dimm = csrow->channels[0]->dimm;
+
+	/* FIXME: FAKE DATA */
+	dimm->nr_pages = 1000;
+	dimm->grain = 128;
+	dimm->mtype = MEM_UNKNOWN;
+	dimm->dtype = DEV_UNKNOWN;
+	dimm->edac_mode = EDAC_SECDED;
+
+	rc = edac_mc_add_mc(mci);
+	if (rc < 0) {
+		pr_info(GHES_PFX "Can't register at EDAC core\n");
+		edac_mc_free(mci);
+
+		return -ENODEV;
+	}
+
+	ghes->mci = mci;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ghes_edac_register);
+
+void ghes_edac_unregister(struct ghes *ghes)
+{
+	struct mem_ctl_info *mci = ghes->mci;
+
+	if (!mci)
+		return;
+
+	edac_mc_del_mc(mci->pdev);
+	edac_mc_free(mci);
+}
+EXPORT_SYMBOL_GPL(ghes_edac_unregister);
-- 
1.8.1.2

