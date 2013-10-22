Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab3JVSCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 14:02:31 -0400
Received: from mout.gmx.net ([212.227.15.19]:50539 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113Ab3JVSBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 14:01:21 -0400
From: Peter Huewe <peterhuewe@gmx.de>
To: james.l.morris@oracle.com, tpmdd-devel@lists.sourceforge.net,
        adlai@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 11/15] tpm: Merge the tpm-bios module with tpm.o
Date: Tue, 22 Oct 2013 20:00:36 +0200
Message-Id: <1382464840-7639-11-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1382464840-7639-6-git-send-email-peterhuewe@gmx.de>
References: <1382464840-7639-6-git-send-email-peterhuewe@gmx.de>
X-Provags-ID: V03:K0:QUyzeDVPVKdzzH7Rlm5fZITlI35rOApFZ30nBx8quCE+cfRR5wq
 vb3BKvraSMLtuIdTSHZzX7/JjSgM1VRLzb9KQEStpwwb1NAYnTyP/dXDDhT4DYFFL4m59iK
 XhiIKJM8MBiUe+Gh7FI0t3TaML0VS+s3ACDIlfuqwlrp9b21mU7tEdhpsb/g2lLoA9Ixtlk
 BvJQib23tzb/dUNb2WPTg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Now that we can have multiple .c files in the tpm module there is
no reason for tpm-bios.

tpm-bios exported several functions: tpm_bios_log_setup,
tpm_bios_log_teardown, tpm_add_ppi, and tpm_remove_ppi.

They are only used by tpm, and if tpm-bios is built then
tpm will unconditionally require them. Further, tpm-bios does
nothing on its own, it has no module_init function.

Thus we remove the exports and merge the modules to simplify things.

The Makefile conditions are changed slightly to match the code,
tpm_ppi is always required if CONFIG_ACPI is set.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/Makefile       |    7 +++----
 drivers/char/tpm/tpm_eventlog.c |    3 ---
 drivers/char/tpm/tpm_ppi.c      |    4 ----
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 83b8a9d..15df2f3 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -3,14 +3,13 @@
 #
 obj-$(CONFIG_TCG_TPM) += tpm.o
 tpm-y := tpm-interface.o
+tpm-$(CONFIG_ACPI) += tpm_ppi.o
 
 ifdef CONFIG_ACPI
-	obj-$(CONFIG_TCG_TPM) += tpm_bios.o
-	tpm_bios-objs += tpm_eventlog.o tpm_acpi.o tpm_ppi.o
+	tpm-y += tpm_eventlog.o tpm_acpi.o
 else
 ifdef CONFIG_TCG_IBMVTPM
-	obj-$(CONFIG_TCG_TPM) += tpm_bios.o
-	tpm_bios-objs += tpm_eventlog.o tpm_of.o
+	tpm-y += tpm_eventlog.o tpm_of.o
 endif
 endif
 obj-$(CONFIG_TCG_TIS) += tpm_tis.o
diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
index 84ddc55..59f7cb2 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -406,7 +406,6 @@ out_tpm:
 out:
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(tpm_bios_log_setup);
 
 void tpm_bios_log_teardown(struct dentry **lst)
 {
@@ -415,5 +414,3 @@ void tpm_bios_log_teardown(struct dentry **lst)
 	for (i = 0; i < 3; i++)
 		securityfs_remove(lst[i]);
 }
-EXPORT_SYMBOL_GPL(tpm_bios_log_teardown);
-MODULE_LICENSE("GPL");
diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
index 2168d15..8e562dc 100644
--- a/drivers/char/tpm/tpm_ppi.c
+++ b/drivers/char/tpm/tpm_ppi.c
@@ -452,12 +452,8 @@ int tpm_add_ppi(struct kobject *parent)
 {
 	return sysfs_create_group(parent, &ppi_attr_grp);
 }
-EXPORT_SYMBOL_GPL(tpm_add_ppi);
 
 void tpm_remove_ppi(struct kobject *parent)
 {
 	sysfs_remove_group(parent, &ppi_attr_grp);
 }
-EXPORT_SYMBOL_GPL(tpm_remove_ppi);
-
-MODULE_LICENSE("GPL");
-- 
1.7.5.4

