Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652Ab3KSIzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 03:55:42 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56113 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3KSIzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 03:55:39 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <528B2757.6010406@jp.fujitsu.com>
Date: Tue, 19 Nov 2013 17:54:47 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: lenb@kernel.org, rjw@rjwysocki.net
CC: linux-acpi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] sysfs, acpi, tables: Set file size for each ACPI table
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, each of the ACPI tables exported from
/sys/firmware/acpi/tables is of zero size:

$ LANG=C ls -ld /sys/firmware/acpi/tables/*
-r-------- 1 root root 0 Nov 19 09:48 /sys/firmware/acpi/tables/APIC
-r-------- 1 root root 0 Nov 19 09:48 /sys/firmware/acpi/tables/BOOT
-r-------- 1 root root 0 Nov 19 14:25 /sys/firmware/acpi/tables/DSDT
-r-------- 1 root root 0 Nov 19 14:25 /sys/firmware/acpi/tables/FACP
-r-------- 1 root root 0 Nov 19 14:25 /sys/firmware/acpi/tables/FACS
-r-------- 1 root root 0 Nov 19 14:25 /sys/firmware/acpi/tables/MCFG
-r-------- 1 root root 0 Nov 19 14:25 /sys/firmware/acpi/tables/SRAT
drwxr-xr-x 2 root root 0 Nov 19 09:48 /sys/firmware/acpi/tables/dynamic/

due to which, user-land tools fail reading each table. For example:

$ acpidump -f /sys/firmware/acpi/tables/SRAT
Could not get input file size: /sys/firmware/acpi/tables/SRAT

To deal with the issue, this patch assigns size of each ACPI table to
the corresponding sysfs file.

$ LANG=C ls -hld /sys/firmware/acpi/tables/*
-r-------- 1 root root  94 Nov 19 16:45 /sys/firmware/acpi/tables/APIC
-r-------- 1 root root  40 Nov 19 16:45 /sys/firmware/acpi/tables/BOOT
-r-------- 1 root root 58K Nov 19 16:55 /sys/firmware/acpi/tables/DSDT
-r-------- 1 root root 244 Nov 19 16:55 /sys/firmware/acpi/tables/FACP
-r-------- 1 root root  64 Nov 19 16:55 /sys/firmware/acpi/tables/FACS
-r-------- 1 root root  60 Nov 19 16:55 /sys/firmware/acpi/tables/MCFG
-r-------- 1 root root 168 Nov 19 16:45 /sys/firmware/acpi/tables/SRAT
drwxr-xr-x 2 root root   0 Nov 19 16:55 /sys/firmware/acpi/tables/dynamic/

Then, user-land tools work well like:

$ acpidump -f /sys/firmware/acpi/tables/SRAT
SRAT @ 0x0000000000000000
  0000: 53 52 41 54 A8 00 00 00 02 65 56 4D 57 41 52 45  SRAT.....eVMWARE
  0010: 4D 45 4D 50 4C 55 47 20 00 00 04 06 56 4D 57 20  MEMPLUG ....VMW
  0020: 01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
  0030: 01 28 00 00 00 00 00 00 00 00 00 00 00 00 00 00  .(..............
  0040: 00 00 0A 00 00 00 00 00 00 00 00 00 01 00 00 00  ................
  0050: 00 00 00 00 00 00 00 00 01 28 00 00 00 00 00 00  .........(......
  0060: 00 00 10 00 00 00 00 00 00 00 F0 BF 00 00 00 00  ................
  0070: 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
  0080: 01 28 00 00 00 00 00 00 00 00 00 00 01 00 00 00  .(..............
  0090: 00 00 00 40 00 00 00 00 00 00 00 00 01 00 00 00  ...@............
  00A0: 00 00 00 00 00 00 00 00                          ........

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---
 drivers/acpi/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
index 05306a5..095ff1f 100644
--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -309,7 +309,7 @@ static void acpi_table_attr_init(struct acpi_table_attr *table_attr,
 		sprintf(table_attr->name + ACPI_NAME_SIZE, "%d",
 			table_attr->instance);
 
-	table_attr->attr.size = 0;
+	table_attr->attr.size = table_header->length;
 	table_attr->attr.read = acpi_table_show;
 	table_attr->attr.attr.name = table_attr->name;
 	table_attr->attr.attr.mode = 0400;
-- 
1.8.3.1

-- 
Thanks.
HATAYAMA, Daisuke

