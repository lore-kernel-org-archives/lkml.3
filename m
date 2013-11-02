Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab3KBRZn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 13:25:43 -0400
Received: from mout.gmx.net ([212.227.15.18]:49243 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab3KBRZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 13:25:14 -0400
From: Peter Huewe <peterhuewe@gmx.de>
To: james.l.morris@oracle.com, tpmdd-devel@lists.sourceforge.net,
        adlai@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Peter Huewe <PeterHuewe@gmx.de>,
        stable@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 2/6] tpm/tpm_ppi: Check return value of acpi_get_name
Date: Sat,  2 Nov 2013 18:24:57 +0100
Message-Id: <1383413101-10975-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1383413101-10975-1-git-send-email-peterhuewe@gmx.de>
References: <trinity-0ea948ed-45da-4711-91da-0d251d630d89-1383412993117@3capp-gmx-bs02>
 <1383413101-10975-1-git-send-email-peterhuewe@gmx.de>
X-Provags-ID: V03:K0:n1Gq99zMuIP4d+IXsUpWHTfqKN+o50zA49la+J2yZBZz5z8taLL
 xuqege8eOGRoAC7ogC27CyC4VrKgRwBWFHfQmldTMIVv7+U4qvmDXeUIjBMRtaohisiT0r6
 O3d5M1len0VRb6eJ80pyiJ1FF5GSp13bJK1ObQZlrR4EmkAvwYDWgBHSJku9y7P7sPJ3iHT
 RAuVGlwuEsgJPhtb11sbA==
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
 drivers/char/tpm/tpm_ppi.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

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
1.7.5.4

