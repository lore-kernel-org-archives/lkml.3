Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab3EQVuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:50:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54690 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757380Ab3EQVuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:50:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 04/33] ACPICA: Fix possible buffer overflow during a field unit read operation
Date: Fri, 17 May 2013 14:49:48 -0700
Message-Id: <20130517214917.350783546@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517214916.821259930@linuxfoundation.org>
References: <20130517214916.821259930@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpica/exfldio.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/acpi/acpica/exfldio.c
+++ b/drivers/acpi/acpica/exfldio.c
@@ -702,7 +702,19 @@ acpi_ex_extract_from_field(union acpi_op
 
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
 


