Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609Ab3HBJVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 05:21:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62165 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758209Ab3HBJQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 05:16:12 -0400
X-IronPort-AV: E=Sophos;i="4.89,800,1367942400"; 
   d="scan'208";a="8098119"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl, lenb@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: [PATCH v2 RESEND 06/18] x86, acpi, ACPICA: Initialize ACPI root table list earlier.
Date: Fri, 2 Aug 2013 17:14:25 +0800
Message-Id: <1375434877-20704-7-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1375434877-20704-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1375434877-20704-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/02 17:14:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/02 17:14:52,
	Serialize complete at 2013/08/02 17:14:52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have split acpi_table_init() into two steps:
1. Pares RSDT or XSDT, and initialize acpi_gbl_root_table_list.
   This step will record all tables' physical address in memory.
2. Check acpi initrd table override and install all tables into
   acpi_gbl_root_table_list.

This patch does step 1 earlier, right after memblock is ready.

When memblock_x86_fill() is called to fulfill memblock.memory[],
memblock is able to allocate memory.

This patch introduces a new function acpi_root_table_init() to
do step 1, and call this function right after memblock_x86_fill()
is called.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/kernel/acpi/boot.c |   45 +++++++++++++++++++++++++++---------------
 arch/x86/kernel/setup.c     |    3 ++
 drivers/acpi/tables.c       |    7 ++++-
 include/linux/acpi.h        |    2 +
 4 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 2627a81..dcdf3e3 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1497,6 +1497,32 @@ static struct dmi_system_id __initdata acpi_dmi_table_late[] = {
 	{}
 };
 
+/**
+ * early_acpi_boot_table_init - Initialize acpi_gbl_root_table_list.
+ *
+ * This function will parse RSDT or XSDT, find all tables' phys addr,
+ * initialize acpi_gbl_root_table_list, and record all tables' phys addr
+ * in acpi_gbl_root_table_list.
+ *
+ * acpi_table_init() is separate to allow reading SRAT without
+ * other side effects.
+ *
+ */
+void __init early_acpi_boot_table_init(void)
+{
+	dmi_check_system(acpi_dmi_table);
+
+	/* If acpi_disabled, bail out */
+	if (acpi_disabled)
+		return;
+
+	/* Initialize the ACPI boot-time table parser */
+	if (acpi_table_init()) {
+		disable_acpi();
+		return;
+	}
+}
+
 /*
  * acpi_boot_table_init() and acpi_boot_init()
  *  called from setup_arch(), always.
@@ -1504,9 +1530,6 @@ static struct dmi_system_id __initdata acpi_dmi_table_late[] = {
  *	2. enumerates lapics
  *	3. enumerates io-apics
  *
- * acpi_table_init() is separate to allow reading SRAT without
- * other side effects.
- *
  * side effects of acpi_boot_init:
  *	acpi_lapic = 1 if LAPIC found
  *	acpi_ioapic = 1 if IOAPIC found
@@ -1518,21 +1541,11 @@ static struct dmi_system_id __initdata acpi_dmi_table_late[] = {
 
 void __init acpi_boot_table_init(void)
 {
-	dmi_check_system(acpi_dmi_table);
-
-	/*
-	 * If acpi_disabled, bail out
-	 */
+	/* If acpi_disabled, bail out */
 	if (acpi_disabled)
-		return; 
-
-	/*
-	 * Initialize the ACPI boot-time table parser.
-	 */
-	if (acpi_table_init()) {
-		disable_acpi();
 		return;
-	}
+
+	acpi_install_root_table();
 
 	acpi_table_parse(ACPI_SIG_BOOT, acpi_parse_sbf);
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f8ec578..53d4ac7 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1073,6 +1073,9 @@ void __init setup_arch(char **cmdline_p)
 	memblock.current_limit = ISA_END_ADDRESS;
 	memblock_x86_fill();
 
+	/* Initialize ACPI global root table list. */
+	early_acpi_boot_table_init();
+
 	/*
 	 * The EFI specification says that boot service code won't be called
 	 * after ExitBootServices(). This is, in fact, a lie.
diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index 8860e79..60ecbb8 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -353,10 +353,13 @@ int __init acpi_table_init(void)
 	if (ACPI_FAILURE(status))
 		return 1;
 
-	acpi_tb_install_root_table();
+	return 0;
+}
 
+void __init acpi_install_root_table(void)
+{
+	acpi_tb_install_root_table();
 	check_multiple_madt();
-	return 0;
 }
 
 static int __init acpi_parse_apic_instance(char *str)
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 353ba25..b722183 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -92,10 +92,12 @@ void __acpi_unmap_table(char *map, unsigned long size);
 int early_acpi_boot_init(void);
 int acpi_boot_init (void);
 void acpi_boot_table_init (void);
+void early_acpi_boot_table_init(void);
 int acpi_mps_check (void);
 int acpi_numa_init (void);
 
 int acpi_table_init (void);
+void acpi_install_root_table(void);
 int acpi_table_parse(char *id, acpi_tbl_table_handler handler);
 int __init acpi_table_parse_entries(char *id, unsigned long table_size,
 				    int entry_id,
-- 
1.7.1

