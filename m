Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaAOV5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:57:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40912 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaAOV5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:57:04 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 133/166] ACPI / TPM: fix memory leak when walking ACPI namespace
Date: Wed, 15 Jan 2014 13:52:27 -0800
Message-Id: <1389822780-4729-134-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiang Liu <jiang.liu@linux.intel.com>

commit df45c712d1f4ef37714245fb75de726f4ca2bf8d upstream.

In function ppi_callback(), memory allocated by acpi_get_name() will get
leaked when current device isn't the desired TPM device, so fix the
memory leak.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/char/tpm/tpm_ppi.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
index 720ebcf..d0f1bdd 100644
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

