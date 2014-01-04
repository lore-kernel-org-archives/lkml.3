Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbaADCnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 21:43:21 -0500
Received: from mout.gmx.net ([212.227.15.15]:57402 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754526AbaADCmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 21:42:49 -0500
From: Peter Huewe <peterhuewe@gmx.de>
To: James Morris <jmorris@namei.org>
Cc: Ashley Lai <ashley@ashleylai.com>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Peter Huewe <PeterHuewe@gmx.de>,
        stable@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 02/15] tpm/tpm_ppi: Check return value of acpi_get_name
Date: Sat,  4 Jan 2014 03:44:36 +0100
Message-Id: <1388803489-13258-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1388803489-13258-1-git-send-email-peterhuewe@gmx.de>
References: <201401040335.04980.PeterHuewe@gmx.de>
 <1388803489-13258-1-git-send-email-peterhuewe@gmx.de>
X-Provags-ID: V03:K0:xll9eMn2XNHr0fRMTPDTQVqJR9LtFY6wSKPKo9iCsYxR+uHJVNS
 YPakWBXL0ZLYBU1rQreMm5QOOBRXXyx1QX9KebjmeU2WMNxfmHmuan/N8dKs3+yt+VwtnTv
 HSYogHDe6XKbTFTJEv8w9usJhjoi367kns+yTIuHJKQ5h8dmnr0kXXQtPrtSgCZZ4oktrCZ
 Q3BPAEW/smDDnav9hhFwg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <PeterHuewe@gmx.de>

If
 status = acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
fails for whatever reason and does not return AE_OK
 if (strstr(buffer.pointer, context) != NULL) {
does dereference a null pointer.

-> Check the return value and return the status to the caller

Found by coverity
Cc: stable@vger.kernel.org
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/tpm_ppi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
index 18c5810..6ac9d27 100644
--- a/drivers/char/tpm/tpm_ppi.c
+++ b/drivers/char/tpm/tpm_ppi.c
@@ -30,6 +30,9 @@ static acpi_status ppi_callback(acpi_handle handle, u32 level, void *context,
 	acpi_status status;
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	status = acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
+	if (ACPI_FAILURE(status))
+		return status;
+
 	if (strstr(buffer.pointer, context) != NULL) {
 		*return_value = handle;
 		kfree(buffer.pointer);
-- 
1.8.1.5

