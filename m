Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab3LSMnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:43:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:46632 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab3LSMnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 07:43:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,512,1384329600"; 
   d="scan'208";a="427187816"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Peter Huewe <peterhuewe@gmx.de>,
        Rajiv Andrade <mail@srajiv.net>, Marcel Selhorst <tpmdd@selhorst.net>,
        Sirrix AG <tpmdd@sirrix.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net
Subject: [Patch v2 06/13] ACPI, TPM: fix memory leak when walking ACPI namespace
Date: Thu, 19 Dec 2013 20:38:15 +0800
Message-Id: <1387456702-4709-7-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387456702-4709-1-git-send-email-jiang.liu@linux.intel.com>
References: <1387456702-4709-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function ppi_callback(), memory allocated by acpi_get_name() will get
leaked when current device isn't the desired TPM device, so fix the
memory leak.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: <stable@vger.kernel.org> # 3.6
---
 drivers/char/tpm/tpm_ppi.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
index 8e562dc..e1f3337 100644
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
1.7.10.4

