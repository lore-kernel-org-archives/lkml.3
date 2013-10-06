Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab3JFTk3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 15:40:29 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:59012 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205Ab3JFTk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 15:40:29 -0400
Date: Sun, 6 Oct 2013 13:40:21 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Peter H?we <PeterHuewe@gmx.de>
Cc: tpmdd-devel@lists.sourceforge.net, Ashley Lai <ashley@ashleylai.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        Sirrix AG <tpmdd@sirrix.com>
Subject: [PATCH 2/2] tpm: Merge the tpm-bios module with tpm.o
Message-ID: <20131006194021.GB19123@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/char/tpm/Makefile       | 7 +++----
 drivers/char/tpm/tpm_eventlog.c | 3 ---
 drivers/char/tpm/tpm_ppi.c      | 4 ----
 3 files changed, 3 insertions(+), 11 deletions(-)

This patch fits into the earlier posted series, see:
https://github.com/jgunthorpe/linux/commits/for-tpm   

I have compile tested this on x86 with various options to confirm
that both the ACPI and IBMVTPM paths work properly.

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
1.8.1.2

