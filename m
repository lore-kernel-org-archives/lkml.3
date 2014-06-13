Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaFMLDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 07:03:37 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:35134 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbaFMLD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 07:03:29 -0400
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
To: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@alien8.de,
        m.chehab@samsung.com, bp@suse.de
Cc: linux-edac@vger.kernel.org, x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        rric@kernel.org, Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [PATCH v3 4/5] apei, ghes, nmi: Factor out NMI arch-specific calls.
Date: Fri, 13 Jun 2014 13:02:59 +0200
Message-Id: <1402657380-18539-5-git-send-email-tomasz.nowicki@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402657380-18539-1-git-send-email-tomasz.nowicki@linaro.org>
References: <1402657380-18539-1-git-send-email-tomasz.nowicki@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to MCE related patch, all NMI architectural calls are abstracted.
Also, we are providing corresponding X86 functions' content.

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
---
 arch/x86/kernel/acpi/apei.c   |   25 +++++++++++++++++++++++++
 drivers/acpi/apei/apei-base.c |   19 +++++++++++++++++++
 drivers/acpi/apei/ghes.c      |   14 ++++++--------
 include/acpi/apei.h           |    7 +++++++
 4 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/acpi/apei.c b/arch/x86/kernel/acpi/apei.c
index dca2852..221a3a6 100644
--- a/arch/x86/kernel/acpi/apei.c
+++ b/arch/x86/kernel/acpi/apei.c
@@ -12,9 +12,12 @@
  * GNU General Public License for more details.
  */
 
+#include <linux/kdebug.h>
 #include <acpi/apei.h>
 
 #include <asm/mce.h>
+#include <asm/nmi.h>
+#include <asm/tlbflush.h>
 
 int apei_arch_enable_cmcff(struct acpi_hest_header *hest_hdr, void *data)
 {
@@ -54,3 +57,25 @@ void apei_arch_report_mem_error(int sev, struct cper_sec_mem_err *mem_err)
 	apei_mce_report_mem_error(sev, mem_err);
 #endif
 }
+
+int arch_apei_register_nmi(int (*nmi_handler)(unsigned int, struct pt_regs *),
+			   const char *name)
+{
+	struct nmiaction apei_nmi_action = {
+		.handler = nmi_handler,
+		.name = name,
+		.flags = 0,
+	};
+
+	return __register_nmi_handler(NMI_LOCAL, &apei_nmi_action);
+}
+
+void arch_apei_unregister_nmi(const char *name)
+{
+	unregister_nmi_handler(NMI_LOCAL, name);
+}
+
+void arch_apei_nmi_oops_begin(void)
+{
+	oops_begin();
+}
diff --git a/drivers/acpi/apei/apei-base.c b/drivers/acpi/apei/apei-base.c
index 4a11c1a..78c2a26 100644
--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -758,6 +758,25 @@ void __weak apei_arch_report_mem_error(int sev,
 }
 EXPORT_SYMBOL_GPL(apei_arch_report_mem_error);
 
+int __weak arch_apei_register_nmi(
+	__attribute__((unused))	int (*nmi_handler)(unsigned int,
+						   struct pt_regs *),
+	const char *name)
+{
+	return -ENOSYS;
+}
+EXPORT_SYMBOL_GPL(arch_apei_register_nmi);
+
+void __weak arch_apei_unregister_nmi(const char *name)
+{
+}
+EXPORT_SYMBOL_GPL(arch_apei_unregister_nmi);
+
+void __weak arch_apei_nmi_oops_begin(void)
+{
+}
+EXPORT_SYMBOL_GPL(arch_apei_nmi_oops_begin);
+
 int apei_osc_setup(void)
 {
 	static u8 whea_uuid_str[] = "ed855e0c-6c90-47bf-a62a-26de0fc5ad5c";
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 6db5110..21aeac5 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -51,7 +51,6 @@
 #include <acpi/ghes.h>
 #include <acpi/apei.h>
 #include <asm/tlbflush.h>
-#include <asm/nmi.h>
 
 #include "apei-internal.h"
 
@@ -817,7 +816,7 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 {
 	struct ghes *ghes, *ghes_global = NULL;
 	int sev, sev_global = -1;
-	int ret = NMI_DONE;
+	int ret = APEI_NMI_DONE;
 
 	BUG_ON(!IS_ENABLED(ARCH_HAS_ACPI_APEI_NMI));
 
@@ -832,14 +831,14 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 			sev_global = sev;
 			ghes_global = ghes;
 		}
-		ret = NMI_HANDLED;
+		ret = APEI_NMI_HANDLED;
 	}
 
-	if (ret == NMI_DONE)
+	if (ret == APEI_NMI_DONE)
 		goto out;
 
 	if (sev_global >= GHES_SEV_PANIC) {
-		oops_begin();
+		arch_apei_nmi_oops_begin();
 		ghes_print_queued_estatus();
 		__ghes_print_estatus(KERN_EMERG, ghes_global->generic,
 				     ghes_global->estatus);
@@ -909,8 +908,7 @@ static int ghes_notify_init_nmi(struct ghes *ghes)
 	ghes_estatus_pool_expand(len);
 	mutex_lock(&ghes_list_mutex);
 	if (list_empty(&ghes_nmi))
-		status = register_nmi_handler(NMI_LOCAL, ghes_notify_nmi, 0,
-					      "ghes");
+		status = arch_apei_register_nmi(ghes_notify_nmi, "ghes");
 	list_add_rcu(&ghes->list, &ghes_nmi);
 	mutex_unlock(&ghes_list_mutex);
 
@@ -924,7 +922,7 @@ static void ghes_notify_remove_nmi(struct ghes *ghes)
 	mutex_lock(&ghes_list_mutex);
 	list_del_rcu(&ghes->list);
 	if (list_empty(&ghes_nmi))
-		unregister_nmi_handler(NMI_LOCAL, "ghes");
+		arch_apei_unregister_nmi("ghes");
 	mutex_unlock(&ghes_list_mutex);
 	/*
 	 * To synchronize with NMI handler, ghes can only be
diff --git a/include/acpi/apei.h b/include/acpi/apei.h
index 62b9d1c..348e1ea 100644
--- a/include/acpi/apei.h
+++ b/include/acpi/apei.h
@@ -14,6 +14,9 @@
 #define APEI_ERST_CLEAR_RECORD		_IOW('E', 1, u64)
 #define APEI_ERST_GET_RECORD_COUNT	_IOR('E', 2, u32)
 
+#define APEI_NMI_DONE		0
+#define APEI_NMI_HANDLED	1
+
 #ifdef __KERNEL__
 
 extern bool hest_disable;
@@ -44,6 +47,10 @@ int erst_clear(u64 record_id);
 
 int apei_arch_enable_cmcff(struct acpi_hest_header *hest_hdr, void *data);
 void apei_arch_report_mem_error(int sev, struct cper_sec_mem_err *mem_err);
+int arch_apei_register_nmi(int (*nmi_handler)(unsigned int, struct pt_regs *),
+			   const char *name);
+void arch_apei_unregister_nmi(const char *name);
+void arch_apei_nmi_oops_begin(void);
 
 #endif
 #endif
-- 
1.7.9.5

