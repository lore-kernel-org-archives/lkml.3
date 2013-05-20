Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab3ETKx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:53:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56243 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab3ETKxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bob Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 069/115] ACPICA: Fix possible buffer overflow during a field unit read operation
Date: Mon, 20 May 2013 11:51:09 +0100
Message-Id: <1369047116-9378-70-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Moore <robert.moore@intel.com>

commit 61388f9e5d93053cf399a356414f31f9b4814c6d upstream.

Can only happen under these conditions: 1) The DSDT version is 1,
meaning integers are 32-bits.  2) The field is between 33 and 64
bits long.

It applies cleanly back to ACPICA 20100806+ (Linux v2.6.37+).

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/acpica/exfldio.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/exfldio.c b/drivers/acpi/acpica/exfldio.c
index 149de45..af9f1f6 100644
--- a/drivers/acpi/acpica/exfldio.c
+++ b/drivers/acpi/acpica/exfldio.c
@@ -722,7 +722,19 @@ acpi_ex_extract_from_field(union acpi_operand_object *obj_desc,
 
 	if ((obj_desc->common_field.start_field_bit_offset == 0) &&
 	    (obj_desc->common_field.bit_length == access_bit_width)) {
-		status = acpi_ex_field_datum_io(obj_desc, 0, buffer, ACPI_READ);
+		if (buffer_length >= sizeof(u64)) {
+			status =
+			    acpi_ex_field_datum_io(obj_desc, 0, buffer,
+						   ACPI_READ);
+		} else {
+			/* Use raw_datum (u64) to handle buffers < 64 bits */
+
+			status =
+			    acpi_ex_field_datum_io(obj_desc, 0, &raw_datum,
+						   ACPI_READ);
+			ACPI_MEMCPY(buffer, &raw_datum, buffer_length);
+		}
+
 		return_ACPI_STATUS(status);
 	}
 
-- 
1.8.1.2

