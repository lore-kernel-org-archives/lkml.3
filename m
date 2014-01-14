Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbaANAdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:33:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54566 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbaANA3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:29:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.12 66/77] ACPI / TPM: fix memory leak when walking ACPI namespace
Date: Mon, 13 Jan 2014 16:28:27 -0800
Message-Id: <20140114002754.370604080@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002752.497010554@linuxfoundation.org>
References: <20140114002752.497010554@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiang Liu <jiang.liu@linux.intel.com>

commit df45c712d1f4ef37714245fb75de726f4ca2bf8d upstream.

In function ppi_callback(), memory allocated by acpi_get_name() will get
leaked when current device isn't the desired TPM device, so fix the
memory leak.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm_ppi.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

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


