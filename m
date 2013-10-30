Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab3J3AhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 20:37:08 -0400
Received: from mout.gmx.net ([212.227.15.15]:51881 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab3J3AhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 20:37:05 -0400
From: Peter Huewe <peterhuewe@gmx.de>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>, Gang Wei <gang.wei@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] tpm/tpm_ppi: Check return value of acpi_get_name
Date: Wed, 30 Oct 2013 01:40:28 +0100
Message-Id: <1383093628-31580-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1383093628-31580-1-git-send-email-peterhuewe@gmx.de>
References: <1383093628-31580-1-git-send-email-peterhuewe@gmx.de>
X-Provags-ID: V03:K0:EDOBbM7im50uo9AIrIT5fAE3WggBljA5CnegVkbNf8xcIuf1sdo
 hXBZzGsR5qRRQj2q1U4aQMfd/vQCPH/RI5CWlHVqyFD4N4+ffOJLwViKNAoWIvLz/noy+TM
 wIRXjyRDM/lnCsQdrJyYgiI7buGoAdT4+jkmfoSaHOWB7ow8F9GVoH1RMir1FiiKC0xMn3i
 gmll1xZdYKtW/TFwkByhA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If
 status = acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
fails for whatever reason and does not return AE_OK
 if (strstr(buffer.pointer, context) != NULL) {
does dereference a null pointer.

-> Check the return value and return the status to the caller

Found by coverity
CID: 728462 Explicit null dereferenced
Cc: stable@vger.kernel.org
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/tpm_ppi.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
index 8b2e05a..2242917 100644
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
1.7.8.6

