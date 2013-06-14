Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab3FNVcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:32:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34415 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab3FNVcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:32:03 -0400
Date: Fri, 14 Jun 2013 14:31:49 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-8ec3ffdf3921675aeae8e9c2b42be3c0b700f153@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tangchen@cn.fujitsu.com, tglx@linutronix.de,
        trenn@suse.de, hpa@linux.intel.com, rjw@sisk.pl
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tangchen@cn.fujitsu.com, tglx@linutronix.de,
        trenn@suse.de, rjw@sisk.pl, hpa@linux.intel.com
In-Reply-To: <1371128589-8953-8-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128589-8953-8-git-send-email-tangchen@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, ACPI:
  Store override acpi tables phys addr in cpio files info array
Git-Commit-ID: 8ec3ffdf3921675aeae8e9c2b42be3c0b700f153
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 14 Jun 2013 14:31:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ec3ffdf3921675aeae8e9c2b42be3c0b700f153
Gitweb:     http://git.kernel.org/tip/8ec3ffdf3921675aeae8e9c2b42be3c0b700f153
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 13 Jun 2013 21:02:54 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 14 Jun 2013 14:04:04 -0700

x86, ACPI: Store override acpi tables phys addr in cpio files info array

This patch introduces a file_pos struct to store physaddr. And then changes
acpi_initrd_files[] to file_pos type. Then store physaddr of ACPI tables
in acpi_initrd_files[].

For finding, we will find ACPI tables with physaddr during 32bit flat mode
in head_32.S, because at that time we don't need to setup page table to
access initrd.

For copying, we could use early_ioremap() with physaddr directly before
memory mapping is set.

To keep 32bit and 64bit platforms consistent, use phys_addr for all.

-v2: introduce file_pos to save physaddr instead of abusing cpio_data
     which tj is not happy with.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1371128589-8953-8-git-send-email-tangchen@cn.fujitsu.com
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Tested-by: Thomas Renninger <trenn@suse.de>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/acpi/osl.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 6ab6c54..42f79e3 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -570,7 +570,11 @@ static const char * const table_sigs[] = {
 #define ACPI_HEADER_SIZE sizeof(struct acpi_table_header)
 
 #define ACPI_OVERRIDE_TABLES 64
-static struct cpio_data __initdata acpi_initrd_files[ACPI_OVERRIDE_TABLES];
+struct file_pos {
+	phys_addr_t data;
+	phys_addr_t size;
+};
+static struct file_pos __initdata acpi_initrd_files[ACPI_OVERRIDE_TABLES];
 
 void __init acpi_initrd_override_find(void *data, size_t size)
 {
@@ -615,7 +619,7 @@ void __init acpi_initrd_override_find(void *data, size_t size)
 			table->signature, cpio_path, file.name, table->length);
 
 		all_tables_size += table->length;
-		acpi_initrd_files[table_nr].data = file.data;
+		acpi_initrd_files[table_nr].data = __pa_nodebug(file.data);
 		acpi_initrd_files[table_nr].size = file.size;
 		table_nr++;
 	}
@@ -624,7 +628,7 @@ void __init acpi_initrd_override_find(void *data, size_t size)
 void __init acpi_initrd_override_copy(void)
 {
 	int no, total_offset = 0;
-	char *p;
+	char *p, *q;
 
 	if (!all_tables_size)
 		return;
@@ -659,12 +663,15 @@ void __init acpi_initrd_override_copy(void)
 	 * one by one during copying.
 	 */
 	for (no = 0; no < ACPI_OVERRIDE_TABLES; no++) {
+		phys_addr_t addr = acpi_initrd_files[no].data;
 		phys_addr_t size = acpi_initrd_files[no].size;
 
 		if (!size)
 			break;
+		q = early_ioremap(addr, size);
 		p = early_ioremap(acpi_tables_addr + total_offset, size);
-		memcpy(p, acpi_initrd_files[no].data, size);
+		memcpy(p, q, size);
+		early_iounmap(q, size);
 		early_iounmap(p, size);
 		total_offset += size;
 	}
