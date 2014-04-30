Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbaD3CGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:06:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:61781 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756834AbaD3CGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:06:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,955,1389772800"; 
   d="scan'208";a="425690342"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Zhao Yakui <yakui.zhao@intel.com>, Bob Moore <robert.moore@intel.com>
Subject: [PATCH 22/27] ACPICA: Tables: Add new mechanism to skip NULL entries in RSDT and XSDT.
Date: Wed, 30 Apr 2014 10:05:56 +0800
Message-Id: <bd6ce63704884742205c675af5dbc3c9ce8c4ee3.1398817612.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1398817612.git.lv.zheng@intel.com>
References: <cover.1398817612.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is reported that there are buggy BIOSes in the world: AMI uses an XSDT
compiler for early BIOSes, this compiler will generate XSDT with a NULL
entry.  The affected BIOS versions are "AMI BIOS F2-F4".

Original solution on Linux is to use an alternative heathy root table
instead of the ill one.  This commit is:
  Commit: 671cc68dc61f029d44b43a681356078e02d8dab8
  Subject: ACPICA: Back port and refine validation of the XSDT root table.

This is an example of such XSDT dumped from B85-HD3 (AMI F3 BIOS):
[000h 0000   4]                    Signature : "XSDT"    [Extended System Description Table]
[004h 0004   4]                 Table Length : 00000074
[008h 0008   1]                     Revision : 01
[009h 0009   1]                     Checksum : 18
[00Ah 0010   6]                       Oem ID : "ALASKA"
[010h 0016   8]                 Oem Table ID : "A M I"
[018h 0024   4]                 Oem Revision : 01072009
[01Ch 0028   4]              Asl Compiler ID : "AMI "
[020h 0032   4]        Asl Compiler Revision : 00010013

[024h 0036   8]       ACPI Table Address   0 : 00000000BA5F8180
[02Ch 0044   8]       ACPI Table Address   1 : 00000000BA5F8290
[034h 0052   8]       ACPI Table Address   2 : 00000000BA5F8308
[03Ch 0060   8]       ACPI Table Address   3 : 00000000BA5F8848
[044h 0068   8]       ACPI Table Address   4 : 00000000BA5F9320
[04Ch 0076   8]       ACPI Table Address   5 : 00000000BA5F9360
[054h 0084   8]       ACPI Table Address   6 : 00000000BA5F9398
[05Ch 0092   8]       ACPI Table Address   7 : 00000000BA5F9708
[064h d100   8]       ACPI Table Address   8 : 00000000BA5FC9A8
[06Ch 0108   8]       ACPI Table Address   9 : 0000000000000000

But according to the bug report, the XSDT in fact is not broken. In the
above XSDT, ACPI Table Address 1-8 contains the same value as RSDT.  The
differences can only be seen on the following 2 entries:
1. The first entry points to a FADT whose Revision is 5 while the first
   entry in RSDT points to a FADT whose Revision is 2.
   The FADT dumped from the address indicated by the first entry of XSDT:
    FACP @ 0x00000000BA5F8180
      0000: 46 41 43 50 0C 01 00 00<05>4B 41 4C 41 53 4B 41  FACP.....KALASKA
      ...
   The FADT dumped from the address indicated by the first entry of RSDT:
    FACP @ 0x00000000BA5ED0F0
      0000: 46 41 43 50 84 00 00 00<02>A7 41 4C 41 53 4B 41  FACP......ALASKA
      ...
2. The last entry is a NULL terminator.
According to the test result, the Revision 5 FADT is accessible.  Thus the
original solution turns out to be a work around that is preventing the
higher revision tables to be used for such platforms (they are all x86-64
platforms, and should use XSDT and higher revision FADT).

This patch offers a new solution, where a sanity check is performed before
installing a table address from XSDT. If the entry is NULL, it is simply
discarded.

Note that, this patch doesn't remove the original solution, so for Linux
kernel, this commit is actually a no-op, but it allows acpidump to be
working on such platforms. By doing so, we allow another easy revertable
commit to enable this feature so that when that commit is reverted, the
useful sanity check will not be affected. Lv Zheng.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=73911
Buglink: https://bugs.archlinux.org/task/39811
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Reported-and-tested-by: Bruce Chiarelli <mano155@gmail.com>
Reported-and-tested-by: Spyros Stathopoulos <spystath@gmail.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
---
 drivers/acpi/acpica/tbutils.c                      |   21 ++++++++++++++------
 .../acpi/os_specific/service_layers/oslinuxtbl.c   |   12 +++++++++++
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/acpica/tbutils.c b/drivers/acpi/acpica/tbutils.c
index e1638ad..801d196 100644
--- a/drivers/acpi/acpica/tbutils.c
+++ b/drivers/acpi/acpica/tbutils.c
@@ -474,12 +474,19 @@ acpi_status __init acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
 
 		/* Get the table physical address (32-bit for RSDT, 64-bit for XSDT) */
 
-		status =
-		    acpi_tb_install_standard_table(acpi_tb_get_root_table_entry
-						   (table_entry,
-						    table_entry_size),
-						   ACPI_TABLE_ORIGIN_INTERNAL_PHYSICAL,
-						   FALSE, TRUE, &table_index);
+		address =
+		    acpi_tb_get_root_table_entry(table_entry, table_entry_size);
+
+		/* Skip NULL entries in RSDT/XSDT */
+
+		if (!address) {
+			goto next_table;
+		}
+
+		status = acpi_tb_install_standard_table(address,
+							ACPI_TABLE_ORIGIN_INTERNAL_PHYSICAL,
+							FALSE, TRUE,
+							&table_index);
 
 		if (ACPI_SUCCESS(status) &&
 		    ACPI_COMPARE_NAME(&acpi_gbl_root_table_list.
@@ -488,6 +495,8 @@ acpi_status __init acpi_tb_parse_root_table(acpi_physical_address rsdp_address)
 			acpi_tb_parse_fadt(table_index);
 		}
 
+next_table:
+
 		table_entry += table_entry_size;
 	}
 
diff --git a/tools/power/acpi/os_specific/service_layers/oslinuxtbl.c b/tools/power/acpi/os_specific/service_layers/oslinuxtbl.c
index e0699e6..ba7bad0 100644
--- a/tools/power/acpi/os_specific/service_layers/oslinuxtbl.c
+++ b/tools/power/acpi/os_specific/service_layers/oslinuxtbl.c
@@ -720,6 +720,12 @@ static acpi_status osl_list_bios_tables(void)
 			    (acpi_physical_address) (*ACPI_CAST32(table_data));
 		}
 
+		/* Skip NULL entries in RSDT/XSDT */
+
+		if (!table_address) {
+			continue;
+		}
+
 		status = osl_map_table(table_address, NULL, &mapped_table);
 		if (ACPI_FAILURE(status)) {
 			return (status);
@@ -865,6 +871,12 @@ osl_get_bios_table(char *signature,
 							     (table_data));
 			}
 
+			/* Skip NULL entries in RSDT/XSDT */
+
+			if (!table_address) {
+				continue;
+			}
+
 			status =
 			    osl_map_table(table_address, NULL, &mapped_table);
 			if (ACPI_FAILURE(status)) {
-- 
1.7.10

