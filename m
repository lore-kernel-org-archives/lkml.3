Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaAMQFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:05:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53830 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbaAMQFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:05:33 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 200/208] ACPI / TPM: fix memory leak when walking ACPI namespace
Date: Mon, 13 Jan 2014 16:00:41 +0000
Message-Id: <1389628849-1614-201-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiang Liu <jiang.liu@linux.intel.com>

commit df45c712d1f4ef37714245fb75de726f4ca2bf8d upstream.

In function ppi_callback(), memory allocated by acpi_get_name() will get
leaked when current device isn't the desired TPM device, so fix the
memory leak.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/char/tpm/tpm_ppi.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
index 2168d15..57a818b 100644
--- a/drivers/char/tpm/tpm_ppi.c
+++ b/drivers/char/tpm/tpm_ppi.c
@@ -27,15 +27,18 @@ static char *tpm_device_name = "TPM";
 static acpi_status ppi_callback(acpi_handle handle, u32 level, void *context,
 				void **return_value)
 {
-	acpi_status status;
+	acpi_status status = AE_OK;
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
-	status = acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
-	if (strstr(buffer.pointer, context) != NULL) {
-		*return_value = handle;
+
+	if (ACPI_SUCCESS(acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer))) {
+		if (strstr(buffer.pointer, context) != NULL) {
+			*return_value = handle;
+			status = AE_CTRL_TERMINATE;
+		}
 		kfree(buffer.pointer);
-		return AE_CTRL_TERMINATE;
 	}
-	return AE_OK;
+
+	return status;
 }
 
 static inline void ppi_assign_params(union acpi_object params[4],
-- 
1.8.3.2

