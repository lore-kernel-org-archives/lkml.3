Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbaFDXXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:23:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbaFDXXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Bob Moore <robert.moore@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 195/228] ACPICA: Tables: Fix invalid pointer accesses in acpi_tb_parse_root_table().
Date: Wed,  4 Jun 2014 16:23:44 -0700
Message-Id: <20140604232354.286357850@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lv Zheng <lv.zheng@intel.com>

commit d48dc067450d84324067f4472dc0b169e9af4454 upstream.

Linux XSDT validation mechanism backport has introduced a regreession:
  Commit: 671cc68dc61f029d44b43a681356078e02d8dab8
  Subject: ACPICA: Back port and refine validation of the XSDT root table.
There is a pointer still accessed after unmapping.

This patch fixes this issue.  Lv Zheng.

Fixes: 671cc68dc61f (ACPICA: Back port and refine validation of the XSDT root table.)
References: https://bugzilla.kernel.org/show_bug.cgi?id=73911
References: https://bugs.archlinux.org/task/39811
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Reported-and-tested-by: Bruce Chiarelli <mano155@gmail.com>
Reported-and-tested-by: Spyros Stathopoulos <spystath@gmail.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpica/tbutils.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/acpi/acpica/tbutils.c
+++ b/drivers/acpi/acpica/tbutils.c
@@ -461,6 +461,7 @@ acpi_status __init acpi_tb_parse_root_ta
 	u32 table_count;
 	struct acpi_table_header *table;
 	acpi_physical_address address;
+	acpi_physical_address rsdt_address;
 	u32 length;
 	u8 *table_entry;
 	acpi_status status;
@@ -488,11 +489,14 @@ acpi_status __init acpi_tb_parse_root_ta
 		 * as per the ACPI specification.
 		 */
 		address = (acpi_physical_address) rsdp->xsdt_physical_address;
+		rsdt_address =
+		    (acpi_physical_address) rsdp->rsdt_physical_address;
 		table_entry_size = ACPI_XSDT_ENTRY_SIZE;
 	} else {
 		/* Root table is an RSDT (32-bit physical addresses) */
 
 		address = (acpi_physical_address) rsdp->rsdt_physical_address;
+		rsdt_address = address;
 		table_entry_size = ACPI_RSDT_ENTRY_SIZE;
 	}
 
@@ -515,8 +519,7 @@ acpi_status __init acpi_tb_parse_root_ta
 
 			/* Fall back to the RSDT */
 
-			address =
-			    (acpi_physical_address) rsdp->rsdt_physical_address;
+			address = rsdt_address;
 			table_entry_size = ACPI_RSDT_ENTRY_SIZE;
 		}
 	}


